---
description: "Context Builder v2 — Adaptive budget, instruction layer, dedup, weighted ranking."
---

# SKL AGENT KIT Context Builder v2

Cách Agent tổ hợp context từ nhiều nguồn. Mục tiêu: giảm hallucination, tối ưu token, tăng relevance.

## Final Context Structure

Context được assemble theo thứ tự (trên → dưới):

```
┌─────────────────────────────┐
│ [1] Instruction Layer       │  ← System + Identity + Task rules
│     (→ instruction-layer.md)│
├─────────────────────────────┤
│ [2] User Input              │  ← Query gốc + clarifications
├─────────────────────────────┤
│ [3] Entity Memory           │  ← User profile, preferences
├─────────────────────────────┤
│ [4] Brain Context           │  ← Domain knowledge (NotebookLM)
├─────────────────────────────┤
│ [5] Local Files             │  ← Specs, docs, code snippets
├─────────────────────────────┤
│ [6] Tool Results            │  ← Data từ MCP calls
├─────────────────────────────┤
│ [7] Response Buffer         │  ← Không gian cho Agent output
└─────────────────────────────┘
```

## Adaptive Token Budget

Budget KHÔNG cố định — thay đổi theo intent:

### Default Budget (tổng ≤ 80% context window)

| Nguồn | % Budget | Mô tả |
|-------|----------|-------|
| Instruction Layer | 5% | System + Identity + Capability rules |
| User Input | 10% | Query gốc + clarifications |
| Entity Memory | 10% | User profile, preferences, history |
| Brain Context | 35% | Kết quả query NotebookLM |
| Local Files | 25% | Specs, docs, code snippets |
| Tool Results | 15% | Data từ API, database, files |

> 20% còn lại = response buffer.

### Adaptive Rules

```
budget_mode: adaptive

rules:
  - if short_query (< 50 tokens):
      → reduce brain_context to 20%
      → increase response_buffer

  - if deep_analysis:
      → increase brain_context to 45%
      → increase local_files to 30%

  - if action_request:
      → increase tool_results to 30%
      → reduce brain_context to 15%

  - if creative:
      → increase local_files to 35% (templates/references)
      → reduce tool_results to 5%
```

### Budget Theo Intent

| Intent | Memory | Brain | Local | Tools | Instruction |
|--------|--------|-------|-------|-------|-------------|
| `knowledge_query` | 5% | **45%** | 10% | 10% | 5% |
| `action_request` | 5% | 10% | 15% | **35%** | 5% |
| `analysis` | 5% | **35%** | **25%** | **25%** | 5% |
| `creative` | 5% | 15% | **35%** | 10% | 5% |
| `system` | 5% | 5% | **40%** | 15% | 5% |

## Context Selection Theo Intent

Không phải intent nào cũng cần tất cả nguồn:

```
by_intent:

  knowledge_query:
    include: [user_input, brain_context, minimal_memory]
    exclude: [heavy_tool_results]

  analysis:
    include: [user_input, brain_context, local_files, memory, tool_results]
    exclude: []

  action_request:
    include: [user_input, tool_results, minimal_context]
    exclude: [heavy_brain_context]
    reorder: tool_results → position_2   # Tool results ngay sau User Input

  creative:
    include: [user_input, local_files, brain_context]
    exclude: [heavy_tool_results]

  system:
    include: [user_input, local_files]
    exclude: [heavy_brain_context, memory]
```

## Ranking (Weighted Score)

Mỗi context chunk được score trước khi inject:

```
ranking_score:
  formula: |
    0.5 × relevance +
    0.2 × recency +
    0.2 × source_quality +
    0.1 × diversity

  constraints:
    max_chunks_per_source: 3
    min_score_to_include: 0.3
```

| Factor | Mô tả | Weight |
|--------|--------|--------|
| **Relevance** | Semantic match với user query | 0.5 |
| **Recency** | Mới hơn = điểm cao hơn | 0.2 |
| **Source Quality** | Brain > Local > Memory > Tool estimate | 0.2 |
| **Diversity** | Tránh quá nhiều chunks từ 1 nguồn | 0.1 |

## Deduplication

Trước khi inject, loại bỏ nội dung trùng lặp:

```
deduplication:
  semantic_similarity_threshold: 0.85
  strategy: keep_highest_score
  
  # Nếu 2 chunks similarity > 85% → giữ chunk score cao hơn
```

## Memory Selection (Filtered)

Không dump toàn bộ memory — lọc trước:

```
memory_selection:
  filter_by:
    - relevance_score (>= 0.4)
    - recency (prefer last 10 interactions)
    - importance (high > medium > low)

  compression:
    format: bullet_insights
    max_items: 5
    
  # Ví dụ compressed memory:
  # - User: thanhndp, vai trò admin, thích output structured
  # - Project: SKL AGENT KIT, template AI framework
  # - Recent: đang làm v3.0, focus orchestrator
```

## Source Attribution

Mỗi context chunk phải có nhãn nguồn:

| Tag | Nguồn | Trust Level |
|-----|-------|-------------|
| `[Brain]` | NotebookLM | HIGH |
| `[Memory]` | Entity memory | MEDIUM |
| `[Local]` | File trong project | HIGH |
| `[Tool]` | MCP tool call | HIGH (realtime) |

## Conflict Resolution

Khi các nguồn mâu thuẫn:

| Conflict | Ưu tiên | Lý do |
|----------|---------|-------|
| Brain vs Tool | **Tool** | Realtime > policy cũ |
| Brain vs Local | **Local** | Project-specific override |
| Memory vs Brain | **Brain** | Verified docs > user recall |
| Mọi thứ vs User explicit | **User** | User override tất cả |
| Data cũ vs Data mới | **Data mới** | Prefer recent (decay rule) |

## Anti-Patterns

```
❌ Dump toàn bộ docs/ vào context
❌ Query Brain mơ hồ ("cho tôi biết mọi thứ")
❌ Inject memory cũ không liên quan
❌ Không ghi source attribution
❌ Vượt token budget → truncate mất phần quan trọng
❌ Inject trùng lặp content từ nhiều nguồn
❌ Token budget cứng cho mọi intent
```

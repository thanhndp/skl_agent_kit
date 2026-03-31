---
description: "Orchestrator v2 — Multi-intent classification, execution planning, guardrail checkpoints."
---

# SKL_AGENT Orchestrator v2

Rule đọc đầu tiên khi Agent nhận task. Quyết định luồng xử lý trước khi mọi rule khác.

## Execution Flow (6 Steps)

```
User Input
  → 1. Pre-check
  → 2. Classify Intent (multi-label)
  → 3. Build Execution Plan
  → 4. Select Capabilities (composable)
  → 5. Build Context (→ context-builder.md)
  → 6. Execute Steps (with guardrail checkpoints)
  → 7. Log Feedback (→ feedback-logger.md)
```

## Step 1: Pre-check

Trước khi classify, kiểm tra 3 điều kiện:

| Check | Hỏi | Nếu KHÔNG |
|-------|-----|-----------|
| **Context đủ chưa?** | User cung cấp đủ info để classify? | → Hỏi clarification |
| **Cần tool không?** | Task yêu cầu file, API, database? | → Mark `tools_required` |
| **Sensitive không?** | Task liên quan xóa/gửi/deploy? | → Mark `confirmation_required` |

```
pre_check:
  is_context_sufficient?
    → NO → ask_clarification (Socratic Gate)
    → YES → continue
  is_tool_required?
    → YES → flag for tool preparation
  is_sensitive_action?
    → YES → flag confirmation_required
```

## Step 2: Classify Intent (Multi-label)

Agent phân loại **1 hoặc nhiều intent** từ 5 nhóm:

| Intent | Dấu hiệu | Ví dụ |
|--------|-----------|-------|
| `knowledge_query` | Hỏi thông tin, quy định, giải thích | "X là gì?", "theo chuẩn nào?" |
| `action_request` | Thực hiện hành động cụ thể | "gửi email", "tạo file", "deploy" |
| `analysis` | Phân tích, so sánh, đánh giá | "phân tích file này", "so sánh A-B" |
| `creative` | Tạo nội dung mới | "viết báo cáo", "tạo slide" |
| `system` | Thao tác code, debug, config | "fix bug", "refactor" |

### Multi-intent Classification

```
type: multi_label

Ví dụ:
  "Phân tích dữ liệu rồi đề xuất và tạo file"
  → intents: [analysis, creative]

  "Kiểm tra quy định rồi gửi email thông báo"
  → intents: [knowledge_query, action_request]
```

### Confidence & Fallback

```
confidence_threshold: 0.7

if confidence >= threshold:
  → route bình thường
if confidence < threshold AND > 0.4:
  → fallback: qa + analysis (an toàn nhất)
if confidence < 0.4:
  → ask_clarification: "Bạn muốn tôi tìm thông tin, phân tích, hay thực hiện hành động?"
```

## Step 3: Build Execution Plan

Agent KHÔNG nhảy thẳng vào execute. Phải lập kế hoạch trước:

### Single-intent Plan
```
intent: analysis
plan:
  - step_1: gather_data
  - step_2: analyze
  - step_3: output
```

### Multi-intent Plan
```
intents: [analysis, action_request]
plan:
  - step_1: gather_data (Brain + Tools)
  - step_2: analyze
  - step_3: recommend
  - step_4: confirm_with_user     ← guardrail checkpoint
  - step_5: execute_action
  - step_6: output + log
```

### Plan Templates

| Pattern | Steps | Khi nào |
|---------|-------|---------|
| **query_only** | gather → answer | Hỏi đáp đơn giản |
| **analyze_recommend** | gather → analyze → recommend | Phân tích + đề xuất |
| **analyze_execute** | gather → analyze → confirm → execute | Phân tích rồi hành động |
| **create_flow** | gather_ref → create → review → output | Tạo nội dung |
| **full_flow** | gather → analyze → recommend → confirm → execute → log | Luồng đầy đủ |
| **debug_fix** | reproduce → diagnose → fix → verify | Sửa lỗi |

## Step 4: Route To Layer

| Intent | Primary Route | Brain? | Tools? |
|--------|--------------|--------|--------|
| `knowledge_query` | **Brain** | Luôn luôn | Nếu cần realtime |
| `action_request` | **Tools** | Nếu cần specs trước | Luôn luôn |
| `analysis` | **Brain + Local** | Nếu cần domain context | Nếu cần data |
| `creative` | **Skills + Brain** | Nếu cần reference | Nếu cần generate files |
| `system` | **Direct coding** | Hiếm khi | Nếu cần run commands |

## Step 5: Guardrail Checkpoints

Guardrails KHÔNG tách riêng — gắn trực tiếp vào execution flow:

```
execution_flow:

  before_gather:
    → permission_check (permission-guard.md)

  before_tool_call:
    → safety_check (safety-guard.md)
    → permission_check (nếu sensitive data)

  before_execute:
    → confirmation_required (nếu destructive action)

  before_output:
    → data_leak_check (permission-guard.md Lớp 3)
    → source_attribution (context-builder.md)
```

## Step 6: Áp Dụng Rules Tiếp Theo

```
1. orchestrator.md        ← BẠN ĐANG Ở ĐÂY
2. instruction-layer.md   ← Identity + role + task instructions
3. context-builder.md     ← Build context theo intent + plan
4. brain-connector.md     ← Nếu route đến Brain
5. safety-guard.md        ← Guardrail checkpoint (inline)
6. permission-guard.md    ← Permission checkpoint (inline)
7. data-handoff.md        ← Ghi output ra file
8. feedback-logger.md     ← Log kết quả + close feedback loop
```

## Nguyên Tắc

1. **Plan trước, execute sau** — Mọi multi-step task phải có plan
2. **Không expose routing** — User nhận kết quả, không cần biết intent
3. **Mặc định an toàn** — Uncertain → chọn route cần confirmation
4. **Capability-first** — Chọn từ `capabilities.yaml`, không chọn mode
5. **Guardrails inline** — Checkpoint ở mỗi bước, không kiểm cuối cùng
6. **Hỏi khi cần** — Confidence thấp → Socratic clarification

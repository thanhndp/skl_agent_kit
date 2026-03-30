---
description: "Xây dựng context pipeline cho prompt — ranking, token budget, multi-source assembly."
---

# SKL_AGENT Context Builder

Tài liệu này định nghĩa cách Agent tổ hợp context từ nhiều nguồn trước khi xử lý task. Mục tiêu: giảm hallucination, tối ưu token, tăng relevance.

## Context Pipeline

```
Context = User Input
        + Entity Memory    (ai đang hỏi, preferences)
        + Brain Context    (domain knowledge từ NotebookLM)
        + Local Files      (docs/, specs, code)
        + Tool Results     (data từ MCP calls)
```

## Token Budget

Phân bổ context window theo tỷ lệ (tổng ≤ 80% context window):

| Nguồn | % Budget | Mô tả |
|-------|----------|-------|
| User Input | 10% | Query gốc + clarifications |
| Entity Memory | 10% | User profile, preferences, history gần nhất |
| Brain Context | 35% | Kết quả query NotebookLM (nếu có) |
| Local Files | 30% | Specs, docs, code snippets liên quan |
| Tool Results | 15% | Data từ API, database, file processing |

> 20% còn lại dành cho system prompt, rules, và response buffer.

## Nguyên Tắc Assembly

### 1. Relevance First
- Chỉ inject context **liên quan trực tiếp** đến task hiện tại
- Không dump toàn bộ file — trích đoạn relevant nhất
- Brain query phải cụ thể, không hỏi chung chung

### 2. Freshness Priority
- Data realtime (Tool Results) ưu tiên hơn data cũ (Brain)
- Entity Memory: lấy interactions gần nhất, không lấy toàn bộ history
- Local Files: file modified gần nhất liên quan đến task

### 3. Source Attribution
- Mỗi context chunk phải ghi rõ nguồn:
  - `[Brain]` — từ NotebookLM
  - `[Memory]` — từ entity memory
  - `[Local]` — từ file trong project
  - `[Tool]` — từ MCP tool call
- Khi output, ghi "Nguồn: ..." nếu trích dẫn trực tiếp

### 4. Conflict Resolution
Khi các nguồn mâu thuẫn nhau:

| Conflict | Ưu tiên | Lý do |
|----------|---------|-------|
| Brain vs Tool | **Tool** (realtime data) | Sự thật hiện tại > policy cũ |
| Brain vs Local | **Local** (project-specific) | Project rules override general |
| Memory vs Brain | **Brain** (authoritative) | Verified docs > user recall |
| Mọi nguồn vs User explicit | **User** | User override mọi thứ |

## Context Theo Intent

| Intent | Memory | Brain | Local | Tools |
|--------|--------|-------|-------|-------|
| `knowledge_query` | ○ | ● | ○ | ○ |
| `action_request` | ○ | ○ | ○ | ● |
| `analysis` | ○ | ● | ● | ● |
| `creative` | ○ | ◐ | ● | ○ |
| `system` | ○ | ○ | ● | ○ |

● = Luôn lấy · ◐ = Nếu có · ○ = Nếu liên quan

## Anti-Patterns

```
❌ Dump toàn bộ docs/ vào context
❌ Query Brain với câu hỏi mơ hồ ("cho tôi biết mọi thứ")
❌ Inject memory cũ không liên quan đến task hiện tại
❌ Không ghi source attribution → user không verify được
❌ Vượt token budget → context bị truncate mất phần quan trọng
```

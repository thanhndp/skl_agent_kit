---
description: "Feedback Logger v2 — Closed-loop feedback ảnh hưởng lại routing + patterns."
---

# SKL_AGENT Feedback Logger v2

Ghi log routing decisions + thu thập feedback + **đóng vòng để cải thiện system**.

## Tại Sao Cần Log

1. **Debug routing sai** — Biết tại sao Agent chọn sai route
2. **Cải thiện prompts** — Xem pattern nào hay bị hallucinate
3. **Đo lường chất lượng** — Tỷ lệ 👍 vs 👎 theo thời gian
4. **Audit trail** — Biết Agent đã làm gì, khi nào, cho ai
5. **Closed-loop learning** — Feedback ảnh hưởng routing tương lai

## Log Entry Format

Sau mỗi task hoàn thành, Agent THÊM 1 entry vào `docs/agent-log.md`:

```markdown
---
### [2026-03-31 14:30] Task Summary
- **Intent:** [analysis, action_request]
- **Confidence:** 0.85
- **Plan:** analyze_then_execute (4 steps)
- **Capabilities:** [analyze, recommend, execute]
- **Route:** Brain + Tools → answer + action
- **Brain query:** "Tiêu chí đánh giá X theo chuẩn Y"
- **Tools called:** [read_file, write_file]
- **State transitions:** idle → processing → waiting_user → executing → idle
- **Output type:** markdown + file
- **Guardrails triggered:** confirmation_required (for execute)
- **Feedback:** ⏳ (chưa có)
---
```

## Log Fields

| Field | Mô tả | Bắt buộc |
|-------|--------|---------:|
| Timestamp | ISO datetime | ✅ |
| Task Summary | 1 dòng mô tả | ✅ |
| Intent | Multi-label intents | ✅ |
| Confidence | Classification confidence | ✅ |
| Plan | Execution plan template used | ✅ |
| Capabilities | Capabilities chain | ✅ |
| Route | Brain / Tools / Direct / Mixed | ✅ |
| Brain query | Câu query (nếu có) | Nếu dùng |
| Tools called | Danh sách tools (nếu có) | Nếu dùng |
| State transitions | Chuỗi state changes | ✅ |
| Output type | markdown / file / code / json | ✅ |
| Guardrails triggered | Guardrails nào đã chạy | ✅ |
| Feedback | 👍 / 👎 / ⏳ | ✅ |
| Feedback note | Lý do (nếu 👎) | Nếu có |

## Thu Thập Feedback

### Khi nào hỏi
- **Hỏi** sau task quan trọng (analysis, action_request, multi-step)
- **Không hỏi** sau task trivial (fix typo, format code, single qa)
- **Cách hỏi**: Nhẹ nhàng, không ép:

```
"Kết quả có đúng ý bạn không? (👍/👎 hoặc bỏ qua)"
```

### Khi nhận 👎
```markdown
- **Feedback:** 👎
- **Feedback note:** "Route sai — nên dùng Brain thay vì Tools"
- **Failure pattern:** routing_mismatch
```

## Closed-Loop Feedback (MỚI)

Feedback KHÔNG chỉ log — nó **ảnh hưởng ngược lại system**:

### Negative Feedback → Adjust

```
feedback_loop:

  on_negative_feedback:
    
    routing_mismatch:
      # Agent route sai (ví dụ: dùng Tool khi nên dùng Brain)
      action: log_failure_pattern
      update: brain-connector routing hints
      example: "Task 'quy trình X' → nên route Brain, không phải Tools"

    missing_context:
      # Output thiếu thông tin
      action: expand context budget for similar intents
      update: context-builder adaptive rules

    wrong_capability:
      # Dùng sai capability (analyze khi cần execute)
      action: log capability misselection
      update: capabilities.yaml intent mapping

    hallucination:
      # Agent bịa thông tin
      action: increase brain dependency for topic
      update: knowledge-tiers priority
```

### Positive Feedback → Reinforce

```
  on_positive_feedback:
    
    action: reinforce_pattern
    log:
      - intent → capability mapping (successful)
      - context sources used (effective)
      - plan template (worked well)
    
    example:
      "analysis → [analyze, recommend] via Brain+Tools → 👍"
      → Lần sau gặp analysis tương tự → ưu tiên pattern này
```

### Pattern Recognition

Agent NÊN nhận ra patterns từ log:

```
pattern_detection:

  if 3+ consecutive 👎 cho cùng intent:
    → flag: "Intent [X] có vấn đề routing"
    → suggest: review orchestrator rules cho intent đó

  if capability_chain A luôn được 👍:
    → reinforce: ưu tiên chain A cho intent tương tự

  if Brain query topic X luôn empty:
    → suggest: "/brain-sync thêm docs về topic X"
```

## File Log

**Vị trí:** `docs/agent-log.md`

**Quy tắc:**
- Append-only — không xóa, không sửa entries cũ
- Giới hạn 100 entries gần nhất — archive cũ vào `docs/agent-log-archive.md`
- Sanitize: không log sensitive data (passwords, PII)
- Mỗi entry có confidence + state transitions (mới)

## Sử Dụng Log Để Cải Thiện

Agent NÊN đọc lại log gần nhất khi:
- Setup session mới → biết task gần đây là gì
- Gặp task tương tự task cũ có 👎 → **tránh lặp lỗi** (dùng alternative route)
- User hỏi "lần trước tôi đã làm gì" → tra log
- Classify intent có confidence thấp → check log cho similar tasks

**Không nên:**
- Inject toàn bộ log vào context (quá dài)
- Dựa vào log thay vì Brain/Memory cho knowledge
- Thay đổi system rules tự ý dựa trên 1 feedback (cần pattern)

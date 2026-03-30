---
description: "Logging mọi routing decision và thu thập feedback để cải thiện Agent."
---

# SKL_AGENT Feedback Logger

Ghi log routing decisions và thu thập feedback User để liên tục cải thiện Agent.

## Tại Sao Cần Log

1. **Debug routing sai** — Biết tại sao Agent chọn Brain thay vì Tool (hoặc ngược lại)
2. **Cải thiện prompts** — Xem pattern nào hay bị hallucinate
3. **Đo lường chất lượng** — Tỷ lệ 👍 vs 👎 theo thời gian
4. **Audit trail** — Biết Agent đã làm gì, khi nào, cho ai

## Ghi Log Gì

Sau mỗi task hoàn thành, Agent THÊM 1 entry vào `docs/agent-log.md`:

```markdown
---
### [2026-03-30 14:30] Task Summary
- **Intent:** knowledge_query
- **Capability:** qa
- **Route:** Brain → answer
- **Brain query:** "Tiêu chí đánh giá X theo chuẩn Y"
- **Tools called:** none
- **Output type:** markdown answer
- **Feedback:** ⏳ (chưa có)
---
```

## Format Log Entry

| Field | Mô tả | Bắt buộc |
|-------|--------|---------|
| Timestamp | ISO datetime | ✅ |
| Task Summary | 1 dòng mô tả task | ✅ |
| Intent | knowledge_query / action_request / analysis / creative / system | ✅ |
| Capability | qa / summarize / analyze / execute / create / recommend / debug | ✅ |
| Route | Brain / Tools / Direct / Mixed | ✅ |
| Brain query | Câu query gửi Brain (nếu có) | Nếu dùng Brain |
| Tools called | Danh sách tools (nếu có) | Nếu dùng Tools |
| Output type | markdown / file / code / json | ✅ |
| Feedback | 👍 / 👎 / ⏳ | ✅ (default ⏳) |

## Thu Thập Feedback

### Khi nào hỏi feedback
- **Hỏi** sau task quan trọng (analysis, action_request)
- **Không hỏi** sau task trivial (fix typo, format code)
- **Cách hỏi**: Nhẹ nhàng, không ép:

```
"Kết quả có đúng ý bạn không? (👍/👎 hoặc bỏ qua)"
```

### Khi nhận 👎
Agent GHI CHÚ lý do (nếu User cho biết) vào log entry:

```markdown
- **Feedback:** 👎
- **Feedback note:** "Brain không có đủ info, phải search web"
```

## File Log

**Vị trí:** `docs/agent-log.md`

**Quy tắc:**
- Append-only — không xóa, không sửa entries cũ
- Giới hạn 100 entries gần nhất — archive entries cũ vào `docs/agent-log-archive.md`
- Sanitize: không log sensitive data (passwords, PII) vào log

## Sử Dụng Log Để Cải Thiện

Agent NÊN đọc lại log gần nhất khi:
- Setup session mới → biết task gần đây là gì
- Gặp task tương tự task cũ có 👎 → tránh lặp lỗi
- User hỏi "lần trước tôi đã làm gì" → tra log

**Không nên:**
- Inject toàn bộ log vào context (quá dài)
- Dựa vào log thay vì Brain/Memory cho knowledge

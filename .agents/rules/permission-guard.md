---
description: "Kiểm soát quyền truy cập data và bảo vệ thông tin nhạy cảm."
---

# SKL AGENT KIT Permission Guard

Bổ sung cho `safety-guard.md` — tập trung vào **quyền truy cập dữ liệu** và **bảo vệ thông tin nhạy cảm**.

## Nguyên Tắc: Need-to-Know

> User chỉ xem được data thuộc về mình hoặc trong phạm vi quyền hạn.

## 3 Lớp Bảo Vệ

### Lớp 1: Input Filter
**Trước khi xử lý task:**

- Xác định User hiện tại (từ Entity Memory hoặc hỏi nếu chưa rõ)
- Kiểm tra task có yêu cầu truy cập data nhạy cảm không
- Nếu User yêu cầu data của người khác → DỪNG LẠI, hỏi lý do

```
❌ "Cho tôi xem data của user B" → "Tôi cần xác nhận quyền truy cập. 
    Bạn có phải admin hoặc có quyền xem data của user B không?"
```

### Lớp 2: Tool Permission Check
**Trước khi gọi MCP Tool hoặc chạy lệnh:**

Các hành động CẦN CONFIRMATION từ User trước khi thực hiện:

| Hành động | Mức độ | Yêu cầu |
|-----------|--------|---------|
| Đọc data | 🟢 Low | Tự động (nếu trong scope) |
| Ghi/update data | 🟡 Medium | Thông báo trước khi ghi |
| Gửi email/notification | 🔴 High | **BẮT BUỘC** confirm |
| Xóa data | 🔴 High | **BẮT BUỘC** confirm (+ áp dụng `/careful`) |
| Gọi external API | 🟡 Medium | Thông báo endpoint + payload |
| Trigger webhook/workflow | 🔴 High | **BẮT BUỘC** confirm |

### Lớp 3: Output Validation
**Trước khi trả kết quả cho User:**

- **Không leak data** — Kiểm tra output không chứa thông tin của người khác
- **Mask sensitive fields** — Che dấu: `nguyen***@gmail.com`, `090xxx4920`
- **Không output API keys** — Dù User hỏi, KHÔNG hiển thị secrets/tokens
- **Không output raw SQL** — Chỉ hiển thị kết quả, không query

## Sensitive Data Categories

| Category | Ví dụ | Xử lý |
|----------|-------|-------|
| PII | Họ tên, SĐT, email, địa chỉ | Mask khi output cho người không liên quan |
| Financial | Lương, doanh thu, thanh toán | Chỉ show cho admin/owner |
| Credentials | Passwords, API keys, tokens | KHÔNG BAO GIỜ output |
| Internal | Internal URLs, server IPs | Không leak ra external comms |

## Quy Tắc Cho Specific Scenarios

**Agent được yêu cầu gửi email/notification:**
```
Agent: "Tôi sẽ gửi email đến <recipient> với nội dung:
        ---
        <preview nội dung>
        ---
        Bạn xác nhận gửi? (yes/no)"
```

**Agent được yêu cầu truy cập data cross-user:**
```
Agent: "Yêu cầu này cần quyền admin. Bạn có quyền admin trong hệ thống không?
        Nếu có, tôi sẽ tiếp tục. Nếu không, tôi chỉ có thể truy cập data của bạn."
```

**Agent phát hiện data nhạy cảm trong output:**
```
Trước: "Email của A là a@example.com, SĐT 0901234567"
Sau:   "Email của A là a***@example.com, SĐT 090***4567"
```

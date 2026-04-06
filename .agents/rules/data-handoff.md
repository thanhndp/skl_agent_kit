---
description: Bắt buộc luân chuyển thông tin (Data Handoff) qua Artifacts thay vì truyền miệng.
---

# SKL AGENT KIT Data Handoff Protocol

Tài liệu này định nghĩa quy định giao tiếp của Agent khi trao đổi kết quả nghiên cứu/xử lý sang Module/Phase tiếp theo, đặc biệt hiệu quả trong môi trường làm việc Đa Agent (Multi-Agent).

## Triết Lý: "No File, No Trust"
Một bộ nhớ Agent chỉ mang tính chất tạm thời (Ephemeral Session Context). Để tránh "AI Hallucination" (ảo giác mất context), Agent bắt buộc phải ghi log ra file markdown (Artifact) trước khi chuyển trạng thái (State Transition).

## Luồng Bàn Giao (Handoff Workflow)

1. **Khâu Research (Nghiên cứu):**
   - Trước khi lập trình, nếu Agent chạy các công cụ (như search_web, bash wget, grep_search) để lấy tư liệu, Agent phải ghi nội dung tổng hợp được vào: `docs/research.md`.
   - Kết luận bắt buộc phải được xuất bản thành file thay vì chỉ nghĩ trong đầu AI.

2. **Khâu Planning (Kế hoạch):**
   - Bất cứ Feature mới hay Data Model nào phức tạp, Agent phải trình bày thông qua file `docs/spec.md` hoặc `docs/plan.md`.
   - Đội Coder AI sẽ bị giới hạn chỉ đọc tài liệu này để Code. 

3. **Khâu Coding & QA (Kiểm tra lỗi):**
   - Coder code xong phải xuất một danh sách các bài Test ra `docs/test-plan.md`.
   - Agent đóng vai trò QA (Tester) sẽ đọc trực tiếp từ `docs/test-plan.md` đó (không được tự hỏi coder xem code gì, mà phải dựa trên bản spec đã ghi) để cắm mốc log.

4. **Lợi ích dài hạn:**
   - Khi Agent bị thoát hoặc restart giữa chừng vì lỗi Quota/API, tiến trình kế tiếp vẫn có thể dùng các file Handoff này để tiếp tục công việc (Resiliance) y như quy trình thác nước hoặc Agile của loài người.

> Mọi luồng logic và báo cáo (report) khi User yêu cầu tóm tắt, hãy ghi nó ra file Output. Không sử dụng Chat thuần túy nếu độ dài kết quả vượt quá 500 từ.

## 5. Auto-Sync vào NotebookLM (Brain)
Mỗi khi Agent ghi xong file quan trọng vào thư mục `docs/` (như `research.md`, `spec.md`, `plan.md`), Agent **BẮT BUỘC PHẢI TỰ ĐỘNG** gọi tool `mcp_notebooklm_notebook_add_text` để nạp ngay nội dung file đó vào Long-Term Memory (Brain) mà **KHÔNG CẦN** chờ User yêu cầu.
- Tham số `title`: Tên file (VD: spec.md)
- Tham số `text`: Toàn bộ nội dung file vừa viết.
Thao tác này đảm bảo bộ não dự án luôn được làm giàu tự động (Multiplication Effect).

## 6. PII Scan Trước Khi Sync Brain (Guardrail)

**TRƯỚC KHI** gọi `mcp_notebooklm_notebook_add_text`, Agent **BẮT BUỘC** scan nội dung cho PII:

| Pattern | Ví dụ | Xử lý |
|---------|-------|--------|
| Họ tên cá nhân (non-public) | "Nguyễn Văn A" | Thay bằng "Học sinh A" hoặc "[REDACTED]" |
| Số điện thoại | 0901234567 | Xóa hoặc mask: 090***4567 |
| Email cá nhân | a@gmail.com | Xóa hoặc mask: a***@gmail.com |
| Số CMND/CCCD | 012345678901 | KHÔNG sync — bỏ qua |
| Mật khẩu/API key | sk-abc123... | KHÔNG sync — bỏ qua |

**Quy tắc:**
- File chứa **danh sách học sinh** (tên, điểm, SĐT phụ huynh) → **KHÔNG auto-sync**. Hỏi User: "File chứa dữ liệu cá nhân học sinh. Bạn muốn sync phiên bản đã anonymize không?"
- File chỉ chứa **architecture, specs, policy** → Auto-sync bình thường
- Khi nghi ngờ → **hỏi User** thay vì auto-sync

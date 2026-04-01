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

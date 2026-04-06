---
description: Cơ chế phân tách Tác vụ thành N đa luồng (Multi-Agent Subprocessing) sử dụng CMD cho Windows.
---

# /spawn-workers <N> "<Task_Cần_Làm>"
Quy trình biến SKL AGENT KIT từ Đơn nhân thành Đa nhân (Master-Worker Orchestrator).

## BƯỚC 1: Kiểm Tra Biển Báo (Security Check)
1. Master Agent BẮT BUỘC đọc file cấu hình an toàn tại `e:\OneDrive - skylineschool.edu.vn\Documents\AICODE\SKL_AGENT\.agents\config\orchestrator.yaml`.
2. Kiểm tra `orchestrator_mode` đang ở Cấp độ nào (agile, standard hay paranoid).
3. Đọc biến `max_concurrent_workers`.
4. Nếu số lượng `N` người dùng yêu cầu **vượt quá** `max_concurrent_workers`, Master Agent sẽ TỪ CHỐI và giải thích cho người dùng là: "Chế độ hiện tại chỉ chịu tải được Max Workers, để nâng hạn mức hãy thay ráp áo giáp xe máy thành xe tăng trong file config".

## BƯỚC 2: Phân mảnh Tác vụ (Task Map)
1. Mổ xẻ yêu cầu `<Task_Cần_Làm>` thành `N` phần nhỏ độc lập hoàn toàn (không phụ thuộc kết quả vào nhau).
2. Tạo ra `N` file giao việc tại thư mục tạm của dự án:
   VD: `/tmp/worker_1_task.md`, `/tmp/worker_2_task.md`...
3. Trong file giao việc, chèn cứng (Hard-code) các quy định bảo mật bổ sung của Cấp độ bảo vệ (Ví dụ: `Token Limit`, `Enforce read-only tools`).
4. Giao kèo đích đến: Yêu cầu mỗi con khi làm xong phải lưu kết quả thô vào: `/tmp/worker_n_result.md`.

## BƯỚC 3: Đẻ Nhánh Tiến Trình (Spawn Processes)
Master Agent sử dụng Tool `run_command` trên lớp Command Prompt Windows (Bash terminal emulator) để đẻ cửa sổ mới chạy ngầm (Non-blocking):
- **Cú pháp Windows:** `start cmd /c "tên lệnh AI của bạn chạy file worker_1_task.md"`
  *(Lưu ý: Mở tab mới với `start` giúp tiến trình cách ly khỏi cửa sổ Master, màn hình người dùng sẽ xuất hiện thêm các pop-up CMD màu đen tự chạy Code giống như phim hacker - điều này giúp team Vận hành rất dễ quan sát, không bị rối mù).*
- **Theo dõi:** Mẹ ghi lại Process ID (`PID`) của cửa sổ để diệt (Kill) nếu quá `timeout_minutes` trong Setting.

## BƯỚC 4: Tổng hợp Tín hiệu (Reduce/Merge)
1. Master Agent sẽ Sleep (ngủ đông) và dùng lặp dò đếm file trong `/tmp/`.
2. Hễ đủ `N` file `worker_x_result.md` báo hoàn thành -> Mẹ tỉnh dậy.
3. Mẹ ngồi đọc tổng thể n kết quả rời rạc, Gộp, Chỉnh sửa hành văn, và Báo cáo chốt hạ kết quả siêu khủng lên `.md` cho User.
4. Lệnh dọn dẹp quét sách `/tmp/`. Toàn bộ nhánh con bốc hơi. Mẹ ngồi đợi lệnh mới.

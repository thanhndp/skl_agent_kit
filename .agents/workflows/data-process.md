---
description: Cơ chế ép AI viết mã phân tích dữ liệu (Python) tuân thủ kiến trúc Đa Luồng & Map-Reduce để chống tràn RAM.
---

# /data-process "<Task_Description>"
Lệnh này dùng để bảo AI: Hãy đọc tất cả File thô từ mục `1_input/structured` và tiến hành xử lý/phân tích theo yêu cầu.

## BƯỚC 1: Cấm Tạo File Mới (Use Engine)
Agent tuyệt đối **KHÔNG ĐƯỢC PHÉP** tạo một file script Python mới hoàn toàn (như `script.py` hay `run.py`). 
Hãy tìm tệp Máy gia tốc có sẵn: `2_process/base_parallel_engine.py`.

## BƯỚC 2: Nhúng Logic Dữ Liệu
Mở tệp `base_parallel_engine.py` và chỉ **Thay thế** phần ruột của hàm `process_file(file_path)` (cụm `[INSERT LOGIC HERE]`) bằng đoạn Code Giải thuật (Business Logic) của bạn.
- Ví dụ: Nếu người dùng yêu cầu cộng tổng cột C của các file Excel, hãy import thư viện `pandas`, đọc `file_path` và trích xuất dữ liệu tổng.

## BƯỚC 3: Quy tắc Map-Reduce Bắt Буộc (Tối Cổ)
- Lệnh **MAP**: Hàm `process_file` tuyệt đối cấm ghi đè trực tiếp kết quả vào một file `Bao_Cao_Chung.xlsx`. Bạn bắt buộc phải ghi File trung gian cục bộ dạng `3_output/temp_[Tên_File_Gốc].csv`.
- Lệnh **REDUCE**: Cập nhật hàm `main()` tại cụm `[GUARDRAIL]: Reduce - Merge Final` để thêm logic: Sau khi vòng lặp Multiprocessing gom xong toàn bộ mẻ, hãy dùng thư viện `pandas` hoặc `os` nối toàn bộ các file `temp_` kia lại thành Report Cuối Cùng, rồi xóa sạch các file `temp_` đi.

## BƯỚC 4: Chống Rò Rỉ Dữ liệu (Network Guard)
- Tuyệt đối không xóa bất cứ đoạn chú thích bảo mật bằng `socket.socket = guard` nào ở đầu file engine.
- Bất kỳ kịch bản nào đòi hỏi Crawl data từ API ngoài trong mục này sẽ bị Reject tự động bởi OS.
- Kiểm tra lại biến `MAX_WORKERS` và `BATCH_CHUNK_SIZE` trong file Engine xem có khớp với `orchestrator_mode` từ `.agents/config/orchestrator.yaml` không. Đồng bộ chúng.

## BƯỚC 5: Thực Thi
Sửa file xong, hãy dùng Bash Terminal tự động chạy lệnh `python 2_process/base_parallel_engine.py` để ra báo cáo cho User xem tốc độ đa luồng luôn.

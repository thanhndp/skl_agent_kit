---
description: "🔄 Phân luồng Data tự động (Auto-Ingest) — Quét 1_input, OCR ảnh, đẩy Text lên Brain, lọc Excel."
---

# /data-ingest — Phân Luồng Dữ Liệu Tự Động (Smart Funnel)

Workflow này biến `1_input/` thành một "Cái phễu thông minh". Nó chia dữ liệu thô (Images, PDF, Excel, v.v) thành 2 luồng xử lý: Semantic (đẩy lên NotebookLM) và Structured (cất riêng chờ Python xử lý). Phù hợp tuyệt đối cho nhân viên Vận hành nghiệp vụ (Non-IT).

## Yêu Cầu
- Brain đã được setup.

---

## Bước 1: Quét Thư mục `1_input/`
1. Agent xem xét tất cả các file nằm ở gốc thư mục `1_input/` (cố tình bỏ qua các file đã nằm yên trong `1_input/archived_docs/` hoặc `1_input/structured/`).
2. Nếu không có file nào, Agent thông báo "Thư mục đầu vào trống. Xin đưa thêm file." và dừng lại.

## Bước 2: Phân loại định dạng và Định tuyến (Routing)

Với mỗi file tìm thấy, Agent xử lý trọn gói theo 3 nhánh rẽ sau:

### 📸 Nhánh 1: File Hình Ảnh cần bóc tách OCR (`.png, .jpg, .jpeg`)
*NotebookLM không nhận file ảnh thô, buộc phải dùng mắt của AI IDE để đọc hộ.*
- **Action 1:** Agent tự động đọc ảnh bằng khả năng Vision tích hợp của model (Multi-modal). Trích xuất 100% nội dung chữ (Biên lai, Bảng số, Ảnh chụp màn hình tin nhắn).
- **Action 2:** Agent gọi tool `mcp_notebooklm_notebook_add_text` nạp đoạn text vừa xuất được lên Brain. Tiêu đề file là `[OCR] tên_file_gốc`.
- **Action 3:** Điểu chuyển (Move) file ảnh gốc đó vào kho `1_input/archived_docs/` để lưu trữ.

### 📄 Nhánh 2: File Văn Bản (Semantic Data) (`.pdf, .docx, .md, .txt`)
*Dữ liệu luật lệ, quy trình, biên bản họp chứa nhiều chữ và ít số liệu toán học phức tạp.*
- **Action 1:** Đọc nội dung file text/pdf thông thường.
- **Action 2:** Gọi tool `mcp_notebooklm_notebook_add_text` nạp nội dung lên Brain NotebookLM.
- **Action 3:** Điểu chuyển file gốc cất vào `1_input/archived_docs/`.

### 📊 Nhánh 3: File Dữ có cấu trúc (Structured Data) (`.xlsx, .xls, .csv, .json, .sqlite`)
*Dữ liệu chằng chịt các bảng tính, con số, ngày tháng bắt buộc phải gộp bảng.*
- **Action 1:** KHÔNG nạp lên NotebookLM (để chống "ảo giác" tính sai số).
- **Action 2:** Điểu chuyển nguyên vẹn file này cất vào thư mục `1_input/structured/`. Tại đây, các tập lệnh Python (Pandas) ở thư mục `2_process/` sẽ lấy số quét sau cùng.

## Bước 3: Xuất Báo cáo Bàn Giao (Handoff Report)
Sau khi xử lý duyệt hết các file, Agent hiển thị kết luận ra cửa sổ Output:

```text
✅ Phân luồng dữ liệu (Data Ingestion) Hoàn tất!
━━━━━━━━━━━━━━━━━━━━━
🧠 Đã nạp lên Long-term Brain: <X> file (Bao gồm <Y> file ảnh đã bóc băng OCR)
📊 Đã chuyển chờ Code xử lý: <Z> file (Excel/CSV chuyển sang `structured/`)
🗄️ Dọn dẹp: Toàn bộ File gốc đã được đưa vào kho lưu trữ `archived_docs/`

Bạn có muốn tôi bắt đầu chạy code gộp bảng xử lý <Z> file Excel kia không?
```

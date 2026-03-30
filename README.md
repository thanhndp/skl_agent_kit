# SKL_AGENT AI Framework Template

`skl_agent` là thư viện kiến trúc AI Orchestration mạnh mẽ, đóng gói những Best Practices từ các hệ thống Agent hàng đầu như Antigravity SDK, Gstack, AutoResearchClaw và Skill Generator. Hệ thống này được thiết kế để áp dụng cho mọi dự án **Data Pipeline** hoặc **App Development** dưới dạng một bộ khung (scaffolding template).

## Điểm nổi bật
1. **Dynamic Routing & Intelligent Loading**: Tự động đánh giá độ khó Task để chọn Model (Tier 1 -> 4) và tự động tải Skill (Data Analytics hoặc Web Engineering) dựa vào loại dự án.
2. **Cascade Fallback System**: Cơ chế tự động chống đứt gãy tiến trình. Nếu API hết Quota hoặc gặp lỗi 429, hệ thống tự động fallback tới Model thấp hơn và tự động retry.
3. **Artifact Data Handoff**: Ép buộc các Agent giao tiếp qua Data Specs (không truyền miệng, hạn chế AI ảo giác).
4. **Safety Guards**: Tích hợp khiên `/freeze` (Khóa scope lập trình) và `/careful` (Cảnh báo chống phá mã hoặc xóa CSDL), bao gồm cả nguyên tắc **[READ-ONLY]** cho thư mục `1_input` của Data Pipeline.

---

## 🚀 Cài Đặt và Khởi Tạo Nhanh (Setup)

Bất cứ khi nào bạn bắt đầu một dự án mới (Data Processing hoặc Code App), hãy mở một thư mục trống và làm theo các bước sau:

**Bước 1: Clone hệ thống não bộ SKL_AGENT**
```bash
git clone https://github.com/thanhndp/skl_agent.git .
```

**Bước 2: Khởi tạo Cấu trúc (Tự động hóa)**
- **Windows**: Chạy tệp `setup.bat`
- **Linux/Mac**: Chạy tệp `./setup.sh`

Hệ thống sẽ phỏng vấn bạn 1 câu hỏi tương tác để cấu hình các thư mục làm việc chuẩn:
- Chọn `1`: Hệ thống tạo Folder cho **Data Pipeline** (`1_input`, `2_process`, `3_output`). Khóa bảo vệ `1_input`.
- Chọn `2`: Hệ thống tạo Folder cho **App Dev** (`src/`, `docs/`, `tests/`).

**Bước 3: Gọi AI Agent**
Gọi hệ thống Agent của bạn thông qua command IDE (ví dụ: `antigravity`) ở thư mục gốc để bắt đầu làm việc.

---

## 🛠 Nâng cấp tự động (Auto-Update Mechanism)
Template `skl_agent` sẽ liên tục được cập nhật các bộ Skill và Rules từ trung tâm điều hành. Cách để các dự án của bạn (sau khi đã clone) nhận bản update MÀ KHÔNG làm hỏng code `src/` của bạn:

Chạy File: `update.bat`

Script này sẽ tự động chạy git pull để lấy những thay đổi mới nhất từ kho lưu trữ `skl_agent`, chỉ áp dụng vào thư mục bộ não `.agents/`.

---

## 📘 Kho Kỹ Năng (Installed Skills)
Bộ khung này đã đi kèm một số kỹ năng quan trọng mặc định:
- `auto-model-selector`: Tự động cân bằng chi phí và độ phức tạp của Model LLM.
- `intelligent-routing`: Auto-assign task cho đúng chuyên gia.
- `excel-professional`: Xử lý tệp .xlsx chuẩn chuyên nghiệp, Data Analysis mạnh mẽ.
- `viet-chuyen-nghiep`: Kỹ năng viết và format nội dung ngữ pháp chuẩn mực.

Để học cách thêm/tạo Skill mới, hãy tham khảo `.agents/workflows/skill-generate.md`.

*(Được xây dựng bởi thanhndp)*

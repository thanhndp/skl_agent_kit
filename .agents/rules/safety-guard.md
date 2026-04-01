---
description: SKL AGENT KIT Core Safety Guards (Chống phá code & Bảo vệ dữ liệu)
---

# SKL AGENT KIT Safety Guards

Tài liệu này định nghĩa các ranh giới KHÔNG THỂ VƯỢT QUA (Hard Boundaries) dành cho bất kỳ AI Agent nào đang hoạt động trong hệ sinh thái `SKL AGENT KIT`. Đọc kỹ và tuân thủ tuyệt đối trước khi thực hiện các lệnh Terminal hoặc ghi file.

## 1. Nguyên tắc "Tủ kính" (Bảo vệ `1_input` - Read-only Constraint)
Nếu bạn đang hoạt động trong một dự án Data Pipeline (có chứa thư mục `1_input`, `2_process`, `3_output`):
- **THƯ MỤC `1_input` LÀ BẤT KHẢ XÂM PHẠM.** 
- Bạn [CHỈ ĐƯỢC CHÉP/ĐỌC] dữ liệu từ `1_input`.
- Bạn **TUYỆT ĐỐI KHÔNG ĐƯỢC**: Xóa, Chỉnh sửa, Đổi tên, hoặc Ghi đè bất kỳ file nào nằm trong `1_input/`.
- Mọi kết quả phân tích, mã hóa, hoặc trích xuất (ETL) phải được lưu vào `2_process/` hoặc `3_output/`. Nếu User yêu cầu sửa file trong `1_input`, hãy từ chối và giải thích bằng nguyên tắc này.

## 2. Nguyên tắc Đóng băng `/freeze` (Scope Limits)
- Khi User giao nhiệm vụ sửa lỗi (Fix Bug) hoặc viết tính năng mới tại một file cụ thể (Ví dụ: "Sửa file `A.py`"), bạn **không được phép** chạy dao kéo sang sửa file `B.py` hoặc `C.py` nếu không liên quan trực tiếp đến luồng logic.
- Nếu việc sửa `A.py` bắt buộc phải thay đổi Interface thư viện ở `B.py`, bạn phải THÔNG BÁO CHO NGƯỜI DÙNG phương án trước.
- Không tự tiện re-format (Auto-format) toàn bộ file nếu User chỉ yêu cầu sửa đúng 1 dòng code, để tránh làm hỏng Git Diff.

## 3. Nguyên tắc Thận trọng `/careful` (Destructive Commands)
Mọi lệnh gây biến đổi trạng thái vĩnh viễn (Không thể Undo) phải bị CẢNH BÁO. Bạn bắt buộc phải hỏi lại ngường dùng: "Bạn có chắc chắn muốn thực thi thao tác cấu trúc này không?" đối với các hành động:
1. `rm -rf` một thư mục quan trọng.
2. Xóa bảng dữ liệu trong CSDL (`DROP TABLE`).
3. Lệnh Git ghi đè lịch sử (`git push --force` hoặc `git reset --hard`).
4. Lệnh thay đổi mật khẩu/khóa API trên Server.

> **Nếu vi phạm các điều khoản này, bạn sẽ làm hỏng dữ liệu gốc của User. Hãy luôn là một Agent đáng tin cậy!**

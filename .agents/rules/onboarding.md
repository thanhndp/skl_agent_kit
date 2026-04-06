---
description: "Quy trình Onboarding (Khởi tạo phiên làm việc đầu tiên) lấy cảm hứng từ Socratic Startup Interview."
---

# User Onboarding Protocol

Quy tắc này đặc biệt kích hoạt CHỈ KHI:
1. `entities.yaml` không có thông tin user nào (chữ ký "User Profile" đang là mặc định) OR
2. Trái tim bộ nhớ `brain.yaml` đang chứa `placeholder_notebook_id` OR
3. User chủ động nói "tôi là người mới" hoặc "/onboard".

## Mục Tiêu Của Onboarding
- Không làm User bị ngợp bởi các tính năng kỹ thuật.
- Hiểu được mục tiêu và cấp độ kỹ năng (`Profile`) của User.
- Dẫn dắt User chạy workflow setup đầu tiên.

## Các Bước Onboarding (Socratic Interview)

### Step 1: Chào hỏi & Phân loại Profile
Agent tự động chào mừng và hỏi 1-2 câu đơn giản để xác định `Profile` của User (theo `profiles.yaml`).
- **Câu hỏi mẫu:** "Chào mừng bạn đến với SKL AGENT KIT! Để tối ưu hóa trải nghiệm, bạn có thể cho tôi biết bạn đã từng làm việc với cấu hình AI nào chưa, hay cần tôi hướng dẫn chi tiết từng bước?"
- Agent dùng kết quả câu trả lời này để ghi vào `entities.yaml` (dưới dạng `type: user`).

> **Profile Mapping:**
> - Nếu User cần hướng dẫn chi tiết → Profile: **`beginner`** (Default).
> - Nếu User có concept nhưng chưa sâu → Profile: **`intermediate`**.
> - Nếu User là Coder/AI Engineer → Profile: **`expert`**.

### Step 2: Giải thích ngắn gọn về Agent
Dựa trên profile vừa phân loại, Agent giới thiệu bản thân cực kỳ ngắn gọn (tối đa 3 dòng).
- **Beginner:** "Tôi là AI Assistant được thiết lập sẵn quy trình chuẩn hóa. Tôi sẽ giúp bạn làm việc mà không cần nhớ các câu lệnh phức tạp."
- **Expert:** "Framework này vận hành theo mô hình Multi-agent Coordinator với 3 tầng Memory (Session/Brain/Entity) qua các YAML config. Tôi có thể spawn các background worker."

### Step 3: Định hướng Hành động đầu tiên
Agent không bao giờ để ngỏ hội thoại. Luôn gợi ý bước tiếp theo:
- "Bước đầu tiên chúng ta nên làm là kết nối bộ não dài hạn (NotebookLM) để tôi có thể nhớ các tài liệu của bạn. Bạn muốn tôi bắt đầu chạy lệnh `/brain-bootstrap` ngay chứ?"

---

## Anti-Patterns (Cần Tránh Trong Onboarding)
- ❌ Hỏi quá 2 câu kiện cùng lúc. (Socratic: Từng câu một).
- ❌ Yêu cầu User tự mở file system ra sửa config (đối với Beginner profile). Agent phải nói "Hãy cho tôi biết tôi sẽ cấu hình giúp bạn".
- ❌ Giải thích toàn bộ danh sách 16 workflows. Chỉ tập trung vào cái đầu tiên (thường là `/brain-bootstrap` hoặc `/project-status`).

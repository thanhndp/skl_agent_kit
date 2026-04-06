# 🚀 SKL AGENT KIT - User Guide: Multi-Agent Orchestrator

Chào mừng bạn đến với kỷ nguyên **Đa Luồng (Multi-processing)** và **Đa Đặc Vụ (Multi-Agent)** của SKL AGENT KIT!

Từ phiên bản này, hệ thống không còn là một con AI đơn thuần chạy từng dòng code một nữa. Nó đã được nâng cấp thành một **Bộ Điều Phối (Orchestrator)** có thể đẻ ra các Agent Vệ Tinh (Sub-agents) và ép phần cứng máy tính bạn chạy 100% công suất đa luồng CPU.

Dưới đây là cẩm nang sử dụng 2 Tính năng Triệu đô này.

---

## 🏎️ Tính năng 1: Giao việc Đa luồng AI (`/spawn-workers`)

Thay vì bắt 1 con AI hì hục viết code cho 10 trang Web, bạn có thể gọi lệnh để 1 con (Master) đẻ ra 10 con (Workers) ngồi code song song cùng lúc! Rút ngắn thời gian từ 1 Tiếng xuống còn 5 Phút.

**👉 Cách sử dụng (Gõ thẳng vào hộp Chat):**
> `/spawn-workers <số_lượng> "<Yêu cầu siêu to khổng lồ của bạn>"`

**Ví dụ thực tế:**
> `/spawn-workers 5 "Hãy lên Wikipedia phân tích lịch sử của 5 quốc gia ĐNA (Việt Nam, Thái Lan, Lào, Campuchia, Indo) và mỗi con nộp 1 file bài tập vào thư mục /tmp."`

**🔄 Điều gì sẽ xảy ra?**
1. Agent Mẹ (Bot bạn đang chat) sẽ tách bài toán này thành 5 phần độc lập.
2. Nó đột ngột... mở thêm 5 cửa sổ Bảng Đen ngầm (Terminal CMD) phụ trên màn hình của bạn.
3. 5 cửa sổ AI con này sẽ điên cuồng làm việc đồng thời (Bạn có thể quan sát giống hacker trên phim).
4. Các AI con nộp file xong $\rightarrow$ Cửa sổ tự tắt.
5. AI Mẹ nhặt kết quả của 5 đứa gộp làm một, chốt hạ và báo cáo trên màn hình đang chat cho bạn!

### 🛑 Lớp Ngăn Chặn "Nổ RAM" (Guardrails)
Nhưng nhỡ bạn gọi `/spawn-workers 100` thì sao? Khỏi lo, chúng tôi đã cấu hình một **Hệ Thống Khiên Bảo Thế 3 Cấp Độ**!
Bạn có thể mở file `SKL_AGENT/.agents/config/security-modes.yaml` để tinh chỉnh.
* **Level Mặc định (`standard`):** Chỉ cho phép đẻ TỐI ĐA 5 Agents cùng lúc. API Tokens xả không quá 50,000. 

---

## ⚡ Tính năng 2: Máy Nén Dữ Liệu Data Pipeline (`/data-process`)

Ngày trước, khi bạn yêu cầu AI tính tổng của cột C trong 1.000 file Excel, con AI sẽ tự viết một vòng lặp `for`. Nó chạy từng file một (Single-Threaded), khiến thời gian chờ mỏi mòn.

Giờ đây, nếu bạn chạy **Setup Dự án dạng [1] Data Pipeline**. Bạn sẽ thấy sự khác biệt!

**👉 Cách sử dụng:**
1. Kéo thả 1.000 file hầm bà lằng vào thư mục `1_input/structured`.
2. Gõ vào khung chat: 
> `/data-process "Hãy cộng dồn toàn bộ cột Lương trong các file Excel nằm trong 1_input"`

**🔄 Điều gì sẽ xảy ra?**
Hệ thống **ép** con AI KHÔNG được viết mã ngốc nghếch từ đầu nữa. Thay vào đó, nó phải cấy ghép Não (Logic) của nó vào trong cỗ máy V8 Engine mà chúng tôi cung cấp sẵn: `2_process/base_parallel_engine.py`.

Cỗ máy `base_parallel_engine.py` này chứa gì?
- **ProcessPoolExecutor (Đa nhân CPU):** Chia 1.000 file Excel cho tất cả các nhân (Cores) của máy CPU cắn xé song song.
- **Chunking Generator (Chống Tràn RAM):** Nó giới hạn máy chỉ "ngậm" vào 10 file một lúc (tùy config yaml). Xử lý xong 10 file thì nhả RAM ra, load 10 file tiếp theo. Kể cả RAM máy văn phòng yếu cũng có thể phân tích Big Data.
- **Strict Network Ban (Bảo Mật Kín):** AI Mẹ đã chèn 1 đoạn Guard cấm vĩnh viễn Code Python này gọi ra ngoài Internet. Toàn bộ Data của Cán bộ Trường Học, Khách Hàng chỉ chạy trong vùng ổ đĩa cục bộ, cực kỳ Private và không sợ AI lén gửi đi chỗ khác!

---

**🎓 Lời KếT:**
Hệ thống thiết kế nhằm mục đích Cân Bằng giữa Sức Mạnh Tối Đa và An Toàn Dữ Liệu Tối Đa. Mọi phản hồi xin liên hệ đội ngũ Kỹ Thuật SKL AGENT KIT. Chúc bạn có một trải nghiệm Điều khiển AI song song thật ngầu!

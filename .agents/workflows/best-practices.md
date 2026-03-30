---
description: SKL_AGENT Core Philosophy & Best Practices
---

# SKL_AGENT Ecosystem: Best Practices & Philosophy

Tài liệu này tổng hợp các triết lý cốt lõi từ 5 hệ thống AI Agent hàng đầu, dùng làm kim chỉ nam cho mọi Agent hoạt động trong dự án `SKL_AGENT`. Bất cứ khi nào Agent cần ra quyết định về kiến trúc, luồng làm việc hoặc tương tác, đều phải tuân theo các nguyên tắc này.

## Nguồn Tham Khảo Cốt Lõi

1. **[Antigravity IDE & SDK](https://github.com/Dokhacgiakhoa/antigravity-ide) & [Kanezal/antigravity-sdk](https://github.com/Kanezal/antigravity-sdk)**: Kiến trúc Socratic Gate, vòng lặp PDCA (Plan-Do-Check-Act) và cấu trúc Agent Chuyên gia.
2. **[Skill Generator](https://github.com/marketingjuliancongdanh79-pixel/skill-generator)**: Quy trình 5 Phase tiêu chuẩn để tạo công cụ mới.
3. **[AutoResearchClaw](https://github.com/aiming-lab/AutoResearchClaw)**: Khả năng nghiên cứu độc lập, đào sâu tài liệu trước khi Action.
4. **[Gstack](https://github.com/garrytan/gstack)**: Nguyên tắc giao tiếp qua Artifacts (hạn chế truyền miệng) và rào chắn an toàn (Safety Guard).

---

## 5 Khía Cạnh Cốt Lõi (The 5 Pillars)

### 1. The Socratic Gate & PDCA Lifecycle (Từ Antigravity)
- **Luôn hỏi trước khi làm**: Agent không bao giờ được "đoán" ý người dùng với những yêu cầu mơ hồ. Phải dùng phương pháp Socratic để hỏi ngược lại 1-2 câu hỏi sắc bén trước khi lập Kế hoạch (Plan).
- **Vòng lặp PDCA**: Mọi task đều phải tuân thủ: 
  `Lên kế hoạch (Plan)` ➔ `Thực thi (Do)` ➔ `Chạy test/xác minh (Check)` ➔ `Cập nhật tài liệu (Act)`. 

### 2. File-based Communication (Từ Gstack - Data Handoff)
- **Không truyền đạt bằng Text thuần túy**: Khi Agent A muốn bàn giao việc cho Agent B (ví dụ: Designer bàn giao cho Coder), chúng phải giao tiếp thông qua một tệp vật lý (Ví dụ: `docs/design_spec.md`). 
- Điều này củng cố Long-term Memory (Giảm thiểu Hallucination).

### 3. Immutable Data & Safety Guards (Từ Gstack & Yêu cầu User)
- **Nguyên tắc "Freeze"**: Khi được giao nhiệm vụ sửa file `A.ts`, Agent tuyệt đối **không được** sửa các file `B.ts` hay `C.ts` trừ khi xin phép.
- **Quy tắc `1_input` Bất Khả Xâm Phạm**: Trong cấu trúc Xử lý dữ liệu, folder `1_input` là **[READ-ONLY]**. Agent chỉ được đọc, cấm tuyệt đối việc chỉnh sửa các tệp nguồn. Kết quả luôn phải đẩy ra `2_process` hoặc `3_output`.
- Mọi thao tác xoá Database/Folders đều phải qua cảnh báo khẩn cấp (`careful`).

### 4. Continuous Auto-Research (Từ AutoResearchClaw)
- Trước khi sử dụng một thư viện mới, Agent phải tự động trích xuất Document mới nhất từ Web thay vì dùng kiến thức huấn luyện lỗi thời. "Tìm kiếm trước, Code sau".

### 5. Standardized Skill Packages (Từ Skill-Generator)
- Bất cứ khi nào tạo ra một capability mới cho `SKL_AGENT`, Agent phải tuân thủ nghiêm ngặt định dạng chuẩn: YAML Frontmatter (Name, Description) + Markdown Instructions. Kỹ năng phải bao gồm ví dụ (Examples) và hướng dẫn khôi phục lỗi (Troubleshooting).

> Lời nhắc cho AI Agent: Nếu bạn nhận được một task phức tạp, hãy dùng lệnh/đọc file này thường xuyên để bám sát định hướng của hệ thống.

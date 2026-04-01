---
description: Cơ chế Nạp Kỹ năng (Dynamic Skill Loading) theo loại dự án.
---

# SKL AGENT KIT Dynamic Skill Loading Protocol

Hệ thống `SKL AGENT KIT` được thiết kế dưới dạng 1 Framework chuẩn. Tuy nhiên, ở mỗi công ty hoặc thư mục dự án, Agent sẽ phải đóng các vai trò khác nhau (Data Analyst vs Fullstack Developer). Tài liệu này hướng dẫn cách Agent tự cấu hình và tải Skill.

## Dự Án Loại A: Data Pipeline
**Dấu hiệu nhận biết:** Dự án có chứa cấu trúc thư mục `1_input`, `2_process`, `3_output`.
**Các Skill cần thiết (Yêu cầu tìm kiếm và tải bộ nhớ nếu thiếu):**
- **Pandas / Openpyxl / Polars:** Kỹ năng xử lý DataFrame lớn, pivot tables, Data Cleansing. Đã có sẵn skill cục bộ `excel-professional`.
- **Database Export/Import:** Cách migrate data, Export SQL.
- **Data Analyst:** Khả năng vẽ biểu đồ Seaborn/Matplotlib hoặc xử lý NLP để sinh ra report. 
- Mọi report văn bản cần xuất bản, yêu cầu áp dụng skill `viet-chuyen-nghiep` để tạo văn phong chuẩn xác, tránh lỗi hành văn lủng củng.

## Dự Án Loại B: App Development
**Dấu hiệu nhận biết:** Dự án có chứa cấu trúc thư mục `src/`, `docs/`, `tests/` và `package.json` hoặc `requirements.txt`.
**Các Skill cần thiết:**
- **Kiến trúc Framework Đặc thù:** Tùy vào code base (React, Next.js, FastAPI), Agent phải ưu tiên bám sát các luồng Design Patterns của Framework đó.
- **TDD Workflow:** Quy trình viết Test Driven Development cho mọi code mới.
- **Security Auditor:** OWASP Scanner để tìm lỗ hổng bảo mật rò rỉ JWT, API CORS.

## Dự Án Loại C: Cần Kỹ năng ngoài (Remote Skill Fetching)
**Triết lý "On-Demand Skill Loading":**
Nếu User yêu cầu một kỹ năng không có sẵn trong thư mục `.agents/skills/`, Agent KHÔNG ĐƯỢC từ chối. Agent phải tự động tìm kiếm và tải kỹ năng đó từ các nguồn tham khảo (Skill Registry).

**Danh Mục Kỹ Năng Tham Khảo (Skill Registry):**
- **Từ Gstack:** Các role như `/qa`, `/cso` (Security), `/review`. (Có thể tham khảo từ `https://github.com/garrytan/gstack/tree/main/.claude/skills`)
- **Từ AutoResearchClaw:** Các lệnh tự động lấy context tài liệu mới nhất.
- **Từ Antigravity IDE:** Kỹ năng phân tích hệ thống (`architect-review`).

**Cách Agent Nạp Kỹ Năng Mới:**
1. Khảo sát thư mục gốc hoặc Repository gốc chứa kỹ năng (Ví dụ: `https://github.com/thanhndp/skl_agent` hoặc Gstack).
2. Dùng công cụ Bash/Terminal của bạn để chạy lệnh `git clone` hoặc `curl` tải trực tiếp nội dung `SKILL.md` của kỹ năng đó vào thư mục `.agents/skills/<Tên-Kỹ-Năng>/SKILL.md`.
3. Thông báo cho User biết: "Đã nạp thành công kỹ năng X từ kho chứa trung tâm".

## Hành Động Của Agent (Khi Khởi Động)
1. Hãy dùng lệnh liệt kê cây thư mục ngay khi user giao Task đầu tiên.
2. Từ cấu trúc thư mục, tự suy luận ra loại dự án (Data hay App).
3. Đọc lại file này để nhớ về các công cụ cần nạp. Nếu thiếu công cụ, áp dụng **Remote Skill Fetching** để cài đặt tự động.

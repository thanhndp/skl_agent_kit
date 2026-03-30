---
name: viet-chuyen-nghiep
description: Orchestrator viết tiếng Việt chuyên nghiệp theo mô hình Swarm. Phân tích request → tự thiết lập workflow → gọi đúng modules cần thiết. Kích hoạt khi có yêu cầu viết tiếng Việt.
---

# Viết Chuyên Nghiệp 2.0 — Swarm Orchestrator

Bộ não điều phối viết nội dung tiếng Việt chuyên nghiệp. Phân tích yêu cầu → tự lắp workflow → gọi đúng tổ hợp modules.

---

## Module Registry

| ID | Module | File | Loại | Kích hoạt khi |
|----|--------|------|------|---------------|
| N1 | Research | `content/research.md` | ⚪ Tùy chọn | Chủ đề xa lạ, cần tìm hiểu thêm |
| N2 | Analysis | `content/analysis.md` | ⚪ Tùy chọn | User cung cấp data thô cần rút insights |
| V1 | Emotional | `style/emotional.md` | 🔵 Mặc định | Mọi bài viết trừ tài liệu kỹ thuật |
| V2 | Advanced | `style/advanced.md` | ⚪ Tùy chọn | Commentary, metaphor, reframing, compounding |
| V3 | Technical | `style/technical.md` | ⚪ Tùy chọn | Sách giáo khoa, tài liệu kỹ thuật, whitepaper |
| H1 | Facebook | `platform/facebook.md` | ⚪ Tùy chọn | Target platform = Facebook |
| Q1 | Punctuation | `quality/punctuation.md` | 🔴 Bắt buộc | LUÔN LUÔN — dấu câu, viết hoa, tiêu đề |
| Q2 | Natural | `quality/natural.md` | 🔴 Bắt buộc | LUÔN LUÔN — văn phạm tự nhiên, anti-AI |
| Q3 | Fact-check | `quality/fact-check.md` | ⚪ Tùy chọn | Có statistics, quotes, claims cần verify |
| Q4 | Consistency | `quality/consistency.md` | 🔵 Mặc định | Sau khi viết xong — kiểm tra nhất quán, xung đột |
| M1 | Upgrade | `meta/upgrade.md` | ⚪ Tùy chọn | Sau khi viết xong, cần rút kinh nghiệm cải tiến skill |
| M2 | Style Audit | `meta/style-audit.md` | ⚪ Tùy chọn | Phân tích bài mẫu hoặc output — rút style DNA, AI self-check |

**Phân loại:**
- 🔴 **Bắt buộc:** Luôn load, không bỏ qua
- 🔵 **Mặc định:** Load trừ khi request cho thấy không cần
- ⚪ **Tùy chọn:** Chỉ load khi điều kiện khớp

---

## Phân Tích Request — 5 Câu Hỏi

Trước khi dispatch, trả lời 5 câu hỏi:

| # | Câu hỏi | Quyết định |
|---|---------|------------|
| 1 | User cung cấp gì? (data thô, ý tưởng, topic trống?) | Cần N1/N2 không? |
| 2 | Mục đích? (inspire, educate, instruct, inform, brief) | V1/V3? |
| 3 | Độc giả là ai? (công chúng, professionals, technical) | Tone & depth? |
| 4 | Platform? (Facebook, blog, docs, report) | Cần H1? |
| 5 | Có claims/số liệu quan trọng? | Cần Q3? |

---

## Dispatch Logic

```
Bước 1: Cần thu thập dữ liệu không?
├─ Chủ đề xa lạ?          → load N1 (research)
├─ Có data thô?           → load N2 (analysis)
└─ Đã đủ thông tin?       → bỏ qua

Bước 2: Phong cách viết nào?
├─ MẶC ĐỊNH               → load V1 (emotional)
├─ Sách/tài liệu kỹ thuật? → load V3 (technical) THAY THẾ V1
├─ Cần commentary/reframe? → load V2 (advanced) BỔ SUNG V1
└─ V1 + V2 có thể dùng cùng lúc, V3 thay thế V1

Bước 3: Platform đặc biệt?
├─ Facebook?              → load H1 (facebook)
└─ Markdown/Blog?         → không cần load gì

Bước 4 (BẮT BUỘC): Load Q1 + Q2

Bước 5: Có claims cần verify?
├─ Có số liệu, quotes?   → load Q3 (fact-check)
└─ Opinion-based?         → bỏ qua

Bước 6 (SAU KHI VIẾT): Load Q4 (consistency) → kiểm tra nhất quán
```

---

## Workflow Tự Lắp — Ví Dụ

| User nói | Workflow |
|----------|----------|
| "Viết bài về..." | [V1] → [Q1 + Q2] |
| "Viết bài đăng Facebook về AI" | [V1] → [H1] → [Q1 + Q2] |
| "Chuyển sang dạng FB" | [H1] (chỉ format) |
| "Viết phản hồi/bình luận bài viết này" | [V1 + V2] → [Q1 + Q2] |
| "Viết tài liệu/sách..." | [V3] → [Q1 + Q2] |
| "Phân tích data này rồi viết bài" | [N2] → [V1] → [Q1 + Q2] |
| "Nghiên cứu về X rồi viết bài có số liệu" | [N1] → [V1] → [Q1 + Q2 + Q3] |
| "Phân tích bài viết vừa xong để cải tiến skill" | [M1] |

---

## Sơ Đồ Cấu Trúc

```
viet-chuyen-nghiep/
│
├── SKILL.md                    ← Bạn đang ở đây (Orchestrator)
│
├── content/                    ← THU THẬP (tùy chọn)
│   ├── research.md             ← Topic → Thông tin       [N1]
│   └── analysis.md             ← Data → Insights         [N2]
│
├── style/                      ← PHONG CÁCH (chọn 1 hoặc kết hợp)
│   ├── emotional.md            ← Storytelling/Blog        [V1] mặc định
│   ├── advanced.md             ← Kỹ thuật nâng cao        [V2] bổ sung V1
│   └── technical.md            ← Kỹ thuật/Học thuật       [V3] thay thế V1
│
├── platform/                   ← HIỂN THỊ (tùy chọn)
│   └── facebook.md             ← Plaintext Facebook       [H1]
│
├── quality/                    ← CHẤT LƯỢNG
│   ├── punctuation.md          ← Dấu câu, viết hoa       [Q1] 🔴
│   ├── natural.md              ← Văn phạm, anti-AI       [Q2] 🔴
│   ├── fact-check.md           ← Kiểm chứng claims       [Q3]
│   └── consistency.md          ← Nhất quán, xung đột     [Q4] 🔵
│
└── meta/                       ← TỰ CẢI TIẾN
    ├── upgrade.md              ← Quy trình nâng cấp      [M1]
    └── style-audit.md          ← Phân tích phong cách   [M2]
```

---

## Checklist Thực Hiện

Với mỗi request viết nội dung:

- [ ] Phân tích request (5 câu hỏi)
- [ ] Xác định modules cần load từ registry
- [ ] Load modules theo thứ tự dispatch
- [ ] **Load Q1 + Q2** (BẮT BUỘC — không bỏ qua)
- [ ] Viết content theo guidelines đã load
- [ ] **Chạy Q4** (kiểm tra nhất quán — mặc định)
- [ ] Verify tuân thủ Q1 + Q2 + Q4

---

## Lỗi Cần Tránh

**❌ Không nên:**
- Bỏ qua Q1/Q2 (bắt buộc mọi lúc)
- Load tất cả modules cùng lúc (lãng phí token)
- Dùng V1 + V3 cùng lúc (V3 thay thế V1, không bổ sung)
- Viết xong mà không chạy checklist Q1/Q2

**✅ Nên:**
- Load modules dần dần theo workflow
- Luôn load Q1 + Q2 trước khi viết
- Dùng V2 bổ sung V1 khi cần kỹ thuật nâng cao
- Gọi M1 sau khi viết xong bài phức tạp để cải tiến skill

---

**Version:** 2.2  
**Vai trò:** Swarm Orchestrator  
**Triết lý:** Phân tích → Tự lắp workflow → Gọi đúng modules → Kiểm tra nhất quán

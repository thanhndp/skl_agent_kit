# Tự Nâng Cấp Skill

**Module:** M1 — Meta  
**Loại:** ⚪ Tùy chọn  
**Mục đích:** Phân tích output đã viết → rút pattern → bổ sung vào skill.

---

## Khi Nào Gọi

- Sau khi hoàn tất bài viết phức tạp và được user duyệt
- Khi user yêu cầu: "phân tích bài viết này để cải tiến skill"
- Khi phát hiện kỹ thuật/pattern lặp lại chưa được document

---

## Quy Trình

### Bước 1: Phân tích output

Dùng `meta/style-audit.md` để phân tích bài viết đã hoàn tất:
- Chạy staged assessment (4 tầng)
- Rút style DNA và kỹ thuật đã dùng
- Chạy AI self-check
- Phát hiện lỗi tiếng Việt đã sửa

### Bước 2: So sánh với registry

Mở `SKILL.md` → đọc registry → kiểm tra:
- Kỹ thuật đó đã có trong module nào chưa?
- Lỗi đó đã được ghi trong `quality/` chưa?

### Bước 3: Đề xuất bổ sung

Nếu phát hiện điều mới:
- **Kỹ thuật mới** → bổ sung vào module style phù hợp
- **Quy tắc mới** → bổ sung vào module quality phù hợp
- **Pattern mới** → báo cáo cho user trước khi thêm

### Bước 4: Thực hiện bổ sung

Sau khi user duyệt, thêm nội dung vào module đích.

---

## Quy Chuẩn Bổ Sung

### Kỹ thuật mới (vào style/)

Mỗi kỹ thuật phải có đủ 5 thành phần:

```
## Kỹ thuật N: [Tên] ([Tên tiếng Anh])

**Mô tả:** [1-2 câu]

**Công thức:**
[Cấu trúc step-by-step]

**Ví dụ:**
[Ví dụ cụ thể từ bài viết thực tế]

**Cấm:**
[Anti-pattern, điều tránh]
```

### Quy tắc mới (vào quality/)

Mỗi quy tắc phải có:

```
### [Tên quy tắc]

| Sai | Đúng |
|-----|------|
| `[ví dụ sai]` | `[ví dụ đúng]` |
```

### Giới hạn kích thước module

- Mỗi module KHÔNG vượt **300 dòng**
- Nếu module sắp vượt → tách thành file mới
- Tên file mới theo quy chuẩn: `[function].md` tiếng Anh
- Cập nhật registry trong `SKILL.md`

---

## Changelog

Mọi thay đổi ghi vào đây:

| Ngày | Module | Thay đổi | Nguồn |
|------|--------|----------|-------|
| 2026-02-26 | `style/advanced.md` | Thêm 6 kỹ thuật nâng cao | Bài viết AI & Gen Z |
| 2026-02-26 | `quality/punctuation.md` | Thêm quy tắc Oxford comma | Bài viết AI & Gen Z |

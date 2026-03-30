---
description: "🔄 Đồng bộ knowledge mới vào NotebookLM Brain — nạp docs, URLs, text vào Long-Term Memory."
---

# /brain-sync — Đồng Bộ Knowledge Vào Brain

Workflow này đồng bộ tài liệu mới từ project vào NotebookLM Brain, giữ Long-Term Memory luôn cập nhật.

## Yêu Cầu
- Brain đã được setup (`brain.enabled: true` trong `.agents/config/brain.yaml`)
- Nếu chưa setup → Hướng dẫn chạy `/brain-bootstrap` trước

---

## Bước 1: Kiểm tra Brain config

Đọc `.agents/config/brain.yaml`:
- Nếu `brain.enabled: false` → "Brain chưa được cấu hình. Chạy `/brain-bootstrap` trước."
- Lấy `notebook_id` để dùng cho các bước sau.

## Bước 2: Hỏi User muốn sync gì

```
🔄 Brain Sync — Chọn nguồn cần đồng bộ:

1. 📂 Auto-scan docs/ — Quét thư mục docs/ và nạp file .md mới
2. 📄 Thêm text — Paste nội dung trực tiếp
3. 🌐 Thêm URL — Nạp trang web/YouTube
4. 📁 Thêm Google Drive — Nạp từ Drive
5. 🔍 Deep Research — Nghiên cứu sâu chủ đề mới cho Brain
6. 📋 Xem status — Xem Brain hiện có gì

Chọn (1-6):
```

### Xử lý lựa chọn:

**Chọn 1 — Auto-scan docs/:**
// turbo
1. Liệt kê tất cả file `.md` trong `docs/`
2. So sánh với danh sách `brain.sources` trong config
3. Chỉ nạp file MỚI hoặc đã thay đổi (so timestamp)
4. Với mỗi file mới:
   ```
   mcp_notebooklm_notebook_add_text(
       notebook_id = "<UUID>",
       text = "<nội_dung_file>",
       title = "<tên_file>"
   )
   ```
5. Cập nhật `brain.sources` và `brain.last_sync`

**Chọn 2 — Text:**
Hỏi User nhập title + paste nội dung → `notebook_add_text()`

**Chọn 3 — URL:**
Hỏi User nhập URL → `notebook_add_url()`

**Chọn 4 — Drive:**
Hỏi document_id + title → `notebook_add_drive()`

**Chọn 5 — Deep Research:**
1. Hỏi User nhập chủ đề cần nghiên cứu
2. Chạy: `research_start(query="<chủ_đề>", notebook_id="<UUID>", mode="deep")`
3. Poll: `research_status(notebook_id, max_wait=300)`
4. Import: `research_import(notebook_id, task_id)`
5. Thông báo số nguồn đã tìm và import

**Chọn 6 — Status:**
1. Chạy: `notebook_describe(notebook_id)` → Hiển thị summary + topics
2. Hiển thị `brain.sources` và `brain.last_sync` từ config

## Bước 3: Cập nhật brain.yaml

Sau khi sync thành công, cập nhật `.agents/config/brain.yaml`:

```yaml
brain:
  sources:
    - title: "research.md"
      synced_at: "2026-03-30T14:00:00+07:00"
    - title: "spec.md"
      synced_at: "2026-03-30T14:00:00+07:00"
  last_sync: "2026-03-30T14:00:00+07:00"
```

## Bước 4: Verify

```
mcp_notebooklm_notebook_describe(notebook_id)
```

Hiển thị summary mới → Xác nhận knowledge đã được nạp.

## Bước 5: Thông báo

```
🔄 Brain Sync Hoàn Tất!
━━━━━━━━━━━━━━━━━━━━━
📓 Brain: <TÊN_NOTEBOOK>
📚 Tổng sources: <số>
🆕 Mới nạp: <số> sources
🕐 Thời gian: <timestamp>

💡 Brain sẽ tự động sử dụng knowledge mới cho các task tiếp theo.
```

---

## Tích Hợp Với Data Handoff

Khi Agent ghi ra `docs/research.md`, `docs/spec.md`, hoặc `docs/plan.md` (theo Data Handoff Protocol), Agent NÊN tự động đề xuất:

> "📋 Tôi vừa ghi kết quả nghiên cứu ra `docs/research.md`. Bạn có muốn tôi sync vào Brain không? (chạy `/brain-sync`)"

Điều này đảm bảo Brain luôn được cập nhật khi có knowledge mới — tạo **Multiplication Effect**: update docs → Brain update → Agent output thay đổi tức thì.

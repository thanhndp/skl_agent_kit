---
description: "🧠 Khởi tạo NotebookLM Brain cho dự án — tạo notebook, nạp knowledge, cấu hình kết nối."
---

# /brain-bootstrap — Khởi Tạo Brain Cho Dự Án

Workflow này tạo một NotebookLM notebook riêng cho project hiện tại, nạp knowledge ban đầu, và cấu hình kết nối MCP.

## Yêu Cầu Trước Khi Chạy
- NotebookLM MCP Server đã được cài đặt và xác thực (xem `docs/skill_extension_integration_guide.md` section 4.2)
- Tool `mcp_notebooklm_notebook_create` khả dụng

---

## Bước 1: Kiểm tra trạng thái hiện tại

Đọc file `.agents/config/brain.yaml`:
- Nếu `brain.enabled: true` và đã có `notebook_id` → Thông báo: "Brain đã được cấu hình. Bạn muốn tạo mới hay giữ nguyên?"
- Nếu `brain.enabled: false` hoặc thiếu `notebook_id` → Tiếp tục tạo mới.

## Bước 2: Xác định tên project

Lấy tên từ một trong các nguồn (theo thứ tự ưu tiên):
1. `package.json` → field `name`
2. `pyproject.toml` → field `name`
3. Tên thư mục gốc của project
4. Hỏi User nếu không xác định được

## Bước 3: Tạo NotebookLM Notebook

```
mcp_notebooklm_notebook_create(title="[Project] <TÊN_PROJECT> Brain")
```

Lưu lại `notebook_id` trả về.

## Bước 4: Hỏi User về knowledge cần nạp

Hiển thị menu cho User:

```
🧠 Brain đã được tạo! Bạn muốn nạp knowledge nào?

1. 📄 Thêm text (specs, requirements, business rules)
2. 🌐 Thêm URL (tài liệu online, docs)
3. 📁 Thêm Google Drive docs
4. 📂 Thêm nội dung từ thư mục docs/ trong project
5. ⏭️ Bỏ qua — tôi sẽ nạp sau bằng /brain-sync

Chọn (1-5, có thể chọn nhiều):
```

### Xử lý lựa chọn:

**Chọn 1 — Text:**
Hỏi User paste nội dung → `mcp_notebooklm_notebook_add_text(notebook_id, text, title)`

**Chọn 2 — URL:**
Hỏi User nhập URL → `mcp_notebooklm_notebook_add_url(notebook_id, url)`

**Chọn 3 — Drive:**
Hỏi document_id + title → `mcp_notebooklm_notebook_add_drive(notebook_id, document_id, title)`

**Chọn 4 — Local docs/:**
Quét thư mục `docs/` → Đọc từng file `.md` → `mcp_notebooklm_notebook_add_text(notebook_id, content, filename)`

## Bước 5: Cấu hình brain.yaml

Cập nhật `.agents/config/brain.yaml`:

```yaml
brain:
  enabled: true
  notebook_id: "<UUID_VỪA_TẠO>"
  notebook_title: "[Project] <TÊN> Brain"
```

## Bước 6: Hỏi User chọn Consult Mode

```
⚙️ Chọn chế độ tham vấn Brain:

1. 🤖 Auto — Agent tự động query Brain khi cần (không hỏi bạn)
2. 🙋 Ask  — Agent hỏi bạn trước mỗi lần query Brain (khuyến nghị)

Chọn (1-2):
```

Cập nhật `consult_mode` trong `brain.yaml` theo lựa chọn.

## Bước 7: Test kết nối

```
mcp_notebooklm_notebook_query(
    notebook_id = "<UUID>",
    query = "Tóm tắt nội dung chính của notebook này"
)
```

- **Thành công** → Hiển thị tóm tắt + "✅ Brain đã sẵn sàng!"
- **Thất bại** → "❌ Không kết nối được. Kiểm tra NotebookLM MCP auth."

## Bước 8: Thông báo hoàn tất

```
🧠 Brain Setup Hoàn Tất!
━━━━━━━━━━━━━━━━━━━━━━━
📓 Notebook: [Project] <TÊN> Brain
🆔 ID: <UUID>
⚙️ Mode: <auto|ask>
📚 Sources: <số lượng> sources đã nạp

💡 Cách dùng:
- Brain sẽ tự động được tham vấn khi bạn gửi task liên quan
- Nạp thêm knowledge: /brain-sync
- Thay đổi mode: sửa .agents/config/brain.yaml → consult_mode
```

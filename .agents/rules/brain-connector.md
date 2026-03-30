---
description: "Quy tắc tham vấn NotebookLM Brain — quyết định KHI NÀO Agent phải query Long-Term Memory."
---

# SKL_AGENT Brain Connector — Workflow Engine Rule

Tài liệu này định nghĩa cơ chế Workflow Engine quyết định khi nào Agent phải kết nối với **NotebookLM Brain** (Long-Term Memory) qua MCP trước khi xử lý Task.

## Kiến Trúc

```
User Task → Agent → [Workflow Engine Check] → Cần Brain? 
                                                  ├── CÓ → MCP query Brain → Xử lý với grounded context
                                                  └── KHÔNG → Xử lý trực tiếp
```

- **NotebookLM** = Long-Term Memory (kiến thức, specs, quy định dự án)
- **Antigravity** = Active Processor (xử lý task dựa trên context từ Brain)
- **MCP** = Live Bridge (kênh giao tiếp real-time giữa hai hệ thống)

## Chế Độ Hoạt Động (Consult Mode)

Đọc `.agents/config/brain.yaml` để xác định chế độ:

| Mode | Hành vi | Khi nào dùng |
|------|---------|-------------|
| `auto` | Agent **tự động** query Brain khi gặp trigger → không hỏi User | Khi đã tin tưởng Brain có đủ specs |
| `ask` | Agent **hỏi User** trước: "Tôi cần tham vấn Brain về X, bạn đồng ý?" | Khi muốn kiểm soát mỗi lần query |
| `off` | Không sử dụng Brain, hoạt động như bình thường | Khi Brain chưa setup hoặc offline |

## Điều Kiện Trigger (Phải Tham Vấn Brain)

Agent PHẢI tham vấn Brain (theo mode `auto` hoặc `ask`) khi Task thỏa **ít nhất 1** điều kiện:

### Trigger Theo Từ Khóa
User mention bất kỳ cụm nào trong `consult_triggers` (cấu hình trong `brain.yaml`):
- "theo chuẩn...", "theo quy định...", "dựa vào tài liệu..."
- "business logic", "requirements", "spec", "policy"
- Hoặc bất kỳ trigger tùy chỉnh nào trong config

### Trigger Theo Ngữ Cảnh
- Task liên quan đến **business rules** hoặc **domain-specific logic** (không phải coding thuần)
- Task cần context từ **tài liệu dự án** (specifications, requirements, design docs)
- Task liên quan đến **quy trình đã được document** trước đó
- Task về **đánh giá, phân tích, hoặc báo cáo** theo tiêu chuẩn cụ thể

### KHÔNG Trigger (Skip Brain)
Agent bỏ qua Brain khi:
- Task đơn giản: fix typo, format code, chạy lệnh terminal
- Task có đủ context trong **local files** (`.agents/rules/`, `docs/`)
- Task thuần coding (viết function, debug syntax error)
- Brain chưa được setup (`brain.enabled: false` hoặc thiếu `notebook_id`)

## Cách Query Brain Đúng Cách

### Format Query
```
mcp_notebooklm_notebook_query(
    notebook_id = "<từ brain.yaml>",
    query = "<câu hỏi cụ thể, tập trung 1 chủ đề>"
)
```

### Nguyên Tắc Query
1. **Cụ thể, không chung chung** — "Tiêu chí đánh giá đọc hiểu lớp 5 theo chuẩn KNTT?" thay vì "Cho tôi biết về giáo dục"
2. **1 query = 1 chủ đề** — Nếu cần nhiều thông tin, chia thành nhiều query
3. **Ghi source** — Sau khi nhận kết quả, ghi rõ "Nguồn: Brain query" trong output

### Xử Lý Kết Quả
- **Có kết quả rõ ràng** → Sử dụng làm grounded context, KHÔNG sáng tạo thêm
- **Kết quả mơ hồ** → Thông báo User: "Brain không có đủ thông tin về X, bạn muốn tôi xử lý dựa trên kiến thức chung?"
- **Brain offline/lỗi** → Theo `fallback_if_offline` trong config (skip / warn / block)

## Fallback Khi Brain Offline

| Config Value | Hành vi |
|-------------|---------|
| `skip` | Bỏ qua, xử lý bình thường. Thông báo: "Brain không khả dụng, xử lý bằng kiến thức cục bộ." |
| `warn` | Cảnh báo User nhưng vẫn tiếp tục: "⚠️ Brain offline. Kết quả có thể thiếu context dự án." |
| `block` | Dừng lại, yêu cầu User fix: "Brain không kết nối được. Chạy `/brain-bootstrap` để kiểm tra." |

## Lợi Ích (Multiplication Effect)

1. **Dynamic Logic** — Update specs trong NotebookLM → Agent output thay đổi tức thì, không cần sửa code
2. **Grounding** — Agent không hallucinate business logic, bám sát docs thật
3. **Persistence** — Restart session → Brain vẫn giữ nguyên knowledge
4. **Scale** — Mỗi project 1 Brain riêng → context chính xác cho từng dự án

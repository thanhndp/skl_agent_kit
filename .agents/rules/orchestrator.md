---
description: "Phân loại intent tự động và điều phối task đến đúng layer (Brain/Tool/Direct)."
---

# SKL_AGENT Orchestrator — Intent Classification & Routing

Tài liệu này là **rule đọc đầu tiên** khi Agent nhận task. Nó quyết định luồng xử lý trước khi mọi rule khác được áp dụng.

## Luồng Xử Lý

```
User Input
  → 1. Classify Intent
  → 2. Select Capability
  → 3. Route to Layer (Brain / Tool / Direct)
  → 4. Build Context (xem context-builder.md)
  → 5. Execute
  → 6. Output
```

## Bước 1: Phân Loại Intent

Khi nhận task từ User, Agent tự phân loại vào **5 intent**:

| Intent | Dấu hiệu | Ví dụ |
|--------|-----------|-------|
| `knowledge_query` | Hỏi thông tin, quy định, giải thích | "X là gì?", "theo chuẩn nào?", "giải thích..." |
| `action_request` | Yêu cầu thực hiện hành động cụ thể | "gửi email", "tạo file", "deploy", "chạy lệnh" |
| `analysis` | Phân tích, so sánh, đánh giá dữ liệu | "phân tích file này", "so sánh A với B" |
| `creative` | Tạo nội dung, viết bài, design | "viết báo cáo", "tạo slide", "design UI" |
| `system` | Thao tác code, debug, cấu hình | "fix bug", "refactor", "thêm test" |

**Cách phân loại:**
1. Đọc user input
2. Match keywords + ngữ cảnh vào intent phù hợp nhất
3. Nếu không rõ → mặc định `analysis` (an toàn nhất)
4. Nếu overlap nhiều intent → chọn intent ĐẦU TIÊN trong danh sách ưu tiên trên

## Bước 2: Route Đến Layer

| Intent | Primary Route | Khi nào dùng Brain | Khi nào dùng Tools |
|--------|--------------|--------------------|--------------------|
| `knowledge_query` | **Brain** (NotebookLM) | Luôn luôn (nếu Brain enabled) | Nếu cần data realtime |
| `action_request` | **Tools** (MCP/Terminal) | Nếu cần specs trước khi execute | Luôn luôn |
| `analysis` | **Brain + Local** | Nếu cần domain context | Nếu cần fetch/process data |
| `creative` | **Skills + Brain (optional)** | Nếu cần reference, template | Nếu cần generate files |
| `system` | **Direct coding** | Hiếm khi | Nếu cần run commands |

## Bước 3: Áp Dụng Rules Tiếp Theo

Sau khi route, Agent đọc thêm rules theo thứ tự:

```
1. orchestrator.md        ← (BẠN ĐANG Ở ĐÂY)
2. context-builder.md     ← Build context cho intent đã chọn
3. brain-connector.md     ← Nếu route đến Brain
4. safety-guard.md        ← Kiểm tra an toàn
5. permission-guard.md    ← Kiểm tra quyền truy cập
6. data-handoff.md        ← Ghi output ra file
7. feedback-logger.md     ← Log kết quả
```

## Nguyên Tắc

1. **Không expose routing ra User** — User không cần biết intent là gì, chỉ nhận kết quả
2. **Mặc định an toàn** — Nếu uncertain, chọn route cần confirmation trước khi execute
3. **Capability-first** — Chọn capability phù hợp nhất từ `capabilities.yaml`, không chọn mode
4. **Transparent khi hỏi** — Nếu thật sự không phân loại được, hỏi User: "Bạn muốn tôi tìm thông tin, hay thực hiện hành động?"

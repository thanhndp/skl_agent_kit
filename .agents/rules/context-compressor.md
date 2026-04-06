---
description: "Context Compression Protocol — Chống tràn Token Window bằng cách Tự động & Thủ công Nén Context dựa trên cơ chế của Claude Code."
---

# Context Compressor Protocol

Agent phải giữ context window (Session Memory) mỏng và relevant nhất có thể. Dữ liệu dài (Stacktrace lỗi cũ, raw file dump, logs) là kẻ thù của hiệu suất.

## 1. Dấu hiệu Cần Nén Context (Triggers)

Agent PHẢI TỰ ĐỘNG nhận diện các dấu hiệu sau để kích hoạt rule nén, hoặc khi User gọi lệnh `/compact`:

1. **Task Switching:** Chuyển từ Task A (VD: Code UI) sang Task B (VD: Viết Test) hoàn toàn khác biệt.
2. **Infinite Error Loop:** Vòng lặp debug thất bại quá 5 lần (Context đã chứa đầy stacktrace rác).
3. **Large File Read:** Vừa đọc 1 file > 500 lines nhưng chỉ cần 1 hàm trong đó.
4. **Phase Transition:** Khi Coordinator chuyển từ Phase 2 (Plan) sang Phase 3 (Implementation).

## 2. Strategies: Cách Nén Context

Không được xoá sạch trí nhớ, phải dùng phương pháp đánh đổi:

### Strategy 1: "Markdown Summarization" (Dùng cho Log/Conversation)
Thay vì giữ nguyên 50 dòng log lỗi và các bước debug, Coordinator tự động tạo 1 note tóm tắt:
- "Bug: Memory Leak. Đã thử fix bằng WeakRef nhưng fail do compatibility."
- Sau khi tóm tắt, hãy ghi lại thay vì giữ raw log.

### Strategy 2: "Artifact Reference" (Dùng cho Data lớn)
Thay vì giữ file JSON 10KB trong prompt, hãy dùng `run_command` để lưu ra `/tmp/temp_data.json` và chỉ giữ đường dẫn trong context.
- "Data đã được xử lý và lưu tại /tmp/temp_data.json. Ignore memory payload từ đây trở đi."

### Strategy 3: "Memory Offloading" (Đẩy về Tier 2 hoặc Tier 3)
- Những file rules, specs dài nên được đẩy lên NotebookLM (Tier 2).
- Các thói quen của User phát sinh trong phiên nên được đẩy lưu vào `entities.yaml` (Tier 3) rồi xoá khỏi Session Context.

## 3. Lệnh Tương Tác: `/compact`

Nếu User chat: `/compact` hoặc "nén context", "xoá bớt log":
1. Agent tạm dừng mọi thứ.
2. Viết ra 1 Artifact `context_summary.md` chứa:
   - Mục tiêu hiện tại là gì.
   - Các file đang thao tác.
   - Lỗi cuối cùng (nếu có).
3. Chỉ giữ lại Artifact đó trong context và hành xử như một Session hoàn toàn mới.

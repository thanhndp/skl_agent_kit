---
description: "Orchestrator v3 — Coordinator Mode (Phase-based Multi-Agent Orchestration), Execution Planning, and Guardrail Checkpoints."
---

# SKL AGENT KIT Orchestrator v3 (Coordinator Mode)

Rule đọc đầu tiên khi Agent nhận task chuyên sâu hoặc yêu cầu dùng profile "Expert/Intermediate".
Hệ thống vận hành theo mô hình Multi-Agent Coordinator lấy cảm hứng từ kiến trúc của Claude Code.

## 1. The Coordinator / Worker Pattern

Thay vì cố gắng code và nghĩ trong cùng một lúc, Agent hoạt động với tư cách là **Coordinator** (Người điều phối).
Coordinator sẽ chia nhỏ tác vụ và chạy theo 4 Phase riêng biệt.

### Phase 1: Research (Khám phá)
- Không chạm vào code. Chỉ dùng tools để đọc docs, search, chạy lệnh list files, xem memory (`entities.yaml`).
- Mục tiêu: Hiểu rõ codebase hiện tại, constraint của project, và cách API hoạt động.

### Phase 2: Synthesis (Tổng hợp & Lên Plan)
- Coordinator tổng hợp thông tin từ Phase 1 và viết Spec (tính năng) hoặc Plan (lộ trình sửa bug).
- *Lưu ý:* Lưu output vào artifacts (`task.md`, `implementation_plan.md`) thay vì định dạng XML để duy trì sự nhất quán của SKL AGENT KIT.
- Đặt `RequestFeedback: true` nếu đụng đến phá vỡ kiến trúc (Breaking changes).

### Phase 3: Implementation (Thực thi - Giao việc cho Worker)
- Coordinator "spawn" các quá trình/tool calls. Ở profile Expert, có thể chạy song song (Concurrent Multi-Agent) nhiều tool calls để sửa nhiều file cùng lúc.
- Anti-pattern: Không sửa 1 file nhỏ lẻ xong vội vã review. Phải chờ các worker (tool calls) xong hết cho 1 cụm tính năng.

### Phase 4: Verification (Kiểm chứng)
- Chạy test, build command, hoặc dùng browser agent để kiểm tra UI.
- Ghi log lại lỗi để fix (vòng lặp về lại Phase 1 hoặc 3).

---

## 2. Multi-intent Classification (Dành cho Quick Tasks)

Nếu task đơn giản và không cần Coordinator Mode, Agent phân loại intent:

| Intent | Dấu hiệu | Ví dụ |
|--------|-----------|-------|
| `knowledge_query` | Hỏi thông tin, quy định | "X là gì?", "theo chuẩn nào?" |
| `action_request` | Thực hiện hành động | "gửi email", "tạo file", "deploy" |
| `analysis` | Phân tích, đánh giá | "phân tích file này", "so sánh A-B" |
| `creative` | Tạo nội dung mới | "viết báo cáo", "tạo slide" |
| `system` | Thao tác code, config | "fix bug", "refactor" |

---

## 3. Delegation Anti-Patterns (Cấm kỵ khi làm Coordinator)

Khi hoạt động trong Coordinator Mode, Agent PHẢI TRÁNH các lỗi kinh điển sau:

1. ❌ **Micro-management:** Quá tỉ mỉ vào 1 file trong khi hệ thống đang vỡ diện rộng. Phải nhìn bức tranh tổng thể (`Synthesis`).
2. ❌ **Dumping Code:** In ra màn hình console hàng trăm dòng code thay vì dùng tool `write_to_file`. Luôn giao việc ghi file cho Tool (Worker).
3. ❌ **Blind Delegation:** Giao việc (cập nhật file) mà không kiểm tra (Phase 4). Luôn luôn phải verify.
4. ❌ **Infinite Loop:** Gặp 1 lỗi test 5 lần không sửa được. Cấm thử lại cùng 1 đoạn code quá 3 lần. Nếu failed → Lùi lại Phase 1 (Research) hoặc báo User.

---

## 4. Artifact-Based Handoff

Khác với các hệ thống nội bộ gửi event XML, SKL AGENT KIT giao tiếp các Phase thông qua **Artifacts** (Markdown files lưu trong `brain/`):
- `implementation_plan.md`: Lưu Plan (Phase 2).
- `task.md`: Lưu Check-list các file/worker cần chạy (Phase 3).
- `walkthrough.md`: Báo cáo quá trình sau khi hoàn tất (Phase 4).

> **Profile Limit:**
> Số lượng "worker" (tức là tool calls chạy song song tối đa) phụ thuộc vào config `max_workers` trong `.agents/config/profiles.yaml` (Beginner: 2, Expert: 10). Nếu User là Beginner, Coordinator phải làm chậm, chia nhỏ hơn nữa.

---

## 5. Quy trình Guardrails (Safety Checkpoints)

Guardrails KHÔNG tách riêng — gắn trực tiếp vào execution flow:

- **Before Implementation (Phase 3):**
  Check `security-modes.yaml` (Cấp độ Paranoid của Beginner sẽ yêu cầu hỏi User trước khi chạy terminal).
- **Before Output:** Kiểm tra PII/Data Leak.

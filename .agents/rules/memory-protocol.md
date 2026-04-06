---
description: "Protocol quản lý bộ nhớ 3 tầng — tập trung vào Tier 3 Entity Memory với 4-Type Taxonomy (User, Feedback, Project, Reference) theo chuẩn Claude Code."
---

# SKL AGENT KIT Memory Protocol v2.0

Hệ thống memory được thiết kế để Agent "nhớ" ngữ cảnh qua các phiên làm việc, giảm thiểu việc lặp lại hướng dẫn và xây dựng hiểu biết sâu sắc về dự án và người dùng.

## Kiến Trúc 3 Tầng

```
┌─────────────────────────────────────────┐
│ Tier 1: Short-term (Session Memory)     │ ← Volatile, within session
│   Conversation context, task state      │
│   Storage: Antigravity session          │
├─────────────────────────────────────────┤
│ Tier 2: Long-term (Brain Memory)        │ ← Persistent, project-wide
│   Specs, business rules, domain logic   │
│   Storage: NotebookLM via MCP           │
├─────────────────────────────────────────┤
│ Tier 3: Entity Memory (4-Type Taxonomy) │ ← Persistent, structured
│   User, Feedback, Project, Reference    │
│   Storage: .agents/memory/entities.yaml │
└─────────────────────────────────────────┘
```

---

## Tier 3: The 4-Type Taxonomy

Dữ liệu bộ nhớ (Entity Memory) trong file `entities.yaml` ĐƯỢC CHIA THÀNH 4 LOẠI CỤ THỂ. Agent phải phân loại thông tin vào đúng type khi lưu trữ.

> [!WARNING]
> **What NOT to save:** Code patterns, project architecture, file paths, git history. Nếu có thể derive từ codebase hiện tại (bằng search, `git log`), đừng lưu vào memory bloat `entities.yaml`.

### 1. User Memory (`type: user`)
Thông tin về vai trò, chuyên môn, trách nhiệm và phong cách của User.
- **When to save:** Khi biết được title, cấp độ kỹ năng (Beginner/Expert), hay mục tiêu cá nhân.
- **How to use:** Tùy chỉnh prompt và mức độ giải thích. (Ví dụ: Tránh giải thích "git là gì" cho Senior Backend Engineer).
- **Ví dụ:** "User là giáo viên Toán, không rành kỹ thuật, cần giải thích step-by-step không dùng biệt ngữ."

### 2. Feedback Memory (`type: feedback`)
Các chỉ đạo của User về CÁCH làm việc: Cả những điều cần tránh (corrections) VÀ những quyết định đúng đắn (confirmations).
- **When to save:** Bất cứ khi nào User nói "đừng làm X", "thế này tốt hơn", "chuẩn rồi, giữ nguyên cách này". **Lưu cả lời khen/xác nhận**, không chỉ lưu lỗi sai.
- **Body structure:** Phải có: {Rule} + **Why:** {Reason} + **How to apply:** {Context}. Biết *tại sao* giúp áp dụng linh hoạt.
- **Ví dụ:** "Rule: Không tự động chạy shell command. Why: Lần trước chạy sai script deploy. How to apply: Luôn Set SafeToAutoRun: false."

### 3. Project Memory (`type: project`)
Bối cảnh dự án, mục tiêu, constraint tạm thời không thể tìm thấy trong code.
- **When to save:** Khi có deadline, thông báo freeze code, hoặc lý do tại sao một tính năng tồn tại. Phải convert relative time ("Thứ Năm") thành absolute date ("2026-04-10").
- **Ví dụ:** "Deadline demo Phase 1 là 2026-04-15. Why: Có lịch họp BGH. How to apply: Ưu tiên tính năng core, bỏ qua nice-to-have từ nay đến đó."

### 4. Reference Memory (`type: reference`)
Con trỏ đến hệ thống hoặc tài liệu external.
- **When to save:** Khi User đưa URL doc, Notion, Jira board, hay chỉ định nơi xem log.
- **Ví dụ:** "Tài liệu API của trường lấy tại: intra.skylineschool.edu.vn/api-docs"

---

## Cấu trúc `entities.yaml`

```yaml
entities:
  # Ví dụ 1: User Profile
  - type: user
    name: User Profile
    content: "Giáo viên Toán cấp 2, ưu tiên tốc độ ra đề thi."
    confidence: 1.0
    date: "2026-04-02"

  # Ví dụ 2: Feedback
  - type: feedback
    name: Bỏ qua giải thích kỹ thuật
    content: "Rule: Chỉ output command, không giải thích dài dòng. Why: User cần làm nhanh. How to apply: Trong mọi query kỹ thuật."
    confidence: 0.8
    date: "2026-04-02"
```

---

## Memory Drift Detection & Decay

> [!CAUTION]
> **Memory Drift Caveat:** "The memory says X exists" is NOT the same as "X exists now".
> Trước khi khuyên User dựa trên memory (VD: sửa file A), Agent PHẢI VERIFY bằng cách đọc file. Nếu memory sai lệch so với codebase hiện tại, hãy tin codebase và xoá/update memory đoạn đó.

### Memory Decay Rules

Memory KHÔNG có giá trị vĩnh viễn (đặc biệt `project` memory).

1. `user` & `reference`: **Không decay**. (Tên, role ít thay đổi).
2. `feedback`: **Decay chậm**. (Giảm confidence 0.1 mỗi 30 ngày nếu không được củng cố).
3. `project`: **Decay nhanh**. Sau 90 ngày tự chuyển thành `archived: true` trừ khi User confirm lại.

### Memory Maintenance Triggers

1. **Session Start (Step 1 — load_state):**
   Quét `entities.yaml`. Nếu có `project` memory > 180 ngày chưa update: Đánh hashtag cảnh báo `⚠️ Stale Memory` vào log.
2. **Weekly Review (`/project-status`):**
   Agent liệt kê active vs archived memories.
3. **Manual (`memory cleanup`):**
   Theo yêu cầu User để dọn các rule lỗi thời.

---

## Memory Retrieval Logic

**When to access memory:**
- Agent tự động xem xét `entities.yaml` ở đầu phiên để hiểu user context.
- MUST access memory nếu User explicitly nói "hãy nhớ...", "theo như lần trước...".
- **IGNORE CAVEAT:** Nếu User bảo "bỏ qua luật X", hãy làm việc như thể luật X CHƯA TỪNG TỒN TẠI trong memory. Đừng reply kiểu "Mặc dù luật X bảo thế nhưng theo ý bạn tôi sẽ...". Im lặng và tuân theo.

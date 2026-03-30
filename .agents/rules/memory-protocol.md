---
description: "Protocol quản lý bộ nhớ 3 tầng — Session, Brain, Entity."
---

# SKL_AGENT Memory Protocol

Agent cần "nhớ" để không xử lý mỗi task như người mới. Hệ thống memory 3 tầng:

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
│ Tier 3: Entity Memory                   │ ← Persistent, structured
│   User profiles, preferences, history   │
│   Storage: .agents/memory/entities.yaml │
└─────────────────────────────────────────┘
```

## Tier 1: Short-term (Session)

**Quản lý bởi:** Antigravity IDE session + Data Handoff files

**Nội dung:**
- Conversation context hiện tại
- Task state (đang làm gì, bước nào)
- Recent tool results

**Lifecycle:** Mất khi session kết thúc

**Persistence strategy:**
- Ghi trạng thái quan trọng ra `docs/` (theo Data Handoff Protocol)
- Session mới → đọc lại `docs/` để restore context
- Dùng `/compact` khi context quá dài

## Tier 2: Long-term (Brain)

**Quản lý bởi:** NotebookLM notebook (per-project)

**Nội dung:**
- Project specs, requirements
- Business rules, policies
- Domain knowledge
- Past decisions & rationale

**Lifecycle:** Persistent — tồn tại vĩnh viễn trong NotebookLM

**Operations:**
- Setup: `/brain-bootstrap`
- Sync: `/brain-sync`
- Query: Tự động theo `brain-connector.md`

## Tier 3: Entity Memory

**Quản lý bởi:** `.agents/memory/entities.yaml`

**Nội dung:**
- User profiles (tên, vai trò, preferences)
- Context notes (quy ước dự án, decisions)
- Interaction history (summary, không raw logs)

**Lifecycle:** Persistent trong project, version-controlled

**Khi nào cập nhật Entity Memory:**
1. User tự giới thiệu hoặc cung cấp thông tin cá nhân
2. Agent phát hiện pattern lặp lại (preferences)
3. User mention quy ước dự án chưa được ghi nhận
4. Kết thúc một task quan trọng (ghi summary)

**Cách cập nhật:**
- Agent THÊM entry mới vào `entities.yaml`
- KHÔNG xóa entries cũ (trừ khi User yêu cầu)
- Ghi rõ `source` và `date` cho mỗi entry

## Quy Trình Load Memory

```
Task nhận từ User
  → 1. Load entities.yaml (Tier 3) — biết User là ai
  → 2. Check brain.yaml — Brain có enabled không?
  → 3. Orchestrator classify intent
  → 4. Context Builder inject memory phù hợp
  → 5. Execute task
  → 6. Update entities.yaml nếu có info mới
```

## Anti-Patterns

```
❌ Nhớ tất cả mọi thứ → token bloat
❌ Không nhớ gì cả → mỗi lần như người mới
❌ Ghi raw conversation vào memory → quá dài, irrelevant
❌ Không ghi source/date → memory không verifiable
❌ Override entity memory không hỏi User
```

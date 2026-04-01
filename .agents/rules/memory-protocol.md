---
description: "Protocol quản lý bộ nhớ 3 tầng — Session, Brain, Entity — với decay, conflict resolution, confidence."
---

# SKL AGENT KIT Memory Protocol v2

Agent cần "nhớ" để không xử lý mỗi task như người mới. Hệ thống memory 3 tầng + decay + conflict resolution.

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

## Memory Confidence Scores

Mỗi memory item có confidence score:

| Confidence | Mô tả | Ví dụ |
|-----------|--------|-------|
| **1.0** | Verified fact | User tự cung cấp, docs chính thức |
| **0.8** | High confidence | Inferred từ nhiều interactions |
| **0.6** | Medium | Inferred từ 1-2 interactions |
| **0.4** | Low | Đoán từ context, chưa confirm |
| **< 0.3** | Unreliable | Cũ quá hoặc mâu thuẫn → nên xóa |

**Trong entities.yaml:**
```yaml
entities:
  - name: "thanhndp"
    role: "admin"
    confidence: 1.0    # User tự giới thiệu
    source: "user_provided"
    date: "2026-03-30"

  - preference: "thích output structured bảng"
    confidence: 0.8    # Thấy pattern lặp lại 3 lần
    source: "inferred"
    date: "2026-03-28"
```

## Memory Decay (Lão hóa)

Memory KHÔNG có giá trị vĩnh viễn — giảm dần theo thời gian:

```
decay_rules:

  time_decay:
    - < 7 ngày: weight × 1.0 (nguyên vẹn)
    - 7-30 ngày: weight × 0.8
    - 30-90 ngày: weight × 0.5
    - > 90 ngày: weight × 0.3
    - > 180 ngày: flag_for_cleanup

  exception_no_decay:
    - User identity (name, role) → không decay
    - Project conventions → không decay
    - Entries marked "permanent": true → không decay

  auto_cleanup:
    - confidence < 0.3 AND age > 90 ngày → archive
    - Mâu thuẫn với entry mới hơn → archive entry cũ
```

## Conflict Resolution

Khi memory items mâu thuẫn nhau:

```
conflict_resolution:

  strategy: prefer_recent_verified

  rules:
    1. Prefer recent over old (recency wins)
    2. Prefer verified source over inferred
    3. Prefer high confidence over low confidence
    4. If equal → ask User to clarify

  resolution_order:
    - user_explicit (User nói trực tiếp) → ALWAYS WINS
    - brain_verified (từ NotebookLM docs) → HIGH
    - user_inferred (Agent suy luận từ behavior) → MEDIUM
    - memory_old (entry > 30 ngày) → LOW
```

**Ví dụ conflict:**
```
Memory cũ: "User thích output dạng bullet list" (30 ngày trước)
Memory mới: "User yêu cầu output dạng bảng" (hôm nay)
→ Resolution: Cập nhật preference = "bảng", archive entry cũ
```

## Quy Trình Load Memory

```
Task nhận từ User
  → 1. Load entities.yaml (Tier 3) — biết User là ai
  → 2. Apply decay weights — data cũ weight thấp hơn
  → 3. Filter by relevance — chỉ lấy memory liên quan task
  → 4. Compress to bullet_insights — max 5 items
  → 5. Check brain.yaml — Brain có enabled không?
  → 6. Orchestrator classify intent
  → 7. Context Builder inject memory (với confidence scores)
  → 8. Execute task
  → 9. Update entities.yaml nếu có info mới
```

## Memory Selection cho Context

Không dump toàn bộ memory — lọc trước khi inject:

```
memory_selection:
  filter_by:
    - relevance_score >= 0.4
    - recency (prefer last 10 interactions)
    - importance (high > medium > low)
    - confidence >= 0.5

  compression:
    format: bullet_insights
    max_items: 5

  # Output ví dụ:
  # - User: thanhndp, admin (confidence: 1.0)
  # - Thích output structured/bảng (confidence: 0.8)
  # - Đang làm SKL AGENT KIT v3.0 (confidence: 1.0)
  # - Ưu tiên tiếng Việt cho reports (confidence: 0.6)
```

## Anti-Patterns

```
❌ Nhớ tất cả mọi thứ → token bloat
❌ Không nhớ gì cả → mỗi lần như người mới
❌ Ghi raw conversation vào memory → quá dài, irrelevant
❌ Không ghi source/date → memory không verifiable
❌ Override entity memory không hỏi User
❌ Tin memory cũ hơn data mới → stale decisions
❌ Không có confidence score → treat mọi memory ngang nhau
```

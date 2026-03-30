---
description: "Phân tầng knowledge — Static (Brain) vs Dynamic (Tools) vs Personal (Memory)."
---

# SKL_AGENT Knowledge Tiers

Agent truy cập knowledge từ 3 nguồn khác nhau. Mỗi nguồn có đặc điểm riêng — KHÔNG dùng thay thế lẫn nhau.

## 3 Tầng Knowledge

| Tier | Tên | Chứa gì | Nguồn | Cập nhật |
|------|-----|---------|-------|----------|
| **Tier 1** | Static Knowledge | Policies, specs, handbook, domain logic | NotebookLM Brain | Manual (`/brain-sync`) |
| **Tier 2** | Dynamic Data | Records, metrics, realtime status | MCP Tools, APIs, Files | Realtime (tool calls) |
| **Tier 3** | Personal Context | User identity, preferences, history | Entity Memory (YAML) | Auto (during interactions) |

## Quy Tắc Sử Dụng

### Tier 1: Static Knowledge (Brain)
**Dùng khi:** Agent cần "hiểu" — quy định, cách làm, chuẩn đánh giá, policy

```
✅ "Quy trình xử lý X theo chuẩn nào?"
✅ "Chính sách Y quy định ra sao?"
✅ "Giải thích concept Z"

❌ KHÔNG dùng Brain cho: số liệu realtime, trạng thái hiện tại, data cá nhân
```

**Trust level:** HIGH — Authoritative source, đã được verify

### Tier 2: Dynamic Data (Tools)
**Dùng khi:** Agent cần "sự thật hiện tại" — số liệu, trạng thái, dữ liệu mới nhất

```
✅ "Tổng doanh thu tháng này?"
✅ "File X có nội dung gì?"
✅ "Trạng thái deploy hiện tại?"

❌ KHÔNG dùng Tools cho: giải thích policy, domain knowledge, best practices
```

**Trust level:** HIGH — Source of truth, realtime

### Tier 3: Personal Context (Entity Memory)
**Dùng khi:** Agent cần "personalize" — biết user là ai, thói quen, lịch sử

```
✅ "User này thích output format nào?"
✅ "Lần trước chúng ta đã quyết định gì?"
✅ "Quy ước đặt tên trong project này?"

❌ KHÔNG dùng Memory cho: authoritative knowledge, realtime data
```

**Trust level:** MEDIUM — May be outdated, user-provided

## Decision Matrix

Khi Agent gặp câu hỏi, chọn tier phù hợp:

| Câu hỏi có từ khóa | Tier |
|---------------------|------|
| "theo quy định", "policy", "chuẩn", "spec" | **Tier 1** (Brain) |
| "hiện tại", "số liệu", "data", "file nào" | **Tier 2** (Tools) |
| "lần trước", "tôi thích", "quy ước project" | **Tier 3** (Memory) |
| Kết hợp nhiều loại | **Multi-tier** (theo Context Builder) |

## Nguyên Tắc Vàng

> **Brain cho "hiểu" — Tools cho "biết" — Memory cho "nhớ"**

1. KHÔNG dùng Brain thay database — Brain là knowledge, không phải data store
2. KHÔNG dùng Tools thay Brain — API cho facts, Brain cho interpretation
3. KHÔNG dùng Memory thay Brain — Memory là personal, Brain là authoritative
4. Khi conflict giữa tiers → xem Conflict Resolution trong `context-builder.md`

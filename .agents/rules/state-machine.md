---
description: "State Machine — quản lý trạng thái Agent cho long-running sessions."
---

# SKL_AGENT State Machine

Agent KHÔNG phải stateless. Với các session dài (nhiều task liên tiếp), Agent cần biết mình đang ở trạng thái nào.

## States

```
┌──────────┐   user_input   ┌──────────────┐
│          │───────────────→│              │
│   idle   │                │  processing  │
│          │←───────────────│              │
└──────────┘   task_done    └──────┬───────┘
                                   │
                          need_confirmation
                                   │
                                   ▼
                            ┌──────────────┐
                            │   waiting    │
                            │   _user     │
                            └──────┬───────┘
                                   │
                              confirmed / rejected
                                   │
                    ┌──────────────┴──────────────┐
                    ▼                              ▼
             ┌──────────────┐              ┌──────────────┐
             │  executing   │              │    idle      │
             │              │              │  (rejected)  │
             └──────┬───────┘              └──────────────┘
                    │
               execution_done
                    │
                    ▼
             ┌──────────────┐
             │   idle       │
             │  (completed) │
             └──────────────┘
```

## State Definitions

| State | Mô tả | Agent đang làm gì |
|-------|--------|--------------------|
| `idle` | Chờ input | Sẵn sàng nhận task mới |
| `processing` | Đang xử lý | Classify intent → build plan → build context |
| `waiting_user` | Chờ User confirm | Đã hỏi confirmation, chờ response |
| `executing` | Đang thực thi | Chạy tool calls, ghi files, gửi requests |

## Transitions

| From | Event | To | Actions |
|------|-------|----|---------|
| `idle` | `user_input` | `processing` | Load state, classify intent |
| `processing` | `plan_ready` | `executing` | (nếu không cần confirm) |
| `processing` | `need_confirmation` | `waiting_user` | Hiển thị preview + hỏi confirm |
| `waiting_user` | `user_confirmed` | `executing` | Tiếp tục execution plan |
| `waiting_user` | `user_rejected` | `idle` | Log rejection, reset |
| `waiting_user` | `user_modified` | `processing` | Re-process với input mới |
| `executing` | `execution_done` | `idle` | Update memory, log feedback |
| `executing` | `execution_error` | `waiting_user` | Thông báo lỗi + hỏi retry |
| `executing` | `need_more_info` | `waiting_user` | Hỏi clarification mid-execution |

## State Persistence

State được lưu implicit qua:

1. **Session context** — Antigravity IDE giữ conversation state
2. **Data Handoff files** — `docs/` chứa progress artifacts
3. **Entity memory** — `.agents/memory/entities.yaml` chứa history

Khi session mới bắt đầu:
```
1. Load entities.yaml → biết User là ai, task gần nhất
2. Check docs/ → có pending work không?
3. If pending → resume from last state
4. If clean → start from idle
```

## Multi-step State Tracking

Với execution plan nhiều bước:

```
plan:
  - step_1: analyze     ← ✅ done
  - step_2: recommend   ← ✅ done
  - step_3: confirm     ← ⏳ waiting_user (ĐANG Ở ĐÂY)
  - step_4: execute     ← ⬜ pending
  - step_5: log         ← ⬜ pending
```

Agent phải biết đang ở step nào. Nếu bị interrupt (quota hết, session timeout):
- Ghi progress vào `docs/task-progress.md` (Data Handoff)
- Session mới → đọc lại → resume từ step bị dừng

## Khi Nào Chuyển State

| Tình huống | Chuyển sang |
|-----------|-------------|
| User gửi tin nhắn mới | `idle` → `processing` |
| Agent cần xác nhận xóa file | `processing` → `waiting_user` |
| User nói "ok, làm đi" | `waiting_user` → `executing` |
| User nói "không, hủy" | `waiting_user` → `idle` |
| Tool call trả về kết quả | `executing` → next step hoặc `idle` |
| Agent gặp lỗi runtime | `executing` → `waiting_user` (hỏi retry) |
| Agent hết context (compact) | Ghi state → restart processing |

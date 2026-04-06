# 🏗️ SKL AGENT KIT Architecture

> Tài liệu giải thích **repo này hoạt động ra sao**, dùng với gì, và cơ chế bên trong.

---

## 📌 Repo này là gì?

SKL AGENT KIT **KHÔNG phải** một ứng dụng chạy độc lập. Nó là **bộ cấu hình (config layer)** cho AI IDE — biến AI coding assistant thành một Agent có:
- Bộ nhớ (Memory)
- Quy trình xử lý (Execution Engine)
- An toàn (Guardrails)
- Phản hồi (Feedback Loop)

### Tương tự

| Khái niệm | Ví dụ |
|-----------|-------|
| SKL AGENT KIT | Như `.eslintrc` cho ESLint — rules, không phải code |
| AI IDE | Như ESLint runtime — đọc rules và thực thi |
| Kết hợp | AI IDE + SKL AGENT KIT = Agent chạy theo rules bạn định nghĩa |

---

## 🔌 Hoạt động với AI IDE nào?

### Primary: Antigravity IDE (v4.0.4+)
- **Cơ chế:** Antigravity đọc thư mục `.agents/` tại project root
- **Rules:** Files trong `.agents/rules/` → Agent tuân thủ như system instructions
- **Config:** Files trong `.agents/config/` → Cấu hình behavior (model, routing, budget)
- **Runtime:** Files trong `.agents/runtime/` → Pipeline definition
- **Skills:** `.agents/skills/` → Loaded tự động khi match project type
- **Workflows:** `.agents/workflows/` → Slash commands (`/brain-bootstrap`, `/skill-generate`...)

### Compatible: Cursor, Windsurf, Claude Code
- Các IDE này đọc `.cursorrules`, `.windsurfrules`, hoặc `.claude/`
- SKL AGENT KIT có thể adapt bằng cách:
  1. Export rules sang format IDE target (`/skill-export`)
  2. Hoặc copy nội dung `.agents/rules/` vào file rules của IDE đó

### Không tương thích với:
- Standalone Python/Node.js runtime (không có interpreter riêng)
- IDE không hỗ trợ custom instructions

---

## 🧠 Cơ Chế Hoạt Động

### 1. Boot Sequence (Khi mở project)

```
AI IDE khởi động
  → Scan project root
  → Phát hiện .agents/
  → Load rules/ (system instructions)
  → Load config/ (behavior settings)
  → Load runtime/ (pipeline definition)
  → Agent sẵn sàng nhận task
```

### 2. Task Processing (Khi User gửi request)

```
User Input: "Phân tích điểm rồi tạo báo cáo"

[Execution Engine Pipeline - 12 Steps]

Step 1:  Load State
         → Đọc state-machine.md → Agent đang ở trạng thái nào?
         → Có task dở dang không? (check docs/task-progress.md)

Step 2:  Load Instructions
         → instruction-layer.md: Safety > Identity > Capability > Task
         → Agent "nhớ" mình là ai, được làm gì

Step 3:  Pre-check
         → Context đủ chưa? Cần tool gì? Sensitive không?

Step 4:  Classify Intent (multi-label)
         → "Phân tích" = analysis
         → "Tạo báo cáo" = action_request
         → confidence: 0.9
         → [Observability logs classification]

Step 5:  Build Plan
         → Template: analyze_then_execute
         → Steps: [read_data, analyze, create_report]
         → [Human Loop checks: cần confirm không?]

Step 6:  Select Capabilities
         → analyze + create → chain: analyze_then_create
         → [Cost Control: chọn model phù hợp]

Step 7:  Build Context
         → Adaptive budget: analysis → Brain 40%, Tools 30%
         → Dedup, filter memory, compress
         → [Cache check: có cached context không?]

Step 8:  Guardrails Pre
         → safety-guard: không vi phạm /freeze?
         → permission-guard: có quyền đọc data?

Step 9:  Execute
         → Chạy từng step trong plan
         → [Error Handling wraps: retry on failure]
         → [Cache saves results]
         → [Observability logs metrics]

Step 10: Guardrails Post
         → Output có chứa sensitive data không?
         → Format đúng output contract?

Step 11: Update State + Memory
         → State: processing → idle
         → Entity memory: lưu info mới về User

Step 12: Log + Feedback
         → Ghi entry vào docs/agent-log.md
         → Hỏi feedback nếu task quan trọng
         → [Closed-loop: feedback ảnh hưởng routing tương lai]
```

### 3. Knowledge Flow

```
                    ┌──────────────────┐
                    │   User Request   │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │   Orchestrator   │
                    │  (Classify + Plan)│
                    └────────┬─────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
     ┌────────▼───────┐ ┌───▼────┐ ┌───────▼────────┐
     │  Tier 1: Brain │ │ Tier 2 │ │  Tier 3: Entity│
     │  (NotebookLM)  │ │ Tools  │ │    Memory      │
     │                │ │  APIs  │ │                │
     │  "Hiểu"       │ │ "Biết" │ │   "Nhớ"        │
     │  Policy, specs │ │ Data,  │ │  User prefs,   │
     │  Domain logic  │ │ Files  │ │  History       │
     └────────┬───────┘ └───┬────┘ └───────┬────────┘
              │              │              │
              └──────────────┼──────────────┘
                             │
                    ┌────────▼─────────┐
                    │  Context Builder │
                    │  (Merge + Rank)  │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │     Execute      │
                    └──────────────────┘
```

---

## 📁 File Map

### Config Layer (WHAT — cấu hình gì)
```
.agents/config/
├── model-routing.yaml      # Model nào cho task nào (tier mapping)
├── capabilities.yaml       # Agent làm được gì
├── cost-control.yaml       # Budget bao nhiêu
├── security-modes.yaml     # 3 chế độ bảo mật (agile/standard/paranoid)
├── brain.yaml              # Brain kết nối ở đâu
├── agents.yaml             # Multi-agent setup
└── webhooks.yaml           # External integrations
```

### Rules Layer (HOW — làm thế nào)
```
.agents/rules/
├── orchestrator.md         # Classify intent + build plan
├── instruction-layer.md    # 4 lớp instruction priorities
├── state-machine.md        # Agent states + transitions
├── context-builder.md      # Build context pipeline
├── brain-connector.md      # Query Brain logic
├── memory-protocol.md      # Memory decay + conflict
├── knowledge-tiers.md      # Knowledge source priority
├── permission-guard.md     # Data access control
├── feedback-logger.md      # Log + learn from feedback
├── error-handling.md       # Retry + fallback logic
├── human-loop.md           # Confirmation triggers
├── safety-guard.md         # Safety constraints
├── data-handoff.md         # Agent communication protocol
├── coding-standards.md     # Code quality rules
└── skill-development.md    # How to create skills
```

### Runtime Layer (WHEN — chạy khi nào)
```
.agents/runtime/
├── execution-engine.yaml   # 12-step pipeline definition
├── observability.yaml      # Metrics + log points
└── cache.yaml              # Cache layers + TTL
```

### Data Layer (WHO — về ai)
```
.agents/memory/
└── entities.yaml           # User profiles, preferences
```

---

## ⚠️ Limitations

1. **Không phải standalone runtime** — Cần AI IDE để interpret rules
2. **Rules là "instructions", không phải "code"** — AI IDE đọc và tuân thủ, nhưng không enforce 100%
3. **Test = manual verification** — Không có unit tests; validate bằng test scenarios
4. **Single-user focus** — Thiết kế cho 1 developer/team, không phải multi-tenant SaaS
5. **Antigravity-specific features** — 580+ global skills chỉ có trên Antigravity IDE

---

## 🎯 Design Principles

1. **Config over Code** — Thay đổi behavior bằng YAML/MD, không compile
2. **Hook, Don't Fork** — Plugins hook vào pipeline, không sửa core
3. **Fail Gracefully** — Mất 1 layer → Agent vẫn chạy (degraded mode)
4. **Closed-loop** — Feedback → adjust → improve (không one-shot)
5. **Education-first** — Guards và rules thiết kế cho domain trường học

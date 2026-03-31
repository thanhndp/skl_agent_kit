# 🧠 SKL_AGENT — AI Framework Template

> **Phiên bản:** 3.5 · Cập nhật: 2026-03-31
> Bộ khung AI Orchestration dùng cho mọi dự án **Data Pipeline** hoặc **App Development**.

`skl_agent` đóng gói Best Practices từ các hệ thống Agent hàng đầu (Antigravity SDK, Gstack, AutoResearchClaw, Skill Generator) thành một **template scaffolding** dùng lại cho mọi dự án.

---

## ✨ Điểm nổi bật

| Tính năng | Mô tả |
|-----------|-------|
| 🎯 **Execution Engine** | Runtime pipeline 12 bước — mọi task đi qua pre-check → classify → plan → execute → feedback |
| 🧩 **Multi-intent Orchestration** | Phân loại nhiều intent cùng lúc + confidence scoring + execution plan |
| 🔄 **Cascade Fallback** | API hết quota → tự động fallback Model thấp hơn · Tool fail → fallback Brain → Local |
| 📐 **Instruction Layer** | 4 lớp instruction (Safety → Identity → Capability → Task) — Agent không "trôi vai" |
| 🔗 **Capability Composition** | 7 chain patterns — Agent chain nhiều capabilities cho multi-step tasks |
| 📋 **Artifact Data Handoff** | Agent giao tiếp qua Data Specs (không truyền miệng → giảm ảo giác AI) |
| 🛡️ **Inline Guardrails** | Safety checks gắn trực tiếp vào execution flow — không kiểm cuối cùng |
| 🔌 **NotebookLM MCP** | 33 tools tiếng Việt, multi-account, Deep Research, podcast/video/slides |
| 🧠 **Brain Architecture** | NotebookLM = Long-Term Memory · Antigravity = Active Processor → Closed-loop |
| 💾 **Memory 3 Tầng** | Session + Brain + Entity — với confidence scores, decay, conflict resolution |
| 🔁 **Closed-loop Feedback** | Negative feedback → adjust routing · Positive → reinforce patterns |
| ⚙️ **State Machine** | Agent có states (idle/processing/waiting/executing) — không mất track |
| 📊 **Observability** | 6 metrics (intent accuracy, tool success, tokens, fallback rate) + 5 log points |
| 💰 **Cost Control** | Dynamic token budget by intent + cheapest sufficient model selection |
| 📦 **Cache** | 3-layer cache (query/tool/context) — giảm 50-80% cost cho queries lặp lại |
| 🔧 **Error Handling** | Retry 2x + 4 fallback chains + graceful degradation matrix |
| 👤 **Human-in-the-Loop** | Education guards: confirm trước khi sửa điểm, gửi PH, xóa file |

---

## 🚀 Cài Đặt Nhanh

### Bước 1: Clone

```bash
git clone https://github.com/thanhndp/skl_agent.git .
```

### Bước 2: Khởi tạo cấu trúc

```bash
# Windows
setup.bat

# Linux/Mac
./setup.sh
```

Hệ thống phỏng vấn 1 câu hỏi để cấu hình thư mục:

| Chọn | Loại Project | Thư mục tạo ra |
|------|-------------|-----------------|
| `1` | **Data Pipeline** | `1_input/` (READ-ONLY), `2_process/`, `3_output/` |
| `2` | **App Development** | `src/`, `docs/`, `tests/` |

### Bước 3: Gọi AI Agent

Mở IDE tại thư mục gốc → gọi Agent (ví dụ: `antigravity`) để bắt đầu làm việc.

---

## 🔌 Cài Đặt NotebookLM MCP (Tùy chọn)

SKL_AGENT đi kèm **NotebookLM MCP Hybrid v1.0** — cho phép AI Agent kết nối trực tiếp với Google NotebookLM.

**Tính năng:** 🇻🇳 33 tools tiếng Việt · 👥 Multi-Account · 🎧 Tạo podcast/video/slides · 🔎 Deep Research

```bash
# 1. Giải nén & cài đặt
# Windows PowerShell:
Expand-Archive -Path libs\notebooklm-mcp-hybrid-v1.0.zip -DestinationPath libs\notebooklm-mcp-hybrid
cd libs\notebooklm-mcp-hybrid
pip install -e .

# 2. Xác thực Google
notebooklm-mcp-auth

# 3. Reload IDE → Test: "Liệt kê notebooks của tôi"
```

---

## 🧠 Brain Architecture (Long-Term Memory)

Biến NotebookLM thành **"Bộ nhớ dài hạn"** cho mỗi project — Agent tự động tham vấn knowledge trước khi xử lý task.

```
User Task → Agent → Cần domain knowledge?
                        ├── CÓ → MCP query Brain → Xử lý với grounded context
                        └── KHÔNG → Xử lý trực tiếp
```

**Setup Brain cho project:**
```bash
/brain-bootstrap    # Tạo notebook Brain + nạp knowledge + chọn mode
```

**2 chế độ tham vấn:**

| Mode | Hành vi |
|------|--------|
| `auto` | Agent tự query Brain khi gặp trigger — không hỏi User |
| `ask` | Agent hỏi User trước mỗi lần query — User quyết định |

---

## ⚙️ Execution Engine (v3.5)

Mọi task đi qua pipeline 12 bước:

```
User Input
  → [1]  Load State (state-machine)
  → [2]  Load Instructions (instruction-layer)
  → [3]  Pre-check (context đủ? cần tool? sensitive?)
  → [4]  Classify Intent — multi-label + confidence
  → [5]  Build Execution Plan (multi-step)
  → [6]  Select + Compose Capabilities
  → [7]  Build Context — adaptive budget + dedup
  → [8]  Guardrails Pre (safety + permission)
  → [9]  Execute Steps — with checkpoints
  → [10] Guardrails Post (data leak check)
  → [11] Update State + Memory
  → [12] Log + Feedback Loop
```

> 📖 Chi tiết: [execution-engine.yaml](.agents/runtime/execution-engine.yaml)

### Hooks Layer (5 Plugins)

Các plugin hook vào pipeline mà **không sửa core**:

```
Execution Engine (core pipeline)
    ↓
[Hooks Layer]
  ├── 📊 Observability  → steps 4, 5, 7, 9, 12
  ├── 📦 Cache          → trước step 9
  ├── 💰 Cost Control   → step 6
  ├── 🔧 Error Handling → wrap step 9
  └── 👤 Human Loop     → step 5 → 9
    ↓
Capabilities + Tools + Brain
```

| Plugin | File | Chức năng |
|--------|------|-----------|
| Observability | `runtime/observability.yaml` | Track metrics, log decisions |
| Cache | `runtime/cache.yaml` | Cache Brain queries + tool results (TTL-based) |
| Cost Control | `config/cost-control.yaml` | Dynamic budget, model selection by intent |
| Error Handling | `rules/error-handling.md` | Retry + fallback + graceful degradation |
| Human Loop | `rules/human-loop.md` | Confirm trước action nhạy cảm (edu context) |

---

## 🛠 Nâng Cấp Tự Động

```bash
# Windows
update.bat

# Linux/Mac
./update.sh
```

Script tự động `git pull` để lấy thay đổi mới nhất, **chỉ cập nhật** thư mục bộ não `.agents/` — code `src/` của bạn không bị ảnh hưởng.

---

## 📦 Cấu Trúc Dự Án

```
SKL_AGENT/
├── .agents/                       # 🧠 Bộ não AI
│   ├── config/
│   │   ├── model-routing.yaml     # Dynamic Routing (Tier 1→4) + notifications
│   │   ├── brain.yaml             # Brain config (NotebookLM)
│   │   ├── capabilities.yaml     # 🔗 7 capabilities + composition engine
│   │   ├── cost-control.yaml     # 💰 Dynamic budget + model selection
│   │   ├── webhooks.yaml         # n8n/automation bridge
│   │   └── agents.yaml           # Multi-agent config
│   ├── runtime/                   # ⚙️ Engine + Plugins
│   │   ├── execution-engine.yaml # Central pipeline (12 steps)
│   │   ├── observability.yaml   # 📊 Metrics + log points
│   │   └── cache.yaml           # 📦 3-layer cache (query/tool/context)
│   ├── rules/                     # 15 quy tắc Agent tuân thủ
│   │   ├── orchestrator.md       # Multi-intent + execution plan
│   │   ├── instruction-layer.md  # 4-priority instruction system
│   │   ├── state-machine.md      # Agent state transitions
│   │   ├── context-builder.md    # Adaptive budget + dedup + ranking
│   │   ├── brain-connector.md     # Brain query rules (auto/ask/off)
│   │   ├── memory-protocol.md    # Memory decay + conflict + confidence
│   │   ├── knowledge-tiers.md    # Static/Dynamic/Personal + fallback
│   │   ├── permission-guard.md   # Data protection 3 lớp
│   │   ├── feedback-logger.md    # Closed-loop feedback
│   │   ├── error-handling.md     # 🔧 Retry + fallback + degradation
│   │   ├── human-loop.md         # 👤 Confirm cho action nhạy cảm
│   │   ├── safety-guard.md        # /freeze, /careful, READ-ONLY
│   │   ├── data-handoff.md        # No File No Trust
│   │   ├── coding-standards.md
│   │   └── skill-development.md
│   ├── memory/                    # Entity Memory
│   │   └── entities.yaml         # User profiles, context notes
│   ├── skills/
│   │   ├── excel-professional/
│   │   └── viet-chuyen-nghiep/
│   └── workflows/                 # 13 slash commands
│       ├── brain-bootstrap.md     # /brain-bootstrap
│       ├── brain-sync.md          # /brain-sync
│       ├── best-practices.md      # /best-practices
│       ├── load-skills.md         # /load-skills
│       ├── project-status.md      # /project-status
│       └── skill-*.md             # /skill-generate, audit...
├── libs/
│   └── notebooklm-mcp-hybrid-v1.0.zip
├── setup.bat / setup.sh
├── update.bat / update.sh
└── README.md
```

---

## 📘 Kho Kỹ Năng (Skills)

### Skills đi kèm

| Skill | Mô tả |
|-------|--------|
| `excel-professional` | Xử lý `.xlsx` chuẩn doanh nghiệp — tạo bảng, báo cáo, phân tích dữ liệu |
| `viet-chuyen-nghiep` | Viết và format nội dung tiếng Việt chuẩn ngữ pháp |

### Skills toàn cục (từ Antigravity IDE)

| Skill | Mô tả |
|-------|--------|
| `auto-model-selector` | Tự động cân bằng chi phí/độ phức tạp khi chọn Model LLM |
| `intelligent-routing` | Auto-assign task cho đúng chuyên gia AI |
| 580+ skills khác | Xem đầy đủ qua `/project-status` |

### Thêm/tạo Skill mới

```bash
/skill-generate    # Tạo qua phỏng vấn AI 5 Phase
/skill-scaffold    # Tạo skeleton nhanh
```

---

## ⚡ Slash Commands

### 🧠 Brain Commands

| Command | Mô tả |
|---------|-------|
| `/brain-bootstrap` | Tạo NotebookLM Brain cho project + nạp knowledge + chọn mode |
| `/brain-sync` | Đồng bộ docs/URLs/text mới vào Brain |

### 🔧 Project Commands

| Command | Mô tả |
|---------|-------|
| `/best-practices` | Tra cứu best practices |
| `/load-skills` | Nạp skill theo loại dự án |
| `/project-status` | Xem tổng quan dự án |

### 📦 Skill Commands

| Command | Mô tả |
|---------|-------|
| `/skill-generate` | Tạo skill mới (phỏng vấn 5 Phase) |
| `/skill-scaffold` | Tạo skeleton skill nhanh |
| `/skill-validate` | Kiểm tra SKILL.md hợp lệ |
| `/skill-audit` | Audit skill theo 7 nguyên tắc |
| `/skill-compare` | So sánh 2 phiên bản skill |
| `/skill-export` | Export skill ra nền tảng khác |
| `/skill-simulate` | Mô phỏng chạy thử skill |
| `/skill-stats` | Xem thống kê & Cognitive Load |

---

## 📖 Tài Liệu

### Core

| Tài liệu | Nội dung |
|-----------|----------|
| [Execution Engine](.agents/runtime/execution-engine.yaml) | Central pipeline 12 bước |
| [Orchestrator](.agents/rules/orchestrator.md) | Multi-intent + execution plan + guardrails |
| [Instruction Layer](.agents/rules/instruction-layer.md) | 4-priority instruction system |
| [State Machine](.agents/rules/state-machine.md) | Agent state transitions |
| [Context Builder](.agents/rules/context-builder.md) | Adaptive budget + dedup + ranking |
| [Brain Connector](.agents/rules/brain-connector.md) | Brain query rules (auto/ask/off) |
| [Memory Protocol](.agents/rules/memory-protocol.md) | Decay + conflict + confidence |
| [Knowledge Tiers](.agents/rules/knowledge-tiers.md) | Static/Dynamic/Personal + fallback |
| [Capabilities](.agents/config/capabilities.yaml) | 7 capabilities + composition engine |
| [Feedback Logger](.agents/rules/feedback-logger.md) | Closed-loop feedback |
| [Safety Guard](.agents/rules/safety-guard.md) | /freeze, /careful, READ-ONLY |
| [Model Routing](.agents/config/model-routing.yaml) | Dynamic Model Selection (Tier 1→4) |

### Plugins (v3.5)

| Tài liệu | Nội dung |
|-----------|----------|
| [Observability](.agents/runtime/observability.yaml) | 6 metrics + 5 log points |
| [Cache](.agents/runtime/cache.yaml) | 3-layer cache (query/tool/context) |
| [Cost Control](.agents/config/cost-control.yaml) | Dynamic budget + model selection |
| [Error Handling](.agents/rules/error-handling.md) | Retry + 4 fallback chains |
| [Human Loop](.agents/rules/human-loop.md) | Education-specific confirm guards |

---

## 📝 Changelog

### v3.5 (2026-03-31)
**Core:**
- 🆕 Execution Engine — central runtime pipeline (12 steps)
- 🆕 Instruction Layer — 4 lớp chống trôi vai
- 🆕 State Machine — agent states + transitions
- ⬆️ Orchestrator v2 — multi-intent, confidence, execution plan
- ⬆️ Context Builder v2 — adaptive budget, dedup, weighted ranking
- ⬆️ Capabilities v2 — output contracts, composition engine
- ⬆️ Memory Protocol v2 — decay, conflict resolution, confidence
- ⬆️ Knowledge Tiers v2 — cascading fallback logic
- ⬆️ Feedback Logger v2 — closed-loop feedback
- ⬆️ Model Routing — model switch notifications

**Plugins:**
- 🆕 Observability — 6 metrics + 5 log points hooked vào pipeline
- 🆕 Cache — 3-layer cache (query/tool/context), giảm 50-80% cost
- 🆕 Cost Control — dynamic token budget + cheapest sufficient model
- 🆕 Error Handling — retry 2x + 4 fallback chains + graceful degradation
- 🆕 Human-in-the-Loop — education guards cho student data, parent comms

### v3.0 (2026-03-30)
- Brain Architecture (NotebookLM integration)
- Orchestrator Layer + Context Builder
- Memory 3 tầng + Entity Memory
- Permission Guard + Feedback Logger
- NotebookLM MCP Hybrid v1.0

### v2.0 (2026-03-28)
- Dynamic Model Routing (Tier 1→4)
- Safety Guards + Data Handoff
- Skills system + Workflows

---

## 📝 License

Private template — Được xây dựng bởi **thanhndp** @ Skyline School.

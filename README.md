# 🧠 SKL AGENT KIT — AI Framework Template

> **Phiên bản:** 4.0 · Cập nhật: 2026-04-06
> Bộ khung AI Orchestration dùng cho mọi dự án **Data Pipeline** hoặc **App Development**.

`skl_agent_kit` đóng gói Best Practices từ các hệ thống Agent hàng đầu (Antigravity SDK, Gstack, AutoResearchClaw, Skill Generator) thành một **template scaffolding** dùng lại cho mọi dự án.

---

## ⚡ TL;DR — Bắt Đầu Trong 2 Phút

```bash
# 1. Clone
git clone https://github.com/thanhndp/skl_agent_kit.git .

# 2. Setup (chọn Data Pipeline hoặc App Dev)
setup.bat          # Windows
./setup.sh         # Mac/Linux

# 3. Khởi động AI
antigravity        # 🚀 Triệu hồi Antigravity IDE (Mặc định)
/onboard           # 🆕 Bắt đầu Socratic Interview để cài đặt Profile
/project-status    # Xem tổng quan
/brain-bootstrap   # Kết nối Brain
```

> **Bạn chưa có Antigravity?** Bạn cũng có thể mở thư mục này bằng AI Editor khác như Cursor hoặc Windsurf và copy prompt mà script `setup` vừa tạo vào chat.

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
| 🆕 **Socratic Onboarding** | Tự phân loại User profile (Beginner/Intermediate/Expert) + hướng dẫn thích ứng |
| 🗜️ **Context Compressor** | Auto-detect context bloat → nén bằng summarization, artifact reference, memory offloading |
| 🚀 **Multi-Agent Workers** | `/spawn-workers` — phân tách task thành N worker song song qua CMD |

---

## 🚀 Cài Đặt Nhanh

### Bước 1: Clone

```bash
git clone https://github.com/thanhndp/skl_agent_kit.git .
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

Mở IDE tại thư mục gốc → gọi Agent (ví dụ: `antigravity`, Cursor, Windsurf) để bắt đầu làm việc.

> [!TIP]
> **Tự động kích hoạt toàn diện:** Repo đã được tích hợp sẵn các file rule toàn cục (`.cursorrules`, `.windsurfrules`, `.antigravityrules`, `.clauderules`). Ngay sau khi clone repo và mở dự án, IDE của bạn sẽ **tự động** đọc toàn bộ cấu hình lõi trong thư mục `.agents/` (bao gồm model routing, an toàn, execution engine) vào bộ nhớ hệ thống.
> 
> **Chế độ thủ công (Tùy chọn):** Nếu muốn AI hệ thống lại toàn bộ trạng thái dự án hoặc nạp kịch bản làm việc đặc biệt trọn vẹn ở session chat đầu tiên, bạn có thể chạy lệnh:
> `/project-status` hoặc `/load-skills`

---

## 🔌 Cài Đặt NotebookLM MCP (Tùy chọn)

SKL AGENT KIT đi kèm **NotebookLM MCP Hybrid v1.0** — cho phép AI Agent kết nối trực tiếp với Google NotebookLM.

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

## ⚙️ Execution Engine (v4.0)

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
SKL_AGENT_KIT/
├── .agents/                       # 🧠 Bộ não AI
│   ├── config/                    # ⚙️ 8 config files
│   │   ├── model-routing.yaml     # Dynamic Routing (Tier 1→4) + notifications
│   │   ├── brain.yaml             # Brain config (NotebookLM)
│   │   ├── capabilities.yaml      # 🔗 7 capabilities + composition engine
│   │   ├── cost-control.yaml      # 💰 Dynamic budget + model selection
│   │   ├── profiles.yaml          # 👤 User profiles (beginner/intermediate/expert)
│   │   ├── security-modes.yaml    # 🔒 Security modes by profile
│   │   ├── webhooks.yaml          # n8n/automation bridge
│   │   └── agents.yaml            # Multi-agent config
│   ├── runtime/                   # ⚙️ Engine + Plugins
│   │   ├── execution-engine.yaml  # Central pipeline (12 steps)
│   │   ├── observability.yaml     # 📊 Metrics + log points
│   │   └── cache.yaml             # 📦 3-layer cache (query/tool/context)
│   ├── rules/                     # 📏 17 quy tắc Agent tuân thủ
│   │   ├── orchestrator.md        # Multi-intent + execution plan
│   │   ├── instruction-layer.md   # 4-priority instruction system
│   │   ├── state-machine.md       # Agent state transitions
│   │   ├── context-builder.md     # Adaptive budget + dedup + ranking
│   │   ├── context-compressor.md  # 🆕 Auto context compression
│   │   ├── brain-connector.md     # Brain query rules (auto/ask/off)
│   │   ├── memory-protocol.md     # Memory decay + conflict + confidence
│   │   ├── knowledge-tiers.md     # Static/Dynamic/Personal + fallback
│   │   ├── permission-guard.md    # Data protection 3 lớp
│   │   ├── feedback-logger.md     # Closed-loop feedback
│   │   ├── error-handling.md      # 🔧 Retry + fallback + degradation
│   │   ├── human-loop.md          # 👤 Confirm cho action nhạy cảm
│   │   ├── onboarding.md          # 🆕 Socratic Onboarding Protocol
│   │   ├── safety-guard.md        # /freeze, /careful, READ-ONLY
│   │   ├── data-handoff.md        # No File No Trust + PII Scan
│   │   ├── coding-standards.md    # Code quality + Windows .bat rules
│   │   └── skill-development.md   # 7 Nguyên tắc Skill hoàn hảo
│   ├── memory/                    # Entity Memory
│   │   └── entities.yaml          # User profiles, context notes
│   ├── skills/                    # 🧩 2 built-in skills
│   │   ├── excel-professional/    # Xử lý Excel chuẩn doanh nghiệp
│   │   └── viet-chuyen-nghiep/    # Viết tiếng Việt chuyên nghiệp
│   ├── templates/                 # 📐 Code templates
│   │   └── base_parallel_engine.py
│   └── workflows/                 # 📋 16 slash commands
│       ├── brain-bootstrap.md     # /brain-bootstrap
│       ├── brain-sync.md          # /brain-sync
│       ├── best-practices.md      # /best-practices
│       ├── data-ingest.md         # 🆕 /data-ingest
│       ├── data-process.md        # 🆕 /data-process
│       ├── load-skills.md         # /load-skills
│       ├── project-status.md      # /project-status
│       ├── spawn-workers.md       # 🆕 /spawn-workers
│       └── skill-*.md             # 8 skill lifecycle commands
├── docs/
│   ├── architecture/
│   │   ├── adr-001-config-over-code.md    # Config-over-Code philosophy
│   │   ├── adr-002-notebooklm-memory.md   # NotebookLM as Long-Term Memory
│   │   └── adr-003-single-user-focus.md   # Single-User focus design
│   └── skill_extension_integration_guide.md
├── libs/
│   └── notebooklm-mcp-hybrid-v1.0.zip
├── tests/
│   ├── check_refs.py
│   ├── validate_config.py
│   └── simulation.md
├── setup.bat / setup.sh
├── update.bat / update.sh
├── ARCHITECTURE.md
├── CONTRIBUTING.md
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

## ⚡ Slash Commands (16)

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

### 📊 Data Commands

| Command | Mô tả |
|---------|-------|
| `/data-ingest` | Quét `1_input/`, OCR ảnh, đẩy Text lên Brain, lọc Excel |
| `/data-process` | Viết mã phân tích dữ liệu theo kiến trúc Map-Reduce chống tràn RAM |
| `/spawn-workers` | Phân tách task thành N worker song song (Multi-Agent) |

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

### Core (17 Rules)

| Tài liệu | Nội dung |
|-----------|----------|
| [Execution Engine](.agents/runtime/execution-engine.yaml) | Central pipeline 12 bước |
| [Orchestrator](.agents/rules/orchestrator.md) | Multi-intent + execution plan + guardrails |
| [Instruction Layer](.agents/rules/instruction-layer.md) | 4-priority instruction system |
| [State Machine](.agents/rules/state-machine.md) | Agent state transitions |
| [Context Builder](.agents/rules/context-builder.md) | Adaptive budget + dedup + ranking |
| [Context Compressor](.agents/rules/context-compressor.md) | Auto context compression protocol |
| [Brain Connector](.agents/rules/brain-connector.md) | Brain query rules (auto/ask/off) |
| [Memory Protocol](.agents/rules/memory-protocol.md) | Decay + conflict + confidence |
| [Knowledge Tiers](.agents/rules/knowledge-tiers.md) | Static/Dynamic/Personal + fallback |
| [Capabilities](.agents/config/capabilities.yaml) | 7 capabilities + composition engine |
| [Feedback Logger](.agents/rules/feedback-logger.md) | Closed-loop feedback |
| [Safety Guard](.agents/rules/safety-guard.md) | /freeze, /careful, READ-ONLY |
| [Permission Guard](.agents/rules/permission-guard.md) | Data protection 3 lớp |
| [Data Handoff](.agents/rules/data-handoff.md) | No File No Trust + PII Scan |
| [Onboarding](.agents/rules/onboarding.md) | Socratic Onboarding Protocol |
| [Model Routing](.agents/config/model-routing.yaml) | Dynamic Model Selection (Tier 1→4) |
| [Coding Standards](.agents/rules/coding-standards.md) | Code quality + .bat safety rules |
| [Skill Development](.agents/rules/skill-development.md) | 7 Nguyên tắc Skill hoàn hảo |

### Plugins (v4.0)

| Tài liệu | Nội dung |
|-----------|----------|
| [Observability](.agents/runtime/observability.yaml) | 6 metrics + 5 log points |
| [Cache](.agents/runtime/cache.yaml) | 3-layer cache (query/tool/context) |
| [Cost Control](.agents/config/cost-control.yaml) | Dynamic budget + model selection |
| [Error Handling](.agents/rules/error-handling.md) | Retry + 4 fallback chains |
| [Human Loop](.agents/rules/human-loop.md) | Education-specific confirm guards |

### Architecture Decision Records

| ADR | Nội dung |
|-----|----------|
| [ADR-001](docs/architecture/adr-001-config-over-code.md) | Config-over-Code philosophy |
| [ADR-002](docs/architecture/adr-002-notebooklm-memory.md) | NotebookLM as Long-Term Memory |
| [ADR-003](docs/architecture/adr-003-single-user-focus.md) | Single-User focus design |

---

## 📝 Changelog

### v4.0 (2026-04-06)
**Core:**
- 🆕 Onboarding Protocol — Socratic Interview tự phân loại User profile
- 🆕 Context Compressor — Auto-detect context bloat + 3 compression strategies
- 🆕 User Profiles — `profiles.yaml` với 3 levels (beginner/intermediate/expert)
- 🆕 Security Modes — `security-modes.yaml` theo profile

**Workflows:**
- 🆕 `/data-ingest` — Auto-ingest pipeline (OCR, Brain sync, Excel filter)
- 🆕 `/data-process` — Map-Reduce data processing architecture
- 🆕 `/spawn-workers` — Multi-agent parallel task execution (Windows CMD)
- ⬆️ Rules: 15 → **17** quy tắc
- ⬆️ Workflows: 13 → **16** slash commands

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

**Proprietary** — All rights reserved.

Được xây dựng bởi **thanhndp** @ Skyline School.
Repo hiện public tạm thời cho mục đích review. Không được sao chép, phân phối, hoặc sử dụng thương mại mà không có sự đồng ý bằng văn bản.

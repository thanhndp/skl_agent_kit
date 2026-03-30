# 🧠 SKL_AGENT — AI Framework Template

> **Phiên bản:** 2.0 · Cập nhật: 2026-03-30
> Bộ khung AI Orchestration dùng cho mọi dự án **Data Pipeline** hoặc **App Development**.

`skl_agent` đóng gói Best Practices từ các hệ thống Agent hàng đầu (Antigravity SDK, Gstack, AutoResearchClaw, Skill Generator) thành một **template scaffolding** dùng lại cho mọi dự án.

---

## ✨ Điểm nổi bật

| Tính năng | Mô tả |
|-----------|-------|
| 🎯 **Dynamic Routing** | Tự động đánh giá độ khó Task → chọn Model (Tier 1→4), tải Skill phù hợp (Data Analytics / Web Engineering) |
| 🔄 **Cascade Fallback** | Chống đứt gãy tiến trình — API hết quota (429) → tự động fallback Model thấp hơn + retry |
| 📋 **Artifact Data Handoff** | Agent giao tiếp qua Data Specs (không truyền miệng → giảm ảo giác AI) |
| 🛡️ **Safety Guards** | `/freeze` (khóa scope), `/careful` (chống phá mã/xóa DB), `[READ-ONLY]` cho `1_input/` |
| 🔌 **NotebookLM MCP** | Đi kèm bộ cài NotebookLM MCP Hybrid v1.0 — 33 tools tiếng Việt, multi-account |
| 🧠 **Brain Architecture** | NotebookLM = Long-Term Memory + Antigravity = Active Processor → Closed-loop system |

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

> 📖 **Hướng dẫn chi tiết:** xem [docs/skill_extension_integration_guide.md](docs/skill_extension_integration_guide.md) — Section 4.2

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

**Multiplication Effect:**
- Cập nhật specs trong NotebookLM → Agent output thay đổi tức thì
- Agent không hallucinate business logic — bám sát docs thật
- Restart session → Brain vẫn giữ nguyên knowledge
- Mỗi project 1 Brain riêng → context chính xác

> 📖 Chi tiết: [.agents/rules/brain-connector.md](.agents/rules/brain-connector.md)

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
├── .agents/                    # 🧠 Bộ não AI
│   ├── config/
│   │   ├── model-routing.yaml  # Dynamic Routing (Tier 1→4)
│   │   └── brain.yaml          # 🆕 Brain config (NotebookLM connection)
│   ├── rules/
│   │   ├── brain-connector.md  # 🆕 Khi nào query Brain (auto/ask/off)
│   │   ├── coding-standards.md
│   │   ├── data-handoff.md
│   │   ├── safety-guard.md
│   │   └── skill-development.md
│   ├── skills/
│   │   ├── excel-professional/
│   │   └── viet-chuyen-nghiep/
│   └── workflows/              # 13 slash commands
│       ├── brain-bootstrap.md  # 🆕 /brain-bootstrap
│       ├── brain-sync.md       # 🆕 /brain-sync
│       ├── best-practices.md   # /best-practices
│       ├── load-skills.md      # /load-skills
│       ├── project-status.md   # /project-status
│       ├── skill-*.md          # /skill-generate, audit, validate...
│       └── ...                 
├── libs/
│   └── notebooklm-mcp-hybrid-v1.0.zip
├── docs/
│   └── skill_extension_integration_guide.md
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

> 📖 Xem chi tiết: [docs/skill_extension_integration_guide.md](docs/skill_extension_integration_guide.md)

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

| Tài liệu | Nội dung |
|-----------|----------|
| [Integration Guide](docs/skill_extension_integration_guide.md) | Hướng dẫn tích hợp Skills, MCP Servers, Workflows |
| [Brain Connector](.agents/rules/brain-connector.md) | 🆕 Cơ chế tham vấn NotebookLM Brain (auto/ask/off) |
| [Brain Config](.agents/config/brain.yaml) | 🆕 Cấu hình kết nối Brain cho project |
| [Safety Guard](.agents/rules/safety-guard.md) | Quy tắc bảo vệ `/freeze`, `/careful` |
| [Data Handoff](.agents/rules/data-handoff.md) | Quy tắc giao tiếp Agent qua Artifact |
| [Model Routing](.agents/config/model-routing.yaml) | Cấu hình Dynamic Model Selection |

---

## 📝 License

Private template — Được xây dựng bởi **thanhndp** @ Skyline School.

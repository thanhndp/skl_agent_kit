# 🤝 Contributing to SKL AGENT KIT

Cảm ơn bạn quan tâm đến SKL AGENT KIT! Dưới đây là hướng dẫn đóng góp.

---

## 📋 Quy Trình Đóng Góp

### 1. Fork & Clone

```bash
git fork https://github.com/thanhndp/skl_agent_kit.git
git clone https://github.com/YOUR_USERNAME/skl_agent_kit.git
cd skl_agent_kit
```

### 2. Tạo Branch

```bash
git checkout -b feat/ten-tinh-nang
# hoặc
git checkout -b fix/ten-loi
```

### 3. Thay Đổi

- **Rules mới:** Tạo file `.agents/rules/ten-rule.md` với frontmatter YAML
- **Config mới:** Thêm vào `.agents/config/` dạng YAML
- **Skill mới:** Dùng `/skill-scaffold` hoặc tạo thủ công trong `.agents/skills/`
- **Workflow mới:** Tạo file `.agents/workflows/ten-workflow.md`

### 4. Kiểm Tra

Chạy test scenarios (xem [tests/simulation.md](tests/simulation.md)):

```bash
# Mở project trong AI IDE (Antigravity/Cursor)
# Chạy 5 test scenarios
# Verify output đúng expected
```

### 5. Commit & PR

```bash
git add .
git commit -m "feat: mô tả ngắn"
git push origin feat/ten-tinh-nang
```

Tạo Pull Request trên GitHub với mô tả:
- **What:** Thay đổi gì
- **Why:** Tại sao cần
- **How:** Cơ chế hoạt động
- **Test:** Đã test scenario nào

---

## 📐 Quy Tắc

### File Format

| Loại | Format | Ví dụ |
|------|--------|-------|
| Rules | Markdown + YAML frontmatter | `rules/ten-rule.md` |
| Config | YAML | `config/ten-config.yaml` |
| Runtime | YAML | `runtime/ten-plugin.yaml` |
| Skills | Markdown (SKILL.md) | `skills/ten-skill/SKILL.md` |

### Naming Convention

```
kebab-case cho file names
camelCase cho YAML keys
UPPER_CASE cho constants
```

### Commit Messages

```
feat: tính năng mới
fix: sửa lỗi
docs: cập nhật tài liệu
chore: maintenance (gitignore, deps)
refactor: tái cấu trúc không đổi behavior
```

### 3 KHÔNG

- ❌ **Không sửa execution-engine.yaml** — Hook vào, đừng fork
- ❌ **Không trộn layers** — Config ≠ Rules ≠ Runtime
- ❌ **Không phá output contracts** — Giữ nguyên format capabilities đã define

### 3 CÓ

- ✅ **Hook vào pipeline** — Thêm log point, cache, guard
- ✅ **Giữ module độc lập** — 1 file = 1 concern
- ✅ **Fail → fallback** — Plugin hỏng → pipeline vẫn chạy

---

## 🏗️ Cấu Trúc Đóng Góp

### Thêm Rule mới

```markdown
---
description: "Mô tả ngắn rule này làm gì"
---

# Tên Rule

## Mục đích
...

## Hook Point
Gắn vào step nào trong execution engine

## Logic
...

## Anti-Patterns
...
```

### Thêm Plugin mới

```yaml
# .agents/runtime/ten-plugin.yaml
ten_plugin:
  enabled: true
  hook_steps: [4, 9]  # Steps trong pipeline
  # ... config
```

---

## 💬 Liên Hệ

- **Maintainer:** thanhndp
- **Issues:** [GitHub Issues](https://github.com/thanhndp/skl_agent_kit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/thanhndp/skl_agent_kit/discussions)

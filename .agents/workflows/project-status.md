---
description: Xem tổng quan dự án — liệt kê tất cả skills, workflows, agents, và rules hiện có
---

# Project Status

Hiển thị tổng quan workspace hiện tại.

## Steps

1. **Scan cấu trúc thư mục** — list `.agents/` directory tree
2. **Liệt kê Skills** — đọc tất cả SKILL.md trong `.agents/skills/` và `skills/`
3. **Liệt kê Workflows** — đọc tất cả `.md` trong `.agents/workflows/`
4. **Liệt kê Rules** — đọc tất cả `.md` trong `.agents/rules/`
5. **Hiển thị tổng kết** theo format:

```
📊 Project Status: SKL_AGENT
═══════════════════════════
🧩 Skills (N):
   - skill-name: description ngắn

📋 Workflows (N):
   - /workflow-name: description ngắn

📏 Rules (N):
   - rule-name: mô tả ngắn

📁 Other:
   - phases/, resources/, examples/, scripts/
```

6. **Ghi chú** — nếu có file nào thiếu description trong frontmatter, cảnh báo

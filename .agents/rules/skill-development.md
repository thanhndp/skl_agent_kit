---
description: Nguyên tắc và tiêu chuẩn thiết kế điểm neo (skill) cho các tác nhân AI (7 Nguyên tắc Skill hoàn hảo).
---

# Skill Development Rules

## 7 Nguyên Tắc Skill Hoàn Hảo

| # | Nguyên tắc | Tóm tắt |
|---|---|---|
| 1 | **Atomic Logic** | 1 skill = 1 việc hoàn hảo. Tên có "and" → tách |
| 2 | **Semantic Trigger** | Description phải chính xác đến mức AI tự kích hoạt |
| 3 | **4 Core Sections** | Goal + Instructions + Examples + Constraints = BẮT BUỘC |
| 4 | **Show Don't Tell** | 2-3 ví dụ hoàn hảo > 50 dòng quy tắc |
| 5 | **Semantic Precision** | Generate/Analyze/Execute — KHÔNG dùng "xử lý", "kiểm tra" |
| 6 | **Error Recovery** | Confidence scores + Decision Tree + ask-back khi mơ hồ |
| 7 | **Black Box Scripts** | AI dùng `--help` để tự học, KHÔNG đọc source code |

## Skill Structure

```
.agents/skills/<skill-name>/
├── SKILL.md          # Main instruction file (≤500 dòng)
├── resources/        # Chi tiết bổ sung, reference data
├── examples/         # Ví dụ mẫu I/O
└── scripts/          # Helper scripts
```

## Orchestration Pattern: Command → Agent → Skill

```
User → /command (entry point)
         ├→ Agent (data fetching, preloaded skills)
         └→ Skill (output generation, independent execution)
```

- **Commands**: Entry point cho workflows, orchestrate agents & skills
- **Agents**: Feature-specific, có preloaded skills (domain knowledge)
- **Skills**: Standalone tools, invoked trực tiếp hoặc preloaded vào agent

## Quality Checklist
- [ ] SKILL.md ≤ 500 dòng — vượt thì tách ra resources/
- [ ] Description "pushy" — cover nhiều cách user có thể hỏi
- [ ] Explain the WHY — giải thích lý do thay vì MUST/NEVER
- [ ] 2-3 ví dụ bắt buộc — thiếu = tăng hallucination
- [ ] Không hardcode secrets/API keys

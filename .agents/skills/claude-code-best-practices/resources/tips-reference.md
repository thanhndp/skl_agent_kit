# Claude Code Tips Reference — 33+ Tips

Nguồn: [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) (MIT License)

---

## ■ Planning (2 tips)

### 1. Luôn bắt đầu bằng plan mode
Dùng [plan mode](https://code.claude.com/docs/en/common-workflows) để Claude phỏng vấn trước khi code. Dùng [AskUserQuestion](https://code.claude.com/docs/en/cli-reference) tool để hỏi user.

> **Nguồn:** [Thariq — 28/Dec/25](https://x.com/trq212/status/2005315275026260309)

### 2. Phase-wise gated plan
Tạo plan chia theo phase, mỗi phase có tests riêng (unit, automation, integration). Dùng [cross-model workflow](https://github.com/shanraisshan/claude-code-best-practice/blob/main/development-workflows/cross-model-workflow/cross-model-workflow.md) để review plan.

---

## ■ Workflows (12 tips)

### 3. CLAUDE.md ≤ 200 dòng
Target dưới [200 dòng](https://code.claude.com/docs/en/memory#write-effective-instructions) per file. [Humanlayer khuyến khích ~60 dòng](https://www.humanlayer.dev/blog/writing-a-good-claude-md).

### 4. Multiple CLAUDE.md cho monorepos
Ancestor loading (lên, load ngay) + Descendant loading (xuống, lazy load).

### 5. Dùng .claude/rules/ để tách instructions lớn
Thay vì nhồi hết vào CLAUDE.md, [tách ra rules/](https://code.claude.com/docs/en/memory#organize-rules-with-clauderules).

### 6. Commands > Standalone agents cho workflows
Dùng [commands](https://code.claude.com/docs/en/slash-commands) thay vì agents riêng lẻ.

### 7. Feature-specific agents + skills
Tạo [sub-agents](https://code.claude.com/docs/en/sub-agents) chuyên biệt với [skills](https://code.claude.com/docs/en/skills) (progressive disclosure) thay vì agent chung chung (qa, backend).

### 8. memory.md / constitution.md không guarantee
Không có gì đảm bảo 100% — [Claude vẫn có thể bỏ qua](https://reddit.com/r/ClaudeCode/comments/1qn9pb9).

### 9. Tránh "agent dumb zone"
Manual [/compact](https://code.claude.com/docs/en/interactive-mode) ở max 50%. Dùng [/clear](https://code.claude.com/docs/en/cli-reference) để reset context khi đổi task.

### 10. Vanilla CC tốt hơn cho task nhỏ
Không cần workflows phức tạp cho tasks đơn giản.

### 11. Skills trong subfolders cho monorepos
[Đặt skills trong subfolders](https://github.com/shanraisshan/claude-code-best-practice/blob/main/reports/claude-skills-for-larger-mono-repos.md) theo component.

### 12. Cấu hình model & context
- `/model` — chọn model + reasoning
- `/context` — xem context usage
- `/usage` — check plan limits
- `/extra-usage` — overflow billing
- `/config` — settings tổng hợp

### 13. Thinking mode + Explanatory output
Bật [thinking mode](https://code.claude.com/docs/en/model-config) true + [Output Style](https://code.claude.com/docs/en/output-styles) Explanatory trong `/config`.

### 14. /rename và /resume sessions
[/rename](https://code.claude.com/docs/en/cli-reference) các sessions quan trọng, [/resume](https://code.claude.com/docs/en/cli-reference) để tiếp tục sau.

---

## ■ Workflows Advanced (6 tips)

### 15. ASCII diagrams cho architecture
Dùng ASCII diagrams nhiều để hiểu kiến trúc.

> **Nguồn:** [Thariq — 28/Feb/26](https://x.com/trq212/status/2027543858289250472)

### 16. Agent teams + git worktrees
[Agent teams với tmux](https://code.claude.com/docs/en/agent-teams) + [git worktrees](https://x.com/bcherny/status/2025007393290272904) cho parallel development.

### 17. /loop cho recurring tasks
Dùng [/loop](https://code.claude.com/docs/en/scheduled-tasks) để poll deployments, babysit PRs, check builds — chạy đến 3 ngày.

### 18. Ralph Wiggum plugin cho autonomous tasks
[Ralph Wiggum](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) cho long-running autonomous tasks.

### 19. Permissions với wildcard
[/permissions](https://code.claude.com/docs/en/permissions) với wildcard syntax: `Bash(npm run *)`, `Edit(/docs/**)` — thay vì `dangerously-skip-permissions`.

### 20. /sandbox cho isolation
[/sandbox](https://code.claude.com/docs/en/sandboxing) giảm permission prompts với file + network isolation.

---

## ■ Debugging (5 tips)

### 21. Screenshots khi stuck
Chụp screenshots và share cho Claude khi gặp vấn đề visual.

### 22. Browser MCP cho console logs
Dùng MCP ([Claude in Chrome](https://code.claude.com/docs/en/chrome), [Playwright](https://github.com/microsoft/playwright-mcp), [Chrome DevTools](https://developer.chrome.com/blog/chrome-devtools-mcp)) để Claude tự xem console logs.

### 23. Background tasks cho debugging
Chạy terminal commands dài hạn ở background cho log visibility tốt hơn.

### 24. /doctor cho diagnostics
[/doctor](https://code.claude.com/docs/en/cli-reference) để diagnose installation, auth, và config issues.

### 25. Compaction error fix
Error khi compact → dùng [/model](https://code.claude.com/docs/en/model-config) chọn 1M token model, rồi chạy [/compact](https://code.claude.com/docs/en/interactive-mode).

---

## ■ Utilities (5 tips)

### 26. Terminal tools
Dùng [iTerm](https://iterm2.com/) / [Ghostty](https://ghostty.org/) / [tmux](https://github.com/tmux/tmux) thay vì IDE terminal (VS Code/Cursor).

### 27. Wispr Flow cho voice prompting
[Wispr Flow](https://wisprflow.ai) — voice prompting, 10x productivity.

### 28. Claude voice hooks
[claude-code-voice-hooks](https://github.com/shanraisshan/claude-code-voice-hooks) cho audio feedback từ Claude.

### 29. Status line
[Status line](https://github.com/shanraisshan/claude-code-status-line) cho context awareness + fast compacting.

### 30. Settings.json features
Explore [Plans Directory](https://github.com/shanraisshan/claude-code-best-practice/blob/main/best-practice/claude-settings.md#plans-directory), [Spinner Verbs](https://github.com/shanraisshan/claude-code-best-practice/blob/main/best-practice/claude-settings.md#display--ux) cho personalized experience.

---

## ■ Daily (3 tips)

### 31. Cập nhật Claude Code hàng ngày
[Update](https://code.claude.com/docs/en/setup) daily + đọc [changelog](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md).

### 32. Follow Reddit communities
[r/ClaudeAI](https://reddit.com/r/ClaudeAI/), [r/ClaudeCode](https://reddit.com/r/ClaudeCode/).

### 33. Follow key people on X
[Boris Cherny](https://x.com/bcherny) (Creator), [Thariq](https://x.com/trq212), [Cat Wu](https://x.com/_catwu), [Lydia Hallie](https://x.com/lydiahallie), [Claude](https://x.com/claudeai).

---

## Key Tweets Timeline

| Ngày | Nội dung | Link |
|------|----------|------|
| 27/Dec/25 | Plan mode, verify, /code-review | [Boris](https://x.com/bcherny/status/2004711722926616680) |
| 03/Jan/26 | 5 setup tips | [Boris](https://x.com/bcherny/status/2007179832300581177) |
| 01/Feb/26 | 10 tips from the team | [Boris](https://x.com/bcherny/status/2017742741636321619) |
| 12/Feb/26 | 12 ways to customize | [Boris](https://x.com/bcherny/status/2021699851499798911) |
| 21/Feb/26 | Git Worktrees 5 ways | [Boris](https://x.com/bcherny/status/2025007393290272904) |
| 28/Feb/26 | Seeing like an Agent | [Thariq](https://x.com/trq212/status/2027463795355095314) |
| 07/Mar/26 | /loop scheduled tasks | [Boris](https://x.com/bcherny/status/2030193932404150413) |
| 10/Mar/26 | Code Review benefits | [Boris](https://x.com/bcherny/status/2031151689219321886) |

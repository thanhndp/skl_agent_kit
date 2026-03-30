# Orchestration Patterns

Kiến trúc **Command → Agent → Skill** và các pattern liên quan.

---

## 1. Tổng quan Flow

```
╔════════════════════════════════════════════╗
║    ORCHESTRATION: Command → Agent → Skill  ║
╚════════════════════════════════════════════╝

                 ┌───────────────────┐
                 │  User Interaction │
                 └─────────┬─────────┘
                           │
                           ▼
      ┌────────────────────────────────────┐
      │  /command — Entry Point            │
      │  (Orchestrator, handles UX)        │
      └──────────┬──────────────┬──────────┘
                 │              │
           Agent tool      Skill tool
                 │              │
                 ▼              ▼
      ┌──────────────┐  ┌──────────────┐
      │  Agent       │  │  Skill       │
      │  (fetches)   │  │  (renders)   │
      │  preloaded:  │  │  independent │
      │  skill-A     │  │  execution   │
      └──────────────┘  └──────────────┘
```

---

## 2. Hai loại Skill

### Agent Skill (Preloaded)
- Được **inject vào agent context** khi startup
- Agent dùng như **domain knowledge** / reference
- Khai báo trong agent frontmatter: `skills: [skill-name]`
- **Không** được invoke trực tiếp

```yaml
# .claude/agents/my-agent.md
---
name: my-agent
skills:
  - data-fetcher    # Preloaded vào context
---
```

### Skill (Direct Invocation)
- Được gọi trực tiếp qua **Skill tool**
- Chạy **độc lập** trong context của command
- Nhận data từ conversation context

```yaml
# .claude/skills/renderer/SKILL.md
---
name: renderer
description: Creates visual output...
---
```

---

## 3. Agent Definition Structure

```yaml
---
name: agent-name
description: "Use PROACTIVELY when..."    # PROACTIVELY = auto-invocation
tools: WebFetch, Read, Write, Edit        # Allowlist (inherits all if omitted)
disallowedTools: Bash                     # Denylist
model: sonnet                             # haiku | sonnet | opus | inherit
color: green                              # CLI output color
maxTurns: 5                               # Max agentic turns
permissionMode: acceptEdits               # acceptEdits | plan | bypassPermissions
memory: project                           # user | project | local
skills:
  - skill-name                            # Preloaded skills
mcpServers:
  - server-name                           # MCP servers for this agent
background: false                         # Run as background task
isolation: worktree                       # Run in temp git worktree
hooks:
  PreToolUse:                             # Scoped lifecycle hooks
    - matcher: ".*"
      hooks:
        - type: command
          command: "..."
---
```

---

## 4. Skill Definition Structure

```yaml
---
name: skill-name                          # Display name + /slash-command
description: When to invoke...            # Semantic trigger (auto-discovery)
argument-hint: "[issue-number]"           # Autocomplete hint
disable-model-invocation: false           # true = prevent auto-invocation
user-invocable: true                      # false = hide from / menu
allowed-tools: Read, Write                # Tools without permission prompts
model: sonnet                             # Model when skill active
context: fork                             # fork = isolated subagent
agent: general-purpose                    # Subagent type for context: fork
hooks:                                    # Lifecycle hooks scoped to skill
  PreToolUse: [...]
---
```

---

## 5. Command Structure

```yaml
---
description: What the command does
model: haiku                              # Model for this command
---

# Command Name
Instructions for the workflow...

## Step 1: ...
## Step 2: Use Agent tool
## Step 3: Use Skill tool
```

---

## 6. Configuration Hierarchy (Claude Code)

| Priority | Location | Scope |
|----------|----------|-------|
| 1 (highest) | `managed-settings.json` | Organization-enforced |
| 2 | CLI arguments | Single-session |
| 3 | `.claude/settings.local.json` | Personal project (git-ignored) |
| 4 | `.claude/settings.json` | Team-shared |
| 5 | `~/.claude/settings.json` | Global personal |

---

## 7. Critical Rules

1. **Subagents KHÔNG THỂ gọi subagent khác qua bash** — phải dùng Agent tool:
   ```
   Agent(subagent_type="agent-name", description="...", prompt="...", model="haiku")
   ```

2. **Commands cho workflows, Agents cho features** — đừng tạo agent chung chung

3. **Skills cho progressive disclosure** — load chi tiết khi cần, không nhồi hết vào agent

---

## 8. Development Workflows Nổi Bật

| Workflow | Mô tả | Link |
|----------|-------|------|
| Cross-Model | Claude Code + Codex cho plan review | [Xem](https://github.com/shanraisshan/claude-code-best-practice/blob/main/development-workflows/cross-model-workflow/cross-model-workflow.md) |
| RPI | Research → Plan → Implement | [Xem](https://github.com/shanraisshan/claude-code-best-practice/blob/main/development-workflows/rpi/rpi-workflow.md) |
| Ralph Wiggum | Long-running autonomous loop | [Xem](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) |
| Github Speckit | Spec-driven development | [Xem](https://github.com/github/spec-kit) |
| GSD | Get Shit Done workflow (★25k) | [Xem](https://github.com/gsd-build/get-shit-done) |

---

Nguồn: [shanraisshan/claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) (MIT License)

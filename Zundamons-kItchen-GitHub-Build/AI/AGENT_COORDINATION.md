# Agent Coordination — Zundamon's kItchen

This document defines how **Cursor**, **DeepSeek OpenCode**, and **Cline** work on the same repo without conflicts.

## Roles

| Agent | Primary role | Branch prefix |
|---|---|---|
| **Cursor Cloud** | Integration, review, conflict resolution, docs | `cursor/<task>-594f` |
| **DeepSeek OpenCode** | Client UI, Studio-facing features, design system adoption | `opencode/<task>` |
| **Cline** | Server refactors, security, data layer, services | `cline/<task>` |

## Before starting any task

1. Read [`AI/AI_RULES.md`](AI_RULES.md)
2. Read [`AI/WORK_QUEUE.md`](WORK_QUEUE.md) — claim an unassigned task or coordinate on an in-progress one
3. Create a branch with your agent prefix
4. Scope changes to files listed in your WORK_QUEUE entry
5. Run `npm run validate` and `npm run lint` before pushing

## Claiming a task

Edit `AI/WORK_QUEUE.md`:

- Set **Owner** to your agent name
- Set **Status** to `in_progress`
- Set **Branch** to your branch name
- Push the claim commit before writing code

## Review protocol (Cursor)

When OpenCode or Cline push branches:

1. `git fetch origin`
2. Diff branch against `main`
3. Run `npm run validate` and `npm run lint`
4. Reject if:
   - `.rbxl`, `.rbxlx`, or `source/` files are committed
   - New code uses `_G.data` instead of `PlayerDataService`
   - `ConfigurationFiles/` modules add server listeners or side effects
   - Remotes lack server-side validation
5. Fix issues or merge; update WORK_QUEUE status to `done`

## Conflict rules

- **One owner per file** per sprint — check WORK_QUEUE before editing
- If two agents need the same file, Cursor merges sequentially
- Cursor wins on integration conflicts (QuestManager, RemoteManifest, default.project.json)
- Do not modify another agent's in-progress branch without coordination

## Territory (initial split)

**OpenCode:** client UI scripts, `UIComponents` adoption, decoration shop UI, skybox docs  
**Cline:** `Planters.server.lua`, `PlayerDataService` migrations, stat hooks, `MarketplaceService`  
**Cursor:** quest wiring, docs, agent coordination, merge/review

## Communication

- Status lives in `AI/WORK_QUEUE.md` (not chat-only handoffs)
- Commit messages: `feat:`, `fix:`, `docs:`, `chore:` prefixes
- Reference task ID from WORK_QUEUE in PR description

## Do not

- Commit place exports (`*.rbxl`, `*.rbxlx`)
- Push directly to `main` without review
- Delete or force-push another agent's branch
- Modify `docs/project-review.md` without updating the date and scorecard

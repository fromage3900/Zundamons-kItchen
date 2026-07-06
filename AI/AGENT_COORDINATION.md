# Agent Coordination — Zundamon's kItchen 🫛

How **Cursor**, **Cline**, and **OpenCode** share one repo without stepping on each other.

## Roles

| Agent | Focus | Branch prefix |
|-------|-------|---------------|
| Cursor | Integration, merge, publish safety, docs | `cursor/<task>-594f` |
| Cline | Server systems, security, data layer | `cline/<task>` |
| OpenCode | Client UI, assets, Studio MCP | `opencode/<task>` |

## Before every session

1. [`AI/WORKSPACE.md`](WORKSPACE.md) — `G:\Zundamons-kItchen`
2. [`AI/WORK_QUEUE.md`](WORK_QUEUE.md) — claim a row
3. [`AI/PUBLISH-PLAN.md`](PUBLISH-PLAN.md) — phase priorities
4. [`AI/AGENT-WORK-REVIEW.md`](AGENT-WORK-REVIEW.md) — who owns what

## Claiming work

Edit `WORK_QUEUE.md`: set Owner, Status `in_progress`, Branch. Push claim before coding.

## Do not

- Commit place exports (`*.rbxl`, `*.rbxlx`)
- Push directly to `main` without review
- Edit another agent's in-progress branch
- Reintroduce nested `Zundamons-kItchen-GitHub-Build/` paths in docs

## Cursor merge protocol

1. `git fetch origin`
2. `npm run validate` + `npm run verify:safety`
3. Reject if secrets, `workspace/` committed, or duplicate `ProcessReceipt`
4. Update `WORK_QUEUE` → `done`

## Hot files (single owner per sprint)

- `VNController.client.lua`, `default.project.json`, `MarketplaceConfig.lua`, `QuestManager.server.lua`

# Cline — System Prompt

You are working on **Zundamon's kItchen**, a Roblox cooperative kitchen life-sim synced via Rojo.

## Required reading (every session)

1. [`AI/AI_RULES.md`](../AI_RULES.md)
2. [`AI/WORK_QUEUE.md`](../WORK_QUEUE.md) — claim a task before coding
3. [`AI/AGENT_COORDINATION.md`](../AGENT_COORDINATION.md) — branch and territory rules

## Your focus

- Server authority (`ServerScriptService/`, especially `Services/`)
- Migrating legacy `_G.data` usage to `PlayerDataService`
- Security: remote validation, rate limiting, single ProcessReceipt owner
- Implementing [`MarketplaceService_Proposed.lua`](../MarketplaceService_Proposed.lua) as a real service
- Quest stat hooks (`companion_chats`, `npc_chats` in `PlayerDataService.stats`)

## Branch naming

Always work on `cline/<short-task-name>`. Never push directly to `main`.

## Code rules

- All Luau changes go under `src/` only — never commit `.rbxl` or `.rbxlx`
- Use `--!strict` on new ModuleScripts when possible
- Active listeners belong in `ServerScriptService`, not `ConfigurationFiles/`
- Update `docs/remotes.md` and `docs/security-audit.md` when changing networking

## Before pushing

```bash
cd Zundamons-kItchen-GitHub-Build
npm run validate
npm run lint
```

Set WORK_QUEUE status to `review` and note your branch name.

## Do not modify (owned by other agents)

- Client UI scripts — OpenCode
- `QuestManager.server.lua`, `QuestProgress.lua` — Cursor (review only)
- `UIConfig.lua`, `UIComponents.lua` — OpenCode

## Verification

Document server-side test steps and confirm no duplicate `ProcessReceipt` handlers.

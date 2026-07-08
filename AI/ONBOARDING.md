# Agent Onboarding — Zundamon's Kitchen

You are working on a Roblox game built with **Rojo + git + cloud place** (Option C).

## First: Read These

| File | What it tells you |
|------|-------------------|
| `docs/migration-from-legacy-place.md` | If team still uses old 48MB `.rbxlx` — migrate first |
| `docs/git-workflow.md` | Git branches, commits, PRs |
| `docs/rojo-workflow.md` | Live Rojo sync |
| `GETTING_STARTED.md` | Electra-friendly daily steps |
| `AI/HANDOFF_QWEN.md` | What NOT to touch |
| `AI/WORK_QUEUE.md` | Current tasks |
| `default.project.json` | Rojo map |

## Project topology

```
G:\Zundamons-kItchen\          ← ALWAYS work from here
├── src/                        ← ALL script changes (git + Rojo)
├── Assets/Upload/              ← Drop meshes for import pipeline
├── scripts/                    ← Build tools + agent orchestrator
└── AI/                         ← Coordination docs

Cloud place 108617605497926     ← World (Studio Save to Roblox)
```

## Ground rules

1. `cd G:\Zundamons-kItchen` before any command
2. **Open cloud place `108617605497926`** — not local `.rbxlx` for playtest
3. `git pull origin main` before coding
4. **Never commit** `.rbxl` / `.rbxlx`
5. **Never modify** local `.rbxlx` as source of truth — edit `src/`
6. `npm run validate` before push
7. Claim work in `AI/WORK_QUEUE.md`
8. Rojo must be connected; verify `[ROJO SYNC OK]` on Play

## Key Architecture

| Layer | What | Located at |
|-------|------|-----------|
| Configs | Shared data (recipes, quests, items) | `src/ReplicatedStorage/ConfigurationFiles/` |
| Server | Gameplay logic | `src/ServerScriptService/` |
| Client | UI + controls | `src/StarterPlayer/StarterPlayerScripts/` |
| Modifiers | Non-destructive visual FX | `src/ReplicatedStorage/Shared/Modules/Modifiers/` |
| Plugins | Hot-reloadable features | `src/ServerScriptService/Plugins/` |
| Services | Core systems (Data, Scatter, Admin) | `src/ServerScriptService/Services/` |

## Config File Format

```lua
--!strict
-- [[ModuleScript] ConfigName]
local Config = {}
-- ... table fields ...
return Config
```

## Important: No Workspace Mapping

The `default.project.json` does NOT map Workspace. Rojo syncs scripts only — terrain and placed objects are safe.

## Critical: Correct Require Paths

RewardCore and LootModule live in `ReplicatedStorage.ConfigurationFiles`, NOT in `ServerScriptService`.
```lua
-- CORRECT:
local RewardCore = require(game.ReplicatedStorage.ConfigurationFiles.RewardCore)
local LootModule = require(game.ReplicatedStorage.ConfigurationFiles.LootModule)

-- WRONG (will hang or fail):
local RewardCore = require(game.ServerScriptService:WaitForChild("RewardCore"))
```

## DO NOT TOUCH (working systems)

- `CompanionManager.server.lua`
- `CompanionShopServer.server.lua`
- `CompanionHUD.client.lua`
- `HudScript.client.lua`

These were reverted to commit `0dafc6d` originals after modifications broke them. They work — leave them alone.

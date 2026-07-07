# Agent Onboarding — Zundamon's Kitchen

You are working on a Roblox game (Zundamon's Kitchen) built with Rojo + Luau + AI agents.

## First: Read These

| File | What it tells you |
|------|-------------------|
| `README.md` | Project overview, all commands |
| `BUILD.md` | Step-by-step build guide |
| `AI/HANDOFF_QWEN.md` | Issues faced + what NOT to touch |
| `AI/WORK_QUEUE.md` | Current task board |
| `default.project.json` | Rojo project map (WHERE scripts sync to) |

## Project Topology

```
G:\Zundamons-kItchen\     ← ALWAYS work from here
├── src/                   ← All game code (script changes go here)
├── Assets/Upload/         ← Drop OBJ/FBX files here for mesh pipeline
├── scripts/               ← Build tools + AI agent orchestrator
│   └── agent_orchestrator/ ← Python agent system (Ollama)
└── AI/                    ← Agent coordination docs
```

## Ground Rules

1. `cd G:\Zundamons-kItchen` before running any command
2. **Never modify `.rbxlx` files** — all code changes go in `src/`
3. **Never commit `.rbxl` or `.rbxlx`** — they're gitignored
4. `npm run validate` before pushing
5. Claim work by updating `AI/WORK_QUEUE.md` before coding
6. Use `npm run overnight` to verify changes didn't break anything

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

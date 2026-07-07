# Zundamon's Kitchen — Roblox + Rojo + AI Agent Toolkit

A cozy cooking RPG for Roblox. Gather ingredients, cook recipes, serve guests, and build your kitchen. Built with Rojo, Luau, and an AI agent orchestrator for autonomous content generation.

---

## Quick Start

```bash
# 1. Sync scripts to Studio
npm run rojo:serve

# 2. In Studio: connect Rojo plugin to localhost:34872
# 3. Press Play to test
```

---

## Architecture

```
src/
├── ReplicatedStorage/           # Shared code (server + client)
│   ├── ConfigurationFiles/      #  34 config modules (quests, recipes, items...)
│   └── Shared/
│       ├── Config/              #  NPC defs, UI assets, variants
│       └── Modules/             #  ModifierStack, EscherMath, UIHelper...
├── ServerScriptService/         # Server-side gameplay (39 scripts)
│   ├── Services/                #  PlayerData, Scatter, Admin, PluginLoader
│   ├── Plugins/                 #  Hot-reloadable gameplay plugins
│   └── DevTools/                #  BuildMeshLibrary, PopulateWorld
└── StarterPlayer/               # Client-side UI + controls (43 scripts)
    └── StarterPlayerScripts/    #  HUD, crafting, fishing, admin console...

scripts/
├── agent_orchestrator/          # AI agent system (Ollama, Python)
│   ├── agents/                  #  Research, Code, Blender, Roblox, Quest
│   ├── tools/                   #  Ollama client, mesh pipeline, model deploy
│   └── orchestrator.py          #  Main agent loop
├── overnight-build.mjs          # Config validation + asset audit
└── validate-structure.mjs       # Rojo project structure check
```

---

## All Commands

| Command | What it does |
|---------|-------------|
| `npm run rojo:serve` | Sync scripts to Studio (live) |
| `npm run rojo:build` | Build a .rbxl file from source |
| `npm run validate` | Check project structure |
| `npm run overnight` | Full config audit + report |
| `npm run generate-quests` | AI-generate quests via Ollama |
| `npm run deploy-models` | Auto-pull all Ollama AI models |
| `npm run lint` | Style check (StyLua + Selene) |

### Studio Command Bar Tools

| Tool | Purpose |
|------|---------|
| `require(SS.DevTools["BuildMeshLibrary.dev"]).build()` | Create MeshLibrary folder with all meshes |
| `require(SS.DevTools["PopulateWorld.dev"]).populate()` | Populate world with cubes, spawns, patrols |
| `require(SS.Services.AdminService)` | In-game admin commands (F2) |

### AI Agent System

```bash
# Deploy AI models (auto-pulls missing ones)
npm run deploy-models

# Generate quests for uncovered recipes
npm run generate-quests

# Run a custom task
python scripts/agent_orchestrator/run.py "Research Penrose tiling algorithm"
```

Requires [Ollama](https://ollama.com) running locally with models deployed.

---

## Key Systems

| System | Location | Status |
|--------|----------|--------|
| **Gathering** (click-to-harvest) | `ZundaGatherServer` + `ScatterService` | ✅ Colored cubes fallback |
| **Crafting** (timed minigame) | `CraftManager` + `TimedCookingScript` | ✅ Server-authoritative quality |
| **Serving** (click-to-serve guests) | `GuestManager` + `ServingSystem` | ✅ Procedural capsule guests |
| **Companions** (follow + buff) | `CompanionManager` + `ZundamonSync` | ✅ 8 companion types |
| **Quests** (68 quests, 6 chains) | `QuestConfig` + `QuestManager` | ✅ AI-generatable |
| **Fishing** (minigame) | `FishingServer` + `FishingMinigameScript` | ✅ 8 fish types |
| **Admin Console** (F2) | `AdminService` + `AdminConsole` | ✅ /commands |
| **Modifier Stack** (non-destructive) | `ModifierStack` + 6 modifiers | ✅ Scale, Glow, Bob, Spin, Sway, Color |
| **Plugin System** (hot-reload) | `PluginLoader` | ✅ ZundamonFX, AmbientNodes |
| **AI Agents** (Ollama, local) | `agent_orchestrator/` | ✅ Research, code gen, quest design |

---

## For Contributors

See [BUILD.md](BUILD.md) for the complete setup guide from clone to running game.

Architecture docs: `AI/ARCHITECTURE.md` · `AI/DESIGN_SYSTEM.md` · `AI/STYLE_GUIDE.md`

Master plans: `.opencode/plans/zunda-omnibus-toolkit.md`

---

## Repo Layout

```
G:\Zundamons-kItchen\          ← Canonical workspace
├── default.project.json        ← Rojo project config
├── Zundamons-kItchen.rbxlx     ← Place file (49MB, gitignored)
├── src/                        ← Source code (what Rojo syncs)
├── Assets/                     ← Source meshes (Upload/) and pipeline metadata
├── scripts/                    ← Build tools, CI, agent orchestrator
├── reports/                    ← Generated reports (gitignored)
├── AI/                         ← Architecture, design system, agent docs
├── docs/                       ← Legacy docs
└── .github/workflows/          ← CI/CD (nightly build + audit)
```

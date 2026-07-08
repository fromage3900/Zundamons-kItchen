# 🫛 Zundamon's Kitchen

A cozy cooking RPG for Roblox. Gather ingredients, cook recipes, serve guests, build your kitchen. Built with Rojo, Luau, and AI agents.

---

## 🆕 New Here? Start Here

| You are… | Read this |
|----------|-----------|
| **Electra / new to git** | **[GETTING_STARTED.md](GETTING_STARTED.md)** |
| **Migrating from old 48MB place** | **[docs/migration-from-legacy-place.md](docs/migration-from-legacy-place.md)** |
| **Contributor / agent** | **[docs/git-workflow.md](docs/git-workflow.md)** + **[docs/rojo-workflow.md](docs/rojo-workflow.md)** |

## Quick Start (Option C — live sync)

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

1. Open **cloud place** `108617605497926` in Studio (not a local `.rbxlx`)
2. Rojo plugin → `localhost:34872` (or `34873`)
3. Play → confirm `[ROJO SYNC OK]` in Output
4. Edit `src/` — changes sync live

## For Contributors

| If you want to... | Read this |
|-------------------|-----------|
| Install from scratch | [`GETTING_STARTED.md`](GETTING_STARTED.md) |
| Migrate off legacy place | [`docs/migration-from-legacy-place.md`](docs/migration-from-legacy-place.md) |
| Git branches, commits, PRs | [`docs/git-workflow.md`](docs/git-workflow.md) |
| Rojo live sync | [`docs/rojo-workflow.md`](docs/rojo-workflow.md) |
| Advanced build + meshes | [`BUILD.md`](BUILD.md) |
| Current tasks | [`AI/WORK_QUEUE.md`](AI/WORK_QUEUE.md) |

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
G:\Zundamons-kItchen\          ← Canonical workspace (git)
├── default.project.json        ← Rojo project config
├── src/                        ← Source code (what Rojo syncs)
├── Assets/                     ← Mesh uploads + pipeline metadata
├── scripts/                    ← Build tools, agent orchestrator
├── docs/                       ← Getting started, git, migration
├── AI/                         ← Agent coordination
└── *.rbxlx (local only)        ← Legacy place archive — gitignored, NOT daily driver
```

**World container:** Roblox cloud place **`108617605497926`** (Save to Roblox for map changes).

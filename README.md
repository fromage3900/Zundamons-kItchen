# Zundamon's kItchen — GitHub Build (Roblox + Rojo)

This repository is the collaboration hub and **source of truth for game code** in the Roblox experience **"Zundamon's kItchen"**.

## Workflow: Rojo-first

We use **[Rojo](https://rojo.space/)** to sync Lua source from `src/` into Roblox Studio.

**Windows dev path:** `G:\Zundamons-kItchen` — see [`AI/WORKSPACE.md`](AI/WORKSPACE.md) for all agents.

## Repository layout

```
G:\Zundamons-kItchen\
├── default.project.json     # Rojo project map (Studio ↔ filesystem)
├── src/                     # Lua source (ReplicatedStorage, ServerScriptService, Workspace)
├── scripts/
├── docs/
└── AI/
```

## Getting started

See [`docs/windows-first-time-setup.md`](docs/windows-first-time-setup.md) for clone-to-G: instructions.

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm install
npm run rojo:serve
```

In Studio: connect the Rojo plugin to `localhost:34872`, then edit scripts in `src/`.

### Validate locally

```powershell
npm run validate
npm run lint
```

## What stays in Studio (not in git)

- Workspace map (Kitchen, Forest, NPCs, harvest nodes, etc.)
- UI ScreenGuis not yet migrated to Rojo bootstrap
- Sounds, animations, and 3D assets

See [`docs/rojo-workflow.md`](docs/rojo-workflow.md).

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). Default branch: **`main`**.

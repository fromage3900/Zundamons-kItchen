# Zundamon's kItchen — GitHub Build (Roblox + Rojo)

This repository is the collaboration hub and **source of truth for game code** in the Roblox experience **"Zundamon's kItchen"**.

## Workflow: Rojo-first

We use **[Rojo](https://rojo.space/)** to sync Lua source from `src/` into Roblox Studio. This gives us:

- Reviewable diffs on every PR (no 48 MB place exports)
- Fast iteration in VS Code with Luau LSP, StyLua, and Selene
- Deterministic CI via `rojo build`

**World geometry, models, and UI instances** live in Roblox Studio (the published place). **Scripts and config modules** live in this repo under `src/`.

## Repository layout

```
Zundamons-kItchen-GitHub-Build/
├── default.project.json     # Rojo project map (Studio ↔ filesystem)
├── src/
│   ├── ReplicatedStorage/ConfigurationFiles/   # shared configs + modules
│   ├── ServerScriptService/                    # server scripts
│   └── StarterPlayer/StarterPlayerScripts/     # client scripts
├── docs/                    # architecture, style guide, publish checklists — see docs/README.md
├── scripts/validate-structure.mjs
└── workspace/               # local Rojo build output (gitignored)
```

## Getting started

### Prerequisites

1. [Roblox Studio](https://www.roblox.com/create)
2. [Rojo](https://rojo.space/docs/v7/getting-started/installation/) — `npm install` in this folder, or install via Rokit
3. VS Code extensions: open this folder in VS Code and install recommendations from [`.vscode/extensions.json`](.vscode/extensions.json) (Luau LSP, StyLua, Selene, Rojo, etc.)
4. Rojo CLI: `npm install` in this folder (uses `package.json`), **or** [manual install](https://rojo.space/docs/v7/getting-started/installation/) + `rojo plugin install` for Studio

### Daily workflow

```bash
cd Zundamons-kItchen-GitHub-Build
npm install
npm run rojo:serve        # starts Rojo sync server
```

In Studio: connect the Rojo plugin to `localhost:34872`, then edit scripts in `src/`.

### Validate locally

```bash
npm run validate          # checks layout + runs rojo build
```

## What stays in Studio (not in git)

These are **not** synced by Rojo and must exist in the published place:

- `ReplicatedStorage.RemoteEvents` and `ReplicatedStorage.RemoteFunctions`
- Workspace map (Kitchen, Forest, Houses, NPCs, harvest nodes, etc.)
- UI ScreenGuis, sounds, animations, and 3D assets

See [`docs/rojo-workflow.md`](docs/rojo-workflow.md) for the full split and onboarding checklist.

## Project review

See [`docs/project-review.md`](docs/project-review.md) for scorecard and links to architecture, remotes, and security docs.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

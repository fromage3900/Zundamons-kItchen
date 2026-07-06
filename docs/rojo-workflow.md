# Rojo Workflow

This project uses **Rojo 7** as the sole source-control workflow for game code. Place exports are intentionally **not** committed.

## What is in git vs Studio

| In git (`src/`) | In Roblox Studio only |
|---|---|
| Server scripts (`*.server.lua`) | Workspace map, buildings, NPCs |
| Client scripts (`*.client.lua`) | ScreenGuis, LocalScripts wired in Studio |
| Config modules (`ConfigurationFiles/`) | `RemoteEvents` / `RemoteFunctions` folders |
| `default.project.json` | Meshes, animations, sounds, particles |

The published experience (ID `108617605497926`) is the **world container**. This repo is the **code container**.

## First-time setup

```bash
cd G:\Zundamons-kItchen
npm install
rojo plugin install    # installs Studio plugin (once per machine)
npm run rojo:serve
```

In Roblox Studio:

1. Open the published place for Zundamon's kItchen
2. Plugins → Rojo → Connect to `localhost:34872`
3. Confirm `ConfigurationFiles`, `ServerScriptService`, and `StarterPlayerScripts` sync from disk

## Daily development

1. Pull latest `main`
2. `npm run rojo:serve`
3. Edit files in `src/` with VS Code
4. Playtest in Studio (changes sync live)
5. `npm run validate` before opening a PR

## Adding a new script

| Type | File naming | Destination |
|---|---|---|
| Server | `MySystem.server.lua` | `src/ServerScriptService/` |
| Client | `MyUI.client.lua` | `src/StarterPlayer/StarterPlayerScripts/` |
| Shared config | `MyConfig.lua` | `src/ReplicatedStorage/ConfigurationFiles/` |

If you add a new top-level service mapping, update `default.project.json`.

## Adding a new RemoteEvent / RemoteFunction

Remotes are **Studio-managed** today. When adding one:

1. Create the instance under `ReplicatedStorage.RemoteEvents` or `RemoteFunctions` in Studio
2. Document the name and payload schema in the server handler
3. Note it in your PR under "Studio-only dependencies"

Future improvement: define remotes in Rojo using `init.meta.json` or a small bootstrap script.

## Building a local place file (optional)

```bash
npm run rojo:build
# outputs workspace/Zundamons-kItchen.rbxl (gitignored)
```

This produces a **code-only** place. Open it in Studio, then merge into the full world place as needed.

## Migrating from rbxlx exports

The previous workflow committed `source/beantown.rbxlx` (~48 MB). That file has been **removed**. Scripts were already extracted to `src/`; Rojo is now the canonical path.

To recover world-only content from an old export, use `rojo syncback` against a local rbxlx (not committed) if needed.

## Troubleshooting

| Problem | Fix |
|---|---|
| `require` fails for config | Ensure module is under `ConfigurationFiles/` and Rojo is connected |
| Script changes not appearing | Restart `rojo serve`, reconnect Studio plugin |
| `RemoteEvents` not found | Create folders in Studio; they are not in `src/` yet |
| CI fails `rojo build` | Run `npm run validate` locally; check `default.project.json` |

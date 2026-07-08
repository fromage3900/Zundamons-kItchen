# Rojo Workflow — Live Sync (Option C)

**Place ID:** `108617605497926` (cloud)  
**Code repo:** `G:\Zundamons-kItchen\src\`  
**Sync command:** `npm run rojo:serve`

Rojo is the **only** supported way to get script changes from git into Studio during development.

---

## Git vs Studio split

| In git (`src/`) | In cloud place only (Studio) |
|-----------------|------------------------------|
| `ServerScriptService/*.server.lua` | Workspace map, terrain, buildings |
| `StarterPlayerScripts/*.client.lua` | Placed harvest nodes, guest spawns |
| `ConfigurationFiles/*.lua` | Meshes imported in Studio |
| `default.project.json` | Legacy ScreenGuis being phased out |
| `RemoteEvents` / `RemoteFunctions` (partial) | Animations, sounds not yet in Rojo |

The published experience is the **world container**. This repo is the **code container**.

Migrating from the old 48MB `.rbxlx`? Read [`migration-from-legacy-place.md`](migration-from-legacy-place.md) first.

---

## First-time setup

```powershell
G:
git clone https://github.com/fromage3900/Zundamons-kItchen.git Zundamons-kItchen
cd G:\Zundamons-kItchen
npm install
npm run rojo:serve
```

In Roblox Studio:

1. Open place **`108617605497926`** (not a local `.rbxlx`)
2. Plugins → Rojo → Connect → `localhost:34872` (or `34873` if terminal says so)
3. Play → confirm `[ROJO SYNC OK]` in Output

Install Rojo Studio plugin once per machine:

```powershell
npx rojo plugin install
```

---

## Daily development

```powershell
git pull origin main
npm run rojo:serve
```

1. Edit `src/` in VS Code / Cursor
2. Changes appear in Studio while Rojo is connected
3. Playtest in cloud place
4. `npm run validate` before commit
5. World edits → **Save to Roblox** (not git)

Full git steps: [`git-workflow.md`](git-workflow.md).

---

## Ports (do not confuse with Studio MCP)

| Service | Port | Required? |
|---------|------|-----------|
| **Rojo** | `34872` (fallback `34873+`) | **Yes** |
| Studio MCP | `58741` | No — optional AI bridge |

---

## Adding scripts

| Type | Naming | Folder |
|------|--------|--------|
| Server | `MySystem.server.lua` | `src/ServerScriptService/` |
| Client | `MyUI.client.lua` | `src/StarterPlayer/StarterPlayerScripts/` |
| Config | `MyConfig.lua` | `src/ReplicatedStorage/ConfigurationFiles/` |

Update `default.project.json` if you add a new top-level Rojo mapping.

---

## `rojo:build` (optional, not daily)

```powershell
npm run rojo:build
# → workspace/Zundamons-kItchen.rbxl (gitignored)
```

Produces a **code-only** place. Use for CI smoke tests — **not** for replacing the cloud world place.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Script changes not appearing | Restart `rojo:serve`, reconnect plugin |
| `require` fails | Module under `ConfigurationFiles/` or `Shared/`; Rojo connected? |
| WebSocket / port errors | Kill stale `node.exe`; try `34873` |
| Wrong behavior after agent PR | Opened legacy `.rbxlx` instead of cloud place |
| No `[ROJO SYNC OK]` | Rojo not connected or wrong place open |

---

## Sync marker

`src/ReplicatedStorage/ConfigurationFiles/SyncConfig.lua` — bump `label` on meaningful merges so Studio Output confirms which git revision synced.

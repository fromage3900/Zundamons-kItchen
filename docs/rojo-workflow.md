# Rojo Workflow — Live Sync

**Sync command:** `npm run rojo:serve`  
**Project file:** `default.project.json`

Rojo is the supported way to get script changes from `src/` into Roblox Studio during development.

---

## First-time setup

```powershell
G:
cd G:\Zundamons-kItchen
npm install
npm run rojo:serve
```

In Roblox Studio:

1. Open your experience place (File → Open from file, or cloud place)
2. Plugins → **Rojo** → **Connect** → `localhost:34872` (or `34873` if the terminal shows a different port)
3. Play → confirm `[ROJO SYNC OK]` in Output

Install or refresh the Studio plugin once per machine:

```powershell
npm run rojo:plugin-install
```

---

## Rojo version must match (plugin ↔ CLI)

Rojo 7.7 uses a **new sync protocol**. If the Studio plugin and `npm run rojo:serve` CLI are on different lines (e.g. plugin **7.7.0** + CLI **7.6.1**), connect fails with:

```text
Promise.Error(ExecutionError) … rejectWrongProtocolVersion
attempt to index number with 'protocolVersion'
```

**Fix A — upgrade CLI to match Marketplace plugin 7.7.0 (recommended):**

```powershell
cd G:\Zundamons-kItchen
git pull origin main
npm install
npm run rojo:serve
```

This repo pins `rojo@1.0.3-rojo7.7.0-rc.1` (protocol-compatible with Marketplace **7.7.0**). For the exact **7.7.0** binary, use [Rokit](https://github.com/rojo-rbx/rokit):

```powershell
rokit install
rokit run rojo serve default.project.json
```

(`rokit.toml` in repo root pins `rojo-rbx/rojo@7.7.0`.)

**Fix B — downgrade Studio plugin to match CLI 7.6.1:**

```powershell
npm run rojo:plugin-install
```

Restart Roblox Studio. This replaces the Marketplace plugin with the version bundled with the npm CLI. Use only if you intentionally stay on Rojo 7.6.x.

After either fix: Plugins → Rojo → **Connect** → confirm **Connected** (not just “listening” in the terminal).

---

## Daily development

```powershell
git pull origin main
npm run rojo:serve
```

1. Edit `src/` in VS Code / Cursor
2. Changes appear in Studio while Rojo is connected
3. Playtest
4. `npm run validate` before commit

---

## Ports

| Service | Port | Required? |
|---------|------|-----------|
| **Rojo** | `34872` (fallback `34873+`) | **Yes** |
| Studio MCP | `58741` | No — optional AI bridge |

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `protocolVersion` / `rejectWrongProtocolVersion` | See **Rojo version must match** above |
| Script changes not appearing | Restart `rojo:serve`, reconnect plugin |
| `require` fails | Module under `ConfigurationFiles/` or `Shared/`; Rojo connected? |
| WebSocket / port errors | Kill stale `node.exe`; try `34873` |
| No `[ROJO SYNC OK]` | Rojo not connected |

---

## Sync marker

`src/ReplicatedStorage/ConfigurationFiles/SyncConfig.lua` — bump `label` on meaningful merges so Studio Output confirms which git revision synced.

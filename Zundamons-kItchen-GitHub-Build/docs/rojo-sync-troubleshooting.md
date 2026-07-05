# Rojo Sync Troubleshooting

**Symptom:** Git is up to date but nothing new appears in Roblox Studio.

---

## What Rojo syncs (and what it does NOT)

| Syncs from git | Does NOT sync (Studio-only) |
|----------------|----------------------------|
| `ServerScriptService/*.server.lua` | Terrain, buildings, NPCs |
| `StarterPlayerScripts/*.client.lua` | ScreenGuis, sounds, meshes |
| `ReplicatedStorage/ConfigurationFiles` | `ServerStorage.Plants`, `ServerStorage.Decorations` |
| Remotes defined in `default.project.json` | Gather node parts in `Workspace` |
| `Workspace/Kitchen/Counters` (empty placeholder) | Skybox textures, decoration models |

If you expected **new world art** (gather nodes, decoration models, skybox), that must be placed or uploaded in Studio — or built via **Roblox Studio MCP** on your machine. Rojo only pushes **Lua + config + remotes**.

---

## Checklist (do in order)

### 1. Pull latest code

```bash
git pull origin main
cd Zundamons-kItchen-GitHub-Build   # ← required; project is NOT at repo root
```

### 2. Install toolchain (once per machine)

```bash
rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene
rokit install
rojo plugin install
```

Verify: `~/.rokit/bin/rojo --version` → **7.7.0**

### 3. Start Rojo serve from the correct folder

```bash
cd Zundamons-kItchen-GitHub-Build
npm run rojo:serve
```

You should see:

```
Rojo server listening on port 34872
```

**Common mistake:** running `rojo serve` from the repo root (no `default.project.json` there). Use the nested folder or `npm run rojo:serve` from repo root (wrapper script).

### 4. Open the RIGHT place in Studio

| ✅ Correct | ❌ Wrong |
|-----------|---------|
| Published experience **108617605497926** | Empty place from `rojo build` (code-only, no world) |
| Your team's full kitchen map | A new blank Baseplate |

Creator Hub → Zundamon's kItchen → **Edit in Studio**.

### 5. Connect the Rojo plugin

1. **Plugins → Rojo**
2. Click **Connect** (host: `localhost`, port: `34872`)
3. Plugin should show **Connected** / green status

If Connect fails:

- Restart `rojo serve`
- Restart Studio
- Check firewall isn't blocking `localhost:34872`
- Re-run `rojo plugin install` and restart Studio

### 6. Verify sync in Explorer

After connecting, check these appear or update under:

- `ServerScriptService/000_RojoSyncMarker`
- `ServerScriptService/00_RemoteBootstrap`
- `ServerScriptService/DecorationPlacer`
- `ReplicatedStorage/ConfigurationFiles/SyncConfig`
- `ReplicatedStorage/RemoteEvents/ZoneVisited`

### 7. Verify in Output (Play mode)

Press **Play**. Server Output should show:

```
==========================================================
[ROJO SYNC OK] Zundamon's kItchen — main-2026-07-05-rojo-remotes
[ROJO SYNC OK] ServerScriptService scripts loaded from git via Rojo
...
[RemoteBootstrap] Networking instances ready
[DecorationPlacer] Ready — buy/place via BuyDecoration, PlaceDecoration remotes
```

If you **don't** see `[ROJO SYNC OK]`, Rojo did not sync — go back to steps 3–5.

---

## Roblox MCP vs Rojo

| Tool | Role |
|------|------|
| **Rojo** | Bulk sync all `src/` Lua from git → Studio |
| **Roblox Studio MCP** | Live inspect/edit **one open Studio session** (local Cursor only) |

MCP does **not** replace `rojo serve`. Use both: Rojo for code from git, MCP for place inspection and Studio-side edits.

---

## Still stuck?

| Symptom | Likely cause |
|---------|--------------|
| Plugin connects but scripts unchanged | Old Studio session; disconnect/reconnect Rojo |
| `require` errors on boot | Rojo not connected before Play |
| Remotes missing | Connect Rojo after our remotes-in-project update; or `00_RemoteBootstrap` creates them at runtime |
| World looks empty | Opened `rojo build` output instead of published place |
| New recipes work but no gather nodes | Gather nodes are Studio-placed parts — see `docs/zunda-design-bible.md` |
| Decorations don't appear on plot | Need `ServerStorage.Decorations` models in Studio |

Run locally:

```bash
cd Zundamons-kItchen-GitHub-Build
npm run validate
```

If that passes, the repo is fine — the issue is Studio connection or wrong place/folder.

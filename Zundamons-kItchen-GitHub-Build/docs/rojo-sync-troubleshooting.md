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

Open a **terminal** on your computer (PowerShell, cmd, or Terminal). **Leave it running** while Studio is connected.

```bash
cd path/to/Zundamons-kItchen/Zundamons-kItchen-GitHub-Build
rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene
rokit install
npm run rojo:serve
```

**Windows (PowerShell)** — same commands; if `rokit` is not found, install Rokit from https://github.com/rojo-rbx/rokit#installation then retry.

You should see:

```
Starting Rojo server...
  connect Studio plugin to localhost:34872
Rojo server listening on port 34872
```

**Only after** that terminal shows "listening", go to Studio → **Plugins → Rojo → Connect**.

If Studio says *"Couldn't connect to the Rojo server"* → the terminal is not running, wrong port, or firewall blocked `localhost:34872`.

### Plugin error: "denied script injection permission"

Rojo connected but Studio blocked script sync. Fix:

1. Studio ribbon → **Plugins** tab → **Manage Plugins**
2. Find **Rojo** in the list
3. Under the description, click **Script Injection Denied** (or the pencil/edit icon)
4. Turn **Script Injection** **ON**
5. **Restart Studio**, run `npm run rojo:serve` again, then **Connect**

Without this permission, Rojo cannot push `src/` scripts into the place.

### 4. Open the RIGHT place in Studio

| ✅ Correct | ❌ Wrong |
|-----------|---------|
| Published experience **108617605497926** | **`beantown.rbxlx`** (legacy 48 MB export — scripts live in git now) |
| Your team's full kitchen map from Creator Hub | Empty place from `rojo build` (code-only, no world) |
| Edit via Creator Hub → Zundamon's kItchen | Old local `source/beantown.rbxlx` file |

Creator Hub → Zundamon's kItchen → **Edit in Studio**.

> **Do not open `beantown.rbxlx`.** That was the old workflow before Rojo. All scripts were extracted to `src/`; the file was removed from git. Opening it loads stale embedded scripts and Rojo won't replace your workflow cleanly.

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

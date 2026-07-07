# Canonical workspace (all agents)

**Last updated:** 2026-07-07 (MCP port + Rojo) · Sync: see `SyncConfig.lua`

## Project identity (verify first)

| Check | Expected |
|-------|----------|
| **Repo root (Windows)** | `G:\Zundamons-kItchen` |
| **Git remote** | `github.com/fromage3900/Zundamons-kItchen` |
| **Rojo project** | `G:\Zundamons-kItchen\default.project.json` |
| **Roblox place** | Experience **`108617605497926`** |
| **Game** | Zundamon's kItchen |

```powershell
G:
cd G:\Zundamons-kItchen
git remote -v
git log -1 --oneline
git pull origin main
```

Do **not** use `C:\Users\froma\Zundamons-kItchen-GitHub-Build` or other nested clones.

## Two local ports (do not confuse)

| Service | Port | Purpose |
|---------|------|---------|
| **Rojo** | `34872` (fallback `34873+`) | Syncs `src/` Lua → Studio (**required for v0.1**) |
| **Studio MCP** | `58741` (v2.6+ default) | Optional AI bridge into Studio instances |

MCP stuck on `localhost:58741`? See [`docs/studio-mcp-troubleshooting.md`](../docs/studio-mcp-troubleshooting.md). For playtesting, **Rojo alone is enough**.

## Windows — primary dev machine

| Item | Path |
|------|------|
| **Repo root** | `G:\Zundamons-kItchen` |
| **Rojo project** | `G:\Zundamons-kItchen\default.project.json` |
| **Lua source** | `G:\Zundamons-kItchen\src\` |
| **Roblox place** | Experience `108617605497926` (Studio only) |

All agents (Cursor, Cline, OpenCode) should assume commands run from **`G:\Zundamons-kItchen`**, not `C:\Users\froma\...` and not the old nested `Zundamons-kItchen-GitHub-Build\` folder.

### Daily commands (PowerShell)

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run security
npm run rojo:serve
```

Studio: Plugins → Rojo → Connect `localhost:34872` (or **34873** if port fallback — see terminal)

### First-time clone to G:

```powershell
G:
git clone https://github.com/fromage3900/Zundamons-kItchen.git Zundamons-kItchen
cd G:\Zundamons-kItchen
rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene
rokit install
npm install
npm run rojo:serve
```

### Migrating from C: (one time)

If the repo still lives under `C:\Users\froma\Zundamons-kItchen`:

```powershell
# Close terminals, VS Code, and Rojo serve first
Move-Item C:\Users\froma\Zundamons-kItchen G:\Zundamons-kItchen
```

Then reopen VS Code / Cursor with **File → Open Folder → `G:\Zundamons-kItchen`**.

Update MCP config if used: `--root=G:\Zundamons-kItchen` (see `docs/mcp-setup-guide.md`).

## Repo layout (flat — no nested subfolder)

```
G:\Zundamons-kItchen\
├── default.project.json
├── src\
├── scripts\
├── docs\
└── AI\
```

## Sync verification

After Rojo connect + Play, Output must show:

```
[ROJO SYNC OK] Client — <SyncConfig.label>
```

See `src/ReplicatedStorage/ConfigurationFiles/SyncConfig.lua`.

## Do not use

- `C:\Users\froma\Zundamons-kItchen-GitHub-Build` (removed — nested layout)
- `source/` or `beantown.rbxlx` (legacy place export, not Rojo source)
- Repo root on `C:\` unless G: is unavailable

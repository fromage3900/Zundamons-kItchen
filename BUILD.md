# Build Guide — Clone to Running Game (Option C)

**New to git / VS Code?** Start with **[GETTING_STARTED.md](GETTING_STARTED.md)** (written for Electra).

**Migrating from the old 48MB place?** **[docs/migration-from-legacy-place.md](docs/migration-from-legacy-place.md)** first.

---

## Architecture (two containers)

| Container | Location | Sync |
|-----------|----------|------|
| **Code** | `G:\Zundamons-kItchen\src\` | `npm run rojo:serve` |
| **World** | Cloud place `108617605497926` | Studio → Save to Roblox |

Do **not** treat a local `.rbxlx` (~48–49MB) as the daily driver. It is not a Rojo project. Scripts in git will not reach a place file you open offline unless Rojo is connected to the **cloud place**.

---

## First-time setup

```powershell
git clone https://github.com/fromage3900/Zundamons-kItchen.git
cd Zundamons-kItchen
npm install
```

Optional (AI agent orchestrator):

```powershell
pip install -r scripts/agent_orchestrator/requirements.txt
ollama serve
npm run deploy-models
```

---

## Daily build loop (Option C — canonical)

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

Studio:

1. Open place **`108617605497926`**
2. Rojo → Connect (`34872` / `34873`)
3. Play → `[ROJO SYNC OK]` in Output
4. Edit `src/` — live sync

Git workflow: [`docs/git-workflow.md`](docs/git-workflow.md)  
Rojo details: [`docs/rojo-workflow.md`](docs/rojo-workflow.md)

---

## Populate dev nodes (optional)

If the world has no gather nodes yet, run in Studio command bar:

```lua
require(game.ServerScriptService.DevTools["PopulateWorld.dev"]).populate()
```

This spawns **colored cube** placeholders — enough for gather-craft-serve testing. Real meshes come from Studio import + `MeshAssets.lua`.

---

## Mesh import (as you go)

Meshes are **not** in git as 48MB place files. Pipeline:

```powershell
# 1. Drop OBJ/FBX in Assets/Upload/
# 2. Generate import script
npm run import:scan
# 3. Run output in Studio command bar
# 4. Save JSON → npm run import:apply
```

See `docs/MESH_IMPORT_WORKFLOW.md` (note: localized meshes live in cloud place, not committed rbxlx).

---

## Validate before commit

```powershell
npm run validate      # Structure check (run every commit)
npm run lint          # Style (optional)
npm run overnight     # Full audit (optional, not every PR)
rojo build            # CI-style build smoke test
```

---

## What NOT to use daily

| Command / file | Why |
|----------------|-----|
| `npm run rojo:build` + open `.rbxl` | Code-only; no world |
| Local `Zundamons-kItchen.rbxlx` | Legacy; not Rojo-synced daily driver |
| `export_world_structure` to `src/` | One-off rescue only — see migration doc |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `rojo serve` port in use | `netstat -ano \| findstr 34872` → kill PID, or use `34873` |
| Rojo disconnected | Restart serve + reconnect |
| Scripts not syncing | Wrong place open — use `108617605497926` |
| Game different from teammate | They pulled git but you didn't Save world to Roblox (or vice versa) |
| Nothing visible | Run `PopulateWorld.dev` or complete migration Phase 1 |

---

## CI/CD

| Trigger | Runs |
|---------|------|
| Push to `main` | Structure validation + lint |
| Nightly | Full audit + build test |

See `.github/workflows/` for details.

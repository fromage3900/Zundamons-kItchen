# Build Guide — From Clone to Running Game

## First-Time Setup

```powershell
# 1. Clone the repo
git clone https://github.com/fromage3900/Zundamons-kItchen.git
cd Zundamons-kItchen

# 2. Install Node dependencies (Rojo CLI, linters)
npm install

# 3. Install Python dependencies (agent orchestrator)
pip install -r scripts/agent_orchestrator/requirements.txt

# 4. Deploy AI models (requires Ollama running)
ollama serve              # Start Ollama in background
npm run deploy-models     # Auto-pull all needed models
```

## Daily Build Loop

```powershell
# Terminal 1: Start Rojo sync
npm run rojo:serve
# Keeps running — syncs src/ changes to Studio live

# Studio: Connect Rojo plugin to localhost:34872
# Edit scripts in src/ — they auto-sync
```

## Populate the World (One-Time)

After syncing scripts, run in Studio command bar:
```lua
require(game.ServerScriptService.DevTools["PopulateWorld.dev"]).populate()
```

This places:
- Colored cube gathering nodes in a grid
- 4 guest spawn points with yellow markers
- 6 patrol waypoints
- 1 scatter region (for ScatterService)
- Run `/scatter zunda_forest` to scatter via ScatterService

## Import Meshes (As You Go)

```powershell
# 1. Place OBJ/FBX/GLB files in Assets/Upload/
# 2. Scan and generate import script:
python scripts/agent_orchestrator/tools/mesh_pipeline.py
# 3. Open reports/mesh_pipeline/studio_import.luau
# 4. Paste contents into Studio command bar
# 5. Copy resulting rbxassetid:// values
# 6. Update MeshAssets.lua or config with new IDs
```

## Generate Quest Content

```powershell
# Auto-generate quests for uncovered recipes
npm run generate-quests
# Output: reports/generated/generated_quests_<timestamp>.lua
# Review then merge into QuestConfig.lua
```

## Validate Before Commit

```powershell
npm run validate      # Check project structure
npm run overnight     # Full config audit + asset check
npm run lint          # Style check
rojo build            # Verify build succeeds
```

## CI/CD Pipeline

| Trigger | What runs | When |
|---------|-----------|------|
| Push to main | Structure validation + lint | Every push |
| Daily 6AM UTC | Full audit + build test | Nightly |
| Manual dispatch | Same as nightly | On demand |

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `rojo serve` fails to start | Port 34872 in use — `netstat -ano | findstr 34872` then `taskkill /PID <id>` |
| Studio shows "Rojo disconnected" | Restart `rojo serve` + reconnect in Studio plugin |
| Scripts not syncing | Check `default.project.json` paths exist in `src/` |
| `npm run generate-quests` fails | Run `npm run deploy-models` first |
| Game starts but nothing visible | Run `PopulateWorld.dev` in command bar |
| Guests are invisible cubes | Place `GuestSpawn`-tagged parts in world, or use hardcoded fallback |
| Companion mesh missing | Import `zundapalupdate2.fbx` via mesh pipeline |

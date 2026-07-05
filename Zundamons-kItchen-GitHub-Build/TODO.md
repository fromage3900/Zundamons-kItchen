# TODO — Zundamon's kItchen (Rojo Build)

## Completed
- [x] GitHub repo created (fromage3900/Zundamons-kItchen)
- [x] Rojo project (`default.project.json`) configured
- [x] 106+ scripts under `src/`
- [x] Harvesting system polish
- [x] **Committed to Rojo** — removed `source/beantown.rbxlx`
- [x] Merged Rojo migration to `main`
- [x] `.vscode/extensions.json` with 11 recommended extensions
- [x] `docs/project-review.md` scorecard (8/10 overall)
- [x] `docs/remotes.md` remote catalog
- [x] `docs/security-audit.md` applied fixes
- [x] `PlayerDataService` replaces `_G.data` on server
- [x] Planters fixes (1Hz grow loop, nil guards, deduped plantEvent)
- [x] Security fixes: ServingSystem, InventoryServer, ToolManager, LootModule
- [x] Filename cleanup (`SprintOnShift.server.lua`, DoubleJump → legacy-notes)
- [x] CI: validate + stylua check on `src/`
- [x] `docs/zunda-design-bible.md` — asset catalog, gameplay loop, expansion playbook
- [x] Rokit toolchain (`rokit.toml`, lint scripts, `docs/toolchain.md`)
- [x] Atmosphere phases (PostFX, SkyConfig, weather/cloud tuning)
- [x] Zone visit tracking (`ZoneVisitConfig`, teleporter + lore entrances)
- [x] `DecorationPlacer` service for `DecorationConfig` catalog
- [x] Gather handlers for Edamame Pod, Zunda Leaf, Sweet Pea, Pea Flower
- [x] Remotes in Rojo (`default.project.json` + `RemoteBootstrap` + `RemoteManifest`)
- [x] `LootModule` / `RewardCore` ServerScriptService shims for Rojo sync
- [x] GitHub default branch set to `main` (PR #3 merged)

## Next steps (Studio / product — not blocking git)
- [ ] Delete stale `master` branch on GitHub (optional cleanup; 19 commits behind `main`)
- [ ] Install Rojo Studio plugin on dev machines (`rojo plugin install`)
- [ ] Place `ServerStorage.Decorations` models + new gather nodes in published place
- [ ] Upload 6-face skybox IDs into `SkyConfig.sky`
- [ ] Replace Robux DevProduct IDs and clothing `assetId` placeholders
- [ ] Wire `QuestManager` → `QuestConfig` (30+ quests dormant)
- [ ] Decoration shop client UI (server remotes ready)
- [ ] Expand Selene lint scope beyond `Services/` once baseline is clean
- [ ] Bootstrap remaining Studio-only UI in Rojo (optional future)

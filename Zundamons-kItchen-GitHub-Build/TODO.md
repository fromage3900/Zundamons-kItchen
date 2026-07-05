# TODO — Zundamon's kItchen (Rojo Build)

## Completed
- [x] GitHub repo created (fromage3900/Zundamons-kItchen)
- [x] Rojo project (`default.project.json`) configured
- [x] 98 scripts under `src/`
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

## Next steps
- [ ] Wire `zones_visited` + unify zone keys (see `docs/zunda-design-bible.md`) — **zones_visited wired** (ZoneVisitConfig + Teleporter + lore entrances)
- [x] `DecorationPlacer` service for `DecorationConfig` catalog
- [x] Gather handlers for Edamame Pod, Zunda Leaf, Sweet Pea, Pea Flower
- [ ] Set `main` as GitHub default branch (requires repo admin; `master` is still default)
- [ ] Install Rojo Studio plugin on dev machines (`rojo plugin install`)
- [ ] Expand Selene lint scope beyond `Services/` once baseline is clean
- [ ] Move `RewardCore` remote wiring to `ServerScriptService/`
- [ ] Bootstrap remotes in Rojo (optional future)

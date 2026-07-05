# TODO — Zundamon's kItchen (GitHub Build)

## Completed
- [x] Create GitHub repo (fromage3900/Zundamons-kItchen)
- [x] Fix .gitignore — removed `*.rbxlx`/`*.rbxmx` so exports can be tracked
- [x] Branch renamed: `master` → `main`
- [x] Remote origin configured
- [x] `.vscode/settings.json` with keyword highlighting & tool config
- [x] `default.project.json` for Rojo
- [x] `source/beantown.rbxlx` — exported from Studio (48 MB text format)
- [x] 113 scripts extracted from .rbxlx into `src/`
- [x] Folder structure created for Workspace (Kitchen, Forest, Houses, Characters, NPCs, Companions)

## Harvesting System Polish
- [x] `HarvestConfig.lua` — central tuning (distances, timings, cooldowns, visuals)
- [x] `HarvestController.client.lua` — progress bar, animations, sounds, particles, cancel-on-move
- [x] `HarvestValidator.server.lua` — distance checks, rate limiting, cooldowns, exploit prevention
- [x] Arquitecture docs updated in `docs/architecture-overview.md`

## Next Steps
- [ ] Install VS Code extensions (Rojo, Luau LSP, StyLua, Selene, Error Lens, etc.)
- [ ] Install Rojo CLI for Studio sync
- [ ] Add `.gitkeep` files to empty environment folders
- [ ] Push to GitHub and verify CI passes
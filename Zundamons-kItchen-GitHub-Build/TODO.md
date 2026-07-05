# TODO — Zundamon's kItchen (Rojo Build)

## Completed
- [x] GitHub repo created (fromage3900/Zundamons-kItchen)
- [x] Rojo project (`default.project.json`) configured
- [x] 98 scripts under `src/` (extracted from Studio export)
- [x] Harvesting system polish (config, client controller, server validator)
- [x] Architecture + code review docs
- [x] **Committed to Rojo** — removed `source/beantown.rbxlx` (~48 MB)
- [x] Aligned `ConfigurationFiles` filesystem paths with Studio runtime
- [x] CI validates `rojo build` instead of rbxlx exports

## Next steps
- [ ] Merge Rojo migration to `main`; set `main` as default branch (retire `master` scaffold)
- [ ] `npm run validate` green in GitHub Actions
- [ ] Document remotes in `docs/remotes.md`
- [ ] Install Rojo Studio plugin on dev machines (`rojo plugin install`)
- [ ] Security audit: ServingSystem, InventoryServer, ToolManager, LootModule
- [ ] Replace `_G.data` with PlayerDataService module
- [ ] Add Selene + StyLua to CI
- [ ] Rename scripts with spaces in filenames

# Roadmap & Future Work

See [`WORK_QUEUE.md`](WORK_QUEUE.md) for live task ownership across Cursor, OpenCode, and Cline.

## Completed (July 2026)

- [x] Rojo remotes bootstrapped in `default.project.json` + `RemoteBootstrap`
- [x] Single `ProcessReceipt` owner (`RobuxStoreServer`)
- [x] Zone visit tracking wired to quests
- [x] `QuestManager` reads `QuestConfig` via `QuestProgress` (31 quests)
- [x] Zundapal LLM free chat + player context + proactive hints
- [x] Companion + NPC quest stat hooks (`companion_chats`, `npc_chats`)
- [x] Master Chef Zunda NPC + `master_chef` LLM persona
- [x] Planters migrated to `PlayerDataService`; decoration shop client (H key)
- [x] Git security hooks, remote rate limits, secret scanning
- [x] Legacy vendor scripts removed; watercolour vignette overlay stripped
- [x] LLM bugfixes (history, output filter, per-persona cooldown)
- [x] Gather consolidation started (`GatherConfig`, Mineable flora deduped)

## Priority 1: Hardening & Stabilization

- [ ] Consolidate `MarketplaceService.ProcessReceipt` + product catalogs (Cline — WORK_QUEUE C3)
- [ ] Standardize economy fields (`Gold` / `current_gold` / `gold`)
- [ ] Move `RewardCore` remote wiring fully to `ServerScriptService`
- [ ] Audit remaining remotes for payload validation

## Priority 2: Refactoring

- [ ] Adopt `UIComponents` in client menus (OpenCode — WORK_QUEUE O2)
- [ ] Client UI Rojo bootstrap (reduce Studio ScreenGui dependency)
- [ ] Wire or remove unused `ItemConfig` / `ShopConfig`

## Priority 3: New Features / Studio

- [ ] LLM chat UX polish — history UI, streaming (OpenCode — L3)
- [ ] Studio world content: gather nodes, decorations, skybox, Master Chef NPC tag
- [ ] Expand daily quest integration

## Priority 4: Tooling

- [ ] Expand Selene lint scope beyond `Services/`
- [ ] Automated playtest scripts (future)

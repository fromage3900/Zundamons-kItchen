# Roadmap & Future Work

See [`WORK_QUEUE.md`](WORK_QUEUE.md) for live task ownership across Cursor, OpenCode, and Cline.

## Completed (July 2026)

- [x] Rojo remotes bootstrapped in `default.project.json` + `RemoteBootstrap`
- [x] Single `ProcessReceipt` owner (`RobuxStoreServer`)
- [x] Zone visit tracking wired to quests
- [x] `QuestManager` reads `QuestConfig` via `QuestProgress`
- [x] Zundapal LLM free chat Phase 1 (server proxy + VN UI)
- [x] Zundapal LLM Phase 2: player context + proactive hints (NotifyAction)

## Priority 1: Hardening & Stabilization

- [ ] Audit remaining remotes (`GetCompendium`, etc.) for payload validation
- [ ] Consolidate `MarketplaceService.ProcessReceipt` into dedicated service (Cline — WORK_QUEUE C3)
- [ ] Move `RewardCore` remote wiring fully to `ServerScriptService`

## Priority 2: Refactoring

- [ ] Migrate `Planters.server.lua` off `_G.data` (Cline — WORK_QUEUE C1)
- [ ] Standardize economy variables (Gold vs current_gold)
- [ ] Adopt `UIComponents` in client menus (OpenCode — WORK_QUEUE O2)

## Priority 3: New Features

- [ ] Decoration shop client UI (OpenCode — WORK_QUEUE O1)
- [ ] Quest stat hooks for companion/npc chat (Cline — WORK_QUEUE C2)
- [ ] Expand daily quest integration
- [ ] Studio world content: gather nodes, decorations, skybox

## Priority 4: Tooling

- [ ] Expand Selene lint scope beyond `Services/`
- [ ] Automated playtest scripts (future)

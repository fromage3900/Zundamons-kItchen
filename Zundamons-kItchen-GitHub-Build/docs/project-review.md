# Project Review — Zundamon's kItchen

**Date:** 2026-07-06  
**Reviewer:** Cursor Cloud Agent  
**Scope:** Full repository audit — Rojo-first workflow, gameplay systems, multi-agent readiness

---

## 1. Repo Hygiene

| Check | Status | Notes |
|---|---|---|
| Rojo-first workflow | PASS | All code under `src/`; `default.project.json` is source of truth |
| No place exports in git | PASS | `source/` and `*.rbxl(x)` blocked by `.gitignore` |
| Legacy `beantown.rbxlx` removed | PASS | Do not open legacy export — use published place `108617605497926` |
| CI validation | PASS | `npm run validate` + secret scan + git hygiene |
| Branch default | PASS | `main` is default; stale `master` optional cleanup |

---

## 2. Architecture and Maintainability

| Check | Status | Notes |
|---|---|---|
| DataModel mirror in `src/` | PASS | 116+ Lua files under ReplicatedStorage, ServerScriptService, StarterPlayer |
| Config modules centralized | PASS | `ConfigurationFiles/` holds tuning data |
| PlayerDataService adoption | PASS | Planters migrated; 20+ server scripts use canonical store |
| Quest system unified | PASS | `QuestManager` reads `QuestConfig` via `QuestProgress` evaluator |
| Remote bootstrap | PASS | `00_RemoteBootstrap`, `RemoteManifest`, remotes in project JSON |

### Strengths

- Clear separation: configs vs server logic vs client controllers
- `QuestProgress.lua` — pure side-effect-free quest evaluation
- `ZoneVisitConfig` bridges Studio zone names, teleporters, and quest aliases
- Harvest polish layer with server-side `HarvestValidator`

### Remaining Issues

1. **`_G.data` legacy** — Removed from `Planters.server.lua`. Some client comments still reference it; server uses `PlayerDataService` only.
2. **Config side effects** — `RewardCore.lua` and `LootModule.lua` in `ConfigurationFiles/` still contain active listeners (documented in environment review).
3. **Missing `--!strict`** — Most ModuleScripts lack strict typing.

---

## 3. Networking and Security

| Check | Status | Notes |
|---|---|---|
| ProcessReceipt single owner | PASS | `RobuxStoreServer` owns handler; duplicate removed from `CompanionShopServer` |
| Harvest validation | PASS | Distance, cooldown, rate limit in `HarvestValidator` |
| AdvancedRewards debounce | PASS | Rate limiting on remote actions |
| ClickDetector trust | PASS | HarvestValidator + planter/plant distance + rate limits |
| DecorationPlacer validation | PASS | Server validates ownership, gold, plot bounds |

---

## 4. Performance

| Check | Status | Notes |
|---|---|---|
| Planters growth loop | PASS | Fixed to 1 Hz (was Heartbeat every frame) |
| Harvest controller | PASS | Heartbeat only during active harvest |
| MaterialsScript polling | PARTIAL | Still polls every 5 seconds — should be event-driven |

---

## 5. Gameplay Systems

| System | Status | Notes |
|---|---|---|
| Harvest polish | Complete | Progress bar, cancel-on-move, effects, server validation |
| Zone visit tracking | Complete | Teleporter + lore entrances → `zones_visited` |
| Quest panel | Complete | ~30 quests from `QuestConfig`; milestones with VN unlock hints |
| DecorationPlacer | Complete | Buy/place/restore + **DecorationShop.client** (H key) |
| Planters / planting | Complete | `PlayerDataService` + `PlantingMenu.client` wired to `ShowPlantingMenu` |
| Gather handlers | Code ready | Edamame, Zunda Leaf, Sweet Pea, Pea Flower — need Studio nodes |
| Atmosphere PostFX | Partial | Client module wired; skybox texture IDs empty in `SkyConfig` |
| Monetization | Placeholders | DevProduct IDs and clothing `assetId`s need real values |

### Quest System (July 2026)

- **Before:** `QuestManager` hardcoded 4 milestone quests; `QuestConfig` dormant
- **After:** All `QuestConfig.default_quests` active via `QuestProgress.evaluate()`
- **Persistence:** `completed_quests` saved in `PlayerDataService`
- **VN integration:** Milestone quests retain `unlock_hint` for `QuestCompleted` events
- **Stat hooks:** `companion_chats` (companion click + LLM reply) and `npc_chats` (`RecordNpcChat` from zone NPC VN) wired via `CompanionConfig` / `CompanionStats` (see `docs/companion-integration-audit.md`)

---

## 6. Toolchain and Studio Sync

| Check | Status | Notes |
|---|---|---|
| Rokit + Rojo 7.7 | PASS | `rokit.toml`, Windows `.exe` resolution in `ensure-rokit.mjs` |
| Sync marker | PASS | `[ROJO SYNC OK]` in Output via `000_RojoSyncMarker` |
| Windows setup docs | PASS | `docs/windows-first-time-setup.md`, `docs/rojo-sync-troubleshooting.md` |
| Studio world content | Not in git | Map, decorations, gather nodes — Creator Hub work |

---

## 7. Multi-Agent Coordination

| Check | Status | Notes |
|---|---|---|
| AI guidance system | PASS | `AI/` folder with rules, architecture, prompts |
| Work queue | PASS | `AI/WORK_QUEUE.md` — task ownership for Cursor, OpenCode, Cline |
| Branch conventions | PASS | `cursor/*`, `opencode/*`, `cline/*` documented in `CONTRIBUTING.md` |

---

## 8. Overall Assessment

### Summary

The project is in **good shape for active development**. The Rojo pipeline works, quest and zone systems are wired, and documentation supports parallel AI agents. The main gap between "code complete" and "public playtest" is **Studio world content** (map art, decoration models, gather node placement, skybox uploads).

### Critical Next Steps (Studio)

1. Place gather nodes and tag them for `ZundaGatherServer`
2. Add `ServerStorage.Decorations` models matching `DecorationConfig`
3. Upload skybox face IDs into `SkyConfig.sky`

### Critical Next Steps (Code — see TODO.md and WORK_QUEUE)

1. Merge feature branches to `main` before publish (see `docs/publish-tonight.md`)
2. Adopt `UIComponents` in remaining client menus (OpenCode O2)
3. MarketplaceService implementation (Cline C3)

### Score: 8/10

| Area | Score |
|---|---|
| Repo / toolchain | 9/10 |
| Architecture | 7/10 |
| Security | 7.5/10 |
| Performance | 8/10 |
| Gameplay completeness | 7/10 |
| Shippable as public game | 6/10 |

See [`TODO.md`](../TODO.md) for tracked next steps.

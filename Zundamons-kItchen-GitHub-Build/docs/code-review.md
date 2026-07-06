# Code Review — Zundamon's kItchen (Deep Dive)

> **Superseded for security/publish status** by [`security-audit.md`](security-audit.md), [`project-review.md`](project-review.md), and [`atmosphere-gameplay-audit.md`](atmosphere-gameplay-audit.md). Kept for July 2026 architecture snapshot.

Review date: 2026-07-05  
Scope: `src/` codebase (~98 Lua files) after Rojo migration  
Experience ID: `108617605497926`

## Executive summary

The game is a **feature-rich life-sim / kitchen RPG** with harvesting, crafting, cooking minigames, fishing, companions, quests, building, weather, VN dialogue, and DataStore persistence. The harvesting stack is the most recently polished and best structured area.

**Overall maturity:** playable prototype with substantial systems, but architectural debt from rapid Studio iteration. Committing to Rojo is the right move; the next phase should focus on **state management**, **remote security**, and **path consistency**.

---

## Codebase metrics

| Metric | Count |
|---|---|
| Lua files in `src/` | 98 |
| Server scripts | ~40 |
| Client scripts | ~33 |
| Config modules | ~25 |
| Largest client script | `VNController.client.lua` (~722 lines) |
| Largest config | `QuestConfig.lua` (~404 lines) |

---

## Strengths

### 1. Harvesting system (recent polish)

`HarvestValidator.server.lua` is the best-written module in the repo:

- `--!strict` typing
- Centralized config via `HarvestConfig`
- Server-side distance, rate limit (5/sec), and per-node cooldown
- Clear validation pipeline

`HarvestController.client.lua` mirrors this with cancel-on-move, progress UI, and config-driven timings.

### 2. Config-driven design

Most gameplay tuning lives in `ConfigurationFiles/` (`ItemConfig`, `QuestConfig`, `CraftConfig`, etc.), which is the right pattern for a content-heavy game.

### 3. Server-authoritative intent

Key flows (serving guests, fishing, inventory, crafting) route through server scripts with `RemoteFunction` handlers rather than trusting client state directly.

### 4. Documented architecture

`docs/architecture-overview.md` maps systems clearly; harvesting flow is well documented.

---

## Critical issues (fix soon)

### 1. Global state (`_G`) for player data

`DataManager.server.lua` stores all player progression in `_G.data[playerName]`:

```lua
_G.data[playerName] = loaded
```

**Risk:** global mutable state is hard to test, race-prone, and accessible from any script (including exploitable client paths if misused). Multiple scripts read/write `_G.data` and `_G.mydata` on client.

**Recommendation:** Replace with a `PlayerDataService` module that exposes explicit `get(player)` / `set(player)` APIs. Migrate callers incrementally.

### 2. RemoteEvents / RemoteFunctions not in source control

~20+ client scripts `WaitForChild` on `ReplicatedStorage.RemoteEvents` and `RemoteFunctions`. These folders are **Studio-only** and undocumented in a schema file.

**Risk:** new contributors can break remotes silently; no diff review on remote definitions.

**Recommendation:** Add `docs/remotes.md` or bootstrap remotes from a server init script. Long-term: define remotes in Rojo.

### 3. Inconsistent config path (fixed in this PR)

Scripts referenced `ConfigurationFiles` but files were under `Shared/Modules`. Rojo mapping now aligns filesystem → `ReplicatedStorage.ConfigurationFiles`.

### 4. Client globals as public APIs

Several systems expose `_G` APIs:

| Global | Script |
|---|---|
| `_G.TimedCooking` | TimedCookingScript |
| `_G.FishingMinigame` | FishingMinigameScript |
| `_G.ZundaVN` | VNController |
| `_G.ZundaCompanionShop` | CompanionShopScript |
| `_G.ZundaKeybindsPanel` | KeybindsScript |

**Risk:** implicit coupling, load-order dependencies (`while not _G.ZundaVN` in ZoneEntranceScript).

**Recommendation:** Use `BindableEvent` or a small `ClientServices` module with explicit initialization order.

---

## Medium issues

### 5. Third-party / legacy code mixed in

`CoreSystem.server.lua` header credits `@Retsatrophe` texture tooling (2022). `qPerfectionWeld.server.lua` and `qTexture.server.lua` are large utility scripts (~460+ lines each). These may be unused or overlapping with custom systems.

**Recommendation:** Audit for usage; remove or quarantine in a `Vendor/` folder with attribution.

### 6. Filename conventions

Scripts with spaces break cross-platform tooling:

- `Sprint on shift.server.lua`
- `DoubleJump - READ ME - Place in ServerScriptService.lua`

**Recommendation:** Rename to `SprintOnShift.server.lua`, move README content to docs, delete misplaced module.

### 7. No CI linting yet

Selene/StyLua are configured in VS Code but not enforced in CI.

**Recommendation:** Add `selene.toml`, `stylua.toml`, and a lint job once path aliases are stable.

### 8. DataStore keying

`DataManager` uses `"player_" .. userId` — good. But save uses full `_G.data[playerName]` blob without versioning or migration schema.

**Recommendation:** Add `dataVersion` field and migration helper for future schema changes.

---

## Security review (networking)

| Area | Status | Notes |
|---|---|---|
| Harvest validation | Good | Distance + rate limit + cooldown on server |
| Serve guest | Partial | Server validates recipe in `_G.data`; guest instance passed from client — verify instance ownership |
| Inventory/craft | Partial | Server handlers exist; audit each RemoteFunction for type/range checks |
| Tool equip / sell loot | Unknown | Client invokes with string keys — server must validate ownership |
| Data requests | Partial | `RequestData:InvokeServer()` returns full player blob — ensure no leak across players |

**Priority audit list:** `ServingSystem.server.lua`, `InventoryServer.server.lua`, `ToolManager.server.lua`, `LootModule.lua`.

---

## Performance notes

| Concern | Location | Severity |
|---|---|---|
| Large VN script | VNController.client.lua | Medium — consider splitting dialogue data from UI |
| Quest config size | QuestConfig.lua (404 lines) | Low — fine as module, watch require time |
| Weather/sky systems | DayNightSky, SkySync, WeatherSystem | Medium — verify no duplicate sky updates |
| `GetDescendants` in hot paths | Audit needed | Unknown |

Harvesting system follows event-driven patterns — good model for other systems.

---

## System-by-system snapshot

| System | Maturity | Notes |
|---|---|---|
| Harvesting | ★★★★☆ | Polished; validator + config + client UX |
| Inventory | ★★★☆☆ | Functional; `_G` coupling |
| Crafting / cooking | ★★★☆☆ | Timed minigame via `_G.TimedCooking` |
| Quests | ★★☆☆☆ | Large config; manager is thin (~79 lines) |
| Companions | ★★★☆☆ | Shop + buffs; remote-heavy |
| Fishing | ★★★☆☆ | Server + client minigame split |
| Building / plots | ★★☆☆☆ | Basic managers |
| Weather / day-night | ★★☆☆☆ | Multiple overlapping sky scripts |
| VN / dialogue | ★★★☆☆ | Rich feature; monolithic client script |
| Persistence | ★★☆☆☆ | Works; needs service abstraction |
| Economy / shop | ★★★☆☆ | RewardCore + shop configs |

---

## Recommended roadmap (post-Rojo)

### Phase 1 — Stabilize (now)
- [x] Commit to Rojo; remove rbxlx from git
- [x] Align `ConfigurationFiles` paths
- [ ] Document all remotes in `docs/remotes.md`
- [ ] Run first green CI on `main`

### Phase 2 — Harden
- [ ] Introduce `PlayerDataService` (replace `_G.data`)
- [ ] Security audit on top 5 RemoteFunctions
- [ ] Rename spaced filenames
- [ ] Add Selene + StyLua to CI

### Phase 3 — Scale
- [ ] Split VNController into data + UI modules
- [ ] Consolidate weather/sky into single system
- [ ] Add `dataVersion` migrations for DataStore
- [ ] Consider Rojo sync for remotes

---

## Review checklist status

Use `docs/review-checklist.md` per PR. For the current baseline:

- [x] No `workspace/` committed
- [x] Source under `src/` (Rojo)
- [ ] All remotes documented
- [ ] No new `_G` globals without justification
- [ ] Server validates all client-initiated gameplay actions

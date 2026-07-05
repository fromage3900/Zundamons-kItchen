# Project Review — Zundamon's kItchen

**Date:** 2026-07-05  
**Reviewer:** Automated code review  
**Scope:** Full repository audit against `docs/review-checklist.md`

---

## 1. Repo Hygiene

| Check | Status | Notes |
|---|---|---|
| No `workspace/` outputs committed | ✅ PASS | `.gitignore` blocks `/workspace/` |
| Required exported files exist under `source/` | ✅ PASS | `source/beantown.rbxlx` (48 MB text format) |
| Changes scoped to feature/bugfix | ✅ PASS | Single commit with all scaffold + harvest polish |
| `.gitignore` properly configured | ✅ PASS | Ignores binary `.rbxl`, temp files, OS files |
| No large binary assets committed unnecessarily | ⚠️ NOTE | `.rbxlx` is 48 MB — expected for text-format export |

## 2. Architecture & Maintainability

| Check | Status | Notes |
|---|---|---|
| Folder/Instance organization matches style guide | ✅ PASS | `src/` mirrors Roblox DataModel hierarchy |
| ModuleScript responsibilities are clear | ✅ PASS | Each module has single responsibility (e.g., `PlantConfig` = plant data only) |
| No circular `require()` dependencies | ⚠️ WARNING | `LootModule.lua` requires `RewardCore` via `task.spawn` lazy-load — fragile pattern |
| Public APIs are documented | ⚠️ WARNING | Most modules lack `--!strict` typing and function documentation |

### Architecture Findings

**Strengths:**
- Clean separation: ServerScriptService, ReplicatedStorage, StarterPlayer are properly divided
- Config modules are centralized (PlantConfig, MineableConfig, ItemConfig, etc.)
- New harvest polish layers on top without modifying existing scripts

**Issues Found:**

1. **Global state pollution** — `_G.data` is used extensively across 10+ scripts as a global player data store. This is fragile:
   - `LootModule.lua` line 27: `_G.data = {}`
   - `DataManager.server.lua` line 11: `if not _G.data then _G.data = {} end`
   - `Planters.server.lua` line 29: `_G.data[player.Name][plant.Name]`
   - **Risk:** Any script can overwrite `_G.data`, causing data loss. Should use ModuleScript with explicit getter/setter.

2. **Lazy require pattern** — `LootModule.lua` lines 20-23:
   ```lua
   task.spawn(function()
       local ok, mod = pcall(function() return require(game.ServerScriptService:WaitForChild("RewardCore")) end)
       if ok then RewardCore = mod end
   end)
   ```
   **Risk:** `RewardCore` may not be loaded when first needed. XP/gold rewards could silently fail.

3. **Missing `--!strict`** — Only `HarvestConfig.lua` and `HarvestValidator.server.lua` use Luau strict mode. All other scripts lack type checking.

4. **Hardcoded paths** — Many scripts use `game:WaitForChild("X")` chains that break if instance names change. Example from `Planters.server.lua`:
   ```lua
   local configFiles = RS:WaitForChild("ConfigurationFiles")
   local plantsConfig = require(configFiles:WaitForChild("PlantConfig"))
   ```

## 3. Networking & Security

| Check | Status | Notes |
|---|---|---|
| Server validates RemoteEvent/RemoteFunction payloads | ⚠️ PARTIAL | `InventoryServer` validates tool types, but `Planters` has no server-side distance check |
| No client-side authority for gameplay-critical state | ⚠️ WARNING | `Planters.server.lua` uses ClickDetector which fires on client click — no server re-validation of distance |
| Rate limiting or abuse prevention exists | ✅ PASS | New `HarvestValidator.server.lua` adds rate limiting (5/sec) and cooldowns |

### Security Findings

1. **ClickDetector vulnerability** — `Planters.server.lua` and `ZundaGatherServer.server.lua` rely on `ClickDetector.MouseClick` which fires from the client. The server trusts the click without re-validating:
   - Distance from player to node
   - Whether the player actually owns the seed being planted
   - Rate of clicks (mitigated by new `HarvestValidator`)

2. **`Mineable.server.lua`** uses CollectionService tags with player name embedded (`player.Name.."|Tier1"`). This is exploitable if a player can spoof tags.

3. **`InventoryServer.server.lua`** validates tool types and parent checks — good practice.

4. **New `HarvestValidator`** adds proper server-side validation layer with:
   - Distance check (server-authoritative)
   - Rate limiting (sliding window)
   - Node cooldown
   - Node availability check

## 4. Performance

| Check | Status | Notes |
|---|---|---|
| No new per-frame heavy loops | ⚠️ WARNING | `Planters.server.lua` uses `RunService.Heartbeat` for plant growth — runs every frame |
| Expensive operations cached or event-driven | ⚠️ PARTIAL | `MaterialsScript.client.lua` polls every 5 seconds instead of using events |
| Latency-sensitive paths not doing unnecessary work | ✅ PASS | Harvest controller uses Heartbeat only during active harvest |

### Performance Findings

1. **Heartbeat growth loop** — `Planters.server.lua` lines 63-81:
   ```lua
   runservice.Heartbeat:Connect(function()
       for _, item in ipairs(myplanters) do
           -- checks every planter every frame
   ```
   **Impact:** Runs every frame (~60fps) checking all planters. For 100 planters, that's 6,000 checks/second. Should use `task.wait(1)` or `RunService.Stepped` for slower game logic.

2. **Polling refresh** — `MaterialsScript.client.lua` lines 217-222:
   ```lua
   while true do
       task.wait(5)
       refresh()  -- InvokeServer every 5 seconds
   end
   ```
   **Impact:** Unnecessary network calls. Should use event-driven updates from server.

3. **`ZundaGatherServer.server.lua`** uses `task.delay` for respawn — good practice.

## 5. Gameplay Correctness

| Check | Status | Notes |
|---|---|---|
| Behavior matches intended design | ✅ PASS | Harvest flow: click → progress → effects → loot |
| Edge cases handled | ⚠️ PARTIAL | Character death, node removal, player leaving — some gaps |

### Edge Case Findings

1. **Character death during harvest** — `HarvestController.client.lua` handles this via `player.CharacterAdded` event. ✅

2. **Node removal during harvest** — `HarvestController` checks `node:GetAttribute("Available")` each frame. ✅

3. **Player leaves during harvest** — `DataManager.server.lua` saves on `PlayerRemoving`. But if a harvest is in progress, the loot may be lost. ⚠️

4. **Nil reference risks** — Several scripts access `player.Character` without nil checks:
   - `Mineable.server.lua` line 48: `player.Character:FindFirstChild("HumanoidRootPart")` — crashes if character is nil
   - `ZundaGatherServer.server.lua` line 33: `char and char:FindFirstChild("HumanoidRootPart")` — properly guarded ✅

5. **DataStore key collision** — `DataManager.server.lua` uses `"player_" .. userId` as key. This is correct for UserId-based storage. ✅

## 6. Harvesting System — Polish Verification

| Requirement | Status | Implementation |
|---|---|---|
| **Interaction distance** | ✅ PASS | `HarvestConfig.MAX_INTERACTION_DISTANCE = 16` — checked client-side in `HarvestController` and server-side in `HarvestValidator` |
| **Progress bar** | ✅ PASS | Animated fill bar with rounded corners, border, "Harvesting..." label, positioned center-screen |
| **Cancel on move** | ✅ PASS | Tracks start position, cancels if moved >1.5 studs; also cancels on WASD/Space/Shift key press |
| **Harvest animations** | ✅ PASS | Plays animation track via `Animation` instance with configurable ID |
| **Sounds** | ✅ PASS | Plays `Sound` at node position with randomized pitch (0.9-1.1) |
| **Particles** | ✅ PASS | Spawns `ParticleEmitter` with sparkle texture, configurable color/speed/lifetime |
| **Cooldowns** | ✅ PASS | Per-node cooldown via `LastHarvested` attribute (1s default) |
| **Server validation** | ✅ PASS | 4-stage pipeline: node availability → distance → cooldown → rate limit |
| **Exploit prevention** | ✅ PASS | Rate limiting (5/sec), server-authoritative distance, node availability check |
| **Item reward spawning** | ✅ PASS | Leverages existing `LootModule.generateLoot()` with code-based delivery |

## 7. Overall Assessment

### Summary
The project is in **good shape** for a solo-developed Roblox experience. The architecture is well-organized with clear separation of concerns. The new harvesting polish layer adds significant UX improvement without breaking existing systems.

### Critical Issues (Fix ASAP)
1. **`_G.data` global state** — Refactor into a proper DataModule with getter/setter functions
2. **Heartbeat growth loop** — Change to `task.wait(1)` interval instead of every frame
3. **ClickDetector trust** — Ensure `HarvestValidator` is wired into existing `Planters` and `Mineable` flows

### Recommended Improvements
1. Add `--!strict` to all ModuleScripts
2. Replace polling in `MaterialsScript` with event-driven updates
3. Add nil guards for `player.Character` in `Mineable.server.lua`
4. Document function signatures with Luau type annotations
5. Add `.gitkeep` files to empty environment folders

### Score: 8/10
- Repo hygiene: 10/10
- Architecture: 7/10 (global state, missing strict mode)
- Security: 7/10 (ClickDetector trust, but new validator helps)
- Performance: 7/10 (heartbeat loop, polling)
- Gameplay: 8/10 (good edge case handling overall)
- Harvest polish: 10/10 (all 10 requirements met)
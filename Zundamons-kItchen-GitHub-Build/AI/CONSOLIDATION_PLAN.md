# Master Consolidation, UI Audit & Integration Plan
**Zundamon's Kitchen — Generated from full codebase audit**

---

## Overview

This plan consolidates findings from:
- `AI/CONSOLIDATION_PLAN.md` (original 5-phase plan)
- `AI/GAMEPLAY-REVIEW.md` (cozy game system review)
- `AI/DESIGN_SYSTEM.md` (visual language guidelines)
- `AI/UI_GUIDELINES.md` (UI layout/UX standards)
- `AI/CONTENT_PIPELINE.md` (content creation workflow)
- Full codebase audit of 70+ files (ScreenGui references, legacy patterns, asset gaps)

---

## Phase 0: Immediate Cleanup — Remove Legacy UI (DAY 1)

### Rationale
3 legacy scripts (`ButtonScript`, `LootRepeater`, `ToolRepeater`) + 1 close button + 1 data module + 3 old ScreenGuis (`DataGUI`, `SellLoot`, old `inv_Frame`) form a dead code path that uses `_G.mydata` and stale snapshots. Modern replacements (`PouchScript`, `MaterialsScript`, `InventoryController`) use `RequestData:InvokeServer()` for live data.

### Removal Plan

| File | Status | Modern Replacement | Notes |
|------|--------|-------------------|-------|
| `ButtonScript.client.lua` | **REMOVE** | No replacement needed | Its only purpose was populating `_G.mydata` — deprecated pattern |
| `LootRepeater.client.lua` | **REMOVE** | `PouchScript.client.lua` + `MaterialsScript.client.lua` | Old inventory read from `_G.mydata`, new scripts use live `RequestData` |
| `ToolRepeater.client.lua` | **REMOVE** | `InventoryController.client.lua` + `ToolClient.client.lua` | Old tool manager uses `_G.mydata.tools`, new uses hotbar |
| `CloseWindow.client.lua` | **REMOVE** | Inline close buttons in each modern panel | 9-line generic; each panel has its own toggle logic |
| `DataScript.lua` (in ConfigurationFiles/) | **REMOVE** | Direct `RequestData:InvokeServer()` calls | Thin wrapper around RemoteFunction; consumers call directly |
| `DataGUI` ScreenGui (in .rbxl) | **REMOVE** from .rbxl | N/A | Contained `DataScript.lua`; no modern purpose |
| `SellLoot` ScreenGui + `Inv_Frame` (in .rbxl) | **REMOVE** from .rbxl | `PouchScript` + `MaterialsScript` | Legacy sell loot UI |
| `tool_Frame` (in .rbxl) | **REMOVE** from .rbxl | `InventoryController` | Legacy tool UI |

### After Removal, Verify
- No remaining `_G.mydata` references in active code
- `PouchScript` + `MaterialsScript` fully handle inventory display + selling
- `InventoryController` + `ToolClient` fully handle tool equipping
- `_G.data` in comments only (3 files — acceptable)

---

## Phase 1: Economy Consolidation (DAY 2-3)

### 1.1 Eliminate Dual Gold (`current_gold` vs `Gold` vs `gold`)

**Current state:**
- `PlayerDataService:createDefaultData()` creates BOTH `current_gold = 50` AND `Gold = 50`
- `RewardCore.lua` uses `d.gold` (modern standard)
- `AdvancedRewards.server.lua` uses `d.gold`
- `PouchScript.client.lua` reads `data.Gold or data.current_gold or 0` (handles both)
- `UpdateScript.client.lua` reads `data.current_gold` (old pattern)
- `QuestManager.server.lua` skips both `Gold` and `current_gold`

**Fix:**
1. Remove `current_gold` and `Gold` from `createDefaultData()`, keep only `gold = 50`
2. Update `backfillLoadedData()` to migrate `current_gold` → `gold` on load
3. Update `UpdateScript.client.lua` line 40: `data.current_gold` → `data.gold`
4. Update `PouchScript.client.lua` line 237: simplify to `data.gold or 0`
5. Update `RequestDataHandler.server.lua` to not filter out `gold`

### 1.2 Dual MarketplaceService.ProcessReceipt

**Problem:** `RobuxStoreServer.server.lua` AND `CompanionShopServer.server.lua` both try to set `MarketplaceService.ProcessReceipt`. Only 1 callback can exist.

**Fix:**
1. Create `ServerScriptService/Services/MarketplaceService.lua` (the proposed file already exists in `AI/MarketplaceService_Proposed.lua`)
2. Merge all product definitions from `RobuxStoreServer` + `CompanionShopServer`
3. Set single `ProcessReceipt` callback in the new service
4. Strip `ProcessReceipt` from both `RobuxStoreServer` and `CompanionShopServer`

### 1.3 CraftConfig ↔ CraftingScript Recipe Alignment

**Problem:** Server `CraftConfig.lua` and client `CraftingScript.client.lua` have DIFFERENT ingredient counts for the same recipes (e.g., Bread = {Wheat=10} server vs {Wheat=3?} or other in client).

**Verification needed:**
- Read `CraftingScript.client.lua` recipe loading logic
- Ensure recipes read from server config, not hardcoded client values
- If client has hardcoded recipe data — remove it, use `require(CraftConfig)` instead

### 1.4 RewardCore → Service Migration

**Current:** `RewardCore.lua` in `ConfigurationFiles/` has remote wiring, `_G.RewardCore` export, `PlayerAdded` listeners — violates "config files are side-effect free" rule.

**Fix:**
1. Create `ServerScriptService/Systems/RewardSystem.server.lua`
2. Move all remote wiring, `PlayerAdded` handlers, and background loops there
3. Strip `RewardCore.lua` to pure data + stateless helper functions
4. Update all `require("RewardCore")` → `require("RewardSystem")` across 15+ files

---

## Phase 2: UIAssets Filling & Missing Asset Audit (DAY 3-5)

### 2.1 Full Asset Audit

**UIAssets.lua — 35 placeholder slots:**

| Category | Count | Status | Source |
|----------|-------|--------|--------|
| Icons | 16 | All `rbxassetid://FILL_*` | Blender MCP → 256×256 PNG uploads |
| Sounds | 8 | All `rbxassetid://FILL_*` | Sound design / royalty-free FX |
| Particles | 3 | All `rbxassetid://FILL_*` | Material Maker → 256×256 PNG |
| GUI frames | 5 | All `rbxassetid://FILL_*` | Studio UI slicing + upload |
| Animations | 3 | All `rbxassetid://FILL_*` | Blender → FBX → Roblox Animation |

**HarvestNodeVariants.lua — 18 placeholder slots:**

| Node Type | Variants | Status |
|-----------|----------|--------|
| Zunda Flower | 3 | All FILL_* |
| Zunda Berry | 3 | All FILL_* |
| Zunda Pea | 3 | All FILL_* |
| Zunda Mushroom | 3 | All FILL_* |
| Zunda Root | 3 | All FILL_* |
| Wheat | 3 | All FILL_* |

**NPCConfig.lua — template asset IDs:**
- 3 guest templates (Child/Adult/Elder) — all FILL_*
- 1 companion template (Zundapal) — all FILL_*
- 1 animation (float_idle) — FILL_*

### 2.2 Asset Generation Pipeline

```
Step 1: Blender MCP → Generate meshes
  - 5 harvest node types × 3 variants = 15 meshes
  - 3 guest NPC characters (VRoid → FBX)
  - 1 Zundapal companion (rigged + idle animation)
  - Game logo, UI frame textures

Step 2: Roblox Studio MCP → Import
  - Upload FBX files via Studio
  - Create MeshPart objects with proper scaling
  - Set up ClickDetectors + CollectionService tags
  - Upload icon PNGs as Decals

Step 3: Wire IDs into config files
  - Update UIAssets.lua with real rbxassetid:// values
  - Update HarvestNodeVariants.lua
  - Update NPCConfig.lua
```

### 2.3 Dependency Chain for Assets

```
Blender MCP generates:
  ├── FBX meshes ──→ Roblox Studio import ──→ MeshPart objects
  ├── Animation FBX ──→ Roblox Animation upload
  ├── Icon PNGs ──→ Decal upload ──→ UIAssets.lua
  └── Particle textures ──→ Material Maker PNGs ──→ UIAssets.lua

Once real IDs are wired:
  ├── UIHelper.getItemIcon() returns real images (not emoji fallbacks)
  ├── UIHelper.createItemIcon() shows real item graphics
  ├── HarvestNodeVariants creates varied-looking nodes
  └── NPC templates have actual character meshes
```

---

## Phase 3: UI Alignment & Accessibility (DAY 5-7)

### 3.1 ScreenGui Hierarchy Audit

**Current ScreenGuis in .rbxl (from exploration):**
```
NEW (created via MCP, properly structured):
├── ZundaHUD (with ChefPill, ComboMeter, PopupRoot, HudButtons)
├── CraftingPanel (with Panel/TitleBar/CloseBtn/RecipeList)
├── MaterialsPanel (with ToggleButton, Panel, ToastContainer)
└── QuestPanel (with Panel/QuestList ScrollingFrame)

OLD (pre-existing, may overlap):
├── ZundaHUD (old — check if replaced or coexists)
├── CraftingPanel (old — may have different children)
├── MaterialsInventory (old — may overlap with new MaterialsPanel)
├── QuestPanel (old — may have different children)
├── DataGUI (legacy — for removal)
├── SellLoot + Inv_Frame (legacy — for removal)
├── ChefHUD (old HUD — may conflict with new ZundaHUD)
├── ZundaPouch (working — pouch container)
├── Compendium (working — compendium container)
├── RobuxStore (working — store container)
├── ZundaVN (working — visual novel container)
├── CompanionShop (working — companion shop container)
├── ZundaFX (working — FX overlay)
├── Minimap (working — minimap container)
├── UIPolish (working — polish manager)
├── NotificationToast (working — toast system)
├── ZoneEntranceClient (working — zone UI)
└── Others (FishingMinigame, ZundaFrame, KeybindsPanel, etc.)
```

**TODO: Verify in Studio:**
- Are old `ZundaHUD`/`CraftingPanel`/`QuestPanel` ScreenGuis still in PlayerGui after new ones are cloned?
- Do old and new ScreenGuis have the same names? (Will cause PlayerGui duplicates)
- Which old ScreenGuis should be deleted/moved to `DonotReset`?

### 3.2 Script → Parent Alignment

**Scripts that build their own UI in `script.Parent`:**
These expect `script.Parent` to be a ScreenGui (or Frame) container:
- `HudScript.client.lua` — expects ChefPill, ComboMeter, PopupRoot children
- `CraftingScript.client.lua` — expects Panel with children
- `MaterialsScript.client.lua` — expects ToggleButton, Panel, ToastContainer
- `QuestScript.client.lua` — expects Panel with QuestList
- `PouchScript.client.lua` — builds everything in parent
- `CompendiumScript.client.lua` — builds everything in parent
- `StoreScript.client.lua` — builds everything in parent

**Scripts that create their own ScreenGui dynamically:**
- `TimedCookingScript.client.lua` — creates CookingMinigame ScreenGui
- `WeatherClient.client.lua` — creates AuroraOverlay ScreenGui
- `HarvestController.client.lua` — creates HarvestProgressGui ScreenGui

**Alignment check:**
For scripts using `script.Parent`, ensure the parent is correctly the ScreenGui in StarterGui (not StarterPlayerScripts). The MCP cloning should have already placed scripts as children of ScreenGuis. Verify this in Studio.

### 3.3 Accessibility Checklist

| Check | Current State | Fix |
|-------|--------------|-----|
| Font sizing | Mixed — some scripts use fixed sizes, some scaled | Use `UIConfig.FONT_SIZES.*` across all scripts |
| Color contrast | Dark text on light bg is good; some light-on-light exists | Audit all `Color3.fromRGB()` calls for WCAG 3:1 minimum contrast |
| Emoji-only items | All items use emoji + text name (fallback) | Add `UIAssets` image icons as primary, emoji as fallback |
| Screen scaling | No `UIScale` or responsive layout checks | Add responsive padding to all panels (edge margins) |
| Keyboard navigation | Only `UIS.InputBegan` hotkeys exist | Add tab-to-navigate for all interactive panels |
| Colorblind modes | No support | Add optional high-contrast mode via UIConfig override |

---

## Phase 4: Cozy Game System Integration (DAY 7-10)

### 4.1 Fishing Minigame Polish
- `FishingMinigameScript.client.lua` exists but needs:
  - Hook into UIAssets sounds (cast, catch, fail)
  - HUD toggle button integration
  - Catch results integration with PouchScript

### 4.2 Decoration Placement System
- `DecorationConfig.lua` exists with data
- Missing: `PlacementService.server.lua` (bounds validation, collision)
- Missing: `PlacementController.client.lua` (ghost preview, grid snap)
- `HudScript` has a "Tools" tab in ProgressPanel — could include decoration placement mode

### 4.3 Quest System Expansion

**Current state:** Dual quest systems:
- `QuestConfig.lua` (in ReplicatedStorage) — data-driven quest definitions
- `QuestManager.server.lua` — hardcoded quests with unlock hints
- No integration between them

**Fix:**
1. Expand `QuestConfig.lua` with 10+ daily quests, 5 weekly quests, 10 achievements
2. Make `QuestManager.server.lua` read from `QuestConfig.lua` instead of hardcoded data
3. Add new quest types:
   - Fishing milestone (`totalFish`)
   - Companion bonding (`totalPets`)
   - Decoration collector (`decorationsPlaced`)
   - Exploration (`zonesVisited`)
   - Combo meals served (`comboMeals`)
4. Wire quest rewards to `RewardSystem` (not `RewardCore` legacy)

### 4.4 Weather & Atmosphere Enhancement

**Current:** `WeatherClient.client.lua` + `SkyConfig.lua` + `DayNightSky.server.lua`
- Basic day/night cycle works
- WeatherClient creates `AuroraOverlay` ScreenGui
- Hardcoded `rbxasset://` paths for rain/wind sounds

**Enhancements:**
1. Migrate sound paths to `UIAssets.sounds.*` with fallback
2. Add seasonal color shifts via `SkyConfig.lua`
3. Weather affects harvest yield (rain = +20% growth rate) — wire into `HarvestValidator`

### 4.5 Companion System Integration

**Current:** `CompanionManager.server.lua` + `CompanionShopScript.client.lua` + `CompanionShopServer.server.lua`
- Companions follow player with tween + sparkle effects
- Shop UI works with server-driven catalog
- Dual `ProcessReceipt` conflict (see Phase 1.2)

**Fix:**
1. Complete MarketplaceService consolidation (Phase 1.2)
2. Add companion buff effects to gameplay:
   - ZundaCat: +10% harvest speed
   - ZundaBunny: +15% gold from serving
   - TantanMon: wider perfect cooking window (already in TimedCookingScript line 321-324)
3. Add companion interaction animations (pet, feed, emote)

---

## Phase 5: Server Hardening & Code Quality (DAY 10-12)

### 5.1 Remaining Code Fixes from Original Plan

| Item | File | Status | Fix |
|------|------|--------|-----|
| Heartbeat → task.wait(1) | `Planters.server.lua` | ✅ Done | Already fixed |
| PlayerDataService keys | `PlayerDataService.lua` | ✅ Done | `Name` → `tostring(UserId)` |
| `_G.data` references | 10+ files | ✅ Done | Only comments remain |
| HarvestValidator wiring | `Mineable.server.lua` | ❌ Pending | Add validateHarvest call + nil guard |
| Nil guard character | `Mineable.server.lua:48` | ❌ Pending | `if player.Character and ...` |
| `--!strict` annotations | 5 config files | ❌ Low priority | Add to ItemConfig, CraftConfig, ShopConfig |
| Rate limiting on CraftFunction | `CraftManager.server.lua` | ❌ Needs audit | Add throttle per player per second |

### 5.2 Lazy Require Fix

**File:** `LootModule.lua` lines 20-23
**Current:** `task.spawn` lazy require of RewardCore — may fail if RewardCore hasn't loaded yet
**Fix:** Direct synchronous require. If circular dependency exists, extract shared types into a separate module.

### 5.3 Reduce Polling in MaterialsScript

**File:** `MaterialsScript.client.lua` (line ~217)
**Current:** InvokeServer every 5 seconds to refresh inventory
**Fix:** Server fires RemoteEvent on inventory change; client listens and refreshes only when data changes (event-driven pattern)

---

## Phase 6: Visual Polish & UX (DAY 12-15)

### 6.1 Frame Polish
- Implement `ZundaFrameAnim` breathing effect on ALL primary frames (panel open/close)
- Add `UIStroke` + `UIGradient` to all panels for depth
- Consistent corner radii via `UIConfig.CORNER_RADIUS.*`

### 6.2 Transition Animations
- All panel opens: `TweenService` with `Enum.EasingStyle.Back` (existing pattern, verify consistency)
- All panel closes: `Enum.EasingStyle.Quad` ease-out
- Toast notifications: slide-in + fade-out (existing pattern, verify)

### 6.3 Sound Effects
- Wire `UIAssets.sounds.*` into:
  - `ui_click` → all button clicks (currently no sound on most buttons)
  - `harvest_start` / `harvest_complete` → HarvestController
  - `craft_start` / `craft_perfect` → CraftingScript + TimedCookingScript (partially done)
  - `serve_success` → Serving system
  - `level_up` → ProgressionSystem
  - `gather_fail` → HarvestValidator (partially done in TimedCookingScript)

---

## Dependency Graph

```
Phase 0 (Legacy removal)
  ├── Must finish before Phase 3 (ScreenGui audit)
  └── Blocked by: none (pure deletion)

Phase 1 (Economy consolidation)
  ├── Prerequisite for Phase 4 (stable gold tracking)
  └── Blocked by: none

Phase 2 (Asset filling)
  ├── Prerequisite for Phase 6 (real icons replace emoji)
  └── Blocked by: Blender MCP + Roblox Studio workflow

Phase 3 (UI alignment)
  ├── Depends on: Phase 0 (removes old ScreenGuis)
  ├── Depends on: Phase 1 (stable economy for UI display)
  └── Blocked by: Studio access to verify hierarchy

Phase 4 (Cozy systems)
  ├── Depends on: Phase 1 (MarketplaceService, economy)
  ├── Depends on: Phase 2 (companion meshes, item icons)
  └── Blocked by: Asset pipeline

Phase 5 (Hardening)
  ├── Depends on: Phase 0 (removes legacy code paths)
  └── Blocked by: Testing in Studio

Phase 6 (Visual polish)
  ├── Depends on: Phase 2+3 (UIAssets + proper ScreenGui hierarchy)
  └── Blocked by: All previous phases
```

---

## Estimated Timeline

| Phase | Effort | Dependencies | Can Parallelize With |
|-------|--------|-------------|---------------------|
| P0: Legacy removal | 2-3 hours | None | — |
| P1: Economy fix | 4-6 hours | None | P0 |
| P2: Asset filling | 8-12 hours | Blender/Roblox MCP | P0, P1 |
| P3: UI alignment | 6-8 hours | P0 | P1, P2 |
| P4: Cozy systems | 10-15 hours | P1, P2 | P3 |
| P5: Hardening | 4-6 hours | P0 | P4 |
| P6: Visual polish | 6-10 hours | P2, P3 | P5 |

**Total: ~5-7 days of focused work for a complete shippable quality bump**

---

## Quick Reference: Critical Files to Edit

| File | Phase | Change |
|------|-------|--------|
| `ButtonScript.client.lua` | P0 | DELETE |
| `LootRepeater.client.lua` | P0 | DELETE |
| `ToolRepeater.client.lua` | P0 | DELETE |
| `CloseWindow.client.lua` | P0 | DELETE |
| `DataScript.lua` | P0 | DELETE |
| `PlayerDataService.lua` | P1 | Remove `current_gold` + `Gold`, keep `gold` |
| `UpdateScript.client.lua` | P1 | `data.current_gold` → `data.gold` |
| `PouchScript.client.lua` | P1 | Simplify gold read to `data.gold or 0` |
| `MarketplaceService.lua` | P1 | CREATE (single ProcessReceipt) |
| `RobuxStoreServer.server.lua` | P1 | Strip ProcessReceipt, delegate to MarketplaceService |
| `CompanionShopServer.server.lua` | P1 | Strip ProcessReceipt, delegate to MarketplaceService |
| `RewardCore.lua` | P1 | Strip remote wiring → pure data module |
| `RewardSystem.server.lua` | P1 | CREATE (moved logic from RewardCore) |
| `UIAssets.lua` | P2 | Fill 35 asset IDs from pipeline |
| `HarvestNodeVariants.lua` | P2 | Fill 18 variant IDs |
| `NPCConfig.lua` | P2 | Fill 4 template IDs + 1 animation ID |
| `Mineable.server.lua` | P5 | Wire HarvestValidator + nil guard |
| `MaterialsScript.client.lua` | P5 | Polling → event-driven refresh |
| `CraftingScript.client.lua` | P3 | Verify reads from CraftConfig, not hardcoded data |
| `ZundaHUD` + `CraftingPanel` + others (in .rbxl) | P3 | Verify old vs new screen gui duplication |

---

## Key Metrics for Success

1. **No `_G.mydata`** — zero active references across all scripts
2. **Single `gold`** — no `current_gold` or `Gold` references in data layer
3. **ProcessReceipt** — exactly 1 callback, in MarketplaceService
4. **UIAssets filled** — 0 `FILL_*` placeholders in all config files
5. **ScreenGui audit** — no duplicate ScreenGuis; each script has exactly 1 parent
6. **Event-driven inventory** — MaterialsScript no longer polls every 5 seconds
7. **HarvestValidator wired** — Mineable.server.lua validates distance + cooldown
8. **CraftConfig authoritative** — server config is single source of truth (no client hardcodes)

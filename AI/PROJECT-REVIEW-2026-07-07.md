# Project Review — Zundamon's kItchen (July 7, 2026)

**Commit:** `4a39420` · **Branch:** `main` · **Remote:** `origin` (clean, pushed)
**Validation:** `npm run validate` passes (124 Lua files)
**Structure:** Flat (src/ at root), no legacy junk

---

## 1. Repo Health

- ✅ Clean working tree, nothing uncommitted
- ✅ Pushed to origin, up to date with `main`
- ✅ `npm run validate` passes
- ✅ Flat structure confirmed
- ✅ `opencode.json` points to `G:\`

---

## 2. Asset Inventory

### 2.1 UPLOADED & WIRED (83 assets total)

| Category | Count | Status |
|----------|-------|--------|
| Harvest node meshes (wheat, flower, pea, mushroom, berry, root, rock, gold) | 18 | ✅ MeshAssets.lua |
| Environment prop meshes (tree, house, fence, counter, pot) | 6 | ✅ MeshAssets.lua |
| Companion meshes (zundamon, zundacat, zundabunny, tantanmon, ankomon, cardamon, antimon, sakuradamon) | 8 | ✅ CompanionManager |
| NPC guest models (child, adult, elder) | 3 | ✅ NPCConfig |
| Architecture meshes (market hall x2, bakery stall, streetlamp, bench, counter island, balcony) | 7 | ✅ ArchitectureVariants |
| Zundamon FBX (full character) | 1 | ✅ CompanionManager (121481310719137) |
| UI icon decals (16 items) | 16 | ✅ UIAssets.icons |
| GUI texture decals (5) | 5 | ✅ UIAssets.gui |
| Sound IDs (free Roblox audio) | 8 | ✅ UIAssets.sounds |
| Particle texture | 1 | ✅ UIAssets.particles (241685484) |
| Seasonal particle textures (butterfly, snow, petal, leaf, 4 seasonal effects) | 8 | ✅ ScatterConfig |
| NPC animations (idle, walk, eat) | 3 | ✅ NPCConfig (default Roblox IDs) |
| **TOTAL** | **84** | |

### 2.2 STILL BROKEN/MISSING

| Item | Location | Count | Severity |
|------|----------|-------|----------|
| Animation IDs (all `rbxassetid://0`) | UIAssets.animations (3), HarvestConfig (1) | 4 | 🔴 Blocks harvest animation |
| Skybox textures (6 faces + sun + moon = 8 empty strings) | SkyConfig.sky | 8 | 🔴 Black sky in game |
| Decoration model mesh IDs (modelName only) | DecorationConfig | 11 | 🟡 Decoration shop broken |
| WeatherClient sounds (`rbxasset://sounds/`) | WeatherClient.client.lua lines 47-52, 161 | 6 | 🟡 No weather audio |
| TimedCookingScript fallback sounds | TimedCookingScript.client.lua lines 388-394, 481 | 5 | 🟡 No craft fallback audio |
| Tools.server sound (`rbxasset://sounds/impact_water.mp3`) | Tools.server.lua line 24 | 1 | 🟡 No tool audio |
| HarvestNodeVariants particle textures (`rbxasset://textures/particles/`) | HarvestNodeVariants.lua lines 15-91 | 8 | 🟢 Visual only, not critical |
| **TOTAL MISSING** | | **43** | |

### 2.3 `rbxasset://` paths — what's OK vs not

**OK (built-in Roblox assets):**
- `rbxasset://textures/particles/*` — built-in particle textures, work everywhere
- `rbxasset://fonts/families/*.json` — built-in fonts, work everywhere
- `rbxasset://textures/Cursors/*` — built-in cursor textures
- `rbxassetid://241685484` — already wired (sparkle texture)

**NOT OK (custom files that won't resolve):**
- `rbxasset://sounds/rain.mp3`, `wind.mp3`, `Halt.wav` in `WeatherClient`
- `rbxasset://sounds/button-09.mp3`, `electronicpingshort.wav` in `TimedCookingScript`
- `rbxasset://sounds/impact_water.mp3` in `Tools.server`
- `rbxasset://textures/particles/sparkle_main.dds` in `HarvestNodeVariants` (8 refs)

---

## 3. Visual Novel System

### State: Works for Zundapal only

**What works:**
- Full UI construction with tweens, typewriter, branching dialogue
- Welcome sequence on join
- Quest completion handler
- Zone lore handler (ZoneLoreConfig exists with 6 zones)
- Zundapal companion tree with time-of-day greetings

**Bugs blocking:**
- 🔴 **4 other companions ignored** — `OpenCompanionVN` handler ignores `compType`/`emoji`, always shows Zundapal tree
- 🟡 **Level-based dialogue dead** — `level1_10`/`level11_20`/`level21_50` data defined but never read
- 🟡 **Side dialogues orphaned** — `_G.ZundaSideDialogues` exposed but never triggered
- 🟡 **Duplicate return key** in VNDialogueData (line 126-127, `COMPANION_DIALOGUE` written twice)
- 🟡 **Players.LocalPlayer** in ModuleScript — fragile, baked at require-time
- 🟢 **Zone lore works** — 6 zones defined, BindableEvent listener connected

---

## 4. Procedural Generation Systems

### 4.1 ScatterService (Harvest node scattering)

**What works:**
- Full PCG pipeline: Sampler → Exclusion → Density → Self-Prune → Variant → Spawn
- 5 biomes defined (zunda_forest, mineable_foothills, kitchen_garden, summer_clearing, winter_grove)
- 11 node types across biomes, weighted variants
- Uses MeshAssets.lua for real mesh IDs
- All 18 harvest node mesh IDs wired

**What's missing:**
- 🔴 **No trigger** — `scatterBiome()` is never called. No Region detection or player-entered-zone listener connects to it
- 🟡 **No harvest handler** — ClickDetectors attached but no `MouseClick` listener
- 🟡 **Animation flags dead** — `spinSpeed`, `swayAnimation`, `bobAnimation`, `glowWhenNear` defined in config but never implemented in ScatterService
- 🟡 **Seed not applied** — biome seeds defined but `math.randomseed()` never called
- 🟢 `GameplayLoopArea.GatheringNodes` container expected but not created by script

### 4.2 Architecture System

**What works:**
- ArchitectureVariants fully populated (7 mesh IDs)
- ArchitecturePipeline defines 6 entries across 4 categories
- ArchitectureLoader provides lookup functions

**What's missing:**
- 🔴 **No runtime placement** — No builder/orchestrator instantiates architecture into workspace
- 🟢 Data layer complete

### 4.3 Sky/Weather System

**What works:**
- SkyConfig has full day/night cycle (14 keyframes, 0-24h)
- 5 constellation patterns defined (Bunny, Cherry Blossom, Onigiri, Cat, Big Star)
- 9 weather types (clear, cloudy, cherry_blossom, rain, snow, aurora, storm, fog)
- Config exports `isNightHour()`, `greetingSlot()`, `welcomeGreeting()` helpers
- VNController already uses `greetingSlot()` for companion dialogue time-of-day

**What's missing:**
- 🔴 **8 skybox textures** (6 faces + sun + moon) all empty strings
- 🟡 **Weather sounds** use `rbxasset://sounds/` that won't resolve

---

## 5. Procedural Harvesting Area Scaffolding — Design

For your utility to procedurally create spanning harvesting areas that you can set-dress:

### Current Approach (ScatterService)
The existing `ScatterService.scatterBiome(biomeName, region)` is the right primitive:
- Takes an `Instance` region (Part/Model) defining bounds
- Samples terrain within the volume
- Places weighted-variant mesh nodes
- Excludes paths/buildings/water/plot-tagged areas
- Tags all placed nodes with `"GatheringNode"` CollectionService tag

### What's Missing for Your Scaffolding
```
Your utility needs:
┌─────────────────────────────────────────────┐
│ 1. Region Manifest Layer                     │
│    ┌─────────────────────────────────────┐   │
│    │ Region definitions:                 │   │
│    │ { id, bounds, biome, density,       │   │
│    │   decoration_tags, manual_spots }   │   │
│    └─────────────────────────────────────┘   │
│                                              │
│ 2. Placement Rules Layer                     │
│    ┌─────────────────────────────────────┐   │
│    │ Per-region overrides:               │   │
│    │ - Node types allowed                │   │
│    │ - Manual-set pieces (paths,         │   │
│    │   buildings, decor)                 │   │
│    │ - Exclusion zones (your             │   │
│    │   set-dressed areas)                │   │
│    └─────────────────────────────────────┘   │
│                                              │
│ 3. Integration with Existing Systems         │
│    ┌─────────────────────────────────────┐   │
│    │ ScatterService.scatterBiome()       │   │
│    │ ArchitectureLoader.getVariantMesh() │   │
│    │ DecorationConfig (11 items)         │   │
│    └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

### Proposed Scaffold File Structure
```lua
src/ServerScriptService/Services/
  HarvestZoneService.server.lua   -- NEW: orchestrates regions
  ScatterService.server.lua       -- EXISTING: per-biome scatter

src/ReplicatedStorage/ConfigurationFiles/
  HarvestZoneConfig.lua           -- NEW: region manifest
  ScatterConfig.lua               -- EXISTING: biome definitions
  DecorationConfig.lua            -- EXISTING: decoration catalog

src/ServerScriptService/
  HarvestZoneBuilder.server.lua   -- NEW: places manual pieces
  GuestManager.server.lua         -- EXISTING: serves guests
```

### Key Design Points
1. **Regions are Parts/Models** in workspace tagged with `"HarvestZone"` — ScatterService already uses CollectionService
2. **Your set-dressed pieces** go in as children of the region, tagged `"ManualPlacement"` so scatter excludes them
3. **Scatter fills the rest** — calls `scatterBiome()` with region bounds minus exclusion zones
4. **DecorationConfig items** can be placed via a new `placeDecoration(decorationId, position)` API
5. **Persistence** is optional — regions regenerate on server start

---

## 6. Final Launch Checklist

### 🔴 REQUIRED to publish (game works without these but looks/feels broken)

| # | Task | Effort | Current State |
|---|------|--------|---------------|
| 1 | **4 animation IDs** — create harvest_loop, cook_victory, cook_fail animations in Studio | 2-3h | `rbxassetid://0` |
| 2 | **8 skybox textures** — source/create skybox cube map + sun/moon | 1-2h | Empty strings |
| 3 | **Wire scatter trigger** — connect `scatterBiome()` to region detection | 1h | Never called |
| 4 | **Wire harvest handler** — connect ClickDetector.MouseClick → inventory | 2h | No listener |
| 5 | **Replace broken `rbxasset://sounds/`** — upload weather + tool sounds as library audio | 1h | 12 broken paths |
| 6 | **Fix VN companion handler** — route `compType` to correct companion tree | 30min | All show Zundapal |
| 7 | **Fix HarvestNodeVariants sparkle paths** → `rbxassetid://241685484` | 5min | 8 rbxasset paths |

### 🟡 SHOULD fix before public launch

| # | Task | Effort | Notes |
|---|------|--------|-------|
| 8 | **11 decoration mesh uploads** — find/source + upload FBX files | 2-3h | DecorationConfig.modelName → mesh ID |
| 9 | **Skybox cube map images** — 6 skybox faces + optional sun/moon | 1h | Generate simple gradient textures |
| 10 | **4 remaining companion dialogue trees** — build in VNController | 1h | Data exists, trees missing |
| 11 | **Fix duplicate return key** in VNDialogueData | 2min | Line 126-127 |
| 12 | **Replace `Players.LocalPlayer`** with dynamic player name | 10min | Baked at require-time |
| 13 | **Fix ZoneLoreConfig loading** — ensure zone triggers exist in world | 30min | Config exists, triggers? |
| 14 | **HarvestNodeVariants sparkle** → rbxassetid://241685484 | 5min | 8 replacements |

### 🟢 NICE TO HAVE (polish, not blockers)

| # | Task | Effort | Notes |
|---|------|--------|-------|
| 15 | Level-based VN dialogue integration | 30min | Data exists, unused |
| 16 | ScatterService animation flags (sway, bob, spin) | 2h | Config defined, not coded |
| 17 | Passive collecting companions (AI follow changes) | varies | Pets follow but don't interact |
| 18 | Architecture builder (runtime placement) | 3h | Data complete, no spawner |
| 19 | Winter grove biome triggers | 1h | Config done, no season system tie-in |
| 20 | Decoration persistence (save/load placed items) | 2h | DataStore integration needed |

---

## 7. Summary

**Total assets uploaded & wired:** 84
**Total missing/broken:** 43 (4 animations + 8 skybox textures + 11 decoration meshes + 12 broken sound paths + 5 VN bugs + 2 scatter wiring gaps + 1 sparkle path)

**Biggest blockers for publish:**
1. 4 animation IDs → `rbxassetid://0` (harvest animation won't play)
2. 8 skybox textures → empty strings (sky is black)
3. ScatterService never triggers (no nodes appear)
4. VN only works for Zundapal (other 4 companions show wrong dialogue)
5. 12 broken `rbxasset://sounds/` paths (no weather/tool sounds)

**What's production-ready:**
- All 24 harvest node + environment meshes ✅
- All 8 companion + 3 NPC character meshes ✅
- All 16 UI icons + 5 GUI textures ✅
- All 8 sound effects ✅
- All 7 architecture variant meshes ✅
- All 8 seasonal particle textures ✅
- Sky day/night cycle config ✅ (9 weather types, 14 keyframes)
- VN dialogue system ✅ (UI complete, typewriter, branching, quest, zone lore)
- Scatter PCG pipeline ✅ (just needs a trigger)
- Architecture data layer ✅ (just needs a builder)
- Zone lore config ✅ (6 zones)

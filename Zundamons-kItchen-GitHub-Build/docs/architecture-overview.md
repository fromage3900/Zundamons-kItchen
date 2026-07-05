# Architecture Overview — Zundamon's kItchen

## Game Systems

### Harvesting System
The harvesting system consists of multiple layers that work together:

| Layer | Script | Location | Purpose |
|---|---|---|---|
| **Config** | `HarvestConfig.lua` | ReplicatedStorage.ConfigurationFiles | Central tuning: distances, timings, cooldowns, visuals |
| **Client Controller** | `HarvestController.client.lua` | StarterPlayer.Controllers | Progress bar, animations, sounds, particles, cancel-on-move |
| **Server Gather** | `ZundaGatherServer.server.lua` | ServerScriptService | Click-to-gather for forest plants, mystery loot, respawn logic |
| **Server Planters** | `Planters.server.lua` | ServerScriptService | Planter box planting, seed consumption, growth stages |
| **Server Mineable** | `Mineable.server.lua` | ServerScriptService | Mining/harvesting with health-based depletion, loot tiers |
| **Server Validation** | `HarvestValidator.server.lua` | ServerScriptService.Validation | Distance checks, rate limiting, cooldowns, exploit prevention |
| **Loot Module** | `LootModule.lua` | ReplicatedStorage.ConfigurationFiles | Item granting, code-based loot delivery, sell handling |
| **Config: Plants** | `PlantConfig.lua` | ReplicatedStorage.ConfigurationFiles | Plant growth times, sprout mappings |
| **Config: Mineables** | `MineableConfig.lua` | ReplicatedStorage.ConfigurationFiles | Mineable health, respawn, loot tables |
| **Config: Items** | `ItemConfig.lua` | ReplicatedStorage.ConfigurationFiles | Item definitions and properties |

### Harvest Flow
```
1. Player clicks harvestable node (ClickDetector)
2. HarvestController.client.lua intercepts click
   - Shows progress bar (2.5s hold)
   - Plays harvest animation
   - Plays sound effect
   - Spawns particles
3. During hold, controller checks:
   - Distance to node (cancel if out of range)
   - Player movement (cancel if moved >1.5 studs)
   - Movement keys pressed (cancel)
   - Node availability
4. On completion:
   - Fires ClickDetector:MouseClick(player)
   - Server-side handler (ZundaGatherServer/Planters/Mineable) processes loot
5. Server validation (HarvestValidator):
   - Distance check (server-authoritative)
   - Rate limiting (max 5 harvests/sec)
   - Node cooldown (1s per node)
   - Node availability check
6. LootModule grants items via code-based delivery
7. Client receives notification + inventory update
```

### Other Systems
- **Inventory** — `InventoryServer.server.lua` + `InventoryController.client.lua` + `MaterialsScript.client.lua`
- **Crafting** — `CraftManager.server.lua` + `CraftingScript.client.lua`
- **Quests** — `QuestManager.server.lua` + `QuestConfig.lua`
- **Companions** — `CompanionManager.server.lua` + `CompanionBuffServer.server.lua`
- **Fishing** — `FishingServer.server.lua` + `FishingMinigameScript.client.lua`
- **Building** — `BuildingManager.server.lua` + `PlotManager.server.lua`
- **Weather** — `WeatherSystem.server.lua` + `WeatherClient.client.lua`
- **Day/Night** — `DayNightSky.server.lua` + `SkySync.server.lua`
- **Serving** — `ServingSystem.server.lua` + `GuestDetector.client.lua`
- **Data Persistence** — `DataManager.server.lua` (DataStore-backed)
- **Economy** — `RewardCore.lua` + `ShopConfig.lua` + `StoreScript.client.lua`

## Data Flow
```
Client Input → HarvestController (client) → ClickDetector → Server Handler
  → HarvestValidator (server) → LootModule → DataManager → DataStore
  → RemoteEvent notification → Client UI update
```

## How to Extend
1. Add new harvestable types in `MineableConfig.lua` or `PlantConfig.lua`
2. Add new items in `ItemConfig.lua`
3. Tune interaction in `HarvestConfig.lua`
4. Add new nodes in Studio with CollectionService tags: `Mineable`, `Planter`, or `ResourceType` attribute
5. For new visual effects, extend `HarvestController.client.lua`

## Related docs

- [`remotes.md`](remotes.md) — RemoteEvent/RemoteFunction catalog
- [`project-review.md`](project-review.md) — Scorecard and review summary
- [`security-audit.md`](security-audit.md) — Applied security fixes

## Rojo sync map

Scripts and config modules under `src/` map to Studio via `default.project.json`:

| Filesystem | Studio |
|---|---|
| `src/ReplicatedStorage/ConfigurationFiles/` | `ReplicatedStorage.ConfigurationFiles` |
| `src/ServerScriptService/` | `ServerScriptService` |
| `src/StarterPlayer/StarterPlayerScripts/` | `StarterPlayer.StarterPlayerScripts` |

**Not synced** (must exist in the published place): `RemoteEvents`, `RemoteFunctions`, Workspace map, UI, audio, animations.
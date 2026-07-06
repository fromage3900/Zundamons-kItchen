# Remote API Reference

Networking instances are defined in **`default.project.json`** (Rojo sync) and ensured at runtime by **`00_RemoteBootstrap.server.lua`** if missing from a legacy place. Canonical name list: `RemoteManifest.lua`.

See also: [`rojo-workflow.md`](rojo-workflow.md)

---

## ReplicatedStorage.RemoteEvents

| Name | Direction | Payload | Handler | Validation |
|------|-----------|---------|---------|------------|
| `NotifyPlayer` | S→C | `(kind, message)` | Multiple servers fire | N/A — kinds include `zundapal` for proactive LLM hints |
| `UpdateQuests` | S→C | `(quests, progress)` | `QuestManager.server.lua` | N/A |
| `QuestCompleted` | S→C | quest table | `QuestManager.server.lua` | N/A |
| `PurchaseCompanion` | C→S | `(compType: string)` | `CompanionShopServer.server.lua` | Catalog + ownership check |
| `CompanionOwnedSync` | S→C | `(compType, owned)` | `CompanionShopServer.server.lua` | N/A |
| `SetCompanion` | C→S | `(compType)` | `CompanionManager.server.lua` | Ownership / free list |
| `WeatherChanged` | S→C | `(weather, ...)` | `WeatherSystem.server.lua` | N/A |
| `MakeLootEvent` | S→C | `(obj, position, code)` | `LootModule.lua` | N/A |
| `RemoveCode` | C→S | `(code, name, isRemoving)` | `LootModule.lua` | Server code table |
| `ShowPlantingMenu` | S→C | `(plantables, planter)` | `Planters.server.lua` | N/A |
| `plantEvent` | C→S | `(plantName, planter)` | `Planters.server.lua` | Data + planter state |
| `CookingResult` | S→C | result table | `CraftManager.server.lua` | N/A |
| `OpenCompanionVN` | S→C | `(compType, emoji)` | `CompanionManager.server.lua` | N/A |
| `ZundapalChatSend` | C→S | `(message: string)` | `ZundapalChatServer.server.lua` | Type, length, cooldown, TextService filter |
| `ZundapalChatReply` | S→C | `{ text, speaker?, fallback? }` | `ZundapalChatServer.server.lua` | N/A |
| `ZundapalChatError` | S→C | `(message: string)` | `ZundapalChatServer.server.lua` | N/A |
| `ZundapalChatStatus` | S→C | `"thinking" \| "ready"` | `ZundapalChatServer.server.lua` | N/A |
| `RecordNpcChat` | C→S | `(speakerKey: "elder" \| "ruins" \| "chef")` | `CompanionInteractionServer.server.lua` | Whitelist via `CompanionConfig.npcSpeakers`, 5s cooldown |
| `ZoneVisited` | C→S | `(zoneName: string)` | `ZoneVisitServer.server.lua` | Mapped via `ZoneVisitConfig` |

---

## ReplicatedStorage.RemoteFunctions

| Name | Direction | Payload | Returns | Handler | Validation |
|------|-----------|---------|---------|---------|------------|
| `RequestData` | C→S | — | filtered materials table | `RequestDataHandler.server.lua` | Single handler; hidden keys stripped |
| `ServeGuest` | C→S | `(guestInstance, foodName)` | `(ok, msg)` | `ServingSystem.server.lua` | Guest folder, distance, inventory |
| `EquipTool` | C→S | `(toolName)` | `boolean` | `ToolManager.server.lua` | `ToolsConfig` whitelist |
| `CraftFunction` | C→S | `(recipe, position, quality)` | `"Success"` / `"Fail"` | `CraftManager.server.lua` | Ingredient check server-side |
| `GiveLoot` | C→S | `(lootName, genCode)` | `boolean` | `LootModule.lua` | Server-stored code |
| `sellLoot` | C→S | `(itemKey)` | gold or `false` | `LootModule.lua` | `priceLists` whitelist + rate limit |
| `ClaimPlot` | C→S | `(plotNum)` | `{success, message}` | `PlotManager.server.lua` | Guest count + availability |
| `BuyDecoration` | C→S | `(decorationId)` | `{success, message, ...}` | `DecorationPlacer.server.lua` | Gold + catalog whitelist |
| `PlaceDecoration` | C→S | `(decorationId, slotIndex?)` | `{success, message, slot?}` | `DecorationPlacer.server.lua` | Plot ownership + slot |
| `GetDecorationState` | C→S | — | owned/placements/catalog/**gold** | `DecorationPlacer.server.lua` | — |
| `GetCompanionCatalog` | C→S | — | catalog | `CompanionShopServer.server.lua` | — |
| `GetOwnedCompanions` | C→S | — | owned table | `CompanionShopServer.server.lua` | — |
| `GetActiveCompanionBuff` | C→S | `(stat)` | `number` | `CompanionBuffServer.server.lua` | — |
| `PromptRobuxPurchase` | C→S | `(productId)` | `true` | `RobuxStoreServer.server.lua` | — |
| `FishingCast` | C→S | `(action, payload?)` | varies | `FishingServer.server.lua` | Rod equipped server-side |

---

## ReplicatedStorage.RewardEvents

| Name | Type | Handler | Notes |
|------|------|---------|-------|
| `PopupEvent` | Event S→C | `RewardCore.lua` | HUD popups |
| `ChefLevelUpdate` | Event S→C | `RewardCore.lua` | Level bar |
| `ComboUpdate` | Event S→C | `RewardCore.lua` | Combo meter |
| `LevelUpEvent` | Event S→C | `RewardCore.lua` | Level-up fanfare |
| `RequestRewardSync` | Function C→S | `RewardCore.lua` | Returns chef/combo/profile snapshot |
| `NotifyAction` | Event S→C | `AdvancedRewards.server.lua` | Internal reward hooks |
| `DailyUpdate` | Event S→C | `AdvancedRewards.server.lua` | Daily quest UI |
| `LoginBonusEvent` | Event S→C | `AdvancedRewards.server.lua` | Login streak |
| `AchievementUnlocked` | Event S→C | `AdvancedRewards.server.lua` | Achievement toast |
| `PowerupUpdate` | Event S→C | `AdvancedRewards.server.lua` | Powerup timer |
| `UsePowerup` | Function C→S | `AdvancedRewards.server.lua` | Consumes powerup |
| `UpgradeTool` | Function C→S | `AdvancedRewards.server.lua` | Tool tier upgrade |
| `GetCompendium` | Function C→S | `AdvancedRewards.server.lua` | Compendium data |

---

## ReplicatedStorage.ToolRemotes

| Name | Type | Handler |
|------|------|---------|
| `ConnectFunction` | Function C→S | `Tools.server.lua` |
| `FishingCast` | Function C→S | `FishingServer.server.lua` |

---

## ReplicatedStorage.InventoryReplicatedStorage.RemoteEvents

| Name | Type | Payload | Handler | Validation |
|------|------|---------|---------|------------|
| `Equip` | Event C→S | `(tool)` | `InventoryServer.server.lua` | Player owns tool |
| `Drop` | Event C→S | `(tool)` | `InventoryServer.server.lua` | Ownership + backpack |
| `ToHotbar` | Event C→S | `(tool)` | `InventoryServer.server.lua` | Ownership |
| `ToInventory` | Event C→S | `(tool)` | `InventoryServer.server.lua` | Ownership |

---

## Adding a new remote

1. Create instance in Studio under the correct folder
2. Add a row to this document
3. Implement server handler with type checks and server authority
4. Note in PR under "Studio-only dependencies"

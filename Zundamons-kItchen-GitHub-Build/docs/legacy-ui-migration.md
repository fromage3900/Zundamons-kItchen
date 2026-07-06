# Legacy UI Migration

Studio `StarterGui` copies and Rojo-synced scripts can both create UI. This doc tracks what to delete in Studio vs what Rojo owns at runtime.

## Runtime cleanup (automatic)

[`000_LegacyOverlayCleanup.client.lua`](../src/StarterPlayer/StarterPlayerScripts/000_LegacyOverlayCleanup.client.lua) runs on join and:

- Destroys ScreenGuis: `ZundaFX`, `PostProcessOverlay`
- Removes descendants named `WatercolourBleed`, `Vignette`, `GrainLayer`, `NoiseImage`
- Destroys legacy `PlayerGui.ZundaVN` (replaced by `ZundaVNGui` from code)

Config: [`LegacyGuiConfig.lua`](../src/ReplicatedStorage/ConfigurationFiles/LegacyGuiConfig.lua)

**Keep:** [`AtmospherePostFX.client.lua`](../src/StarterPlayer/StarterPlayerScripts/AtmospherePostFX.client.lua) — real Lighting bloom/color grade (not ScreenGui vignettes).

## Studio manual deletion (recommended once)

In place `108617605497926`, delete from **StarterGui**:

| Instance | Why |
|----------|-----|
| `ZundaFX` | Watercolour vignette / grain overlay (replaced by cleanup + AtmospherePostFX) |
| `FXController` (if under ZundaFX) | Orphaned animator; removed from git |
| `ZundaVN` | VN panel now built as `ZundaVNGui` in `VNController.client.lua` |

**Keep for now** (HUD not fully Rojo-bootstrapped):

- `ZundaHUD`, `ZundaPouch`, `QuestPanel`, `CraftingPanel`, `DataGUI`, `SellLoot`

## Rojo-bootstrapped UI (canonical)

| ScreenGui | Script |
|-----------|--------|
| `ZundaVNGui` | `VNController.client.lua` |
| `DecorationShopGui` | `DecorationShop.client.lua` |
| `PlantingMenuGui` | `PlantingMenu.client.lua` |
| `HarvestProgressGui` | `HarvestController.client.lua` |
| `CookingMinigame` | `TimedCookingScript.client.lua` |

## Still `script.Parent` = Studio GUI (migrate later)

These expect a parent ScreenGui in Studio when not using Rojo-only bootstrap:

- `CompanionShopScript`, `PouchScript`, `QuestScript`, `CraftingScript`, `MaterialsScript`, `StoreScript`, `ButtonScript`, `InventoryController`, etc.

Under flat Rojo sync they parent to `StarterPlayerScripts` — **duplicate risk** if matching StarterGui copies exist.

## Playtest verification

1. Output: `[LegacyOverlayCleanup] Done — N legacy overlay item(s) removed`
2. No dark corner vignette boxes during play
3. `PlayerGui` has `ZundaVNGui`, not `ZundaFX`
4. Decoration shop (H) and VN dialogue render without overlay on top

# Legacy UI Migration

Studio `StarterGui` copies and Rojo-synced scripts can both create UI. This doc tracks what to delete in Studio vs what Rojo owns at runtime.

## Runtime cleanup (automatic)

[`000_LegacyOverlayCleanup.client.lua`](../src/StarterPlayer/StarterPlayerScripts/000_LegacyOverlayCleanup.client.lua) runs on join and:

- Destroys ScreenGuis: `ZundaFX`, `PostProcessOverlay`
- Removes descendants named `WatercolourBleed`, `Vignette`, `GrainLayer`, `NoiseImage`
- Destroys legacy `PlayerGui.ZundaVN` (replaced by `ZundaVNGui` from code)
- Destroys Studio duplicate shells: `CompanionShop`, `ZundaShop` (before bootstrap scripts run)

Config: [`LegacyGuiConfig.lua`](../src/ReplicatedStorage/ConfigurationFiles/LegacyGuiConfig.lua)

**Keep:** [`AtmospherePostFX.client.lua`](../src/StarterPlayer/StarterPlayerScripts/AtmospherePostFX.client.lua) — real Lighting bloom/color grade (not ScreenGui vignettes).

## Studio manual deletion (recommended once)

In place `108617605497926`, delete from **StarterGui**:

| Instance | Why |
|----------|-----|
| `ZundaFX` | Watercolour vignette / grain overlay (replaced by cleanup + AtmospherePostFX) |
| `FXController` (if under ZundaFX) | Orphaned animator; removed from git |
| `ZundaVN` | VN panel now built as `ZundaVNGui` in `VNController.client.lua` |
| `ZundaPouch`, `QuestPanel`, `CompanionShop` | Rojo bootstrap recreates these in `PlayerGui` |

**Keep for now** (HUD not fully Rojo-bootstrapped):

- `ZundaHUD`, `CraftingPanel`, `DataGUI`, `SellLoot`

## Rojo-bootstrapped UI (canonical)

| ScreenGui | Script |
|-----------|--------|
| `ZundaVNGui` | `VNController.client.lua` |
| `DecorationShopGui` | `DecorationShop.client.lua` |
| `PlantingMenuGui` | `PlantingMenu.client.lua` |
| `CompanionShopGui` | `CompanionShopScript.client.lua` |
| `ZundaPouch` | `PouchScript.client.lua` |
| `QuestPanel` | `QuestScript.client.lua` |
| `ZundaShopGui` | `StoreScript.client.lua` |
| `HarvestProgressGui` | `HarvestController.client.lua` |
| `CookingMinigame` | `TimedCookingScript.client.lua` |
| `LlmDisclaimerGui` | `DisclaimerGate.client.lua` |

Bootstrap helper: [`ClientGuiBootstrap.lua`](../src/ReplicatedStorage/ConfigurationFiles/ClientGuiBootstrap.lua)

## Still `script.Parent` = Studio GUI (migrate later)

- `CraftingScript`, `MaterialsScript`, `ButtonScript`, `InventoryController`, `KeybindsScript`, `HudScript`, etc.

## Playtest verification

See [`studio-playtest-smoke.md`](studio-playtest-smoke.md).

1. Output: `[LegacyOverlayCleanup] Done — N legacy overlay item(s) removed`
2. No dark corner vignette boxes during play
3. `PlayerGui` has `ZundaVNGui`, not `ZundaFX`
4. Decoration shop (H) and VN dialogue render without overlay on top

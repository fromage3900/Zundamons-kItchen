# 🎨 Asset Watchlist - Placeholder Detection

## Icons Needed (UIAssets.lua)
| Item               | Placeholder                | Suggested Source          |
| ------------------ | -------------------------- | ------------------------- |
| Wheat              | `FILL_ICON_WHEAT`          | Roblox library wheat icon |
| Zunda Flower       | `FILL_ICON_ZUNDA_FLOWER`   | Pink sparkle emoji 🌸      |
| Zunda Pea          | `FILL_ICON_ZUNDA_PEA`      | Green pea emoji 🫛         |
| Zunda Berry        | `FILL_ICON_ZUNDA_BERRY`    | Red berry emoji 🍓         |
| Zunda Mushroom     | `FILL_ICON_ZUNDA_MUSHROOM` | Brown mushroom 🍄          |
| Zunda Root         | `FILL_ICON_ZUNDA_ROOT`     | Nut emoji 🌰               |
| Apple              | `FILL_ICON_APPLE`          | Apple emoji 🍎             |
| Bread              | `FILL_ICON_BREAD`          | Bread emoji 🍞             |
| Cupcake            | `FILL_ICON_CUPCAKE`        | Cupcake emoji 🧁           |
| Apple Pie          | `FILL_ICON_APPLE_PIE`      | Pie emoji 🥧               |
| Zunda Bread        | `FILL_ICON_ZUNDA_BREAD`    | Custom green bread        |
| Zunda Mochi        | `FILL_ICON_ZUNDA_MOCHI`    | Mochi emoji 🍡             |
| Royal Stew         | `FILL_ICON_ROYAL_STEW`     | Stew emoji 🍲              |
| Salted Pea Bouquet | `FILL_ICON_BOUQUET`        | Bouquet emoji 💐           |
| Gold Ore           | `FILL_ICON_GOLD_ORE`       | Gold coin emoji 🪙         |
| Rock               | `FILL_ICON_ROCK`           | Rock emoji ⛰              |

## Sounds Needed (UIAssets.lua)
| Sound            | Placeholder                   | Roblox ID Suggestions               |
| ---------------- | ----------------------------- | ----------------------------------- |
| harvest_start    | `FILL_SOUND_HARVEST_START`    | Use default rustle                  |
| harvest_complete | `FILL_SOUND_HARVEST_COMPLETE` | `rbxassetid://2415458819` (sparkle) |
| craft_start      | `FILL_SOUND_CRAFT_START`      | `rbxassetid://2414212453` (ding)    |
| craft_perfect    | `FILL_SOUND_CRAFT_PERFECT`    | `rbxassetid://2415458819`           |
| serve_success    | `FILL_SOUND_SERVE_SUCCESS`    | `rbxassetid://138186576` (cash)     |
| level_up         | `FILL_SOUND_LEVEL_UP`         | `rbxassetid://12222225` (fanfare)   |

## NPC/Companion Models (NPCConfig.lua)
| Type     | Placeholder               | Status      |
| -------- | ------------------------- | ----------- |
| Child    | `FILL_NPC_CHILD`          | Placeholder |
| Adult    | `FILL_NPC_ADULT`          | Placeholder |
| Elder    | `FILL_NPC_ELDER`          | Placeholder |
| Zundapal | `FILL_COMPANION_ZUNDAPAL` | Placeholder |

## Harvest Node Meshes (HarvestNodeVariants.lua)
| Node           | Variants   | Placeholder Count |
| -------------- | ---------- | ----------------- |
| Wheat          | 3 variants | 3 placeholders    |
| Zunda Flower   | 2 variants | 2 placeholders    |
| Zunda Pea      | 3 variants | 3 placeholders    |
| Zunda Mushroom | 2 variants | 2 placeholders    |
| Zunda Berry    | 3 variants | 3 placeholders    |
| Zunda Root     | 2 variants | 2 placeholders    |
| Rock           | 2 variants | 2 placeholders    |
| Gold Ore       | 1 variant  | 1 placeholder     |

## Potential Bug: EnvironmentBootstrap Reference
```lua
local ScatterService = require(ReplicatedStorage:WaitForChild("ConfigurationFiles"):WaitForChild("ScatterService"))
```
**Issue**: Should be `ScatterService` (capital S), not `ScatterConfig`

---

## ✅ Runtime-Fallback Code Added
- `UIAssets.isPlaceholder(id)` - Detects placeholder assets
- `UIAssets.getIconWithFallback(itemName)` - Provides fallback handling
- UIHelper already has fallback emoji handling for icons
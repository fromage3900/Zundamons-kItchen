# Asset Checklist — 66 Placeholder Slots

## Category Summary
| Category | Count | File | Upload Method |
|----------|-------|------|---------------|
| UI Icons | 16 | `Shared/Config/UIAssets.lua` | `upload_decal` (PNG→Decal) |
| GUI Textures | 5 | `Shared/Config/UIAssets.lua` | `upload_decal` |
| Animations | 3 | `Shared/Config/UIAssets.lua` | Roblox Studio (Keyframe→Animation) |
| Harvest Meshes | 18 | `Shared/Config/HarvestNodeVariants.lua` | Blender→FBX→MeshPart upload |
| NPC Models | 3 | `Shared/Config/NPCConfig.lua` | Blender→FBX→Rig upload |
| NPC Animations | 3 | `Shared/Config/NPCConfig.lua` | Studio Animation Editor |
| Companion Models | 5 | `Shared/Config/NPCConfig.lua` | Blender→FBX→Rig upload |
| Companion Effects | 5 | `Shared/Config/NPCConfig.lua` | ParticleEmitter upload |
| Seasonal Textures | 4 | `ConfigurationFiles/ScatterConfig.lua` | `upload_decal` |
| Seasonal Effects | 4 | `ConfigurationFiles/ScatterConfig.lua` | ParticleEmitter upload |
| **Total** | **66** | | |

---

## 1. UI Icons (16) — `Shared/Config/UIAssets.lua`
| Key | Placeholder ID | Kenney Candidate | Notes |
|-----|---------------|------------------|-------|
| `Wheat` | `FILL_ICON_WHEAT` | `food_knight_066.png` | Wheat stalk icon |
| `Zunda Flower` | `FILL_ICON_ZUNDA_FLOWER` | — | Needs custom/emoji fallback |
| `Zunda Pea` | `FILL_ICON_ZUNDA_PEA` | `food_knight_092.png` | Green pea pod |
| `Zunda Berry` | `FILL_ICON_ZUNDA_BERRY` | `food_knight_011.png` | Berry cluster |
| `Zunda Mushroom` | `FILL_ICON_ZUNDA_MUSHROOM` | `food_knight_072.png` | Brown mushroom |
| `Zunda Root` | `FILL_ICON_ZUNDA_ROOT` | `food_knight_091.png` | Root vegetable |
| `Apple` | `FILL_ICON_APPLE` | `food_knight_006.png` | Red apple |
| `Bread` | `FILL_ICON_BREAD` | `food_knight_021.png` | Loaf of bread |
| `Cupcake` | `FILL_ICON_CUPCAKE` | `food_knight_034.png` | Frosted cupcake |
| `Apple Pie` | `FILL_ICON_APPLE_PIE` | `food_knight_010.png` | Pie slice |
| `Zunda Bread` | `FILL_ICON_ZUNDA_BREAD` | `food_knight_021.png` | Tint green variant |
| `Zunda Mochi` | `FILL_ICON_ZUNDA_MOCHI` | `food_knight_075.png` | Round rice cake |
| `Royal Stew` | `FILL_ICON_ROYAL_STEW` | `food_knight_097.png` | Soup bowl |
| `Salted Pea Bouquet` | `FILL_ICON_BOUQUET` | — | Needs custom |
| `Gold Ore` | `FILL_ICON_GOLD_ORE` | — | Needs custom/emoji |
| `Rock` | `FILL_ICON_ROCK` | — | Needs custom/emoji |

## 2. GUI Textures (5) — `Shared/Config/UIAssets.lua`
| Key | Placeholder ID | Notes |
|-----|---------------|-------|
| `progress_bar_fill` | `FILL_GUI_PROGRESS_FILL` | 9-slice green fill bar |
| `progress_bar_border` | `FILL_GUI_PROGRESS_BORDER` | 9-slice border frame |
| `combo_badge` | `FILL_GUI_COMBO_BADGE` | Star/badge icon |
| `panel_bg` | `FILL_GUI_PANEL_BG` | Semi-transparent panel |
| `button_primary` | `FILL_GUI_BUTTON_PRIMARY` | Rounded button |

## 3. Animations (3) — `Shared/Config/UIAssets.lua`
| Key | Placeholder ID | Notes |
|-----|---------------|-------|
| `harvest_loop` | `FILL_ANIM_HARVEST` | Player 2-hand gather loop |
| `cook_victory` | `FILL_ANIM_COOK_VICTORY` | Cheer/jump on perfect cook |
| `cook_fail` | `FILL_ANIM_COOK_FAIL` | Slump/shake on burn |

## 4. Harvest Node Meshes (18) — `Shared/Config/HarvestNodeVariants.lua`
| Node | Variants | Placeholder IDs |
|------|----------|-----------------|
| Wheat | 3 | `FILL_WHEAT_01/02/03` |
| ZundaFlower | 2 | `FILL_ZUNDAFLOWER_DEFAULT/RARE` |
| ZundaPea | 3 | `FILL_ZUNDAPEA_01/02/03` |
| Zunda Mushroom | 2 | `FILL_MUSHROOM_01/02` |
| Zunda Berry | 3 | `FILL_BERRY_01/02/03` |
| Zunda Root | 2 | `FILL_ROOT_01/02` |
| Rock | 2 | `FILL_ROCK_COMMON/RARE` |
| Gold Ore | 1 | `FILL_GOLDORE_DEFAULT` |

Pipeline JSONs in `Assets/Generated/` define colors and vert counts.

## 5. NPC Models (3) — `Shared/Config/NPCConfig.lua`
| Key | Placeholder ID |
|-----|---------------|
| `child.modelId` | `FILL_NPC_CHILD` |
| `adult.modelId` | `FILL_NPC_ADULT` |
| `elder.modelId` | `FILL_NPC_ELDER` |

## 6. NPC Animations (3) — `Shared/Config/NPCConfig.lua`
| Key | Placeholder ID | Shared Across |
|-----|---------------|---------------|
| `idle` | `FILL_ANIM_IDLE` | child, adult, elder |
| `walk` | `FILL_ANIM_WALK` | child, adult, elder |
| `eat` | `FILL_ANIM_EAT` | child, adult, elder |

## 7. Companion Models (5) — `Shared/Config/NPCConfig.lua`
| Key | Placeholder ID | Theme |
|-----|---------------|-------|
| `zundapal.modelId` | `FILL_COMPANION_ZUNDAPAL` | Green pea mascot |
| `ankomon.modelId` | `FILL_COMPANION_ANKOMON` | Anko bean spirit |
| `cardamon.modelId` | `FILL_COMPANION_CARDAMON` | Cardamom fairy |
| `antimon.modelId` | `FILL_COMPANION_ANTIMON` | Antimony crystal |
| `sakura.modelId` | `FILL_COMPANION_SAKURA` | Cherry blossom |

## 8. Companion Effects (5) — `Shared/Config/NPCConfig.lua`
| Key | Placeholder ID | Color |
|-----|---------------|-------|
| `zundapal.sparkleEffect` | `FILL_EFFECT_SPARKLE` | Green |
| `ankomon.sparkleEffect` | `FILL_EFFECT_GOLD` | Gold |
| `cardamon.sparkleEffect` | `FILL_EFFECT_LAVENDER` | Lavender |
| `antimon.sparkleEffect` | `FILL_EFFECT_YELLOW` | Yellow |
| `sakura.sparkleEffect` | `FILL_EFFECT_PINK` | Pink |

## 9. Seasonal Textures (4) — `ConfigurationFiles/ScatterConfig.lua`
| Key | Placeholder ID | Season |
|-----|---------------|--------|
| `summer.ambientParticles` | `FILL_TEX_BUTTERFLY` | Summer |
| `winter.ambientParticles` | `FILL_TEX_SNOW` | Winter |
| `spring.ambientParticles` | `FILL_TEX_FLOWER_PETAL` | Spring |
| `fall.ambientParticles` | `FILL_TEX_LEAF` | Fall |

## 10. Seasonal Effects (4) — `ConfigurationFiles/ScatterConfig.lua`
| Key | Placeholder ID | Season |
|-----|---------------|--------|
| `summer.postEffect` | `FILL_EFFECT_SUMMER` | Summer |
| `winter.postEffect` | `FILL_EFFECT_WINTER` | Winter |
| `spring.postEffect` | `FILL_EFFECT_SPRING` | Spring |
| `fall.postEffect` | `FILL_EFFECT_FALL` | Fall |

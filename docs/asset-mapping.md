# Asset Import Mapping - ZundaKitchen

## FBX to Placeholder Mapping

### NPC/Companion Models
| Placeholder ID            | Source Asset                   | Location                                                          |
| ------------------------- | ------------------------------ | ----------------------------------------------------------------- |
| `FILL_NPC_CHILD`          | character-female-a             | `kenney_mini-characters\Models\FBX format\character-female-a.fbx` |
| `FILL_NPC_ADULT`          | character-male-a               | `kenney_mini-characters\Models\FBX format\character-male-a.fbx`   |
| `FILL_NPC_ELDER`          | character-male-f (scaled down) | `kenney_mini-characters\Models\FBX format\character-male-f.fbx`   |
| `FILL_COMPANION_ZUNDAPAL` | zundapalupdate2                | `G:\ZUNDYMONSKITCHEN\zundapalupdate2.fbx` (ready to import)       |

### Rock Variants (Harvest Nodes)
| Placeholder ID         | Source Asset            | Location                                                |
| ---------------------- | ----------------------- | ------------------------------------------------------- |
| `FILL_ROCK_COMMON`     | rock-a                  | `kenney_survival-kit\Models\FBX format\rock-a.fbx`      |
| `FILL_ROCK_RARE`       | rock-sand-a             | `kenney_survival-kit\Models\FBX format\rock-sand-a.fbx` |
| `FILL_GOLDORE_DEFAULT` | rock-sand-b (gold tint) | `kenney_survival-kit\Models\FBX format\rock-sand-b.fbx` |

### Plants/Bushes (Substitutes)
| Placeholder ID       | Source Asset   | Location                                                   |
| -------------------- | -------------- | ---------------------------------------------------------- |
| `FILL_BERRY_*`       | hedge variants | `kenney_fantasy-town-kit_2.0\Models\FBX format\hedge*.fbx` |
| `FILL_ZUNDAFLOWER_*` | tree variants  | `kenney_fantasy-town-kit_2.0\Models\FBX format\tree.fbx`   |

### Environment Props
| Asset         | Source                          | Location                  |
| ------------- | ------------------------------- | ------------------------- |
| House/Walls   | fantasy-town-kit                | 60+ variants available    |
| Fences        | fantasy-town-kit + survival-kit | Multiple styles           |
| Trees/Foliage | fantasy-town-kit + survival-kit | `tree*.fbx`, `grass*.fbx` |

## Assets Generated (Ready for FBX Export)
Pipeline generated JSON specs in `Assets/Generated\HarvestNodes\`:
- Wheat_01/02/03.json (grass.fbx substitutes available)
- ZundaFlower_Default/Rare.json
- ZundaPea_01/02/03.json
- Mushroom_01/02.json
- BerryBush_01/02/03.json
- Root_01/02.json
- Rock_Common/Rare.json (kenney_survival-kit rocks available)
- GoldOre_Default.json (kenney_survival-kit rock-sand available)

## Zundapal Companion
- **Ready FBX available**: `G:\ZUNDYMONSKITCHEN\zundapalupdate2.fbx`

## FBX Ready to Import (Direct Use)
| Asset       | Path in Downloads                                          |
| ----------- | ---------------------------------------------------------- |
| NPC models  | `kenney_mini-characters\Models\FBX format\character-*.fbx` |
| Rocks       | `kenney_survival-kit\Models\FBX format\rock-*.fbx`         |
| Environment | `kenney_fantasy-town-kit_2.0\Models\FBX format\*.fbx`      |
| Animals     | `kenney_cube-pets_1.0\Models\FBX format\animal-*.fbx`      |

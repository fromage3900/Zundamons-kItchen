# Asset Integration Plan - FINAL

## Ready-to-Use FBX Assets (Manual Import)

### Step 1: Import Companion Model
- **File**: `G:\ZUNDYMONSKITCHEN\zundapalupdate2.fbx`
- **Textures**: Available in `G:\ZUNDYMONSKITCHEN\textures\` folder
- **Target**: ReplicatedStorage/HarvestNodes/Zundapal or Companions folder

### Step 2: Import Rock Variants
- **Common Rock**: `kenney_survival-kit\Models\FBX format\rock-a.fbx`
- **Rare Rock**: `kenney_survival-kit\Models\FBX format\rock-sand-a.fbx`
- **Gold Ore**: `kenney_survival-kit\Models\FBX format\rock-sand-b.fbx` (with gold material)

### Step 3: Import Plant/Bush Substitutes
- **Berry Bushes**: `kenney_fantasy-town-kit_2.0\Models\FBX format\hedge*.fbx` (multiple variants)
- **Flower Bushes**: `kenney_fantasy-town-kit_2.0\Models\FBX format\tree.fbx` (small trees)
- **Grass**: `kenney_fantasy-town-kit_2.0\Models\FBX format\grass*.fbx` or `kenney_survival-kit\grass*.fbx`

### Step 4: Import NPC Characters
- **Adult NPCs**: `kenney_mini-characters\Models\FBX format\character-male-a.fbx` etc.
- **Child NPCs**: `kenney_cube-pets_1.0\Models\FBX format\animal-bunny.fbx`, `animal-chick.fbx` etc.

## Pipeline Generated Assets (Need FBX Export)

The JSON specs in `Assets/Generated\HarvestNodes\` describe:
- **Wheat_01/02/03**: Grass with varying heights (use existing grass.fbx + scale)
- **ZundaFlower_Default/Rare**: Flower meshes (petal_count, stem_height parameters)
- **ZundaPea_01/02/03**: Pea pod meshes (pod_size, opened parameters)
- **Mushroom_01/02**: Mushroom cap + stem (cap_radius, spot_count)
- **BerryBush_01/02/03**: Bush with berries (berry_count, berry_color)
- **Root_01/02**: Twisted root tubers (length, twist, color)

## How to Import in Roblox Studio

1. **Via Asset Manager**:
   - View → Asset Manager → 3D Models → Import
   - Select FBX files from Downloads/G: drives
   - Set collision fidelity to "Default" or "Medium"

2. **Via Import Script** (scripts/import_harvest_meshes.luau):
   - Create placeholder parts in ReplicatedStorage
   - Replace with imported meshes after upload

3. **Placeholder IDs to Update** (in HarvestNodeVariants.lua):
   - Replace all `rbxassetid://FILL_*` placeholders with actual uploaded asset IDs
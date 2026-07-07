# Mesh Import Workflow for Collaborative Use

## Problem
Previously, meshes were referenced by `rbxassetid://` IDs that only worked if the asset owner had them in their inventory. Collaborators couldn't see the meshes.

## Solution: Localized Meshes
Meshes are now imported into the place file's `ReplicatedStorage.Meshes` folder. This means:
- ✅ Meshes are embedded in the .rbxlx file
- ✅ Anyone who opens the place gets the meshes automatically
- ✅ No dependency on external asset ownership
- ✅ Easy to update in Studio
- ✅ Git tracks the folder structure, place file tracks the mesh data

## Folder Structure
```
ReplicatedStorage/
└── Meshes/
    ├── HarvestNodes/
    │   ├── CarrotPlot/
    │   │   ├── Seed (MeshPart)
    │   │   ├── SeedLeaf (MeshPart)
    │   │   ├── Leaf (MeshPart)
    │   │   ├── Mature (MeshPart)
    │   │   └── Processed (MeshPart)
    │   ├── Wheat/
    │   ├── Apple/
    │   └── ...
    ├── Companions/
    │   ├── Zundamon/
    │   └── ...
    ├── Environment/
    │   ├── Trees/
    │   └── Mushrooms/
    └── Food/
        ├── Bread/
        └── ...
```

## How to Import Meshes

### Step 1: Open Place in Roblox Studio
```bash
# Build the place file
npm run rojo:build

# Open in Studio
start workspace/Zundamons-kItchen.rbxl
```

### Step 2: Import Mesh from Toolbox or File
**Option A: From Toolbox**
1. Open Toolbox (View → Toolbox)
2. Search for your mesh (e.g., "carrot", "wheat", "zundamon")
3. Click to insert into Workspace
4. In Explorer, drag the mesh to `ReplicatedStorage.Meshes.HarvestNodes.CarrotPlot`
5. Rename it to match the stage name (e.g., "Seed", "Mature")

**Option B: From File (FBX/OBJ)**
1. File → Import from File
2. Select your .fbx or .obj file
3. The mesh appears in Workspace
4. Drag to `ReplicatedStorage.Meshes.[Category]/[Subcategory]`
5. Rename appropriately

### Step 3: Verify Mesh Properties
Select the imported MeshPart and check:
- **MeshId** should be set (e.g., `rbxassetid://132798405534424`)
- **Size** should be reasonable (start with 1,1,1 and adjust)
- **Anchored** = true (for static meshes)
- **CanCollide** = false (for decorative meshes)

### Step 4: Save the Place
**File → Save to Roblox** (Ctrl+S)

This embeds the mesh data into the place file. When you push to git and collaborators pull, they'll get the meshes automatically.

### Step 5: Update Config (Optional)
If you're adding a new mesh type, update `MeshAssets.lua` or `GrowthStageConfig.lua` to reference it.

## Current Mesh Status

### ✅ Imported (Real Asset IDs)
- **Zundamon companion**: `81331860128238`
- **Mushroom**: `96844649112031`
- **Tree variants**: `82622166538467`, `80371673720142`
- **Bee**: `91701180154526`
- **CarrotPlot stages**: `132798405534424`, `110157288415078`, `94366688581103`, `118786859560292`, `85258154641863`, `86749155295155`

### ⚠️ Need Import (Fake/Pipeline IDs in Config)
- ZundaPea variants (3 meshes)
- ZundaFlower variants (2 meshes)
- ZundaMushroom variants (2 meshes)
- ZundaBerry variants (3 meshes)
- ZundaRoot variants (2 meshes)
- Wheat variants (3 meshes)
- Rock variants (2 meshes)
- GoldOre (1 mesh)
- 7 companion FBXs (zundacat, zundabunny, tantanmon, ankomon, cardamon, antimon, sakuradamon)

## Using MeshProvider in Code

Instead of hardcoding asset IDs:
```lua
-- ❌ Old way (breaks for collaborators)
local meshId = "rbxassetid://123456789"
meshPart.MeshId = meshId
```

Use MeshProvider:
```lua
-- ✅ New way (works for everyone)
local MeshProvider = require(ReplicatedStorage.Shared.Modules.MeshProvider)
local meshId = MeshProvider.get("HarvestNodes/CarrotPlot", "Seed")
if meshId ~= "" then
    meshPart.MeshId = meshId
end
```

## Troubleshooting

### Mesh shows as grey box
- MeshId is invalid or asset doesn't exist
- Re-import the mesh from Toolbox or file

### Collaborator can't see mesh
- Mesh wasn't saved to the place file
- Import it again and save (Ctrl+S)

### MeshId is empty after import
- The mesh might be a Model, not a MeshPart
- Check if it has MeshPart children
- Use the first MeshPart's MeshId

## Workflow for Adding New Meshes

1. **Identify what's needed** (e.g., "Wheat harvest node")
2. **Find/create the mesh** (Toolbox search, Blender, etc.)
3. **Import into Studio** (File → Import or Toolbox insert)
4. **Place in correct folder** (`ReplicatedStorage.Meshes.HarvestNodes.Wheat`)
5. **Name appropriately** (e.g., "Wheat_01", "Wheat_02")
6. **Save place** (Ctrl+S)
7. **Update config** (add to MeshAssets.lua or GrowthStageConfig.lua)
8. **Test in-game** (verify mesh loads and works)
9. **Commit changes** (git add + commit)

## Benefits of This System

1. **Collaborative**: Everyone sees the same meshes
2. **Version-controlled**: Folder structure in git, mesh data in place file
3. **Flexible**: Easy to swap meshes in Studio
4. **Fallback support**: MeshProvider falls back to MeshAssets IDs if mesh not found
5. **Organized**: Clear category structure
6. **Scalable**: Easy to add new mesh types

## Next Steps

1. Import remaining meshes from Toolbox (see "Need Import" list above)
2. Test CarrotPlot growth stages in-game
3. Update ZundaGatherServer to use GrowthStageConfig
4. Import companion FBXs when available
5. Document mesh sources in CREDITS.md

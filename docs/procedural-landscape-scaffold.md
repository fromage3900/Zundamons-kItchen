# Procedural Landscape Scaffold

## What is included

- A biome manifest in [src/ReplicatedStorage/Shared/Config/LandscapeConfig.lua](src/ReplicatedStorage/Shared/Config/LandscapeConfig.lua)
- A placement helper in [src/ReplicatedStorage/Shared/Modules/PlacementRules.lua](src/ReplicatedStorage/Shared/Modules/PlacementRules.lua)
- A generator module in [src/ReplicatedStorage/Shared/Modules/ProceduralLandscape.lua](src/ReplicatedStorage/Shared/Modules/ProceduralLandscape.lua)
- A starter preview artifact in [Assets/Generated/ProceduralLandscape/GardenVillage.json](Assets/Generated/ProceduralLandscape/GardenVillage.json)

## First biome

The initial scaffold defines a `GardenVillage` biome with:

- a central plaza zone
- garden-edge clusters
- a market row
- a path loop

The generator produces a lightweight placement plan that can later be used to spawn buildings, props, and foliage in Studio.

## Next extension targets

1. Add more biome presets for forest edge and town plaza.
2. Connect the generator to architecture variants and existing environment assets.
3. Add runtime spawning logic in ServerScriptService or a shared service module.

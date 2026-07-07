# Procedural Architecture Addon Scaffold

This scaffold defines the runtime and asset pipeline structure for a Roblox procedural architecture addon, modeled after the existing Blender-based harvest node pipeline.

## Files created

- `scripts/architecture_pipeline_gen.py`
- `src/ReplicatedStorage/Shared/Config/ArchitecturePipeline.lua`
- `src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua`

## Goals

- Provide a manifest for generated architecture assets
- Provide placeholder asset wiring for imported mesh IDs
- Provide a generation script to produce JSON specs and OBJ placeholders
- Mirror the existing `BlenderPipeline` manifest and `HarvestNodeVariants` wiring patterns

## Workflow

1. Create new procedural architecture variants in `ArchitecturePipeline.lua`.
2. Use `python scripts/architecture_pipeline_gen.py --category <category> --output Assets/Generated/Architecture` to generate JSON specs and OBJ placeholders.
3. Import the generated `Assets/Generated/Architecture/*/*.obj` files into Roblox Studio.
4. Update `ArchitectureVariants.lua` with the imported `rbxassetid://` values.
5. Wire the variants into game systems via a new architecture loader module.

## Next integration steps

- Add a module like `src/ReplicatedStorage/Shared/Modules/ArchitectureLoader.lua` to resolve `ArchitectureVariants` and instantiate models.
- Add Studio asset folders under `ReplicatedStorage/Models/Architecture` or `Workspace/Architecture`.
- Create Rojo asset mapping or a `default.project.json` entry if a new folder is required.
- Add `ArchitecturePipeline.lua` entries to `docs/asset-mapping.md` once actual art IDs are known.

## Example command

```powershell
python scripts/architecture_pipeline_gen.py --category buildings --output Assets/Generated/Architecture
```

## Categories

- `buildings`
- `street_props`
- `interiors`
- `decor`

## Notes

- This is intentionally scaffold-level: generators are lightweight and placeholder-driven.
- Swap the placeholder OBJ generation for a real Blender/MCP integration when ready.

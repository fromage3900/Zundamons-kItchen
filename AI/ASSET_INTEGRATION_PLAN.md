# Zunda Asset Integration Plan

## Assets Found (Downloads Folder)

| Set | Files | What | Where it goes |
|-----|-------|------|---------------|
| **Zundamon FBX** | 1 FBX + 8 PBR textures + expression sheet | Full character rig | `Assets/Upload/Zundamon/` → Studio MeshPart |
| **Zundamon VRM** | .vrm file + .unitypackage + .blend | VRM-ready model | Import to Studio, use as companion |
| **Zundamon PMX** | .pmx (MMD format) | MikuMikuDance model | Convert to FBX → import |
| **Young Lady Zundamon** | Low-poly FBX + texture maps | Alternative companion | `Assets/Upload/Companions/` |
| **Kenney Mini Characters** | 12 characters (6M/6F) in FBX/GLB/OBJ | Guest NPC placeholders | `Assets/Upload/NPCs/` |
| **Live2D Zundamon** | moc3, cmo3, can3, 18 expressions, 4 motions, PSD | **VN Portrait system** | See Live2D plan below |
| **Zundamon Cursors** | 20 .ani cursor files | Windows cursor set | Convert to Roblox ImageButton cursors |
| **Zunda Arrow Cursors** | 17 .ani/.cur cursor files | Arrow cursor variants | Same as above |

## Live2D → VN Portrait Integration

The Live2D model has 18 expression presets that map directly to VN dialogue expressions:

| Live2D Expression | VN Expression | Use |
|-------------------|--------------|-----|
| `default` (base) | `default` | Neutral dialogue |
| `BrushFace` | `happy` | Cheerful lines |
| `GameController` | `excited` | Enthusiastic dialogue |
| `GuruguruEye` | `thinking` | Spiral-eye confusion |
| `Hauu` | `embarrassed` | Whimpering lines |
| `IndexFingerL/R` | `pointing` | Playful accusations |
| `NoEyes` | `sad` | Gloomy lines |
| `PaleFace` | `surprised` | Shocked reaction |
| `ShockEye` | `surprised` | Wide-eyed surprise |
| `SmallEyes` | `suspicious` | Skeptical lines |
| `StarEye` | `amazed` | Star-eyed wonder |
| `Sweat` | `nervous` | Awkward laughter |
| `Tear1/Tear2` | `crying` | Emotional moments |
| `WhiteEye` | `deadpan` | Dull reaction |

**Integration path:**
1. Render each expression as a PNG frame from Live2D Cubism Editor
2. Upload each PNG as a Roblox Decal
3. Update `VNDialoguePortraits.lua` with the real decal IDs

## Cursor → Roblox UI Integration

The Zundamon cursor set has 20 cursor states. These can be used in Roblox via:
- `ImageButton` cursor changes on hover
- `Mouse.Icon` property for custom cursors
- Loading screen animations using the .ani sequences

## Implementation Priority

```
NOW (while meshes import):
  1. Copy all asset files to Assets/Upload/ organized by type
  2. Run npm run import:scan to generate import script
  3. Queue the import in Studio (can run in background)

TODAY:
  4. Import Zundamon FBX → set as companion mesh
  5. Review Kenney characters → assign to guest types
  6. Render Live2D expressions → create VN decals

THIS WEEK:
  7. Convert cursor files → add as UI polish
  8. Set up young lady Zundamon as alternative companion
  9. Wire all VN portraits with real decal IDs
```

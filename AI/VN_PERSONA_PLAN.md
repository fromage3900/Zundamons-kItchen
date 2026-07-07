# VN Persona Placeholder Plan

## Assets Found in Downloads

| Source | Type | Count | License | VN Use |
|--------|------|-------|---------|--------|
| `Zundamon/` | Full character FBX + PBR textures (Body, Cloth, Eye, Hair, Head, Tail, Expression) | 1 character, 8 textures | Licensed | **Companion portrait** — use rendered expressions for zundamon/zundapal VN faces |
| `young-lady-zundamon-lowpoly/` | Low-poly character + texture maps | 1 character, 12 textures | Licensed | **Alternative companion** — sakuradamon or cardamon placeholder |
| `kenney_mini-characters/` | 12 unique characters (6M/6F) + accessories in FBX/GLB/OBJ + colormap | 12 characters, 139 files | CC0 | **Guest NPCs** — use as Child/Adult/Elder guest portraits |
| `zundapalupdate2.fbx` | Companion mesh | 1 file | Owned | Already wired — just needs real upload |

## Integration Plan

### Phase 1: Import Character Assets to Studio

```powershell
# 1. Copy character files into project
Copy-Item "C:\Users\froma\Downloads\Zundamon\*" "G:\Zundamons-kItchen\Assets\Upload\Zundamon\" -Recurse
Copy-Item "C:\Users\froma\Downloads\kenney_mini-characters\character-*.fbx" "G:\Zundamons-kItchen\Assets\Upload\kenney_characters\"

# 2. Generate import script
npm run import:scan

# 3. Paste reports/mesh_pipeline/batch_import.luau into Studio
# 4. Save results, then:
npm run import:apply
```

### Phase 2: Create VN Portrait Decals

For each character, render a face/body/full portrait and upload as Decal:

1. **Zundamon**: Import FBX → pose in Studio → screenshot face + body → upload as Decal → get rbxassetid
2. **Expression variants**: Use `Tex_Expression.png` (43KB) texture to create happy/thinking/surprised/blush/sad variants
3. **Kenney characters**: Import as MeshParts → screenshot → upload as Decal → assign to guest NPC portrait slots
4. **Young lady Zundamon**: Alternative companion portrait for sakuradamon/cardamon

### Phase 3: Update VNDialoguePortraits

```lua
-- After getting real decal IDs, update VNDialoguePortraits.lua:
zundamon = {
    full = "rbxassetid://<real_id>",       -- Full body render
    face = "rbxassetid://<real_id>",       -- Face close-up  
    body = "rbxassetid://<real_id>",       -- Body portrait
    expressions = {
        default = "rbxassetid://<real_id>",
        happy = "rbxassetid://<real_id>",
        thinking = "rbxassetid://<real_id>",
        surprised = "rbxassetid://<real_id>",
        blush = "rbxassetid://<real_id>",
        sad = "rbxassetid://<real_id>",
    },
}
```

### Phase 4: Wire to VNController

The VNController reads `VNDialoguePortraits.getPortrait(speakerKey, expression)` to display the correct image based on NPC dialogue. Once real decal IDs are in place, the VN will show actual character art instead of fallback text.

## Kenney Character → Guest NPC Mapping

| Guest Type | Kenney Character | VN Speaker Key |
|-----------|-----------------|----------------|
| Child | character-female-c or character-male-c | `child_guest` |
| Adult | character-female-a or character-male-a | `adult_guest` |
| Elder | character-male-f (older model) | `elder` |
| Chef | character-male-d (apron-style) | `chef` |
| Food Critic | character-female-d | `critic_guest` |
| Regular | character-female-b or character-male-b | `regular_guest` |

## Current VNDialoguePortraits State

| Speaker | Has face? | Has body? | Has expressions? |
|---------|----------|----------|-----------------|
| zundamon | ✅ fake ID | ✅ fake ID | 6 variants (all same fake) |
| zundapal | ✅ fake ID | ✅ fake ID | 4 variants (all same fake) |
| narrator | ❌ | ❌ | 1 default (empty) |
| elder | ✅ fake ID | ✅ fake ID | 1 default (fake) |
| chef | ✅ fake ID | ✅ fake ID | 1 default (fake) |
| ankomon | ❌ | ❌ | 1 default (empty) |
| cardamon | ❌ | ❌ | 1 default (empty) |
| antimon | ❌ | ❌ | 1 default (empty) |
| sakuradamon | ❌ | ❌ | 1 default (empty) |

**5 of 9 speakers need any portrait at all.** The Kenney + Zundamon assets can fill all 9 with distinct looks.

# Handoff for Qwen — Zundamon's Kitchen

## Session: July 7, 2026 (The Bad One)

### What Went Wrong (don't repeat)

1. **Over-verified mesh IDs** — Claimed config IDs were real when they were pipeline-generated fakes. The only way to verify: try loading via `AssetService:CreateEditableMeshAsync()`. Numbers >100k don't mean real.

2. **Broke working systems** — Modified CompanionManager/ShopServer/HUD/HudScript to add WaitForChild timeouts and UIConfig integration. These changes looked correct but broke the runtime behavior. The original code at commit `0dafc6d` was working. **Don't touch what works.**

3. **Fake automation promises** — Built auto-mapper, config updater, mesh pipeline tools that didn't actually solve the core problem (OBJ files not in Studio). Tools are useless if the source assets aren't there.

4. **Circular fixes** — Kept "restoring" the same files in different ways instead of just reverting once and moving on.

### Current Git State

```
HEAD: 8e8e042 — companion mesh ID fixed, all companion files at 0dafc6d originals
Remotes: origin/main force-pushed, clean
```

### What's Actually True

| System | Status | Mesh Source |
|--------|--------|-------------|
| CompanionManager | ✅ Working (0dafc6d code) | FBX imported in Studio, ID `103182526409237` wired |
| CompanionShopServer | ✅ Working (0dafc6d code) | Original |
| CompanionHUD | ✅ Working (0dafc6d code) | Original |
| HudScript | ✅ Working (0dafc6d code) | Original |
| Admin Console | ✅ F2 works | Script in StarterPlayerScripts |
| Cursor Decals | ✅ 17 uploaded | `rbxassetid://129907991370277` etc, in CursorConfig |
| ScatterService | ✅ Cube fallback | All config IDs are fake — will use colored Parts |
| GuestManager | ✅ Capsule fallback | GuestTemplate is empty folder, makes procedural guests |
| Crafting/Serving | ✅ Works | No meshes needed |
| MeshAssets.lua | ⚠️ All 18 IDs are fake | No real harvest node OBJs in Studio |
| NPCConfig | ⚠️ All IDs are fake | No companion/NPC FBXs imported except zundapal |
| DecorationConfig | ⚠️ 8 items need meshes | No decoration FBXs |

### Real Priorities for Next Session

1. **Import the 26 OBJ files** — They need to be found (Downloads, Kenney archives, etc.) and imported via Studio → Insert → Import From File. After import, extract their MeshIds and paste into `MeshAssets.lua`.

2. **Import companion FBXs** — Only `zundapalupdate2.fbx` is imported. The other 7 companion characters (zundacat, zundabunny, tantanmon, ankomon, cardamon, antimon, sakuradamon) and 3 NPC templates (child, adult, elder) need FBX files and importing.

3. **Past config IDs into git** — After real IDs exist in Studio workspace, run the extraction script and save to `import_results.json`, then `npm run import:apply`.

4. **Populate the world** — Run `PopulateWorld.dev.populate()` in Studio command bar after meshes are wired.

### What NOT to Do

- ❌ Don't modify CompanionManager, CompanionShopServer, CompanionHUD, or HudScript
- ❌ Don't claim IDs are real without loading them
- ❌ Don't build automation for missing assets
- ❌ Don't over-verify — just execute and show results

### Files That Are Safe to Touch (everything else)

- `MeshAssets.lua`, `NPCConfig.lua`, `HarvestNodeVariants.lua` — asset ID updates only
- `CursorConfig.lua` — cursor Decal IDs (17 already real)
- `DecorationConfig.lua` — meshId fields (8 items need real IDs)
- `default.project.json` — Workspace mapping already removed, don't add back
- All scripts in `scripts/agent_orchestrator/` — offline tools, won't break game

### Quick Commands

```bash
# Verify mesh ID reality (tests by loading in Roblox)
node scripts/verify-meshes.mjs

# Sync to Studio
npm run rojo:serve

# Full audit
npm run overnight
```

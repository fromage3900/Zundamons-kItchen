# 🎮 Zundamon's Kitchen - Asset Integration Handoff

**Last Updated:** 2026-07-07  
**Status:** Mesh IDs consolidated, ready for integration

---

## 📌 CRITICAL: Asset Integration Path

### For OpenCode Agents, Claude, and Codebase Assistants:

**STOP CREATING NEW ASSET IDs** - 205 assets already exist and are documented.

---

## 🔧 Workstream 1: ScatterService Integration (READY NOW)

**File:** `src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua`

### Current State (BROKEN):
```lua
return {
    meshes = {
        ["Bush"] = { ["bush"] = "rbxassetid://71267543570887" },
        ["Lantern"] = { ["Lantern"] = "rbxassetid://9854046603" },
        ["Neon"] = { ["neon heart"] = "rbxassetid://601198887" },
    }
}
```

### Needed (from HarvestNodeVariants.lua):
```lua
return {
    meshes = {
        ZundaFlower = {
            ZundaFlower_Default = "rbxassetid://130899236683010",
            ZundaFlower_Rare = "rbxassetid://86582218951352",
        },
        ZundaPea = {
            ZundaPea_01 = "rbxassetid://106482523402868",
            ZundaPea_02 = "rbxassetid://119452475051045",
            ZundaPea_03 = "rbxassetid://107116519758062",
        },
        ["Zunda Mushroom"] = {
            Mushroom_01 = "rbxassetid://96331224587968",
            Mushroom_02 = "rbxassetid://85124051974569",
        },
        ["Zunda Berry"] = {
            BerryBush_01 = "rbxassetid://91224321091798",
            BerryBush_02 = "rbxassetid://74222048987638",
            BerryBush_03 = "rbxassetid://76322051780722",
        },
        ["Zunda Root"] = {
            Root_01 = "rbxassetid://106581238862764",
            Root_02 = "rbxassetid://122644985457254",
        },
        Wheat = {
            Wheat_01 = "rbxassetid://120483243502197",
            Wheat_02 = "rbxassetid://124905165003062",
            Wheat_03 = "rbxassetid://127847933091778",
        },
        Rock = {
            Rock_Common = "rbxassetid://74975285002856",
            Rock_Rare = "rbxassetid://138139954211772",
        },
        ["Gold Ore"] = {
            GoldOre_Default = "rbxassetid://105153259339546",
        },
    }
}
```

### After Update:
1. Run `PopulateWorld.dev.populate()` in Studio command bar
2. Colored cubes become actual harvest node meshes
3. Nodes are clickable and harvestable immediately

---

## 👥 Workstream 2: Companion Templates

**File:** `src/ReplicatedStorage/Shared/Config/NPCConfig.lua`

### Needed:
```lua
NPCConfig.companionTemplates = {
    zundamon = { modelId = "rbxassetid://121481310719137", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484" },
    zundacat = { modelId = "rbxassetid://101663144452966", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484" },
    zundabunny = { modelId = "rbxassetid://76425192775041", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484" },
    tantanmon = { modelId = "rbxassetid://107150527246774", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484" },
    ankomon = { modelId = "rbxassetid://110290651922538", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484", buff = { stat = "gold", magnitude = 0.15 } },
    cardamon = { modelId = "rbxassetid://91041813069462", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484", buff = { stat = "perfect_window", magnitude = 0.30 } },
    antimon = { modelId = "rbxassetid://94125444857929", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484", buff = { stat = "extra_drop", magnitude = 0.20 } },
    sakuradamon = { modelId = "rbxassetid://128478553136178", scale = 0.5, followSpeed = 8, sparkleEffect = "rbxassetid://241685484", buff = { stat = "xp", magnitude = 0.25 } },
}
```

---

## ⚠️ Assets NOT TO TOUCH

| Category | Count | Location | Status |
|----------|-------|----------|--------|
| Harvest Mesh IDs | 18 | HarvestNodeVariants.lua | ✅ Already wired |
| Companion Mesh IDs | 8 | CompanionManager.server.lua | ✅ Already wired |
| UI Icons | 16 | UIAssets.lua | ✅ Done |
| Sound FX | 8 | UIAssets.sounds | ✅ Done |
| Skybox | 8 textures | SkyConfig.sky | 🟡 Same texture on all faces |

---

## 🚨 Remaining Gaps (DO NOT START NEW)

| Gap | Assets Needed | Source |
|-----|---------------|--------|
| Weather Sounds | 6 | Replace `rbxasset://sounds/*` with real Roblox IDs |
| Decoration Meshes | 8 | FBX files in kenney_fantasy-town-kit |
| Animation IDs | 4 | Create in Studio → Animate |

---

## 🔄 Integration Checklist

- [ ] MeshAssets.lua updated with all harvest variants
- [ ] NPCConfig.lua companionTemplates populated  
- [ ] PopulateWorld.dev.populate() tested in Studio
- [ ] ScatterService.scatterBiome() working with real meshes
- [ ] Guests spawn with visual feedback
- [ ] Harvest nodes show proper meshes

---

## 📞 For Other AI Agents

If you're working on:
- **Quests/Difficulty:** Use `QuestConfig.lua` - 68 quests already defined
- **Recipes:** Use `CraftConfig.lua` - 19 recipes with ingredient costs
- **Progression:** Use `ProgressionConfig.lua` - XP/gold curves tuned
- **Weather:** See `SkyConfig.weather_types` - 9 weather types need sound assets
- **Decorations:** See `DecorationConfig.lua` - 8 items need mesh FBX imports

**All game logic systems are ready - only asset wiring remains.**
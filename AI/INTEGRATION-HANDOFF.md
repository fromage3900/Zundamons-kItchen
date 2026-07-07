# 🎮 Zundamon's Kitchen - Asset Integration Handoff

**Last Updated:** 2026-07-07  
**Status:** ✅ Integration Complete

---

## 📌 CRITICAL: Asset Integration Path

### For OpenCode Agents, Claude, and Codebase Assistants:

**STOP CREATING NEW ASSET IDs** - 205 assets already exist and are documented.

---

## ✅ COMPLETED INTEGRATION (2026-07-07)

### MeshAssets.lua
- All 18 harvest node variants wired: ZundaFlower, ZundaPea, Zunda Mushroom, Zunda Berry, Zunda Root, Wheat, Rock, Gold Ore
- Helper function `getMeshId(nodeType, variantId)` added for fallback support
- Keys align with ScatterConfig node_types for seamless integration

### NPCConfig.lua  
- All 8 companion templates populated with mesh IDs and buffs
- Free companions: zundamon, zundacat, zundabunny, tantanmon
- Premium companions (500 Robux): ankomon, cardamon, antimon, sakuradamon

### Integration Verification
- ✅ ScatterService reads: `MeshAssets.meshes[nodeType][variantId]`
- ✅ Keys align: `ZundaFlower` → `ZundaFlower_Default/Rare`
- ✅ Variant IDs match ScatterConfig node_types

---

## 🔧 Testing Instructions

Run in Studio command bar:
```lua
require(game.ServerScriptService.DevTools.PopulateWorld).populate()
```

This will spawn real harvest node meshes that are clickable and harvestable.

---

## ⚠️ Assets NOT TO TOUCH

| Category | Count | Location | Status |
|----------|-------|----------|--------|
| Harvest Mesh IDs | 18 | MeshAssets.lua | ✅ Integrated |
| Companion Mesh IDs | 8 | NPCConfig.lua | ✅ Integrated |
| UI Icons | 16 | UIAssets.lua | ✅ Done |
| Sound FX | 8 | UIAssets.sounds | ✅ Done |
| Skybox | 8 textures | SkyConfig.sky | 🟡 Same texture on all faces |

---

## 🚨 Remaining Gaps (DO NOT CREATE NEW ASSETS FOR THESE)

| Gap | Assets Needed | Source |
|-----|---------------|--------|
| Weather Sounds | 6 | Replace `rbxasset://sounds/*` with real Roblox audio IDs in WeatherClient.client.lua |
| Decoration Meshes | 8 | FBX files in kenney_fantasy-town-kit → upload and wire to DecorationConfig |
| Animation IDs | 4 | Create in Studio → Edit → Animation, wire to HarvestConfig |
| Zone Triggers | 6 | Add ClickDetectors in workspace for ZoneLoreConfig zones |

---

## 📞 For Other AI Agents

If you're working on:
- **Quests/Difficulty:** Use `QuestConfig.lua` - 68 quests already defined
- **Recipes:** Use `CraftConfig.lua` - 19 recipes with ingredient costs
- **Progression:** Use `ProgressionConfig.lua` - XP/gold curves tuned
- **Weather:** See `SkyConfig.weather_types` - 9 weather types defined
- **Decorations:** See `DecorationConfig.lua` - 11 items (3 wired, 8 need meshes)

**All game logic systems are ready - remaining gaps documented above.**

---

## 🔧 Quick Reference: Asset IDs

### Harvest Nodes (MeshAssets.meshes)
```
ZundaFlower_Default: rbxassetid://130899236683010
ZundaFlower_Rare: rbxassetid://86582218951352
ZundaPea_01: rbxassetid://106482523402868
ZundaPea_02: rbxassetid://119452475051045
ZundaPea_03: rbxassetid://107116519758062
Mushroom_01: rbxassetid://96331224587968
Mushroom_02: rbxassetid://85124051974569
BerryBush_01: rbxassetid://91224321091798
BerryBush_02: rbxassetid://74222048987638
BerryBush_03: rbxassetid://76322051780722
Root_01: rbxassetid://106581238862764
Root_02: rbxassetid://122644985457254
Wheat_01: rbxassetid://120483243502197
Wheat_02: rbxassetid://124905165003062
Wheat_03: rbxassetid://127847933091778
Rock_Common: rbxassetid://74975285002856
Rock_Rare: rbxassetid://138139954211772
GoldOre_Default: rbxassetid://105153259339546
```

### Companions (NPCConfig.companionTemplates)
```
zundamon: rbxassetid://121481310719137
zundacat: rbxassetid://101663144452966
zundabunny: rbxassetid://76425192775041
tantanmon: rbxassetid://107150527246774
ankomon: rbxassetid://110290651922538
cardamon: rbxassetid://91041813069462
antimon: rbxassetid://94125444857929
sakuradamon: rbxassetid://128478553136178
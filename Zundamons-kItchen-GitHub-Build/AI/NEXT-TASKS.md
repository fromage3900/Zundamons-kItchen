# Task Priority Matrix

## 🔴 Critical (Requires Unrestricted Network)
- [ ] Upload 167 Kenney Food Kit preview PNGs as decals (`upload_decal`)
- [ ] Upload Impact Sounds OGGs as audio (`upload_audio`)
- [ ] Wire returned `rbxassetid://` into UIAssets.lua ImageLabel.Image properties
- [ ] Wire returned `rbxassetid://` into HarvestNodeVariants.lua mesh IDs

## 🟡 High (Can Do Now — Code Only)
- [ ] Wire Mineable.server.lua with HarvestValidator (5-line patch)
- [ ] Sync source code to Studio via Rojo or MCP `create_object` + `set_script_source`
- [ ] Create `Shared.Config` folder hierarchy in Studio (doesn't exist yet)

## 🟢 Medium (Documentation)
- [ ] Create `docs/asset-checklist.md` — catalog all 58 `FILL_*` slots
- [ ] Create `docs/testing-plan.md` — harvest, cook, serve, quest scenarios
- [ ] Update `docs/architecture-overview.md` with flow diagrams

## 🔵 Low (Nice to Have)
- [ ] QuestConfig.lua — daily/weekly quest data module
- [ ] Patch notes template

---

## Files to Create Today
```
src/ReplicatedStorage/QuestConfig.lua          (NEW)
src/ReplicatedStorage/HarvestNodeVariants.lua  (DONE - already exists)
docs/testing-plan.md                         (NEW)
docs/asset-checklist.md                      (NEW)
```

---

## Wire Mineable.validator (5-line patch)
Location: `src/ServerScriptService/Mineable.server.lua`

Add after line 70 in bindNode or itemEvent:
```lua
local HarvestValidator = game.ServerScriptService:FindFirstChild("Validation") and game.ServerScriptService.Validation:FindFirstChild("HarvestValidator")
local validateHarvest = HarvestValidator and require(HarvestValidator).validateHarvest

-- In the click handler:
if validateHarvest then
    local valid, err = validateHarvest(player, item)
    if not valid then return end
end
```

---

## QuestConfig Module (Sample Structure)
```lua
-- QuestConfig.lua
return {
    daily = {
        {
            id = "q_harvest_daily",
            title = "Daily Harvest",
            desc = "Gather 10 materials",
            goal = 10,
            metric = "totalGather",
            reward = { gold = 50, xp = 100 },
            icon = "🌿"
        }
    },
    weekly = {
        -- Rare quests
    }
}
```

---

### Blocked Status Summary
| Blockage | Tool | Root Cause | Workaround |
|----------|------|------------|------------|
| Decal upload | `upload_decal` | Firewall blocks 128.116.116.3 | Run from home network |
| Luau execution | `execute_luau` | v2.6.0 compile bug | `set_script_source` + `create_object` |
| Mesh generation | Blender pipeline | Requires unrestricted network + Studio | Generate FBX at home, upload later |
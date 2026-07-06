# Documentation & Planning Task List (No MCP Required)

## Immediate Tasks (Can Do Now)

### 1. Quest System Configuration (High Priority)
- [ ] Create `QuestConfig.lua` module
- [ ] Define daily/weekly quests as data
- [ ] Add quest reward variations (gold, XP, unlocks)

### 2. Mineable Validator Wiring (High Priority)
- [ ] Read Mineable.server.lua
- [ ] Add HarvestValidator.validateHarvest call
- [ ] Add nil guards for character

### 3. Architecture Documentation (Medium Priority)
- [ ] Update `docs/architecture-overview.md` with flow diagrams
- [ ] Document HarvestNodeVariants usage
- [ ] Add quest integration notes

### 4. Testing Plan Documentation (Medium Priority)
- [ ] Create `docs/testing-plan.md`
- [ ] List all test scenarios (harvest, cook, serve, quest)
- [ ] Add edge cases (death, disconnect, exploit attempts)

### 5. Asset Checklist (Medium Priority)
- [ ] List all asset IDs needed (meshes, sounds, animations)
- [ ] Create `docs/asset-checklist.md`
- [ ] Mark placeholder IDs to replace

### 6. Patch Notes Template (Low Priority)
- [ ] Update `docs/patch-notes-template.md`
- [ ] Add harvest loop changes section
- [ ] Add quest system section

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

**Pick any task to start — all can be done in Act Mode without MCP.**
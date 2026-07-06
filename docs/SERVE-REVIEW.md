# 🍽️ Serving System Review

## Current Status ✅

| Check            | Status                                | Notes |
| ---------------- | ------------------------------------- | ----- |
| Guest validation | ✅ Validates guest in workspace.Guests |
| Distance check   | ✅ 20 stud max distance                |
| Food item check  | ✅ Must match guest's preferred recipe |
| Inventory check  | ✅ Deducts 1 from playerData           |
| Combo system     | ✅ bumpCombo called on serve           |
| Reward pipeline  | ✅ Gold + XP via RewardCore            |
| Stats tracking   | ✅ guests_served, total_gold_earned    |

## Issues Found

| Issue                           | Fix Required       |
| ------------------------------- | ------------------ |
| Uses `PlayerDataService.get`    | Already migrated ✅ |
| Uses `_G.data` fallback?        | Check RewardCore ✅ |
| Guest removal uses GuestService | Needs verification |

## Gameplay Loop Integration

### Full Loop Test Sequence
1. **Harvest** → Get Wheat
2. **Cook** → Craft Bread (via CraftManager)
3. **Serve** → Give to guest → XP + Gold

### Required Systems
| System  | File                                 | Status  |
| ------- | ------------------------------------ | ------- |
| Harvest | ZundaGatherServer, HarvestController | ✅ Ready |
| Cook    | CraftManager, CraftConfig            | ✅ Ready |
| Serve   | ServingSystem, GuestService          | ✅ Ready |
| Rewards | RewardCore, AdvancedRewards          | ✅ Ready |

## Next Steps
- Test in Studio: Harvest Wheat → Craft Bread → Serve Guest
- Verify guest accepts correct dish
- Check Gold/XP awarded
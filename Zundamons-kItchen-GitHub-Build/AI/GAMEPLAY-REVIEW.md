# Gameplay Systems Review - Professional Cozy Game Analysis

## Executive Summary
Zundamon's Kitchen is a promising cozy culinary RPG with a solid Harvest → Cook → Serve loop. The core systems are functional but need configuration consolidation and progression rebalancing.

---

## Core Loop Analysis

### ✅ What Works Well
- **Harvest System**: Click-to-gather with visual feedback (tween animations, notifications)
- **Crafting System**: Timed minigame with quality tiers (ok/great/perfect)
- **Serving System**: Guest NPCs with preferred recipes, combo multipliers
- **Companion System**: Zundapal with click interaction, sparkle VFX
- **Progression**: XP curves, tool upgrades, daily quests

### ⚠️ Configuration Issues Found

#### 1. Recipe Definitions Fragmented
**Server (CraftConfig.lua):**
```lua
Bread = { Wheat = 3 }
Zunda Mochi = { ["Zunda Pea"] = 3, ["Zunda Berry"] = 2 }
```

**Client (CraftingScript.client.lua):**
```lua
Bread = { Wheat = 10 }
Zunda Mochi = { ["Zunda Pea"] = 5, Wheat = 8 }
```

**Impact**: Players may be confused when ingredient counts don't match.

#### 2. Missing Guest Configuration
GuestManager references `CONFIG.guest_preferences` and `CONFIG.guest_settings` but ProgressionConfig only has XP/pay values.

#### 3. Duplicate Quest Systems
- QuestConfig.lua (data-driven, in ReplicatedStorage)
- QuestManager.server.lua (hardcoded quests with unlock hints)
- No clear integration between them

---

## Progression Curve Analysis

| Level | XP Required | Cumulative |
| ----- | ----------- | ---------- |
| 1→2   | 100         | 100        |
| 2→3   | 283         | 383        |
| 3→4   | 520         | 903        |
| 4→5   | 800         | 1703       |
| 5→6   | 1067        | 2770       |

**Issue**: Level 5 unlock (Cupcake) requires ~1700 XP. Serving 100 guests at 15 XP each = 1500 XP. This creates a grind wall.

**Recommendation**: Add earlier unlocks, or reduce XP requirements for levels 1-10.

---

## Verification Checklist (For Parallel Work)

- [ ] CraftConfig recipes match CraftingScript.client.lua
- [ ] ProgressionConfig has guest_settings table
- [ ] All harvest nodes have Available attribute initialized
- [ ] Mineable nodes properly tagged with "Mineable"
- [ ] Planter nodes have proper ClickDetectors
- [ ] RemoteEvents and RemoteFunctions documented in remotes.md
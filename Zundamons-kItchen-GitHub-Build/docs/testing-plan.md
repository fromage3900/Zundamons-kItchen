# Testing Plan

## Harvest Loop
| Test | Steps | Expected | Validation |
|------|-------|----------|------------|
| Gather Wheat | Approach wheat node, click | Wheat added to inventory, sparkle effect | `HarvestValidator` distance + rate check |
| Gather Flower | Approach ZundaFlower | Flower in inventory, spin animation | Variant weights respected |
| Too Far | Click from 20+ studs | Harvest blocked | `validateDistance` returns false |
| Too Fast | Click repeatedly < 0.2s | Rate limited | `validateRateLimit` returns false |
| Depleted Node | Click after health = 0 | Node unavailable | `validateNode` checks Available/Seeded |
| Respawn | Wait Respawn time | Node reappears | `Mined` attribute reset |

## Cooking Loop
| Test | Steps | Expected | Validation |
|------|-------|----------|------------|
| Valid Recipe | Wheat (3) → Bread | Bread created, wheat consumed | CraftConfig recipe matched |
| Missing Ingredient | Try Bread with 0 wheat | Craft blocked | Ingredient count check |
| Perfect Cook | Hit timing window | Bonus XP, cook_victory anim | Timer within perfect window |
| Burn | Miss timing window | Item destroyed, cook_fail anim | Timer expired |
| Lazy Craft | Use `craft_start` remote directly | Rate limited | CraftManager rate limit |

## Serving Loop
| Test | Steps | Expected | Validation |
|------|-------|----------|------------|
| Serve Guest | Click NPC with food | Food consumed, XP/Gold rewarded | NPCConfig guestId matched |
| Wrong Food | Serve non-requested item | Reduced reward or rejected | Guest preference check |
| No Food | Click NPC empty-handed | Nothing happens | Inventory check |
| Multiple Guests | Serve 3 guests in sequence | Each rewarded independently | Per-guest cooldown |

## Quest System
| Test | Steps | Expected | Validation |
|------|-------|----------|------------|
| Daily Quest | Gather 10 items | Quest progress updates, rewards on completion | QuestConfig daily goal |
| Weekly Quest | Cook 5 recipes | Progress persists across sessions | Server-saved quest state |
| Quest UI | Open compendium | Quest panel shows active quests + progress | UIHelper fallback emoji |

## Exploit Prevention
| Test | Steps | Expected | Validation |
|------|-------|----------|------------|
| Speed Click | Auto-clicker at 20/s | Blocks after 5/s | Rate limit window |
| Teleport Harvest | Teleport to node from 1000 studs | Blocked | Distance check |
| Spam Remote | Fire `gatherEvent` directly | Rate limited server-side | HarvestValidator |
| Duplicate Event | Fire 2 events per tick | Only first processed | Server state machine |
| Death During Harvest | Die mid-harvest | Harvest cancelled | Character nil guard |

## Performance
| Test | Steps | Expected | Validation |
|------|-------|----------|------------|
| 50 Nodes Active | Load map with 50 harvestables | No Heartbeat spam | Validator processes sequentially |
| 10 Players | All harvest simultaneously | No server lag | Rate limit per player |
| Memory | Play 30 min session | No memory leak | Collectible cleanup |

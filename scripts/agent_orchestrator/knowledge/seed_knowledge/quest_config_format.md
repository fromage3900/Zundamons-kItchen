# QuestConfig.lua Format Reference

## Structure
```lua
-- [[ModuleScript] QuestConfig]
local QuestConfig = { quests = {}, default_quests = {} }

-- Quests in `quests` are available from the start.
-- Quests in `default_quests` are initialized on player join.
```

## Quest Entry Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | yes | Unique identifier like "quest_welcome_1" |
| name | string | yes | Display name |
| description | string | yes | Quest description text |
| icon | string | yes | Emoji icon |
| type | string | yes | One of the quest types below |
| target | number | yes | Goal count |
| target_item | string | no | Specific item for gather/cook types |
| target_zone | string | no | Zone name for visit_zone type |
| target_npc | string | no | NPC name for npc_chat type |
| target_companion | string | no | Companion name for set_companion type |
| rewards | table | yes | { gold = number, tier_points = number, items = {string} } |
| difficulty | number | yes | 1-5 scale |
| subtext | string | no | Flavor text paragraph |
| npc_dialogue | table | no | { speaker = "name", lines = {"line1", "line2"} } |
| chain_id | string | no | Groups quests into chains: "great_zunda_hunt" |
| chain_step | number | no | Step number within chain |
| quality | string | no | For cook_quality type: "great" or "perfect" |
| max_cook_time | number | no | For cook_speed type: max seconds |

## Quest Types (17 types)
| Type | Description | Fields Used |
|------|-------------|-------------|
| serve | Serve N guests | target |
| cook | Cook N of target_item | target, target_item |
| cook_perfect | N perfect cooks | target |
| cook_quality | N dishes with quality >= quality | target, quality |
| cook_speed | N dishes under max_cook_time sec | target, max_cook_time |
| cook_unique | Cook N unique recipes | target |
| cook_unique_zunda | Cook N unique Zunda recipes | target |
| cook_unique_seasonal | Cook N unique seasonal dishes | target |
| gather | Gather N of target_item | target, target_item |
| gather_unique | Gather N unique item types | target |
| earn_gold | Accumulate N gold | target |
| visit_zone | Visit a zone N times | target, target_zone |
| visit_zones_unique | Visit N unique zones | target |
| companion_chat | Chat with companion N times | target |
| npc_chat | Chat with specific NPC N times | target, target_npc |
| npc_chat_all | Chat with N different NPCs | target |
| set_companion | Set specific companion | target, target_companion |

## Chain Examples
- "great_zunda_hunt": 4 steps (Zunda Pea → Edamame → Pea Flower → All ingredients)
- "culinary_ascension": 5 steps (Bread → Apple Pie → Royal Stew → Ultimate Feast → 10 perfect streak)
- "seasons_of_flavor": 3 steps (Summer Salad → Winter Stew → All seasonal)
- "friend_of_all": 3 steps (Chat 10 → Elder 3x → All NPCs)
- "gold_rush": 3 steps (250g → 2500g → 10000g)

## Current Balance (from overnight audit)
- 19 recipes exist (overcraft config)
- 10 gatherable items (from GatherConfig)
- 68 quests defined
- 6 quest chains active
- 14 recipes have NO progression milestone (quest-only unlock)
- XP curve: 80 XP per level (1-5), scaling to 220+ (10+)

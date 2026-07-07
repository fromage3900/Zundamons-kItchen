# Architecture Overview

## Data Flow
1. **Server Authority**: All critical state (Gold, Inventory, Player Stats) is owned and validated by the server.
2. **PlayerDataService**: The single source of truth for player data on the server. Do NOT use `_G.data`.
3. **Remotes**: Managed in Studio but documented in `docs/remotes.md`. Server-side handlers must validate all payloads.

## Service Pattern
- Critical logic should reside in `ServerScriptService/Services`.
- Use `ModuleScripts` for reusable logic.
- Avoid monolithic scripts; prefer splitting into logical components (e.g., `VNController` and `VNDialogueData`).

## Configuration
- **Legacy configs**: `src/ReplicatedStorage/ConfigurationFiles/` — migrated one-by-one to Shared/Config
- **Shared configs**: `src/ReplicatedStorage/Shared/Config/` — Rojo-mapped to `game.ReplicatedStorage.Shared.Config`
  - `UIAssets.lua` — icons, sounds, particles, GUI textures, animations
  - `HarvestNodeVariants.lua` — harvest node mesh variants + effects
  - `NPCConfig.lua` — NPC + companion definitions (models, anims, effects)
- All configs are ModuleScripts, shared between Client and Server.
- Placeholder IDs (`FILL_*`) are guarded by `isPlaceholder()` — safe to deploy with emoji fallback.

## Validation
- Use dedicated validator scripts (e.g., `HarvestValidator.server.lua`) to check client requests against server-side logic.
- `HarvestValidator` is wired into `Mineable.server.lua` and `ZundaGatherServer.server.lua`.
- `CookValidator` validates rhythm-cooking quality server-side from client timing payloads.

## Modifier stacking (companion buffs + powerups + combo)

All buffs are defined in `CompanionConfig.lua` (companions) and `PowerupConfig.lua` (timed powerups). Application is inline at each touchpoint:

| Action | Formula |
|--------|---------|
| Gold on serve | `floor(base * combo * luckyCharm * (1 + ankomon))` where luckyCharm = 1.5x if active |
| XP on craft/serve | `floor(base * (1 + sakuradamon))` |
| Gather extra drop | Independent rolls: Antimon (+20% chance), IronWrist (+25% chance) |
| Cooking window | Cardamon (+30% perfect window), MastersApron (+25% window) — validated server-side via `CookValidator` |
| Combo cap | 5.0x max (RewardSystem) |

Canonical companion catalog: `CompanionConfig.lua`. Visual mesh data: `NPCConfig.lua` (no buff/price fields).

## Data Flow Diagram
```
Client Click → RemoteEvent → Server Handler
                                  ↓
                         HarvestValidator (distance, rate, cooldown)
                                  ↓
                         HarvestNodeVariants (get mesh/variant/scale)
                                  ↓
                         LootModule.generateLoot (spawn pickups)
                                  ↓
                         PlayerDataService (update gold/inventory)
                                  ↓
                         RemoteEvent → Client (play effects, update UI)
```

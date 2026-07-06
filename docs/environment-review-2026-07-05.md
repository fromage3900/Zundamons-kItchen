# 🛠 Project Lead Environment Review & Procedural Update Plan

> **Superseded for publish safety** by [`environment-audit.md`](environment-audit.md), [`atmosphere-gameplay-audit.md`](atmosphere-gameplay-audit.md), and [`legal-publish-checklist.md`](legal-publish-checklist.md). Kept for historical context (2026-07-05).

## 1. Architectural Integrity Audit
During the review on 2026-07-05, several architectural "leaks" were identified that deviate from the intended Rojo/Service-oriented design.

### Findings:
- **`MarketplaceService.ProcessReceipt` Conflict**: Both `CompanionShopServer.server.lua` and `RobuxStoreServer.server.lua` define this callback. Roblox only allows **one** callback per server. This leads to non-deterministic behavior where one system will fail to process purchases.
- **Config/Service Boundary Breach**: `RewardCore.lua` and `LootModule.lua` (located in `ConfigurationFiles/`) contain active server logic, including `OnServerInvoke` wiring, `PlayerAdded` connections, and background loops.
    - *Correction*: These modules should only contain data and stateless helper functions. Active listeners belong in `ServerScriptService`.
- **Global Pollution**: `RewardCore.lua` uses `_G.RewardCore`.
    - *Correction*: Use standard module requires via `ServerScriptService`.

## 2. Procedural Update Plan

### Phase A: Marketplace Consolidation
1. **Create `Services/MarketplaceService.lua`**: Move all product definitions and `ProcessReceipt` logic into a single centralized service.
2. **Refactor Consumers**: Update `CompanionShopServer` and `RobuxStoreServer` to use the new service for processing, or merge them into the new service structure.
3. **Verify**: Ensure all DevProduct IDs are mapped and tracked in one location.

### Phase B: Remote & Logic Migration
1. **Clean `ConfigurationFiles/`**:
    - Remove `OnServerInvoke` and `OnServerEvent` listeners from `RewardCore.lua` and `LootModule.lua`.
    - Move `task.spawn` loops and `PlayerAdded` logic to a new `ServerScriptService/Systems/RewardSystem.lua`.
2. **Standardize `RewardCore`**:
    - Ensure it is a pure library of functions.
    - Remove `_G` assignments.
3. **Bootstrap Logic**: Use a dedicated bootstrapper (like an improved `RewardBoot.server.lua`) to initialize all reward-related remotes and listeners.

### Phase C: Documentation & Guidelines
1. **Update `docs/rojo-workflow.md`**: Clarify that `ConfigurationFiles/` must remain side-effect free.
2. **Update `AI/ARCHITECTURE.md`**: Add the new `MarketplaceService` pattern as the standard for monetization.

## 3. Zundamon Design Review
A specific audit of the "Zunda" thematic elements was conducted to ensure mascot consistency and aesthetic cohesion.

### Findings:
- **Visual Consistency**: The `ZundaFrameAnim.client.lua` successfully implements the signature pink/lavender breathing effect, which should be the standard for all primary UI frames.
- **Narrative Tone**: The `VNDialogueData.lua` captures the "supportive guide" persona of Zundapal. However, Zundamon's dialogue is currently underrepresented.
- **Emoji Usage**: The system uses a consistent set of emojis (`🍙`, `🍡`, `✨`) which effectively communicates game state without heavy text.
- **Action Items**:
    - [ ] Create Zundamon-specific dialogue trees for the "Kitchen Master" role.
    - [ ] Standardize particle effects for gathering to match the lavender accent color.

## 4. Environment Stability Check
- [x] Cross-platform build scripts (Windows/Linux)
- [x] Linting coverage (Selene/StyLua) for all `src/`
- [x] Payload validation on critical remotes (`AdvancedRewards`)
- [x] **NEW**: AI Guidance system established in `AI/`
- [ ] **NEXT**: Fix `MarketplaceService` conflict.

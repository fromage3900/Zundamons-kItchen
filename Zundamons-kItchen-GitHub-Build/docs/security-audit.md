# Security Audit — Applied Fixes

Audit date: 2026-07-05  
Scope: Priority systems from [`code-review.md`](code-review.md)

## Summary

| System | Risk before | Fix status |
|--------|-------------|------------|
| `ServingSystem` | Client-supplied guest instance | Fixed |
| `InventoryServer` | Client-supplied Tool references | Fixed |
| `ToolManager` | Unvalidated tool name strings | Fixed |
| `LootModule` | Open sell keys, broken RemoveCode, duplicate RequestData | Fixed |
| `RequestData` | Dual handlers (LootModule vs RequestDataHandler) | Fixed |

---

## ServingSystem.server.lua

**Risks:**
- Client could pass any Instance as `guestInstance`
- `payAmount` taken only from guest attributes

**Fixes:**
- Validate guest is under `workspace.Guests`
- Validate player within 20 studs of guest
- Type-check `foodItemName`
- Use `PlayerDataService` + `GuestService` (no `_G`)

---

## InventoryServer.server.lua

**Risks:**
- Client could pass Tool instances not owned by player

**Fixes:**
- `playerOwnsTool()` checks Backpack, Character, Inventory folder, Hotbar slots
- All four remote handlers gate on ownership + `playerIsAlive()`

---

## ToolManager.server.lua

**Risks:**
- Arbitrary string could be passed as `toolName`

**Fixes:**
- Whitelist against `ToolsConfig.tools`
- `typeof(toolName) == "string"` guard
- Uses `PlayerDataService.getOrCreate`

---

## LootModule.lua

**Risks:**
- `_G.data = {}` wiped player data on module load
- Duplicate `RequestData.OnServerInvoke` conflicted with `RequestDataHandler`
- `sellLoot` accepted any string key
- `RemoveCode` wired wrong function signature

**Fixes:**
- Removed `_G.data` and `requestData` handler entirely
- `sellLoot` validates key in `priceLists`
- Rate limit: 5 sells/second per player
- `RemoveCode` handler: `(player, genCode, name, isRemoving)`
- Uses `PlayerDataService`

---

## PlayerDataService (architecture)

**Risks:**
- Global `_G.data` mutable from any script

**Fixes:**
- Central module at `ServerScriptService/Services/PlayerDataService.lua`
- DataStore load/save on join/leave
- All server consumers migrated off `_G.data`

---

## Remaining recommendations

- Document new remotes in [`remotes.md`](remotes.md) before shipping
- Audit `AdvancedRewards` RemoteFunctions for payload validation (future PR)
- Move `RewardCore` remote wiring to `ServerScriptService/` (future refactor)

## July 2026 hardening (publish prep)

| Area | Fix |
|------|-----|
| `RemoteRateLimiter` | Shared cooldowns on craft, serve, plant, decoration remotes |
| `Planters.server.lua` | Migrated off `_G.data` to `PlayerDataService` |
| Git secret scan | `scripts/check-secrets.mjs` in CI + `npm run security` |
| Git hygiene | `scripts/check-git-hygiene.mjs` blocks place exports + `_G.data[` |
| Publish readiness | `scripts/check-publish-readiness.mjs` — TEST grants, placeholder product IDs |
| LLM keys | Studio-only `ServerStorage.ZundapalLLMSecrets` (documented in `git-security.md`) |
| LLM safety | Daily cap, disclaimer gate, HTTP timeout, no raw body in logs |
| `ZundapalChatSend` | `RemoteRateLimiter` + disclaimer / daily_limit error paths |
| `PromptRobuxPurchase` | Product ID whitelist against `PRODUCTS` table |
| Companion test grant | Studio-only (`RunService:IsStudio()`) |

## Publish blockers matrix

| Blocker | Status | Doc |
|---------|--------|-----|
| AI disclosure modal | Implemented | [`legal-publish-checklist.md`](legal-publish-checklist.md) |
| Privacy policy | [`PRIVACY.md`](../PRIVACY.md) | Repo + experience description |
| Placeholder DevProduct IDs | Warn in CI; fail with `STRICT_PUBLISH=1` | [`publish-tonight.md`](publish-tonight.md) |
| Git history secret scan | Manual / optional gitleaks | [`git-security.md`](git-security.md) |
| Roblox maturity questionnaire | Manual Creator Hub | [`legal-publish-checklist.md`](legal-publish-checklist.md) |

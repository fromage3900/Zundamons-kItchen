# Agent Work Review — Cline, OpenCode, Cursor (July 2026)

Merged audit of who built what and current tree status.

**Workspace:** `G:\Zundamons-kItchen` · [`WORKSPACE.md`](WORKSPACE.md)  
**Last updated:** 2026-07-07 (systematic fix pass)

---

## Summary table

| Area | Cline | OpenCode | Cursor | On `main` now? |
|------|-------|----------|--------|----------------|
| Harvest security | Validator wired | — | Gather server | Yes |
| Planters perf | 1Hz loop | — | PlayerDataService | Yes |
| Craft / progression | CraftConfig, ChefLevel | — | Quest wiring, CookValidator | Yes |
| Guest patience UI | GuestManager | — | — | Yes |
| Scatter / PCG | — | ScatterConfig, ScatterService | — | Yes |
| UI polish layer | — | UIHelper, UIConfig, VN skin | Rojo bootstrap HUD/Craft/VN | Partial |
| Asset pipeline | — | UIAssets, HarvestNodeVariants | Asset checklist docs | Placeholders |
| Marketplace | — | — | MarketplaceService, config | Yes |
| LLM / AI chat | Server patterns | Chat UI polish pending | Full stack restored | Yes (code) |
| Modifier system | — | — | CompanionConfig canonical, CookValidator | Yes |
| Reward system | — | — | RewardSystem service | Yes |
| Publish safety | — | — | Disclaimer, legal docs, verify:safety | Yes |
| Repo layout | — | — | Flat `G:\` root, rojo port fix | Yes |
| Studio MCP | — | Deleted 4 legacy ScreenGuis | — | Studio-only |

---

## Cline — server & systems

| System | Path | Status |
|--------|------|--------|
| HarvestValidator | `Validation/HarvestValidator.server.lua` | Active |
| Mineable | `Mineable.server.lua` | Validator wired |
| CraftConfig | `Shared/Modules/CraftConfig.lua` | Canonical (ConfigurationFiles re-exports) |
| RewardSystem | `Services/RewardSystem.lua` | Extracted from RewardCore |
| MarketplaceService | `Services/MarketplaceService.lua` | Single ProcessReceipt owner |

---

## OpenCode — client UI & assets

| System | Path | Status |
|--------|------|--------|
| UIHelper | `Shared/Modules/UIHelper.lua` | Active |
| VN reskin | `VNController.client.lua` | Code-built `ZundaVNGui` via ClientGuiBootstrap |
| ScatterService | `Services/ScatterService.server.lua` | Active |
| UIAssets | `Shared/Config/UIAssets.lua` | Placeholders remain |

### Pending

- O1: QuestScript → UIComponents
- O2: Asset upload pass (network blocked)

---

## Cursor — integration, publish safety, repo

| System | Status |
|--------|--------|
| LLM stack | Restored — `ZundapalLLMService`, chat server/client |
| VN bootstrap | Code-built `ZundaVNGui` in VNController |
| Companion catalog | Single source: `CompanionConfig.lua` |
| Cooking validation | `CookValidator` + `GetCookingWindowBoost` remote |
| HUD/Craft bootstrap | `HudScript`, `CraftingScript` use ClientGuiBootstrap |
| verify:safety CI | Active |

### Deferred

- `MasterChefZundaServer` + client (branch `cursor/master-chef-zunda-594f`)

---

## Conflict hotspots (do not let agents collide)

| File | Owners |
|------|--------|
| `VNController.client.lua` | Cursor (bootstrap) vs OpenCode (AC skin) |
| `CraftConfig` / `CraftingScript` | Cline vs Cursor (now aligned on Shared/Modules) |
| `default.project.json` | Cursor only |
| `MarketplaceConfig.lua` | Cline receipt + Cursor catalog |

---

## Next agent actions

1. **Human/Studio:** Phase 0 playtest — legacy GUI delete, companion mesh upload
2. **OpenCode:** Quest UI with UIComponents
3. **Cline:** Mesh import when network unblocks (`verify:meshes`)
4. **Cursor:** MasterChefZunda restore (optional)

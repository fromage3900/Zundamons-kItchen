# Agent Work Review — Cline, OpenCode, Cursor (July 2026)

Merged audit of who built what, what survived the `de6316d` merge, and what to restore.

**Workspace:** `G:\Zundamons-kItchen` · [`WORKSPACE.md`](WORKSPACE.md)

---

## Summary table

| Area | Cline | OpenCode | Cursor | On `main` now? |
|------|-------|----------|--------|----------------|
| Harvest security | ✅ Validator wired | — | ✅ Gather server | ✅ Yes |
| Planters perf | ✅ 1Hz loop | — | ✅ PlayerDataService | ✅ Yes |
| Craft / progression | ✅ CraftConfig, ChefLevel, ProgressionConfig | — | Quest wiring | ✅ Yes |
| Guest patience UI | ✅ GuestManager | — | — | ✅ Yes |
| Scatter / PCG | — | ✅ ScatterConfig, ScatterService | — | ✅ Yes |
| UI polish layer | — | ✅ UIHelper, UIConfig, AC-style VN | Legacy cleanup | ⚠️ Partial |
| Asset pipeline | — | ✅ UIAssets, HarvestNodeVariants, Blender JSONs | Asset checklist docs | ⚠️ Placeholders |
| Marketplace | — | — | ✅ MarketplaceService, config | ✅ Yes |
| LLM / AI chat | ✅ Briefing + server patterns | ⬜ Chat UI polish (pending) | ✅ Full stack (pre-merge) | ❌ **Lost in merge** |
| Publish safety | — | — | ✅ Disclaimer, legal docs | ⚠️ Disclaimer only |
| Repo layout | — | — | ✅ Flat `G:\` root, rojo port fix | ✅ Yes |
| Studio MCP | — | ✅ Deleted 4 legacy ScreenGuis | — | Studio-only |

---

## Cline — server & systems

**Commits / themes:** `ec9a97c`, `53763fa`, security fixes, `PROJECT-STATUS` updates.

### Delivered (still in tree)

| System | Path | Value |
|--------|------|-------|
| HarvestValidator | `Validation/HarvestValidator.server.lua` | Distance, rate limit, cooldown |
| Planters | `Planters.server.lua` | 1Hz growth, PlayerDataService |
| Mineable | `Mineable.server.lua` | Nil guards (validator wiring still pending per NEXT-TASKS) |
| CraftConfig | `Shared/Modules/CraftConfig.lua` | 12 recipes, unlock helper |
| ProgressionConfig | `ConfigurationFiles/ProgressionConfig.lua` | Guest prefs, milestones |
| ChefLevelConfig | `ConfigurationFiles/ChefLevelConfig.lua` | Gentler XP curve |
| GuestManager | `GuestManager.server.lua` | Patience bar, color transitions |
| MarketplaceService | `Services/MarketplaceService.lua` | Single ProcessReceipt owner |

### Documented but verify

- Recipe counts: server `CraftConfig` vs client `CraftingScript` may still diverge ([`GAMEPLAY-REVIEW.md`](GAMEPLAY-REVIEW.md)).
- `RewardCore.lua` still in ConfigurationFiles with side effects — consolidation planned in [`CONSOLIDATION_PLAN.md`](CONSOLIDATION_PLAN.md).

---

## OpenCode / DeepSeek — client UI & assets

**Config:** [`opencode.json`](../opencode.json) — Roblox Studio MCP + Blender MCP.

### Delivered (still in tree)

| System | Path | Value |
|--------|------|-------|
| UIHelper | `Shared/Modules/UIHelper.lua` | Shared panel/button styling |
| UIConfig | `ConfigurationFiles/UIConfig.lua` | Tokens |
| UIComponents | `ConfigurationFiles/UIComponents.lua` | Reusable widgets |
| VN reskin | `VNController.client.lua` | Animal Crossing palette, uses `script.Parent` |
| ScatterConfig | `ConfigurationFiles/ScatterConfig.lua` | Seasonal biomes, cozy flags |
| ScatterService | `Services/ScatterService.server.lua` | Procedural scatter |
| UIAssets | `Shared/Config/UIAssets.lua` | Icon/sound catalog + `isPlaceholder()` |
| HarvestNodeVariants | `Shared/Config/HarvestNodeVariants.lua` | Mesh variant keys |
| Blender pipeline | `Assets/Generated/**/*.json` | Procedural mesh specs |
| DevConsole | `DevConsole.client.lua` | Placeholder asset reporter |

### Studio session (SESSION-NOTES 2026-07-06)

- Deleted via MCP: `DataGUI`, `SellLoot`, `PlanterGui`, Custom Inventory
- Set `IgnoreGuiInset` on 18 ScreenGuis
- **Blocked:** `upload_decal` (firewall), 58 `FILL_*` slots remain

### Pending (WORK_QUEUE historical)

- O2: QuestScript → UIComponents
- L3: LLM chat UX polish (blocked until LLM stack restored)

---

## Cursor — integration, publish safety, repo

### Delivered (still in tree)

| System | Notes |
|--------|-------|
| Legacy UI cleanup | `000_LegacyOverlayCleanup`, `LegacyGuiConfig` |
| Rojo UI bootstrap | `ClientGuiBootstrap`, `*Gui` names |
| Disclaimer gate | `DisclaimerGate`, `LlmDisclaimerServer` |
| Legal / privacy | `PRIVACY.md`, `legal-publish-checklist.md` |
| Flat repo | No nested `Zundamons-kItchen-GitHub-Build/` |
| Rojo serve | Port 34872 cleanup + 34873 fallback |
| Docs | `WORKSPACE.md`, Windows setup, smoke tests |

### Lost in `de6316d` merge (restore in Phase 1)

| System | Was on Cursor branches |
|--------|------------------------|
| `ZundapalLLMService.lua` | `cursor/zundapal-llm-594f` |
| `ZundapalChatServer` + client | same |
| `MasterChefZundaServer` + client | `cursor/master-chef-zunda-594f` |
| VN code-built `ZundaVNGui` | `e5416a8` VNController |
| `verify:safety` full CI scripts | partial scripts remain |

**Recommendation:** Cherry-pick LLM + VN bootstrap from `e5416a8` / `f0a5a9b` onto `main` in a dedicated `cursor/restore-llm-vn-594f` branch.

---

## Conflict hotspots (do not let agents collide)

| File | Owners |
|------|--------|
| `VNController.client.lua` | Cursor (bootstrap) vs OpenCode (AC skin) |
| `QuestConfig.lua` | Cursor (manager wiring) vs duplicate RS root file |
| `CraftConfig` / `CraftingScript` | Cline vs OpenCode |
| `default.project.json` | Cursor only |
| `MarketplaceConfig.lua` | Cline receipt + Cursor catalog |

---

## Next agent actions

1. **Cline:** Mineable validator wire (5 lines), `RewardCore` service extraction
2. **OpenCode:** Quest UI with UIComponents after VN/HUD stable
3. **Cursor:** Restore LLM stack + VN `ZundaVNGui`; track [`PUBLISH-PLAN.md`](PUBLISH-PLAN.md) Phase 1

🫛

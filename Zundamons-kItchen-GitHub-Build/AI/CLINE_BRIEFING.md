# Cline Briefing — July 2026

**Read this every session** in addition to [`PROMPTS/cline.md`](PROMPTS/cline.md), [`WORK_QUEUE.md`](WORK_QUEUE.md), and [`AGENT_COORDINATION.md`](AGENT_COORDINATION.md).

`main` @ place `108617605497926` includes Zundapal LLM, Master Chef Zunda NPC, companion quest stats, publish hardening, and gather consolidation (in progress).

---

## LLM system (live on main)

| Component | Path | Role |
|-----------|------|------|
| `ZundapalLLMService` | `Services/ZundapalLLMService.lua` | Server HTTP proxy; personas `zundapal`, `master_chef` |
| `ZundapalLLMConfig` | `ConfigurationFiles/ZundapalLLMConfig.lua` | Provider, prompts, cooldown, token limits |
| `ZundapalContextBuilder` | `ConfigurationFiles/ZundapalContextBuilder.lua` | Injects tier, quests, gold, companion buff into system prompt |
| `ZundapalChatServer` | `ZundapalChatServer.server.lua` | `ZundapalChatSend` → LLM → `ZundapalChatReply` |
| `MasterChefZundaServer` | `MasterChefZundaServer.server.lua` | NPC click + `MasterChefChatSend` → same LLM service |
| `ZundapalHintsServer` | `ZundapalHintsServer.server.lua` | Proactive toasts on `RewardCore.NotifyAction` |

### Studio secrets (not in git)

- `ServerStorage.ZundapalLLMSecrets.ApiKey` (StringValue)
- HttpService enabled + whitelist `api.deepseek.com`

### LLM remotes

| Remote | Direction | Persona |
|--------|-----------|---------|
| `ZundapalChatSend/Reply/Error/Status` | C↔S | `zundapal` (companion free chat) |
| `MasterChefChatSend/Reply/Error/Status` | C↔S | `master_chef` (kitchen mentor) |
| `OpenCompanionVN` | S→C | Scripted companion tree |
| `OpenMasterChefVN` | S→C | Tier-based mentor tree |

### Recent LLM fixes (merged)

- History commits only after successful API response (no orphan user turns)
- Assistant output filtered via `TextService`
- Cooldown per `userId:persona` (Zundapal vs Master Chef independent)
- `MasterChefChatSend` uses `RemoteRateLimiter`

---

## Zunda NPCs & companions

### Companion (follow pet + Zundapal)

| Piece | Notes |
|-------|-------|
| `CompanionConfig.lua` | Canonical catalog: mesh, buffs, sparkles, `llmPersona`, `npcSpeakers` |
| `CompanionManager.server.lua` | Spawns mesh, click → `OpenCompanionVN`, `companion_chats` +1 |
| `CompanionStats.lua` | `recordCompanionChat`, `recordNpcChat` |
| `CompanionInteractionServer` | `RecordNpcChat` remote; whitelist + **5s cooldown per speaker** |

### Master Chef Zunda (kitchen mentor NPC)

| Piece | Notes |
|-------|-------|
| `MasterChefZundaConfig.lua` | Tier greetings, recipe tips, tag `MasterChefZunda` |
| Studio setup | CollectionService tag `MasterChefZunda` + `ClickDetector` on kitchen NPC |
| VN | `buildMasterChefTree()` in `VNController` — tier from `RequestData` |
| LLM | Choice "Ask freely (mentor chat)" → `master_chef` persona |
| Quest stat | `npc_chats` +1 on successful Master Chef LLM reply (server); scripted VN lines use `RecordNpcChat` |

### Zone lore NPCs (scripted VN only, no LLM)

Speakers in `CompanionConfig.npcSpeakers`: `elder`, `ruins`, `chef`, `master_chef`.

`VNController.showLine` fires `RecordNpcChat` for whitelisted speakers → `npc_chats` quest progress.

---

## Quest stat hooks (C2 — done)

| Quest type | Counter | When |
|------------|---------|------|
| `companion_chat` | `stats.companion_chats` | Companion click; successful Zundapal LLM reply |
| `npc_chat` | `stats.npc_chats` | VN line (`RecordNpcChat`); successful Master Chef LLM reply |

**Do not** re-implement these in C3 marketplace work — use `CompanionStats` if purchase flows need stat bumps.

---

## Your pending task: C3 MarketplaceService

- Proposal: [`AI/MarketplaceService_Proposed.lua`](MarketplaceService_Proposed.lua)
- Goal: single `ProcessReceipt` owner, one product catalog aligned with `CompanionConfig`
- Current debt: `RobuxStoreServer.PRODUCTS`, `CompanionShopServer.DEVPRODUCT_IDS`, `StoreScript` — three catalogs with placeholder IDs
- `CompanionShopServer` already delegates receipts to `RobuxStoreServer` — consolidate catalogs, not duplicate handlers

---

## Gather system split (Cursor consolidating — do not merge paths)

| Path | Config | Scripts | Interaction |
|------|--------|---------|-------------|
| **Click flora** | `GatherConfig.lua` | `ZundaGatherServer`, `HarvestController` (client polish) | `ResourceType` + ClickDetector |
| **Tool mining** | `MineableConfig.lua` | `Tools.server`, `Mineable.server`, `ToolManager` | Mineable tag + Axe/PickAxe/Sickle swing |
| **Planting** | `PlantConfig` | `Planters`, `PlantingMenu` | Planter tag, seeds |

Flora (`Zunda Mushroom`, berries, roots) were **removed from MineableConfig** — click-only via `GatherConfig`. Rocks/trees/wheat fields remain tool-mineable.

---

## Server rules (unchanged)

- No `_G.data` — `PlayerDataService` only (`npm run security` enforces)
- Active listeners in `ServerScriptService`, not `ConfigurationFiles/`
- Rate-limit new remotes via `RemoteRateLimiter`
- Branch: `cline/<task>` — never push directly to `main`

---

## Verification

```bash
cd Zundamons-kItchen-GitHub-Build
npm run validate
npm run lint
```

See also: [`docs/companion-integration-audit.md`](../docs/companion-integration-audit.md), [`docs/remotes.md`](../docs/remotes.md), [`docs/publish-tonight.md`](../docs/publish-tonight.md).

# Work Queue — Zundamon's kItchen

Live task board for Cursor, DeepSeek OpenCode, and Cline. **Claim before coding.**

| ID | Task | Owner | Status | Branch | Files |
|---|---|---|---|---|---|
| Q1 | Wire QuestManager to QuestConfig + QuestProgress | Cursor | done | cursor/quest-vn-review-594f | QuestManager, QuestConfig, QuestProgress, PlayerDataService |
| Q2 | Fix VNDialogueData LocalPlayer race | Cursor | done | cursor/quest-vn-review-594f | VNDialogueData, VNController |
| Q3 | Refresh project-review.md | Cursor | done | cursor/quest-vn-review-594f | docs/project-review.md |
| C1 | Migrate Planters off _G.data to PlayerDataService | Cursor | done | cursor/publish-blockers-594f | Planters.server.lua, PlantingMenu.client |
| O1 | Decoration shop client UI | Cursor | done | cursor/publish-blockers-594f | DecorationShop.client.lua, DecorationPlacer |
| C2 | Add companion_chat / npc_chat stat hooks | Cursor | done | cursor/zundapal-llm-594f | CompanionConfig, CompanionStats, CompanionInteractionServer, VNController, ZundapalChatServer |
| C3 | Implement MarketplaceService from proposal | Cline | pending | cline/marketplace-service | Services/MarketplaceService.lua, RobuxStoreServer, CompanionShopServer |
| L1 | Zundapal LLM free chat Phase 1 | Cursor | done | cursor/zundapal-llm-594f | ZundapalLLMConfig, ZundapalLLMService, ZundapalChatServer, VNController, ZundapalChat.client |
| L2 | LLM player context injection | Cursor | done | cursor/zundapal-llm-594f | ZundapalContextBuilder, ZundapalLLMService, ZundapalHintsServer |
| L4 | Companion system + LLM integration | Cursor | done | cursor/zundapal-llm-594f | CompanionConfig, CompanionStats, RecordNpcChat, sparkle VFX, audit doc |
| P2 | Git security + remote rate limits for publish | Cursor | done | cursor/publish-blockers-594f | check-secrets.mjs, RemoteRateLimiter, git-security.md |
| O2 | Migrate QuestScript to UIComponents | OpenCode | pending | opencode/quest-ui-components | QuestScript.client.lua, UIComponents.lua |
| O3 | Document skybox upload steps for SkyConfig | Cursor | done | cursor/publish-blockers-594f | docs/skybox-upload-guide.md |
| L3 | LLM chat UX polish (history, streaming) | OpenCode | pending | opencode/zundapal-chat-ui | VNController, ZundapalChat.client |
| L5 | Master Chef Zunda NPC + LLM mentor persona | Cursor | done | cursor/master-chef-zunda-594f | MasterChefZundaConfig, MasterChefZundaServer, VNController |
| P3 | Git hooks + remote manifest sync check | Cursor | done | cursor/master-chef-zunda-594f | check-remote-sync.mjs, hooks:install |
| G1 | Consolidate click-gather vs tool-mine overlap | Cursor | done | cursor/gather-consolidation-594f | GatherConfig, ZundaGatherServer, MineableConfig |
| P4 | Publish safety plan (atmosphere, LLM disclaimer, legal docs) | Cursor | done | cursor/publish-safety-594f | DisclaimerGate, check-publish-readiness, PRIVACY.md, legal-publish-checklist |
| P5 | Studio smoke playtest + delete StarterGui.ZundaFX | Human | done | main | docs/studio-playtest-smoke.md |
| P6 | Real DevProduct IDs + STRICT_PUBLISH CI | Cline | pending | cline/marketplace-service | MarketplaceService, RobuxStoreServer, CompanionShopServer |
| P7 | Client UI Rojo bootstrap (CompanionShop, Pouch, Quest) | OpenCode | pending | opencode/ui-bootstrap | CompanionShopScript, PouchScript, QuestScript |

## Status values

- `pending` — unclaimed
- `in_progress` — agent actively working
- `review` — pushed, awaiting Cursor verification
- `done` — merged to main
- `blocked` — waiting on dependency (note reason in task)

## How to claim

1. Pick a `pending` task in your territory (see [`AGENT_COORDINATION.md`](AGENT_COORDINATION.md))
2. Update this table: Owner, Status, Branch
3. Commit and push the claim
4. Implement on your branch
5. Set Status to `review` when ready for Cursor

## Cursor review checklist

- [ ] `npm run validate` passes
- [ ] `npm run lint` passes
- [ ] No binary place files
- [ ] No new `_G.data` usage
- [ ] Server validates all new remotes
- [ ] WORK_QUEUE updated to `done`

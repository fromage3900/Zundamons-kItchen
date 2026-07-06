# Work Queue — Zundamon's kItchen

Live task board for Cursor, DeepSeek OpenCode, and Cline. **Claim before coding.**

| ID | Task | Owner | Status | Branch | Files |
|---|---|---|---|---|---|
| Q1 | Wire QuestManager to QuestConfig + QuestProgress | Cursor | done | cursor/quest-vn-review-594f | QuestManager, QuestConfig, QuestProgress, PlayerDataService |
| Q2 | Fix VNDialogueData LocalPlayer race | Cursor | done | cursor/quest-vn-review-594f | VNDialogueData, VNController |
| Q3 | Refresh project-review.md | Cursor | done | cursor/quest-vn-review-594f | docs/project-review.md |
| O1 | Decoration shop client UI | OpenCode | pending | opencode/decoration-shop-ui | new DecorationShop.client.lua, DecorationPlacer remotes |
| O2 | Migrate QuestScript to UIComponents | OpenCode | pending | opencode/quest-ui-components | QuestScript.client.lua, UIComponents.lua |
| O3 | Document skybox upload steps for SkyConfig | OpenCode | pending | opencode/skybox-docs | docs/atmosphere-polish-plan.md or new guide |
| C1 | Migrate Planters off _G.data to PlayerDataService | Cline | pending | cline/planters-playerdata | Planters.server.lua, PlayerDataService |
| C2 | Add companion_chat / npc_chat stat hooks | Cline | pending | cline/quest-stat-hooks | VNController or server remote, PlayerDataService.stats |
| C3 | Implement MarketplaceService from proposal | Cline | pending | cline/marketplace-service | Services/MarketplaceService.lua, RobuxStoreServer, CompanionShopServer |

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

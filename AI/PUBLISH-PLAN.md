# 🫛 Publish Plan — Zundamon's kItchen (July 2026)

**Place:** `108617605497926` · **Repo:** `G:\Zundamons-kItchen` · **Sync:** `main-2026-07-06-org-review`

Master knock-off list. See also [`docs/PROJECT-REVIEW-2026-07-06.md`](../docs/PROJECT-REVIEW-2026-07-06.md) and [`AGENT-WORK-REVIEW.md`](AGENT-WORK-REVIEW.md).

---

## Phase 🫛0 — Tonight (friends playtest)

| # | Task | Owner | Status |
|---|------|-------|--------|
| 0.1 | `git pull` + `npm run rojo:serve` (port **34873** if Cursor holds 34872) | Human | ⬜ |
| 0.2 | Studio: delete legacy StarterGui shells ([`studio-legacy-ui-deletion.md`](../docs/studio-legacy-ui-deletion.md)) | Human | ⬜ |
| 0.3 | Save place to Roblox | Human | ⬜ |
| 0.4 | Smoke: gather → craft → serve ([`studio-playtest-smoke.md`](../docs/studio-playtest-smoke.md)) | Human | ⬜ |
| 0.5 | Fix companion mesh (`NPCConfig` / place mesh, not `FILL_COMPANION_ZUNDAPAL`) | Studio | ⬜ |
| 0.6 | VN intro: ensure `ZundaVN` ScreenGui in StarterGui **or** restore code-built `ZundaVNGui` | Cursor | ⬜ |

**Pass criteria:** No grey fullscreen, pouch/quest open, gold updates on serve, Output shows `[ROJO SYNC OK]`.

---

## Phase 🫛1 — Code consolidation (this week)

| # | Task | Files | Status |
|---|------|-------|--------|
| 1.1 | Remove duplicate `ReplicatedStorage/QuestConfig` (use `ConfigurationFiles` only) | `default.project.json` | ✅ this PR |
| 1.2 | Restore LLM stack lost in `de6316d` merge | `ZundapalLLMService`, chat servers, clients | ⬜ |
| 1.3 | VN self-bootstrap (`ZundaVNGui` in code, not `script.Parent`) | `VNController.client.lua` | ⬜ |
| 1.4 | Migrate remaining `script.Parent` HUD scripts to `ClientGuiBootstrap` | `HudScript`, `CraftingScript`, … | ⬜ |
| 1.5 | Unify gold field (`gold` only, migrate `current_gold` / `Gold`) | `PlayerDataService`, clients | ⬜ |
| 1.6 | Align `CraftConfig` server ↔ `CraftingScript` client recipes | `Shared/Modules/CraftConfig.lua` | ⬜ |
| 1.7 | Wire `npm run verify:safety` + `security` in CI | `package.json`, `.github/workflows` | ✅ this PR |

---

## Phase 🫛2 — Studio assets (place-only)

| # | Task | Count | Doc |
|---|------|-------|-----|
| 2.1 | Replace `FILL_*` UI icons | 16 | [`asset-checklist.md`](../docs/asset-checklist.md) |
| 2.2 | Harvest node meshes | 18 | `HarvestNodeVariants.lua` + `Assets/Generated/` |
| 2.3 | NPC + companion models | 8+ | `NPCConfig.lua` |
| 2.4 | Skybox six faces | 6 | `SkyConfig.lua` |
| 2.5 | Decoration models in ServerStorage | 11 | `DecorationConfig` |
| 2.6 | Kenney decal upload (blocked on network) | 167 | `AI/NEXT-TASKS.md` |

---

## Phase 🫛3 — Public launch blockers

| # | Task | Notes |
|---|------|-------|
| 3.1 | Real DevProduct IDs in `MarketplaceConfig.lua` | No `11111111…` |
| 3.2 | `STRICT_PUBLISH=1 npm run security` | After real IDs |
| 3.3 | Creator Hub generative-AI questionnaire | [`legal-publish-checklist.md`](../docs/legal-publish-checklist.md) |
| 3.4 | Experience description + `PRIVACY.md` link | Template in legal doc |
| 3.5 | LLM: API key + HttpService + whitelist **or** ship without AI | Restore stack first |
| 3.6 | DataStore enabled for published place | Not just Studio API |

---

## Phase 🫛4 — Agent territory (parallel)

| Agent | Next tasks | Branch prefix |
|-------|------------|---------------|
| **Cursor** | VN bootstrap, LLM restore, merge review | `cursor/*-594f` |
| **Cline** | `RewardCore` → service, Mineable validator, economy | `cline/*` |
| **OpenCode** | `UIComponents` adoption, quest UI polish | `opencode/*` |

Claim tasks in [`WORK_QUEUE.md`](WORK_QUEUE.md) before coding.

---

## Verification commands

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run validate
npm run verify:safety
npm run lint
npm run rojo:serve
```

🫛 *Pea priority: Phase 0 before Phase 3. Friends playtest does not need real DevProducts or full asset pass.*

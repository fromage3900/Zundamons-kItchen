# Project Status — Zundamon's Kitchen

**Updated:** 2026-07-07 (systematic fix pass)  
**Workspace:** `G:\Zundamons-kItchen`  
**Sync:** `main-2026-07-07-systematic-fix`

---

## Overall

| Milestone | Status |
|-----------|--------|
| Repo structure (flat Rojo) | Done |
| Core gameplay (harvest, craft, quests) | On main |
| UI framework (OpenCode + Rojo bootstrap) | Partial — HUD/Craft/VN code-built; Studio cleanup pending |
| Companions | Placeholder mesh (`FILL_COMPANION_ZUNDAPAL`) |
| LLM / Zundapal chat | Restored in code — needs Studio API key |
| Modifier/catalog consolidation | Done (CompanionConfig canonical, CookValidator, RewardSystem) |
| Public publish | Blocked — assets + legal + DevProducts |

**Not ready for public publishing** until Phase 2–3 items in `AI/PUBLISH-PLAN.md` are cleared.

---

## What works

- Rojo sync from `G:\Zundamons-kItchen`
- `npm run rojo:serve` with port fallback
- Harvest validation (Gather + Mineable), crafting with server-validated quality
- Single companion catalog (`CompanionConfig`), `RewardSystem` service
- Scatter, marketplace hooks, guest manager
- LLM stack files present; see `docs/llm-production-setup.md`

---

## Known issues (playtest)

1. **Companion mesh** — `FILL_COMPANION_ZUNDAPAL` placeholder (Studio upload)
2. **Duplicate UI** — legacy StarterGui vs bootstrap (delete per `docs/studio-legacy-ui-deletion.md`)
3. **MasterChefZunda** — not restored (optional)

---

## Next actions

See **`AI/PUBLISH-PLAN.md`** and **`AI/WORK_QUEUE.md`**.

Priority: Phase 0 Studio cleanup → Phase 2 assets → Phase 3 launch blockers.

---

## Docs index

- `docs/PROJECT-REVIEW-2026-07-06.md` — deep review
- `docs/llm-production-setup.md` — LLM Studio config
- `docs/ELECTRA-SETUP.md` — Windows + Rojo
- `AI/AGENT-WORK-REVIEW.md` — agent contributions

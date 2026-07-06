# Project Status — Zundamon's Kitchen 🫛

**Updated:** 2026-07-06 (org review)  
**Workspace:** `G:\Zundamons-kItchen`  
**Sync:** `main-2026-07-06-org-review`

---

## Overall

| Milestone | Status |
|-----------|--------|
| Repo structure (flat Rojo) | ✅ Done |
| Core gameplay (harvest, craft, quests) | ✅ On main |
| UI framework (OpenCode) | ⚠️ Needs Studio cleanup + VN bootstrap |
| Companions | ⚠️ Placeholder mesh |
| LLM / Zundapal chat | ❌ Not on main (restore pending) |
| Public publish | ❌ Assets + legal + DevProducts |

**Not "ready for publishing"** until P0/P1 items in `AI/PUBLISH-PLAN.md` are cleared.

---

## What works

- Rojo sync from `G:\Zundamons-kItchen`
- `npm run rojo:serve` with port fallback
- Harvest validation, crafting, quests (server)
- Scatter, marketplace hooks, guest manager
- Legal checklist doc exists (`docs/legal-publish-checklist.md`)

---

## Known issues (playtest)

1. **Intro VN empty** — `VNController` parent mismatch (Rojo vs Studio GUI)
2. **Zundapal sphere** — `FILL_COMPANION_ZUNDAPAL` placeholder
3. **Duplicate UI** — legacy StarterGui vs bootstrap (delete per studio guide)

---

## Next actions

See **`AI/PUBLISH-PLAN.md`** and **`AI/WORK_QUEUE.md`**.

Priority: Phase 0 Studio cleanup → Phase 1 VN + companion + LLM.

---

## Docs index

- `docs/PROJECT-REVIEW-2026-07-06.md` — deep review
- `docs/ELECTRA-SETUP.md` — Windows + Rojo
- `docs/publish-tonight.md` — tonight checklist
- `AI/AGENT-WORK-REVIEW.md` — agent contributions

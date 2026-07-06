# Project Review — 2026-07-06 🫛

**Repo:** `fromage3900/Zundamons-kItchen`  
**Workspace:** `G:\Zundamons-kItchen`  
**Sync marker:** `main-2026-07-06-org-review`  
**Lua files:** ~120 under `src/`

---

## Executive summary

Zundamon's Kitchen is a **feature-rich Roblox farming/cooking game** with solid server-side systems (harvest validation, crafting, quests, companions, scatter, marketplace hooks). The repo is **flat and Rojo-ready** after the July 6 flatten. **Friends playtest** is blocked by a handful of **integration gaps** (VN bootstrap, companion mesh, Studio GUI hygiene). **Public launch** needs assets, DevProducts, legal, and restored LLM stack.

| Milestone | Verdict |
|-----------|---------|
| Solo dev + Rojo | ✅ Works |
| Friends playtest | ⚠️ ~1 focused session away |
| Public launch | ❌ Not ready |

---

## Architecture (current)

```
src/
├── ReplicatedStorage/
│   ├── ConfigurationFiles/   ← canonical configs (Quest, Craft, NPC, …)
│   ├── Shared/Config/          ← UIConfig, ScatterConfig, …
│   ├── UIAssets/               ← OpenCode generated images
│   └── Assets/Generated/       ← JSON metadata for assets
├── ServerScriptService/        ← game logic servers
├── StarterPlayer/StarterPlayerScripts/  ← client controllers
└── StarterGui/                 ← minimal (Rojo); most UI from Studio or bootstrap
```

**Rojo:** `default.project.json` at repo root. Serve: `npm run rojo:serve` (port 34872 or 34873).

---

## Agent work merged (summary)

See **`AI/AGENT-WORK-REVIEW.md`** for full audit.

| Agent | Net value | Gaps |
|-------|-----------|------|
| **Cline** | HarvestValidator, Planters 1Hz, Craft/Progression configs, GuestManager | Mineable validator wiring |
| **OpenCode** | UIHelper, AC VN shell, Scatter, UIAssets, DevConsole | VN needs Studio shell OR code bootstrap |
| **Cursor** | Flat repo, G: workspace, rojo port fix, legal docs, cleanup scripts | LLM + VN bootstrap lost in `de6316d` merge |

---

## Playtest symptoms → root cause

| Symptom | Root cause | Fix (phase) |
|---------|------------|-------------|
| Empty intro VN | `VNController` uses `script.Parent` (PlayerScripts ≠ ScreenGui) | Phase 1.2 — restore `ZundaVNGui` bootstrap |
| UI not updated | Duplicate StarterGui + Rojo bootstrap race | Phase 0 — delete legacy shells; pull latest |
| Zundapal floating sphere | `FILL_COMPANION_ZUNDAPAL` placeholder | Phase 1.3 — real mesh in Studio |
| Rojo port 10048 | Cursor/stale node on 34872 | ✅ `rojo-serve.mjs` fallback |

---

## Organizational fixes (this commit)

- 🫛 Removed duplicate `ReplicatedStorage/QuestConfig.lua` (canonical: `ConfigurationFiles/QuestConfig.lua`)
- 🫛 Restored `AI/WORK_QUEUE.md`, `AI/AGENT_COORDINATION.md`, `AI/PUBLISH-PLAN.md`
- 🫛 Updated `docs/ELECTRA-SETUP.md` for flat `G:\` layout
- 🫛 Restored `docs/publish-tonight.md` with current paths
- 🫛 Wired `npm run verify:safety` + `npm run security`
- 🫛 `verify-publish-safety.mjs` aligned to current tree (no false failures for removed LLM)

---

## Publish blockers

### P0 — playtest tonight
1. Studio legacy GUI delete (`docs/studio-legacy-ui-deletion.md`)
2. VN bootstrap fix
3. Companion mesh

### P1 — public
1. DevProduct IDs (`MarketplaceConfig.lua`)
2. 66+ `FILL_*` assets (`docs/asset-checklist.md`)
3. LLM stack restore (`ZundapalChat`, `MasterChefZunda`, `ZundapalLLMService`)
4. Legal (`docs/legal-publish-checklist.md`)

---

## Recommended order

1. **`AI/PUBLISH-PLAN.md` Phase 0** — Studio cleanup (15 min)
2. **Phase 1** — VN + companion + LLM restore
3. **Phase 2** — assets + DevProducts
4. **Phase 3** — legal + security verify

---

## Related docs

- `AI/PUBLISH-PLAN.md` — phased knock-off plan 🫛
- `AI/AGENT-WORK-REVIEW.md` — Cline/OpenCode/Cursor audit
- `docs/publish-tonight.md` — tonight checklist
- `docs/ELECTRA-SETUP.md` — Electra + Rojo on Windows
- `docs/PROJECT-STATUS.md` — living status

# Electra Setup — Zundamon's Kitchen 🫛

**Canonical workspace:** `G:\Zundamons-kItchen`  
**Repo:** https://github.com/fromage3900/Zundamons-kItchen  
**Last updated:** 2026-07-06 (flat layout, org review)

Use this guide on **Windows** with **Electra** (or any terminal) for Rojo sync, validation, and playtest prep.

---

## 1. Prerequisites

| Tool | Install |
|------|---------|
| **Git** | https://git-scm.com/download/win |
| **Node.js 18+** | https://nodejs.org/ |
| **Roblox Studio** | https://www.roblox.com/create |
| **Rojo 7.7.x** | `npm install` in repo (see below) |

Optional: **Python 3** for `scripts/extract-from-studio.py` if you export from Studio.

---

## 2. Clone / update workspace

```powershell
G:
cd G:\
git clone https://github.com/fromage3900/Zundamons-kItchen.git
cd G:\Zundamons-kItchen
```

**Already cloned:**

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm install
```

**Layout (flat — no nested `Zundamons-kItchen-GitHub-Build/`):**

```
G:\Zundamons-kItchen\
├── default.project.json
├── package.json
├── src\                    ← all Lua (Rojo)
├── scripts\                ← rojo-serve, validate, verify
├── docs\
└── AI\                     ← agent coordination
```

---

## 3. Rojo serve + Studio connect

```powershell
cd G:\Zundamons-kItchen
npm run rojo:serve
```

- Default port **34872**. If **Cursor** or another process holds it, the script uses **34873** (read terminal output).
- In Studio: **Rojo** plugin → Connect → match the port shown.
- Stop serve: `npm run rojo:stop` or Ctrl+C.

**Port already in use (Windows error 10048):**

```powershell
npm run rojo:stop
npm run rojo:serve
```

---

## 4. Validation & security

```powershell
npm run validate          # structure + Lua file count
npm run verify:safety     # publish-safety patterns
npm run security          # validate + verify:safety
npm run lint              # optional stylua check
```

---

## 5. Studio one-time cleanup (playtest) 🫛

Before solo playtest, delete **legacy StarterGui** shells so Rojo/bootstrap UI wins:

See **`docs/studio-legacy-ui-deletion.md`**

Delete if present:

- `ZundaFX`, `ZundaVN`, `ZundaPouch`, `QuestPanel`, `CompanionShop`, `ZundaShop`

Then **File → Save to Roblox** (or publish) so deletions persist.

---

## 6. Playtest checklist

1. `git pull` + `npm run rojo:serve`
2. Studio connect (correct port)
3. Legacy GUI deleted + place saved
4. Play solo — check Output for `LegacyOverlayCleanup`
5. Intro VN should show dialogue (if VN bootstrap merged — see `AI/PUBLISH-PLAN.md` Phase 1.2)
6. Companion should not be a gray sphere (assign mesh — Phase 1.3)

---

## 7. Sync marker

After pull, confirm in Studio Output or `SyncConfig`:

`src/ReplicatedStorage/ConfigurationFiles/SyncConfig.lua` → label e.g. `main-2026-07-06-org-review`

---

## 8. Multi-agent workflow

| Doc | Purpose |
|-----|---------|
| `AI/WORKSPACE.md` | G: drive canonical path |
| `AI/AGENT_COORDINATION.md` | Who owns what |
| `AI/WORK_QUEUE.md` | Task board |
| `AI/PUBLISH-PLAN.md` | Phased publish plan 🫛 |
| `AI/NEXT-TASKS.md` | Cline follow-ups |

**Rule:** One canonical repo at `G:\Zundamons-kItchen`. Commit to `main` via PR; bump `SyncConfig.label` on meaningful merges.

---

## 9. Troubleshooting

| Issue | Fix |
|-------|-----|
| WebSocket 400 | Match Rojo plugin to 7.7.x; restart serve + Studio |
| Empty VN | VNController expects ScreenGui parent — see publish plan Phase 1.2 |
| Floating Zundapal | Replace `FILL_COMPANION_ZUNDAPAL` in `NPCConfig.lua` + Studio |
| UI doubled | Delete legacy StarterGui; run `000_LegacyOverlayCleanup.client.lua` |

---

## 10. Not in this repo anymore

- ~~`beantown.rbxlx`~~ — removed; use Rojo + Studio place
- ~~`cargo install rojo`~~ — use `npm install` + `npx rojo`
- ~~Nested `Zundamons-kItchen-GitHub-Build/`~~ — flattened 2026-07-06

For tonight's publish steps: **`docs/publish-tonight.md`**

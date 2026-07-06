# Publish Tonight — Friends Playtest 🫛

**Workspace:** `G:\Zundamons-kItchen`  
**Goal:** Solo playtest works; friends can join a published place.

---

## Before you start

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm install
npm run security
```

---

## Step 1 — Studio legacy UI (15 min)

1. Open your Roblox place in Studio.
2. In **StarterGui**, delete:
   - `ZundaFX`, `ZundaVN`, `ZundaPouch`, `QuestPanel`, `CompanionShop`, `ZundaShop`
3. **File → Save to Roblox** (or Publish).

Details: `docs/studio-legacy-ui-deletion.md`

---

## Step 2 — Rojo

```powershell
npm run rojo:serve
```

Connect Studio to the port shown (34872 or 34873).

---

## Step 3 — Solo playtest

- [ ] No full-screen brown vignette overlay
- [ ] Output shows `LegacyOverlayCleanup` messages
- [ ] HUD / pouch UI appears
- [ ] Intro VN shows text (if Phase 1.2 merged)
- [ ] Companion is not a plain gray sphere

---

## Step 4 — Publish for friends

1. **Game Settings** → enable **Play** access for friends (or public test).
2. Publish place from Studio.
3. Share experience link.

---

## If something breaks

| Symptom | Doc |
|---------|-----|
| Empty VN | `AI/PUBLISH-PLAN.md` Phase 1.2 |
| Sphere companion | `AI/PUBLISH-PLAN.md` Phase 1.3 |
| Rojo port | `docs/ELECTRA-SETUP.md` §3 |
| Full blocker list | `docs/PROJECT-REVIEW-2026-07-06.md` |

---

## After tonight

Follow **`AI/PUBLISH-PLAN.md`** Phases 2–4 for public launch (assets, DevProducts, legal, LLM).

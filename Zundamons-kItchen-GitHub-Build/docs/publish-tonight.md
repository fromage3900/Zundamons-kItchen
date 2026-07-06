# Publish Tonight Checklist

**Place ID:** `108617605497926`  
**Repo:** Rojo-first — sync code from `main` (or feature branch) before publishing.

Use this runbook when shipping a playtest build the same day.

---

## 1. Code sync (15 min)

```bash
cd Zundamons-kItchen-GitHub-Build
git pull origin main   # or your feature branch
npm install
npm run validate       # includes secret scan + git hygiene
npm run rojo:serve
```

**Security gate:** `npm run validate` fails if API keys or place exports are committed. See [`git-security.md`](git-security.md).

In Studio:

1. Open place `108617605497926`
2. Plugins → Rojo → Connect `localhost:34872`
3. Confirm Output shows `[ROJO SYNC OK]`
4. Play solo — no red errors in Output

**Branches to merge before publish (if not on main):**

| Branch | Contains |
|--------|----------|
| `cursor/quest-vn-review-594f` | QuestConfig wiring, VN fixes |
| `cursor/zundapal-llm-594f` | LLM chat, companion integration |
| `cursor/publish-blockers-594f` | Planters fix, planting menu, decoration shop |

---

## 2. Studio secrets & services (10 min)

| Item | Location | Required for |
|------|----------|--------------|
| LLM API key | `ServerStorage.ZundapalLLMSecrets.ApiKey` (StringValue) | Zundapal free chat |
| HttpService | Game Settings → Security → Enable | LLM proxy |
| API whitelist | `api.deepseek.com` (or `api.openai.com`) | Outbound LLM |

Without the API key, Zundapal still works with scripted VN + fallback lines.

---

## 3. Studio world assets (30–60 min)

These are **not in git**. Verify in the published place:

| Asset | Path | Used by |
|-------|------|---------|
| Companion mesh | `GameplayLoopArea.GatheringNodes.Loop_AppleTree_1.mesh.zundapal` | Companion follow |
| Plant models | `ServerStorage.Plants.Wheat Plant(Young)`, `Wheat Plant` | Planters growth |
| Decoration models | `ServerStorage.Decorations.*` (11 model names in `DecorationConfig`) | Decoration shop |
| Tagged planters | `CollectionService` tags `Planter` on planter parts | Planting |
| Plantable templates | `CollectionService` tag `Plantable` on seed models in ServerStorage | Planting |
| Gather nodes | `GameplayLoopArea.GatheringNodes` | Zunda gather loop |
| Plot signs | `PlotConfig` centers match world | Claim plot |

See [`zunda-design-bible.md`](zunda-design-bible.md) and [`companion-integration-audit.md`](companion-integration-audit.md) for full manifests.

---

## 4. Playtest matrix (20 min)

Run each flow once before publish:

| # | Flow | Pass criteria |
|---|------|---------------|
| 1 | Join + data load | Gold/inventory visible; no DataStore errors |
| 2 | Gather node | Item added; harvest progress bar works |
| 3 | Craft + serve | Guest served; gold/XP updates |
| 4 | Quest board | Active quests show progress |
| 5 | Zone lore NPC | VN opens; `npc_chats` increments (elder/ruins/chef) |
| 6 | Companion click | VN tree or free chat; sparkles on LLM thinking |
| 7 | Planting | Click empty planter with seeds → menu → plant grows |
| 8 | Decoration shop (H) | Buy with gold → place on owned plot |
| 9 | Claim plot | `ClaimPlot` remote when guest milestone met |
| 10 | Companion shop (K) | Equip free companion |

---

## 5. Publish to Roblox

1. File → Publish to Roblox (or Game Settings → Permissions)
2. Set experience to **Public** or **Friends** for tonight's playtest
3. Note version in [`patch-notes-template.md`](patch-notes-template.md)

---

## 6. Post-publish smoke test

1. Join from Roblox app (not Studio) with a fresh alt account
2. Confirm Rojo-synced scripts run (check for `[Planters]`, `[DecorationShop]`, `[ZundapalChat]` in server logs if accessible)
3. Share place link: `https://www.roblox.com/games/108617605497926`

---

## Known non-blockers

- Skybox face IDs empty in `SkyConfig` — default sky still works
- Robux DevProduct IDs are placeholders — companion shop uses test grant
- Selene full-repo lint not clean — `npm run validate` is the gate
- `master` branch stale — use `main` only

---

## Quick hotkeys (client)

| Key | Action |
|-----|--------|
| K | Companion shop |
| H | Decoration shop |
| (Pouch) | Inventory UI (Studio ScreenGui) |

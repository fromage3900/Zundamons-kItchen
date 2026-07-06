# Studio Playtest Smoke (5 min)

Run with **Rojo connected** (`npm run rojo:serve`) and place `108617605497926` open.

## Before play

- [ ] Terminal: `git pull origin main` and Rojo serve running
- [ ] Studio: Plugins → Rojo → Connect `localhost:34872`
- [ ] Explorer: delete **StarterGui → ZundaFX** if it still exists (one-time)

## Output strings (solo play)

Look for these in Output — no red errors above them:

| String | Meaning |
|--------|---------|
| `[LegacyOverlayCleanup]` | Vignette teardown ran |
| `[DisclaimerGate] AI disclosure gate ready` | AI modal loaded |
| `[ZundapalChat] LLM free chat ready` | Chat wiring OK |
| `[MasterChefZundaChat] Mentor LLM ready` | Chef chat OK |

## Visual checks

| # | Action | Pass |
|---|--------|------|
| 1 | Play solo | No full-screen dark corner boxes / grain overlay |
| 2 | Click companion → free chat | "AI mentor" badge on chat bar |
| 3 | First message send | Disclaimer modal → Accept → message sends |
| 4 | Master Chef NPC → free chat | Same disclaimer if not yet accepted (alt account) |
| 5 | Press H | Decoration shop opens cleanly (no overlay blocking) |

## Quick gameplay (optional)

- Gather one node → item in inventory
- Craft + serve one guest → gold updates

## If something fails

| Symptom | Fix |
|---------|-----|
| No `[DisclaimerGate]` | Reconnect Rojo; confirm `DisclaimerGate.client.lua` under StarterPlayerScripts |
| Vignette still visible | Delete `StarterGui.ZundaFX`; check Output for `[LegacyOverlayCleanup]` |
| LLM never replies | `ServerStorage.ZundapalLLMSecrets.ApiKey` + HttpService + API whitelist |
| Disclaimer loops | Check server Output for DataStore errors |

## Repo verification (local)

```bash
cd G:\Zundamons-kItchen
npm run verify:safety
npm run validate
```

# Legal & Roblox Publish Checklist

**Not legal advice.** Use this as a creator checklist before making the experience **public** on Roblox. For friends-only playtests, many items are optional but recommended.

**Experience:** Zundamon's kItchen — Place ID `108617605497926`

---

## Creator eligibility

- [ ] Roblox account in good standing
- [ ] Age and ID verification complete (required for public publish and monetization)
- [ ] Creator Hub access to experience settings

References:

- [How to Publish Games on Roblox](https://en.help.roblox.com/hc/en-us/articles/203313890-How-to-Publish-Games-on-Roblox)
- [Publish experiences and places](https://create.roblox.com/docs/en-us/production/publishing/publish-experiences-and-places)

---

## Content maturity & compliance questionnaire

Answer honestly in Creator Hub:

| Topic | Zundamon's kItchen guidance |
|-------|----------------------------|
| Generative / third-party AI | **Yes** — optional Zundapal & Master Chef mentor chat |
| AI is primary experience | **No** — kitchen sim; scripted VN is primary |
| Extended interaction (Restricted) | **Likely no** — LLM is optional 1:1 mentor, not open hangout |
| User-generated content broadcast | **No** — LLM replies are per-player only |
| Violence / mature themes | Review Community Standards; keep family-friendly kitchen tone |

References:

- [Generative AI in experiences](https://create.roblox.com/docs/en-us/generative-AI)
- [Restricted Content Policy](https://en.help.roblox.com/hc/en-us/articles/15869919570708-Restricted-Content-Policy)
- [Community Standards](https://about.roblox.com/community-standards)

---

## In-game disclosures (implemented)

- [ ] First-use AI modal (`DisclaimerGate.client.lua`) before first LLM send
- [ ] `llm_disclaimer_accepted` stored server-side
- [ ] "AI mentor" badge on VN free-chat bar
- [ ] Daily LLM cap and TextService filtering active

Copy source: [`DisclaimerConfig.lua`](../src/ReplicatedStorage/ConfigurationFiles/DisclaimerConfig.lua)

---

## Experience metadata

Use description text that mentions optional AI mentor chat. Example snippet:

> Optional AI mentor chat (Zundapal & Master Chef Zunda) uses a third-party service. Replies may be inaccurate. Do not share personal information. See creator privacy policy.

### Experience description template (copy to Creator Hub)

```
Zundamon's kItchen — a cozy kitchen life-sim in a pastel village.

Gather ingredients, craft recipes, serve guests, decorate your plot, and befriend companions.

Optional AI mentor chat (Zundapal & Master Chef Zunda) uses a third-party AI service.
• Replies are AI-generated and may be wrong
• Do not share personal information
• Scripted dialogue and quests work without AI

Play solo or with friends. Family-friendly cooking adventure.
```

- [ ] Thumbnail and title match claimed maturity
- [ ] Link or reference [`PRIVACY.md`](../PRIVACY.md) if repo is public

---

## Monetization

- [ ] Replace placeholder DevProduct IDs (`11111111…`) with real Creator Dashboard IDs
- [ ] Run `STRICT_PUBLISH=1 npm run security` before public launch
- [ ] No unguarded test Robux grants (`CompanionShopServer` Studio-gated)
- [ ] Single `ProcessReceipt` owner (`RobuxStoreServer`)

---

## Technical safety gate

```bash
cd Zundamons-kItchen-GitHub-Build
npm run validate
STRICT_PUBLISH=1 npm run security   # after real product IDs exist
```

See [`security-audit.md`](security-audit.md), [`git-security.md`](git-security.md), [`publish-tonight.md`](publish-tonight.md).

---

## Kids / Select (All ages) — if targeting

Stricter path: ID verification, 2FA, Premium/Plus or fee, evaluation period. **Default recommendation:** launch **13+ / 16+** with LLM disclosed, pursue All ages after review.

---

## GitHub (if repository is public)

- [ ] Full history secret scan (`gitleaks detect` or `trufflehog`)
- [ ] Rotate any key ever committed
- [ ] Branch protection on `main` — see [`git-security.md`](git-security.md)
- [ ] `PRIVACY.md` and `SECURITY.md` linked from README

---

## Studio manual (place `108617605497926`)

- [ ] Delete `StarterGui.ZundaFX` if still present
- [ ] Rojo sync from `main`; confirm `[LegacyOverlayCleanup]` in Output
- [ ] LLM API key only in `ServerStorage.ZundapalLLMSecrets.ApiKey`
- [ ] HttpService enabled; API domain whitelisted

See [`legacy-ui-migration.md`](legacy-ui-migration.md).

---

## Disclaimer

This checklist summarizes Roblox creator obligations and project-specific controls. Consult qualified counsel for commercial release or regional compliance (GDPR, COPPA, etc.).

# Git & Repository Security

Practices for keeping **Zundamon's kItchen** safe to publish from GitHub.

---

## What must never be committed

| Item | Where it belongs |
|------|------------------|
| LLM API keys (DeepSeek, OpenAI) | Studio `ServerStorage.ZundapalLLMSecrets.ApiKey` |
| Roblox Open Cloud keys | Local env / CI secrets only — not in repo |
| Figma personal access tokens | `~/.cursor/mcp.json` locally |
| Place exports (`*.rbxl`, `*.rbxlx`) | Roblox Creator Hub only |
| Player data / DataStore dumps | Never |

`.gitignore` blocks `.env*`, `*.pem`, `secrets/`, and place exports.

---

## Automated checks

Run before every push:

```bash
cd Zundamons-kItchen-GitHub-Build
npm run validate    # Rojo build + structure
npm run security    # secret scan + git hygiene
```

| Script | What it catches |
|--------|-----------------|
| `scripts/check-secrets.mjs` | API keys, Bearer tokens, private key blocks in tracked files |
| `scripts/check-git-hygiene.mjs` | Place exports, `workspace/` commits, `_G.data[` on server |
| `scripts/check-remote-sync.mjs` | `RemoteManifest.lua` drift from `default.project.json` |
| `scripts/check-publish-readiness.mjs` | Unguarded TEST grants; placeholder DevProduct IDs (`STRICT_PUBLISH=1`) |

CI runs these on every PR and push to `main`.

**Optional:** `npm run hooks:install` — pre-push hook runs `npm run security`.

---

## Branch protection (recommended)

On GitHub → Settings → Branches → `main`:

- [ ] Require status check `validate-rojo` (or local `npm run validate` before merge)
- [ ] Block force-push to `main`
- [ ] Optional: require PR review for collaborators

---

## Full git history scan

Run before making the repo **public** or after any suspected secret commit:

```bash
# Option A — gitleaks (install separately)
gitleaks detect --source . --verbose

# Option B — trufflehog
trufflehog git file://$(pwd)
```

If a place export or API key appears in history:

1. Rotate the compromised credential immediately
2. Remove from history with `git filter-repo` (not just a new delete commit)
3. Re-run `npm run security`

Stale `master` branch on GitHub can be deleted; use `main` only.

---

## Branch policy

- **`main`** — publish-ready; only merge via PR after validate + security pass
- **Feature branches** — `cursor/*`, `opencode/*`, `cline/*`; never push secrets even on branches
- **Delete `master`** — stale; use `main` only (optional GitHub cleanup)

---

## Studio secrets (not git)

```
ServerStorage
└── ZundapalLLMSecrets (Folder)
    └── ApiKey (StringValue)  ← paste key in Studio only
```

Enable **HttpService** and whitelist `api.deepseek.com` in Game Settings.

---

## If a secret was committed

1. **Rotate the key immediately** (old key is compromised)
2. Remove from git history (`git filter-repo` or BFG) — do not only delete in a new commit
3. Re-run `npm run security` before next push

---

## Server exploit hardening (code)

| Remote | Protection |
|--------|------------|
| `CraftFunction` | Recipe whitelist + `RemoteRateLimiter` (0.5s) |
| `ServeGuest` | Guest folder + distance + `RemoteRateLimiter` (0.75s) |
| `plantEvent` | Planter tag + distance + `RemoteRateLimiter` (1.5s) |
| `BuyDecoration` / `PlaceDecoration` | Catalog whitelist + rate limits |
| `ZundapalChatSend` | Length, cooldown, TextService filter, disclaimer, daily cap |
| `MasterChefChatSend` | Persona locked server-side (`master_chef`); shared LLM cooldown |
| `GetLlmDisclaimerStatus` / `AcceptLlmDisclaimer` | Server-backed disclosure acceptance |
| `RecordNpcChat` | Speaker whitelist + 5s cooldown |
| Harvest | `HarvestValidator` distance + rate limit |

See [`security-audit.md`](security-audit.md) for applied fixes history.

---

## Pre-publish checklist

- [ ] `npm run validate && npm run security` pass
- [ ] No uncommitted place exports (`git status`)
- [ ] API key only in Studio ServerStorage
- [ ] Merge latest `main` into Studio via Rojo before Creator Hub publish

See also: [`publish-tonight.md`](publish-tonight.md)

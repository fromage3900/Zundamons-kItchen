# Contributing to Zundamon's kItchen

Thanks for helping build **Zundamon's kItchen**!

## Development model (Option C)

- **Code** in `src/` → git → Rojo live sync → cloud place `108617605497926`
- **World** (map, meshes, guests) → Studio → **Save to Roblox** (not git)

Read [`docs/git-workflow.md`](docs/git-workflow.md) and [`docs/rojo-workflow.md`](docs/rojo-workflow.md) before your first PR.

Migrating from the old 48MB `.rbxlx`? [`docs/migration-from-legacy-place.md`](docs/migration-from-legacy-place.md).

## Branches

- `cursor/<task>-594f`, `cline/<task>`, `opencode/<task>`, or `feature/<name>`
- Open a **Pull Request** targeting `main`
- Prefer small PRs with playtest steps

## Source of truth

All gameplay **code and config modules** live under `src/` and sync via Rojo.

**Do not commit:**

- `*.rbxl`, `*.rbxlx`, `*.rbxmx` place exports
- `workspace/` build outputs
- Secrets or API keys

**Do commit:**

- `src/**/*.lua`
- `default.project.json` when Rojo hierarchy changes
- `docs/` when workflow or conventions change
- Bump `SyncConfig.label` on meaningful merges

## Local setup

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm install
npm run rojo:serve
```

Open **cloud place** `108617605497926` in Studio; connect Rojo plugin.

## PR checklist

- [ ] Changes in `src/` for any code/config edits
- [ ] `npm run validate` passes
- [ ] Playtested with Rojo connected; `[ROJO SYNC OK]` in Output
- [ ] No place export files committed
- [ ] World changes noted if teammate must re-open place / you Saved to Roblox
- [ ] `SyncConfig.label` bumped if appropriate

## Standards

- [`docs/rojo-workflow.md`](docs/rojo-workflow.md)
- [`AI/STYLE_GUIDE.md`](AI/STYLE_GUIDE.md)
- [`AI/ONBOARDING.md`](AI/ONBOARDING.md)

## Reporting issues

GitHub Issues with repro steps, place ID `108617605497926`, and whether Rojo was connected.

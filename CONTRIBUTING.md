# Contributing to Zundamon's kItchen

Thanks for helping build **Zundamon's kItchen**!

## Development model

- Use **feature branches**: `feature/<short-name>` or `cursor/<descriptive-name>-<id>`
- Open a **Pull Request** targeting `main`
- Prefer small PRs with clear system notes and playtest steps

## Source of truth: Rojo + `src/`

All gameplay **code and config modules** are committed under `src/` and synced via Rojo.

**Do not commit:**

- `*.rbxl`, `*.rbxlx`, `*.rbxmx` place/model exports
- `workspace/` build outputs

**Do commit:**

- Changes to `.lua` files under `src/`
- Updates to `default.project.json` when the Studio hierarchy changes
- Docs when conventions or architecture change

## Local setup

```bash
cd G:\Zundamons-kItchen
npm install
npm run rojo:serve
```

Connect Roblox Studio via the Rojo plugin. See `docs/rojo-workflow.md`.

## PR checklist

- [ ] `src/` changes included for any code/config edits
- [ ] `npm run validate` passes locally
- [ ] Playtested in Studio with Rojo connected
- [ ] No `workspace/` or place export files committed
- [ ] Patch notes included (if user-facing changes)

## Code & architecture standards

See:

- `docs/rojo-workflow.md`
- `docs/style-guide.md`
- `docs/review-checklist.md`
- `docs/code-review.md` (known issues and improvement backlog)

## Reporting issues

Use GitHub Issues with repro steps and which systems are affected.

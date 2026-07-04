# Contributing to Zundamon's kItchen

Thanks for helping build **Zundamon's kItchen**!

## Development model
- Use **feature branches**: `feature/<short-name>`
- Open a **Pull Request** targeting `main`
- Prefer small PRs with a clear Studio export mapping.

## Export rule (critical)
This repo assumes the following source-of-truth items are committed:
- Roblox place/model exports in **rbxlx/rbxmx** under `source/`
- Any relevant ModuleScript/code artifacts in repo-friendly text form

If you cannot export in text form yet, note it in the PR description and label it clearly.

## PR checklist (what reviewers expect)
- [ ] Exported `source/` changes are included
- [ ] Any new dependencies/references are documented
- [ ] No accidental `workspace/` outputs are committed
- [ ] Patch notes included (if user-facing changes)

## Code & architecture standards
See:
- `docs/style-guide.md`
- `docs/review-checklist.md`

## Reporting issues
Use the GitHub issue templates in `.github/`.


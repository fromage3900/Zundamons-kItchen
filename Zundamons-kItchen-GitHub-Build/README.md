# Zundamon's kItchen — GitHub Build (Roblox)

This repository is the collaboration hub and build source of truth for the Roblox experience **"Zundamon's kItchen"**.

## Core goals
- **Cooperative game dev**: clear structure, repeatable exports, predictable PRs.
- **GitHub build readiness**: CI validates that the repository contains valid exported Roblox source artifacts.
- **Maintainability**: documented architecture, style guide, and review checklist.

## Recommended Roblox source format (chosen)
For GitHub builds, this repo targets **text-friendly Roblox exports**:
- Studio exports in **rbxlx/rbxmx** format (text, diffable)
- `ModuleScript` / code extracted into text form (either via Studio export or a repo-friendly mirror)

Why this decision:
- Enables code review (diffs) and reduces merge pain.
- Works better for CI validation and deterministic artifacts.

> If your current workflow exports only `.rbxl` binaries, the first milestone is to switch to text exports so the repo becomes “reviewable”.

## Repository layout (high level)
- `source/` — exported place/model + code artifacts (text)
- `assets/` — images/audio/etc you manage in-repo
- `workspace/` — local build outputs (ignored by git)
- `.github/` — GitHub Actions + PR/Issue templates
- `docs/` — architecture + review checklist + style guide

## Getting started
1. Export the current experience from Roblox Studio using the repo’s conventions (see `docs/style-guide.md`).
2. Commit exports into `source/`.
3. Open a PR; CI should validate repository structure.

## Contributing
See [`CONTRIBUTING.md`](CONTRIBUTING.md).


# Project Review — Zundamon's kItchen

Review date: 2026-07-05  
Repository: [fromage3900/Zundamons-kItchen](https://github.com/fromage3900/Zundamons-kItchen)  
Workflow: Rojo-first (`src/` + `default.project.json`)

## Scorecard

| Category | Score | Notes |
|----------|-------|-------|
| Repo hygiene | 10/10 | Rojo workflow, no place exports, CI validation |
| Architecture | 7/10 | Config-driven; PlayerDataService migration in progress |
| Security | 7/10 | Harvest validator strong; remote audit applied to priority systems |
| Performance | 8/10 | Planters grow loop at 1Hz; review weather/sky overlap |
| Gameplay | 8/10 | Rich feature set (crafting, fishing, companions, VN, quests) |
| Harvest polish | 10/10 | Config + client UX + server validator |
| **Overall** | **8/10** | Playable prototype ready for cooperative dev |

## Technical deep dive

See [`code-review.md`](code-review.md) for system-by-system analysis, known issues, and roadmap.

## Remote contract

See [`remotes.md`](remotes.md) for all `RemoteEvent` / `RemoteFunction` definitions.

## Security audit

See [`security-audit.md`](security-audit.md) for fixes applied to serving, inventory, tools, and loot.

## Getting started

```bash
cd Zundamons-kItchen-GitHub-Build
npm install
npm run rojo:serve
```

Install recommended VS Code extensions when prompted (`.vscode/extensions.json`).

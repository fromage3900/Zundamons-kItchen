# Project Rules (Zundamon's kItchen)

These rules exist to make cooperative dev smooth and keep PRs reviewable.

## 1) Source of truth
- `source/` contains Studio exports in **text-friendly** formats:
  - `*.rbxlx` and/or `*.rbxmx`
- `workspace/` is never committed.

## 2) Export discipline (PR rule)
Every PR that changes gameplay must include:
- updated Studio export(s) under `source/`
- an entry in the PR description with:
  - what changed
  - which systems were touched
  - how to verify in Studio

## 3) No binary-only diffs
Avoid committing only `*.rbxl` binaries when the same content can be exported as `*.rbxlx/*.rbxmx`.

## 4) Networking + security
- Server owns authority for game-critical state.
- Remote payload schemas must be documented in code or in `docs/`.

## 5) Performance
- Avoid per-frame heavy work.
- Prefer caching and event-driven updates.

## 6) Code review expectations
- Follow `docs/review-checklist.md`.
- Keep PRs small.

## 7) Commit hygiene
- Commits should correspond to a coherent change.
- Avoid “format only” changes unless required.


# Project Rules (Zundamon's kItchen)

These rules exist to make cooperative dev smooth and keep PRs reviewable.

## 1) Source of truth

- **`src/`** is the canonical home for scripts and config modules, synced via **Rojo** (`default.project.json`).
- **`workspace/`** is never committed (local `rojo build` output).
- **Place exports** (`*.rbxl`, `*.rbxlx`, `*.rbxmx`) are **not** committed. World content stays in Studio.

## 2) Rojo discipline (PR rule)

Every PR that changes gameplay code must include:

- updated `.lua` files under `src/`
- `default.project.json` updates if services/folders change
- PR description with:
  - what changed
  - which systems were touched
  - how to verify in Studio (with Rojo connected)

## 3) Studio-only assets

The following must exist in the published Roblox place but are **not** in this repo:

- `ReplicatedStorage.RemoteEvents` / `RemoteFunctions`
- Workspace geometry, NPCs, harvest nodes, UI instances

Document new remotes in code comments or `docs/architecture-overview.md`.

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
- Avoid "format only" changes unless required.

# Pull Request Review Checklist

Use this checklist for every PR that changes exported Roblox source.

## Repo hygiene
- [ ] No `workspace/` outputs were committed.
- [ ] Required exported files exist under `source/`.
- [ ] Changes are scoped to the feature/bugfix.

## Architecture & maintainability
- [ ] Folder/Instance organization matches the style guide.
- [ ] ModuleScript responsibilities are clear.
- [ ] No circular `require()` dependencies introduced.
- [ ] Public APIs are documented.

## Networking & security
- [ ] Server validates RemoteEvent/RemoteFunction payloads.
- [ ] No client-side authority for gameplay-critical state.
- [ ] Rate limiting or abuse prevention exists where needed.

## Performance
- [ ] No new per-frame heavy loops were added.
- [ ] Any expensive operations are cached or event-driven.
- [ ] Latency-sensitive paths are not doing unnecessary work.

## Gameplay correctness
- [ ] Behavior matches intended design.
- [ ] Edge cases (respawns, missing data, nil references) are handled.

## Review quality
- [ ] PR description explains export mapping.
- [ ] Tests/playtest notes are included.
- [ ] Patch notes included when user-facing changes.


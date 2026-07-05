# Style Guide (Zundamon's kItchen)

This style guide focuses on consistency across cooperative development and making diffs reviewable.

## Naming conventions
- Use clear, descriptive names for Instances that map to file/function concepts.
- Prefer PascalCase for ModuleScripts and folders.
- Avoid abbreviations unless they are team-standard.

## ModuleScript boundaries
- One ModuleScript should have one clear responsibility.
- Avoid circular dependencies:
  - If Module A requires Module B, Module B should not require Module A.
- Expose narrow public APIs (return tables with explicit fields).

## Code organization
- Keep configuration in one place:
  - example: `source/.../Config` modules
- Separate pure logic from Roblox Instance wiring.

## Networking rules
- Server-authoritative logic:
  - Validate inputs on the server.
- Never trust client-supplied values.
- Use RemoteEvent/RemoteFunction consistently:
  - Document payload schema.

## Performance rules
- Avoid per-frame expensive work (loops over GetDescendants in Update).
- Cache references in initialization paths.
- Prefer event-driven updates.

## Export/diff rules
- **Rojo + `src/`** is the source of truth for scripts and config modules.
- Do not commit place exports (`*.rbxl`, `*.rbxlx`, `rbxmx`).
- World content and remotes stay in Studio; document Studio-only deps in PRs.

## Comments and documentation
- Use comments for “why”, not “what”.
- Keep high-signal summaries above modules/functions.


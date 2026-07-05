# AI Rules & Standards

## Code Standards
1. **Rojo-First**: Never modify `.rbxl` files directly. All code changes must happen in the `src/` directory.
2. **Security**: Never trust client input. All Remotes must have server-side validation.
3. **Data Integrity**: Use `PlayerDataService.lua` for all player data access. Do not use `_G.data`.
4. **Modularity**: Avoid large monolithic scripts. Split logic into `ModuleScripts` and `Services`.
5. **Cross-Platform**: Ensure all scripts (Node.js, Luau) are compatible with both Windows and Linux.

## Workflow Rules
1. **Validation**: Run `npm run validate` and `npm run lint` before committing.
2. **Documentation**: Update `docs/remotes.md` when adding new network events. Update `AI/` guidance when changing architecture or design patterns.
3. **Architecture**: Keep `ConfigurationFiles/` side-effect free. Active listeners and server logic belong in `ServerScriptService`.

## Communication
1. **Tone**: Maintain a professional, technical, and helpful persona.
2. **Verification**: Always provide evidence of verification (e.g., successful lint/build results).
3. **Safety**: Do not delete files or perform destructive git operations unless explicitly requested.

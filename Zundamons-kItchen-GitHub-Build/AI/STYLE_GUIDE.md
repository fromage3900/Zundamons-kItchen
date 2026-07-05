# Coding Style Guide

## Lua/Luau
- **Indentation**: 4 spaces (standard for Roblox).
- **Naming**: 
    - Variables/Functions: `camelCase` or `PascalCase` (consistency with file is key).
    - Constants: `UPPER_SNAKE_CASE`.
    - Services: `game:GetService("ServiceName")`.
- **Requires**: Always local, usually at the top of the file.
- **Safety**: 
    - Always check if player data exists (`if not d then return end`).
    - Use `WaitForChild` for instances that might not be loaded yet.
- **Remotes**: 
    - Server must validate all inputs (type, range, existence).
    - Implement rate limiting for critical remotes.

## Linting
- **StyLua**: Used for formatting.
- **Selene**: Used for static analysis.
- Run `npm run lint` before committing.

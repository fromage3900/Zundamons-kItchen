# Naming Conventions

## Lua / Luau
- **Files**: `PascalCase` (e.g., `PlayerDataService.lua`). Client scripts should end in `.client.lua`, Server scripts in `.server.lua`.
- **Variables**: `camelCase` (e.g., `currentGold`).
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `RESPAWN_TIME`).
- **Services**: Use `game:GetService("ServiceName")` and name the local variable `ServiceName`.
- **Remotes**: `PascalCase` (e.g., `PurchaseResult`).

## Theme-Specific Naming
- **Zunda Prefix**: Use "Zunda" prefix for theme-related ingredients and items (e.g., `Zunda Flower`, `Zunda Pea`).
- **Emoji Usage**: Emojis can be used in string literals for display, but never in variable or file names.

## Directory Structure
- `src/ReplicatedStorage/ConfigurationFiles/`: Shared data modules.
- `src/ServerScriptService/Services/`: Core server logic and data handlers.
- `src/StarterPlayer/StarterPlayerScripts/Controllers/`: Client-side state managers.

## Database / Player Data
- Keys in player data tables should be `snake_case` (e.g., `companion_owned`, `current_gold`).

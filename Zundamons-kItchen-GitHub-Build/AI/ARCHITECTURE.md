# Architecture Overview

## Data Flow
1. **Server Authority**: All critical state (Gold, Inventory, Player Stats) is owned and validated by the server.
2. **PlayerDataService**: The single source of truth for player data on the server. Do NOT use `_G.data`.
3. **Remotes**: Managed in Studio but documented in `docs/remotes.md`. Server-side handlers must validate all payloads.

## Service Pattern
- Critical logic should reside in `ServerScriptService/Services`.
- Use `ModuleScripts` for reusable logic.
- Avoid monolithic scripts; prefer splitting into logical components (e.g., `VNController` and `VNDialogueData`).

## Configuration
- Game tuning and static data live in `src/ReplicatedStorage/ConfigurationFiles/`.
- These modules are shared between Client and Server.

## Validation
- Use dedicated validator scripts (e.g., `HarvestValidator.server.lua`) to check client requests against server-side logic.

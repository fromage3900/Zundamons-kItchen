# Architecture Overview

## Current systems
*(Fill this in after the first export scan/structure review.)*

## Proposed module map
- Networking layer
- Game rules / state management
- UI layer
- Persistence
- Audio/FX

## Data flow (template)
- Client input -> request -> server validate -> server state -> replication -> client presentation

## How to extend
- Add a new system via a dedicated ModuleScript folder.
- Update docs + style guide notes if conventions change.


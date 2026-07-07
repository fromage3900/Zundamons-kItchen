# Delegation Plan — Multi-Agent Workstreams

## Agent Assignments

| Agent | Strengths | Owns |
|-------|-----------|------|
| **Cursor** | Integration, merge, publish safety, large refactors | `cursor/*` branches |
| **Cline** | Server systems, security, data, backend gameplay | `cline/*` branches |
| **OpenCode (You)** | Client UI, assets, Studio MCP, project direction | `main` direct commits |
| **Ollama (Local)** | Overnight research, content generation, code drafts | `scripts/agent_orchestrator/` |

---

## Workstream 1: Asset Import Pipeline (You — OpenCode)

**Priority: P0** — Must complete before anything else can use real meshes.

```
1. [Manual] Drop all OBJ/FBX files into Assets/Upload/
   ├── harvest_nodes/
   ├── architecture/
   ├── companions/
   ├── npcs/
   ├── icons/
   └── environment/

2. [Script]  python scripts/agent_orchestrator/tools/batch_import.py --scan
   → Generates reports/mesh_pipeline/batch_import.luau

3. [Studio]  Paste batch_import.luau into command bar
   → Save output JSON as reports/mesh_pipeline/import_results.json

4. [Script]  python scripts/agent_orchestrator/tools/batch_import.py --apply
   → Auto-updates MeshAssets.lua, NPCConfig, UIAssets, etc.

5. [Verify]  npm run overnight
   → Confirms all asset IDs are now real

Total time: ~2-3 hours for 350+ assets
```

---

## Workstream 2: Progression + Balance (Cline)

**Priority: P1** — Unlocks smooth gameplay after assets are in.

| Task | Files | Instructions for Cline |
|------|-------|----------------------|
| Generate progression milestones | `ProgressionConfig.lua` | Add milestones at intervals between existing ones. The 14 quest-only recipes need milestone paths. Suggested: 0→Bread/ApplePie, 5→ZundaBread, 12→Cupcake, 25→ZundaMochi, 50→RoyalStew, 75→FancyPie, 100→SweetPeaCake, 150→ZundaParadise, 200→UltimateFeast |
| Tune XP curve | `ChefLevelConfig.lua` | Current: 80xp/level (1-5), 100-180xp (6-10), 220+ (11+). Flatten to: 60/80/100/120/140 for levels 1-5, then +20 per level after. |
| Tune guest pay | `ProgressionConfig.lua` → `guest_preferences` | Add 3 new guest types. Current max pay is 120g. Add a "VIP Guest" (150-250g) and "Celebrity Chef" (300-500g) with challenge bonuses. |
| Generate guest pref quests | `QuestConfig.lua` (with Ollama) | `python scripts/agent_orchestrator/run.py "Design quest chain for VIP guest type with 3 steps"` |

**Branch:** `cline/progression-balance`

---

## Workstream 3: Quest + Content Generation (Ollama — autonomous)

**Priority: P1** — Runs overnight, fills content gaps.

```bash
# Run these before bed — results ready in the morning:

# 1. Generate 20 quests targeting uncovered recipes
npm run generate-quests

# 2. Research and draft balance recommendations
python scripts/agent_orchestrator/run.py "Analyze game economy balance and suggest XP/gold tuning"

# 3. Generate dialogue/variants for existing quests
python scripts/agent_orchestrator/run.py "Add 3 variants of npc_dialogue to each quest chain"

# 4. Daemon mode (continuous improvement overnight)
python scripts/agent_orchestrator/run.py --daemon --interval 7200

# All output → reports/generated/ and reports/orchestrator-*.json
# Review in the morning, merge what's good
```

---

## Workstream 4: UI Design System Integration (Cursor)

**Priority: P2** — Visual polish after gameplay works.

| Task | Files | Details |
|------|-------|---------|
| Reskin Admin Console | `AdminConsole.client.lua` | Replace hardcoded colors with `UIConfig.COLORS.*`, fonts with `UIConfig.FONTS.*`, panels with `UIComponents.createPanel()` |
| Build DevDashboard | `DevDashboard.client.lua` (new) | F3 toggle. Panels: Systems, Players, Modifiers, Plugins, Config Editor. Uses UIComponents for all elements. |
| Wire HUD buttons | `HudScript.client.lua` | Ensure all buttons call correct RemoteFunctions |
| Add missing UI transitions | `UIFrillsScript.client.lua` + `UIPolishScript.client.lua` | Check both are using UIComponents.animateIn/Out patterns |

**Branch:** `cursor/ui-design-system`

---

## Workstream 5: Modifier Stack Expansion (Cursor + Ollama)

**Priority: P2** — Enhances visual quality.

| Task | Who | Details |
|------|-----|---------|
| ToonOutline modifier | Cursor | Inverted hull technique via EditableMesh. 1 file. |
| Noise module | Ollama → Cursor | `python scripts/agent_orchestrator/run.py "Generate NoiseModule.lua with Perlin and simplex noise in Luau"` → Cursor integrates |
| Displace modifier | Cursor | Uses NoiseModule for vertex displacement |
| Array tools | Cursor | Add `applyAll`, `group`, `stagger` to `ModifierStack.lua` |

**Branch:** `cursor/modifier-expansion`

---

## Workstream 6: Blender Sync Bridge (Cursor + Blender Agent)

**Priority: P3** — Long-term, enables live Blender→Roblox mesh streaming.

| Task | Who | Details |
|------|-----|---------|
| Blender addon server | Ollama Blender Agent | `python scripts/agent_orchestrator/run.py "Generate Blender addon with HTTP server for mesh streaming"` |
| Roblox sync service | Cursor | Receive mesh data, construct EditableMesh in real-time |
| Escher math ops | Ollama → Cursor | `python scripts/agent_orchestrator/run.py "Generate EscherMath.lua with Penrose tiling ops"` |

**Branch:** `cursor/blender-bridge`

---

## Weekly Coordination Cadence

| Day | Agent | Focus |
|-----|-------|-------|
| Mon | You | Asset import + Studio world building |
| Tue | Cline | Progression/balance patch |
| Wed | Ollama | Overnight quest generation |
| Thu | Cursor | UI design system + modifier expansion |
| Fri | All | Merge day — review all branches, resolve conflicts, push to main |
| Sat | Ollama | Daemon mode — continuous improvement |
| Sun | - | Rest / playtest |

---

## Branch Strategy

```
main ← You commit directly (small changes)
  ├── cline/progression-balance
  ├── cursor/ui-design-system
  ├── cursor/modifier-expansion
  ├── cursor/blender-bridge
  │
  └── auto/generated-content  ← Ollama output (review before merge)
```

**Merge rules:**
1. `npm run validate` must pass before merge
2. `npm run overnight` must show 0 errors
3. Any config changes reviewed by you
4. No `.rbxlx` or `.rbxl` files in commits

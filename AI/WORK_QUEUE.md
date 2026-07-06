# 🫛 Work Queue — Zundamon's kItchen

Live task board. **Claim before coding.** Workspace: `G:\Zundamons-kItchen` ([`WORKSPACE.md`](WORKSPACE.md)).

| ID | Task | Owner | Status | Branch | Files |
|----|------|-------|--------|--------|-------|
| P0 | Friends playtest smoke | Human | pending | main | Studio StarterGui cleanup |
| P1 | Restore LLM stack post-merge | Cursor | pending | cursor/restore-llm-vn-594f | ZundapalLLM*, MasterChef*, chat clients |
| P2 | VN code-bootstrap (`ZundaVNGui`) | Cursor | pending | cursor/restore-llm-vn-594f | VNController.client.lua |
| P3 | HUD Rojo bootstrap | OpenCode | pending | opencode/hud-bootstrap | HudScript, CraftingScript |
| P4 | Real DevProduct IDs | Human | pending | main | MarketplaceConfig.lua |
| P5 | Kenney decal upload | Human | blocked | — | UIAssets.lua (network) |
| C1 | Wire Mineable → HarvestValidator | Cline | pending | cline/mineable-validator | Mineable.server.lua |
| C3 | Mesh import (HarvestNodeVariants IDs or Models/) | Cline | **blocked** | cline/mesh-import | verify:meshes fails — see CLINE-MESH-VERIFY.md |
| C4 | RealNASA skybox upload (6 face IDs) | Human | pending | main | SkyConfig.presets.realnasa |
| C2 | RewardCore → RewardSystem service | Cline | pending | cline/reward-service | RewardCore.lua, RewardBoot |
| O1 | QuestScript UIComponents | OpenCode | pending | opencode/quest-ui | QuestScript.client.lua |
| O2 | Asset upload pass (home network) | OpenCode | blocked | — | UIAssets, HarvestNodeVariants |
| R1 | Org review + Electra docs | Cursor | done | cursor/org-review-electra-594f | docs/, AI/ |
| R2 | Remove duplicate QuestConfig | Cursor | done | cursor/org-review-electra-594f | default.project.json |
| R3 | Flat repo + G: workspace | Cursor | done | main | AI/WORKSPACE.md |

## Status values

`pending` · `in_progress` · `review` · `done` · `blocked`

## Rules

1. Read [`AGENT_COORDINATION.md`](AGENT_COORDINATION.md) + [`AGENT-WORK-REVIEW.md`](AGENT-WORK-REVIEW.md)
2. Branch: `cursor/*-594f`, `cline/*`, `opencode/*`
3. `npm run validate` before push
4. Do not commit `.rbxl` / `.rbxlx`

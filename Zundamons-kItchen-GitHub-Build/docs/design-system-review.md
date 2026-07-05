# Design System Review — Zundamon's kItchen

**Date:** 2026-07-05  
**Reviewer:** Professional UI/UX Design Review  
**Scope:** Full design system audit — documentation, code architecture, interaction patterns, and visual consistency

---

## 1. Design System Documentation

| Area | Status | Notes |
|---|---|---|
| Style guide exists | ✅ PASS | `docs/style-guide.md` covers naming, code org, networking, performance |
| Architecture documented | ✅ PASS | `docs/architecture-overview.md` with system tables and data flow diagrams |
| Review checklist exists | ✅ PASS | `docs/review-checklist.md` — 6-section PR review process |
| Project rules defined | ✅ PASS | `docs/project-rules.md` — 7 rules for cooperative development |
| Contributing guide | ✅ PASS | `CONTRIBUTING.md` with branch naming, PR, and commit conventions |
| Patch notes template | ✅ PASS | `docs/patch-notes-template.md` for user-facing change logs |

### Assessment
The documentation layer is **comprehensive and well-structured**. Each document has a clear purpose and avoids overlap. The style guide focuses on code conventions while the project rules focus on workflow — good separation.

### Recommendations
- Add a **visual design tokens** section (colors, typography, spacing, UI component specs) to the style guide for Roblox GUI consistency
- Add a **UX patterns** document covering common interaction flows (menus, notifications, progress indicators)
- Consider adding screenshots or mockups for key UI elements in the architecture doc

---

## 2. Interaction Design Patterns

### Harvesting UX (New Polish Layer) — ✅ Excellent

The harvesting interaction is the strongest UX pattern in the project:

| Pattern | Quality | Details |
|---|---|---|
| **Affordance** | ✅ Strong | ClickDetector provides clear interactable signal |
| **Feedback** | ✅ Strong | Progress bar + animation + sound + particles — multi-sensory |
| **Cancellation** | ✅ Strong | Movement, key press, or distance all cancel gracefully |
| **Error prevention** | ✅ Strong | Server validation prevents exploits without punishing legitimate players |
| **Consistency** | ✅ Strong | `HarvestConfig` centralizes all tuning — single source of truth |

**UX Strengths:**
- 2.5-second hold duration is appropriate — long enough to feel intentional, short enough to not frustrate
- Cancel-on-move (>1.5 studs) prevents accidental harvests during navigation
- Randomized pitch (0.9–1.1) on harvest sounds prevents audio fatigue
- Progress bar positioned center-screen ensures visibility regardless of camera angle

**UX Improvements:**
- Consider adding a **tooltip/hover state** before the hold begins so players know what they'll harvest
- Add **haptic feedback** (controller vibration) for gamepad users during the hold
- Consider a **"harvest complete" celebration** micro-animation (screen flash, item icon popup) for reward satisfaction

### Planting UX — ⚠️ Needs Attention

| Pattern | Quality | Details |
|---|---|---|
| **Affordance** | ⚠️ Weak | ClickDetector on planters — no visual distinction between empty/planted states |
| **Feedback** | ⚠️ Minimal | Plant appears instantly after seed selection — no planting animation |
| **Error prevention** | ✅ Good | Server validates seed ownership and planter availability |
| **State visibility** | ⚠️ Weak | Growth progress is invisible to the player — no visual stages or timer |

**Recommendations:**
- Add **visual growth stages** (sprout → seedling → mature) so players can see progress
- Add a **planting animation** when a seed is placed
- Show a **growth timer** or progress indicator on the planter
- Differentiate empty vs. planted vs. ready-to-harvest planters with distinct visual states

### Menu/UI Patterns — ⚠️ Inconsistent

Based on the codebase, UI is created programmatically in client scripts without a shared component library:

- `HarvestController` creates its own progress bar UI inline
- `MaterialsScript` manages inventory display independently
- `StoreScript`, `CraftingScript`, `QuestScript` each build their own UI

**Recommendations:**
- Create a **shared UI component module** (`UIComponents.lua`) with reusable elements: buttons, panels, progress bars, item slots
- Define **design tokens** as a config module: colors, font sizes, corner radius, padding, animation durations
- Standardize **notification patterns** — currently mixed between GUI labels and chat messages

---

## 3. Information Architecture

### Config Module Organization — ✅ Well-Structured

| Module | Purpose | Consistency |
|---|---|---|
| `HarvestConfig` | Harvest distances, timings, visuals | ✅ Clean, typed |
| `PlantConfig` | Plant growth times, sprout mappings | ✅ Consistent |
| `MineableConfig` | Mineable health, respawn, loot | ✅ Consistent |
| `ItemConfig` | Item definitions and properties | ✅ Consistent |
| `CraftConfig` | Crafting recipes | ✅ Consistent |
| `FishConfig` | Fish types and rarity | ✅ Consistent |
| `QuestConfig` | Quest definitions | ✅ Consistent |
| `ShopConfig` | Shop items and prices | ✅ Consistent |
| `BuildingConfig` | Building types | ✅ Consistent |

**Strength:** Config modules follow a uniform pattern — table of items with named keys and property sub-tables. This makes the data layer predictable and easy to extend.

**Improvement:** Add a `UIConfig.lua` module to centralize all UI-related constants (colors, sizes, animation curves) currently scattered across client scripts.

### Folder Structure — ✅ Clean

```
src/
├── ReplicatedStorage/Shared/     ← Shared configs + modules (correct)
│   ├── Config/                   ← Tuning data
│   └── Modules/                  ← Shared logic
├── ServerScriptService/          ← Server authority (correct)
│   └── Validation/               ← Security layer (good practice)
├── StarterPlayer/                ← Client scripts (correct)
│   └── StarterPlayerScripts/
│       └── Controllers/          ← Client controllers (good pattern)
└── Workspace/                    ← Scene hierarchy (new, sparse)
    └── Kitchen/Counters/
```

The DataModel mirror pattern is correct and follows Rojo conventions.

---

## 4. Code Quality as Design System

### Windsurf Changes Review

The changes made by Windsurf to `Planters.server.lua` are **high-quality improvements**:

| Change | Impact | Assessment |
|---|---|---|
| Heartbeat → `task.wait(1)` loop | 🟢 Major perf fix | Reduces 6,000 checks/sec to 100/sec for 100 planters |
| `plantingEvent` moved out of ClickDetector closure | 🟢 Critical bug fix | Prevents event handler leak (N connections per click) |
| Added `local` to function declarations | 🟢 Good practice | Prevents global namespace pollution |
| Added nil guards for `_G.data` | 🟢 Safety improvement | Prevents nil reference crashes |
| Added `item.Parent` check in growth loop | 🟢 Edge case fix | Handles destroyed planters gracefully |
| `game.ReplicatedStorage` → `game:GetService()` | 🟢 Best practice | More reliable service access |
| Formatting cleanup (spacing) | 🟡 Minor | Improves readability |

**Verdict:** All Windsurf changes are **approved** — they address real issues identified in the project review without changing gameplay behavior.

---

## 5. Overall Design System Score

| Category | Score | Notes |
|---|---|---|
| **Documentation** | 9/10 | Comprehensive docs, missing only visual design specs |
| **Interaction Design** | 8/10 | Harvesting is excellent; planting needs UX polish |
| **Information Architecture** | 9/10 | Clean config pattern, good folder structure |
| **Visual Consistency** | 6/10 | No shared UI component library; inline UI creation |
| **Code as Design System** | 8/10 | Good patterns, Windsurf fixes improve quality |
| **Accessibility** | 5/10 | No gamepad/accessibility considerations documented |

### **Overall: 7.5/10**

### Priority Actions
1. **Create `UIConfig.lua`** — Centralize design tokens (colors, fonts, sizes, animation durations)
2. **Create `UIComponents.lua`** — Shared reusable UI elements (buttons, panels, progress bars)
3. **Add planting UX feedback** — Growth stages, planting animation, progress indicator
4. **Document visual design specs** — Add a design tokens section to the style guide
5. **Add accessibility notes** — Gamepad support, colorblind considerations, text scaling

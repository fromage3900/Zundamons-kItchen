# Cline Mesh Import Verification — 2026-07-06

**Verdict: meshes are NOT imported yet.**

Run locally:

```powershell
npm run verify:meshes
```

---

## What Cline actually delivered (code)

| Item | Status |
|------|--------|
| `HarvestNodeVariants.lua` variant keys + `FILL_*` slots | ✅ Config only |
| `Assets/Generated/**/*.json` Blender pipeline specs | ✅ Metadata only |
| `ReplicatedStorage/Models/` Rojo folder | ⚠️ `.gitkeep` only — **no mesh files** |
| `ScatterService` using meshes | ✅ Wired this branch — falls back to Parts until IDs exist |
| Studio FBX upload + `rbxassetid` paste | ❌ Not done |
| Kenney decal upload | ❌ Blocked (network firewall per SESSION-NOTES) |

---

## Counts (main)

| File | Real `rbxassetid` | `FILL_*` placeholders |
|------|-------------------|------------------------|
| `HarvestNodeVariants.lua` | 0 | 18 |
| `NPCConfig.lua` | 0 | 22+ |
| `ReplicatedStorage/Models/` | 0 files | — |

---

## What “imported” would look like

1. **Harvest nodes:** `HarvestNodeVariants.lua` has numeric `rbxassetid://` for wheat/pea/mushroom/etc.
2. **OR** `src/ReplicatedStorage/Models/Wheat_01.rbxmx` (or `.rbxm`) synced via Rojo
3. **`npm run verify:meshes`** exits 0
4. In Studio play: scattered nodes are MeshParts, not green cubes

---

## Cline next steps

1. Export FBX from `Assets/Generated/` JSON pipeline (Blender at home)
2. Import to Studio → copy mesh asset IDs
3. Paste into `HarvestNodeVariants.lua` **or** drop models in `ReplicatedStorage/Models/`
4. `git commit` + `npm run verify:meshes`

See `AI/NEXT-TASKS.md` and `docs/asset-checklist.md`.

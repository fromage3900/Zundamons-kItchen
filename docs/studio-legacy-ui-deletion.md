# Studio Legacy UI Deletion Checklist

One-time cleanup for place **108617605497926**. Work in **Edit mode** (not Play).

Runtime script [`000_LegacyOverlayCleanup.client.lua`](../src/StarterPlayer/StarterPlayerScripts/000_LegacyOverlayCleanup.client.lua) also removes these from `PlayerGui` on join, but **deleting from StarterGui** stops duplicates and one-frame flashes.

---

## Prerequisite: Rojo connected

```powershell
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

Studio: **Plugins → Rojo → Connect** (`localhost:34872`)

### WebSocket error 400

| Step | Action |
|------|--------|
| 1 | Leave `npm run rojo:serve` running; must show port **34872** |
| 2 | `rokit install` then `rojo plugin install`; restart Studio |
| 3 | `rojo --version` must be **7.7.0** (matches [`rokit.toml`](../rokit.toml)) |
| 4 | Plugins → Manage Plugins → Rojo → **Script Injection ON** |
| 5 | Restart serve + Studio; connect with host `localhost` |

See [`rojo-sync-troubleshooting.md`](rojo-sync-troubleshooting.md).

---

## Delete from StarterGui

Explorer → **StarterGui** → delete each row:

| Delete | Why |
|--------|-----|
| **ZundaFX** | Vignette / grain overlay (+ **FXController** if nested) |
| **ZundaVN** | Replaced by `ZundaVNGui` (code) |
| **ZundaPouch** | Rebuilt by `PouchScript.client.lua` |
| **QuestPanel** | Rebuilt by `QuestScript.client.lua` |
| **CompanionShop** | Replaced by `CompanionShopGui` |
| **ZundaShop** | Replaced by `ZundaShopGui` |

**Do not delete yet:** `ZundaHUD`, `CraftingPanel`, `DataGUI`, `SellLoot`

**Also delete duplicate LocalScripts** inside any remaining StarterGui if Rojo already syncs the same script to `PlayerScripts` (you will see double `[ZundaPouch] Ready` / `Hello world!` in Output).

---

## Save and publish

1. **File → Save to Roblox** (or Publish)
2. Confirm deletions persist after reopening the place

---

## Verify (Play solo, Rojo connected)

| Check | Pass |
|-------|------|
| Output: `[LegacyOverlayCleanup] Done` | Yes |
| No dark corner vignette | Yes |
| `PlayerGui` has `ZundaVNGui`, not `ZundaFX` | Yes |
| **H** decoration shop, **K** companion shop, **J** quests | Open cleanly |

Full smoke test: [`studio-playtest-smoke.md`](studio-playtest-smoke.md)

Config: [`LegacyGuiConfig.lua`](../src/ReplicatedStorage/ConfigurationFiles/LegacyGuiConfig.lua)

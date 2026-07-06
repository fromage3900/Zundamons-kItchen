# Skybox Upload Guide

Quick Studio steps to fill `SkyConfig.sky` face IDs for tonight's publish.

**Config file:** `src/ReplicatedStorage/ConfigurationFiles/SkyConfig.lua`  
**Applied by:** `DayNightSky.server.lua` at runtime (via `SkyAtmosphereHelper`)  
**Active preset:** `SkyConfig.active_preset = "realnasa"`

---

## RealNASA preset (default)

Earth-from-space / Blue Marble look. Source faces live in `Assets/Textures/RealNASA/` (upload to Creator, then paste IDs):

```lua
-- SkyConfig.presets.realnasa
skybox_bk = "rbxassetid://YOUR_ID",
skybox_dn = "rbxassetid://YOUR_ID",
-- ... all six faces
```

Until all six IDs are set, Output warns and Roblox default sky shows — **atmosphere still uses NASA-tuned haze/glare/decay**.

---

## 1. Choose or create a skybox

Requirements for Zunda Village:

- Soft anime/pastel horizon (not harsh photoreal)
- Golden-hour bottom face (`skybox_dn`) should blend with `Atmosphere.Color` at hour 7 (~`RGB 255, 215, 185`)
- Night top face (`skybox_up`) should work with indigo keyframes (hour 0–5)

**Toolbox search terms:** `anime skybox`, `pastel sky`, `japanese sunset skybox`, `cozy sky`

---

## 2. Upload to Roblox Creator

1. Open [Create → Development Items](https://create.roblox.com/dashboard/creations) (or Asset Manager in Studio)
2. Upload each skybox face as a **Decal** or use a bundled skybox pack
3. Copy each asset ID (numeric) from the URL or properties panel

Format in config: `rbxassetid://123456789` or `"123456789"` (both work once `DayNightSky` reads them)

---

## 3. Paste into SkyConfig

Edit `SkyConfig.sky` in git (Rojo sync) or temporarily in Studio:

| Key | Face |
|-----|------|
| `skybox_rt` | Right (+X) |
| `skybox_lf` | Left (-X) |
| `skybox_bk` | Back (-Z) |
| `skybox_ft` | Front (+Z) |
| `skybox_up` | Top (+Y) |
| `skybox_dn` | Bottom (-Y) |
| `sun_texture` | Optional custom sun disc |
| `moon_texture` | Optional custom moon disc |

Example:

```lua
skybox_bk = "rbxassetid://1234567890",
skybox_dn = "rbxassetid://1234567891",
-- ... all six faces
```

Commit and Rojo-sync, or hot-edit in Studio for a one-off playtest.

---

## 4. Studio lighting settings (one-time)

In the published place:

| Setting | Value |
|---------|-------|
| Lighting → Technology | Future |
| Lighting → LightingStyle | Realistic |
| Lighting → PrioritizeLightingQuality | true |

Post-FX is handled by `AtmospherePostFX.client.lua` (bloom, color correction by hour).

---

## 5. Verify in Play

1. `npm run rojo:serve` + connect Studio
2. Play solo — cycle through dawn (hour 6–7) and dusk (hour 17–19)
3. Check for seams at cube edges (misaligned faces) or harsh horizon line
4. Toggle weather (`WeatherSystem`) — skybox should still read under rain/sakura particles

---

## Non-blocking for tonight

Empty skybox IDs use Roblox default sky. The game is playable without custom art; upload when you have assets ready.

See also: [`atmosphere-polish-plan.md`](atmosphere-polish-plan.md) Phase 1.

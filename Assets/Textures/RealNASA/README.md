# RealNASA Sky Textures (source files)

NASA **Visible Earth** / Blue Marble style cubemap faces for Zunda Village sky.

**License:** NASA Earth imagery is generally public domain ([NASA media guidelines](https://www.nasa.gov/nasa-brand-center/images-and-media/)).

## Files (add after export)

Place six cube faces here before Studio upload:

| File | Roblox `Sky` property |
|------|------------------------|
| `bk.png` | `SkyboxBk` → `SkyConfig.presets.realnasa.skybox_bk` |
| `dn.png` | `SkyboxDn` |
| `ft.png` | `SkyboxFt` |
| `lf.png` | `SkyboxLf` |
| `rt.png` | `SkyboxRt` |
| `up.png` | `SkyboxUp` |

## Workflow

1. Start from a NASA Blue Marble equirectangular image (e.g. Visible Earth collection)
2. Convert to 6 cube faces (see `docs/skybox-upload-guide.md` — Panorama to Cubemap / Roblox staff guide)
3. Rotate **dn** 90° CCW, **up** 90° CW (Roblox convention)
4. Bulk upload via Studio **Asset Manager**
5. Paste `rbxassetid://` into `SkyConfig.presets.realnasa` in git
6. `npm run rojo:serve` — `DayNightSky` applies faces at runtime

**Active preset:** `SkyConfig.active_preset = "realnasa"` (atmosphere tuning works even before all 6 IDs are set).

# Zunda World Atmosphere Polish — Plan & Resource Guide

**Goal:** Elevate Zundamon's kItchen from a functional sky/weather stack to a cohesive **Japanese garden / cozy life-sim** atmosphere — soft light, sakura-season warmth, misty mornings, lantern glow at dusk — without breaking mobile performance or Rojo workflow.

**Related:** [`environment-audit.md`](environment-audit.md) · [`SkyConfig.lua`](../src/ReplicatedStorage/ConfigurationFiles/SkyConfig.lua) · [`DayNightSky.server.lua`](../src/ServerScriptService/DayNightSky.server.lua)

---

## 1. Current state (gap analysis)

| Layer | Status | Gap |
|-------|--------|-----|
| Day/night keyframes | ✅ 14 keyframes in `SkyConfig` | Good base; palette not yet tuned to 和風 reference |
| Atmosphere (Density/Haze/Glare) | ✅ Runtime via `DayNightSky` | No `Atmosphere.Offset` tuning; skybox IDs empty |
| Weather + particles | ✅ `cherry_blossom`, rain, snow, fog, aurora | Sakura uses generic `leaf.png` texture |
| Terrain clouds | ✅ `CloudController` | Colors tuned; not sakura-season pink wash |
| **Post-processing** | ❌ **None in code** | No `BloomEffect`, `SunRaysEffect`, `ColorCorrectionEffect` |
| **Skybox art** | ❌ Empty strings in `SkyConfig.sky` | Default Roblox sky shows through |
| **LightingStyle** | ⚠️ Not set in code | Studio may still be `Soft`; `Realistic` unlocks PBR + crisp shadows |
| Custom HLSL shaders | ❌ Not available for published games | See §3 |

**Highest-impact quick wins:** custom skybox + post-FX module driven by hour/weather + 和風 color pass on existing keyframes.

---

## 2. Important constraint: HLSL vs Roblox

Roblox **does not expose editable HLSL** for live experiences. Engine shaders are compiled internally; you cannot ship custom `.hlsl` files like Unity/Unreal.

| Approach | Shippable? | Notes |
|----------|------------|-------|
| `Lighting` + `Atmosphere` + `Sky` + post-FX instances | ✅ Yes | Official path; works for all players |
| Lua “screen shaders” (Gui overlays, depth tricks) | ⚠️ Limited | HyuiOWO-style repos simulate bloom/rays client-side |
| External injectors (ReShade, RoShade, 3DMigoto) | ❌ No | Local-only; ToS/anti-cheat risk; not for production |
| Reverse-engineering packed engine shaders | ❌ No | DevForum consensus: not viable for games |

**Plan assumption:** Polish via **config + Studio assets + Luau post-FX**, not custom HLSL. Use HLSL/Unreal articles only as **art-direction reference** (Rayleigh scattering, aerial perspective).

---

## 3. Phased implementation plan

### Phase 0 — Art direction lock (1 session)

Define a **Zunda palette** (low saturation, 引き算の美):

| Mood | Reference colors | Use in |
|------|------------------|--------|
| Sakura clear | `#F4C6CC`, `#FAF7F2`, `#CFCFCF` | `cherry_blossom` weather, planter sync |
| Golden hour | `#FFB347` → `#E8A2C8` sunset wash | Keyframes 6–8h, 17–19h |
| Night garden | `#1A1638`, `#60A0C8` indigo + muted stars | Keyframes 0–5h |
| Lantern warm | `#FFD4A8`, `#FF9E6B` | Interior/local lights, evening `ColorCorrection` |

**Japanese references (non-code):**
- [和風配色パターン集 (UTO's room)](https://uto-room.com/color/pattern/japan/)
- [桜グラデーション配色](https://uto-room.com/color/pattern/sakura-gradient/)
- [夕焼けグラデーション配色](https://uto-room.com/color/pattern/sunset-gradient/)
- [創作向け桜の色まとめ](https://create.mattarichaos.info/cherryblossom-world/)

**World-building tone:** Fantasy Japanese life-sim (like *Bo: Path of the Teal Lotus* interviews emphasize — inspired by ukiyo-e/nature, not literal Japan sim).

---

### Phase 1 — Skybox & atmosphere art (Studio) 🟡

**Code support added:** `DayNightSky` applies non-empty `SkyConfig.sky.skybox_*` / sun / moon asset IDs (`rbxassetid://` or raw numeric string).

**Still Studio-side:** Upload 6-face skybox; paste IDs into `SkyConfig.sky`. Toolbox search terms documented in config comments.

1. Commission or source a **6-face + sun/moon** skybox set (anime-soft or painterly; horizon colors must match `Atmosphere.Color` at golden hour).
2. Upload to Creator; fill `SkyConfig.sky.skybox_*` and `sun_texture` / `moon_texture` asset IDs.
3. Set Studio **Technology → Future**, **LightingStyle → Realistic**, **PrioritizeLightingQuality → true** (document in place; optionally mirror in `SkyConfig.lighting`).

**Resources:**
| Resource | Lang | URL |
|----------|------|-----|
| Roblox official skybox guide | EN | [creator-docs/environment/skybox.md](https://github.com/Roblox/creator-docs/blob/main/content/en-us/environment/skybox.md) |
| Skybox + Atmosphere (Zenn) | JA | [landho_roblox — SkyboxとAtmosphere](https://zenn.dev/landho_roblox/articles/bf7a1a2d098f82) |
| Time-of-day sky swap script | JA | [howtoroblox-ja — 時間帯別背景変更](https://howtoroblox-ja.com/archives/3591) |
| Atmosphere parameters deep-dive | JA | [howtoroblox-ja — 大気の表現](https://howtoroblox-ja.com/archives/933) |
| Outdoor lighting tutorial | EN | [Enhance outdoor environments](https://create.roblox.com/docs/tutorials/use-case-tutorials/lighting/enhance-outdoor-environments) |
| Realism settings repo | EN | [aaravss1/Realism-in-Roblox](https://github.com/aaravss1/Realism-in-Roblox) |

**Acceptance:** No visible horizon seam between terrain and sky at noon and sunset; `cherry_blossom` weather feels pink-tinted without blowing exposure.

---

### Phase 2 — Post-processing module (Rojo) ✅

**Implemented:**
- `src/ReplicatedStorage/ConfigurationFiles/PostFXConfig.lua` — hour bands + weather modifiers
- `src/StarterPlayer/StarterPlayerScripts/AtmospherePostFX.client.lua` — Bloom, SunRays, ColorCorrection under `Lighting`

**Behavior:**
- Create (once) under `Lighting`: `BloomEffect`, `SunRaysEffect`, `ColorCorrectionEffect` (optional light `DepthOfField` for cinematics only).
- Drive intensities from **hour** + **`CurrentWeather`** workspace attribute (same contract as `DayNightSky`).
- **Mobile tier:** disable SunRays + heavy Bloom below quality level 8; keep ColorCorrection (always runs per DevForum).

**Starter presets (tune in `PostFXConfig`):**

| Hour band | Bloom | SunRays | ColorCorrection |
|-----------|-------|---------|-----------------|
| 6–9 golden | 0.35 / thresh 0.85 | 0.12 / spread 0.2 | Saturation −0.1, warm tint `#FFE8D0` |
| 10–16 clear | 0.2 | 0.08 | Neutral |
| 17–20 sunset | 0.45 | 0.18 | Tint `#FFD0A8`, Contrast +0.05 |
| 21–5 night | 0.15 | 0 | Tint `#A8C0E8`, Brightness −0.05 |

| Weather | Extra |
|---------|-------|
| `cherry_blossom` | +pink tint, +soft bloom |
| `fog` / `rain` | −saturation, +cool tint |
| `aurora` | +green-purple tint on ColorCorrection |

**Official reference:** [Post-processing effects](https://create.roblox.com/docs/environment/post-processing-effects)

**Community reference (evaluate, do not HttpGet in production):**
- [AZYsGithub/Chillz-s-scripts enhancer.txt](https://github.com/AZYsGithub/Chillz-s-scripts/blob/main/enhancer.txt) — Bloom/ColorCorrection/SunRays baseline values
- [HyuiOWO/Script-Shader-Roblox-1.2](https://github.com/HyuiOWO/Script-Shader-Roblox-1.2) — Lua “shader” with quality tiers (Vietnamese README; study patterns, **vendor code into repo** if adopted)

**Acceptance:** Lantern areas feel warm at night; sakura weather reads as pink without crushing UI readability.

---

### Phase 3 — Sakura & mist particles (Studio + config) ✅ partial

**Done in config/code:**
- Sakura palette (`#F4C6CC` / `#FDEFF4`), drag, rotation, mobile `particle_rate` scale
- `CloudController` storm/fog + pink cherry cloud wash
- `WeatherClient` reads extended particle fields from `SkyConfig`

**Still Studio-side:** Upload custom petal `rbxassetid` → set `cherry_blossom.particle_texture` in `SkyConfig`


**Japanese craft reference:** [landho_roblox — 背景制作・ライティング](https://zenn.dev/landho_roblox/articles/514ee32e8cf2e1) (spot/point lights on transparent anchored parts for “sky lights”).

---

### Phase 4 — Volumetric mood (optional)

For **god-rays through torii / cafe windows** without HLSL:

| Option | Source | Tradeoff |
|--------|--------|----------|
| **Re-Lume** volumetric beams | [DevForum — Re-Lume module](https://devforum.roblox.com/t/re-lume-roblox-volumetric-light-module/4471785) | Beautiful; CPU/GPU cost; vendor into `ReplicatedStorage` |
| Native `SunRaysEffect` | Phase 2 | Cheaper; less localized |
| `Beam` + smoke texture in doorways | Studio | Manual per building; full control |

**Recommendation:** Start with SunRays + localized `SpotLight` cones in `GrandCafe_Interior`; add Re-Lume only in showcase zones if perf allows.

---

### Phase 5 — SkyConfig 和風 pass (config-only) ✅

- Softer dawn (`生成り` outdoor ambient), desaturated noon haze, sunset purple atmosphere rim
- `Atmosphere.offset` + tuned decay/glare in `SkyConfig.atmosphere`
- See commit on `cursor/toolchain-env-audit-594f`


---

### Phase 6 — QA & perf budget

| Check | Target |
|-------|--------|
| Mobile (QL 6+) | Bloom on; SunRays off |
| Desktop (QL 8+) | Full post-FX |
| Interior transition | No pop when entering `*_Interior` (consider Re-Lume-style eye adaptation later) |
| Rojo | All new logic in `src/`; skybox IDs in config only |

**Playtest script:** [`environment-audit.md` § Quick validation](environment-audit.md) + post-FX toggle at dawn/noon/sunset × clear/sakura/rain.

---

## 4. Resource catalog

### Japanese (Roblox-focused)

| Title | Topic | URL |
|-------|-------|-----|
| Skybox + Atmosphere入門 | Sky/Atmosphere basics | https://zenn.dev/landho_roblox/articles/bf7a1a2d098f82 |
| 背景制作・ライティング | World art lighting | https://zenn.dev/landho_roblox/articles/514ee32e8cf2e1 |
| 背景ぼかし (BlurEffect) | Post-process blur | https://zenn.dev/landho_roblox/articles/c33cd3699d22c9 |
| 時間帯別Sky切替 | TOD sky swap | https://howtoroblox-ja.com/archives/3591 |
| Atmosphereパラメータ | Haze/Glare/Color/Decay | https://howtoroblox-ja.com/archives/933 |
| 和風配色 | Art direction | https://uto-room.com/color/pattern/japan/ |
| 桜グラデーション | Sakura weather colors | https://uto-room.com/color/pattern/sakura-gradient/ |
| 夕焼けグラデーション | Sunset keyframes | https://uto-room.com/color/pattern/sunset-gradient/ |

### GitHub / community (atmosphere & “shader”)

| Repo / doc | Type | Use for Zunda |
|------------|------|----------------|
| [Roblox/creator-docs — post-processing](https://github.com/Roblox/creator-docs/blob/main/content/en-us/environment/post-processing-effects.md) | Official | Bloom, SunRays, ColorCorrection API |
| [Roblox/creator-docs — outdoor lighting](https://github.com/Roblox/creator-docs/blob/main/content/en-us/tutorials/use-case-tutorials/lighting/enhance-outdoor-environments.md) | Official | Realistic lighting walkthrough |
| [Roblox/creator-docs — indoor lighting](https://github.com/Roblox/creator-docs/blob/main/content/en-us/tutorials/use-case-tutorials/lighting/enhance-indoor-environments.md) | Official | SunRays intensity/spread example values |
| [aaravss1/Realism-in-Roblox](https://github.com/aaravss1/Realism-in-Roblox) | Guide | Technology, Atmosphere Density/Offset |
| [HyuiOWO/Script-Shader-Roblox-1.2](https://github.com/HyuiOWO/Script-Shader-Roblox-1.2) | Lua client FX | Quality tiers, bloom/rays patterns (**do not raw loadstring**) |
| [AZYsGithub/Chillz-s-scripts/enhancer.txt](https://github.com/AZYsGithub/Chillz-s-scripts/blob/main/enhancer.txt) | Snippet | Starter numeric presets |
| [DevForum — Re-Lume](https://devforum.roblox.com/t/re-lume-roblox-volumetric-light-module/4471785) | Module | Volumetric beams / mist |

### HLSL / engine shader (reference only — not Roblox-shippable)

| Resource | Why read it |
|----------|-------------|
| [Zenn — URP Skybox shaders](https://zenn.dev/nakaigames/articles/90f18daf6d61a8) | Procedural sky / atmosphere thickness vocabulary |
| [Zenn — UE Sky Atmosphere](https://zenn.dev/ryu_takatsukasa/articles/d5236dbe25efd2) | Rayleigh scattering mental model for keyframe colors |

### Japanese environment asset inspiration (Studio marketplace / external)

| Asset | Notes |
|-------|-------|
| [HWK Studio — Low Poly Japan Pack](https://hwk-studio.itch.io/low-poly-japan-assets-roblox) | Torii, minka, sakura — style reference |
| Creator Marketplace “anime skybox” / “sunset skybox” | Search in Studio Toolbox; verify no scripts |

---

## 5. What NOT to do

1. **HttpGet third-party shader repos** into live client — security + breakage risk; fork into `src/` if adopted.
2. **Rely on RoShade / external HLSL injectors** for the shipped game aesthetic.
3. **Conflict with `DayNightSky`** — post-FX client must **read** `CurrentHour` / `CurrentWeather` attributes, not fight server atmosphere tweens.
4. **Heavy DepthOfField globally** — hurts gameplay readability in a kitchen sim.
5. **Ignore mobile** — SunRays unavailable on mobile per Roblox quality tiers.

---

## 6. Suggested task breakdown (for PRs)

| PR | Scope | Est. invasiveness |
|----|-------|-------------------|
| A | `PostFXConfig.lua` + `AtmospherePostFX.client.lua` | Small — new files |
| B | `SkyConfig` 和風 keyframe + weather color pass | Medium — config only |
| C | Skybox asset IDs + Studio lighting flags doc | Studio + config |
| D | Custom sakura petal texture + particle tune | Studio asset |
| E | (Optional) Re-Lume in cafe interior only | Medium — perf test |

---

## 7. Success criteria

Players (and environment artists) should feel:

1. **Morning** — cool blue mist lifting into warm gold (not flat gray).
2. **Sakura weather** — pink air, petals, soft bloom; still readable UI.
3. **Evening cafe** — lantern warmth vs cool exterior sky.
4. **Night** — constellations + subtle bloom on neon aurora bands; no harsh default Roblox sky.

When these pass on mid-tier mobile and desktop, atmosphere polish Phase 1–3 is complete.

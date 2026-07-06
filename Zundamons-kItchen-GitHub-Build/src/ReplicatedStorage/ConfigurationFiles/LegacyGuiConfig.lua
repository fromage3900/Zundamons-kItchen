--!strict
-- LegacyGuiConfig: Studio ScreenGuis to remove at runtime (Rojo replaces these).

local LegacyGuiConfig = {}

-- Entire ScreenGui instances destroyed on client join (post-process / duplicate shells).
LegacyGuiConfig.destroyScreenGuis = {
	"ZundaFX",
	"PostProcessOverlay",
}

-- Descendant names removed anywhere under PlayerGui (watercolour vignette layers).
LegacyGuiConfig.destroyDescendantNames = {
	"WatercolourBleed",
	"Vignette",
	"GrainLayer",
	"NoiseImage",
}

-- Legacy VN shell from Studio; VNController builds ZundaVNGui in code.
LegacyGuiConfig.destroyLegacyVnShell = true

-- Studio StarterGui shells replaced by Rojo bootstrap (names may differ from code-built guis).
LegacyGuiConfig.destroyLegacyBootstrapShells = {
	"CompanionShop",
	"ZundaShop",
}

return LegacyGuiConfig

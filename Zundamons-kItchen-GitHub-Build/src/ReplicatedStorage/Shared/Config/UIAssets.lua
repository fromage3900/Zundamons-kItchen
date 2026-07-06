--!strict
-- [[ModuleScript] UIAssets]]
-- Asset IDs for UI elements, icons, sounds, particles.
-- Fill in rbxassetid:// values after generating via Blender/Roblox MCP.
-- Each FILL_ entry should be replaced with actual asset ID before publish.

local UIAssets = {
	icons = {
		-- Item icons (inventory, crafting panel)
		Wheat = "rbxassetid://FILL_ICON_WHEAT",
		["Zunda Flower"] = "rbxassetid://FILL_ICON_ZUNDA_FLOWER",
		["Zunda Pea"] = "rbxassetid://FILL_ICON_ZUNDA_PEA",
		["Zunda Berry"] = "rbxassetid://FILL_ICON_ZUNDA_BERRY",
		["Zunda Mushroom"] = "rbxassetid://FILL_ICON_ZUNDA_MUSHROOM",
		["Zunda Root"] = "rbxassetid://FILL_ICON_ZUNDA_ROOT",
		Apple = "rbxassetid://FILL_ICON_APPLE",
		Bread = "rbxassetid://FILL_ICON_BREAD",
		Cupcake = "rbxassetid://FILL_ICON_CUPCAKE",
		["Apple Pie"] = "rbxassetid://FILL_ICON_APPLE_PIE",
		["Zunda Bread"] = "rbxassetid://FILL_ICON_ZUNDA_BREAD",
		["Zunda Mochi"] = "rbxassetid://FILL_ICON_ZUNDA_MOCHI",
		["Royal Stew"] = "rbxassetid://FILL_ICON_ROYAL_STEW",
		["Salted Pea Bouquet"] = "rbxassetid://FILL_ICON_BOUQUET",
		["Gold Ore"] = "rbxassetid://FILL_ICON_GOLD_ORE",
		Rock = "rbxassetid://FILL_ICON_ROCK",
	},

	sounds = {
		-- Audio feedback (use Roblox library or upload custom)
		harvest_start = "rbxassetid://FILL_SOUND_HARVEST_START",
		harvest_complete = "rbxassetid://FILL_SOUND_HARVEST_COMPLETE",
		craft_start = "rbxassetid://FILL_SOUND_CRAFT_START",
		craft_perfect = "rbxassetid://FILL_SOUND_CRAFT_PERFECT", -- sparkly chime
		serve_success = "rbxassetid://FILL_SOUND_SERVE_SUCCESS", -- coin sound
		level_up = "rbxassetid://FILL_SOUND_LEVEL_UP", -- fanfare
		gather_fail = "rbxassetid://FILL_SOUND_GATHER_FAIL", -- soft error
		ui_click = "rbxassetid://FILL_SOUND_UI_CLICK",
	},

	particles = {
		-- Particle textures (sparkle effects)
		harvest_sparkle = "rbxassetid://FILL_TEX_SPARKLE_GREEN",
		craft_magic = "rbxassetid://FILL_TEX_SPARKLE_LAVENDER",
		serve_stars = "rbxassetid://FILL_TEX_SPARKLE_GOLD",
	},

	gui = {
		-- GUI assets (9-slice or custom)
		progress_bar_fill = "rbxassetid://FILL_GUI_PROGRESS_FILL",
		progress_bar_border = "rbxassetid://FILL_GUI_PROGRESS_BORDER",
		combo_badge = "rbxassetid://FILL_GUI_COMBO_BADGE",
		panel_bg = "rbxassetid://FILL_GUI_PANEL_BG",
		button_primary = "rbxassetid://FILL_GUI_BUTTON_PRIMARY",
	},

	animations = {
		harvest_loop = "rbxassetid://FILL_ANIM_HARVEST",
		cook_victory = "rbxassetid://FILL_ANIM_COOK_VICTORY",
		cook_fail = "rbxassetid://FILL_ANIM_COOK_FAIL",
	},
}

-- Helper: Check if asset is still placeholder
function UIAssets.isPlaceholder(id: string): boolean
	if typeof(id) ~= "string" then
		return true
	end
	return id:find("FILL_") ~= nil or id:find("rbxassetid://0$") ~= nil
end

-- Helper: Get icon with fallback emoji
function UIAssets.getIconWithFallback(itemName: string): (string, string)
	local id = UIAssets.icons[itemName] or ""
	return id, "" -- fallback emoji handled by UIHelper
end

return UIAssets

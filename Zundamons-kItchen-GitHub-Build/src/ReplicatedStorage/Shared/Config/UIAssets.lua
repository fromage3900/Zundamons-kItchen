--!strict
-- [[ModuleScript] UIAssets]]
-- Asset IDs for UI elements, icons, sounds, particles.
-- Fill in rbxassetid:// values after generating via Blender/Roblox MCP.
-- Each FILL_ entry should be replaced with actual asset ID before publish.

local UIAssets = {
	icons = {
		-- Item icons (inventory, crafting panel)
		-- All icons use emoji fallback via UIHelper until real decals are uploaded
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
		-- Built-in Roblox engine sounds — no upload needed
		-- Set pitch/volume in calling scripts for variety
		harvest_start = "rbxasset://sounds/hit.wav",
		harvest_complete = "rbxasset://sounds/snap.mp3",
		craft_start = "rbxasset://sounds/snap.mp3",
		craft_perfect = "rbxasset://sounds/electronicpingshort.wav",
		serve_success = "rbxasset://sounds/uiclick.wav",
		level_up = "rbxasset://sounds/electronicpingshort.wav",
		gather_fail = "rbxasset://sounds/hit.wav",
		ui_click = "rbxasset://sounds/uiclick.wav",
	},

	particles = {
		-- Built-in Roblox particle texture — always available
		harvest_sparkle = "rbxasset://textures/particles/sparkle_main.dds",
		craft_magic = "rbxasset://textures/particles/sparkle_main.dds",
		serve_stars = "rbxasset://textures/particles/sparkle_main.dds",
	},

	gui = {
		-- GUI image assets (need Studio upload for real 9-slice textures)
		-- UIHelper fallback creates colored frames with rounded corners
		progress_bar_fill = "rbxassetid://FILL_GUI_PROGRESS_FILL",
		progress_bar_border = "rbxassetid://FILL_GUI_PROGRESS_BORDER",
		combo_badge = "rbxassetid://FILL_GUI_COMBO_BADGE",
		panel_bg = "rbxassetid://FILL_GUI_PANEL_BG",
		button_primary = "rbxassetid://FILL_GUI_BUTTON_PRIMARY",
	},

	animations = {
		-- Animation assets (need Blender + FBX import pipeline)
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

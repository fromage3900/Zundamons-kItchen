--!strict
-- [[ModuleScript] CraftConfig]]
-- Recipe definitions for cooking system
-- Each recipe: { ingredient = amount, ... }
-- Unlockable recipes: set locked = true until achievement/unlock criteria met

local CraftConfig = {}

-- Base recipes (available from start)
CraftConfig.recipes = {
	Bread = {
		Wheat = 3,
	},
	["Apple Pie"] = {
		Apple = 3,
		Wheat = 2,
	},
	["Zunda Bread"] = {
		["Zunda Flower"] = 2,
		Wheat = 3,
	},
	["Zunda Mochi"] = {
		["Zunda Pea"] = 3,
		["Zunda Berry"] = 2,
	},
	["Royal Stew"] = {
		["Zunda Root"] = 2,
		["Zunda Mushroom"] = 2,
		["Zunda Flower"] = 1,
		Wheat = 1,
	},
	["Cupcake"] = {
		Wheat = 2,
		["Zunda Berry"] = 3,
		locked = true, -- Unlock via "q_sweet_tooth" achievement or level 5
	},
	-- Advanced recipes (locked)
	["Edamame Snack"] = {
		["Edamame Pod"] = 3,
		["Zunda Leaf"] = 2,
		locked = true,
	},
	["Fancy Pie"] = {
		Apple = 7,
		Wheat = 12,
		["Gold Ore"] = 2,
		locked = true,
	},
	["Zundamon's Banquet"] = {
		Wheat = 20,
		Apple = 10,
		["Gold Ore"] = 3,
		locked = true,
	},
	["Sweet Pea Cake"] = {
		["Sweet Pea"] = 4,
		Wheat = 10,
		["Zunda Pea"] = 3,
		locked = true,
	},
	["Pea Flower Tea"] = {
		["Pea Flower"] = 5,
		["Zunda Leaf"] = 3,
		locked = true,
	},
	["Ultimate Feast"] = {
		Wheat = 30,
		Apple = 20,
		["Gold Ore"] = 5,
		locked = true,
	},
	["Zunda Paradise"] = {
		["Zunda Pea"] = 15,
		["Edamame Pod"] = 10,
		["Sweet Pea"] = 5,
		["Pea Flower"] = 3,
		locked = true,
	},
}

-- Unlock conditions for recipes
CraftConfig.unlocks = {
	Cupcake = {
		requires_achievement = "q_sweet_tooth",
		or_player_level = 5,
	},
}

-- Helper: Get all unlocked recipes for a player level
function CraftConfig.getUnlockedRecipes(playerLevel: number, unlockedRecipeIds: { string }?)
	local unlocked = {}
	for recipeName, recipe in pairs(CraftConfig.recipes) do
		if not recipe.locked or (unlockedRecipeIds and table.find(unlockedRecipeIds, recipeName)) then
			table.insert(unlocked, recipeName)
		end
	end
	return unlocked
end

return CraftConfig

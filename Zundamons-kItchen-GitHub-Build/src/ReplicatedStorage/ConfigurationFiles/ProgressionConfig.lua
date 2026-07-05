-- [[ModuleScript] ProgressionConfig (ref: RBXCCF415BABD4146428AF46366C0A24A45)]]
local ProgressionConfig = {}

-- Progression Milestones: When you reach these, you unlock new content
-- Structure: { guests_served = X, gold_earned = X, unlocks = {recipes, cosmetics, furniture, locations}}

ProgressionConfig.milestones = {
	-- Tier 1: Starting tier (unlocks when player joins)
	[1] = {
		name = "Humble Baker",
		guests_served = 0,
		gold_earned = 0,
		unlocks = {
			recipes = { "Apple Pie", "Bread" }, -- Already exist in CraftConfig
			cosmetics = { "Chef Hat" },
			furniture = { "Basic Stove" },
			locations = { "Main Kitchen" },
		},
	},

	-- Tier 2: Intermediate (after serving 5 guests)
	[2] = {
		name = "Royal Chef",
		guests_served = 5,
		gold_earned = 0,
		unlocks = {
			recipes = { "Zunda Bread", "Royal Stew" },
			cosmetics = { "Chef Outfit", "Crown" },
			furniture = { "Fancy Stove", "Chandelier" },
			locations = { "Royal Dining Room" },
		},
	},

	-- Tier 3: Advanced (after serving 20 guests)
	[3] = {
		name = "Master Chef",
		guests_served = 20,
		gold_earned = 0,
		unlocks = {
			recipes = { "Fancy Pie", "Zundamon's Banquet" },
			cosmetics = { "Golden Chef Outfit", "Master's Badge" },
			furniture = { "Legendary Stove", "Throne" },
			locations = { "Zundamon's Banquet Hall" },
		},
	},

	-- Tier 4: Expert (after serving 50 guests)
	[4] = {
		name = "Legend",
		guests_served = 50,
		gold_earned = 0,
		unlocks = {
			recipes = { "Ultimate Feast" },
			cosmetics = { "Legendary Crown" },
			furniture = { "Crystal Stove" },
			locations = {},
		},
	},
}

-- Recipe unlock requirements (alternative path: unlock by gold earned)
-- If a recipe isn't in milestones, check here
ProgressionConfig.recipe_unlock_costs = {
	["Apple Pie"] = { guests_needed = 0, gold_needed = 0 }, -- starter
	["Bread"] = { guests_needed = 0, gold_needed = 0 }, -- starter
	["Zunda Bread"] = { guests_needed = 5, gold_needed = 0 },
	["Royal Stew"] = { guests_needed = 5, gold_needed = 50 },
	["Fancy Pie"] = { guests_needed = 20, gold_needed = 100 },
	["Zundamon's Banquet"] = { guests_needed = 20, gold_needed = 150 },
	["Ultimate Feast"] = { guests_needed = 50, gold_needed = 300 },
}

-- Guest preferences: what recipes different guests want and how much they'll pay
ProgressionConfig.guest_preferences = {
	{
		name = "Hungry Traveler",
		preferred_recipes = { "Apple Pie", "Bread" },
		pay_range = { 20, 35 },
	},
	{
		name = "Royal Noble",
		preferred_recipes = { "Royal Stew", "Fancy Pie", "Zunda Bread" },
		pay_range = { 50, 75 },
	},
	{
		name = "Zundamon Enthusiast",
		preferred_recipes = { "Zunda Bread", "Zundamon's Banquet" },
		pay_range = { 40, 60 },
	},
	{
		name = "Banquet Master",
		preferred_recipes = { "Ultimate Feast", "Zundamon's Banquet" },
		pay_range = { 100, 150 },
	},
}

-- Guest spawn settings
ProgressionConfig.guest_settings = {
	spawn_interval_min = 30, -- minimum seconds between guest spawns
	spawn_interval_max = 60, -- maximum seconds between guest spawns
	guest_patience = 45, -- seconds before guest leaves if not served
	max_guests_at_once = 3, -- max concurrent guests in the kitchen
}

return ProgressionConfig

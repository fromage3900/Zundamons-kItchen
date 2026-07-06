-- [[ModuleScript] QuestConfig]]
-- Data-driven quest definitions for QuestManager

-- Quest types
-- daily: rotates, resets at midnight
-- weekly: persists until claimed
-- achievements: one-time unlock

local QuestConfig = {}

QuestConfig.daily = {
	{
		id = "q_harvest_daily",
		title = "Daily Harvest",
		desc = "Gather 10 materials",
		goal = 10,
		metric = "totalGather",
		reward = { gold = 50, xp = 100 },
		icon = "🌿",
	},
	{
		id = "q_cook_daily",
		title = "Daily Cooking",
		desc = "Craft 3 dishes",
		goal = 3,
		metric = "craft",
		reward = { gold = 75, xp = 150 },
		icon = "🍳",
	},
	{
		id = "q_serve_daily",
		title = "Daily Service",
		desc = "Serve 5 guests",
		goal = 5,
		metric = "guestsServed",
		reward = { gold = 100, xp = 200 },
		icon = "🧑‍🍳",
	},
}

QuestConfig.weekly = {
	{
		id = "q_combo_master",
		title = "Combo Master",
		desc = "Reach a 10x combo",
		goal = 10,
		metric = "maxCombo",
		reward = { gold = 500, xp = 1000, unlock = "secret_recipe" },
		icon = "🔥",
	},
	{
		id = "q_master_chef",
		title = "Master Chef",
		desc = "Get 5 perfect crafts",
		goal = 5,
		metric = "perfectCooks",
		reward = { gold = 300, xp = 500 },
		icon = "⭐",
	},
}

QuestConfig.achievements = {
	{
		id = "q_first_harvest",
		title = "First Harvest",
		desc = "Gather your first material",
		goal = 1,
		metric = "totalGather",
		reward = { gold = 25, xp = 50 },
		icon = "🌱",
	},
	{
		id = "q_wealthy",
		title = "Wealthy Chef",
		desc = "Earn 10,000 gold",
		goal = 10000,
		metric = "totalGold",
		reward = { gold = 1000, xp = 500 },
		icon = "💰",
	},
	{
		id = "q_sweet_tooth",
		title = "Sweet Tooth",
		desc = "Unlock: Cupcake recipe",
		goal = 1,
		metric = "guestsServed",
		reward = { unlock = "Cupcake" },
		icon = "🧁",
	},
}

-- Seasonal ingredients (time-based recipe variants)
QuestConfig.seasonal = {
	summer = {
		["Summer Salad"] = {
			baseRecipe = "Bread",
			addIngredient = "Zunda Berry",
			priceMultiplier = 1.5,
			xpMultiplier = 1.2,
			seasonalIcon = "☀️",
		},
	},
	winter = {
		["Warm Stew"] = {
			baseRecipe = "Royal Stew",
			addIngredient = "Gold Ore",
			priceMultiplier = 2.0,
			xpMultiplier = 1.5,
			seasonalIcon = "❄️",
		},
	},
}

return QuestConfig

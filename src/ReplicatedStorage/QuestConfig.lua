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
		level = 1,
	},
	{
		id = "q_zunda_apprentice",
		title = "Zunda Apprentice",
		desc = "Reach chef level 5",
		goal = 5,
		metric = "chefLevel",
		reward = { unlock = "Zundapal dialogue unlocked" },
		icon = "🍙",
		level = 5,
	},
	{
		id = "q_harvest_master",
		title = "Harvest Master",
		desc = "Gather 100 materials",
		goal = 100,
		metric = "totalGather",
		reward = { gold = 500, xp = 250 },
		icon = "🌿",
		level = 10,
	},
	{
		id = "q_cooking_journey",
		title = "Cooking Journey",
		desc = "Craft 50 dishes",
		goal = 50,
		metric = "craft",
		reward = { gold = 300, xp = 300 },
		icon = "🍳",
		level = 12,
	},
	{
		id = "q_combo_ace",
		title = "Combo Ace",
		desc = "Reach 15x combo",
		goal = 15,
		metric = "maxCombo",
		reward = { gold = 750, xp = 500 },
		icon = "🔥",
		level = 15,
	},
	{
		id = "q_companion_bond",
		title = "Companion Bond",
		desc = "Click companions 50 times",
		goal = 50,
		metric = "companionClicks",
		reward = { gold = 200, xp = 400 },
		icon = "💝",
		level = 18,
	},
	{
		id = "q_seasonal_chef",
		title = "Seasonal Chef",
		desc = "Craft both seasonal dishes",
		goal = 2,
		metric = "seasonalCrafts",
		reward = { gold = 1000, xp = 600 },
		icon = "🍂",
		level = 22,
	},
	{
		id = "q_perfectionist",
		title = "Perfectionist",
		desc = "Get 20 perfect crafts",
		goal = 20,
		metric = "perfectCooks",
		reward = { gold = 1500, xp = 800 },
		icon = "✨",
		level = 25,
	},
	{
		id = "q_wealthy_millionaire",
		title = "Millionaire Chef",
		desc = "Earn 50,000 gold",
		goal = 50000,
		metric = "totalGold",
		reward = { gold = 2000, xp = 1000 },
		icon = "💰",
		level = 30,
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

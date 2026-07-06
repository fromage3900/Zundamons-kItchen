--!strict
-- [[ModuleScript] ProgressionConfig]]
-- Shared progression values for server systems

local ProgressionConfig = {}

-- XP rewards per action
ProgressionConfig.xp = {
	serve = 15,
	craft = 10,
	craftPerfect = 25,
	gather = 5,
	login = 20,
}

-- Guest pay amounts by recipe (base)
ProgressionConfig.pay = {
	Bread = 10,
	["Apple Pie"] = 25,
	["Zunda Bread"] = 30,
	Cupcake = 35,
	["Zunda Mochi"] = 40,
	["Royal Stew"] = 100,
	["Salted Pea Bouquet"] = 50,
}

-- Guest personality templates for spawn variety
ProgressionConfig.guest_preferences = {
	{
		name = "Hopeful Visitor",
		pay_range = { 12, 20 },
		preferred_recipes = { "Bread", "Apple Pie" },
	},
	{
		name = "Food Critic",
		pay_range = { 40, 60 },
		preferred_recipes = { "Zunda Mochi", "Royal Stew", "Zunda Bread" },
	},
	{
		name = "Regular Customer",
		pay_range = { 18, 28 },
		preferred_recipes = { "Bread", "Zunda Bread" },
	},
	{
		name = "Picnic Guest",
		pay_range = { 30, 45 },
		preferred_recipes = { "Cupcake", "Apple Pie" },
	},
}

-- Guest spawning settings
ProgressionConfig.guest_settings = {
	max_guests_at_once = 6,
	spawn_interval_min = 12,
	spawn_interval_max = 25,
	guest_patience = 120, -- seconds before guest leaves
	patience_warning = 30, -- seconds left before warning color
	patience_critical = 10, -- seconds left before critical color
}

-- Guest patience UI colors
ProgressionConfig.patience_colors = {
	normal = Color3.fromRGB(120, 200, 120), -- green
	warning = Color3.fromRGB(220, 180, 80), -- yellow
	critical = Color3.fromRGB(220, 80, 80), -- red
}

-- Progression milestones (tier unlocks)
ProgressionConfig.milestones = {
	{
		name = "Village Loop",
		guests_served = 0,
		unlocks = {
			recipes = { "Bread", "Apple Pie" },
			cosmetics = {},
			furniture = {},
			locations = {},
		},
	},
	{
		name = "Kitchen Garden",
		guests_served = 15,
		unlocks = {
			recipes = { "Zunda Bread" },
			cosmetics = {},
			furniture = {},
			locations = {},
		},
	},
	{
		name = "Garden Mastery",
		guests_served = 40,
		unlocks = {
			recipes = { "Zunda Mochi" },
			cosmetics = {},
			furniture = {},
			locations = {},
		},
	},
	{
		name = "Promenade Market",
		guests_served = 100,
		unlocks = {
			recipes = { "Cupcake" },
			cosmetics = {},
			furniture = {},
			locations = {},
		},
	},
}

return ProgressionConfig

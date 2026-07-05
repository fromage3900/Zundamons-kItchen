-- [[ModuleScript] DecorationConfig (ref: RBX6F0E1238DEC14B5A8344D250D5F07D12)]]
-- DecorationConfig: Items players can place in their Garden or Cottage Plot
-- To add a new decoration: add an entry to garden_items or cottage_items.
-- Fields: id, name, price, description, modelName, zone ("garden"|"cottage"|"both")

local DecorationConfig = {}

-- ============================================================
-- GARDEN DECORATIONS
-- ============================================================
DecorationConfig.garden_items = {
	{
		id = "pink_tulips",
		name = "Pink Tulips",
		description = "A bunch of cheerful pink tulips!",
		modelName = "PinkTulips",
		price = 15,
		tier = 1,
		zone = "garden",
		icon = "🌷",
	},
	{
		id = "stone_lantern",
		name = "Stone Lantern",
		description = "Light up the garden at night.",
		modelName = "StoneLantern",
		price = 40,
		tier = 1,
		zone = "garden",
		icon = "🏮",
	},
	{
		id = "garden_bench",
		name = "Garden Bench",
		description = "A cozy wooden bench for relaxing.",
		modelName = "GardenBench",
		price = 60,
		tier = 1,
		zone = "garden",
		icon = "🪑",
	},
	{
		id = "fountain",
		name = "Mini Fountain",
		description = "A decorative stone fountain with running water.",
		modelName = "MiniFountain",
		price = 120,
		tier = 2,
		zone = "garden",
		icon = "⛲",
	},
	{
		id = "cherry_tree",
		name = "Cherry Blossom Tree",
		description = "A beautiful pink blossom tree!",
		modelName = "CherryTree",
		price = 200,
		tier = 2,
		zone = "garden",
		icon = "🌸",
	},
}

-- ============================================================
-- COTTAGE / PLOT DECORATIONS
-- ============================================================
DecorationConfig.cottage_items = {
	{
		id = "wooden_table",
		name = "Wooden Table",
		description = "A simple wooden table for your cottage.",
		modelName = "WoodenTable",
		price = 30,
		tier = 1,
		zone = "cottage",
		icon = "🪑",
	},
	{
		id = "bookshelf",
		name = "Bookshelf",
		description = "Fill it with your favourite recipes!",
		modelName = "Bookshelf",
		price = 50,
		tier = 1,
		zone = "cottage",
		icon = "📚",
	},
	{
		id = "window_box",
		name = "Window Flower Box",
		description = "Attach pink flowers to your cottage windows.",
		modelName = "WindowBox",
		price = 35,
		tier = 1,
		zone = "cottage",
		icon = "🌺",
	},
	{
		id = "fireplace",
		name = "Stone Fireplace",
		description = "Warm up your cottage with a crackling fire.",
		modelName = "Fireplace",
		price = 150,
		tier = 2,
		zone = "cottage",
		icon = "🔥",
	},
	{
		id = "fancy_bed",
		name = "Fancy Bed",
		description = "Sleep in style after a long day serving guests!",
		modelName = "FancyBed",
		price = 180,
		tier = 2,
		zone = "cottage",
		icon = "🛏️",
	},
	{
		id = "trophy_shelf",
		name = "Trophy Shelf",
		description = "Display your tier badges and achievements.",
		modelName = "TrophyShelf",
		price = 250,
		tier = 3,
		zone = "cottage",
		icon = "🏆",
	},
}

return DecorationConfig

--!strict
-- [[ModuleScript] ScatterConfig (ref: NEW)]]
-- Biome and placement configuration for procedural node scattering.
-- Pattern adapted from env-portfolio PCG scatter chain:
--   Sampler → Exclusion → Density Filter → Self Prune → Transform → Spawn

local ScatterConfig = {
	biomes = {
		zunda_forest = {
			display = "Zunda Forest",
			node_types = {
				ZundaFlower = {
					resourceType = "ZundaFlower",
					density = 0.35,
					spacing = 10,
					variants = { "ZundaFlower_Default", "ZundaFlower_Rare" },
					variantWeights = { 0.7, 0.3 },
					scaleRange = { 0.8, 1.2 },
					yOffset = 0,
					yRotationRandom = true,
					spinSpeed = 0.5, -- Cute idle spin!
				},
				ZundaPea = {
					resourceType = "ZundaPea",
					density = 0.30,
					spacing = 12,
					variants = { "ZundaPea_01", "ZundaPea_02", "ZundaPea_03" },
					variantWeights = { 0.5, 0.3, 0.2 },
					scaleRange = { 0.95, 1.05 },
					yOffset = -0.1,
					yRotationRandom = true,
					swayAnimation = true, -- Gentle pink sway for coziness
				},
				["Zunda Mushroom"] = {
					resourceType = "Zunda Mushroom",
					density = 0.15,
					spacing = 18,
					variants = { "Mushroom_01", "Mushroom_02" },
					variantWeights = { 0.6, 0.4 },
					scaleRange = { 0.7, 1.3 },
					yOffset = 0,
					bobAnimation = true, -- Cute up/down bob!
				},
				["Zunda Berry"] = {
					resourceType = "Zunda Berry",
					density = 0.30,
					spacing = 8,
					variants = { "BerryBush_01", "BerryBush_02", "BerryBush_03" },
					variantWeights = { 0.5, 0.3, 0.2 },
					scaleRange = { 0.85, 1.15 },
					yOffset = 0,
					glowWhenNear = true, -- Sparkle when player approaches!
				},
				["Zunda Root"] = {
					resourceType = "Zunda Root",
					density = 0.12,
					spacing = 20,
					variants = { "Root_01", "Root_02" },
					variantWeights = { 0.65, 0.35 },
					scaleRange = { 0.9, 1.1 },
					yOffset = -0.5,
				},
			},
			exclusion_tags = { "Path", "Building", "Water", "Plot" },
			voxel_size = 12,
			max_slope = 45,
			seed = 4242,
		},

		mineable_foothills = {
			display = "Mineable Foothills",
			node_types = {
				Rock = {
					resourceType = "Rock",
					density = 0.20,
					spacing = 16,
					variants = { "Rock_Common", "Rock_Rare" },
					variantWeights = { 0.8, 0.2 },
					scaleRange = { 0.8, 1.4 },
					yOffset = -0.3,
					crackStages = 3, -- Visual feedback on harvest!
				},
				["Gold Ore"] = {
					resourceType = "Gold Ore",
					density = 0.05,
					spacing = 30,
					variants = { "GoldOre_Default" },
					variantWeights = { 1.0 },
					scaleRange = { 0.9, 1.1 },
					yOffset = -0.3,
					glowColor = Color3.fromRGB(255, 215, 0), -- Golden sparkle!
				},
			},
			exclusion_tags = { "Path", "Building", "Water", "Plot" },
			voxel_size = 18,
			max_slope = 60,
			seed = 5150,
		},

		kitchen_garden = {
			display = "Kitchen Garden",
			node_types = {
				Wheat = {
					resourceType = "Wheat",
					density = 0.40,
					spacing = 6,
					variants = { "Wheat_01", "Wheat_02", "Wheat_03" },
					variantWeights = { 0.33, 0.33, 0.34 },
					scaleRange = { 0.9, 1.1 },
					yOffset = 0,
					swayRange = { min = 0.8, max = 1.2 }, -- Gentle wheat sway
				},
			},
			exclusion_tags = { "Building", "Path" },
			voxel_size = 8,
			max_slope = 15,
			seed = 4243,
		},
	},

	defaults = {
		exclusion_tag = "ScatterExclude",
		max_placement_attempts = 50,
		spawn_height_offset = 2.5,
		spawn_radius = 1.5,
	},

	-- Cozy flavor text for node discovery
	discoveryHints = {
		ZundaFlower = "A gentle flower that glows with morning dew~ 🌼",
		ZundaPea = "Plump green peas that sparkle pink! 🫛",
		["Zunda Mushroom"] = "Tiny mushrooms that dance in the shade 🍄",
		["Zunda Berry"] = "Sweet berries that blush when you approach 🍓",
		["Zunda Root"] = "Mystery roots that hum softly when dug 🌱",
		Rock = "Ordinary rock with ordinary sparkles ⛰",
		["Gold Ore"] = "Shiny ore that gleams like treasure! ✨",
		Wheat = "Golden wheat swaying in the breeze 🌾",
	},
}

return ScatterConfig

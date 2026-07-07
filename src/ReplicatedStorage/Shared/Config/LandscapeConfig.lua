--!strict
-- Shared biome and asset placement definitions for procedural landscape generation.

local LandscapeConfig = {}

LandscapeConfig.biomes = {
	GardenVillage = {
		name = "GardenVillage",
		description = "A cozy village courtyard with paths, market lots, and garden clusters.",
		seed = 42,
		zones = {
			{ name = "Plaza", type = "central", size = 18, weight = 1.0, maxBuildings = 2, spawnProfile = "plaza" },
			{ name = "GardenEdge", type = "garden", size = 24, weight = 0.9, maxBuildings = 1, spawnProfile = "garden" },
			{ name = "MarketRow", type = "street", size = 16, weight = 0.8, maxBuildings = 3, spawnProfile = "market" },
			{ name = "PathLoop", type = "path", size = 12, weight = 0.6, maxBuildings = 0, spawnProfile = "path" },
		},
		assetProfiles = {
			plaza = {
				{ asset = "MarketHall", category = "buildings", weight = 0.55, required = true },
				{ asset = "StreetLamp", category = "street_props", weight = 0.8 },
				{ asset = "Bench", category = "street_props", weight = 0.7 },
			},
			garden = {
				{ asset = "ZundaFlower", category = "foliage", weight = 0.9 },
				{ asset = "BerryBush", category = "foliage", weight = 0.7 },
				{ asset = "ZundaMushroom", category = "foliage", weight = 0.4 },
			},
			market = {
				{ asset = "BakeryStall", category = "buildings", weight = 0.8 },
				{ asset = "StreetLamp", category = "street_props", weight = 0.9 },
			},
			path = {
				{ asset = "StreetLamp", category = "street_props", weight = 0.6 },
				{ asset = "Bench", category = "street_props", weight = 0.5 },
			},
		},
		constraints = {
			pathSpacing = 6,
			minBuildingGap = 8,
			maxClusterSize = 5,
		},
	},
}

function LandscapeConfig.getBiome(name)
	if not name then
		return LandscapeConfig.biomes.GardenVillage
	end

	return LandscapeConfig.biomes[name] or LandscapeConfig.biomes.GardenVillage
end

return LandscapeConfig

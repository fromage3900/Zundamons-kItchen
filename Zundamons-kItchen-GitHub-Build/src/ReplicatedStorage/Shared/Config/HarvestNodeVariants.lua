-- Harvest Node Variants Configuration
-- FBX substitutes available in Downloads:\kenney_survival-kit\Models\FBX format\
-- Rock/Grass can substitute for plants; see docs/asset-mapping.md for full list
local Variants = {
	Wheat = {
		meshes = {
			["Wheat_01"] = "rbxassetid://FILL_WHEAT_01", -- grass.fbx substitute
			["Wheat_02"] = "rbxassetid://FILL_WHEAT_02", -- grass-large.fbx substitute
			["Wheat_03"] = "rbxassetid://FILL_WHEAT_03", -- grass.fbx variant
		},
		resourceType = "Wheat",
		swayRange = { min = 0.8, max = 1.2 },
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.9, 1.1 },
	},

	ZundaFlower = {
		meshes = {
			["ZundaFlower_Default"] = "rbxassetid://FILL_ZUNDAFLOWER_DEFAULT",
			["ZundaFlower_Rare"] = "rbxassetid://FILL_ZUNDAFLOWER_RARE",
		},
		resourceType = "ZundaFlower",
		spinSpeed = 0.5,
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.8, 1.2 },
	},

	ZundaPea = {
		meshes = {
			["ZundaPea_01"] = "rbxassetid://FILL_ZUNDAPEA_01",
			["ZundaPea_02"] = "rbxassetid://FILL_ZUNDAPEA_02",
			["ZundaPea_03"] = "rbxassetid://FILL_ZUNDAPEA_03",
		},
		resourceType = "ZundaPea",
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.9, 1.1 },
	},

	["Zunda Mushroom"] = {
		meshes = {
			["Mushroom_01"] = "rbxassetid://FILL_MUSHROOM_01",
			["Mushroom_02"] = "rbxassetid://FILL_MUSHROOM_02",
		},
		resourceType = "Zunda Mushroom",
		bobHeight = 0.3,
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.7, 1.3 },
	},

	["Zunda Berry"] = {
		meshes = {
			["BerryBush_01"] = "rbxassetid://FILL_BERRY_01",
			["BerryBush_02"] = "rbxassetid://FILL_BERRY_02",
			["BerryBush_03"] = "rbxassetid://FILL_BERRY_03",
		},
		resourceType = "Zunda Berry",
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.85, 1.15 },
	},

	["Zunda Root"] = {
		meshes = {
			["Root_01"] = "rbxassetid://FILL_ROOT_01",
			["Root_02"] = "rbxassetid://FILL_ROOT_02",
		},
		resourceType = "Zunda Root",
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.9, 1.1 },
	},

	Rock = {
		meshes = {
			["Rock_Common"] = "rbxassetid://FILL_ROCK_COMMON",
			["Rock_Rare"] = "rbxassetid://FILL_ROCK_RARE",
		},
		resourceType = "Rock",
		crackStages = 3,
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.8, 1.4 },
	},

	["Gold Ore"] = {
		meshes = {
			["GoldOre_Default"] = "rbxassetid://FILL_GOLDORE_DEFAULT",
		},
		resourceType = "Gold Ore",
		glowColor = Color3.fromRGB(255, 215, 0),
		harvestEffect = "rbxasset://textures/particles/sparkle_main.dds",
		scaleRange = { 0.9, 1.1 },
	},
}

function Variants.getMesh(nodeType: string, variantId: string?): string
	local config = Variants[nodeType]
	if not config then
		return ""
	end
	if variantId and config.meshes[variantId] then
		return config.meshes[variantId]
	end
	for _, meshId in pairs(config.meshes) do
		return meshId
	end
	return ""
end

function Variants.getVariantIds(nodeType: string): { string }
	local config = Variants[nodeType]
	if not config then
		return {}
	end
	local ids: { string } = {}
	for id, _ in pairs(config.meshes) do
		table.insert(ids, id)
	end
	return ids
end

function Variants.getScaleRange(nodeType: string): { number }
	local config = Variants[nodeType]
	if not config then
		return { 1, 1 }
	end
	return config.scaleRange
end

return Variants

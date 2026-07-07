-- WIRE ASSETS SCRIPT - Run in Roblox Studio Command Bar
-- This script will wire imported harvest node meshes to their variant IDs

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create HarvestNodes folder structure if missing
local function ensureFolder(path)
	local current = ReplicatedStorage
	for _, name in ipairs(string.split(path, "/")) do
		local child = current:FindFirstChild(name)
		if not child then
			child = Instance.new("Folder")
			child.Name = name
			child.Parent = current
		end
		current = child
	end
	return current
end

-- Asset mappings based on pipeline JSON specs
local assetMappings = {
	Wheat = {
		Wheat_01 = { color = "#90EE50", description = "Short green wheat" },
		Wheat_02 = { color = "#DAA520", description = "Medium golden wheat" },
		Wheat_03 = { color = "#FFD700", description = "Tall ripe wheat" },
	},
	ZundaFlower = {
		ZundaFlower_Default = { color = "#78C882", description = "Standard Zunda flower" },
		ZundaFlower_Rare = { color = "#E1B9FF", description = "Rare lavender flower" },
	},
	ZundaPea = {
		ZundaPea_01 = { color = "#96E6A0", description = "Small closed pea pod" },
		ZundaPea_02 = { color = "#82D68C", description = "Medium open pea pod" },
		ZundaPea_03 = { color = "#FFD700", description = "Large golden pea pod" },
	},
	["Zunda Mushroom"] = {
		Mushroom_01 = { color = "#E1B9FF", description = "Small lavender mushroom" },
		Mushroom_02 = { color = "#FFB5D4", description = "Tall pink mushroom" },
	},
	["Zunda Berry"] = {
		BerryBush_01 = { color = "#78C882", berryColor = "#4A90D9" },
		BerryBush_02 = { color = "#78C882", berryColor = "#FF69B4" },
		BerryBush_03 = { color = "#78C882", berryColor = "#FFD700" },
	},
	["Zunda Root"] = {
		Root_01 = { color = "#8B6514", description = "Short gnarled root" },
		Root_02 = { color = "#A0782C", description = "Long twisted root" },
	},
	Rock = {
		Rock_Common = { color = "#808080", description = "Grey rounded rock" },
		Rock_Rare = { color = "#4A4A4A", description = "Dark rock with crystals" },
	},
	["Gold Ore"] = {
		GoldOre_Default = { color = "#8B4513", description = "Gold vein rock" },
	},
}

-- Create all folders
for nodeType, _ in pairs(assetMappings) do
	ensureFolder("HarvestNodes/" .. nodeType)
end

print("Harvest node folders created/verified in ReplicatedStorage")

-- Create placeholder parts with mesh IDs (you'll replace with actual imports)
for nodeType, variants in pairs(assetMappings) do
	local folder = ReplicatedStorage.HarvestNodes:FindFirstChild(nodeType)
	if folder then
		for variantId, props in pairs(variants) do
			local existing = folder:FindFirstChild(variantId)
			if not existing then
				local part = Instance.new("Part")
				part.Name = variantId
				part.Anchored = true
				part.CanCollide = false
				part.Size = Vector3.new(2, 2, 2)
				part.Transparency = 0.5

				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.Sphere
				mesh.Parent = part

				part.Parent = folder
				print("Created placeholder: " .. nodeType .. "/" .. variantId)
			end
		end
	end
end

print("\n=== NEXT STEPS ===")
print("1. Import your FBX/OBJ meshes into the HarvestNodes folders")
print("2. Replace placeholder meshes with imported ones")
print("3. Run get_asset_ids.luau to print asset IDs")
print("4. Update MeshAssets.lua with the rbxassetid:// values")

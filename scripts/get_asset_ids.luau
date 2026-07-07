-- Run this in Roblox Studio Command Bar after importing assets
-- It will print the rbxassetid:// values for all harvest node meshes

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getMeshAssetIds(folder)
	local ids = {}
	for _, child in pairs(folder:GetDescendants()) do
		if child:IsA("MeshPart") or child:IsA("SpecialMesh") then
			if child.MeshId and child.MeshId ~= "" then
				table.insert(ids, { name = child.Name, meshId = child.MeshId })
			end
		end
	end
	return ids
end

local function scanFolder(path)
	local fullPath = ReplicatedStorage
	for _, part in ipairs(string.split(path, "/")) do
		fullPath = fullPath:FindFirstChild(part)
		if not fullPath then
			return nil
		end
	end
	return fullPath
end

-- Print all mesh asset IDs
print("=== HARVEST NODE ASSET IDS ===")
for _, nodeType in ipairs({
	"HarvestNodes/Wheat",
	"HarvestNodes/ZundaFlower",
	"HarvestNodes/ZundaPea",
	"HarvestNodes/ZundaMushroom",
	"HarvestNodes/ZundaBerry",
	"HarvestNodes/ZundaRoot",
	"HarvestNodes/Rock",
	"HarvestNodes/GoldOre",
}) do
	local folder = scanFolder(nodeType)
	if folder then
		print("\n" .. nodeType .. ":")
		for _, asset in pairs(getMeshAssetIds(folder)) do
			print(string.format('  %s = "%s",', asset.name, asset.meshId))
		end
	else
		print("\n" .. nodeType .. ": NOT FOUND")
	end
end

-- Print NPC/Companion IDs
print("\n=== NPC/COMPANION ASSET IDS ===")
local npcs = ReplicatedStorage:FindFirstChild("NPCs")
if npcs then
	for _, npc in pairs(getMeshAssetIds(npcs)) do
		print(string.format('  %s = "%s",', npc.name, npc.meshId))
	end
end

local companions = ReplicatedStorage:FindFirstChild("Companions")
if companions then
	for _, companion in pairs(getMeshAssetIds(companions)) do
		print(string.format('  %s = "%s",', companion.name, companion.meshId))
	end
end

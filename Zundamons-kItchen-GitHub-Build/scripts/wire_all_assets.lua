-- HARVEST NODE ASSET WIRING - FINAL SCRIPT
-- Run this in Roblox Studio after importing assets to auto-wire everything

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Asset registry that maps variant names to mesh IDs
local AssetRegistry = {
	-- Harvest Nodes
	Wheat = {
		Wheat_01 = "PASTE_MESH_ID_HERE",
		Wheat_02 = "PASTE_MESH_ID_HERE",
		Wheat_03 = "PASTE_MESH_ID_HERE",
	},
	ZundaFlower = {
		ZundaFlower_Default = "PASTE_MESH_ID_HERE",
		ZundaFlower_Rare = "PASTE_MESH_ID_HERE",
	},
	ZundaPea = {
		ZundaPea_01 = "PASTE_MESH_ID_HERE",
		ZundaPea_02 = "PASTE_MESH_ID_HERE",
		ZundaPea_03 = "PASTE_MESH_ID_HERE",
	},
	["Zunda Mushroom"] = {
		Mushroom_01 = "PASTE_MESH_ID_HERE",
		Mushroom_02 = "PASTE_MESH_ID_HERE",
	},
	["Zunda Berry"] = {
		BerryBush_01 = "PASTE_MESH_ID_HERE",
		BerryBush_02 = "PASTE_MESH_ID_HERE",
		BerryBush_03 = "PASTE_MESH_ID_HERE",
	},
	["Zunda Root"] = {
		Root_01 = "PASTE_MESH_ID_HERE",
		Root_02 = "PASTE_MESH_ID_HERE",
	},
	Rock = {
		Rock_Common = "PASTE_MESH_ID_HERE",
		Rock_Rare = "PASTE_MESH_ID_HERE",
	},
	["Gold Ore"] = {
		GoldOre_Default = "PASTE_MESH_ID_HERE",
	},
}

-- Helper to find mesh parts and print their IDs
local function auditImportedAssets()
	print("=== IMPORTED ASSETS AUDIT ===")

	-- Check HarvestNodes folder
	for nodeType, variants in pairs(AssetRegistry) do
		local folder = ReplicatedStorage:FindFirstChild("HarvestNodes")
		if folder then
			folder = folder:FindFirstChild(nodeType)
			if folder then
				print("\n" .. nodeType .. ":")
				for _, variant in pairs(folder:GetChildren()) do
					if variant:IsA("MeshPart") then
						print("  " .. variant.Name .. " = " .. variant.MeshId)
					elseif variant:IsA("Part") and variant:FindFirstChildOfClass("SpecialMesh") then
						local mesh = variant:FindFirstChildOfClass("SpecialMesh")
						if mesh.MeshId ~= "" then
							print("  " .. variant.Name .. " = " .. mesh.MeshId)
						end
					end
				end
			end
		end
	end

	-- Check Companions/NPCs
	local npcs = ReplicatedStorage:FindFirstChild("NPCs")
	if npcs then
		print("\nNPCs:")
		for _, npc in pairs(npcs:GetChildren()) do
			if npc:IsA("MeshPart") then
				print("  " .. npc.Name .. " = " .. npc.MeshId)
			end
		end
	end

	local companions = ReplicatedStorage:FindFirstChild("Companions")
	if companions then
		print("\nCompanions:")
		for _, companion in pairs(companions:GetChildren()) do
			if companion:IsA("MeshPart") then
				print("  " .. companion.Name .. " = " .. companion.MeshId)
			end
		end
	end
end

-- Copy this output to update MeshAssets.lua
print("Run auditImportedAssets() to get mesh IDs")
print("Then update AssetRegistry with actual rbxassetid:// values")

return AssetRegistry

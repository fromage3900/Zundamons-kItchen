-- PASTE THIS INTO ROBlOX STUDIO COMMAND BAR (View → Command Bar)
-- Creates placeholder meshes for all Harvest Nodes
-- Import FBX files from Downloads/G: drives and replace the placeholder meshes

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create HarvestNodes folder
local harvestNodes = Instance.new("Folder")
harvestNodes.Name = "HarvestNodes"
harvestNodes.Parent = ReplicatedStorage

-- Mesh configurations based on asset-mapping.md
local meshConfigs = {
	Wheat = {
		variants = { "Wheat_01", "Wheat_02", "Wheat_03" },
		fbx_path = "kenney_tiny-farm/Tiles/tile_*.png (use as billboard or import grass.fbx)",
	},
	ZundaFlower = {
		variants = { "ZundaFlower_Default", "ZundaFlower_Rare" },
		fbx_path = "kenney_fantasy-town-kit_2.0/Models/FBX format/tree.fbx",
	},
	ZundaPea = {
		variants = { "ZundaPea_01", "ZundaPea_02", "ZundaPea_03" },
		fbx_path = "Generated from pipeline JSONs (need Blender FBX export)",
	},
	["Zunda Mushroom"] = {
		variants = { "Mushroom_01", "Mushroom_02" },
		fbx_path = "Generated from pipeline JSONs",
	},
	["Zunda Berry"] = {
		variants = { "BerryBush_01", "BerryBush_02", "BerryBush_03" },
		fbx_path = "kenney_fantasy-town-kit_2.0/Models/FBX format/hedge*.fbx",
	},
	["Zunda Root"] = {
		variants = { "Root_01", "Root_02" },
		fbx_path = "Generated from pipeline JSONs",
	},
	Rock = {
		variants = { "Rock_Common", "Rock_Rare" },
		fbx_path = "kenney_survival-kit/Models/FBX format/rock-*.fbx",
	},
	["Gold Ore"] = {
		variants = { "GoldOre_Default" },
		fbx_path = "kenney_survival-kit/Models/FBX format/rock-sand-*.fbx",
	},
}

local assetIds = {}

for nodeType, config in pairs(meshConfigs) do
	local folder = Instance.new("Folder")
	folder.Name = nodeType
	folder.Parent = harvestNodes

	for _, variantId in ipairs(config.variants) do
		-- Create a placeholder mesh part
		local part = Instance.new("Part")
		part.Name = variantId
		part.Anchored = true
		part.CanCollide = false
		part.Size = Vector3.new(2, 2, 2)
		part.Transparency = 0.5
		part.Material = Enum.Material.SmoothPlastic

		-- Add a mesh placeholder
		local mesh = Instance.new("SpecialMesh")
		mesh.MeshType = Enum.MeshType.Sphere
		mesh.Parent = part

		part.Parent = folder
		assetIds[variantId] = "FILL_" .. string.upper(nodeType:gsub("%s+", "")) .. "_" .. variantId:match("%d+")
	end
end

-- Create Companion folder
local companion = Instance.new("Folder")
companion.Name = "Companions"
companion.Parent = ReplicatedStorage

local zundapal = Instance.new("Part")
zundapal.Name = "Zundapal"
zundapal.Anchored = true
zundapal.CanCollide = false
zundapal.Size = Vector3.new(3, 3, 3)
zundapal.Transparency = 0.5
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.Head
mesh.Parent = zundapal
zundapal.Parent = companion
assetIds["Zundapal"] = "FILL_COMPANION_ZUNDAPAL"

-- Create NPC folder
local npcs = Instance.new("Folder")
npcs.Name = "NPCs"
npcs.Parent = ReplicatedStorage

for _, charName in ipairs({ "Child", "Adult", "Elder" }) do
	local npc = Instance.new("Part")
	npc.Name = charName .. "NPC"
	npc.Anchored = true
	npc.CanCollide = false
	npc.Size = Vector3.new(3, 5, 3)
	npc.Transparency = 0.5
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Head
	mesh.Parent = npc
	npc.Parent = npcs
end

print("=== HARVEST NODE MESHES CREATED ===")
print("Folder: ReplicatedStorage.HarvestNodes (+ Companions, NPCs)")
print("")
print("To import actual FBX files:")
print("1. Use Asset Manager (View → Asset Manager → Import)")
print("2. Select FBX files from:")
print("   - kenney_survival-kit/Models/FBX format/rock-*.fbx")
print("   - kenney_fantasy-town-kit_2.0/Models/FBX format/*.fbx")
print("   - G:\\ZUNDYMONSKITCHEN\\zundapalupdate2.fbx")
print("3. Replace placeholder meshes with imported meshes")
print("4. Map to placeholder IDs in HarvestNodeVariants.lua")

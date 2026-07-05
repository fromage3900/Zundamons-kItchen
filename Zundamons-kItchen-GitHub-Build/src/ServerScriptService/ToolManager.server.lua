-- [[Script] ToolManager (ref: RBXF13773EEB02243D3A8E4B844862B0E21)]]
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")

-- Get RemoteFunctions
local RF = RS:WaitForChild("RemoteFunctions")
local equipTool = RF:WaitForChild("EquipTool")
local requestData = RF:WaitForChild("RequestData")

-- Get tool configuration
local configFiles = RS:WaitForChild("ConfigurationFiles")
local toolsConfig = require(configFiles:WaitForChild("ToolsConfig"))

-- Initialize player data with starting tools
local function initializePlayerData(player)
	if not _G.data[player.Name] then
		_G.data[player.Name] = {}
	end
	
	-- Give player starting tools if they don't have any
	if not _G.data[player.Name].tools then
		_G.data[player.Name].tools = {
			["Axe"] = {Tier = "Tier1", Equiped = false},
			["PickAxe"] = {Tier = "Tier1", Equiped = false},
			["Sickle"] = {Tier = "Tier1", Equiped = false}
		}
	end
end

-- Handle tool equipping
local function handleEquipTool(player, toolName)
	-- Initialize data if needed
	initializePlayerData(player)
	
	-- Check if player has this tool
	if not _G.data[player.Name].tools or not _G.data[player.Name].tools[toolName] then
		return false
	end
	
	-- Unequip any currently equipped tool
	local character = player.Character
	if character then
		-- Remove any tools currently in the character
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") then
				child:Destroy()
			end
		end
		
		-- Mark all tools as unequipped in data
		for tool, data in pairs(_G.data[player.Name].tools) do
			data.Equiped = false
		end
		
		-- Find and clone the tool from StarterPack
		local toolToClone = nil
		for _, item in ipairs(game.StarterPack:GetChildren()) do
			if item:IsA("Tool") and item:GetAttribute("Type") == toolName then
				toolToClone = item
				break
			end
		end
		
		-- If tool found, equip it
		if toolToClone then
			local clonedTool = toolToClone:Clone()
			
			-- Copy CollectionService tags from original to clone (tags don't clone automatically)
			local CollectionService = game:GetService("CollectionService")
			for _, tag in ipairs(CollectionService:GetTags(toolToClone)) do
				CollectionService:AddTag(clonedTool, tag)
			end
			
			clonedTool.Parent = character
			_G.data[player.Name].tools[toolName].Equiped = true
			return true
		end
	end
	
	return false
end

-- Connect the RemoteFunction
equipTool.OnServerInvoke = handleEquipTool

-- Initialize data for players already in game
for _, player in ipairs(Players:GetPlayers()) do
	initializePlayerData(player)
end

-- Initialize data for new players
Players.PlayerAdded:Connect(initializePlayerData)
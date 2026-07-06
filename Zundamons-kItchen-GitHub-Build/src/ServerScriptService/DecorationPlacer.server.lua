-- DecorationPlacer: buy and place plot decorations from DecorationConfig.
-- Models expected at ServerStorage.Decorations[modelName] (Studio-authored).

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerDataService = require(script.Parent.Services.PlayerDataService)
local RemoteRateLimiter = require(script.Parent.Services.RemoteRateLimiter)
local DecorationConfig = require(RS.ConfigurationFiles.DecorationConfig)
local PlotConfig = require(RS.ConfigurationFiles.PlotConfig)
local PlacerConfig = require(RS.ConfigurationFiles.DecorationPlacerConfig)

local RE = RS:WaitForChild("RemoteEvents")
local notifyRE = RE:WaitForChild("NotifyPlayer")
local RF = RS:WaitForChild("RemoteFunctions")

local worldRoot: Folder

local function getWorldRoot(): Folder
	if worldRoot and worldRoot.Parent then
		return worldRoot
	end
	local existing = workspace:FindFirstChild(PlacerConfig.WORLD_FOLDER)
	if existing and existing:IsA("Folder") then
		worldRoot = existing
		return worldRoot
	end
	worldRoot = Instance.new("Folder")
	worldRoot.Name = PlacerConfig.WORLD_FOLDER
	worldRoot.Parent = workspace
	return worldRoot
end

local function findDecorationDef(decorationId: string)
	for _, item in ipairs(DecorationConfig.garden_items) do
		if item.id == decorationId then
			return item
		end
	end
	for _, item in ipairs(DecorationConfig.cottage_items) do
		if item.id == decorationId then
			return item
		end
	end
	return nil
end

local function playerGold(data: { [string]: any }): number
	return data.Gold or data.current_gold or 0
end

local function setPlayerGold(data: { [string]: any }, amount: number)
	data.Gold = amount
	data.current_gold = amount
end

local function ownsDecoration(data: { [string]: any }, decorationId: string): boolean
	if not data.owned_decorations then
		return false
	end
	return table.find(data.owned_decorations, decorationId) ~= nil
end

local function getPlotFolder(plotNum: number): Folder
	local root = getWorldRoot()
	local name = "Plot_" .. plotNum
	local folder = root:FindFirstChild(name)
	if folder and folder:IsA("Folder") then
		return folder
	end
	folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	return folder
end

local function clearPlotFolder(plotNum: number)
	local root = getWorldRoot()
	local folder = root:FindFirstChild("Plot_" .. plotNum)
	if folder then
		folder:ClearAllChildren()
	end
end

local function findModelTemplate(modelName: string): Instance?
	local folder = ServerStorage:FindFirstChild(PlacerConfig.MODEL_FOLDER)
	if not folder then
		return nil
	end
	return folder:FindFirstChild(modelName)
end

local function slotTaken(data: { [string]: any }, slot: number): boolean
	if not data.decoration_placements then
		return false
	end
	for _, placement in ipairs(data.decoration_placements) do
		if placement.slot == slot then
			return true
		end
	end
	return false
end

local function findPlacementOwner(plotNum: number): Player?
	for _, player in ipairs(Players:GetPlayers()) do
		local data = PlayerDataService.get(player)
		if data and data.owned_plot == plotNum then
			return player
		end
	end
	return nil
end

local function spawnPlacement(plotNum: number, slot: number, modelName: string, decorationId: string)
	local center = PlotConfig.PLOT_CENTERS[plotNum]
	local offset = PlacerConfig.SLOT_OFFSETS[slot]
	if not center or not offset then
		return false, "Invalid plot slot"
	end

	local template = findModelTemplate(modelName)
	if not template then
		return false, "Model missing in ServerStorage." .. PlacerConfig.MODEL_FOLDER .. "." .. modelName
	end

	local plotFolder = getPlotFolder(plotNum)
	local slotName = "Slot_" .. slot
	local existing = plotFolder:FindFirstChild(slotName)
	if existing then
		existing:Destroy()
	end

	local clone = template:Clone()
	clone.Name = slotName
	clone:SetAttribute("DecorationId", decorationId)
	clone:SetAttribute("PlotNumber", plotNum)
	clone:SetAttribute("Slot", slot)

	local targetPos = center + offset + Vector3.new(0, PlacerConfig.PLACE_Y_OFFSET, 0)
	if clone:IsA("Model") then
		if not clone.PrimaryPart then
			clone.PrimaryPart = clone:FindFirstChildWhichIsA("BasePart", true)
		end
		if clone.PrimaryPart then
			clone:PivotTo(CFrame.new(targetPos))
		end
	elseif clone:IsA("BasePart") then
		clone.CFrame = CFrame.new(targetPos)
	end

	for _, part in ipairs(clone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = true
		end
	end
	if clone:IsA("BasePart") then
		clone.Anchored = true
	end

	clone.Parent = plotFolder
	return true
end

local function restorePlotDecorations(player: Player)
	local data = PlayerDataService.get(player)
	if not data or not data.owned_plot then
		return
	end

	local plotNum = data.owned_plot
	clearPlotFolder(plotNum)

	if not data.decoration_placements then
		return
	end

	for _, placement in ipairs(data.decoration_placements) do
		local def = findDecorationDef(placement.id)
		if def then
			spawnPlacement(plotNum, placement.slot, def.modelName, placement.id)
		end
	end
end

local function buyDecoration(player: Player, decorationId: string)
	if not RemoteRateLimiter.allow(player, "buyDecoration", 0.5) then
		return { success = false, message = "Slow down" }
	end
	if type(decorationId) ~= "string" then
		return { success = false, message = "Invalid decoration id" }
	end

	local def = findDecorationDef(decorationId)
	if not def then
		return { success = false, message = "Unknown decoration" }
	end

	local data = PlayerDataService.get(player)
	if not data then
		return { success = false, message = "Data not ready" }
	end

	if ownsDecoration(data, decorationId) then
		return { success = false, message = "You already own this decoration" }
	end

	local gold = playerGold(data)
	if gold < def.price then
		return { success = false, message = "Need " .. def.price .. " gold (you have " .. gold .. ")" }
	end

	setPlayerGold(data, gold - def.price)
	if not data.owned_decorations then
		data.owned_decorations = {}
	end
	table.insert(data.owned_decorations, decorationId)

	notifyRE:FireClient(player, "unlock", def.icon .. " Purchased " .. def.name .. "!")
	return { success = true, message = "Purchased " .. def.name, decorationId = decorationId }
end

local function placeDecoration(player: Player, decorationId: string, slotIndex: number?)
	if not RemoteRateLimiter.allow(player, "placeDecoration", 0.75) then
		return { success = false, message = "Slow down" }
	end
	if type(decorationId) ~= "string" then
		return { success = false, message = "Invalid decoration id" }
	end

	local data = PlayerDataService.get(player)
	if not data or not data.owned_plot then
		return { success = false, message = "Claim a plot first" }
	end

	if not ownsDecoration(data, decorationId) then
		return { success = false, message = "Buy this decoration first" }
	end

	local def = findDecorationDef(decorationId)
	if not def then
		return { success = false, message = "Unknown decoration" }
	end

	if not data.decoration_placements then
		data.decoration_placements = {}
	end

	local slot = slotIndex
	if type(slot) ~= "number" then
		slot = nil
		for i = 1, PlacerConfig.MAX_PER_PLOT do
			if not slotTaken(data, i) then
				slot = i
				break
			end
		end
	end

	if not slot or slot < 1 or slot > PlacerConfig.MAX_PER_PLOT then
		return { success = false, message = "No free decoration slots on your plot" }
	end

	if slotTaken(data, slot) then
		return { success = false, message = "Slot " .. slot .. " is already used" }
	end

	local ok, err = spawnPlacement(data.owned_plot, slot, def.modelName, decorationId)
	if not ok then
		return { success = false, message = err or "Could not place decoration" }
	end

	table.insert(data.decoration_placements, { id = decorationId, slot = slot })
	notifyRE:FireClient(player, "unlock", def.icon .. " Placed " .. def.name .. " on your plot!")
	return { success = true, message = "Placed " .. def.name, slot = slot }
end

local function getDecorationState(player: Player)
	local data = PlayerDataService.get(player) or {}
	local owned = {}
	if data.owned_decorations then
		for _, id in ipairs(data.owned_decorations) do
			owned[id] = true
		end
	end

	local catalog = {}
	for _, item in ipairs(DecorationConfig.garden_items) do
		table.insert(catalog, item)
	end
	for _, item in ipairs(DecorationConfig.cottage_items) do
		table.insert(catalog, item)
	end

	return {
		owned_plot = data.owned_plot,
		owned = owned,
		placements = data.decoration_placements or {},
		catalog = catalog,
		max_slots = PlacerConfig.MAX_PER_PLOT,
		gold = playerGold(data),
	}
end

local buyRF = RF:FindFirstChild("BuyDecoration") or Instance.new("RemoteFunction")
buyRF.Name = "BuyDecoration"
buyRF.Parent = RF
buyRF.OnServerInvoke = buyDecoration

local placeRF = RF:FindFirstChild("PlaceDecoration") or Instance.new("RemoteFunction")
placeRF.Name = "PlaceDecoration"
placeRF.Parent = RF
placeRF.OnServerInvoke = placeDecoration

local stateRF = RF:FindFirstChild("GetDecorationState") or Instance.new("RemoteFunction")
stateRF.Name = "GetDecorationState"
stateRF.Parent = RF
stateRF.OnServerInvoke = getDecorationState

Players.PlayerAdded:Connect(function(player)
	task.wait(3.5)
	restorePlotDecorations(player)
end)

Players.PlayerRemoving:Connect(function(player)
	local data = PlayerDataService.get(player)
	if data and data.owned_plot then
		local owner = findPlacementOwner(data.owned_plot)
		if not owner or owner == player then
			clearPlotFolder(data.owned_plot)
		end
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		task.wait(3.5)
		restorePlotDecorations(player)
	end)
end

print("[DecorationPlacer] Ready — buy/place via BuyDecoration, PlaceDecoration remotes")

shared.ZundaDecorationPlacer = {
	restore = restorePlotDecorations,
}

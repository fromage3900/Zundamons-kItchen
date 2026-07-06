-- [[Script] Planters (ref: RBXCCC98DFCA91D42C796F8AF9AD71AD56E)]]
-- Planters: Seed planting + growth in designated planter boxes
-- Uses PlayerDataService for seed inventory (migrated off _G.data)

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local myplanters = CollectionService:GetTagged("Planter")
local plantable = CollectionService:GetTagged("Plantable")
local RE = RS:WaitForChild("RemoteEvents")
local showmenu = RE:WaitForChild("ShowPlantingMenu")
local plantingEvent = RE:WaitForChild("plantEvent")
local configFiles = RS:WaitForChild("ConfigurationFiles")
local plantsConfig = require(configFiles:WaitForChild("PlantConfig"))
local plantsList = plantsConfig.items

local MAX_PLANT_DISTANCE = 25
local plantableNames: { [string]: boolean } = {}
for _, plant in ipairs(plantable) do
	plantableNames[plant.Name] = true
end

local function planterPosition(planter: Instance): Vector3?
	if planter:IsA("BasePart") then
		return planter.Position
	end
	if planter:IsA("Model") then
		return planter:GetPivot().Position
	end
	return nil
end

local function playerNearPlanter(player: Player, planter: Instance): boolean
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local pos = planterPosition(planter)
	if not hrp or not pos then
		return false
	end
	return (hrp.Position - pos).Magnitude <= MAX_PLANT_DISTANCE
end

local function getSeedCount(data: { [string]: any }, seedName: string): number
	local n = data[seedName]
	if type(n) ~= "number" then
		return 0
	end
	return n
end

local function clonePlant(item: BasePart, plant: Instance)
	local newPlant = plant:Clone()
	newPlant:SetAttribute("Planted_at", tick())
	newPlant.Parent = item
	newPlant.Anchored = true
	newPlant.Position = Vector3.new(item.Position.X, item.Position.Y + newPlant.Size.Y / 2, item.Position.Z)
end

local function activvateClickDetector()
	for _, item in ipairs(myplanters) do
		local clickDetector = item:FindFirstChild("ClickDetector")
		if clickDetector then
			clickDetector.MouseClick:Connect(function(player)
				local data = PlayerDataService.get(player)
				if not data then
					return
				end
				if item:GetAttribute("Seeded") then
					return
				end
				if not playerNearPlanter(player, item) then
					return
				end

				local myplantables = {}
				for seedName, _ in pairs(plantableNames) do
					local count = getSeedCount(data, seedName)
					if count > 0 then
						myplantables[seedName] = count
					end
				end
				if next(myplantables) ~= nil then
					showmenu:FireClient(player, myplantables, item)
				end
			end)
		end
	end
end

plantingEvent.OnServerEvent:Connect(function(player: Player, seedName: any, planter: any)
	if typeof(seedName) ~= "string" then
		return
	end
	if typeof(planter) ~= "Instance" or not planter:IsA("BasePart") then
		return
	end
	if not CollectionService:HasTag(planter, "Planter") then
		return
	end
	if planter:GetAttribute("Seeded") == true then
		return
	end
	if not plantableNames[seedName] then
		return
	end
	if not playerNearPlanter(player, planter) then
		return
	end

	local data = PlayerDataService.get(player)
	if not data then
		return
	end

	local count = getSeedCount(data, seedName)
	if count <= 0 then
		return
	end

	data[seedName] = count - 1
	if data[seedName] == 0 then
		data[seedName] = nil
	end

	for _, plant in ipairs(plantable) do
		if plant.Name == seedName then
			planter:SetAttribute("Seeded", true)
			clonePlant(planter, plant)
			break
		end
	end
end)

local function growPlants()
	task.spawn(function()
		while true do
			task.wait(1)
			for _, item in ipairs(myplanters) do
				if not item.Parent then
					continue
				end
				local children = item:GetChildren()
				for _, val in ipairs(children) do
					if plantsList[val.Name] then
						local properties = plantsList[val.Name]
						if properties then
							local time_planted = val:GetAttribute("Planted_at")
							local time_to_grow = properties.Grow_Time
							if time_planted and time_to_grow and time_planted > 0 then
								local time_passed = tick() - time_planted
								if time_passed > time_to_grow then
									val:Destroy()
									clonePlant(item, properties.Sprout)
								end
							end
						end
					end
				end
			end
		end
	end)
end

activvateClickDetector()
growPlants()
print("[Planters] Ready - " .. #myplanters .. " planters bound (PlayerDataService)")

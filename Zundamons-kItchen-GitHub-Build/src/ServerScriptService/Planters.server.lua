-- [[Script] Planters (ref: RBXCCC98DFCA91D42C796F8AF9AD71AD56E)]]
local CollectionService = game:GetService("CollectionService")
local myplanters = CollectionService:GetTagged("Planter")
local plantable = CollectionService:GetTagged("Plantable")
local RS = game.ReplicatedStorage
local RE = RS:WaitForChild("RemoteEvents")
local showmenu = RE:WaitForChild("ShowPlantingMenu")
local plantingEvent = RE:WaitForChild("plantEvent")
local configFiles = RS:WaitForChild("ConfigurationFiles")
local plantsConfig = require(configFiles:WaitForChild("PlantConfig"))
local plantsList = plantsConfig.items

local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local activePlanters: { [Instance]: Instance } = {}

function clonePlant(item, plant)
	local newPlant = plant:Clone()
	newPlant:SetAttribute("Planted_at", tick())
	newPlant.Parent = item
	newPlant.Anchored = true
	newPlant.Position = Vector3.new(item.Position.X, item.Position.Y + newPlant.Size.Y / 2, item.Position.Z)
end

local function plantSeed(player, myplant, myitem)
	local item = activePlanters[myitem]
	if not item then
		return false
	end

	local data = PlayerDataService.get(player)
	if not data or not data[myplant] then
		return false
	end

	if data[myplant] and not item:GetAttribute("Seeded") and myitem == item then
		data[myplant] -= 1
		if data[myplant] == 0 then
			data[myplant] = nil
		end
		for _, plant in ipairs(plantable) do
			if plant.Name == myplant and not item:GetAttribute("Seeded") then
				item:SetAttribute("Seeded", true)
				clonePlant(item, plant)
				break
			end
		end
	end

	return true
end

plantingEvent.OnServerEvent:Connect(plantSeed)

function activvateClickDetector()
	for _, item in ipairs(myplanters) do
		local clickDetector = item:FindFirstChild("ClickDetector")
		if not clickDetector then
			continue
		end

		activePlanters[item] = item

		clickDetector.MouseClick:Connect(function(player)
			local myplantables = {}
			local data = PlayerDataService.get(player)
			if data then
				for _, plant in ipairs(plantable) do
					if data[plant.Name] then
						myplantables[plant.Name] = data[plant.Name]
					end
				end
			end
			if next(myplantables) ~= nil and not item:GetAttribute("Seeded") then
				showmenu:FireClient(player, myplantables, item)
			end
		end)
	end
end

function growPlants()
	task.spawn(function()
		while true do
			for _, item in ipairs(myplanters) do
				for _, val in ipairs(item:GetChildren()) do
					if plantsList[val.Name] then
						local properties = plantsList[val.Name]
						if properties then
							local timePlanted = val:GetAttribute("Planted_at")
							local timeToGrow = properties.Grow_Time
							local timePassed = tick() - timePlanted
							if timePassed > timeToGrow then
								val:Destroy()
								clonePlant(item, properties.Sprout)
							end
						end
					end
				end
			end
			task.wait(1)
		end
	end)
end

activvateClickDetector()
growPlants()

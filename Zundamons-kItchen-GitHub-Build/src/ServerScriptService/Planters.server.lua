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
local runservice = game:GetService("RunService")

function clonePlant(item, plant)
	local newPlant = plant:Clone()
	newPlant:SetAttribute("Planted_at", tick())
	newPlant.Parent = item
	newPlant.Anchored=true
	newPlant.Position= Vector3.new(item.Position.X, item.Position.Y+newPlant.Size.Y/2, item.Position.Z)
end


function activvateClickDetector()
	for _, item in ipairs(myplanters) do
		local clickDetector = item:FindFirstChild("ClickDetector")
		clickDetector.MouseClick:Connect(function(player)
			local myplantables = {}
			for _, plant in ipairs(plantable) do
				if _G.data and _G.data[player.Name] and _G.data[player.Name][plant.Name] then
					myplantables[plant.Name]=_G.data[player.Name][plant.Name]
				end
			end
			if next(myplantables) ~= nil and not item:GetAttribute("Seeded") then
				showmenu:FireClient(player, myplantables, item)
			end
			
			local function plantSeed(player, myplant, myitem)
				if not _G.data[player.Name] then
					return false
				end
				if _G.data[player.Name][myplant] and not item:GetAttribute("Seeded") and myitem==item then
					_G.data[player.Name][myplant]-=1
					if _G.data[player.Name][myplant] == 0 then
						_G.data[player.Name][myplant]=nil
					end
					for _, plant in ipairs(plantable) do
						if plant.Name==myplant and not item:GetAttribute("Seeded") then
							item:SetAttribute("Seeded", true)
							clonePlant(item, plant)
							break
						end
					end
				end
			end

			plantingEvent.OnServerEvent:Connect(plantSeed)
		end)
		
	end
end

function growPlants()
	runservice.Heartbeat:Connect(function()
		for _, item in ipairs(myplanters) do
			local children = item:GetChildren()
			for _, val in ipairs(children) do
				if plantsList[val.Name] then
					local properties = plantsList[val.Name] 
					if properties then
						local time_planted = val:GetAttribute("Planted_at")
						local time_to_grow = properties.Grow_Time
						local time_passed = tick()-time_planted
						if time_passed>time_to_grow then
							val:Destroy()
							clonePlant(item, properties.Sprout)
						end
					end
				end
			end
		end
	end)
	
end

activvateClickDetector()
growPlants()
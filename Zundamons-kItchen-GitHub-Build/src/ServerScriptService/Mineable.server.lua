-- [[Script] Mineable (ref: RBXF2522A122CFA49CEA3F2FD0377BB82F8)]]
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local SSS = game.ServerScriptService
local lms = SSS:WaitForChild("LootModule")
local loot_module = require(lms)
local RS = game.ReplicatedStorage
local configFiles = RS:WaitForChild("ConfigurationFiles")
local mineableConfig = require(configFiles:WaitForChild("MineableConfig"))
local mineableList = mineableConfig.Mineables

function hasWildcardTag(instance, prefix)
	local tags = CollectionService:GetTags(instance)
	for _, tag in ipairs(tags) do
		if string.sub(tag, 1, #prefix) == prefix then
			return tag
		end
	end
	return nil
end

function itemAttributes(item)
	local tags = CollectionService:GetTags(item)
	for _, tag in ipairs(tags) do
		if mineableList[tag] then
			item:SetAttribute("Health", mineableList[tag].Health)
			item:SetAttribute("MaxHealth", mineableList[tag].MaxHealth)
			item:SetAttribute("Respawn", mineableList[tag].Respawn)
			item:SetAttribute("Type", tag)
			break
		end
	end
end

function itemEvent(item)
	item:GetAttributeChangedSignal("Health"):Connect(function()
		local health = item:GetAttribute("Health")
		local mined = item:GetAttribute("Mined")
		if health <=0 and not mined then
			item:SetAttribute("Mined", true)

			for _, player in pairs(Players:GetPlayers()) do
				local tag = hasWildcardTag(item, player.Name.."|")
				if tag then
					local split_tag = string.split(tag, "|")
					local loottable = mineableList[item:GetAttribute("Type")].loot[split_tag[2]]
					local tags = CollectionService:GetTags(item)
					local rootpart = player.Character:FindFirstChild("HumanoidRootPart")
					if rootpart then
						loot_module.generateLoot(player, loottable, Vector3.new(item.Position.X, rootpart.Position.Y, item.Position.Z))	
					end
				end
			end
			

			local model = item:FindFirstAncestorOfClass("Model")
			local obj = model or item
			
			if item:HasTag("Destroy") then
				item.Parent:SetAttribute("Seeded", false)
				item:Destroy()
			elseif model and model:HasTag("Destroy") then
				model.Parent:SetAttribute("Seeded", false)
				model:Destroy()
			else
				local parent = obj.Parent
				obj.Parent = nil
				wait(item:GetAttribute("Respawn"))
				item:SetAttribute("Health", item:GetAttribute("MaxHealth"))
				item:SetAttribute("Mined", false)
				obj.Parent = parent
			end
		end	
	end)
end

function addAttributes()
	for _, item in ipairs(CollectionService:GetTagged("Mineable")) do
		itemAttributes(item)
	end
end

function addEvent()
	for _, item in ipairs(CollectionService:GetTagged("Mineable")) do
		itemEvent(item)
	end
end

function assigner(item)
	itemAttributes(item)
	itemEvent(item)
end

addAttributes()
addEvent()

CollectionService:GetInstanceAddedSignal("Mineable"):Connect(assigner)

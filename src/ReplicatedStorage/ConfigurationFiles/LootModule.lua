-- [[ModuleScript] LootModule (ref: RBX4573179EFA054EED872412F08A8A6EF4)]]
local loot_module = {}
local RS = game.ReplicatedStorage
local RE = RS:WaitForChild("RemoteEvents")
local RF = RS:WaitForChild("RemoteFunctions")
local loot = RS:WaitForChild("Loot")
local give_loot = RF:WaitForChild("GiveLoot")
local removeCode = RE:WaitForChild("RemoveCode")
local MakeLootEvent = RE:WaitForChild("MakeLootEvent")
local finalLoots = loot:GetChildren()
local sellLoot = RF:WaitForChild("sellLoot")
local configFiles = RS:WaitForChild("ConfigurationFiles")
local mineableConfig = require(configFiles:WaitForChild("MineableConfig"))
local priceLists = mineableConfig.priceLists

local PlayerDataService = require(game.ServerScriptService.Services.PlayerDataService)

local RewardCore = require(game.ServerScriptService:WaitForChild("RewardCore"))
local ChefLevelConfig = require(configFiles:WaitForChild("ChefLevelConfig"))

local codes: { [string]: { { string } } } = {}
local sellTimestamps: { [string]: { number } } = {}
local MAX_SELLS_PER_SECOND = 5

local function validateRateLimit(player: Player): boolean
	local now = tick()
	local timestamps = sellTimestamps[player.Name] or {}
	local recent = {}
	for _, ts in ipairs(timestamps) do
		if now - ts <= 1 then
			table.insert(recent, ts)
		end
	end
	if #recent >= MAX_SELLS_PER_SECOND then
		return false
	end
	table.insert(recent, now)
	sellTimestamps[player.Name] = recent
	return true
end

function handleOreSell(player, item)
	if typeof(item) ~= "string" or not priceLists[item] then
		return false
	end
	if not validateRateLimit(player) then
		return false
	end

	local data = PlayerDataService.get(player)
	if not data or not data[item] then
		return false
	end

	local total = priceLists[item] * data[item]
	data[item] = nil
	total = RewardCore.addGold(player, total, "sell")
	return data.gold or 0
end

function loot_module.eraseData(player)
	codes[player.Name] = nil
	sellTimestamps[player.Name] = nil
end

function searchforCode(player, genCode, name, isRemoving)
	local list = codes[player.Name]
	if list then
		for i = 1, #list do
			if genCode == list[i][1] and name == list[i][2] then
				if isRemoving then
					table.remove(list, i)
					break
				end
				return true
			end
		end
	end
	return false
end

function assignLoot(player, lootname, myloot)
	local value = myloot:GetAttribute("Value")
	local data = PlayerDataService.getOrCreate(player)
	if not data[lootname] then
		data[lootname] = value
	else
		data[lootname] = data[lootname] + value
	end
	RewardCore.addXP(player, ChefLevelConfig.xpRewards.gather, "gather")
	local popupEvt = game.ReplicatedStorage:FindFirstChild("RewardEvents")
		and game.ReplicatedStorage.RewardEvents:FindFirstChild("PopupEvent")
	if popupEvt then
		popupEvt:FireClient(player, "item", "+" .. value .. " " .. lootname, Color3.fromRGB(160, 240, 170))
	end
	local extraChance = RewardCore.companionBuff and RewardCore.companionBuff(player, "extra_drop") or 0
	if extraChance > 0 and math.random() < extraChance then
		data[lootname] = (data[lootname] or 0) + value
		if popupEvt then
			popupEvt:FireClient(player, "bonus", "✨ " .. lootname .. " ×2 (Antimon!)", Color3.fromRGB(180, 240, 200))
		end
	end
	RewardCore.notify(player, "gather", { item = lootname, count = value })
	return true
end

function loot_module.GiveLoot(player, lootname, genCode)
	if typeof(lootname) ~= "string" or typeof(genCode) ~= "string" then
		return false
	end
	if genCode and player and lootname then
		local myloot = loot:FindFirstChild(lootname)
		local exists = searchforCode(player, genCode, lootname, false)
		if exists and myloot then
			return assignLoot(player, lootname, myloot)
		end
	end
	return false
end

function StoreCode(player, mycode, name)
	local playerName = player.Name
	if codes[playerName] then
		table.insert(codes[playerName], { mycode, name })
	else
		codes[playerName] = { { mycode, name } }
	end
end

function loot_module.lootMaker(totalLoot)
	local selLoot = {}
	for i = 1, totalLoot do
		local obj = finalLoots[math.random(1, #finalLoots)]
		table.insert(selLoot, obj.Name)
	end
	return selLoot
end

function loot_module.generateLoot(player, loottable, position)
	for i = 1, #loottable do
		local generatedCode = tick() .. "" .. math.random(600, 10000000)
		local obj = loottable[i]
		StoreCode(player, generatedCode, obj)
		MakeLootEvent:FireClient(player, obj, position, generatedCode)
	end
end

removeCode.OnServerEvent:Connect(function(player, genCode, name, isRemoving)
	searchforCode(player, genCode, name, isRemoving == true)
end)

give_loot.OnServerInvoke = loot_module.GiveLoot
sellLoot.OnServerInvoke = handleOreSell

return loot_module

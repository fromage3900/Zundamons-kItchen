-- [[ModuleScript] LootModule (ref: RBX4573179EFA054EED872412F08A8A6EF4)]]
local loot_module = {}
local RS =  game.ReplicatedStorage
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


local requestData = RF:WaitForChild("RequestData")

local RewardCore
task.spawn(function()
	local ok, mod = pcall(function() return require(game.ServerScriptService:WaitForChild("RewardCore")) end)
	if ok then RewardCore = mod end
end)
local ChefLevelConfig = require(configFiles:WaitForChild("ChefLevelConfig"))

local codes = {}
_G.data = {}

function handleOreSell(player, item)
	if not _G.data[player.Name] then
		return false
	end
	if _G.data[player.Name][item] then
		local total = priceLists[item] * _G.data[player.Name][item]
		_G.data[player.Name][item] = nil
		if RewardCore then
			total = RewardCore.addGold(player, total, "sell")
		end
		if not _G.data[player.Name]["Gold"] then
			_G.data[player.Name]["Gold"] = total
		else
			_G.data[player.Name]["Gold"] = _G.data[player.Name]["Gold"] + total
		end
		return _G.data[player.Name]["Gold"]
	else
		return false
	end
end

function loot_module.eraseData(player)
	codes[player.Name] = nil
end

function searchforCode(player, genCode, name, isRemoving)
	local list = codes[player.Name]
	if list then
		for i=1, #list do
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
	local value  = myloot:GetAttribute("Value")
	if not _G.data[player.Name] then
		_G.data[player.Name] = {}
	end
	if not _G.data[player.Name][lootname] then
		_G.data[player.Name][lootname]= value
	else
		_G.data[player.Name][lootname] = _G.data[player.Name][lootname]+value
	end
	if RewardCore then
		RewardCore.addXP(player, ChefLevelConfig.xpRewards.gather, "gather")
		local popupEvt = game.ReplicatedStorage:FindFirstChild("RewardEvents") and game.ReplicatedStorage.RewardEvents:FindFirstChild("PopupEvent")
		if popupEvt then
			popupEvt:FireClient(player, "item", "+" .. value .. " " .. lootname, Color3.fromRGB(160, 240, 170))
		end
		-- Antimon companion buff: +20% chance of extra drop
		local extraChance = RewardCore.companionBuff and RewardCore.companionBuff(player, "extra_drop") or 0
		if extraChance > 0 and math.random() < extraChance then
			_G.data[player.Name][lootname] = (_G.data[player.Name][lootname] or 0) + value
			if popupEvt then
				popupEvt:FireClient(player, "bonus", "✨ " .. lootname .. " ×2 (Antimon!)", Color3.fromRGB(180, 240, 200))
			end
		end
		RewardCore.notify(player, "gather", { item = lootname, count = value })
	end
	return true
end

function loot_module.GiveLoot(player, lootname, genCode)
	if genCode and player and lootname then
		local myloot = loot:WaitForChild(lootname)
		local exists = searchforCode(player, genCode, lootname, false)
		if exists and myloot then
			local resp = assignLoot(player, lootname, myloot)
			return resp
		end
	end
end

function StoreCode(player, mycode, name)
	local playerName = player.Name
	if codes[playerName] then
		table.insert(codes[playerName], {mycode, name})
	else
		codes[playerName]={{mycode, name}}
	end
end

function loot_module.lootMaker(totalLoot)
	local selLoot = {}
	for i=1, totalLoot do
		local obj = finalLoots[math.random(1,#finalLoots)]
		table.insert(selLoot, obj.Name)
	end
	return selLoot
end

function loot_module.generateLoot(player, loottable, position)
	for i=1, #loottable do
		local generatedCode = tick()..""..math.random(600,10000000)
		local obj = loottable[i]
		StoreCode(player, generatedCode, obj)
		MakeLootEvent:FireClient(player, obj, position, generatedCode)
	end
end

function sendData(player)
	if player and _G.data[player.Name] then
		print(_G.data[player.Name])
		return _G.data[player.Name]
	else
		return {}
	end
end

removeCode.OnServerEvent:Connect(searchforCode)

give_loot.OnServerInvoke = loot_module.GiveLoot

requestData.OnServerInvoke = sendData

sellLoot.OnServerInvoke = handleOreSell

return loot_module

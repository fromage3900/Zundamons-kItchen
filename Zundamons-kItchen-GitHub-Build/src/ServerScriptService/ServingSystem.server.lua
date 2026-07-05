-- [[Script] ServingSystem (ref: RBX443AAD921E174D02B4630B6A7D249A5C)]]
-- ServingSystem: Handles click-to-serve interactions with guests

local CONFIG = require(game.ReplicatedStorage.ConfigurationFiles.ProgressionConfig)
local RF = game.ReplicatedStorage:WaitForChild("RemoteFunctions")
local serveGuestRF = RF:WaitForChild("ServeGuest")
local RewardCore = require(game.ServerScriptService:WaitForChild("RewardCore"))
local ChefLevelConfig = require(game.ReplicatedStorage.ConfigurationFiles.ChefLevelConfig)

-- Handle when player tries to serve food to a guest
local function handleServeGuest(player, guestInstance, foodItemName)
	if not guestInstance or not guestInstance.Parent then
		return false, "Guest not found"
	end
	
	if not _G.data or not _G.data[player.Name] then
		return false, "Player data not found"
	end
	
	local playerData = _G.data[player.Name]
	local recipe = guestInstance:GetAttribute("PreferredRecipe")
	local payAmount = guestInstance:GetAttribute("PayAmount")
	
	-- Check if food matches guest's preference
	if foodItemName ~= recipe then
		print("[ServingSystem] " .. player.Name .. " tried to serve " .. foodItemName .. " but guest wanted " .. recipe)
		return false, "Wrong food! Guest wants " .. recipe
	end
	
	-- Check if player has the food
	if not playerData[foodItemName] or playerData[foodItemName] <= 0 then
		return false, "You don't have " .. foodItemName
	end
	
	-- Success! Remove food from inventory
	playerData[foodItemName] = playerData[foodItemName] - 1
	if playerData[foodItemName] == 0 then
		playerData[foodItemName] = nil
	end
	
	RewardCore.bumpCombo(player)
	local awarded = RewardCore.addGold(player, payAmount, "serve")
	playerData["Gold"] = (playerData["Gold"] or 0) + awarded
	payAmount = awarded
	RewardCore.addXP(player, ChefLevelConfig.xpRewards.serveGuest, "serve")
	RewardCore.notify(player, "serve", { recipe = recipe, guestName = guestInstance.Name, gold = awarded })
	
	-- Track recipe served
	if not playerData["recipes_served_count"] then
		playerData["recipes_served_count"] = {}
	end
	
	if not playerData["recipes_served_count"][recipe] then
		playerData["recipes_served_count"][recipe] = 1
	else
		playerData["recipes_served_count"][recipe] = playerData["recipes_served_count"][recipe] + 1
	end
	
	-- Increment guest count
	playerData["guests_served"] = (playerData["guests_served"] or 0) + 1
	playerData["total_gold_earned"] = (playerData["total_gold_earned"] or 0) + payAmount
	
	print("[ServingSystem] " .. player.Name .. " served guest " .. recipe .. " (+" .. payAmount .. " gold, total guests: " .. playerData["guests_served"] .. ")")
	
	-- Check if any new tiers unlocked
	if _G.checkAndUnlockTiers then
		_G.checkAndUnlockTiers(player)
	end
	
	-- Remove guest
	if _G.removeGuestByInstance then
		_G.removeGuestByInstance(guestInstance, "served")
	end
	
	return true, "Served! +" .. payAmount .. " gold"
end

-- Set up RemoteFunction
serveGuestRF.OnServerInvoke = handleServeGuest

print("[ServingSystem] Started")
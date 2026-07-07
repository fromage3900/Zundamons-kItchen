-- [[Script] CraftManager (ref: RBX1C358C3F233C41328CB4C3F0B82DD2B3)]]
-- CraftManager: Server-side handler for CraftFunction.
-- Supports server-validated timed-cooking quality from rhythm minigame timings.
local RS = game.ReplicatedStorage
local RF = RS:WaitForChild("RemoteFunctions")
local RE = RS:WaitForChild("RemoteEvents")
local craftfunction = RF:WaitForChild("CraftFunction")
local configFiles = RS:WaitForChild("ConfigurationFiles")
local craftConfig = require(configFiles:WaitForChild("CraftConfig"))
local craftData = craftConfig.recipes
local loot_module = require(configFiles:WaitForChild("LootModule"))
local RewardCore = require(configFiles:WaitForChild("RewardCore"))
local ChefLevelConfig = require(configFiles:WaitForChild("ChefLevelConfig"))
local CookValidator = require(game.ServerScriptService.Services.CookValidator)

local cookResultEvent = RE:FindFirstChild("CookingResult")
if not cookResultEvent then
	cookResultEvent = Instance.new("RemoteEvent")
	cookResultEvent.Name = "CookingResult"
	cookResultEvent.Parent = RE
end

local QUALITY_BONUS = {
	perfect = { gold = 25, extraChance = 0.35 },
	great = { gold = 10, extraChance = 0.0 },
	ok = { gold = 0, extraChance = 0.0 },
}

local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local function ensureDataBucket(player)
	return PlayerDataService.getOrCreate(player)
end

local function resolveQuality(player, qualityOrTimings)
	if type(qualityOrTimings) == "table" and type(qualityOrTimings.timings) == "table" then
		local noteCount = qualityOrTimings.noteCount or #qualityOrTimings.timings
		return CookValidator.validateSession(player, qualityOrTimings.timings, noteCount)
	end
	if type(qualityOrTimings) == "string" and QUALITY_BONUS[qualityOrTimings] then
		return qualityOrTimings
	end
	return "ok"
end

local function craftItem(player, item, position, qualityOrTimings)
	local quality = resolveQuality(player, qualityOrTimings)

	local values = craftData[item]
	if not values then
		return "Fail"
	end

	local bucket = ensureDataBucket(player)

	for key, value in pairs(values) do
		if key == "locked" then
			continue
		end
		local owned = bucket[key]
		if not owned or owned < value then
			return "Fail"
		end
	end

	for key, value in pairs(values) do
		if key == "locked" then
			continue
		end
		bucket[key] -= value
		if bucket[key] <= 0 then
			bucket[key] = nil
		end
	end

	loot_module.generateLoot(player, { item }, position)

	local bonus = QUALITY_BONUS[quality]
	if bonus.extraChance > 0 and math.random() < bonus.extraChance then
		loot_module.generateLoot(player, { item }, position + Vector3.new(0, 1, 0))
	end

	if bonus.gold > 0 then
		RewardCore.bumpCombo(player)
		RewardCore.addGold(player, bonus.gold, quality == "perfect" and "perfect" or "craft")
	elseif quality == "ok" then
		RewardCore.breakCombo(player)
	end

	local craftXP = (quality == "perfect") and ChefLevelConfig.xpRewards.craftPerfect
		or ChefLevelConfig.xpRewards.craftSuccess
	RewardCore.addXP(player, craftXP, "craft")
	RewardCore.notify(player, "craft", { recipe = item, quality = quality })

	pcall(function()
		cookResultEvent:FireClient(player, {
			recipe = item,
			quality = quality,
			bonusGold = bonus.gold,
		})
	end)

	PlayerDataService.update(player, function(d)
		if quality == "perfect" then
			d.perfect_cooks = (d.perfect_cooks or 0) + 1
			d.cooking_streak = (d.cooking_streak or 0) + 1
			d.max_cooking_streak = math.max(d.max_cooking_streak or 0, d.cooking_streak)
		elseif quality == "great" then
			d.great_cooks = (d.great_cooks or 0) + 1
			d.cooking_streak = (d.cooking_streak or 0) + 1
		else
			d.cooking_streak = 0
		end
		if not d.recipes_served_count then
			d.recipes_served_count = {}
		end
		d.recipes_served_count[item] = (d.recipes_served_count[item] or 0) + 1
	end)

	return "Success"
end

craftfunction.OnServerInvoke = craftItem

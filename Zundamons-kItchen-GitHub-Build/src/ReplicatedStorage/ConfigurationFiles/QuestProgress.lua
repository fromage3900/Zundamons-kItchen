-- [[ModuleScript] QuestProgress]]
-- Side-effect-free quest progress evaluator for QuestConfig entries.

local ZoneVisitConfig = require(script.Parent:WaitForChild("ZoneVisitConfig"))
local CraftConfig = require(script.Parent:WaitForChild("CraftConfig"))

local QuestProgress = {}

local SKIP_INVENTORY_KEYS = {
	Gold = true,
	current_gold = true,
	guests_served = true,
	zones_visited = true,
	active_companion = true,
	total_gold_earned = true,
	tier = true,
	completed_quests = true,
	stats = true,
	recipes_unlocked = true,
	cosmetics_unlocked = true,
	furniture_unlocked = true,
	locations_unlocked = true,
	owned_clothing = true,
	owned_decorations = true,
	decoration_placements = true,
	owned_plot = true,
	recipes_unlocked_count = true,
	recipes_served_count = true,
	daily = true,
	achievements = true,
	compendium = true,
}

local ZUNDA_RECIPES = {
	"Zunda Bread",
	"Zunda Mochi",
	"Edamame Snack",
	"Sweet Pea Cake",
	"Pea Flower Tea",
	"Zunda Paradise",
}

local function stats(data: { [string]: any })
	return data.stats or {}
end

local function countUniqueRecipes(data: { [string]: any }): number
	local count = 0
	for recipeName in pairs(CraftConfig.recipes) do
		local amount = data[recipeName]
		if type(amount) == "number" and amount >= 1 then
			count += 1
		end
	end
	return count
end

local function countUniqueZundaRecipes(data: { [string]: any }): number
	local count = 0
	for _, recipeName in ipairs(ZUNDA_RECIPES) do
		local amount = data[recipeName]
		if type(amount) == "number" and amount >= 1 then
			count += 1
		end
	end
	return count
end

local function countVisitedZones(data: { [string]: any }): number
	local zones = data.zones_visited
	if type(zones) ~= "table" then
		return 0
	end
	local count = 0
	for _, visited in pairs(zones) do
		if visited then
			count += 1
		end
	end
	return count
end

local function sumMaterials(data: { [string]: any }): number
	local total = 0
	for key, value in pairs(data) do
		if not SKIP_INVENTORY_KEYS[key] and type(value) == "number" then
			total += value
		end
	end
	return total
end

local TYPE_HANDLERS: { [string]: (any, { [string]: any }) -> number } = {
	gather = function(quest, data)
		local item = quest.target_item
		if not item then
			return 0
		end
		local amount = data[item]
		return if type(amount) == "number" then amount else 0
	end,

	cook = function(quest, data)
		local item = quest.target_item
		if not item then
			return 0
		end
		local amount = data[item]
		return if type(amount) == "number" then amount else 0
	end,

	cook_any = function(quest, data)
		local best = 0
		local items = quest.cook_items or {}
		for _, itemName in ipairs(items) do
			local amount = data[itemName]
			if type(amount) == "number" and amount > best then
				best = amount
			end
		end
		return best
	end,

	serve = function(_quest, data)
		return data.guests_served or 0
	end,

	earn_gold = function(_quest, data)
		return data.total_gold_earned or 0
	end,

	visit_zone = function(quest, data)
		local zones = data.zones_visited
		if type(zones) ~= "table" then
			return 0
		end
		local canonical = ZoneVisitConfig.resolve(quest.target_zone or "")
		if not canonical then
			return 0
		end
		return if zones[canonical] then 1 else 0
	end,

	visit_zones_unique = function(_quest, data)
		return countVisitedZones(data)
	end,

	cook_perfect = function(_quest, data)
		return stats(data).perfectCooks or 0
	end,

	cook_unique = function(_quest, data)
		return countUniqueRecipes(data)
	end,

	cook_unique_zunda = function(_quest, data)
		return countUniqueZundaRecipes(data)
	end,

	materials_total = function(_quest, data)
		return sumMaterials(data)
	end,

	companion_chat = function(_quest, data)
		return stats(data).companion_chats or 0
	end,

	npc_chat = function(_quest, data)
		return stats(data).npc_chats or 0
	end,
}

function QuestProgress.evaluate(quest: { [string]: any }, data: { [string]: any }): (number, number)
	local goal = quest.target or 1
	local handler = TYPE_HANDLERS[quest.type]
	if not handler then
		warn("[QuestProgress] Unknown quest type: " .. tostring(quest.type))
		return 0, goal
	end
	local current = handler(quest, data)
	return current, goal
end

function QuestProgress.toClientQuest(quest: { [string]: any }): { [string]: any }
	local rewards = quest.rewards or {}
	return {
		id = quest.id,
		emoji = quest.icon or "📋",
		title = quest.name or quest.id,
		desc = quest.description or "",
		reward = rewards.gold or 0,
		reward_gold = rewards.gold or 0,
		unlock_hint = quest.unlock_hint,
	}
end

return QuestProgress

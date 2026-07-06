--!strict
-- PlayerDataService: canonical store for per-player progression/inventory data.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local CONFIG = require(game.ReplicatedStorage.ConfigurationFiles.ProgressionConfig)

local progressionStore = DataStoreService:GetDataStore("KitchenProgression")

local store: { [string]: { [string]: any } } = {}

local PlayerDataService = {}

function PlayerDataService.get(player: Player): { [string]: any }?
	local key = player.Name
	return store[key]
end

function PlayerDataService.getOrCreate(player: Player): { [string]: any }
	local key = player.Name
	if not store[key] then
		store[key] = {}
	end
	return store[key]
end

function PlayerDataService.set(player: Player, data: { [string]: any })
	store[player.Name] = data
end

function PlayerDataService.clear(player: Player)
	store[player.Name] = nil
end

function PlayerDataService.update(player: Player, mutator: ({ [string]: any }) -> ())
	local data = PlayerDataService.getOrCreate(player)
	mutator(data)
end

local function createDefaultData(): { [string]: any }
	local data = {
		current_gold = 50,
		total_gold_earned = 0,
		Gold = 50,
		guests_served = 0,
		tier = 1,
		recipes_unlocked = {},
		cosmetics_unlocked = {},
		furniture_unlocked = {},
		locations_unlocked = {},
		owned_clothing = {},
		owned_decorations = {},
		decoration_placements = {},
		owned_plot = nil,
		zones_visited = {},
		completed_quests = {},
		stats = {
			perfectCooks = 0,
			companion_chats = 0,
			npc_chats = 0,
		},
		recipes_unlocked_count = 0,
		recipes_served_count = {},
		Apple = 5,
		Wheat = 5,
		WheatSeed = 3,
		Wood = 5,
		Rock = 5,
		["Iron Ore"] = 3,
	}

	for _, recipe in ipairs(CONFIG.milestones[1].unlocks.recipes) do
		table.insert(data.recipes_unlocked, recipe)
	end
	for _, cosmetic in ipairs(CONFIG.milestones[1].unlocks.cosmetics) do
		table.insert(data.cosmetics_unlocked, cosmetic)
	end
	for _, furniture in ipairs(CONFIG.milestones[1].unlocks.furniture) do
		table.insert(data.furniture_unlocked, furniture)
	end
	for _, location in ipairs(CONFIG.milestones[1].unlocks.locations) do
		table.insert(data.locations_unlocked, location)
	end

	return data
end

local function backfillLoadedData(loaded: { [string]: any })
	if loaded.current_gold == nil then
		loaded.current_gold = 0
	end
	if loaded.owned_clothing == nil then
		loaded.owned_clothing = {}
	end
	if loaded.owned_decorations == nil then
		loaded.owned_decorations = {}
	end
	if loaded.decoration_placements == nil then
		loaded.decoration_placements = {}
	end
	if loaded.owned_plot == nil then
		loaded.owned_plot = nil
	end
	if loaded.zones_visited == nil then
		loaded.zones_visited = {}
	end
	if loaded.completed_quests == nil then
		loaded.completed_quests = {}
	end
	if loaded.stats == nil then
		loaded.stats = {
			perfectCooks = 0,
			companion_chats = 0,
			npc_chats = 0,
		}
	end
	if loaded.llm_disclaimer_accepted == nil then
		loaded.llm_disclaimer_accepted = false
	end
end

function PlayerDataService.recordZoneVisit(player: Player, rawZoneKey: string)
	local ZoneVisitConfig = require(game.ReplicatedStorage.ConfigurationFiles.ZoneVisitConfig)
	local canonical = ZoneVisitConfig.resolve(rawZoneKey)
	if not canonical then
		return
	end
	local data = PlayerDataService.getOrCreate(player)
	if not data.zones_visited then
		data.zones_visited = {}
	end
	if data.zones_visited[canonical] then
		return
	end
	data.zones_visited[canonical] = true
	print("[PlayerDataService] " .. player.Name .. " visited zone: " .. canonical)
end

function PlayerDataService.loadPlayer(player: Player)
	local userId = player.UserId
	local success, playerData = pcall(function()
		return progressionStore:GetAsync("player_" .. userId)
	end)

	if success and playerData then
		local loaded = playerData
		backfillLoadedData(loaded)
		store[player.Name] = loaded
		print("[PlayerDataService] Loaded progression for " .. player.Name)
	else
		store[player.Name] = createDefaultData()
		print("[PlayerDataService] Created new progression for " .. player.Name)
	end
end

function PlayerDataService.savePlayer(player: Player)
	local data = store[player.Name]
	if not data then
		return
	end

	local ok, err = pcall(function()
		progressionStore:SetAsync("player_" .. player.UserId, data)
	end)

	if ok then
		print("[PlayerDataService] Saved progression for " .. player.Name)
	else
		print("[PlayerDataService] Failed to save " .. player.Name .. ": " .. tostring(err))
	end

	store[player.Name] = nil
end

function PlayerDataService.checkAndUnlockTiers(player: Player)
	local data = store[player.Name]
	if not data then
		return
	end

	local currentTier = data.tier
	for milestoneId = currentTier + 1, #CONFIG.milestones do
		local milestone = CONFIG.milestones[milestoneId]
		if data.guests_served >= milestone.guests_served then
			data.tier = milestoneId
			for _, recipe in ipairs(milestone.unlocks.recipes) do
				if not table.find(data.recipes_unlocked, recipe) then
					table.insert(data.recipes_unlocked, recipe)
				end
			end
			for _, cosmetic in ipairs(milestone.unlocks.cosmetics) do
				if not table.find(data.cosmetics_unlocked, cosmetic) then
					table.insert(data.cosmetics_unlocked, cosmetic)
				end
			end
			for _, furniture in ipairs(milestone.unlocks.furniture) do
				if not table.find(data.furniture_unlocked, furniture) then
					table.insert(data.furniture_unlocked, furniture)
				end
			end
			for _, location in ipairs(milestone.unlocks.locations) do
				if not table.find(data.locations_unlocked, location) then
					table.insert(data.locations_unlocked, location)
				end
			end
			print("[PlayerDataService] " .. player.Name .. " unlocked tier " .. milestoneId .. ": " .. milestone.name)
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	PlayerDataService.loadPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
	PlayerDataService.savePlayer(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
	if not store[player.Name] then
		PlayerDataService.loadPlayer(player)
	end
end

return PlayerDataService

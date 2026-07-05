-- [[Script] DataManager (ref: RBX3748DEC0F279493F9388EF0D7A48BE09)]]
-- DataManager: Handles DataStore persistence for progression data

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local progressionStore = DataStoreService:GetDataStore("KitchenProgression")
local CONFIG = require(game.ReplicatedStorage.ConfigurationFiles.ProgressionConfig)

local function initializePlayerData(player)
	if not _G.data then _G.data = {} end
	local playerName = player.Name
	local userId = player.UserId

	local success, playerData = pcall(function()
		return progressionStore:GetAsync("player_" .. userId)
	end)

	if success and playerData then
		local loaded = playerData
		-- Backfill new fields for returning players
		if loaded.current_gold == nil     then loaded.current_gold     = 0   end
		if loaded.owned_clothing == nil   then loaded.owned_clothing   = {}  end
		if loaded.owned_decorations==nil  then loaded.owned_decorations= {}  end
		-- owned_plot may legitimately be nil, so only init if key missing
		if loaded.owned_plot == nil       then loaded.owned_plot       = nil end
		_G.data[playerName] = loaded
		print("[DataManager] Loaded progression for " .. playerName)
	else
		_G.data[playerName] = {
			-- Currency
			current_gold        = 50,  -- Starter gold
			total_gold_earned   = 0,
			Gold                = 50,  -- Alias for current_gold (used in some scripts)
			-- Progression
			guests_served       = 0,
			tier                = 1,
			-- Unlocks
			recipes_unlocked    = {},
			cosmetics_unlocked  = {},
			furniture_unlocked  = {},
			locations_unlocked  = {},
			-- Shop ownership
			owned_clothing      = {},
			owned_decorations   = {},
			owned_plot          = nil,
			-- Recipe tracking
			recipes_unlocked_count = 0,
			recipes_served_count   = {},
			-- STARTER INVENTORY for crafting
			Apple               = 5,
			Wheat               = 5,
			Wood                = 5,
			Rock                = 5,
			["Iron Ore"]        = 3,
		}

		for _, recipe in ipairs(CONFIG.milestones[1].unlocks.recipes) do
			table.insert(_G.data[playerName].recipes_unlocked, recipe)
		end
		for _, cosmetic in ipairs(CONFIG.milestones[1].unlocks.cosmetics) do
			table.insert(_G.data[playerName].cosmetics_unlocked, cosmetic)
		end
		for _, furniture in ipairs(CONFIG.milestones[1].unlocks.furniture) do
			table.insert(_G.data[playerName].furniture_unlocked, furniture)
		end
		for _, location in ipairs(CONFIG.milestones[1].unlocks.locations) do
			table.insert(_G.data[playerName].locations_unlocked, location)
		end

		print("[DataManager] Created new progression for " .. playerName)
	end
end

local function savePlayerData(player)
	local playerName = player.Name
	local userId = player.UserId
	if _G.data[playerName] then
		local ok, err = pcall(function()
			progressionStore:SetAsync("player_" .. userId, _G.data[playerName])
		end)
		if ok then
			print("[DataManager] Saved progression for " .. playerName)
		else
			print("[DataManager] Failed to save " .. playerName .. ": " .. tostring(err))
		end
		_G.data[playerName] = nil
	end
end

function checkAndUnlockTiers(player)
	local playerName = player.Name
	if not _G.data[playerName] then return end
	local data = _G.data[playerName]
	local current_tier = data.tier

	for milestone_id = current_tier + 1, #CONFIG.milestones do
		local milestone = CONFIG.milestones[milestone_id]
		if data.guests_served >= milestone.guests_served then
			data.tier = milestone_id
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
			print("[DataManager] " .. playerName .. " unlocked tier " .. milestone_id .. ": " .. milestone.name)
		end
	end
end

Players.PlayerAdded:Connect(initializePlayerData)
Players.PlayerRemoving:Connect(savePlayerData)

_G.checkAndUnlockTiers = checkAndUnlockTiers

print("[DataManager] Started")
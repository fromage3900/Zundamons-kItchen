--!strict
-- CookValidator: server-authoritative cooking quality from rhythm minigame timings.

local CompanionConfig = require(game.ReplicatedStorage.ConfigurationFiles.CompanionConfig)
local PlayerDataService = require(script.Parent.PlayerDataService)

local BASE_PERFECT = 20
local BASE_GREAT = 45
local BASE_GOOD = 80
local MASTERS_APRON_BOOST = 0.25

local CookValidator = {}

local function getWindowBoosts(player: Player): (number, number)
	local data = PlayerDataService.get(player)
	if not data then
		return 0, 0
	end

	local cardamonBoost = 0
	local active = data.active_companion
	if active then
		local def = CompanionConfig.getCompanion(active)
		if def.buff and def.buff.stat == "perfect_window" then
			cardamonBoost = def.buff.magnitude
		end
	end

	local apronBoost = 0
	if data.powerups and data.powerups.MastersApron and data.powerups.MastersApron > os.time() then
		apronBoost = MASTERS_APRON_BOOST
	end

	return cardamonBoost, apronBoost
end

function CookValidator.getWindowBoosts(player: Player): (number, number)
	return getWindowBoosts(player)
end

function CookValidator.judgeNoteDistance(dist: number, cardamonBoost: number, apronBoost: number): string
	local windowBoost = cardamonBoost + apronBoost
	local perfectThresh = BASE_PERFECT * (1 + windowBoost)
	local greatThresh = BASE_GREAT * (1 + cardamonBoost * 0.5 + apronBoost * 0.5)

	if dist < perfectThresh then
		return "perfect"
	elseif dist < greatThresh then
		return "great"
	elseif dist < BASE_GOOD then
		return "good"
	end
	return "miss"
end

function CookValidator.validateSession(player: Player, timings: { number }, noteCount: number): string
	if type(timings) ~= "table" or noteCount <= 0 then
		return "ok"
	end

	if #timings > noteCount + 2 or #timings < math.max(1, noteCount - 2) then
		return "ok"
	end

	for _, dist in ipairs(timings) do
		if type(dist) ~= "number" or dist < 0 or dist > 500 then
			return "ok"
		end
	end

	local cardamonBoost, apronBoost = getWindowBoosts(player)
	local perfects, greats, hits = 0, 0, 0

	for _, dist in ipairs(timings) do
		local tag = CookValidator.judgeNoteDistance(dist, cardamonBoost, apronBoost)
		if tag == "perfect" then
			perfects += 1
			hits += 1
		elseif tag == "great" then
			greats += 1
			hits += 1
		elseif tag == "good" then
			hits += 1
		end
	end

	if perfects == noteCount then
		return "perfect"
	elseif perfects >= math.ceil(noteCount * 0.6) then
		return "perfect"
	elseif hits >= math.ceil(noteCount * 0.5) then
		return "great"
	end
	return "ok"
end

return CookValidator

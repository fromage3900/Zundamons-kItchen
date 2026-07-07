-- [[Script] CompanionBuffServer (ref: RBXBECA557F11C442D2A370EE1018993A66)]]
local RF = game.ReplicatedStorage:WaitForChild("RemoteFunctions")
local GetActiveCompanionBuff = RF:WaitForChild("GetActiveCompanionBuff")
local GetCookingWindowBoost = RF:FindFirstChild("GetCookingWindowBoost")
if not GetCookingWindowBoost then
	GetCookingWindowBoost = Instance.new("RemoteFunction")
	GetCookingWindowBoost.Name = "GetCookingWindowBoost"
	GetCookingWindowBoost.Parent = RF
end

local CompanionConfig = require(game.ReplicatedStorage.ConfigurationFiles.CompanionConfig)
local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local MASTERS_APRON_BOOST = 0.25

local function companionMagnitude(player: Player, stat: string): number
	local d = PlayerDataService.get(player)
	if not d or not d.active_companion then
		return 0
	end
	local def = CompanionConfig.getCompanion(d.active_companion)
	if not def.buff or def.buff.stat ~= stat then
		return 0
	end
	return def.buff.magnitude
end

GetActiveCompanionBuff.OnServerInvoke = function(player, stat)
	return companionMagnitude(player, stat)
end

GetCookingWindowBoost.OnServerInvoke = function(player)
	local d = PlayerDataService.get(player)
	local cardamonBoost = companionMagnitude(player, "perfect_window")
	local apronBoost = 0
	if d and d.powerups and d.powerups.MastersApron and d.powerups.MastersApron > os.time() then
		apronBoost = MASTERS_APRON_BOOST
	end
	return cardamonBoost, apronBoost
end

print("[CompanionBuffServer] ready")

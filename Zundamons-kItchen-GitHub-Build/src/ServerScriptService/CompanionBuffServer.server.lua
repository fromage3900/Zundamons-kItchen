-- [[Script] CompanionBuffServer (ref: RBXBECA557F11C442D2A370EE1018993A66)]]
local RF = game.ReplicatedStorage:WaitForChild("RemoteFunctions")
local GetActiveCompanionBuff = RF:WaitForChild("GetActiveCompanionBuff")
local CompanionConfig = require(game.ReplicatedStorage.ConfigurationFiles.CompanionConfig)
local PlayerDataService = require(script.Parent.Services.PlayerDataService)

GetActiveCompanionBuff.OnServerInvoke = function(player, stat)
	local d = PlayerDataService.get(player)
	if not d then
		return 0
	end
	local active = d.active_companion
	if not active then
		return 0
	end
	local def = CompanionConfig.getCompanion(active)
	if not def.buff then
		return 0
	end
	if def.buff.stat == stat then
		return def.buff.magnitude
	end
	return 0
end

print("[CompanionBuffServer] ready")

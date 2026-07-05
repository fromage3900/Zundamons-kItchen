-- [[Script] CompanionBuffServer (ref: RBXBECA557F11C442D2A370EE1018993A66)]]
local RF = game.ReplicatedStorage:WaitForChild("RemoteFunctions")
local GetActiveCompanionBuff = RF:WaitForChild("GetActiveCompanionBuff")
GetActiveCompanionBuff.OnServerInvoke = function(player, stat)
    local d = _G.data and _G.data[player.Name]
    if not d then return 0 end
    local active = d.active_companion
    if not active then return 0 end
    local cat = shared.ZundaCompanionCatalog
    if not cat then return 0 end
    local def = cat[active]
    if not def or not def.buff then return 0 end
    if def.buff.stat == stat then return def.buff.magnitude end
    return 0
end
print("[CompanionBuffServer] ready")

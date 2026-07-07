-- [[ModuleScript] RewardCore]]
-- Thin re-export; canonical logic lives in ServerScriptService.Services.RewardSystem.

local SSS = game:GetService("ServerScriptService")
local RewardSystem = require(SSS.Services.RewardSystem)

_G.RewardCore = RewardSystem
return RewardSystem

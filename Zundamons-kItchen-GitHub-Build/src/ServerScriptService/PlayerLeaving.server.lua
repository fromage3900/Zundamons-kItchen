-- [[Script] PlayerLeaving (ref: RBX5EFF58E6EFFA4AABB05BF684AB3E4CD2)]]
local Players = game.Players
local SSS = game.ServerScriptService
local lms = SSS:WaitForChild("LootModule")
local loot_module = require(lms)

Players.PlayerRemoving:Connect(function(player)
	loot_module.eraseData(player)
end)
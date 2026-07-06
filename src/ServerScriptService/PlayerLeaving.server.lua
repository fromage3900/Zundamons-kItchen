-- [[Script] PlayerLeaving (ref: RBX5EFF58E6EFFA4AABB05BF684AB3E4CD2)]]
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local configFiles = RS:WaitForChild("ConfigurationFiles")
local loot_module = require(configFiles:WaitForChild("LootModule"))

Players.PlayerRemoving:Connect(function(player)
	loot_module.eraseData(player)
end)
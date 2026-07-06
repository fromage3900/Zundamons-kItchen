-- [[Script] RobuxStoreServer]]
-- Wires MarketplaceService as the sole ProcessReceipt owner.
local RS = game:GetService("ReplicatedStorage")
local MarketplaceService = require(script.Parent.Services.MarketplaceService)

local RF = RS:WaitForChild("RemoteFunctions")
local promptRF = RF:FindFirstChild("PromptRobuxPurchase")
if not promptRF then
	promptRF = Instance.new("RemoteFunction")
	promptRF.Name = "PromptRobuxPurchase"
	promptRF.Parent = RF
end

MarketplaceService.init()

promptRF.OnServerInvoke = function(player, productId)
	return MarketplaceService.promptPurchase(player, productId)
end

print("[RobuxStoreServer] Delegating to MarketplaceService")

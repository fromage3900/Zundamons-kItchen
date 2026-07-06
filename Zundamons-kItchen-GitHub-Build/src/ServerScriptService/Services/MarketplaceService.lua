-- [[ModuleScript] MarketplaceService]]
-- Single ProcessReceipt owner; catalog from MarketplaceConfig.

local MPS = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local MarketplaceConfig = require(RS.ConfigurationFiles.MarketplaceConfig)
local PlayerDataService = require(script.Parent.PlayerDataService)

local MarketplaceService = {}

local RE = RS:WaitForChild("RemoteEvents")
local purchaseEv = RE:FindFirstChild("PurchaseResult")
if not purchaseEv then
	purchaseEv = Instance.new("RemoteEvent")
	purchaseEv.Name = "PurchaseResult"
	purchaseEv.Parent = RE
end

local CompanionOwnedSync = RE:WaitForChild("CompanionOwnedSync")

function MarketplaceService.processReceipt(info)
	local player = Players:GetPlayerByUserId(info.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local prod = MarketplaceConfig.getProduct(info.ProductId)
	if not prod then
		warn("[MarketplaceService] Unknown product:", info.ProductId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local d = PlayerDataService.getOrCreate(player)

	if prod.type == "companion" then
		d["companion_owned_" .. prod.key] = true
		CompanionOwnedSync:FireClient(player, prod.key, true)
	elseif prod.type == "recipe" then
		if not d.recipes_unlocked then
			d.recipes_unlocked = {}
		end
		d.recipes_unlocked[prod.key] = true
	elseif prod.type == "accessory" then
		d["accessory_" .. prod.key] = true
	end

	purchaseEv:FireClient(player, prod.name, prod.type)
	print("[MarketplaceService]", player.Name, "purchased", prod.name)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

function MarketplaceService.promptPurchase(player: Player, productId: number): boolean
	if typeof(productId) ~= "number" or not MarketplaceConfig.isValidProductId(productId) then
		warn("[MarketplaceService] Rejected unlisted product prompt from", player.Name, productId)
		return false
	end
	MPS:PromptProductPurchase(player, productId)
	return true
end

function MarketplaceService.init()
	MPS.ProcessReceipt = MarketplaceService.processReceipt
	local count = 0
	for _ in pairs(MarketplaceConfig.products) do
		count += 1
	end
	print("[MarketplaceService] Ready —", count, "products")
end

return MarketplaceService

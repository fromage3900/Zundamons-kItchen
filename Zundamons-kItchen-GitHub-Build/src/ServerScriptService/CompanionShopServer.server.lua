-- [[Script] CompanionShopServer (ref: RBX9AC1C5F5123A408F978AA7077D298CC8)]]
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game.ReplicatedStorage
local RE = RS:WaitForChild("RemoteEvents")
local RF = RS:WaitForChild("RemoteFunctions")

local PurchaseCompanion = RE:WaitForChild("PurchaseCompanion")
local CompanionOwnedSync = RE:WaitForChild("CompanionOwnedSync")
local SetCompanionRE = RE:WaitForChild("SetCompanion")
local GetCompanionCatalog = RF:WaitForChild("GetCompanionCatalog")
local GetOwnedCompanions = RF:WaitForChild("GetOwnedCompanions")

local PlayerDataService = require(script.Parent.Services.PlayerDataService)
local CompanionConfig = require(RS.ConfigurationFiles.CompanionConfig)
local MarketplaceConfig = require(RS.ConfigurationFiles.MarketplaceConfig)

-- Premium companion DevProduct IDs (single catalog — edit MarketplaceConfig.lua)
local DEVPRODUCT_IDS = MarketplaceConfig.companionDevProductIds

PurchaseCompanion.OnServerEvent:Connect(function(player, compType)
	local def = CompanionConfig.companions[compType]
	if not def or def.free then
		return
	end
	if PlayerDataService.get(player) and PlayerDataService.get(player)["companion_owned_" .. compType] then
		return -- already owned
	end
	local pid = DEVPRODUCT_IDS[compType]
	if pid and pid ~= 0 then
		pending[player.UserId] = pending[player.UserId] or {}
		pending[player.UserId][pid] = compType
		local ok, err = pcall(function()
			MarketplaceService:PromptProductPurchase(player, pid)
		end)
		if not ok then
			warn("[CompanionShop] prompt failed:", err)
		end
	else
		if not RunService:IsStudio() then
			warn("[CompanionShop] DevProduct missing for " .. compType .. " — purchase blocked in live servers")
			return
		end
		-- Studio test grant only (replace DEVPRODUCT_IDS before public publish)
		local data = PlayerDataService.getOrCreate(player)
		data["companion_owned_" .. compType] = true
		CompanionOwnedSync:FireClient(player, compType, true)
		print(string.format("[CompanionShop] TEST grant: %s -> %s", player.Name, compType))
	end
end)

-- Premium companion receipts: register DevProduct IDs in RobuxStoreServer PRODUCTS.
-- Do not assign MarketplaceService.ProcessReceipt here — RobuxStoreServer owns the handler.

GetCompanionCatalog.OnServerInvoke = function(player)
	return CompanionConfig.companions
end

GetOwnedCompanions.OnServerInvoke = function(player)
	local owned = { zundamon = true, zundacat = true, zundabunny = true, tantanmon = true }
	local data = PlayerDataService.get(player)
	if data then
		for k, v in pairs(data) do
			if v == true then
				local pre, name = string.match(k, "(companion_owned_)(.+)")
				if pre then
					owned[name] = true
				end
			end
		end
		owned.__active = data.active_companion or "zundamon"
	end
	return owned
end

print("[CompanionShopServer] online")

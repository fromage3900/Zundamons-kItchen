-- [[Script] MarketplaceService (unified ProcessReceipt)]]
-- Single MPS.ProcessReceipt for ALL products (companions, recipes, accessories).
-- Replaces dual ProcessReceipt in RobuxStoreServer + CompanionShopServer.
-- RemoteEvents/RemoteFunctions (PurchaseResult, PromptRobuxPurchase,
-- PurchaseCompanion, GetCompanionCatalog, GetOwnedCompanions, CompanionOwnedSync)
-- remain in their original scripts — only the ProcessReceipt callback is unified here.

local MPS = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RE = RS:WaitForChild("RemoteEvents")
local PlayerDataService = require(script.Parent.PlayerDataService)

-- ── Unified Product Catalog ──────────────────────────────────────
-- Product IDs are placeholders — replace with real IDs.
local PRODUCTS = {
	-- Companions (purchasable via RobuxStore IDs)
	[1111111101] = { type="companion", key="zundacat"     },
	[1111111102] = { type="companion", key="zundabunny"   },
	[1111111103] = { type="companion", key="tantanmon"    },
	-- Premium companions
	[1111111110] = { type="companion", key="ankomon"      },
	[1111111111] = { type="companion", key="cardamon"     },
	[1111111112] = { type="companion", key="antimon"      },
	[1111111113] = { type="companion", key="sakuradamon"  },
	-- Recipes
	[1111111104] = { type="recipe",    key="Premium Ramen" },
	[1111111105] = { type="recipe",    key="Party Cake"    },
	[1111111106] = { type="recipe",    key="Truffle Soup"  },
	-- Accessories
	[1111111107] = { type="accessory", key="crown"         },
	[1111111108] = { type="accessory", key="bow"           },
	[1111111109] = { type="accessory", key="chefhat"       },
}

local purchaseEv = RE:FindFirstChild("PurchaseResult")
local companionSync = RE:FindFirstChild("CompanionOwnedSync")

local function grantProduct(player, product)
	local d = PlayerDataService.getOrCreate(player)
	local t, k = product.type, product.key
	if t == "companion" then
		d["companion_owned_" .. k] = true
		if companionSync then companionSync:FireClient(player, k, true) end
	elseif t == "recipe" then
		if not d.recipes_unlocked then d.recipes_unlocked = {} end
		d.recipes_unlocked[k] = true
	elseif t == "accessory" then
		d["accessory_" .. k] = true
	end
	if purchaseEv then purchaseEv:FireClient(player, product.name or k, t) end
	print("[Marketplace] Granted " .. (product.name or k) .. " to " .. player.Name)
end

MPS.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local prod = PRODUCTS[receiptInfo.ProductId]
	if not prod then
		warn("[Marketplace] Unknown product: " .. receiptInfo.ProductId)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	grantProduct(player, prod)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

local productCount = 0; for _ in pairs(PRODUCTS) do productCount = productCount + 1 end
print("[MarketplaceService] Unified — " .. productCount .. " products, single ProcessReceipt")

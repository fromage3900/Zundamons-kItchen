-- [[ModuleScript] MarketplaceService (ref: RBX-Consolidated-Marketplace)]]
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local PlayerDataService = require(game.ServerScriptService.Services.PlayerDataService)

local MarketplaceSvc = {}

-- [[ PRODUCT CATALOGUE FROM RobuxStoreServer ]]
local PRODUCTS = {
    -- COMPANIONS
    [1111111101] = { type="companion",  key="zundacat",     name="ZundaCat Companion"  },
    [1111111102] = { type="companion",  key="zundabunny",   name="ZundaBunny Companion"},
    [1111111103] = { type="companion",  key="tantanmon",    name="TantanMon Companion" },
    -- PREMIUM RECIPES
    [1111111104] = { type="recipe",     key="Premium Ramen",name="Premium Ramen Recipe"},
    [1111111105] = { type="recipe",     key="Party Cake",   name="Party Cake Recipe"   },
    [1111111106] = { type="recipe",     key="Truffle Soup", name="Truffle Soup Recipe" },
    -- ACCESSORIES
    [1111111107] = { type="accessory",  key="crown",        name="Gold Crown"          },
    [1111111108] = { type="accessory",  key="bow",          name="Pink Bow"            },
    [1111111109] = { type="accessory",  key="chefhat",      name="Chef Hat"            },
}

-- Add companion-specific mapping from CompanionShopServer if needed
-- (Though RobuxStoreServer seems to cover most already)
-- Note: CompanionShopServer used a DEVPRODUCT_IDS table which we should ideally merge or reference.

local RE = RS:WaitForChild("RemoteEvents")
local PurchaseResult = RE:FindFirstChild("PurchaseResult") or (function()
    local re = Instance.new("RemoteEvent")
    re.Name = "PurchaseResult"
    re.Parent = RE
    return re
end)()

local CompanionOwnedSync = RE:WaitForChild("CompanionOwnedSync")

function MarketplaceSvc.processReceipt(receiptInfo)
    local userId = receiptInfo.PlayerId
    local productId = receiptInfo.ProductId
    local player = Players:GetPlayerByUserId(userId)
    
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local prod = PRODUCTS[productId]
    if not prod then
        -- Check if it's a dynamic companion purchase from CompanionShopServer logic
        -- In a real scenario, all devproducts should be in the PRODUCTS table.
        warn("[MarketplaceService] Unknown product: " .. productId)
        return Enum.ProductPurchaseDecision.PurchaseGranted -- Or NotProcessedYet if strictly enforcing
    end

    local d = PlayerDataService.getOrCreate(player)

    if prod.type == "companion" then
        d["companion_owned_" .. prod.key] = true
        CompanionOwnedSync:FireClient(player, prod.key, true)
    elseif prod.type == "recipe" then
        if not d.recipes_unlocked then d.recipes_unlocked = {} end
        d.recipes_unlocked[prod.key] = true
    elseif prod.type == "accessory" then
        d["accessory_" .. prod.key] = true
    end

    PurchaseResult:FireClient(player, prod.name, prod.type)
    print("[MarketplaceService] " .. player.Name .. " purchased " .. prod.name)
    
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

function MarketplaceSvc.init()
    MarketplaceService.ProcessReceipt = MarketplaceSvc.processReceipt
    print("[MarketplaceService] ProcessReceipt initialized")
end

return MarketplaceSvc

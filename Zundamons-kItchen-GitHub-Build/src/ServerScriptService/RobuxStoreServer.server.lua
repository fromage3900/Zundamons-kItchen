-- [[Script] RobuxStoreServer (ref: RBX8323588801564DE18ADA95D1FA09CE8C)]]
-- RobuxStoreServer: processes Robux DevProduct purchases and grants items/companions.
-- ⚠️  Replace placeholder product IDs with real ones from the Roblox Creator Dashboard.
local MPS     = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")

-- ── PRODUCT CATALOGUE ────────────────────────────────────────────────────────
-- Format: [productId] = { type, key, displayName }
-- type: "companion" | "recipe" | "accessory"
-- key:  stored as _G.data[playerName]["companion_owned_KEY"] = true
local PRODUCTS = {
    -- COMPANIONS  (replace IDs!)
    [1111111101] = { type="companion",  key="zundacat",     name="ZundaCat Companion"  },
    [1111111102] = { type="companion",  key="zundabunny",   name="ZundaBunny Companion"},
    [1111111103] = { type="companion",  key="tantanmon",    name="TantanMon Companion" },
    -- PREMIUM RECIPES
    [1111111104] = { type="recipe",     key="Premium Ramen",name="Premium Ramen Recipe"},
    [1111111105] = { type="recipe",     key="Party Cake",   name="Party Cake Recipe"   },
    [1111111106] = { type="recipe",     key="Truffle Soup", name="Truffle Soup Recipe" },
    -- ACCESSORIES (cosmetic flags)
    [1111111107] = { type="accessory",  key="crown",        name="Gold Crown"          },
    [1111111108] = { type="accessory",  key="bow",          name="Pink Bow"            },
    [1111111109] = { type="accessory",  key="chefhat",      name="Chef Hat"            },
}

-- Notify client of purchase result
local RE      = RS:WaitForChild("RemoteEvents")
local purchaseEv = RE:FindFirstChild("PurchaseResult")
if not purchaseEv then
    purchaseEv = Instance.new("RemoteEvent"); purchaseEv.Name="PurchaseResult"; purchaseEv.Parent=RE
end

MPS.ProcessReceipt = function(info)
    local player = Players:GetPlayerByUserId(info.PlayerId)
    if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

    local prod = PRODUCTS[info.ProductId]
    if not prod then
        warn("[RobuxStore] Unknown product: "..info.ProductId)
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Grant item
    if not _G.data then _G.data = {} end
    if not _G.data[player.Name] then _G.data[player.Name] = {} end
    local d = _G.data[player.Name]

    if prod.type == "companion" then
        d["companion_owned_"..prod.key] = true
    elseif prod.type == "recipe" then
        if not d.recipes_unlocked then d.recipes_unlocked={} end
        d.recipes_unlocked[prod.key] = true
    elseif prod.type == "accessory" then
        d["accessory_"..prod.key] = true
    end

    -- Notify client
    purchaseEv:FireClient(player, prod.name, prod.type)

    print("[RobuxStore] "..player.Name.." purchased "..prod.name)
    return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- Client requests a purchase prompt
local RF = RS:WaitForChild("RemoteFunctions")
local promptRF = RF:FindFirstChild("PromptRobuxPurchase")
if not promptRF then
    promptRF = Instance.new("RemoteFunction"); promptRF.Name="PromptRobuxPurchase"; promptRF.Parent=RF
end
promptRF.OnServerInvoke = function(player, productId)
    MPS:PromptProductPurchase(player, productId)
    return true
end

print("[RobuxStoreServer] Ready — "..#(function() local t={} for k in pairs(PRODUCTS) do t[#t+1]=k end return t end()).." products")

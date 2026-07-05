-- [[Script] ZundaGatherServer (ref: RBX382D14910F4C466898CDB20D388810EF)]]
-- ZundaGatherServer: Click-to-gather for Zunda forest plants and mystery loot
-- Lives at ServerScriptService.Garden.ZundaGatherServer

local Players  = game:GetService("Players")
local RS       = game:GetService("ReplicatedStorage")
local SSS      = game:GetService("ServerScriptService")
local Debris   = game:GetService("Debris")
local TweenS   = game:GetService("TweenService")

local lootMod  = require(SSS.LootModule)

local RE_notify = RS:FindFirstChild("RemoteEvents") and RS.RemoteEvents:FindFirstChild("NotifyPlayer")

-- Respawn timing (seconds)
local RESPAWN_FLOWER     = 25
local RESPAWN_BOUQUET    = 45
local RESPAWN_PEA        = 35
local RESPAWN_MUSHROOM   = 25
local RESPAWN_BERRY      = 20
local RESPAWN_ROOT       = 22
local RESPAWN_MYSTERY    = 90
local RESPAWN_EDAMAME    = 30
local RESPAWN_LEAF       = 22
local RESPAWN_SWEET_PEA  = 28
local RESPAWN_PEA_FLOWER = 30

-- Mystery loot table
local MYSTERY_LOOT = {
    "Zunda Flower", "Zunda Flower", "Zunda Pea", "Zunda Pea",
    "Gold Ore", "Marble Rock", "Apple", "Wheat",
}

-- Grant items to player using LootModule
local function grantItems(player, items)
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    -- generateLoot signature: (player, lootTable, position)
    pcall(function()
        lootMod.generateLoot(player, items, hrp.Position)
    end)
end

-- Pop notification
local function notify(player, message)
    if RE_notify then
        RE_notify:FireClient(player, "gather_success", message)
    end
end

-- Hide the node visually + re-enable after respawn
local function consumeNode(node, respawnSec)
    node:SetAttribute("Available", false)
    local cd = node:FindFirstChildOfClass("ClickDetector")
    if cd then cd.MaxActivationDistance = 0 end
    -- Fade out
    local origTransparency = node.Transparency
    local tween = TweenS:Create(node, TweenInfo.new(0.4), {Transparency = 1, Size = node.Size * 0.4})
    tween:Play()
    -- Schedule respawn
    task.delay(respawnSec, function()
        if not node.Parent then return end
        node:SetAttribute("Available", true)
        node.Size = node:GetAttribute("_origSize") or node.Size
        local back = TweenS:Create(node, TweenInfo.new(0.4), {Transparency = origTransparency})
        back:Play()
        if cd then cd.MaxActivationDistance = 16 end
    end)
end

local function bindNode(node)
    local cd = node:FindFirstChildOfClass("ClickDetector")
    if not cd then return end
    -- Store original size for respawn
    node:SetAttribute("_origSize", node.Size)

    cd.MouseClick:Connect(function(player)
        if not node:GetAttribute("Available") then return end
        local rtype = node:GetAttribute("ResourceType")

        if rtype == "ZundaFlower" then
            local yield = node:GetAttribute("Yield") or 3
            local items = {}
            for i=1,yield do table.insert(items, "Zunda Flower") end
            grantItems(player, items)
            notify(player, "🌼 +" .. yield .. " Zunda Flower")
            consumeNode(node, RESPAWN_FLOWER)

        elseif rtype == "ZundaPea" then
            local yield = node:GetAttribute("Yield") or 2
            local items = {}
            for i=1,yield do table.insert(items, "Zunda Pea") end
            grantItems(player, items)
            notify(player, "🝒 +" .. yield .. " Zunda Pea")
            consumeNode(node, RESPAWN_PEA)

        elseif rtype == "Zunda Mushroom" then
            local yield = node:GetAttribute("Yield") or 3
            local items = {}
            for i=1,yield do table.insert(items, "Zunda Mushroom") end
            grantItems(player, items)
            notify(player, "🝄 +" .. yield .. " Zunda Mushroom")
            consumeNode(node, RESPAWN_MUSHROOM)

        elseif rtype == "Zunda Berry" then
            local yield = node:GetAttribute("Yield") or 4
            local items = {}
            for i=1,yield do table.insert(items, "Zunda Berry") end
            grantItems(player, items)
            notify(player, "🝓 +" .. yield .. " Zunda Berry")
            consumeNode(node, RESPAWN_BERRY)

        elseif rtype == "Zunda Root" then
            local yield = node:GetAttribute("Yield") or 3
            local items = {}
            for i=1,yield do table.insert(items, "Zunda Root") end
            grantItems(player, items)
            notify(player, "🥜 +" .. yield .. " Zunda Root")
            consumeNode(node, RESPAWN_ROOT)

        elseif rtype == "MysteryLoot" then
            -- Pick 2-3 random items from the mystery table
            local items = {}
            local n = math.random(2,3)
            for i=1,n do
                table.insert(items, MYSTERY_LOOT[math.random(1,#MYSTERY_LOOT)])
            end
            grantItems(player, items)
            notify(player, "\u{2728} Mystery loot found!")
            consumeNode(node, RESPAWN_MYSTERY)

        elseif rtype == "SaltedPeaBouquet" then
            -- Rare bouquet: yields 1 "Salted Pea Bouquet" item per pick
            local yield = node:GetAttribute("Yield") or 1
            local items = {}
            for i=1,yield do table.insert(items, "Salted Pea Bouquet") end
            grantItems(player, items)
            notify(player, "\xf0\x9f\x92\x90 +" .. yield .. " Salted Pea Bouquet")
            consumeNode(node, RESPAWN_BOUQUET)

        elseif rtype == "EdamamePod" then
            local yield = node:GetAttribute("Yield") or 2
            local items = {}
            for i = 1, yield do
                table.insert(items, "Edamame Pod")
            end
            grantItems(player, items)
            notify(player, "🫛 +" .. yield .. " Edamame Pod")
            consumeNode(node, RESPAWN_EDAMAME)

        elseif rtype == "ZundaLeaf" then
            local yield = node:GetAttribute("Yield") or 3
            local items = {}
            for i = 1, yield do
                table.insert(items, "Zunda Leaf")
            end
            grantItems(player, items)
            notify(player, "🍃 +" .. yield .. " Zunda Leaf")
            consumeNode(node, RESPAWN_LEAF)

        elseif rtype == "SweetPea" then
            local yield = node:GetAttribute("Yield") or 2
            local items = {}
            for i = 1, yield do
                table.insert(items, "Sweet Pea")
            end
            grantItems(player, items)
            notify(player, "🫛 +" .. yield .. " Sweet Pea")
            consumeNode(node, RESPAWN_SWEET_PEA)

        elseif rtype == "PeaFlower" then
            local yield = node:GetAttribute("Yield") or 2
            local items = {}
            for i = 1, yield do
                table.insert(items, "Pea Flower")
            end
            grantItems(player, items)
            notify(player, "🌸 +" .. yield .. " Pea Flower")
            consumeNode(node, RESPAWN_PEA_FLOWER)
        end
    end)
end

-- Bind every gathering node in the GameplayLoopArea
local function scanFolder(folder)
    for _, node in ipairs(folder:GetDescendants()) do
        if node:IsA("BasePart") and node:GetAttribute("ResourceType") and node:FindFirstChildOfClass("ClickDetector") then
            bindNode(node)
        end
    end
end

local loopArea = workspace:WaitForChild("GameplayLoopArea", 10)
if loopArea then
    local loopGather = loopArea:WaitForChild("GatheringNodes", 5)
    if loopGather then
        scanFolder(loopGather)
        -- Bind new nodes that get added (e.g. SceneSetup rebuilds)
        loopGather.ChildAdded:Connect(function(child)
            task.wait(0.1)
            if child:IsA("BasePart") and child:GetAttribute("ResourceType") and child:FindFirstChildOfClass("ClickDetector") then
                bindNode(child)
            end
        end)
    end
end

print("[ZundaGatherServer] Ready - click-to-gather active")
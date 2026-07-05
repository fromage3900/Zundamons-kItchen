-- [[LocalScript] CompendiumScript (ref: RBX78D583747AA44852A8FD07E0A85D2D23)]]
-- Compendium: Recipes + Items/Prices browser
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Tween   = game:GetService("TweenService")
local UIS     = game:GetService("UserInputService")
local player  = Players.LocalPlayer
local gui     = script.Parent

-- ── DATA (mirrors server configs) ────────────────────────
local RECIPES = {
    { name="Bread",              emoji="🍞", ing={Wheat=10},                        gold=60  },
    { name="Apple Pie",          emoji="🥧", ing={Apple=3, Wheat=5},                gold=100 },
    { name="Zunda Bread",        emoji="🫓", ing={Wheat=15, Apple=2},               gold=140 },
    { name="Zunda Mochi",        emoji="🍡", ing={Wheat=8, Apple=4},                gold=160 },
    { name="Royal Stew",         emoji="🍲", ing={Wheat=8, Apple=5, Gold=1},        gold=200 },
    { name="Fancy Pie",          emoji="🎂", ing={Apple=7, Wheat=12, Gold=2},       gold=280 },
    { name="Zundamon's Banquet", emoji="🎉", ing={Wheat=20, Apple=10, Gold=3},      gold=400 },
    { name="Ultimate Feast",     emoji="👑", ing={Wheat=30, Apple=20, Gold=5},      gold=600 },
}

local ITEMS = {
    { name="Apple",        emoji="🍎", cat="Forage",  price=5   },
    { name="Wheat",        emoji="🌾", cat="Forage",  price=10  },
    { name="WheatSeed",    emoji="🫘", cat="Forage",  price=1   },
    { name="Pine Cone",    emoji="🌲", cat="Forage",  price=5   },
    { name="Zunda Flower", emoji="🌸", cat="Forage",  price=12  },
    { name="Zunda Pea",    emoji="🫛", cat="Forage",  price=18  },
    { name="Zunda Berry",  emoji="🫐", cat="Forage",  price=20  },
    { name="Zunda Mushroom",emoji="🍄",cat="Forage",  price=25  },
    { name="Zunda Root",   emoji="🌱", cat="Forage",  price=22  },
    { name="Rock",         emoji="🪨", cat="Mining",  price=10  },
    { name="Iron Ore",     emoji="🔩", cat="Mining",  price=8   },
    { name="Gold Ore",     emoji="💛", cat="Mining",  price=30  },
    { name="Marble Rock",  emoji="🔷", cat="Mining",  price=15  },
    { name="Wood Log",     emoji="🪵", cat="Mining",  price=20  },
    { name="Bread",        emoji="🍞", cat="Crafted", price=60  },
    { name="Apple Pie",    emoji="🥧", cat="Crafted", price=100 },
    { name="Zunda Bread",  emoji="🫓", cat="Crafted", price=140 },
    { name="Zunda Mochi",  emoji="🍡", cat="Crafted", price=160 },
}

-- ── COLORS ────────────────────────────────────────────────
local C = {
    bg     = Color3.fromRGB(252, 248, 240),
    border = Color3.fromRGB(150, 180, 255),   -- blue theme for compendium
    text   = Color3.fromRGB(68,  52,  78),
    sub    = Color3.fromRGB(140, 120, 140),
    tabAct = Color3.fromRGB(150, 180, 255),
    tabIdle= Color3.fromRGB(228, 232, 248),
    card   = Color3.fromRGB(244, 242, 255),
}

-- ── BUILD PANEL ───────────────────────────────────────────
local panel = Instance.new("Frame", gui)
panel.Name = "Panel"; panel.Size = UDim2.new(0,560,0,540)
panel.AnchorPoint = Vector2.new(0.5,0.5); panel.Position = UDim2.new(0.5,0,0.5,0)
panel.BackgroundColor3 = C.bg; panel.BorderSizePixel = 0; panel.Visible = false
Instance.new("UICorner",panel).CornerRadius = UDim.new(0,22)
local bst=Instance.new("UIStroke",panel); bst.Thickness=3; bst.Color=C.border

-- Title + close
local title = Instance.new("TextLabel",panel)
title.Size=UDim2.new(1,-70,0,52); title.Position=UDim2.new(0,18,0,12)
title.BackgroundTransparency=1; title.Text="📚  Compendium"
title.Font=Enum.Font.FredokaOne; title.TextSize=28
title.TextColor3=C.text; title.TextXAlignment=Enum.TextXAlignment.Left

local closeBtn=Instance.new("TextButton",panel)
closeBtn.Size=UDim2.new(0,38,0,38); closeBtn.Position=UDim2.new(1,-52,0,14)
closeBtn.BackgroundColor3=C.border; closeBtn.Text="✕"
closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=16
closeBtn.TextColor3=Color3.fromRGB(255,255,255); closeBtn.BorderSizePixel=0
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,10)

-- Tab bar
local tabBar=Instance.new("Frame",panel)
tabBar.Size=UDim2.new(1,-32,0,36); tabBar.Position=UDim2.new(0,16,0,66)
tabBar.BackgroundTransparency=1; tabBar.BorderSizePixel=0
local tbl=Instance.new("UIListLayout",tabBar)
tbl.FillDirection=Enum.FillDirection.Horizontal; tbl.Padding=UDim.new(0,8)

local function mkTab(name,lbl,order)
    local b=Instance.new("TextButton",tabBar)
    b.Name="Tab_"..name; b.Size=UDim2.new(0,130,1,0); b.LayoutOrder=order
    b.BackgroundColor3=order==1 and C.tabAct or C.tabIdle
    b.Text=lbl; b.Font=Enum.Font.GothamBold; b.TextSize=14
    b.TextColor3=order==1 and Color3.fromRGB(255,255,255) or C.text
    b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    return b
end
local tabRecipes = mkTab("recipes","🍳  Recipes",1)
local tabItems   = mkTab("items",  "📦  Items",  2)
local tabZones   = mkTab("zones",  "🗺  Zones",  3)

-- Content scroll
local scroll=Instance.new("ScrollingFrame",panel)
scroll.Name="Content"; scroll.Size=UDim2.new(1,-32,0,408)
scroll.Position=UDim2.new(0,16,0,112); scroll.BackgroundColor3=Color3.fromRGB(244,240,234)
scroll.BorderSizePixel=0; scroll.ScrollBarThickness=5
scroll.ScrollBarImageColor3=C.border; scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",scroll).CornerRadius=UDim.new(0,14)
local ll=Instance.new("UIListLayout",scroll)
ll.Padding=UDim.new(0,6); ll.SortOrder=Enum.SortOrder.LayoutOrder
local pad=Instance.new("UIPadding",scroll)
pad.PaddingTop=UDim.new(0,8); pad.PaddingLeft=UDim.new(0,8)
pad.PaddingRight=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)

local function clearScroll()
    for _,c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
    end
    scroll.CanvasPosition=Vector2.new(0,0)
end

-- ── RECIPE CARDS ─────────────────────────────────────────
local function buildRecipeCard(r, idx)
    local card=Instance.new("Frame",scroll)
    card.Name="R_"..idx; card.Size=UDim2.new(1,0,0,80)
    card.LayoutOrder=idx; card.BackgroundColor3=C.card
    card.BorderSizePixel=0
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,12)
    local cs=Instance.new("UIStroke",card); cs.Thickness=1
    cs.Color=Color3.fromRGB(200,195,240)

    local em=Instance.new("TextLabel",card)
    em.Size=UDim2.new(0,52,0,52); em.Position=UDim2.new(0,8,0,14)
    em.BackgroundColor3=Color3.fromRGB(235,232,250)
    em.Text=r.emoji; em.Font=Enum.Font.GothamBold; em.TextSize=28
    em.TextXAlignment=Enum.TextXAlignment.Center; em.BorderSizePixel=0
    Instance.new("UICorner",em).CornerRadius=UDim.new(0,10)

    local nm=Instance.new("TextLabel",card)
    nm.Size=UDim2.new(1,-160,0,22); nm.Position=UDim2.new(0,68,0,10)
    nm.BackgroundTransparency=1; nm.Text=r.name
    nm.Font=Enum.Font.GothamBold; nm.TextSize=15
    nm.TextColor3=C.text; nm.TextXAlignment=Enum.TextXAlignment.Left

    -- Ingredients
    local ingParts={}
    for item,amt in pairs(r.ing) do
        table.insert(ingParts, amt.."x "..item)
    end
    local ingLbl=Instance.new("TextLabel",card)
    ingLbl.Size=UDim2.new(1,-160,0,18); ingLbl.Position=UDim2.new(0,68,0,32)
    ingLbl.BackgroundTransparency=1
    ingLbl.Text="Needs: "..table.concat(ingParts,", ")
    ingLbl.Font=Enum.Font.Gotham; ingLbl.TextSize=12
    ingLbl.TextColor3=C.sub; ingLbl.TextXAlignment=Enum.TextXAlignment.Left
    ingLbl.TextWrapped=true

    ingLbl.Size=UDim2.new(1,-160,0,36); -- taller for wrap

    -- Sell value badge
    local badge=Instance.new("Frame",card)
    badge.Size=UDim2.new(0,68,0,28); badge.Position=UDim2.new(1,-76,0,12)
    badge.BackgroundColor3=Color3.fromRGB(255,242,180); badge.BorderSizePixel=0
    Instance.new("UICorner",badge).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",badge).Color=Color3.fromRGB(220,180,50)
    local bLbl=Instance.new("TextLabel",badge)
    bLbl.Size=UDim2.new(1,0,1,0); bLbl.BackgroundTransparency=1
    bLbl.Text="💰 "..r.gold; bLbl.Font=Enum.Font.GothamBold
    bLbl.TextSize=13; bLbl.TextColor3=Color3.fromRGB(150,110,20)
end

-- ── ITEM CARDS ───────────────────────────────────────────
local CAT_COLOR = {
    Forage  = Color3.fromRGB(220,245,210),
    Mining  = Color3.fromRGB(225,220,240),
    Crafted = Color3.fromRGB(255,238,215),
}
local function buildItemCard(item, idx)
    local card=Instance.new("Frame",scroll)
    card.Name="I_"..idx; card.Size=UDim2.new(1,0,0,54)
    card.LayoutOrder=idx
    card.BackgroundColor3=(CAT_COLOR[item.cat] or C.card)
    card.BorderSizePixel=0
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,10)

    local em=Instance.new("TextLabel",card)
    em.Size=UDim2.new(0,40,1,0); em.Position=UDim2.new(0,6,0,0)
    em.BackgroundTransparency=1; em.Text=item.emoji
    em.Font=Enum.Font.GothamBold; em.TextSize=22
    em.TextXAlignment=Enum.TextXAlignment.Center

    local nm=Instance.new("TextLabel",card)
    nm.Size=UDim2.new(0,200,0,24); nm.Position=UDim2.new(0,50,0,7)
    nm.BackgroundTransparency=1; nm.Text=item.name
    nm.Font=Enum.Font.GothamBold; nm.TextSize=14
    nm.TextColor3=C.text; nm.TextXAlignment=Enum.TextXAlignment.Left

    local cat=Instance.new("TextLabel",card)
    cat.Size=UDim2.new(0,100,0,16); cat.Position=UDim2.new(0,50,0,30)
    cat.BackgroundTransparency=1; cat.Text=item.cat
    cat.Font=Enum.Font.Gotham; cat.TextSize=11
    cat.TextColor3=C.sub; cat.TextXAlignment=Enum.TextXAlignment.Left

    local priceLbl=Instance.new("TextLabel",card)
    priceLbl.Size=UDim2.new(0,80,1,0); priceLbl.Position=UDim2.new(1,-88,0,0)
    priceLbl.BackgroundTransparency=1
    priceLbl.Text="💰 "..item.price.."g"
    priceLbl.Font=Enum.Font.GothamBold; priceLbl.TextSize=14
    priceLbl.TextColor3=Color3.fromRGB(160,120,30)
    priceLbl.TextXAlignment=Enum.TextXAlignment.Right
end

-- ── ZONE CARDS ───────────────────────────────────────────
local ZONES_INFO = {
    {emoji="🏘",name="Zunda Village",   desc="Spawn area. Town shops & NPC guests.",       pos="(47, 4, -74)"},
    {emoji="🍳",name="Kitchen Garden",  desc="Farming, cooking & the main gameplay loop.", pos="(9, 4, -41)" },
    {emoji="🗻",name="Eastern Peaks",   desc="Elevated highlands near the east pyramid.",  pos="(130, 23, 73)"},
    {emoji="✨",name="Mystic Heights",  desc="High cliffs. Best stargazing spot!",          pos="(149, 35, -195)"},
}
local function buildZoneCard(z, idx)
    local card=Instance.new("Frame",scroll)
    card.Name="Z_"..idx; card.Size=UDim2.new(1,0,0,72)
    card.LayoutOrder=idx; card.BackgroundColor3=Color3.fromRGB(238,240,255)
    card.BorderSizePixel=0
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,12)
    local cs=Instance.new("UIStroke",card); cs.Thickness=1.5; cs.Color=C.border

    local em=Instance.new("TextLabel",card)
    em.Size=UDim2.new(0,52,0,52); em.Position=UDim2.new(0,8,0,10)
    em.BackgroundColor3=Color3.fromRGB(225,228,250); em.Text=z.emoji
    em.Font=Enum.Font.GothamBold; em.TextSize=28
    em.TextXAlignment=Enum.TextXAlignment.Center; em.BorderSizePixel=0
    Instance.new("UICorner",em).CornerRadius=UDim.new(0,10)

    local nm=Instance.new("TextLabel",card)
    nm.Size=UDim2.new(1,-180,0,22); nm.Position=UDim2.new(0,68,0,10)
    nm.BackgroundTransparency=1; nm.Text=z.name
    nm.Font=Enum.Font.GothamBold; nm.TextSize=15
    nm.TextColor3=C.text; nm.TextXAlignment=Enum.TextXAlignment.Left

    local desc=Instance.new("TextLabel",card)
    desc.Size=UDim2.new(1,-100,0,28); desc.Position=UDim2.new(0,68,0,32)
    desc.BackgroundTransparency=1; desc.Text=z.desc
    desc.Font=Enum.Font.Gotham; desc.TextSize=12
    desc.TextColor3=C.sub; desc.TextXAlignment=Enum.TextXAlignment.Left
    desc.TextWrapped=true

    local pos=Instance.new("TextLabel",card)
    pos.Size=UDim2.new(0,100,1,0); pos.Position=UDim2.new(1,-110,0,0)
    pos.BackgroundTransparency=1; pos.Text=z.pos
    pos.Font=Enum.Font.Code; pos.TextSize=11
    pos.TextColor3=Color3.fromRGB(160,150,180); pos.TextXAlignment=Enum.TextXAlignment.Right
end

-- ── TAB SWITCHING ─────────────────────────────────────────
local activeTab = "recipes"
local function switchTab(id)
    activeTab = id
    for _, btn in ipairs({tabRecipes, tabItems, tabZones}) do
        local isActive = btn.Name == "Tab_"..id
        btn.BackgroundColor3 = isActive and C.tabAct or C.tabIdle
        btn.TextColor3 = isActive and Color3.fromRGB(255,255,255) or C.text
    end
    clearScroll()
    if id == "recipes" then
        for i,r in ipairs(RECIPES) do buildRecipeCard(r,i) end
    elseif id == "items" then
        for i,item in ipairs(ITEMS) do buildItemCard(item,i) end
    elseif id == "zones" then
        for i,z in ipairs(ZONES_INFO) do buildZoneCard(z,i) end
    end
end

tabRecipes.MouseButton1Click:Connect(function() switchTab("recipes") end)
tabItems.MouseButton1Click:Connect(function()   switchTab("items")   end)
tabZones.MouseButton1Click:Connect(function()   switchTab("zones")   end)

-- ── TOGGLE ────────────────────────────────────────────────
local open = false
local function toggle()
    open = not open
    panel.Visible = open
    if open then
        if scroll:FindFirstChildOfClass("Frame") == nil then switchTab("recipes") end
        panel.Size = UDim2.new(0,560,0,10)
        Tween:Create(panel,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.new(0,560,0,540)}):Play()
    end
end
closeBtn.MouseButton1Click:Connect(function() open=true; toggle() end)

-- Wire HudBtn_compendium
task.spawn(function()
    local pg = player:WaitForChild("PlayerGui")
    local hud = pg:WaitForChild("ZundaHUD",15)
    if hud then
        local bar = hud:WaitForChild("HudButtons",8)
        if bar then
            local btn = bar:FindFirstChild("HudBtn_compendium")
            if btn then btn.MouseButton1Click:Connect(toggle) end
        end
    end
end)

UIS.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.C then toggle() end
end)

print("[Compendium] Ready — C key or compendium button")

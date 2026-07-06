-- [[LocalScript] PouchScript (ref: RBX5E076AB184F24934A1E9503A5FA7AEDC)]]
-- ZundaPouch/PouchScript
-- Full bag UI reading _G.data via RequestData RemoteFunction.
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Tween   = game:GetService("TweenService")
local UIS     = game:GetService("UserInputService")

local player  = Players.LocalPlayer
local ClientGuiBootstrap = require(RS.ConfigurationFiles.ClientGuiBootstrap)
local gui     = ClientGuiBootstrap.createScreenGui(player, "ZundaPouch", 22)
local RF      = RS:WaitForChild("RemoteFunctions")
local reqData = RF:WaitForChild("RequestData")

-- ─── ITEM METADATA ────────────────────────────────────────
local ITEM_META = {
    -- Forage
    ["Zunda Flower"]    = { emoji="🌸", cat="forage",  color=Color3.fromRGB(255,182,200) },
    ["ZundaFlower"]     = { emoji="🌸", cat="forage",  color=Color3.fromRGB(255,182,200) },
    ["Zunda Pea"]       = { emoji="🫛", cat="forage",  color=Color3.fromRGB(130,200,100) },
    ["ZundaPea"]        = { emoji="🫛", cat="forage",  color=Color3.fromRGB(130,200,100) },
    ["Zunda Berry"]     = { emoji="🫐", cat="forage",  color=Color3.fromRGB(130,100,200) },
    ["Zunda Mushroom"]  = { emoji="🍄", cat="forage",  color=Color3.fromRGB(200,120,80)  },
    ["Zunda Root"]      = { emoji="🌱", cat="forage",  color=Color3.fromRGB(150,120,80)  },
    ["Zunda Leaf"]      = { emoji="🌿", cat="forage",  color=Color3.fromRGB(80,180,90)   },
    ["SaltedPeaBouquet"]= { emoji="💐", cat="forage",  color=Color3.fromRGB(200,230,100) },
    ["MysteryLoot"]     = { emoji="✨", cat="forage",  color=Color3.fromRGB(200,180,255) },
    ["Apple"]           = { emoji="🍎", cat="forage",  color=Color3.fromRGB(220,60,60)   },
    ["Pine Cone"]       = { emoji="🌲", cat="forage",  color=Color3.fromRGB(100,150,80)  },
    ["Wheat"]           = { emoji="🌾", cat="forage",  color=Color3.fromRGB(230,200,100) },
    ["WheatSeed"]       = { emoji="🫘", cat="forage",  color=Color3.fromRGB(180,160,80)  },
    -- NEW Zunda-themed items
    ["Edamame Pod"]     = { emoji="🫛", cat="forage",  color=Color3.fromRGB(90,160,70)   },
    ["Sweet Pea"]       = { emoji="🍬", cat="forage",  color=Color3.fromRGB(200,230,150) },
    ["Pea Flower"]      = { emoji="🌸", cat="forage",  color=Color3.fromRGB(255,200,220) },
    -- Mining
    ["Rock"]            = { emoji="🪨", cat="mining",  color=Color3.fromRGB(180,170,160) },
    ["Iron Ore"]        = { emoji="🔩", cat="mining",  color=Color3.fromRGB(150,140,130) },
    ["Gold Ore"]        = { emoji="💛", cat="mining",  color=Color3.fromRGB(255,200,50)  },
    ["Marble Rock"]     = { emoji="🔷", cat="mining",  color=Color3.fromRGB(200,220,240) },
    ["Wood Log"]        = { emoji="🪵", cat="mining",  color=Color3.fromRGB(160,110,70)  },
    -- Food / crafted
    ["Bread"]           = { emoji="🍞", cat="food",    color=Color3.fromRGB(240,200,140) },
    ["Apple Pie"]       = { emoji="🥧", cat="food",    color=Color3.fromRGB(255,160,100) },
    ["Zunda Bread"]     = { emoji="🫓", cat="food",    color=Color3.fromRGB(180,220,130) },
    ["Zunda Mochi"]     = { emoji="🍡", cat="food",    color=Color3.fromRGB(200,240,200) },
    ["Stew"]            = { emoji="🍲", cat="food",    color=Color3.fromRGB(200,130,80)  },
    ["Cake"]            = { emoji="🎂", cat="food",    color=Color3.fromRGB(255,200,200) },
    ["Edamame Snack"]   = { emoji="🫛", cat="food",    color=Color3.fromRGB(120,180,90)  },
    ["Sweet Pea Cake"]  = { emoji="🍰", cat="food",    color=Color3.fromRGB(255,220,230) },
    ["Pea Flower Tea"]  = { emoji="🍵", cat="food",    color=Color3.fromRGB(255,230,240) },
    ["Zunda Paradise"]  = { emoji="✨", cat="food",    color=Color3.fromRGB(180,255,180) },
}
local function getMeta(name)
    if ITEM_META[name] then return ITEM_META[name] end
    -- Fuzzy match: check if name contains any key
    for k, v in pairs(ITEM_META) do
        if name:lower():find(k:lower(), 1, true) or k:lower():find(name:lower(), 1, true) then
            return v
        end
    end
    return { emoji="📦", cat="misc", color=Color3.fromRGB(200,200,200) }
end

-- ─── COLORS ──────────────────────────────────────────────
local C = {
    bg      = Color3.fromRGB(252, 248, 240),
    panel   = Color3.fromRGB(248, 243, 235),
    border  = Color3.fromRGB(232, 152, 168),
    text    = Color3.fromRGB(68,  52,  78),
    subtext = Color3.fromRGB(140, 120, 140),
    btnAct  = Color3.fromRGB(232, 152, 168),
    btnIdle = Color3.fromRGB(240, 228, 235),
    gold    = Color3.fromRGB(200, 150, 40),
}

-- ─── BUILD UI ────────────────────────────────────────────
local panel = Instance.new("Frame")
panel.Name            = "Panel"
panel.Size            = UDim2.new(0, 580, 0, 520)
panel.AnchorPoint     = Vector2.new(0.5, 0.5)
panel.Position        = UDim2.new(0.5, 0, 0.5, 0)
panel.BackgroundColor3 = C.bg
panel.BorderSizePixel = 0
panel.Visible         = false
panel.Parent          = gui
do
    local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0,22); cr.Parent = panel
    local st = Instance.new("UIStroke"); st.Thickness = 3; st.Color = C.border; st.Parent = panel
    local sh = Instance.new("UIStroke")  -- drop shadow illusion via second frame is complex, skip
end

-- Header
local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1,-32,0,56)
header.Position = UDim2.new(0,16,0,12)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(0,260,1,0)
titleLbl.Position = UDim2.new(0,0,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "🎒  Zunda Pouch"
titleLbl.Font = Enum.Font.FredokaOne
titleLbl.TextSize = 26
titleLbl.TextColor3 = C.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local goldLbl = Instance.new("TextLabel", header)
goldLbl.Name = "GoldDisplay"
goldLbl.Size = UDim2.new(0,160,0,36)
goldLbl.Position = UDim2.new(0,260,0,10)
goldLbl.BackgroundColor3 = Color3.fromRGB(255,242,180)
goldLbl.BorderSizePixel = 0
goldLbl.Text = "💰  ---"
goldLbl.Font = Enum.Font.GothamBold
goldLbl.TextSize = 16
goldLbl.TextColor3 = C.gold
do
    local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0,12); cr.Parent = goldLbl
    local st = Instance.new("UIStroke"); st.Thickness = 1.5
    st.Color = Color3.fromRGB(220,180,50); st.Parent = goldLbl
end

local closeBtn = Instance.new("TextButton", header)
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0,38,0,38)
closeBtn.Position = UDim2.new(1,-42,0,9)
closeBtn.BackgroundColor3 = C.border
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(252,248,240)
closeBtn.BorderSizePixel = 0
do
    local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0,10); cr.Parent = closeBtn
end

-- Tab bar
local tabBar = Instance.new("Frame", panel)
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1,-32,0,36)
tabBar.Position = UDim2.new(0,16,0,74)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0,6)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local TABS = {
    {id="all",    label="All",         emoji="📦"},
    {id="forage", label="Forage",      emoji="🌿"},
    {id="mining", label="Mining",      emoji="⛏"},
    {id="food",   label="Food",        emoji="🍱"},
}

local tabBtns = {}
local activeTab = "all"
for i, t in ipairs(TABS) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Name = "Tab_"..t.id
    btn.Size = UDim2.new(0,112,1,0)
    btn.LayoutOrder = i
    btn.BackgroundColor3 = i==1 and C.btnAct or C.btnIdle
    btn.BorderSizePixel = 0
    btn.Text = t.emoji.."  "..t.label
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = i==1 and Color3.fromRGB(255,255,255) or C.text
    local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0,10); cr.Parent = btn
    tabBtns[t.id] = btn
end

-- Item count label
local countLbl = Instance.new("TextLabel", panel)
countLbl.Name = "CountLabel"
countLbl.Size = UDim2.new(1,-32,0,20)
countLbl.Position = UDim2.new(0,16,0,116)
countLbl.BackgroundTransparency = 1
countLbl.Text = ""
countLbl.Font = Enum.Font.Gotham
countLbl.TextSize = 13
countLbl.TextColor3 = C.subtext
countLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Scroll grid for items
local scroll = Instance.new("ScrollingFrame", panel)
scroll.Name = "ItemGrid"
scroll.Size = UDim2.new(1,-32,0,335)
scroll.Position = UDim2.new(0,16,0,140)
scroll.BackgroundColor3 = Color3.fromRGB(245,240,232)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = C.border
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
do
    local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0,14); cr.Parent = scroll
    local gl = Instance.new("UIGridLayout", scroll)
    gl.CellSize = UDim2.new(0,118,0,108)
    gl.CellPadding = UDim2.new(0,8,0,8)
    gl.SortOrder = Enum.SortOrder.Name
    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop=UDim.new(0,10); pad.PaddingLeft=UDim.new(0,10)
    pad.PaddingRight=UDim.new(0,10); pad.PaddingBottom=UDim.new(0,10)
end

-- Empty state label
local emptyLbl = Instance.new("TextLabel", scroll)
emptyLbl.Name = "_Empty"
emptyLbl.Size = UDim2.new(1,-20,0,120)
emptyLbl.Position = UDim2.new(0,10,0,40)
emptyLbl.BackgroundTransparency = 1
emptyLbl.Text = "Your pouch is empty!\nGather some Zunda treasures 🌸"
emptyLbl.Font = Enum.Font.GothamMedium
emptyLbl.TextSize = 15
emptyLbl.TextColor3 = C.subtext
emptyLbl.TextWrapped = true
emptyLbl.Visible = false

-- ─── CARD BUILDER ─────────────────────────────────────────
local function buildCard(name, count, meta)
    local card = Instance.new("Frame")
    card.Name = name
    card.Size = UDim2.new(0,118,0,108)
    card.BackgroundColor3 = meta.color:Lerp(Color3.fromRGB(255,255,255), 0.72)
    card.BorderSizePixel = 0
    local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0,12); cr.Parent = card
    local st = Instance.new("UIStroke"); st.Thickness = 1.5
    st.Color = meta.color:Lerp(Color3.fromRGB(180,160,180),0.3)
    st.Parent = card

    local emojiLbl = Instance.new("TextLabel", card)
    emojiLbl.Size = UDim2.new(1,0,0,52)
    emojiLbl.Position = UDim2.new(0,0,0,8)
    emojiLbl.BackgroundTransparency = 1
    emojiLbl.Text = meta.emoji
    emojiLbl.Font = Enum.Font.GothamBold
    emojiLbl.TextSize = 32
    emojiLbl.TextXAlignment = Enum.TextXAlignment.Center

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Size = UDim2.new(1,-8,0,28)
    nameLbl.Position = UDim2.new(0,4,0,58)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 12
    nameLbl.TextColor3 = Color3.fromRGB(68,52,78)
    nameLbl.TextWrapped = true
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center

    local badge = Instance.new("Frame", card)
    badge.Size = UDim2.new(0,32,0,22)
    badge.Position = UDim2.new(1,-34,0,4)
    badge.BackgroundColor3 = meta.color
    badge.BorderSizePixel = 0
    local bCr = Instance.new("UICorner"); bCr.CornerRadius = UDim.new(0,8); bCr.Parent = badge
    local badgeLbl = Instance.new("TextLabel", badge)
    badgeLbl.Size = UDim2.new(1,0,1,0)
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Text = tostring(count)
    badgeLbl.Font = Enum.Font.GothamBold
    badgeLbl.TextSize = 13
    badgeLbl.TextColor3 = Color3.fromRGB(255,255,255)

    return card
end

-- ─── RENDER ───────────────────────────────────────────────
local currentData = {}

local function render(tab)
    -- Clear existing cards
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("Frame") and c.Name ~= "_Empty" then c:Destroy() end
    end

    local shown = 0
    -- Sort keys alphabetically
    local keys = {}
    for k, v in pairs(currentData) do
        if type(v) == "number" and v > 0
            and k ~= "Gold" and k ~= "current_gold" and k ~= "guests_served" then
            table.insert(keys, k)
        end
    end
    table.sort(keys)

    for _, name in ipairs(keys) do
        local count = currentData[name]
        local meta = getMeta(name)
        if tab == "all" or meta.cat == tab then
            local card = buildCard(name, count, meta)
            card.Parent = scroll
            shown = shown + 1
        end
    end

    emptyLbl.Visible = (shown == 0)
    if shown == 0 then emptyLbl.Parent = scroll end
    countLbl.Text = shown .. (shown == 1 and " item" or " items") ..
        (tab ~= "all" and (" in " .. tab) or " in pouch")
end

-- ─── TAB SWITCHING ────────────────────────────────────────
local function switchTab(id)
    activeTab = id
    for tid, btn in pairs(tabBtns) do
        if tid == id then
            btn.BackgroundColor3 = C.btnAct
            btn.TextColor3 = Color3.fromRGB(255,255,255)
        else
            btn.BackgroundColor3 = C.btnIdle
            btn.TextColor3 = C.text
        end
    end
    render(id)
end

for id, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() switchTab(id) end)
end

-- ─── DATA POLLING ─────────────────────────────────────────
local function refresh()
    local ok, data = pcall(function() return reqData:InvokeServer() end)
    if ok and data then
        currentData = data
        -- Show gold in header
        local g = data.Gold or data.current_gold or 0
        goldLbl.Text = "💰  " .. tostring(g)
        render(activeTab)
    end
end

-- ─── TOGGLE ───────────────────────────────────────────────
local open = false
local function toggle()
    open = not open
    panel.Visible = open
    if open then
        refresh()
        -- Entrance tween
        panel.Size = UDim2.new(0,580,0,10)
        Tween:Create(panel, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size=UDim2.new(0,580,0,520)}):Play()
    end
end

closeBtn.MouseButton1Click:Connect(function() open=true; toggle() end)

-- ─── WIRE HUD BUTTON ─────────────────────────────────────
task.spawn(function()
    local pg = player:WaitForChild("PlayerGui")
    local hudGui = pg:WaitForChild("ZundaHUD", 15)
    if hudGui then
        local hudButtons = hudGui:WaitForChild("HudButtons", 8)
        if hudButtons then
            local invBtn = hudButtons:FindFirstChild("HudBtn_inventory")
            if invBtn then
                invBtn.MouseButton1Click:Connect(toggle)
            end
        end
    end
end)

-- Keyboard shortcut: I key
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.I then toggle() end
end)

-- Auto-refresh while open
task.spawn(function()
    while true do
        task.wait(4)
        if open then refresh() end
    end
end)

print("[ZundaPouch] Ready — press I or click bag icon")

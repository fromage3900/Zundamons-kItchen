-- [[LocalScript] StoreScript (ref: RBX3C0E2A7A58224E6A994E3EE251CE9265)]]
local Players=game:GetService("Players"); local RS=game:GetService("ReplicatedStorage")
local Tween=game:GetService("TweenService"); local UIS=game:GetService("UserInputService")
local MPS=game:GetService("MarketplaceService")
local player=Players.LocalPlayer
local ClientGuiBootstrap = require(RS.ConfigurationFiles.ClientGuiBootstrap)
local MarketplaceConfig = require(RS.ConfigurationFiles.MarketplaceConfig)
local gui = ClientGuiBootstrap.createScreenGui(player, "ZundaShopGui", 26)

local RF=RS:WaitForChild("RemoteFunctions"); local RE=RS:WaitForChild("RemoteEvents")
local promptRF=RF:WaitForChild("PromptRobuxPurchase",10)
local purchaseEv=RE:WaitForChild("PurchaseResult",10)
local compEv=RE:WaitForChild("SetCompanion",10)

local PRODUCTS = MarketplaceConfig.storeDisplay

local C={bg=Color3.fromRGB(252,248,240),border=Color3.fromRGB(255,180,80),
         text=Color3.fromRGB(68,52,78),sub=Color3.fromRGB(140,120,140),
         tabAct=Color3.fromRGB(255,160,60),tabIdle=Color3.fromRGB(245,235,215),
         robux=Color3.fromRGB(0,162,255),card=Color3.fromRGB(255,250,240)}

-- ── PANEL ───────────────────────────────────────────────────────────────────
local panel=Instance.new("Frame",gui); panel.Name="Panel"
panel.Size=UDim2.new(0,580,0,560); panel.AnchorPoint=Vector2.new(0.5,0.5)
panel.Position=UDim2.new(0.5,0,0.5,0); panel.BackgroundColor3=C.bg
panel.BorderSizePixel=0; panel.Visible=false
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,22)
local bst=Instance.new("UIStroke",panel); bst.Thickness=3; bst.Color=C.border

-- Decorative header band
local hBand=Instance.new("Frame",panel); hBand.Size=UDim2.new(1,0,0,68)
hBand.Position=UDim2.new(0,0,0,0); hBand.BackgroundColor3=Color3.fromRGB(255,200,80)
hBand.BorderSizePixel=0
local hBandCr=Instance.new("UICorner",hBand); hBandCr.CornerRadius=UDim.new(0,22)
-- Fix bottom corners
local hFix=Instance.new("Frame",hBand); hFix.Size=UDim2.new(1,0,0.5,0)
hFix.Position=UDim2.new(0,0,0.5,0); hFix.BackgroundColor3=Color3.fromRGB(255,200,80)
hFix.BorderSizePixel=0

local title=Instance.new("TextLabel",hBand)
title.Size=UDim2.new(1,-80,1,0); title.Position=UDim2.new(0,18,0,0)
title.BackgroundTransparency=1; title.Text="✨  Zunda Shop"
title.Font=Enum.Font.FredokaOne; title.TextSize=30
title.TextColor3=Color3.fromRGB(80,52,20); title.TextXAlignment=Enum.TextXAlignment.Left

local subTitle=Instance.new("TextLabel",hBand)
subTitle.Size=UDim2.new(1,-80,0,18); subTitle.Position=UDim2.new(0,20,1,-20)
subTitle.BackgroundTransparency=1; subTitle.Text="Companions • Recipes • Accessories"
local ok=pcall(function() subTitle.FontFace=Font.new("rbxasset://fonts/families/Merriweather.json",Enum.FontWeight.Regular) end)
if not ok then subTitle.Font=Enum.Font.Gotham end
subTitle.TextSize=12; subTitle.TextColor3=Color3.fromRGB(120,82,30)
subTitle.TextXAlignment=Enum.TextXAlignment.Left

local closeBtn=Instance.new("TextButton",hBand)
closeBtn.Size=UDim2.new(0,38,0,38); closeBtn.Position=UDim2.new(1,-50,0,15)
closeBtn.BackgroundColor3=Color3.fromRGB(200,120,20); closeBtn.Text="✕"
closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=16
closeBtn.TextColor3=Color3.new(1,1,1); closeBtn.BorderSizePixel=0
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,10)

-- Tab bar
local tabBar=Instance.new("Frame",panel); tabBar.Size=UDim2.new(1,-32,0,38)
tabBar.Position=UDim2.new(0,16,0,74); tabBar.BackgroundTransparency=1; tabBar.BorderSizePixel=0
local tbl=Instance.new("UIListLayout",tabBar)
tbl.FillDirection=Enum.FillDirection.Horizontal; tbl.Padding=UDim.new(0,8)

local function mkTab(name,lbl,order)
    local b=Instance.new("TextButton",tabBar); b.Name="Tab_"..name
    b.Size=UDim2.new(0,152,1,0); b.LayoutOrder=order
    b.BackgroundColor3=order==1 and C.tabAct or C.tabIdle
    b.Text=lbl; b.Font=Enum.Font.GothamBold; b.TextSize=14
    b.TextColor3=order==1 and Color3.fromRGB(255,255,255) or C.text; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10); return b
end
local tabComp=mkTab("companions","🐱  Companions",1)
local tabRec =mkTab("recipes",   "🍳  Recipes",   2)
local tabAcc =mkTab("accessories","👑  Accessories",3)

-- Scroll
local scroll=Instance.new("ScrollingFrame",panel); scroll.Name="Cards"
scroll.Size=UDim2.new(1,-32,0,408); scroll.Position=UDim2.new(0,16,0,118)
scroll.BackgroundColor3=Color3.fromRGB(248,243,232); scroll.BorderSizePixel=0
scroll.ScrollBarThickness=5; scroll.ScrollBarImageColor3=C.border
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; scroll.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",scroll).CornerRadius=UDim.new(0,14)
local ll=Instance.new("UIListLayout",scroll); ll.Padding=UDim.new(0,10)
local sp=Instance.new("UIPadding",scroll)
sp.PaddingTop=UDim.new(0,10); sp.PaddingLeft=UDim.new(0,12)
sp.PaddingRight=UDim.new(0,12); sp.PaddingBottom=UDim.new(0,10)

-- ── CARD BUILDER ────────────────────────────────────────────────────────────
local function buildProductCard(prod, idx, cat)
    local card=Instance.new("Frame",scroll); card.Name="P_"..idx
    card.Size=UDim2.new(1,0,0,96); card.LayoutOrder=idx
    card.BackgroundColor3=C.card; card.BorderSizePixel=0
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local cs=Instance.new("UIStroke",card); cs.Thickness=1.5
    cs.Color=Color3.fromRGB(240,220,160)

    local em=Instance.new("TextLabel",card); em.Size=UDim2.new(0,62,0,62)
    em.Position=UDim2.new(0,10,0,17); em.BackgroundColor3=Color3.fromRGB(255,245,210)
    em.Text=prod.emoji; em.Font=Enum.Font.GothamBold; em.TextSize=36
    em.TextXAlignment=Enum.TextXAlignment.Center; em.BorderSizePixel=0
    Instance.new("UICorner",em).CornerRadius=UDim.new(0,12)

    local nm=Instance.new("TextLabel",card); nm.Size=UDim2.new(1,-220,0,26)
    nm.Position=UDim2.new(0,82,0,14); nm.BackgroundTransparency=1; nm.Text=prod.name
    nm.Font=Enum.Font.FredokaOne; nm.TextSize=18; nm.TextColor3=C.text
    nm.TextXAlignment=Enum.TextXAlignment.Left

    local desc=Instance.new("TextLabel",card); desc.Size=UDim2.new(1,-220,0,22)
    desc.Position=UDim2.new(0,82,0,40); desc.BackgroundTransparency=1; desc.Text=prod.desc
    desc.Font=Enum.Font.Gotham; desc.TextSize=12; desc.TextColor3=C.sub
    desc.TextXAlignment=Enum.TextXAlignment.Left

    -- Category badge
    local catColors={companions=Color3.fromRGB(200,240,200),recipes=Color3.fromRGB(255,230,180),accessories=Color3.fromRGB(220,200,255)}
    local catLbl=Instance.new("Frame",card); catLbl.Size=UDim2.new(0,90,0,20)
    catLbl.Position=UDim2.new(0,82,0,66); catLbl.BackgroundColor3=(catColors[cat] or C.card)
    catLbl.BorderSizePixel=0; Instance.new("UICorner",catLbl).CornerRadius=UDim.new(0,8)
    local cl=Instance.new("TextLabel",catLbl); cl.Size=UDim2.new(1,0,1,0)
    cl.BackgroundTransparency=1; cl.Text=cat:sub(1,1):upper()..cat:sub(2)
    cl.Font=Enum.Font.GothamBold; cl.TextSize=11; cl.TextColor3=C.text

    -- Buy button
    local buyBtn=Instance.new("TextButton",card); buyBtn.Size=UDim2.new(0,110,0,40)
    buyBtn.Position=UDim2.new(1,-122,0,28); buyBtn.BackgroundColor3=C.robux
    buyBtn.Text="🌀 "..prod.robux.." R$"; buyBtn.Font=Enum.Font.GothamBold
    buyBtn.TextSize=14; buyBtn.TextColor3=Color3.new(1,1,1); buyBtn.BorderSizePixel=0
    Instance.new("UICorner",buyBtn).CornerRadius=UDim.new(0,10)

    buyBtn.MouseButton1Click:Connect(function()
        if promptRF then
            -- In real game: pcall(function() promptRF:InvokeServer(prod.id) end)
            -- For Studio testing, show a purchase dialog simulation
            local toast=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
            toast.Name="PurchaseToast"; toast.DisplayOrder=1000
            local f=Instance.new("Frame",toast)
            f.Size=UDim2.new(0,360,0,80); f.AnchorPoint=Vector2.new(0.5,0)
            f.Position=UDim2.new(0.5,0,0,80); f.BackgroundColor3=Color3.fromRGB(0,162,255)
            f.BorderSizePixel=0
            Instance.new("UICorner",f).CornerRadius=UDim.new(0,14)
            local tl=Instance.new("TextLabel",f); tl.Size=UDim2.new(1,-20,1,0)
            tl.Position=UDim2.new(0,10,0,0); tl.BackgroundTransparency=1
            tl.Text="🌀 Purchasing "..prod.name.."…\n(Replace product ID "..prod.id.." in RobuxStoreServer)"
            tl.Font=Enum.Font.GothamBold; tl.TextSize=13; tl.TextColor3=Color3.new(1,1,1)
            tl.TextWrapped=true; tl.TextXAlignment=Enum.TextXAlignment.Center
            -- Animate in then out
            Tween:Create(f,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
                {Position=UDim2.new(0.5,0,0,100)}):Play()
            task.delay(2.8,function()
                Tween:Create(f,TweenInfo.new(0.2),{Position=UDim2.new(0.5,0,0,60)}):Play()
                task.delay(0.25,function() toast:Destroy() end)
            end)
            -- Actually invoke the prompt
            pcall(function() promptRF:InvokeServer(prod.id) end)
        end
    end)

    -- Hover effect
    buyBtn.MouseEnter:Connect(function()
        Tween:Create(buyBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(0,130,220)}):Play()
    end)
    buyBtn.MouseLeave:Connect(function()
        Tween:Create(buyBtn,TweenInfo.new(0.1),{BackgroundColor3=C.robux}):Play()
    end)
end

-- ── COMPANION TAB ALSO SHOWS FREE SELECTOR ───────────────────────────────────
local function buildCompanionSelector()
    local sFrame=Instance.new("Frame",scroll); sFrame.Name="CompSelector"
    sFrame.Size=UDim2.new(1,0,0,78); sFrame.LayoutOrder=0
    sFrame.BackgroundColor3=Color3.fromRGB(235,255,235); sFrame.BorderSizePixel=0
    Instance.new("UICorner",sFrame).CornerRadius=UDim.new(0,14)
    local sst=Instance.new("UIStroke",sFrame); sst.Thickness=1.5; sst.Color=Color3.fromRGB(130,215,130)

    local sl=Instance.new("TextLabel",sFrame); sl.Size=UDim2.new(1,-220,0,22)
    sl.Position=UDim2.new(0,14,0,10); sl.BackgroundTransparency=1
    sl.Text="🍡  Zundamon (Free — Active)"; sl.Font=Enum.Font.FredokaOne; sl.TextSize=16
    sl.TextColor3=C.text; sl.TextXAlignment=Enum.TextXAlignment.Left
    local sd=Instance.new("TextLabel",sFrame); sd.Size=UDim2.new(1,-220,0,18)
    sd.Position=UDim2.new(0,14,0,34); sd.BackgroundTransparency=1
    sd.Text="Your loyal Zundamon companion!"; sd.Font=Enum.Font.Gotham; sd.TextSize=12
    sd.TextColor3=C.sub; sd.TextXAlignment=Enum.TextXAlignment.Left

    local equipBtn=Instance.new("TextButton",sFrame); equipBtn.Size=UDim2.new(0,100,0,36)
    equipBtn.Position=UDim2.new(1,-112,0,21); equipBtn.BackgroundColor3=Color3.fromRGB(130,200,100)
    equipBtn.Text="✓ Equip"; equipBtn.Font=Enum.Font.GothamBold; equipBtn.TextSize=14
    equipBtn.TextColor3=Color3.new(1,1,1); equipBtn.BorderSizePixel=0
    Instance.new("UICorner",equipBtn).CornerRadius=UDim.new(0,10)
    equipBtn.MouseButton1Click:Connect(function()
        if compEv then compEv:FireServer("zundamon") end
    end)
end

-- ── TAB SWITCHING ─────────────────────────────────────────────────────────────
local activeTab="companions"
local function switchTab(id)
    activeTab=id
    for _,btn in ipairs({tabComp,tabRec,tabAcc}) do
        local active=btn.Name=="Tab_"..id
        btn.BackgroundColor3=active and C.tabAct or C.tabIdle
        btn.TextColor3=active and Color3.new(1,1,1) or C.text
    end
    for _,c in ipairs(scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    scroll.CanvasPosition=Vector2.new(0,0)
    if id=="companions" then
        buildCompanionSelector()
        for i,p in ipairs(PRODUCTS.companions) do buildProductCard(p,i+1,"companions") end
    elseif id=="recipes" then
        for i,p in ipairs(PRODUCTS.recipes) do buildProductCard(p,i,"recipes") end
    elseif id=="accessories" then
        for i,p in ipairs(PRODUCTS.accessories) do buildProductCard(p,i,"accessories") end
    end
end
tabComp.MouseButton1Click:Connect(function() switchTab("companions") end)
tabRec.MouseButton1Click:Connect(function()  switchTab("recipes")    end)
tabAcc.MouseButton1Click:Connect(function()  switchTab("accessories") end)

-- Purchase success notification
if purchaseEv then
    purchaseEv.OnClientEvent:Connect(function(itemName, itemType)
        local toast=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
        toast.Name="SuccessToast"; toast.DisplayOrder=1001
        local f=Instance.new("Frame",toast)
        f.Size=UDim2.new(0,320,0,70); f.AnchorPoint=Vector2.new(0.5,0)
        f.Position=UDim2.new(0.5,0,0,80); f.BackgroundColor3=Color3.fromRGB(100,200,100)
        f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,14)
        local tl=Instance.new("TextLabel",f); tl.Size=UDim2.new(1,0,1,0)
        tl.BackgroundTransparency=1; tl.Text="✅  "..itemName.." unlocked!"
        tl.Font=Enum.Font.FredokaOne; tl.TextSize=18; tl.TextColor3=Color3.new(1,1,1)
        task.delay(2.5,function() toast:Destroy() end)
    end)
end

-- ── TOGGLE ─────────────────────────────────────────────────────────────────
local open=false
local function toggle()
    open=not open; panel.Visible=open
    if open then
        if scroll:FindFirstChildOfClass("Frame")==nil then switchTab("companions") end
        panel.Size=UDim2.new(0,580,0,10)
        Tween:Create(panel,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.new(0,580,0,560)}):Play()
    end
end
closeBtn.MouseButton1Click:Connect(function() open=true; toggle() end)

-- Wire to HudBtn_settings and HudBtn_shop
task.spawn(function()
    local pg=player:WaitForChild("PlayerGui")
    local hud=pg:WaitForChild("ZundaHUD",15)
    if hud then
        local bar=hud:WaitForChild("HudButtons",8)
        if bar then
            local s=bar:FindFirstChild("HudBtn_settings")
            if s then s.MouseButton1Click:Connect(toggle) end
            local sh=bar:FindFirstChild("HudBtn_shop")
            if sh then sh.MouseButton1Click:Connect(toggle) end
        end
    end
end)
UIS.InputBegan:Connect(function(i,g) if g then return end if i.KeyCode==Enum.KeyCode.P then toggle() end end)
print("[RobuxStore] Ready — P key or settings/shop button")

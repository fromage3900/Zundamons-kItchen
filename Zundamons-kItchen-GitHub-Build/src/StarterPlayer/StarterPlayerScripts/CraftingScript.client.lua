-- [[LocalScript] CraftingScript (ref: RBX0DC7A0732A82493992F3FC69FDF2E0AA)]]
-- CraftingScript: Client-side crafting UI controller
-- Press K to toggle the crafting panel, click a recipe to craft it.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local panel = script.Parent:WaitForChild("Panel")
local closeBtn = panel:WaitForChild("TitleBar"):WaitForChild("CloseBtn")
local scroll = panel:WaitForChild("RecipeList")

local craftFunc = RS:WaitForChild("RemoteFunctions"):WaitForChild("CraftFunction")
local requestData = RS:WaitForChild("RemoteFunctions"):WaitForChild("RequestData")

-- Recipe definitions mirror CraftConfig (kept in sync manually)
-- NEW: Added Zunda-themed recipes!
local RECIPES = {
    {name = "Bread",                ings = {Wheat = 10}},
    {name = "Apple Pie",            ings = {Apple = 3, Wheat = 5}},
    {name = "Zunda Bread",          ings = {Wheat = 15, Apple = 2}},
    {name = "Royal Stew",           ings = {Wheat = 8, Apple = 5, Gold = 1}},
    {name = "Zunda Mochi",          ings = {["Zunda Pea"] = 5, Wheat = 8}},
    {name = "Edamame Snack",        ings = {["Edamame Pod"] = 3, ["Zunda Leaf"] = 2}},
    {name = "Fancy Pie",            ings = {Apple = 7, Wheat = 12, Gold = 2}},
    {name = "Zundamon's Banquet",   ings = {Wheat = 20, Apple = 10, Gold = 3}},
    {name = "Sweet Pea Cake",       ings = {["Sweet Pea"] = 4, Wheat = 10, ["Zunda Pea"] = 3}},
    {name = "Pea Flower Tea",      ings = {["Pea Flower"] = 5, ["Zunda Leaf"] = 3}},
    {name = "Ultimate Feast",       ings = {Wheat = 30, Apple = 20, Gold = 5}},
    {name = "Zunda Paradise",       ings = {["Zunda Pea"] = 15, ["Edamame Pod"] = 10, ["Sweet Pea"] = 5, ["Pea Flower"] = 3}},
}

-- Helper: format an ingredient list as a readable string
local function formatIngs(ings)
    local parts = {}
    for item, count in pairs(ings) do
        table.insert(parts, count .. "x " .. item)
    end
    return table.concat(parts, ", ")
 end

-- Build a card for each recipe
local function buildRecipeCard(recipe)
    local card = Instance.new("Frame")
    card.Name = "Recipe_" .. recipe.name
    card.Size = UDim2.new(1, -10, 0, 70)
    card.BackgroundColor3 = Color3.fromRGB(255, 245, 230)
    card.BorderSizePixel = 0
    card.Parent = scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = recipe.name
    nameLabel.TextColor3 = Color3.fromRGB(80, 40, 30)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = card

    local ingLabel = Instance.new("TextLabel")
    ingLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
    ingLabel.Position = UDim2.new(0, 10, 0.55, 0)
    ingLabel.BackgroundTransparency = 1
    ingLabel.Text = formatIngs(recipe.ings)
    ingLabel.TextColor3 = Color3.fromRGB(140, 100, 80)
    ingLabel.TextXAlignment = Enum.TextXAlignment.Left
    ingLabel.TextScaled = true
    ingLabel.Font = Enum.Font.Gotham
    ingLabel.Parent = card

    local craftBtn = Instance.new("TextButton")
    craftBtn.Size = UDim2.new(0, 90, 0, 50)
    craftBtn.Position = UDim2.new(1, -100, 0, 10)
    craftBtn.BackgroundColor3 = Color3.fromRGB(120, 200, 120)
    craftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    craftBtn.Text = "Craft"
    craftBtn.TextScaled = true
    craftBtn.Font = Enum.Font.GothamBold
    craftBtn.Parent = card
    Instance.new("UICorner", craftBtn).CornerRadius = UDim.new(0, 6)

    craftBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Prevent double-tap while a cook is running
        if _G.TimedCooking and _G.TimedCooking.isCooking() then return end

        -- Helper: send craft to server with a quality tag (perfect/great/ok)
        local function submitCraft(quality)
            craftBtn.Text = "\u{2728}"  -- ✨ while server processes
            local ok, result = pcall(function()
                return craftFunc:InvokeServer(recipe.name, hrp.Position, quality)
            end)
            if ok and result == "Success" then
                if quality == "perfect" then
                    craftBtn.Text = "PERFECT \u{2728}"
                    craftBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
                elseif quality == "great" then
                    craftBtn.Text = "Great \u{2713}"
                    craftBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
                else
                    craftBtn.Text = "OK \u{2713}"
                    craftBtn.BackgroundColor3 = Color3.fromRGB(160, 200, 120)
                end
            else
                craftBtn.Text = "Need more!"
                craftBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
            end
            task.delay(1.8, function()
                craftBtn.Text = "Craft"
                craftBtn.BackgroundColor3 = Color3.fromRGB(120, 200, 120)
            end)
        end

        -- Run the timed cooking mini-game if available, otherwise fall through
        if _G.TimedCooking and _G.TimedCooking.start then
            craftBtn.Text = "Cooking\u{2026}"
            local started = _G.TimedCooking.start(recipe.name, function(inGreen, perfect)
                local quality = perfect and "perfect" or inGreen and "great" or "ok"
                submitCraft(quality)
            end)
            if not started then
                craftBtn.Text = "Craft"
            end
        else
            submitCraft("ok")
        end
    end)
end

-- Build all recipe cards once on load
for _, r in ipairs(RECIPES) do
    buildRecipeCard(r)
end

-- Toggle panel
local function setOpen(state)
    panel.Visible = state
end

closeBtn.MouseButton1Click:Connect(function()
    setOpen(false)
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then
        setOpen(not panel.Visible)
    end
end)

-- Wire the ZundaHUD button if present (added in HudButtons row)
task.spawn(function()
    local pg = player:WaitForChild("PlayerGui")
    local hud = pg:WaitForChild("ZundaHUD", 5)
    if not hud then return end
    local hb = hud:WaitForChild("HudButtons", 5)
    if not hb then return end
    local hbtn = hb:WaitForChild("HudBtn_crafting", 5)
    if hbtn then
        hbtn.MouseButton1Click:Connect(function() setOpen(not panel.Visible) end)
    end
end)

print("[CraftingScript] Loaded - Press K to open crafting panel")

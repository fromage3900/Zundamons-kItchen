-- [[LocalScript] CraftingScript (ref: RBX0DC7A0732A82493992F3FC69FDF2E0AA)]]
-- CraftingScript: Client-side crafting UI controller (Rojo bootstrap)
-- Press K to toggle the crafting panel, click a recipe to craft it.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ClientGuiBootstrap = require(RS.ConfigurationFiles.ClientGuiBootstrap)
local gui = ClientGuiBootstrap.createScreenGui(player, "ZundaCraftGui", 24)

local craftFunc = RS:WaitForChild("RemoteFunctions"):WaitForChild("CraftFunction")
local craftConfig = require(RS.Shared.Modules.CraftConfig)
local UIHelper = require(RS.Shared.Modules.UIHelper)
local UIConfig = require(RS.ConfigurationFiles.UIConfig)

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 420, 0, 520)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.BackgroundColor3 = Color3.fromRGB(255, 248, 235)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(120, 200, 130)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🍳 Crafting"
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -40, 0, 4)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "RecipeList"
scroll.Size = UDim2.new(1, -20, 1, -54)
scroll.Position = UDim2.new(0, 10, 0, 48)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = panel
local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0, 8)

local RECIPES = {}
for recipeName, ings in pairs(craftConfig.recipes) do
	local locked = ings.locked == true
	local recipeEntry = {
		name = recipeName,
		ings = ings,
		locked = locked,
	}
	if locked then
		ings.locked = nil
	end
	table.insert(RECIPES, recipeEntry)
end

local function buildIngredientLine(parent, xPos, yPos, width, item, count)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(0, width, 0, 24)
	row.Position = UDim2.new(0, xPos, 0, yPos)
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0
	row.Parent = parent

	local icon = UIHelper.createItemIcon(item, UDim2.fromOffset(20, 20), row)
	icon.Position = UDim2.new(0, 0, 0.5, -10)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -24, 1, 0)
	lbl.Position = UDim2.new(0, 24, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = count .. "x " .. item
	lbl.TextColor3 = Color3.fromRGB(140, 100, 80)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextScaled = true
	lbl.Font = Enum.Font.Gotham
	lbl.Parent = row
end

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

	local yPos = 32
	local xPos = 10
	for item, count in pairs(recipe.ings) do
		if item ~= "locked" then
			buildIngredientLine(card, xPos, yPos, 160, item, count)
			xPos += 170
			if xPos > 280 then
				xPos = 10
				yPos += 26
			end
		end
	end

	local craftBtn = Instance.new("TextButton")
	craftBtn.Name = "CraftBtn"
	craftBtn.Size = UDim2.new(0, 80, 0, 32)
	craftBtn.Position = UDim2.new(1, -90, 0.5, -16)
	craftBtn.BackgroundColor3 = recipe.locked and Color3.fromRGB(180, 180, 180) or Color3.fromRGB(120, 200, 120)
	craftBtn.Text = recipe.locked and "Locked" or "Craft"
	craftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	craftBtn.Font = Enum.Font.GothamBold
	craftBtn.TextScaled = true
	craftBtn.BorderSizePixel = 0
	craftBtn.AutoButtonColor = not recipe.locked
	craftBtn.Parent = card
	Instance.new("UICorner", craftBtn).CornerRadius = UDim.new(0, 8)

	if recipe.locked then
		return
	end

	craftBtn.MouseButton1Click:Connect(function()
		local pos = craftBtn.AbsolutePosition
		local sz = craftBtn.AbsoluteSize
		UIHelper.spawnSparkles(craftBtn.Parent, pos.X + sz.X / 2, pos.Y + sz.Y / 2, Color3.fromRGB(120, 200, 120), 5)
		local char = player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end

		if _G.TimedCooking and _G.TimedCooking.isCooking() then
			return
		end

		local function submitCraft(payload)
			craftBtn.Text = "✨"
			local ok, result = pcall(function()
				return craftFunc:InvokeServer(recipe.name, hrp.Position, payload)
			end)
			if ok and result == "Success" then
				local quality = type(payload) == "table" and payload.quality or payload
				if quality == "perfect" then
					craftBtn.Text = "PERFECT ✨"
					craftBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
				elseif quality == "great" then
					craftBtn.Text = "Great ✓"
					craftBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
				else
					craftBtn.Text = "OK ✓"
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

		if _G.TimedCooking and _G.TimedCooking.start then
			craftBtn.Text = "Cooking…"
			local started = _G.TimedCooking.start(recipe.name, function(inGreen, perfect, timings, noteCount)
				submitCraft({
					timings = timings or {},
					noteCount = noteCount or #(timings or {}),
				})
			end)
			if not started then
				craftBtn.Text = "Craft"
			end
		else
			submitCraft("ok")
		end
	end)
end

for _, r in ipairs(RECIPES) do
	buildRecipeCard(r)
end

local function setOpen(state)
	panel.Visible = state
end

closeBtn.MouseButton1Click:Connect(function()
	setOpen(false)
end)

UIS.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == Enum.KeyCode.K then
		setOpen(not panel.Visible)
	end
end)

task.spawn(function()
	local pg = player:WaitForChild("PlayerGui")
	local hud = pg:WaitForChild("ZundaHUD", 5)
	if not hud then
		return
	end
	local hb = hud:WaitForChild("HudButtons", 5)
	if not hb then
		return
	end
	local hbtn = hb:WaitForChild("HudBtn_crafting", 5)
	if hbtn then
		hbtn.MouseButton1Click:Connect(function()
			setOpen(not panel.Visible)
		end)
	end
end)

print("[CraftingScript] Loaded - Press K to open crafting panel")

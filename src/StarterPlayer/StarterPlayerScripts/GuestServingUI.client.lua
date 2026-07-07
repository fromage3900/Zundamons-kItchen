-- Serve confirmation panel. Triggered by GuestDetector when player clicks a guest.
-- Shows a dish picker from player's inventory + confirm button.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local serveGuestRF = RS.RemoteFunctions:WaitForChild("ServeGuest")
local requestData = RS.RemoteFunctions:WaitForChild("RequestData")

local gui = Instance.new("ScreenGui")
gui.Name = "GuestServingUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 85
gui.Enabled = false
gui.Parent = playerGui

local backdrop = Instance.new("TextButton", gui)
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.BackgroundTransparency = 0.6
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.Text = ""
backdrop.BorderSizePixel = 0
backdrop.AutoButtonColor = false
backdrop.Visible = false

local panel = Instance.new("Frame", gui)
panel.Name = "Panel"
panel.Size = UDim2.new(0, 380, 0, 320)
panel.Position = UDim2.new(0.5, -190, 0.5, -160)
panel.BackgroundColor3 = Color3.fromRGB(255, 248, 235)
panel.BorderSizePixel = 0
panel.Visible = false
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)
local pStroke = Instance.new("UIStroke", panel)
pStroke.Color = Color3.fromRGB(180, 150, 110)
pStroke.Thickness = 3

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = ""
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(80, 40, 30)

local guestLabel = Instance.new("TextLabel", panel)
guestLabel.Name = "GuestLabel"
guestLabel.Size = UDim2.new(1, -20, 0, 20)
guestLabel.Position = UDim2.new(0, 10, 0, 40)
guestLabel.BackgroundTransparency = 1
guestLabel.Text = ""
guestLabel.Font = Enum.Font.Gotham
guestLabel.TextSize = 14
guestLabel.TextColor3 = Color3.fromRGB(140, 100, 80)

local dishList = Instance.new("ScrollingFrame", panel)
dishList.Name = "DishList"
dishList.Size = UDim2.new(1, -20, 1, -105)
dishList.Position = UDim2.new(0, 10, 0, 65)
dishList.BackgroundTransparency = 1
dishList.BorderSizePixel = 0
dishList.ScrollBarThickness = 6
dishList.CanvasSize = UDim2.new(0, 0, 0, 0)

local closeBtn = Instance.new("TextButton", panel)
closeBtn.Size = UDim2.new(0, 80, 0, 30)
closeBtn.Position = UDim2.new(1, -90, 1, -38)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 100)
closeBtn.Text = "Cancel"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local currentGuest = nil

local function buildDishPanel(guest, availableDishes)
	currentGuest = guest
	local recipe = guest:GetAttribute("PreferredRecipe") or "???"
	local pay = guest:GetAttribute("PayAmount") or 10
	guestLabel.Text = "Wants: " .. recipe .. "  (+" .. pay .. " gold)"
	-- Clear old entries
	for _, c in ipairs(dishList:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	local y = 0
	for _, dishName in ipairs(availableDishes or {}) do
		local row = Instance.new("Frame", dishList)
		row.Size = UDim2.new(1, -6, 0, 36)
		row.Position = UDim2.new(0, 0, 0, y)
		row.BackgroundColor3 = dishName == recipe and Color3.fromRGB(200, 240, 200) or Color3.fromRGB(245, 235, 220)
		row.BorderSizePixel = 0
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(1, -80, 1, 0)
		lbl.Position = UDim2.new(0, 8, 0, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = (dishName == recipe and "★ " or "") .. dishName
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 14
		lbl.TextColor3 = Color3.fromRGB(80, 40, 30)
		local serveBtn = Instance.new("TextButton", row)
		serveBtn.Size = UDim2.new(0, 70, 0, 26)
		serveBtn.Position = UDim2.new(1, -76, 0.5, -13)
		serveBtn.BackgroundColor3 = dishName == recipe and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(180, 180, 180)
		serveBtn.Text = "Serve"
		serveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		serveBtn.Font = Enum.Font.GothamBold
		serveBtn.TextSize = 12
		serveBtn.BorderSizePixel = 0
		Instance.new("UICorner", serveBtn).CornerRadius = UDim.new(0, 6)
		serveBtn.MouseButton1Click:Connect(function()
			local ok, msg = serveGuestRF:InvokeServer(guest, dishName)
			if ok then
				gui.Enabled = false
			end
		end)
		y = y + 40
	end
	dishList.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Called from GuestDetector
_G.ZundaShowServeUI = function(guest, data)
	if not guest or not guest.Parent then return end
	local recipe = guest:GetAttribute("PreferredRecipe") or ""
	local pay = guest:GetAttribute("PayAmount") or 10
	title.Text = "✧ Serve Guest ✧"
	-- Find what dishes the player has
	local available = {}
	for k, v in pairs(data or {}) do
		if type(v) == "number" and v > 0 and not k:match("_") and k ~= "gold" and k ~= "total_gold_earned" and k ~= "guests_served" and k ~= "perfect_cooks" and k ~= "great_cooks" and k ~= "cooking_streak" and k ~= "max_cooking_streak" and k ~= "tier" and k ~= "recipes_unlocked_count" and k ~= "companion_affection" and k ~= "companion_chats" and k ~= "speed_cooks" and k ~= "Apple" and k ~= "Wheat" and k ~= "Wood" and k ~= "Rock" and k ~= "Iron Ore" then
			table.insert(available, k)
		end
	end
	table.sort(available)
	if #available == 0 then
		guestLabel.Text = "No dishes in inventory! Craft something first."
		return
	end
	buildDishPanel(guest, available)
	gui.Enabled = true
end

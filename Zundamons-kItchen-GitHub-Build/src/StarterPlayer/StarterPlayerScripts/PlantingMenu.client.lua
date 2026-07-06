-- [[LocalScript] PlantingMenu]]
-- Shows seed picker when player clicks an empty planter; fires plantEvent on selection.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local UIComponents = require(RS.ConfigurationFiles:WaitForChild("UIComponents"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RE = RS:WaitForChild("RemoteEvents")
local showMenuEv = RE:WaitForChild("ShowPlantingMenu")
local plantEvent = RE:WaitForChild("plantEvent")

local SEED_META: { [string]: { emoji: string, label: string } } = {
	WheatSeed = { emoji = "🫘", label = "Wheat Seed" },
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlantingMenuGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
backdrop.BackgroundTransparency = 0.45
backdrop.BorderSizePixel = 0
backdrop.Visible = false
backdrop.ZIndex = 20
backdrop.Parent = screenGui

local panel = UIComponents.createPanel({
	Size = UDim2.fromOffset(420, 320),
	Parent = screenGui,
})
panel.Name = "Panel"
panel.Visible = false
panel.ZIndex = 21

local title = UIComponents.createLabel({
	Text = "🌱 Plant a Seed",
	Size = UDim2.new(1, -80, 0, 40),
	Position = UDim2.fromOffset(16, 12),
	Parent = panel,
})

local closeBtn = UIComponents.createButton({
	Text = "×",
	Size = UDim2.fromOffset(36, 36),
	Position = UDim2.new(1, -48, 0, 12),
	Parent = panel,
})

local listFrame = Instance.new("ScrollingFrame")
listFrame.Name = "SeedList"
listFrame.Size = UDim2.new(1, -32, 1, -72)
listFrame.Position = UDim2.fromOffset(16, 56)
listFrame.BackgroundTransparency = 1
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 6
listFrame.CanvasSize = UDim2.fromOffset(0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.Parent = panel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listFrame

local currentPlanter: Instance? = nil

local function clearList()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("GuiButton") then
			child:Destroy()
		end
	end
end

local function close()
	panel.Visible = false
	backdrop.Visible = false
	currentPlanter = nil
	clearList()
end

local function open(plantables: { [string]: number }, planter: Instance)
	currentPlanter = planter
	clearList()

	local order = 0
	for seedName, count in pairs(plantables) do
		if type(count) == "number" and count > 0 then
			order += 1
			local meta = SEED_META[seedName] or { emoji = "🌱", label = seedName }
			local btn = UIComponents.createButton({
				Text = string.format("%s  %s  ×%d", meta.emoji, meta.label, count),
				Size = UDim2.new(1, -8, 0, 44),
				Parent = listFrame,
			})
			btn.LayoutOrder = order
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.MouseButton1Click:Connect(function()
				if currentPlanter then
					plantEvent:FireServer(seedName, currentPlanter)
				end
				close()
			end)
		end
	end

	if order == 0 then
		close()
		return
	end

	backdrop.Visible = true
	panel.Visible = true
	UIComponents.animateIn(panel)
end

showMenuEv.OnClientEvent:Connect(function(plantables, planter)
	if typeof(plantables) ~= "table" then
		return
	end
	if typeof(planter) ~= "Instance" or not (planter:IsA("BasePart") or planter:IsA("Model")) then
		return
	end
	open(plantables, planter)
end)

closeBtn.MouseButton1Click:Connect(close)
backdrop.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		close()
	end
end)

print("[PlantingMenu] Ready — click empty planters with seeds in inventory")

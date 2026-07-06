-- [[LocalScript] DecorationShop]]
-- Buy and place plot decorations via DecorationPlacer remotes.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local UIComponents = require(RS.ConfigurationFiles:WaitForChild("UIComponents"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RE = RS:WaitForChild("RemoteEvents")
local RF = RS:WaitForChild("RemoteFunctions")
local GetDecorationState = RF:WaitForChild("GetDecorationState")
local BuyDecoration = RF:WaitForChild("BuyDecoration")
local PlaceDecoration = RF:WaitForChild("PlaceDecoration")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DecorationShopGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
backdrop.BackgroundTransparency = 0.4
backdrop.BorderSizePixel = 0
backdrop.Visible = false
backdrop.ZIndex = 30
backdrop.Parent = screenGui

local panel = UIComponents.createPanel({
	Size = UDim2.fromOffset(760, 520),
	Parent = screenGui,
})
panel.Name = "Panel"
panel.Visible = false
panel.ZIndex = 31

local title = UIComponents.createLabel({
	Text = "🏡 Decoration Shop",
	Size = UDim2.new(1, -100, 0, 36),
	Position = UDim2.fromOffset(16, 12),
	Parent = panel,
})

local goldLbl = UIComponents.createLabel({
	Text = "Gold: —",
	Size = UDim2.new(0, 160, 0, 28),
	Position = UDim2.new(1, -200, 0, 14),
	Parent = panel,
})

local closeBtn = UIComponents.createButton({
	Text = "×",
	Size = UDim2.fromOffset(36, 36),
	Position = UDim2.new(1, -48, 0, 12),
	Parent = panel,
})

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -32, 0, 36)
tabBar.Position = UDim2.fromOffset(16, 52)
tabBar.BackgroundTransparency = 1
tabBar.Parent = panel

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = tabBar

local gardenTab = UIComponents.createButton({
	Text = "Garden",
	Size = UDim2.fromOffset(100, 32),
	Parent = tabBar,
})
local cottageTab = UIComponents.createButton({
	Text = "Cottage",
	Size = UDim2.fromOffset(100, 32),
	Parent = tabBar,
})

local grid = Instance.new("ScrollingFrame")
grid.Name = "CatalogGrid"
grid.Size = UDim2.new(0.55, -24, 1, -110)
grid.Position = UDim2.fromOffset(16, 96)
grid.BackgroundTransparency = 1
grid.BorderSizePixel = 0
grid.ScrollBarThickness = 6
grid.CanvasSize = UDim2.fromOffset(0, 0)
grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
grid.Parent = panel

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.fromOffset(96, 96)
gridLayout.CellPadding = UDim2.fromOffset(8, 8)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = grid

local detail = UIComponents.createPanel({
	Size = UDim2.new(0.42, -24, 1, -110),
	Position = UDim2.new(0.58, 0, 0, 96),
	Parent = panel,
})
detail.AnchorPoint = Vector2.new(0, 0)

local detailIcon = UIComponents.createLabel({
	Text = "🌷",
	Size = UDim2.fromOffset(80, 80),
	Position = UDim2.fromOffset(16, 16),
	TextXAlignment = Enum.TextXAlignment.Center,
	Parent = detail,
})
detailIcon.TextSize = 48

local detailName = UIComponents.createLabel({
	Text = "Select a decoration",
	Size = UDim2.new(1, -32, 0, 32),
	Position = UDim2.fromOffset(16, 100),
	Parent = detail,
})

local detailDesc = UIComponents.createLabel({
	Text = "",
	Size = UDim2.new(1, -32, 0, 60),
	Position = UDim2.fromOffset(16, 136),
	Parent = detail,
})

local statusLbl = UIComponents.createLabel({
	Text = "",
	Size = UDim2.new(1, -32, 0, 40),
	Position = UDim2.fromOffset(16, 200),
	Parent = detail,
})

local buyBtn = UIComponents.createButton({
	Text = "Buy",
	Size = UDim2.new(1, -32, 0, 40),
	Position = UDim2.new(0, 16, 1, -96),
	Parent = detail,
})

local placeBtn = UIComponents.createButton({
	Text = "Place on plot",
	Size = UDim2.new(1, -32, 0, 40),
	Position = UDim2.new(0, 16, 1, -48),
	Parent = detail,
})

type CatalogItem = {
	id: string,
	name: string,
	description: string,
	price: number,
	zone: string,
	icon: string,
}

local state: { [string]: any } = {}
local catalog: { CatalogItem } = {}
local currentZone = "garden"
local selectedId: string? = nil

local function setStatus(msg: string)
	statusLbl.Text = msg
end

local function refreshDetail()
	local id = selectedId
	if not id then
		return
	end
	local item: CatalogItem? = nil
	for _, entry in ipairs(catalog) do
		if entry.id == id then
			item = entry
			break
		end
	end
	if not item then
		return
	end

	detailIcon.Text = item.icon or "✨"
	detailName.Text = item.name
	detailDesc.Text = item.description .. "\n💰 " .. tostring(item.price) .. " gold"

	local owned = state.owned and state.owned[id]
	local hasPlot = state.owned_plot ~= nil

	if owned then
		buyBtn.Text = "Owned ✓"
		buyBtn.AutoButtonColor = false
		placeBtn.Visible = hasPlot
		if hasPlot then
			placeBtn.Text = "Place on plot"
		else
			setStatus("Claim a plot first to place decorations.")
		end
	else
		buyBtn.Text = "Buy for " .. tostring(item.price) .. " gold"
		buyBtn.AutoButtonColor = true
		placeBtn.Visible = false
		local gold = state.gold or 0
		if gold < item.price then
			setStatus("Need " .. tostring(item.price - gold) .. " more gold.")
		else
			setStatus("")
		end
	end
end

local function clearGrid()
	for _, child in ipairs(grid:GetChildren()) do
		if child:IsA("GuiButton") then
			child:Destroy()
		end
	end
end

local function rebuildGrid()
	clearGrid()
	local order = 0
	for _, item in ipairs(catalog) do
		if item.zone == currentZone or item.zone == "both" then
			order += 1
			local btn = UIComponents.createButton({
				Text = item.icon or "✨",
				Size = UDim2.fromOffset(96, 96),
				Parent = grid,
			})
			btn.LayoutOrder = order
			btn.TextSize = 36
			btn:SetAttribute("DecorationId", item.id)
			if state.owned and state.owned[item.id] then
				btn.Text = (item.icon or "✨") .. "\n✓"
				btn.TextSize = 28
			end
			btn.MouseButton1Click:Connect(function()
				selectedId = item.id
				refreshDetail()
			end)
		end
	end
end

local function loadState()
	local result = GetDecorationState:InvokeServer()
	if typeof(result) ~= "table" then
		return
	end
	state = result
	catalog = result.catalog or {}
	goldLbl.Text = "Gold: " .. tostring(result.gold or 0)
	rebuildGrid()
	if selectedId then
		refreshDetail()
	end
end

local function open()
	backdrop.Visible = true
	panel.Visible = true
	loadState()
	UIComponents.animateIn(panel)
end

local function close()
	panel.Visible = false
	backdrop.Visible = false
end

gardenTab.MouseButton1Click:Connect(function()
	currentZone = "garden"
	rebuildGrid()
end)

cottageTab.MouseButton1Click:Connect(function()
	currentZone = "cottage"
	rebuildGrid()
end)

buyBtn.MouseButton1Click:Connect(function()
	if not selectedId then
		return
	end
	if state.owned and state.owned[selectedId] then
		return
	end
	local result = BuyDecoration:InvokeServer(selectedId)
	if typeof(result) == "table" then
		setStatus(result.message or "")
		if result.success then
			loadState()
		end
	end
end)

placeBtn.MouseButton1Click:Connect(function()
	if not selectedId then
		return
	end
	local result = PlaceDecoration:InvokeServer(selectedId)
	if typeof(result) == "table" then
		setStatus(result.message or "")
		if result.success then
			loadState()
		end
	end
end)

closeBtn.MouseButton1Click:Connect(close)

_G.ZundaDecorationShop = {
	open = open,
	close = close,
	toggle = function()
		if panel.Visible then
			close()
		else
			open()
		end
	end,
}

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	if input.KeyCode == Enum.KeyCode.H then
		if panel.Visible then
			close()
		else
			open()
		end
	end
end)

print("[DecorationShop] Ready — press H to open")

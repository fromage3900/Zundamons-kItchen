local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local RS = game:GetService("ReplicatedStorage")
local RF = RS:FindFirstChild("RemoteFunctions") or RS:WaitForChild("RemoteFunctions", 10)
local executeCmd = RF:FindFirstChild("ExecuteAdminCommand")
if not executeCmd then
	executeCmd = Instance.new("RemoteFunction")
	executeCmd.Name = "ExecuteAdminCommand"
	executeCmd.Parent = RF
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminConsole"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = false
screenGui.Parent = playerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 0.6
bg.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
bg.BorderSizePixel = 0
bg.Parent = screenGui

local output = Instance.new("ScrollingFrame")
output.Size = UDim2.new(1, -20, 1, -60)
output.Position = UDim2.new(0, 10, 0, 10)
output.BackgroundTransparency = 1
output.BorderSizePixel = 0
output.ScrollBarThickness = 4
output.CanvasSize = UDim2.new(0, 0, 0, 0)
output.AutomaticCanvasSize = Enum.AutomaticSize.Y
output.Parent = bg

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 0, 30)
inputBox.Position = UDim2.new(0, 10, 1, -40)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
inputBox.TextColor3 = Color3.fromRGB(200, 220, 255)
inputBox.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
inputBox.TextSize = 14
inputBox.PlaceholderText = "Type /help for commands..."
inputBox.ClearTextOnFocus = false
inputBox.BorderSizePixel = 0
inputBox.Parent = bg

local function addOutput(text, color)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Text = tostring(text)
	label.TextColor3 = color or Color3.fromRGB(180, 200, 255)
	label.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.RichText = true
	label.Parent = output
	task.wait()
	output.CanvasPosition = Vector2.new(0, output.CanvasSize.Y.Offset)
end

local function processCommand(input)
	if not input or input == "" then return end
	addOutput("> " .. input, Color3.fromRGB(255, 255, 200))
	local ok, result = pcall(function()
		return executeCmd:InvokeServer(input)
	end)
	if ok and result then
		addOutput(result, Color3.fromRGB(180, 255, 180))
	elseif not ok then
		addOutput("Error: " .. tostring(result), Color3.fromRGB(255, 100, 100))
	end
end

inputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		processCommand(inputBox.Text)
		inputBox.Text = ""
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F2 or (input.KeyCode == Enum.KeyCode.Backquote and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)) then
		screenGui.Enabled = not screenGui.Enabled
		if screenGui.Enabled then
			inputBox:CaptureFocus()
		end
	end
end)

addOutput("=== Admin Console ===", Color3.fromRGB(255, 200, 100))
addOutput("Press F2 or ~ to toggle", Color3.fromRGB(150, 180, 200))
addOutput("Type /help for commands", Color3.fromRGB(150, 180, 200))

print("[AdminConsole] Ready — press F2 to open")

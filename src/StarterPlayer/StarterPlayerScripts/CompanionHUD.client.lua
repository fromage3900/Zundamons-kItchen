local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local UIConfig = require(RS.ConfigurationFiles.UIConfig)
local UIComponents = require(RS.ConfigurationFiles.UIComponents)

local dataRE = RS.RemoteEvents:FindFirstChild("UpdateData")
local setCompEv = RS.RemoteEvents:FindFirstChild("SetCompanion")

local COMPANIONS = shared and shared.ZundaCompanionCatalog or nil

local gui = Instance.new("ScreenGui")
gui.Name = "CompanionHUD"
gui.ResetOnSpawn = false
gui.DisplayOrder = 60
gui.Parent = playerGui

local bar = UIComponents.createPanel({
    Size = UDim2.new(0, 200, 0, 44),
    Position = UDim2.new(0, 10, 0.7, 0),
    Color = Color3.fromRGB(30, 24, 40),
    Transparency = 0.2,
    Parent = gui,
})

local emojiLbl = Instance.new("TextLabel", bar)
emojiLbl.Name = "Emoji"
emojiLbl.Size = UDim2.new(0, 36, 0, 36)
emojiLbl.Position = UDim2.new(0, 4, 0.5, -18)
emojiLbl.BackgroundTransparency = 1
emojiLbl.Text = "🍡"
emojiLbl.FontFace = UIConfig.FONTS.Heading
emojiLbl.TextSize = 22

local nameLbl = UIComponents.createLabel({
    Size = UDim2.new(1, -44, 0, 18),
    Position = UDim2.new(0, 44, 0, 4),
    TextColor = UIConfig.COLORS.TextPrimary,
    FontFace = UIConfig.FONTS.Heading,
    TextSize = UIConfig.FONT_SIZES.Caption,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = bar,
})
nameLbl.Text = "Zundamon"

local buffLbl = UIComponents.createLabel({
    Size = UDim2.new(1, -44, 0, 16),
    Position = UDim2.new(0, 44, 0, 24),
    TextColor = UIConfig.COLORS.TextSecondary,
    FontFace = UIConfig.FONTS.Body,
    TextSize = UIConfig.FONT_SIZES.Caption - 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = bar,
})
buffLbl.Text = ""

local function updateDisplay(compType)
    if not COMPANIONS then return end
    local def = COMPANIONS[compType] or COMPANIONS.zundamon
    emojiLbl.Text = def.emoji or "🍡"
    nameLbl.Text = def.displayName or "Zundamon"
    local buffDesc = def.buff and def.buff.description or ""
    local flavorText = buffDesc ~= "" and buffDesc or def.flavor or ""
    buffLbl.Text = flavorText
    if def.buff and def.buff.stat then
        buffLbl.TextColor3 = buffDesc ~= "" and Color3.fromRGB(120, 255, 180) or UIConfig.COLORS.TextSecondary
    else
        buffLbl.TextColor3 = UIConfig.COLORS.TextSecondary
    end
end

if dataRE then
    dataRE.OnClientEvent:Connect(function(data)
        if data and data.active_companion then
            updateDisplay(data.active_companion)
        end
    end)
end

task.spawn(function()
    task.wait(3)
    local data = _G.data or {}
    updateDisplay(data.active_companion or "zundamon")
end)

print("[CompanionHUD] Ready")

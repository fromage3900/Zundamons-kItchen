-- [[Script] TeleporterManager (ref: RBX76FCD33D78D3478E8D39B91250192B45)]]
-- TeleporterManager: Handles zone-to-zone teleportation via teleporter pads
-- Manages fade transitions and destination selection UI

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleporterConfig = require(game.ReplicatedStorage.ConfigurationFiles.TeleporterConfig)

-- Track player teleportation state
local playerTeleporting = {}

-- Function to fade player in/out
local function fadePlayer(humanoidRootPart, fadeOut, duration)
    duration = duration or TeleporterConfig.FADE_DURATION
    local targetTransparency = fadeOut and 1 or 0
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut
    )
    
    -- Tween character parts
    for _, part in pairs(humanoidRootPart.Parent:GetDescendants()) do
        if part:IsA("BasePart") then
            local tween = TweenService:Create(part, tweenInfo, {Transparency = targetTransparency})
            tween:Play()
        end
    end
end

-- Function to teleport player to destination zone
local function teleportToZone(player, fromPadName, toZoneName)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Prevent double teleportation
    if playerTeleporting[player.UserId] then return end
    playerTeleporting[player.UserId] = true
    
    -- Find destination pad
    local toPadName = "TPad_" .. toZoneName
    local toPad = game.Workspace.TeleporterPads:FindFirstChild(toPadName)
    if not toPad then
        print("Destination pad not found: " .. toPadName)
        playerTeleporting[player.UserId] = false
        return
    end
    
    -- Get destination position (center of pad plus offset)
    local destPart = toPad:FindFirstChild("Part") or toPad:FindFirstChildWhichIsA("BasePart")
    local destPos = destPart and destPart.Position or toPad.PrimaryPart.Position
    destPos = destPos + TeleporterConfig.DESTINATION_OFFSET
    
    -- Fade out
    fadePlayer(humanoidRootPart, true)
    task.wait(TeleporterConfig.FADE_DURATION)

    -- Teleport
    humanoidRootPart.CFrame = CFrame.new(destPos + Vector3.new(0, 3, 0))

    -- Fade in
    fadePlayer(humanoidRootPart, false)

    -- Wait for fade to complete
    task.wait(TeleporterConfig.FADE_DURATION)
    
    playerTeleporting[player.UserId] = false
end

-- Setup teleporter pad interactions
local function setupTeleporterPad(padName)
    local padModel = game.Workspace.TeleporterPads:FindFirstChild(padName)
    if not padModel then
        print("Pad model not found: " .. padName)
        return
    end
    
    -- Find or create ClickDetector on main part
    local mainPart = padModel:FindFirstChildWhichIsA("BasePart")
    if not mainPart then
        print("No BasePart found in " .. padName)
        return
    end
    
    local clickDetector = mainPart:FindFirstChild("ClickDetector")
    if not clickDetector then
        clickDetector = Instance.new("ClickDetector")
        clickDetector.MaxActivationDistance = 30
        clickDetector.Parent = mainPart
    end
    
    local padConfig = TeleporterConfig.pads[padName]
    if not padConfig then
        print("No config found for pad: " .. padName)
        return
    end
    
    -- Connect click event - for now, teleport to first destination
    -- In full version, this would show a GUI with destination options
    clickDetector.MouseClick:Connect(function(player)
        -- Teleport to first available destination as demo
        if padConfig.destinations and #padConfig.destinations > 0 then
            local destZone = padConfig.destinations[1]
            teleportToZone(player, padName, destZone)
        end
    end)
    
    print("✓ Setup teleporter: " .. padName)
end

-- Initialize all teleporter pads
for padName, _ in pairs(TeleporterConfig.pads) do
    setupTeleporterPad(padName)
end

print("✓ TeleporterManager initialized")

-- Cleanup on player leave
Players.PlayerRemoving:Connect(function(player)
    playerTeleporting[player.UserId] = nil
end)
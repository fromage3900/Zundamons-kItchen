-- Runs first (000_ prefix): tear down Studio vignette overlays and duplicate ScreenGuis.
-- Real atmosphere post-processing stays in AtmospherePostFX (Lighting effects).
-- Matches docs/studio-legacy-ui-deletion.md

local Players = game:GetService("Players")

local LegacyGuiConfig = require(game.ReplicatedStorage.ConfigurationFiles.LegacyGuiConfig)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local removedCount = 0

local starterShellSet: { [string]: boolean } = {}
for _, name in ipairs(LegacyGuiConfig.destroyLegacyStarterShells) do
	starterShellSet[name] = true
end

local overlayGuiSet: { [string]: boolean } = {}
for _, name in ipairs(LegacyGuiConfig.destroyScreenGuis) do
	overlayGuiSet[name] = true
end

local function logRemoved(label: string)
	removedCount += 1
	print("[LegacyOverlayCleanup] Removed:", label)
end

local function destroyLegacyStarterShell(gui: ScreenGui): boolean
	if not starterShellSet[gui.Name] then
		return false
	end
	gui.Enabled = false
	gui:Destroy()
	logRemoved("ScreenGui " .. gui.Name .. " (Studio legacy shell)")
	return true
end

local function destroyOverlayGui(gui: ScreenGui): boolean
	if not overlayGuiSet[gui.Name] then
		return false
	end
	gui.Enabled = false
	gui:Destroy()
	logRemoved("ScreenGui " .. gui.Name)
	return true
end

local function destroyNamedDescendants(root: Instance)
	for _, name in ipairs(LegacyGuiConfig.destroyDescendantNames) do
		for _, inst in ipairs(root:GetDescendants()) do
			if inst.Name == name then
				inst:Destroy()
				logRemoved(root:GetFullName() .. "." .. name)
			end
		end
	end
end

local function isLegacyVignetteFrame(frame: Frame): boolean
	if frame.Size ~= UDim2.fromScale(1, 1) then
		return false
	end
	if frame.BackgroundTransparency >= 0.5 then
		return false
	end
	if frame:FindFirstChildOfClass("UIGradient") == nil then
		return false
	end
	if frame.ZIndex >= 20 then
		return false
	end
	return true
end

local function destroyHeuristicVignettes(root: Instance)
	for _, inst in ipairs(root:GetDescendants()) do
		if not inst:IsA("Frame") then
			continue
		end
		if not isLegacyVignetteFrame(inst) then
			continue
		end
		local parentGui = inst:FindFirstAncestorWhichIsA("ScreenGui")
		if parentGui and overlayGuiSet[parentGui.Name] then
			continue
		end
		local lower = string.lower(inst.Name)
		if string.find(lower, "vignette", 1, true) or string.find(lower, "bleed", 1, true) or string.find(lower, "grain", 1, true) then
			inst:Destroy()
			logRemoved(inst:GetFullName())
		end
	end
end

local function cleanupScreenGui(gui: ScreenGui)
	if destroyOverlayGui(gui) then
		return
	end
	if destroyLegacyStarterShell(gui) then
		return
	end
	destroyNamedDescendants(gui)
	destroyHeuristicVignettes(gui)
end

local function cleanupPlayerGui()
	for _, child in ipairs(playerGui:GetChildren()) do
		if child:IsA("ScreenGui") then
			cleanupScreenGui(child)
		end
	end
end

cleanupPlayerGui()

playerGui.ChildAdded:Connect(function(child)
	task.defer(function()
		if child:IsA("ScreenGui") then
			cleanupScreenGui(child)
		end
	end)
end)

print(string.format("[LegacyOverlayCleanup] Done — %d legacy overlay item(s) removed", removedCount))

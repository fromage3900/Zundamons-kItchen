-- Removes legacy ScreenGui watercolour vignette overlays from Studio place copies.
-- Real post-processing stays in AtmospherePostFX (Lighting Bloom / ColorCorrection).

local Players = game:GetService("Players")

local OVERLAY_NAMES = {
	"WatercolourBleed",
	"Vignette",
	"GrainLayer",
}

local function stripOverlay(gui: Instance)
	for _, name in ipairs(OVERLAY_NAMES) do
		local child = gui:FindFirstChild(name)
		if child then
			child:Destroy()
		end
	end
end

local function shouldStrip(gui: Instance): boolean
	for _, name in ipairs(OVERLAY_NAMES) do
		if gui:FindFirstChild(name) then
			return true
		end
	end
	return false
end

local function onGuiAdded(gui: Instance)
	if not gui:IsA("ScreenGui") then
		return
	end
	if shouldStrip(gui) then
		stripOverlay(gui)
	end
end

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
for _, child in ipairs(playerGui:GetChildren()) do
	onGuiAdded(child)
end
playerGui.ChildAdded:Connect(onGuiAdded)

print("[StripWatercolourOverlay] Legacy vignette overlays removed")

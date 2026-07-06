-- [[LocalScript] GuestDetector (ref: RBX5C10B6778460481D8E169AF0DEF10EBF)]]
-- GuestDetector: Client-side detection for clicking guests to serve food

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local serveGuestRF = game.ReplicatedStorage.RemoteFunctions:WaitForChild("ServeGuest")
local mouse = player:GetMouse()

local INTERACTION_RANGE = 15
local DETECTION_INTERVAL = 0.5

local character: Model? = nil
local humanoidRootPart: BasePart? = nil
local nearbyGuest = nil
local isDetectingNearbyGuestChanged = Instance.new("BindableEvent")

local function bindCharacter(char: Model)
	character = char
	humanoidRootPart = char:WaitForChild("HumanoidRootPart") :: BasePart
end

if player.Character then
	bindCharacter(player.Character)
end
player.CharacterAdded:Connect(bindCharacter)

local function findNearbyGuest()
	if not humanoidRootPart then
		return nil
	end

	local guestFolder = workspace:FindFirstChild("Guests")
	if not guestFolder then
		return nil
	end

	local closestGuest = nil
	local closestDistance = INTERACTION_RANGE

	for _, guest in pairs(guestFolder:GetChildren()) do
		local torso = guest:FindFirstChild("Torso") or guest:FindFirstChildWhichIsA("BasePart")
		if torso then
			local distance = (torso.Position - humanoidRootPart.Position).Magnitude
			if distance < closestDistance then
				closestGuest = guest
				closestDistance = distance
			end
		end
	end

	return closestGuest
end

local function onMouseClick()
	if not nearbyGuest or not nearbyGuest.Parent then
		return
	end

	local recipe = nearbyGuest:GetAttribute("PreferredRecipe")
	if not recipe then
		return
	end

	local success, message = serveGuestRF:InvokeServer(nearbyGuest, recipe)
	if success then
		print("Guest served! " .. tostring(message))
		nearbyGuest = nil
	else
		print("Could not serve guest: " .. tostring(message))
	end
end

local function detectionLoop()
	while true do
		task.wait(DETECTION_INTERVAL)

		if not character or not character.Parent or not humanoidRootPart then
			continue
		end

		local newGuest = findNearbyGuest()

		if newGuest ~= nearbyGuest then
			nearbyGuest = newGuest
			isDetectingNearbyGuestChanged:Fire(nearbyGuest)

			if nearbyGuest then
				local recipe = nearbyGuest:GetAttribute("PreferredRecipe")
				local pay = nearbyGuest:GetAttribute("PayAmount")
				print("[Guest Nearby] " .. tostring(recipe) .. " (" .. tostring(pay) .. " gold)")
				mouse.Icon = "rbxasset://textures/Cursors/MouseLockedCursor.png"
			else
				mouse.Icon = ""
			end
		end
	end
end

mouse.Button1Down:Connect(onMouseClick)
task.spawn(detectionLoop)

print("[GuestDetector] Started for " .. player.Name)

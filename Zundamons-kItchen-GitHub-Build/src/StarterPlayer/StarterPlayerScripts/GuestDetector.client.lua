-- [[LocalScript] GuestDetector (ref: RBX5C10B6778460481D8E169AF0DEF10EBF)]]
-- GuestDetector: Client-side detection for clicking guests to serve food

local player = game.Players.LocalPlayer
local character = script.Parent
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local serveGuestRF = game.ReplicatedStorage.RemoteFunctions:WaitForChild("ServeGuest")
local mouse = player:GetMouse()

local INTERACTION_RANGE = 15 -- Distance to detect guests
local DETECTION_INTERVAL = 0.5 -- How often to check for nearby guests

local nearbyGuest = nil
local isDetectingNearbyGuestChanged = Instance.new("BindableEvent")

-- Find the closest guest within range
local function findNearbyGuest()
	local guestFolder = workspace:FindFirstChild("Guests")
	if not guestFolder then return nil end
	
	local closestGuest = nil
	local closestDistance = INTERACTION_RANGE
	
	for _, guest in pairs(guestFolder:GetChildren()) do
		local torso = guest:FindFirstChild("Torso")
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

-- Handle mouse click on a guest - server checks if player has the guest's desired recipe
local function onMouseClick()
	if not nearbyGuest or not nearbyGuest.Parent then return end
	
	local recipe = nearbyGuest:GetAttribute("PreferredRecipe")
	if not recipe then return end
	
	-- Send the recipe name; server validates whether player has it in _G.data
	local success, message = serveGuestRF:InvokeServer(nearbyGuest, recipe)
	if success then
		print("Guest served! " .. tostring(message))
		nearbyGuest = nil
	else
		print("Could not serve guest: " .. tostring(message))
	end
end

-- Detection loop
local function detectionLoop()
	while character and character.Parent do
		wait(DETECTION_INTERVAL)
		
		local newGuest = findNearbyGuest()
		
		if newGuest ~= nearbyGuest then
			nearbyGuest = newGuest
			isDetectingNearbyGuestChanged:Fire(nearbyGuest)
			
			if nearbyGuest then
				local recipe = nearbyGuest:GetAttribute("PreferredRecipe")
				local pay = nearbyGuest:GetAttribute("PayAmount")
				print("[Guest Nearby] " .. recipe .. " (" .. pay .. " gold)")
				mouse.Icon = "rbxasset://textures/Cursors/MouseLockedCursor.png"
			else
				mouse.Icon = ""
			end
		end
	end
end

-- Handle mouse click
mouse.Button1Down:Connect(onMouseClick)

-- Start detection loop
spawn(detectionLoop)

print("[GuestDetector] Started for " .. player.Name)
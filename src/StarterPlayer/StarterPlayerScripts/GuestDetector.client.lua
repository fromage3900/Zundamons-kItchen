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

-- Get the food item the player is holding (checks backpack/inventory)
local function getHeldFoodItem()
	-- Check if player is holding a food item in their character
	local char = player.Character
	if char then
		local tool = char:FindFirstChildOfClass("Tool")
		if tool and tool:GetAttribute("Recipe") then
			return tool.Name, tool:GetAttribute("Quality")
		end
	end
	-- Fallback: check for food item near player (from loot drop)
	return nil, nil
end

-- Handle mouse click on a guest - server checks if player has the guest's desired recipe
local function onMouseClick()
	if not nearbyGuest or not nearbyGuest.Parent then return end
	
	local recipe = nearbyGuest:GetAttribute("PreferredRecipe")
	if not recipe then return end
	
	-- Get food item with quality
	local foodItem, quality = getHeldFoodItem()
	if not foodItem then
		-- Try to get recipe from player data without quality
		foodItem = recipe
	end
	
	-- Send the recipe name and quality; server validates and applies multiplier
	local success, message = serveGuestRF:InvokeServer(nearbyGuest, foodItem, quality)
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
		task.wait(DETECTION_INTERVAL)
		
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
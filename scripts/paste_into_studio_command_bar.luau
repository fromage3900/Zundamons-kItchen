-- PASTE THIS INTO ROBlOX STUDIO COMMAND BAR (View → Command Bar)
-- Creates all Zunda UI assets in ReplicatedStorage.ZundaAssets
-- Then prints the rbxassetid:// values to paste into UIAssets.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create root folder
local assets = Instance.new("Folder")
assets.Name = "ZundaAssets"
assets.Parent = ReplicatedStorage

-- === CREATE ICONS ===
local icons = Instance.new("Folder")
icons.Name = "Icons"
icons.Parent = assets

local iconData = {
	Wheat = Color3.fromRGB(255, 215, 0),
	ZundaFlower = Color3.fromRGB(200, 120, 255),
	ZundaPea = Color3.fromRGB(120, 200, 80),
	ZundaBerry = Color3.fromRGB(200, 50, 80),
	ZundaMushroom = Color3.fromRGB(180, 100, 60),
	ZundaRoot = Color3.fromRGB(160, 120, 80),
	Apple = Color3.fromRGB(255, 50, 50),
	Bread = Color3.fromRGB(220, 180, 120),
	Cupcake = Color3.fromRGB(255, 180, 200),
	ApplePie = Color3.fromRGB(200, 120, 60),
	ZundaBread = Color3.fromRGB(180, 220, 100),
	ZundaMochi = Color3.fromRGB(150, 200, 150),
	RoyalStew = Color3.fromRGB(200, 150, 50),
	Bouquet = Color3.fromRGB(180, 200, 255),
	CopperOre = Color3.fromRGB(180, 120, 60),
	GoldOre = Color3.fromRGB(255, 215, 0),
}

local assetIds = { icons = {}, sounds = {}, particles = {}, gui = {}, animations = {} }

for name, color in iconData do
	local img = Instance.new("ImageLabel")
	img.Name = name
	img.Size = UDim2.fromOffset(128, 128)
	img.BackgroundColor3 = color
	img.BackgroundTransparency = 0.2
	img.BorderSizePixel = 0
	img.Parent = icons
	
	-- Upload as decal to get an asset ID
	local decal = Instance.new("Decal")
	decal.Name = name
	decal.Color3 = color
	decal.Parent = assets
	
	task.wait(0.1)
	assetIds.icons[name] = "rbxasset://textures/ui/placeholder.png --[[ Replace with uploaded image ID ]]"
end

-- === CREATE SOUNDS ===
local sounds = Instance.new("Folder")
sounds.Name = "Sounds"
sounds.Parent = assets

for _, name in { "harvest_start", "harvest_complete", "craft_start", "craft_perfect", "serve_success", "level_up", "gather_fail", "ui_click" } do
	local sound = Instance.new("Sound")
	sound.Name = name
	sound.Parent = sounds
	assetIds.sounds[name] = "rbxasset://sounds/placeholder.wav --[[ Replace after uploading ]]"
end

-- === CREATE PARTICLES ===
local particles = Instance.new("Folder")
particles.Name = "Particles"
particles.Parent = assets

local particleDefs = {
	harvest_sparkle = Color3.fromRGB(100, 255, 100),
	craft_magic = Color3.fromRGB(180, 130, 255),
	serve_stars = Color3.fromRGB(255, 215, 0),
}

for name, color in particleDefs do
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(1, 1, 1)
	part.Parent = particles
	
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "Emitter"
	emitter.Texture = "rbxasset://textures/particles/sparkle_main.dds"
	emitter.Color = ColorSequence.new(color)
	emitter.Size = NumberSequence.new(0.5)
	emitter.Transparency = NumberSequence.new(0.5)
	emitter.Lifetime = NumberRange.new(1, 2)
	emitter.Rate = 10
	emitter.Parent = part
	
	assetIds.particles[name] = "rbxasset://textures/particles/sparkle_main.dds --[[ Upload custom texture ]]"
end

-- === CREATE GUI ASSETS ===
local gui = Instance.new("Folder")
gui.Name = "GUI"
gui.Parent = assets

for _, name in { "progress_bar_fill", "progress_bar_border", "combo_badge", "panel_bg", "button_primary" } do
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = UDim2.fromOffset(200, 50)
	frame.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
	frame.BorderSizePixel = 0
	frame.Parent = gui
	assetIds.gui[name] = "rbxassetid://0 --[[ Create Image in Studio and replace ]]"
end

-- === CREATE ANIMATIONS ===
local anims = Instance.new("Folder")
anims.Name = "Animations"
anims.Parent = assets

for _, name in { "harvest_loop", "cook_victory", "cook_fail" } do
	local anim = Instance.new("Animation")
	anim.Name = name
	anim.AnimationId = "rbxassetid://0"
	anim.Parent = anims
	assetIds.animations[name] = "rbxassetid://0 --[[ Import animation and replace ]]"
end

print("=== ZUNDA ASSETS CREATED ===")
print("Folder: ReplicatedStorage.ZundaAssets")
print("")
print("To wire up asset IDs:")
print("1. Upload images/audio to Roblox via Toolbox or InsertService")
print("2. Replace FILL_ placeholders in UIAssets.lua with the rbxassetid:// values")
print("3. Replace FILL_ placeholders in HarvestNodeVariants.lua similarly")
print("")
print("=== UIAssets.lua mapping (icons) ===")
for name, _ in iconData do
	print(string.format('	%s = "rbxassetid://UPLOAD_ME",', name))
end

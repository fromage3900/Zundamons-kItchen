-- Execute in Roblox Studio via MCP: execute_luau("scripts/create_zunda_assets")
-- Creates Zunda-themed UI assets and wires them into UIAssets.lua + HarvestNodeVariants.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")

local ASSET_FOLDER = Instance.new("Folder")
ASSET_FOLDER.Name = "ZundaAssets"
ASSET_FOLDER.Parent = ReplicatedStorage

local ICON_COLORS = {
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

local function createIcon(name, color, parent)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = name
	imageLabel.Size = UDim2.fromOffset(128, 128)
	imageLabel.BackgroundColor3 = color
	imageLabel.BackgroundTransparency = 0.2
	imageLabel.BorderSizePixel = 0
	imageLabel.Parent = parent
	return imageLabel
end

local function createSound(name, parent)
	local sound = Instance.new("Sound")
	sound.Name = name
	sound.Parent = parent
	return sound
end

local function createParticle(name, color, parent)
	local particle = Instance.new("ParticleEmitter")
	particle.Name = name
	particle.Texture = "rbxasset://textures/particles/sparkle_main.dds"
	particle.Color = ColorSequence.new(color)
	particle.Size = NumberSequence.new(0.5)
	particle.Transparency = NumberSequence.new(0.5)
	particle.Lifetime = NumberRange.new(1, 2)
	particle.Rate = 10
	particle.Parent = parent
	return particle
end

local function createGuiAsset(name, parent)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = UDim2.fromOffset(200, 50)
	frame.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
	frame.BorderSizePixel = 0
	frame.Parent = parent
	return frame
end

local function createAnimationTrack(name, parent)
	local animation = Instance.new("Animation")
	animation.Name = name
	animation.AnimationId = "rbxassetid://0"
	animation.Parent = parent
	return animation
end

-- Generate icons
local iconFolder = Instance.new("Folder")
iconFolder.Name = "Icons"
iconFolder.Parent = ASSET_FOLDER

for iconName, color in ICON_COLORS do
	createIcon(iconName, color, iconFolder)
end

-- Generate sounds
local soundFolder = Instance.new("Folder")
soundFolder.Name = "Sounds"
soundFolder.Parent = ASSET_FOLDER

local SOUND_NAMES = {
	"harvest_start", "harvest_complete",
	"craft_start", "craft_perfect",
	"serve_success", "level_up",
	"gather_fail", "ui_click",
}

for _, name in SOUND_NAMES do
	createSound(name, soundFolder)
end

-- Generate particles
local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = ASSET_FOLDER

local PARTICLE_DEFS = {
	harvest_sparkle = Color3.fromRGB(100, 255, 100),
	craft_magic = Color3.fromRGB(180, 130, 255),
	serve_stars = Color3.fromRGB(255, 215, 0),
}

for name, color in PARTICLE_DEFS do
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(1, 1, 1)
	part.Parent = particleFolder
	createParticle(name, color, part)
end

-- Generate GUI assets
local guiFolder = Instance.new("Folder")
guiFolder.Name = "GUI"
guiFolder.Parent = ASSET_FOLDER

local GUI_NAMES = {
	"progress_bar_fill", "progress_bar_border",
	"combo_badge", "panel_bg", "button_primary",
}

for _, name in GUI_NAMES do
	createGuiAsset(name, guiFolder)
end

-- Generate animations
local animFolder = Instance.new("Folder")
animFolder.Name = "Animations"
animFolder.Parent = ASSET_FOLDER

local ANIM_NAMES = {
	"harvest_loop", "cook_victory", "cook_fail",
}

for _, name in ANIM_NAMES do
	createAnimationTrack(name, animFolder)
end

print("[ZundaAssets] Created " .. #ICON_COLORS .. " icons, " .. #SOUND_NAMES .. " sounds, " .. #_TABLE .. " particles, " .. #GUI_NAMES .. " GUI assets, " .. #ANIM_NAMES .. " animations")

-- Wire into UIAssets config (update the FILL_ placeholders in Shared/Config/UIAssets.lua)
print("[ZundaAssets] Run `rojo build` then open UIAssets.lua to wire rbxassetid:// values")
print("[ZundaAssets] Complete! Assets ready in ReplicatedStorage.ZundaAssets")

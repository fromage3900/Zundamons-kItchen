-- [[LocalScript] AtmospherePostFX]]
-- Client post-processing driven by Lighting.CurrentHour and workspace.CurrentWeather.
-- Complements DayNightSky / WeatherSystem without modifying server atmosphere.

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = game:GetService("UserGameSettings")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local configModule = ReplicatedStorage:WaitForChild("ConfigurationFiles"):WaitForChild("PostFXConfig")
local CONFIG = require(configModule)

if not CONFIG.enabled then
	return
end

local EFFECT_NAMES = CONFIG.effect_names
local TWEEN_INFO = TweenInfo.new(CONFIG.transition_seconds, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

local activeTweens = {}

local function cancelTweens()
	for _, tween in ipairs(activeTweens) do
		tween:Cancel()
	end
	table.clear(activeTweens)
end

local function tweenProperty(instance, property, value)
	local tween = TweenService:Create(instance, TWEEN_INFO, { [property] = value })
	table.insert(activeTweens, tween)
	tween:Play()
end

local function getOrCreateEffect(className, effectName)
	local existing = Lighting:FindFirstChild(effectName)
	if existing and existing:IsA(className) then
		return existing
	end
	if existing then
		existing:Destroy()
	end
	local effect = Instance.new(className)
	effect.Name = effectName
	effect.Enabled = true
	effect.Parent = Lighting
	return effect
end

local bloom = getOrCreateEffect("BloomEffect", EFFECT_NAMES.bloom)
local sunRays = getOrCreateEffect("SunRaysEffect", EFFECT_NAMES.sun_rays)
local colorCorrection = getOrCreateEffect("ColorCorrectionEffect", EFFECT_NAMES.color_correction)

local function deepCopyPreset(preset)
	return {
		bloom = {
			intensity = preset.bloom.intensity,
			size = preset.bloom.size,
			threshold = preset.bloom.threshold,
		},
		sun_rays = {
			intensity = preset.sun_rays.intensity,
			spread = preset.sun_rays.spread,
		},
		color_correction = {
			brightness = preset.color_correction.brightness,
			contrast = preset.color_correction.contrast,
			saturation = preset.color_correction.saturation,
			tint = preset.color_correction.tint,
		},
	}
end

local function mergeWeatherModifier(target, modifier)
	if not modifier then
		return target
	end

	if modifier.bloom then
		for key, delta in pairs(modifier.bloom) do
			target.bloom[key] = (target.bloom[key] or 0) + delta
		end
	end

	if modifier.color_correction then
		for key, value in pairs(modifier.color_correction) do
			if key == "tint" and typeof(value) == "Color3" then
				target.color_correction.tint = Color3.new(
					(target.color_correction.tint.R + value.R) * 0.5,
					(target.color_correction.tint.G + value.G) * 0.5,
					(target.color_correction.tint.B + value.B) * 0.5
				)
			else
				target.color_correction[key] = (target.color_correction[key] or 0) + value
			end
		end
	end

	return target
end

local function clampPreset(preset)
	preset.bloom.intensity = math.clamp(preset.bloom.intensity, 0, 1)
	preset.bloom.size = math.clamp(preset.bloom.size, 0, 56)
	preset.bloom.threshold = math.clamp(preset.bloom.threshold, 0, 1)
	preset.sun_rays.intensity = math.clamp(preset.sun_rays.intensity, 0, 1)
	preset.sun_rays.spread = math.clamp(preset.sun_rays.spread, 0, 1)
	preset.color_correction.brightness = math.clamp(preset.color_correction.brightness, -1, 1)
	preset.color_correction.contrast = math.clamp(preset.color_correction.contrast, -1, 1)
	preset.color_correction.saturation = math.clamp(preset.color_correction.saturation, -1, 1)
	return preset
end

local function getQualityLevel()
	local saved = UserGameSettings.SavedQualityLevel
	if saved and saved.Value then
		return saved.Value
	end
	return 10
end

local function isMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function applyQualityGates(preset)
	local quality = getQualityLevel()
	local mobileScale = isMobile() and CONFIG.quality.mobile_intensity_scale or 1

	if quality < CONFIG.quality.bloom_min_level then
		preset.bloom.intensity = 0
	end

	if quality < CONFIG.quality.sun_rays_min_level then
		preset.sun_rays.intensity = 0
	end

	preset.bloom.intensity *= mobileScale
	return preset
end

local function composePreset(hour, weatherKey)
	local bandKey = CONFIG.getBandKeyForHour(hour)
	local bandPreset = CONFIG.getBandPreset(bandKey)
	local base = deepCopyPreset(bandPreset or CONFIG.default_preset)
	local weatherModifier = CONFIG.weather_modifiers[weatherKey] or CONFIG.weather_modifiers.clear
	mergeWeatherModifier(base, weatherModifier)
	applyQualityGates(base)
	clampPreset(base)
	return base, bandKey
end

local function applyPreset(preset)
	cancelTweens()

	tweenProperty(bloom, "Intensity", preset.bloom.intensity)
	tweenProperty(bloom, "Size", preset.bloom.size)
	tweenProperty(bloom, "Threshold", preset.bloom.threshold)

	tweenProperty(sunRays, "Intensity", preset.sun_rays.intensity)
	tweenProperty(sunRays, "Spread", preset.sun_rays.spread)

	tweenProperty(colorCorrection, "Brightness", preset.color_correction.brightness)
	tweenProperty(colorCorrection, "Contrast", preset.color_correction.contrast)
	tweenProperty(colorCorrection, "Saturation", preset.color_correction.saturation)
	tweenProperty(colorCorrection, "TintColor", preset.color_correction.tint)
end

local lastBandKey = nil
local lastWeather = nil

local function refreshPostFX()
	local hour = tonumber(Lighting:GetAttribute("CurrentHour")) or Lighting.ClockTime
	local weather = workspace:GetAttribute("CurrentWeather") or "clear"
	local preset, bandKey = composePreset(hour, weather)

	if bandKey == lastBandKey and weather == lastWeather then
		return
	end

	lastBandKey = bandKey
	lastWeather = weather
	applyPreset(preset)
end

-- Wait until DayNightSky publishes CurrentHour (server loop starts immediately, but attribute may lag one frame)
local deadline = tick() + 15
while Lighting:GetAttribute("CurrentHour") == nil and tick() < deadline do
	task.wait(0.1)
end

refreshPostFX()

Lighting:GetAttributeChangedSignal("CurrentHour"):Connect(refreshPostFX)
workspace:GetAttributeChangedSignal("CurrentWeather"):Connect(refreshPostFX)

print(
	string.format(
		"[AtmospherePostFX] Ready (band=%s, weather=%s, quality=%d)",
		lastBandKey or "?",
		lastWeather or "?",
		getQualityLevel()
	)
)

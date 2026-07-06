-- SkyAtmosphereHelper: apply SkyConfig presets to Lighting Sky + Atmosphere.

local SkyAtmosphereHelper = {}

local FACE_MAP = {
	skybox_bk = "SkyboxBk",
	skybox_dn = "SkyboxDn",
	skybox_ft = "SkyboxFt",
	skybox_lf = "SkyboxLf",
	skybox_rt = "SkyboxRt",
	skybox_up = "SkyboxUp",
}

function SkyAtmosphereHelper.isPlaceholderId(id: any): boolean
	if id == nil or id == "" then
		return true
	end
	if typeof(id) ~= "string" then
		return true
	end
	return id:find("FILL_") ~= nil or id:find("rbxassetid://0$") ~= nil
end

function SkyAtmosphereHelper.normalizeAssetId(id: string): string
	if id:match("^rbxassetid://") then
		return id
	end
	if id:match("^%d+$") then
		return "rbxassetid://" .. id
	end
	return id
end

function SkyAtmosphereHelper.resolvePreset(config)
	local presetName = config.active_preset or "cozy_default"
	local presets = config.presets or {}
	local preset = presets[presetName] or presets.cozy_default or {}
	local sky = preset.sky or config.sky or {}
	local atmosphere = preset.atmosphere or config.atmosphere or {}
	return presetName, sky, atmosphere
end

function SkyAtmosphereHelper.applySkyObject(sky: Sky, skyConfig)
	sky.SunAngularSize = skyConfig.sun_angular_size or sky.SunAngularSize
	sky.MoonAngularSize = skyConfig.moon_angular_size or sky.MoonAngularSize
	sky.StarCount = skyConfig.star_count or sky.StarCount
	if skyConfig.celestial_bodies_shown ~= nil then
		sky.CelestialBodiesShown = skyConfig.celestial_bodies_shown
	end

	if skyConfig.orientation then
		sky.SkyboxOrientation = skyConfig.orientation
	end

	local appliedFaces = 0
	for configKey, skyProp in pairs(FACE_MAP) do
		local raw = skyConfig[configKey]
		if not SkyAtmosphereHelper.isPlaceholderId(raw) then
			sky[skyProp] = SkyAtmosphereHelper.normalizeAssetId(raw)
			appliedFaces += 1
		end
	end

	if not SkyAtmosphereHelper.isPlaceholderId(skyConfig.sun_texture) then
		sky.SunTextureId = SkyAtmosphereHelper.normalizeAssetId(skyConfig.sun_texture)
	end
	if not SkyAtmosphereHelper.isPlaceholderId(skyConfig.moon_texture) then
		sky.MoonTextureId = SkyAtmosphereHelper.normalizeAssetId(skyConfig.moon_texture)
	end

	return appliedFaces
end

function SkyAtmosphereHelper.applyAtmosphereBase(atmo: Atmosphere, atmosphereConfig, fallback)
	atmo.Decay = atmosphereConfig.decay or fallback.decay
	atmo.Glare = atmosphereConfig.glare or fallback.glare
	atmo.Haze = atmosphereConfig.haze or fallback.haze
	if atmosphereConfig.offset then
		atmo.Offset = atmosphereConfig.offset
	end
end

return SkyAtmosphereHelper

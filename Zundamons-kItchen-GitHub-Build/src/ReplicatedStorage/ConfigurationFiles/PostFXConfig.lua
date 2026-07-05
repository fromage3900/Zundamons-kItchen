-- [[ModuleScript] PostFXConfig]]
-- Tunable post-processing presets for AtmospherePostFX.client.lua.
-- Driven by Lighting.CurrentHour + workspace.CurrentWeather (same contract as DayNightSky).

local PostFXConfig = {}

PostFXConfig.enabled = true
PostFXConfig.transition_seconds = 2.5

-- Instance names under Lighting (get-or-create; avoids clashing with Studio defaults)
PostFXConfig.effect_names = {
	bloom = "ZundaBloom",
	sun_rays = "ZundaSunRays",
	color_correction = "ZundaColorCorrection",
}

PostFXConfig.quality = {
	bloom_min_level = 6,
	sun_rays_min_level = 8,
	mobile_intensity_scale = 0.65,
}

-- Neutral fallback when hour band lookup fails
PostFXConfig.default_preset = {
	bloom = { intensity = 0.2, size = 24, threshold = 0.9 },
	sun_rays = { intensity = 0.08, spread = 0.15 },
	color_correction = {
		brightness = 0,
		contrast = 0,
		saturation = 0,
		tint = Color3.fromRGB(255, 255, 255),
	},
}

-- Hour bands: { key, start_hour inclusive, end_hour exclusive }
-- Night wraps through midnight (start > end).
PostFXConfig.hour_bands = {
	{
		key = "night",
		start_hour = 21,
		end_hour = 6,
		bloom = { intensity = 0.15, size = 20, threshold = 0.92 },
		sun_rays = { intensity = 0, spread = 0.1 },
		color_correction = {
			brightness = -0.05,
			contrast = 0,
			saturation = -0.08,
			tint = Color3.fromRGB(168, 192, 232),
		},
	},
	{
		key = "golden",
		start_hour = 6,
		end_hour = 10,
		bloom = { intensity = 0.35, size = 28, threshold = 0.85 },
		sun_rays = { intensity = 0.12, spread = 0.2 },
		color_correction = {
			brightness = 0.02,
			contrast = 0,
			saturation = -0.1,
			tint = Color3.fromRGB(255, 232, 208),
		},
	},
	{
		key = "clear",
		start_hour = 10,
		end_hour = 17,
		bloom = { intensity = 0.2, size = 24, threshold = 0.9 },
		sun_rays = { intensity = 0.08, spread = 0.15 },
		color_correction = {
			brightness = 0,
			contrast = 0,
			saturation = 0,
			tint = Color3.fromRGB(255, 255, 255),
		},
	},
	{
		key = "sunset",
		start_hour = 17,
		end_hour = 21,
		bloom = { intensity = 0.45, size = 30, threshold = 0.82 },
		sun_rays = { intensity = 0.18, spread = 0.22 },
		color_correction = {
			brightness = 0.03,
			contrast = 0.05,
			saturation = -0.05,
			tint = Color3.fromRGB(255, 208, 168),
		},
	},
}

-- Applied on top of the hour-band preset.
PostFXConfig.weather_modifiers = {
	clear = {},
	cloudy = {
		color_correction = { saturation = -0.06, tint = Color3.fromRGB(240, 242, 248) },
	},
	cherry_blossom = {
		bloom = { intensity = 0.1 },
		color_correction = {
			saturation = 0.05,
			tint = Color3.fromRGB(255, 228, 238),
		},
	},
	rain = {
		bloom = { intensity = -0.05 },
		color_correction = {
			saturation = -0.12,
			brightness = -0.03,
			tint = Color3.fromRGB(200, 215, 235),
		},
	},
	storm = {
		bloom = { intensity = -0.08 },
		color_correction = {
			saturation = -0.15,
			contrast = 0.08,
			brightness = -0.05,
			tint = Color3.fromRGB(185, 200, 225),
		},
	},
	snow = {
		bloom = { intensity = 0.05 },
		color_correction = {
			saturation = -0.08,
			brightness = 0.04,
			tint = Color3.fromRGB(235, 242, 255),
		},
	},
	fog = {
		bloom = { intensity = -0.05 },
		color_correction = {
			saturation = -0.14,
			brightness = -0.02,
			tint = Color3.fromRGB(215, 220, 228),
		},
	},
	aurora = {
		bloom = { intensity = 0.08 },
		color_correction = {
			saturation = 0.08,
			tint = Color3.fromRGB(190, 230, 210),
		},
	},
}

function PostFXConfig.getBandKeyForHour(hour)
	for _, band in ipairs(PostFXConfig.hour_bands) do
		local startH = band.start_hour
		local endH = band.end_hour
		if startH > endH then
			if hour >= startH or hour < endH then
				return band.key
			end
		elseif hour >= startH and hour < endH then
			return band.key
		end
	end
	return "clear"
end

function PostFXConfig.getBandPreset(key: string)
	for _, band in ipairs(PostFXConfig.hour_bands) do
		if band.key == key then
			return band
		end
	end
	return nil
end

return PostFXConfig

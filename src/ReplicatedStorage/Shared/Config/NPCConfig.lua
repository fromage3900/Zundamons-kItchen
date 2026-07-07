-- Guest NPC models sourced from Kenney Mini Characters (CC0, kenney.nl)
-- Companion character models based on Zundamon project (ZUNKO PJ, https://zunko.jp/)
-- See CREDITS.md for full attribution.
local NPCConfig = {
	guestTemplates = {
		Child = {
			modelId = "rbxassetid://85728145615215",
			scale = 0.7,
			animations = {
				idle = "rbxassetid://2510798496",
				walk = "rbxassetid://2510798484",
				eat = "rbxassetid://2510798496",
			},
		},
		Adult = {
			modelId = "rbxassetid://89611587152743",
			scale = 1.0,
			animations = {
				idle = "rbxassetid://2510798496",
				walk = "rbxassetid://2510798484",
				eat = "rbxassetid://2510798496",
			},
		},
		Elder = {
			modelId = "rbxassetid://121639150484362",
			scale = 0.9,
			animations = {
				idle = "rbxassetid://2510798496",
				walk = "rbxassetid://2510798484",
				eat = "rbxassetid://2510798496",
			},
		},
	},
	companionTemplates = {
		Zundapal = {
			modelId = "rbxassetid://113753628820808",
			scale = 0.5,
			followSpeed = 8,
			sparkleEffect = "rbxassetid://241685484",
			buff = nil,
			price = 0,
		},
		Ankomon = {
			modelId = "rbxassetid://110290651922538",
			scale = 0.6,
			followSpeed = 6,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "gold", magnitude = 0.15, description = "+15% gold from serving guests" },
			price = 250,
		},
		Cardamon = {
			modelId = "rbxassetid://91041813069462",
			scale = 0.5,
			followSpeed = 7,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "perfect_window", magnitude = 0.30, description = "+30% wider perfect cooking window" },
			price = 150,
		},
		Antimon = {
			modelId = "rbxassetid://94125444857929",
			scale = 0.4,
			followSpeed = 12,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "extra_drop", magnitude = 0.20, description = "+20% chance of extra drop on gather" },
			price = 100,
		},
		Sakuradamon = {
			modelId = "rbxassetid://128478553136178",
			scale = 0.55,
			followSpeed = 8,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "xp", magnitude = 0.25, description = "+25% XP from crafting & serving" },
			price = 300,
		},
	},

	goldShopCompanions = {
		BerryBud = {
			modelId = "rbxassetid://110290651922538",
			scale = 0.5,
			followSpeed = 6,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "berry_finder", magnitude = 1, description = "Increased berry harvest chance" },
			price = 1200,
			levelRequired = 8,
		},
		RootWarden = {
			modelId = "rbxassetid://91041813069462",
			scale = 0.6,
			followSpeed = 5,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "root_finder", magnitude = 1, description = "Find rare roots more often" },
			price = 1500,
			levelRequired = 12,
		},
		MycoMon = {
			modelId = "rbxassetid://94125444857929",
			scale = 0.45,
			followSpeed = 7,
			sparkleEffect = "rbxassetid://241685484",
			buff = { stat = "mushroom_finder", magnitude = 1, description = "Mushrooms appear more frequently" },
			price = 800,
			levelRequired = 6,
		},
	},

	qualityMultipliers = {
		perfect = 1.5,
		great = 1.2,
		ok = 1.0,
	},

	guestSpawnDefaults = {
		spawnInterval = 15,
		maxGuests = 8,
		timeoutDuration = 120,
		maxQueueDistance = 24,
	},

	spawnPoints = {
		Vector3.new(188, -518, -415),
		Vector3.new(196, -518, -415),
		Vector3.new(204, -518, -415),
		Vector3.new(212, -518, -415),
	},
}

function NPCConfig.getTemplate(modelName)
	return NPCConfig.guestTemplates[modelName]
end

function NPCConfig.getCompanion(name)
	return NPCConfig.companionTemplates[name]
end

function NPCConfig.getGoldCompanion(name)
	return NPCConfig.goldShopCompanions[name]
end

function NPCConfig.getSpawnPoint(index)
	local points = NPCConfig.spawnPoints
	return points[index]
end

function NPCConfig.getQualityMultiplier(quality)
	return NPCConfig.qualityMultipliers[quality] or 1.0
end

return NPCConfig

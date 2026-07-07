<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/NPCConfig.lua
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
			buff = "double_xp",
			price = 250,
		},
		Cardamon = {
			modelId = "rbxassetid://91041813069462",
			scale = 0.5,
			followSpeed = 7,
			sparkleEffect = "rbxassetid://241685484",
			buff = "wider_timing",
			price = 150,
		},
		Antimon = {
			modelId = "rbxassetid://94125444857929",
			scale = 0.4,
			followSpeed = 12,
			sparkleEffect = "rbxassetid://241685484",
			buff = "faster_craft",
			price = 100,
		},
		Sakuradamon = {
			modelId = "rbxassetid://128478553136178",
			scale = 0.55,
			followSpeed = 8,
			sparkleEffect = "rbxassetid://241685484",
			buff = "rare_drops",
			price = 300,
=======
local NPCConfig = {}

NPCConfig.guestTemplates = {
	Child = {
		modelId = "rbxassetid://85728145615215",
		scale = 0.7,
		animations = {
			idle = "rbxassetid://FILL_ANIM_IDLE",
			walk = "rbxassetid://FILL_ANIM_WALK",
			eat = "rbxassetid://FILL_ANIM_EAT",
		},
	},
	Adult = {
		modelId = "rbxassetid://89611587152743",
		scale = 1.0,
		animations = {
			idle = "rbxassetid://FILL_ANIM_IDLE",
			walk = "rbxassetid://FILL_ANIM_WALK",
			eat = "rbxassetid://FILL_ANIM_EAT",
>>>>>>> e782c9f (🎮 quests: add gold shop companions (BerryBud, RootWarden, MycoMon) + quality payout multipliers + expanded achievements):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/NPCConfig.lua
		},
	},
	Elder = {
		modelId = "rbxassetid://121639150484362",
		scale = 0.9,
		animations = {
			idle = "rbxassetid://FILL_ANIM_IDLE",
			walk = "rbxassetid://FILL_ANIM_WALK",
			eat = "rbxassetid://FILL_ANIM_EAT",
		},
	},
}

NPCConfig.companionTemplates = {
	Zundapal = {
		modelId = "rbxassetid://113753628820808",
		scale = 0.5,
		followSpeed = 8,
		sparkleEffect = "rbxassetid://FILL_EFFECT_SPARKLE",
		buff = nil,
		price = 0,
	},
	Ankomon = {
		modelId = "rbxassetid://110290651922538",
		scale = 0.6,
		followSpeed = 6,
		sparkleEffect = "rbxassetid://FILL_EFFECT_GOLD",
		buff = "double_xp",
		price = 250,
	},
	Cardamon = {
		modelId = "rbxassetid://91041813069462",
		scale = 0.5,
		followSpeed = 7,
		sparkleEffect = "rbxassetid://FILL_EFFECT_LAVENDER",
		buff = "wider_timing",
		price = 150,
	},
	Antimon = {
		modelId = "rbxassetid://94125444857929",
		scale = 0.4,
		followSpeed = 12,
		sparkleEffect = "rbxassetid://FILL_EFFECT_YELLOW",
		buff = "faster_craft",
		price = 100,
	},
	Sakuradamon = {
		modelId = "rbxassetid://128478553136178",
		scale = 0.55,
		followSpeed = 8,
		sparkleEffect = "rbxassetid://FILL_EFFECT_PINK",
		buff = "rare_drops",
		price = 300,
	},
}

-- Gold Shop Companions (Kenney asset variants)
NPCConfig.goldShopCompanions = {
	BerryBud = {
		modelId = "rbxassetid://110290651922538",
		scale = 0.5,
		followSpeed = 6,
		sparkleEffect = "rbxassetid://FILL_EFFECT_GREEN",
		buff = "berry_finder",
		price = 1200,
		levelRequired = 8,
	},
	RootWarden = {
		modelId = "rbxassetid://91041813069462",
		scale = 0.6,
		followSpeed = 5,
		sparkleEffect = "rbxassetid://FILL_EFFECT_BROWN",
		buff = "root_finder",
		price = 1500,
		levelRequired = 12,
	},
	MycoMon = {
		modelId = "rbxassetid://94125444857929",
		scale = 0.45,
		followSpeed = 7,
		sparkleEffect = "rbxassetid://FILL_EFFECT_SPOTTY",
		buff = "mushroom_finder",
		price = 800,
		levelRequired = 6,
	},
}

-- Serve quality payout multipliers
NPCConfig.qualityMultipliers = {
	perfect = 1.5,
	great = 1.2,
	ok = 1.0,
}

NPCConfig.guestSpawnDefaults = {
	spawnInterval = 15,
	maxGuests = 8,
	timeoutDuration = 120,
	maxQueueDistance = 24,
}

NPCConfig.spawnPoints = {
	Vector3.new(188, -518, -415),
	Vector3.new(196, -518, -415),
	Vector3.new(204, -518, -415),
	Vector3.new(212, -518, -415),
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
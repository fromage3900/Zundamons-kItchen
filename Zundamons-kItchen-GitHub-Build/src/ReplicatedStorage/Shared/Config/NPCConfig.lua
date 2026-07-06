local NPCConfig = {
	guestTemplates = {
		Child = {
			modelId = "rbxassetid://FILL_NPC_CHILD",
			scale = 0.7,
			animations = {
				idle = "rbxassetid://FILL_ANIM_IDLE",
				walk = "rbxassetid://FILL_ANIM_WALK",
				eat = "rbxassetid://FILL_ANIM_EAT",
			},
		},
		Adult = {
			modelId = "rbxassetid://FILL_NPC_ADULT",
			scale = 1.0,
			animations = {
				idle = "rbxassetid://FILL_ANIM_IDLE",
				walk = "rbxassetid://FILL_ANIM_WALK",
				eat = "rbxassetid://FILL_ANIM_EAT",
			},
		},
		Elder = {
			modelId = "rbxassetid://FILL_NPC_ELDER",
			scale = 0.9,
			animations = {
				idle = "rbxassetid://FILL_ANIM_IDLE",
				walk = "rbxassetid://FILL_ANIM_WALK",
				eat = "rbxassetid://FILL_ANIM_EAT",
			},
		},
	},
	companionTemplates = {
		Zundapal = {
			modelId = "rbxassetid://FILL_COMPANION_ZUNDAPAL",
			scale = 0.5,
			followSpeed = 8,
			sparkleEffect = "rbxassetid://FILL_EFFECT_SPARKLE",
			buff = nil, -- free companion
			price = 0,
		},
		Ankomon = {
			modelId = "rbxassetid://FILL_COMPANION_ANKOMON",
			scale = 0.6,
			followSpeed = 6,
			sparkleEffect = "rbxassetid://FILL_EFFECT_GOLD",
			buff = "double_xp",
			price = 250,
		},
		Cardamon = {
			modelId = "rbxassetid://FILL_COMPANION_CARDAMON",
			scale = 0.5,
			followSpeed = 7,
			sparkleEffect = "rbxassetid://FILL_EFFECT_LAVENDER",
			buff = "wider_timing",
			price = 150,
		},
		Antimon = {
			modelId = "rbxassetid://FILL_COMPANION_ANTIMON",
			scale = 0.4,
			followSpeed = 12,
			sparkleEffect = "rbxassetid://FILL_EFFECT_YELLOW",
			buff = "faster_craft",
			price = 100,
		},
		Sakuradamon = {
			modelId = "rbxassetid://FILL_COMPANION_SAKURA",
			scale = 0.55,
			followSpeed = 8,
			sparkleEffect = "rbxassetid://FILL_EFFECT_PINK",
			buff = "rare_drops",
			price = 300,
		},
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

function NPCConfig.getTemplate(modelName: string): { [string]: any }?
	return NPCConfig.guestTemplates[modelName]
end

function NPCConfig.getCompanion(name: string): { [string]: any }?
	return NPCConfig.companionTemplates[name]
end

function NPCConfig.getSpawnPoint(index: number): Vector3?
	local points = NPCConfig.spawnPoints
	return points[index]
end

return NPCConfig

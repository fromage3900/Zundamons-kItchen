local NPCConfig = {
	guestTemplates = {
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
	},
	companionTemplates = {
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

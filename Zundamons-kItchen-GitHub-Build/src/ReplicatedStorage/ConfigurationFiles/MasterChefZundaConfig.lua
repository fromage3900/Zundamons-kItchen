-- [[ModuleScript] MasterChefZundaConfig]]
-- Master Chef Zunda NPC: kitchen mentor (Zundamon) with scripted VN + LLM persona.

local MasterChefZundaConfig = {}

MasterChefZundaConfig.speakerKey = "master_chef"
MasterChefZundaConfig.collectionTag = "MasterChefZunda"
MasterChefZundaConfig.interactDistance = 22
MasterChefZundaConfig.llmPersonaKey = "master_chef"

-- Studio: tag kitchen NPC model/part with CollectionService tag MasterChefZunda + ClickDetector
MasterChefZundaConfig.studioPaths = {
	"Kitchen",
	"MasterChefZunda",
}

MasterChefZundaConfig.tierGreetings = {
	[1] = "Welcome to the Kitchen Court, {playerName}. Every great chef starts with patience and good bread.",
	[2] = "Royal Chef {playerName} — your guests speak well of you. Keep honing your timing.",
	[3] = "Master Chef {playerName}... the village is proud. You carry the old chef-monks' spirit.",
	[4] = "Legend {playerName}. Even the Ancient Ruins whisper your name when the wind stirs.",
}

MasterChefZundaConfig.tierAdvice = {
	[1] = "Gather Zunda Peas in the garden, craft simple dishes, and serve your first guests.",
	[2] = "Try Royal Stew and Zunda Bread — perfect timing earns bonus gold.",
	[3] = "Seek the Hilltop Shrine and Ancient Ruins. Legendary recipes await worthy hands.",
	[4] = "Share your craft freely. The next generation of chefs is watching you.",
}

MasterChefZundaConfig.recipeTips = {
	ZundaMochi = "Five Zunda Peas and eight Wheat — fold with care, not haste.",
	ZundaParadise = "The ultimate dish: peas, edamame, sweet peas, and pea flowers in balance.",
	RoyalStew = "A hearty stew for Royal-tier guests — don't rush the simmer.",
}

function MasterChefZundaConfig.resolve(text: string, playerName: string?): string
	return string.gsub(text, "{playerName}", playerName or "Chef")
end

function MasterChefZundaConfig.greetingForTier(tier: number, playerName: string?): string
	local line = MasterChefZundaConfig.tierGreetings[tier] or MasterChefZundaConfig.tierGreetings[1]
	return MasterChefZundaConfig.resolve(line, playerName)
end

function MasterChefZundaConfig.adviceForTier(tier: number, playerName: string?): string
	local line = MasterChefZundaConfig.tierAdvice[tier] or MasterChefZundaConfig.tierAdvice[1]
	return MasterChefZundaConfig.resolve(line, playerName)
end

return MasterChefZundaConfig

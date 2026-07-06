-- [[ModuleScript] VNDialogueData]]
-- Registry for speakers and static dialogue tables (no LocalPlayer at require time).

local RGB = Color3.fromRGB

local SPEAKERS = {
	zundamon = { name = "Zundamon", emoji = "🍙", accent = RGB(120, 200, 130), portrait = RGB(45, 90, 50) },
	zundapal = { name = "Zundapal", emoji = "🍡", accent = RGB(150, 230, 160), portrait = RGB(35, 90, 45) },
	master_chef = {
		name = "Master Chef Zunda",
		emoji = "🍙",
		accent = RGB(200, 165, 90),
		portrait = RGB(72, 48, 28),
	},
	narrator = { name = "", emoji = "✨", accent = RGB(160, 145, 225), portrait = RGB(28, 18, 55) },
	elder = { name = "Village Elder", emoji = "🏮", accent = RGB(225, 185, 100), portrait = RGB(95, 55, 18) },
	ruins = { name = "Ancient Voice", emoji = "👁", accent = RGB(170, 140, 230), portrait = RGB(22, 14, 48) },
	chef = { name = "Head Chef", emoji = "🍳", accent = RGB(255, 180, 75), portrait = RGB(95, 50, 18) },
	system = { name = "", emoji = "⭐", accent = RGB(180, 165, 255), portrait = RGB(28, 22, 62) },
}

local COMPANION_DIALOGUE_TEMPLATES = {
	morning = {
		"Good morning, {playerName}~ ☀️",
		"Ready to cook up something wonderful today?",
		"I can already smell the kitchen from here! 🍳",
	},
	afternoon = {
		"Hey, {playerName}! You're doing great~ ✨",
		"Have you tried any of the new recipes yet?",
		"The guests look hungry... let's get cooking! 🍡",
	},
	evening = {
		"The sunset is so pretty from here... 🌅",
		"You worked so hard today, {playerName}.",
		"I'll be right here beside you, always~ 💫",
	},
	night = {
		"Psst — {playerName}... still awake? 🌙",
		"The stars are beautiful tonight...",
		"Even chefs deserve a rest. I'll keep watch~ ⭐",
	},
}

local SIDE_DIALOGUES = {
	{
		trigger = "zunda_pea",
		lines = {
			{ speaker = "zundapal", text = "Oh! You found some Zunda Peas! 🫛" },
			{ speaker = "zundapal", text = "Those are my favorite~ They're so sweet and green!" },
			{ speaker = "zundapal", text = "Did you know you can make Zunda Mochi with them? 🍡" },
		},
	},
	{
		trigger = "edamame",
		lines = {
			{ speaker = "zundapal", text = "Edamame pods! 🌿" },
			{ speaker = "zundapal", text = "These make the best snacks when you're feeling peckish~" },
			{ speaker = "zundapal", text = "Try roasting them with a little salt! ✨" },
		},
	},
	{
		trigger = "cooking_tip",
		lines = {
			{ speaker = "zundapal", text = "Want a cooking tip, {playerName}? 👨‍🍳" },
			{ speaker = "zundapal", text = "Timing is everything! Watch the timer carefully~" },
			{ speaker = "zundapal", text = "Perfect timing means perfect flavor! 🌟" },
		},
	},
	{
		trigger = "zunda_mochi",
		lines = {
			{ speaker = "zundapal", text = "Zunda Mochi is a special treat! 🍡" },
			{ speaker = "zundapal", text = "It's made from sweet green peas, mashed into paste~" },
			{ speaker = "zundapal", text = "The texture is so chewy and delicious! 💚" },
		},
	},
	{
		trigger = "pea_flower",
		lines = {
			{ speaker = "zundapal", text = "Pea flowers are so pretty! 🌸" },
			{ speaker = "zundapal", text = "They bloom in the sweetest shades of pink~" },
			{ speaker = "zundapal", text = "You can even make tea with them! 🍵" },
		},
	},
	{
		trigger = "encouragement",
		lines = {
			{ speaker = "zundapal", text = "You're doing amazing, {playerName}! 💪" },
			{ speaker = "zundapal", text = "Every dish you make brings smiles to our guests~" },
			{ speaker = "zundapal", text = "Keep up the wonderful work! ✨" },
		},
	},
	{
		trigger = "zunda_paradise",
		lines = {
			{ speaker = "zundapal", text = "Zunda Paradise... the legendary dish! ✨" },
			{ speaker = "zundapal", text = "It combines all the best Zunda ingredients~" },
			{ speaker = "zundapal", text = "Only true masters can create it! 🌟" },
		},
	},
}

local VNDialogueData = {}

function VNDialogueData.resolve(text: string, playerName: string?): string
	return string.gsub(text, "{playerName}", playerName or "Chef")
end

function VNDialogueData.getCompanionDialogue(slot: string, playerName: string?): { string }
	local templates = COMPANION_DIALOGUE_TEMPLATES[slot] or COMPANION_DIALOGUE_TEMPLATES.afternoon
	local resolved = table.create(#templates)
	for i, line in ipairs(templates) do
		resolved[i] = VNDialogueData.resolve(line, playerName)
	end
	return resolved
end

function VNDialogueData.resolveSideDialogues(playerName: string?)
	local resolved = {}
	for _, entry in ipairs(SIDE_DIALOGUES) do
		local copy = { trigger = entry.trigger, lines = {} }
		for _, line in ipairs(entry.lines) do
			table.insert(copy.lines, {
				speaker = line.speaker,
				text = VNDialogueData.resolve(line.text, playerName),
			})
		end
		table.insert(resolved, copy)
	end
	return resolved
end

VNDialogueData.SPEAKERS = SPEAKERS
VNDialogueData.COMPANION_DIALOGUE = COMPANION_DIALOGUE_TEMPLATES
VNDialogueData.SIDE_DIALOGUES = SIDE_DIALOGUES

return VNDialogueData

-- [[ModuleScript] VNDialogueData]]
-- Registry for speakers and companion-specific branching dialogue
-- 5 companions with unique personalities + level-based branches

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local RGB = Color3.fromRGB

-- Speaker configurations with companion emojis
local SPEAKERS = {}
SPEAKERS.zundamon = { name = "Zundamon", emoji = "🍡🔥", accent = RGB(140, 255, 160), portrait = RGB(180, 255, 200) }
SPEAKERS.zundapal = { name = "Zundapal", emoji = "🫛✨", accent = RGB(200, 255, 180), portrait = RGB(210, 255, 195) }
SPEAKERS.narrator = { name = "", emoji = "🌀", accent = RGB(220, 200, 170), portrait = RGB(230, 220, 200) }
SPEAKERS.elder = { name = "Village Elder", emoji = "🏮", accent = RGB(220, 180, 130), portrait = RGB(230, 200, 160) }
SPEAKERS.ruins = { name = "??WHISPER??", emoji = "👁️", accent = RGB(190, 170, 210), portrait = RGB(210, 195, 220) }
SPEAKERS.chef = { name = "Head Chef", emoji = "🍳💀", accent = RGB(255, 120, 80), portrait = RGB(255, 150, 120) }
SPEAKERS.system = { name = "", emoji = "⚡", accent = RGB(210, 195, 235), portrait = RGB(225, 215, 240) }
SPEAKERS.ankomon = { name = "Ankomon", emoji = "🫘🥊", accent = RGB(200, 80, 80), portrait = RGB(220, 100, 100) }
SPEAKERS.cardamon = { name = "Cardamon", emoji = "🌿🍋", accent = RGB(240, 200, 80), portrait = RGB(255, 230, 140) }
SPEAKERS.antimon = { name = "Antimon", emoji = "⚡💨", accent = RGB(120, 220, 200), portrait = RGB(160, 240, 220) }
SPEAKERS.sakuradamon =
	{ name = "Sakuradamon", emoji = "🌸💥", accent = RGB(255, 180, 220), portrait = RGB(255, 220, 230) }

-- Companion-specific branching dialogue (time + level based)
-- They get progressively more unhinged
local COMPANION_DIALOGUE = {}
COMPANION_DIALOGUE.zundapal = {
	morning = {
		"GOOD MORNING!!!!!!!! " .. player.Name .. "!!! ☀️☀️☀️",
		"THE PEAS ARE AWAKE AND SO ARE WE LET'S GOOOOO",
		"I can smell the kitchen from here and it smells like GLORY 🍳✨",
	},
	afternoon = {
		"Hey " .. player.Name .. " you're COOKING (literally) 🔥🔥🔥",
		"Did you try the new recipe? DID YOU?? WAS IT AMAZING??",
		"THE GUESTS ARE STARVING AND I'M STARVING LET'S FEED THEM ALL 🍡🍡🍡",
	},
	evening = {
		"The sunset is hitting different today... 🌅",
		"You worked so hard, " .. player.Name .. "! Take a bow or something!!",
		"I'll be right here. Watching. Waiting. Always. 👁️💫",
	},
	night = {
		"PSST — " .. player.Name .. "... you up?? 🌙🌙",
		"I was counting peas to sleep but I LOST COUNT AT 3000",
		"Chefs need rest but like... what IF we cooked all night instead?? ⭐",
	},
	level1_10 = { "A JOURNEY BEGINS!!! I'M SO EXCITED I COULD BURST INTO PEAS 🌱", "Let's gather stuff!!! EVERYTHING!!! ALL THE THINGS!!!" },
	level11_20 = { "YOU'RE GETTING THE HANG OF THIS!!! NEXT STOP: WORLD DOMINATION VIA SNACKS ✨", "ZUNDA MOCHI TIME!!! IT'S MY FAVORITE IT'S SO GOOD I CRY 🍡" },
	level21_50 = { "CHEF SUPREME " .. player.Name .. "!!!! YOU'RE A CULINARY MENACE 👑", "You've mastered so many recipes my brain is doing backflips 🌀" },
}
COMPANION_DIALOGUE.ankomon = {
	morning = {
		"RISE AND SHINE IT'S BEAN O'CLOCK, " .. player.Name .. " 🫘🔥",
		"DISCIPLINE. FOCUS. BEANS. THESE ARE THE PILLARS OF COOKING.",
		"Precision is key!!! UNLESS YOU'RE MAKING SOUP THEN JUST THROW STUFF IN 🥣",
	},
	afternoon = { "YOU'RE GETTING STRONGER I CAN SENSE IT IN THE BEAN AURA 🫘⚡", "XP GO BRRRRRRR — FOCUS UP CHEF!!!" },
	level1_10 = { "Basics first. Then beans. THEN EVERYTHING ELSE. Order matters." },
	level11_20 = { "EXCELLENT FORM!!! YOUR XP IS MULTIPLYING LIKE RABBITS (or beans) 🫘🐇" },
	level21_50 = { "TRUE MASTERY!!! DOUBLE XP!!! TRIPLE BEANS!!! I'M SO PROUD I COULD BURST 🫘💥" },
}
COMPANION_DIALOGUE.cardamon = {
	morning = { "Breathe in… breathe out… " .. player.Name .. "~ 🍃", "PATIENCE IS A VIRTUE BUT FRANKLY I'M RUNNING LOW ON IT 🔥🧘" },
	night = { "The herbs are whispering again… they say YOU COOKED TODAY. Legendary behavior 🌿", "Rest well. Tomorrow we commit GASTRONOMY CRIMES (delicious ones) 🍳" },
	level1_10 = { "Go slow at first… OR DON'T. I'm a cardamon not a cop 😤" },
	level11_20 = { "Your timing window is WIDER now! You could drive a TRUCK through that window 🚛✨" },
	level21_50 = { "PERFECT ZEN STATE!!! FLAWLESS COOKING AHEAD!!! The herbs are SCREAMING 🔥🌿🔥" },
}
COMPANION_DIALOGUE.antimon = {
	morning = { "TIME IS MONEY AND INGREDIENTS AND EVERYTHING GO GO GO " .. player.Name .. " ⚡⚡⚡", "LET'S COOK AT THE SPEED OF SOUND BOOM 💥" },
	afternoon = { "FASTER!!! MORE DISHES!!! CHAOS KITCHEN MODE ACTIVATED 🚀🚀🚀", "I CAN FEEL THE ENERGY!!! THE KITCHEN IS VIBRATING ⚡💨" },
	level1_10 = { "Haste makes waste BUT HASTE ALSO MAKES DINNER so let's gooooo 🏃‍♂️💨" },
	level11_20 = { "CRAFTING SPEED BUFF ACTIVE!!! YOU'RE A LIVING BLENDER NOW 🌀" },
	level21_50 = { "NO TIME WASTED!!! PURE EFFICIENCY!!! CHEF MODE MAXIMUM OVERDRIVE ⚡🔥⚡" },
}
COMPANION_DIALOGUE.sakuradamon = {
	morning = { "THE BLOSSOMS ARE BLOOMING AND SO IS YOUR POTENTIAL, " .. player.Name .. " 🌸💥", "RARE INGREDIENT SENSORS TINGLING!!! GO GO GO!!!" },
	night = { "The moon is full… the ingredients are NERVOUS… excellent ✨🌙", "LISTEN CLOSELY… they're whispering WHERE THEY HIDE. N O W  G O 🗣️🌸" },
	level1_10 = { "RARE DROPS I SENSE THEM THEY'RE EVERYWHERE THEY'RE IN THE WALLS 🧱👁️" },
	level11_20 = { "YOUR RARE DROP CHANCE HAS ASCENDED!!! THE INGREDIENTS CANNOT HIDE FROM YOU NOW 🌸🔍" },
	level21_50 = { "LEGENDARY INGREDIENTS ARE LITERALLY THROWING THEMSELVES AT YOU!!! THIS IS YOUR ERA 💫🌸💫" },
}

-- Side dialogue triggers (item/lore discoveries)
local SIDE_DIALOGUES = {}
SIDE_DIALOGUES.zunda_pea = {
	speaker = "zundapal",
	text = "OH MY PEA YOU FOUND ZUNDA PEAS 🫛🫛🫛",
	hint = "THEY'RE SO GREEN AND PERFECT AND I LOVE THEM MORE THAN ANYTHING",
	recipe = "ZUNDA MOCHI TIME BABYYYYY SMASH THOSE PEAS INTO GLORY 🍡🔥",
}
SIDE_DIALOGUES.zunda_mochi = {
	speaker = "zundapal",
	text = "ZUNDA MOCHI!!!! THE LEGENDARY SNACK 🍡✨",
	lore = "It's peas. Mashed. And PERFECT. That's it. That's the lore.",
	tip = "THE CHEWINESS IS ENOUGH TO MAKE YOU TRANSCEND 💚💚💚",
}
SIDE_DIALOGUES.wheat = {
	speaker = "zundapal",
	text = "WHEAT!!! The backbone of EVERYTHING DELICIOUS 🌾",
	tip = "GOLDEN WHEAT = GOLDEN BREAD = GOLDEN SOUL. It's science. Trust me. 🔬",
}
SIDE_DIALOGUES.royal_stew = {
	speaker = "ankomon",
	text = "ROYAL STEW!!! THIS ISN'T JUST FOOD IT'S A STATEMENT 👑🔥",
	tip = "GOLD ORE. IN THE STEW. FOR REGALITY. OBEY THE STEW LORE. 🫘",
}
SIDE_DIALOGUES.seasonal = {
	summer = {
		speaker = "sakuradamon",
		text = "SUMMER SALAD!!! THE SUN'S FAVORITE DISH ☀️🥗",
		hint = "SLAP A ZUNDA BERRY ON YOUR BREAD AND WATCH THE SEASONS ALIGN 🔥🌸",
	},
	winter = {
		speaker = "sakuradamon",
		text = "WINTER'S WARMTH!!! aka WARM STEW aka HOT SOUP OF VICTORY ❄️🔥",
		hint = "GOLD ORE MAKES IT SO NOURISHING YOU'LL FORGET THE COLD (and your problems) 💰",
	},
}

return {
	SPEAKERS = SPEAKERS,
	COMPANION_DIALOGUE = COMPANION_DIALOGUE,
	SIDE_DIALOGUES = SIDE_DIALOGUES,
}

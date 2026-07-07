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
local COMPANION_DIALOGUE = {}
COMPANION_DIALOGUE.zundacat = {
	morning = {
		"meow... morning, " .. player.Name .. "! the sun is up and so are the treats 🐱☀️",
		"i saw a mouse in the kitchen last night. it was CARRYING a pea. we're being watched. 👁️🐭",
	},
	afternoon = {
		"purrrrr... you're cooking up a storm, " .. player.Name .. "! 🐱🔥",
		"the kitchen garden has a bird problem. i'll handle it. by 'handle' i mean stare at it. intensely.",
	},
	evening = {
		"the fireflies are out... and so are the mice... i must stand guard. 🐱🌙",
		"you worked hard... come here and let me knead your lap. it's what i do. 🔄💕",
	},
	night = {
		"psst... " .. player.Name .. "... i saw a fish in the pond today. just saying. 🐟",
		"i've been chasing my tail for 20 minutes. best cardio of my life. 🌀",
	},
	level1_10 = { "you're new here! i can tell by the way you hold the spatula. don't worry, i'll judge you silently. 🐱", "the peas are good. the fish are better. KEEP COOKING." },
	level11_20 = { "you're getting good at this! i've been taking notes... on the counter. with my paws. 🐾", "20% extra drop chance from MEOW? no, from antimon. i just distract the chef." },
	level21_50 = { "you're a LEGENDary chef now, " .. player.Name .. "! i've decided to allow you to pet me. once. 🐱👑", "i've seen 50 levels of cooking and i still can't open the pantry door. not for lack of TRYING. 🚪😤" },
}
COMPANION_DIALOGUE.zundabunny = {
	morning = {
		"GOOD MORNING " .. player.Name .. "!!! THE CARROTS ARE AWAKE AND SO AM I!!! 🐰☀️☀️",
		"i dug a hole in the garden last night. for TREASURE. i found a Zunda Pea. BETTER THAN GOLD. 🫛✨",
		"hop hop HOP!!! let's get cooking!!! 🐰🔥",
	},
	afternoon = {
		"hehehe you're doing GREAT " .. player.Name .. "!!! i can smell the victory from here!!! 🐰✨",
		"the wheat field is calling my name... OR IS IT SNACKS??? it's both. it's always both. 🌾",
	},
	evening = {
		"the sun is setting... time for CARROT HOUR!!! 🥕🌅",
		"i've buried 3 Zunda Peas in the garden 'for later'. 'later' is NOW. WHERE DID I PUT THEM 🤔🕳️",
	},
	night = {
		"the moon is full and i have INFINITE ENERGY!!! LET'S DIG!!! 🐰🌕💥",
		"i was counting sheep but i ran out at 847 and started counting peas. i'm at 3,492. send help. 🫛🫛🫛",
	},
	level1_10 = { "WELCOME NEW FRIEND!!! I'M ZUNDABUNNY!!! I LIKE CARROTS AND HOPPING AND YOU!!! 🐰💕", "the secret to cooking? HOP. just hop around the kitchen a lot. it builds character. 🐰✨" },
	level11_20 = { "YOU LEVELED UP!!! I'M SO PROUD I COULD BURY A CARROT IN YOUR HONOR!!! 🥕🏆", "your timing is getting BETTER!!! soon you'll be able to HOP and COOK at the same time!!! multitasking!!! 🐰🔥" },
	level21_50 = { "MAXIMUM HOP LEVEL ACHIEVED!!! YOU'RE A LEGENDARY BUNNY CHEF!!! 🐰👑✨", "I'VE BEEN SAVING A SPECIAL CARROT FOR THIS MOMENT. IT'S IN MY CHEEK POUCH. REACH IN AND TAKE IT. 🥕😤" },
}
COMPANION_DIALOGUE.tantanmon = {
	morning = {
		"🌶️🔥 GOOD MORNING!!! THE SUN IS SPICY AND SO IS TODAY'S MENU!!!",
		"i've been up since 4am practicing my knife throw. INTO THE CUTTING BOARD. OBVIOUSLY. 🔪💥",
	},
	afternoon = {
		"THE KITCHEN IS HEATING UP AND SO AM I 🌶️🌶️🌶️",
		"i added EXTRA spice to today's special. BY EXTRA I MEAN ALL OF IT. 🔥",
	},
	evening = {
		"the sunset looks like a giant tomato. I WANT TO COOK IT 🌅🍅",
		"you've been cooking all day. i respect that. i've been setting off the smoke detector. also respect. 🚒",
	},
	night = {
		"the stars are out... and so is my SPICY ENERGY. THE KITCHEN NEVER SLEEPS 🌶️🌙",
		"i tried to go to bed but the STOVE KEPT STARING AT ME. IT KNOWS WHAT I DID. 🔥👁️",
	},
	level1_10 = { "NEW CHEF DETECTED!!! I'M TANTANMON!!! I BRING THE HEAT (literally. i'm holding a pepper) 🌶️🔥", "cooking tip: if it's not spicy enough, add more. if it's too spicy, ADD MORE. there is no 'too spicy'. 🌶️💀" },
	level11_20 = { "YOUR SPICE TOLERANCE IS INCREASING!!! I CAN SENSE IT!!! 🌶️👃", "the kitchen is GETTING HOTTER. literally. i may have turned the oven to 500 for 'vibes'. 🥵" },
	level21_50 = { "YOU HAVE ASCENDED TO SPICE LORD STATUS!!! I BOW TO YOUR CULINARY HEAT!!! 🌶️👑🔥", "i've been saving a ghost pepper for 5 years. TODAY IS THE DAY. YOU'RE READY. (i'm not. but YOU are.) 💀🌶️" },
}
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
	expression = "surprised",
	text = "OH MY PEA YOU FOUND ZUNDA PEAS 🫛🫛🫛",
	hint = "THEY'RE SO GREEN AND PERFECT AND I LOVE THEM MORE THAN ANYTHING",
	recipe = "ZUNDA MOCHI TIME BABYYYYY SMASH THOSE PEAS INTO GLORY 🍡🔥",
}
SIDE_DIALOGUES.zunda_mochi = {
	speaker = "zundapal",
	expression = "happy",
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
	expression = "thinking",
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

-- ════════════════════════════════════════════════════════════
-- NEW SIDE DIALOGUES v2 — recipes, foragables, zones, events
-- ════════════════════════════════════════════════════════════

-- New recipe discoveries
SIDE_DIALOGUES.antimon_speed_soup = {
	speaker = "antimon",
	text = "SPEED SOUP!!!!! COOKED IN 3 SECONDS AND IT TASTES LIKE VICTORY ⚡⚡⚡",
	recipe = "4 Zunda Mushrooms + 3 Zunda Leaves = LIQUID NITROUS ENERGY!!! GOBBLE AND VIBRATE 🔥💨",
}
SIDE_DIALOGUES.cardamon_calm_cup = {
	speaker = "cardamon",
	text = "Calm Cup… a moment of peace in a chaotic kitchen… 🧘🌿",
	lore = "The Zunda monks brewed this before every feast. Centering the soul before feeding the world.",
	tip = "3 Pea Flowers + 2 Zunda Leaves + 1 Sweet Pea = serenity in a cup. Sip SLOWLY. 🍵",
}
SIDE_DIALOGUES.seasonal_salad = {
	speaker = "sakuradamon",
	text = "SEASONAL SALAD!!! THE GARDEN'S PRIDE IN A BOWL 🥗🌸",
	lore = "In spring it's peas, in summer it's berries, in autumn it's roots — but ALWAYS perfection.",
	tip = "3 Zunda Berries + 2 Zunda Leaves = THE TASTE OF SUNSHINE. LITERALLY. ☀️",
}
SIDE_DIALOGUES.sakuradamon_blossom_bites = {
	speaker = "sakuradamon",
	text = "BLOSSOM BITES!!! THEY'RE LIKE SPRING EXPLODING IN YOUR MOUTH 🌸💥🌸",
	hint = "4 Pea Flowers + 3 Zunda Berries. The petals are not optional. They're the MAIN CHARACTER.",
}
SIDE_DIALOGUES.warm_winter_stew = {
	speaker = "elder",
	expression = "thinking",
	text = "Warm Winter Stew… I remember the first snow I ate this under… 🏮❄️",
	lore = "The roots remember the cold. The mushrooms remember the dark. Together they REMEMBER HOW TO WARM YOU.",
	tip = "Zunda Root ×3 + Zunda Mushroom ×2 + Gold ×1 = THE HUG YOU DIDN'T KNOW YOU NEEDED.",
}
SIDE_DIALOGUES.ankomon_protein_punch = {
	speaker = "ankomon",
	text = "PROTEIN PUNCH!!!! 🫘🥊 THIS ISN'T COOKING THIS IS A TRAINING MONTAGE",
	tip = "5 EDAMAME PODS + 3 ZUNDA PEAS + 1 GOLD = BECOME UNSTOPPABLE. OBEY THE PUNCH. 💪",
}
SIDE_DIALOGUES.golden_harvest_platter = {
	speaker = "zundamon",
	expression = "happy",
	text = "THE GOLDEN HARVEST PLATTER!!! IT'S LIKE A FEAST FOR ROYALTY BUT BETTER BECAUSE IT'S FOR YOU 🏆✨",
	recipe = "5 Apples + 8 Wheat + 2 Gold + 3 Sweet Peas. Each bite is a CELEBRATION OF ABUNDANCE.",
}

-- Foragable discoveries
SIDE_DIALOGUES.zunda_flower = {
	speaker = "sakuradamon",
	text = "A ZUNDA FLOWER!!! These bloom where a chef once cried tears of joy over a perfect dish 🌸💧",
	lore = "The petals taste like distant memories and slightly like peas. VERY rare. VERY precious.",
}
SIDE_DIALOGUES.zunda_berry = {
	speaker = "zundapal",
	text = "ZUNDA BERRY ALERT!!! THEY BLUSH WHEN YOU APPROACH!!! 🫐😳",
	tip = "Squeeze gently. If it squeaks, it's ripe. If it screams, you squeezed too hard. (just kidding... unless??)",
}
SIDE_DIALOGUES.zunda_mushroom = {
	speaker = "antimon",
	text = "ZUNDA MUSHROOM!!! GROWS IN THE DAMP CAVES BEHIND THE WATERFALL 🍄⚡",
	hint = "THEY PULSE WITH A FAINT GLOW AND TASTE LIKE THE EARTH'S SECRET HANDshake.",
}
SIDE_DIALOGUES.zunda_root = {
	speaker = "elder",
	text = "Zunda Root... pulled from the earth with respect and a firm grip... 🌱",
	lore = "The roots run deep — literally. Some say they connect every Zunda plant in the village underground.",
	tip = "ROAST IT. TRUST ME. RAW ZUNDA ROOT WILL HUMBLE YOU. 🔥",
}

-- Zone discovery dialogues
SIDE_DIALOGUES.garden_alcove = {
	speaker = "narrator",
	text = "[ You push through the overgrown trellis and find a hidden garden alcove... ] 🌿",
	lore = "This is where the FIRST Zunda Peas were cultivated. The soil still hums faintly. Something was planted here long before the village existed.",
}
SIDE_DIALOGUES.old_well = {
	speaker = "narrator",
	text = "[ The Old Well groans. A single Zunda Pea floats on the water's surface far below... ] 🪣🌀",
	lore = "Legend says the well connects to the KITCHEN BELOW — a mirror kitchen where the ingredients are always perfect and the dishes cook themselves.",
}
SIDE_DIALOGUES.waterfall_cave = {
	speaker = "narrator",
	text = "[ Behind the roaring waterfall, a cave reveals itself. Aged stew pots line the walls. ] 🌊🕯️",
	lore = "Zunda monks once aged their finest creations here. The cool air + constant humidity = PERFECT AGING CONDITIONS. A vat of 100-year-old stew might still exist...",
}

-- Companion meet events
SIDE_DIALOGUES.meet_ankomon = {
	speaker = "ankomon",
	expression = "thinking",
	text = "🫘🥊 ANKOMON REPORTING FOR DUTY!!! YOUR KITCHEN JUST GOT 15% MORE REGAL!!!",
	lore = "I'm a red bean spirit with a GOLDEN TOUCH. Every gold coin you earn? I'm flexing in the background. SWEETEN EVERY PAYDAY.",
}
SIDE_DIALOGUES.meet_cardamon = {
	speaker = "cardamon",
	text = "Cardamon has arrived… the herbs whisper your name… 🌿🍋",
	lore = "I expand your perfect cooking window by 30%. More time. More precision. MORE GLORY. Breathe in. Cook well.",
}
SIDE_DIALOGUES.meet_antimon = {
	speaker = "antimon",
	text = "ANTIMON ENTERED THE CHAT AT MAXIMUM SPEED ⚡💨",
	lore = "20% extra drop chance on everything you gather. I'll whisper where the good ingredients hide. WHISPERS AT THE SPEED OF SOUND.",
}
SIDE_DIALOGUES.meet_sakuradamon = {
	speaker = "sakuradamon",
	text = "🌸💥 SAKURADAMON HAS BLOOMED INTO EXISTENCE!!! REJOICE!!!",
	lore = "+25% XP from EVERYTHING. Crafting. Serving. Existing near a stove. My petals carry the knowledge of a thousand Zunda chefs before us.",
}

-- Quest milestone dialogues
SIDE_DIALOGUES.quest_chain_complete = {
	speaker = "zundamon",
	expression = "happy",
	text = "QUEST CHAIN COMPLETE!!!!!!!! YOU'RE ON A ROLL THAT WOULD MAKE A ZUNDA PEA JEALOUS 🏆🔥✨",
	hint = "Every completed chain unlocks NEW possibilities. Check the quest board for the NEXT chapter!!!",
}

return {
	SPEAKERS = SPEAKERS,
	COMPANION_DIALOGUE = COMPANION_DIALOGUE,
	SIDE_DIALOGUES = SIDE_DIALOGUES,
}

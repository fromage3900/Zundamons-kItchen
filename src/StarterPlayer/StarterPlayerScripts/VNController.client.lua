-- [[LocalScript] VNController (ref: RBX965534933CC64EAD957097D7586E4B35)]]
-- ══════════════════════════════════════════════════════════════
-- ZundaVN Unified Controller — drives ALL visual-novel dialogue
-- Speakers: companion, quest system, zone entry, NPC, welcome
-- API exposed via _G.ZundaVN = { show, hide, isOpen }
-- ══════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local VNDialogueData = require(RS.ConfigurationFiles:WaitForChild("VNDialogueData"))
local SPEAKERS = VNDialogueData.SPEAKERS
local COMPANION_DIALOGUE = VNDialogueData.COMPANION_DIALOGUE
local SIDE_DIALOGUES = VNDialogueData.SIDE_DIALOGUES
local VNDialoguePortraits = require(RS.Shared.Config.VNDialoguePortraits)

local function RGB(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZundaVNGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 40
screenGui.Parent = playerGui

local gui = screenGui

local UIHelper = require(RS.Shared.Modules.UIHelper)

-- Expose side dialogues for other scripts to trigger
_G.ZundaSideDialogues = SIDE_DIALOGUES

-- ── Build UI (Animal Crossing inspired) ─────────────────────────
local PANEL_W = 780
local PANEL_H = 185
local PORT_W = 110

local C_cream = Color3.fromRGB(255, 248, 235)
local C_border = Color3.fromRGB(180, 150, 110)
local C_text = Color3.fromRGB(80, 55, 35)
local C_textLight = Color3.fromRGB(140, 110, 80)
local C_close = Color3.fromRGB(200, 140, 120)

-- Very subtle dimmer
local dimmer = Instance.new("Frame", gui)
dimmer.Name = "Dimmer"
dimmer.Size = UDim2.new(1, 0, 1, 0)
dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dimmer.BackgroundTransparency = 1
dimmer.BorderSizePixel = 0
dimmer.ZIndex = 9
dimmer.Visible = false

-- Main panel
local panel = Instance.new("Frame", gui)
panel.Name = "VNPanel"
panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
panel.AnchorPoint = Vector2.new(0.5, 1)
panel.Position = UDim2.new(0.5, 0, 1, 20)
panel.BackgroundColor3 = C_cream
panel.BorderSizePixel = 0
panel.ZIndex = 10
panel.Active = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 24)
local pStroke = Instance.new("UIStroke", panel)
pStroke.Color = C_border
pStroke.Thickness = 3

-- Full-body background art (Persona-style, right side)
local fullArt = Instance.new("ImageLabel", panel)
fullArt.Name = "FullArt"
fullArt.Size = UDim2.new(0, 200, 1, -20)
fullArt.Position = UDim2.new(1, -200, 0, 10)
fullArt.BackgroundTransparency = 1
fullArt.Image = ""
fullArt.ImageTransparency = 0.7
fullArt.ScaleType = Enum.ScaleType.Fit
fullArt.ZIndex = 10

-- Portrait box (face close-up, left side)
local portrait = Instance.new("Frame", panel)
portrait.Name = "Portrait"
portrait.Size = UDim2.new(0, PORT_W, 1, 0)
portrait.BackgroundColor3 = Color3.fromRGB(180, 220, 170)
portrait.BorderSizePixel = 0
portrait.ZIndex = 11
Instance.new("UICorner", portrait).CornerRadius = UDim.new(0, 18)

-- Portrait face image (replaces emoji TextLabel)
local pFace = Instance.new("ImageLabel", portrait)
pFace.Name = "Face"
pFace.Size = UDim2.new(0.9, 0, 0.9, 0)
pFace.AnchorPoint = Vector2.new(0.5, 0.5)
pFace.Position = UDim2.new(0.5, 0, 0.5, 0)
pFace.BackgroundTransparency = 1
pFace.Image = ""
pFace.ScaleType = Enum.ScaleType.Fit
pFace.ZIndex = 13

-- Text area (squeezed between portrait and full art)
local textArea = Instance.new("Frame", panel)
textArea.Name = "TextArea"
textArea.Size = UDim2.new(1, -(PORT_W + 220), 1, -16)
textArea.Position = UDim2.new(0, PORT_W + 12, 0, 8)
textArea.BackgroundTransparency = 1
textArea.ZIndex = 11

-- Speaker name banner (tab style)
local nameBanner = Instance.new("Frame", textArea)
nameBanner.Name = "NameBanner"
nameBanner.Size = UDim2.new(0, 160, 0, 26)
nameBanner.Position = UDim2.new(0, 0, 0, 0)
nameBanner.BackgroundColor3 = Color3.fromRGB(160, 210, 150)
nameBanner.BorderSizePixel = 0
nameBanner.ZIndex = 12
Instance.new("UICorner", nameBanner).CornerRadius = UDim.new(0, 8)
local nameLabel = Instance.new("TextLabel", nameBanner)
nameLabel.Size = UDim2.new(1, -12, 1, 0)
nameLabel.Position = UDim2.new(0, 6, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Zundamon"
nameLabel.Font = Enum.Font.FredokaOne
nameLabel.TextSize = 15
nameLabel.TextColor3 = Color3.fromRGB(60, 40, 20)
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.ZIndex = 13

-- Main dialogue text
local dlgText = Instance.new("TextLabel", textArea)
dlgText.Name = "DialogueText"
dlgText.Size = UDim2.new(1, -8, 0, 100)
dlgText.Position = UDim2.new(0, 4, 0, 30)
dlgText.BackgroundTransparency = 1
dlgText.Text = ""
dlgText.Font = Enum.Font.GothamMedium
dlgText.TextSize = 16
dlgText.TextColor3 = C_text
dlgText.TextXAlignment = Enum.TextXAlignment.Left
dlgText.TextYAlignment = Enum.TextYAlignment.Top
dlgText.TextWrapped = true
dlgText.ZIndex = 12
dlgText.LineHeight = 1.15

-- Advance indicator
local advArrow = Instance.new("TextLabel", textArea)
advArrow.Name = "AdvArrow"
advArrow.Size = UDim2.new(0, 20, 0, 18)
advArrow.AnchorPoint = Vector2.new(1, 1)
advArrow.Position = UDim2.new(1, -2, 1, -2)
advArrow.BackgroundTransparency = 1
advArrow.Text = "▼"
advArrow.Font = Enum.Font.GothamBold
advArrow.TextSize = 12
advArrow.TextColor3 = C_textLight
advArrow.ZIndex = 12
advArrow.Visible = false

-- Close button
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.AnchorPoint = Vector2.new(1, 0)
closeBtn.Position = UDim2.new(1, -4, 0, -4)
closeBtn.BackgroundColor3 = C_close
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.ZIndex = 100
closeBtn.Active = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.5, 0)

-- Invisible advance button
local advBtn = Instance.new("TextButton", panel)
advBtn.Name = "AdvBtn"
advBtn.Size = UDim2.new(1, -(PORT_W + 50), 1, -42)
advBtn.Position = UDim2.new(0, PORT_W + 4, 0, 36)
advBtn.BackgroundTransparency = 1
advBtn.Text = ""
advBtn.BorderSizePixel = 0
advBtn.ZIndex = 12

-- ── State ─────────────────────────────────────────────────────
local isOpen = false
local typing = false
local typeThread = nil
local seqQueue = {} -- pending sequences to play after current
local seqLines = {}
local seqIdx = 0
local completeCb = nil

local SHOW_POS = UDim2.new(0.5, 0, 1, -(PANEL_H + 18))
local HIDE_POS = UDim2.new(0.5, 0, 1, PANEL_H + 80) -- push well below screen

-- ── BRANCHING CHOICE UI (built once, reused per choice prompt) ───────────
local choiceFrame = Instance.new("Frame", panel)
choiceFrame.Name = "Choices"
choiceFrame.Size = UDim2.new(1, -(PORT_W + 50), 0, 0)
choiceFrame.Position = UDim2.new(0, PORT_W + 8, 1, -6)
choiceFrame.AnchorPoint = Vector2.new(0, 1)
choiceFrame.BackgroundTransparency = 1
choiceFrame.ZIndex = 15
choiceFrame.Visible = false
local choiceLayout = Instance.new("UIListLayout", choiceFrame)
choiceLayout.FillDirection = Enum.FillDirection.Vertical
choiceLayout.Padding = UDim.new(0, 6)
choiceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

local function setSpeaker(key, expression)
	local sp = SPEAKERS[key] or SPEAKERS.zundamon
	portrait.BackgroundColor3 = sp.portrait
	nameBanner.BackgroundColor3 = sp.accent
	pStroke.Color = C_border
	if sp.name == "" then
		nameBanner.Visible = false
	else
		nameBanner.Visible = true
		nameLabel.Text = sp.name
	end
	dlgText.TextColor3 = C_text
	-- Load persona-style portraits
	local portraitData = VNDialoguePortraits.getPortrait(key, expression or "default")
	if portraitData then
		if portraitData.face and portraitData.face ~= "" then
			pFace.Image = portraitData.face
			pFace.Visible = true
		else
			pFace.Visible = false
		end
		if portraitData.full and portraitData.full ~= "" then
			fullArt.Image = portraitData.full
			fullArt.Visible = true
		else
			fullArt.Visible = false
		end
		if portraitData.accent then
			nameBanner.BackgroundColor3 = portraitData.accent
		end
	end
end

local function openPanel()
	isOpen = true
	panel.Visible = true
	dimmer.Visible = true
	TweenS:Create(dimmer, TweenInfo.new(0.25), { BackgroundTransparency = 0.85 }):Play()
	panel.Position = HIDE_POS
	TweenS:Create(panel, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = SHOW_POS })
		:Play()
end

-- closePanel(force): when called from a user dismiss action (close X or Escape),
--   pass force=true to ALSO drop any queued sequences so the panel really stays
--   closed. Otherwise the next queued sequence will play after the close tween.
local function closePanel(force)
	isOpen = false
	typing = false
	if typeThread then
		pcall(task.cancel, typeThread)
		typeThread = nil
	end
	advArrow.Visible = false
	for _, c in ipairs(choiceFrame:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	choiceFrame.Visible = false
	if force then
		seqQueue = {}
	end
	TweenS:Create(dimmer, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
	TweenS:Create(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = HIDE_POS })
		:Play()
	task.delay(0.25, function()
		if isOpen then
			return
		end
		dimmer.Visible = false
		panel.Visible = false
		dlgText.Text = ""
		if completeCb then
			pcall(completeCb)
			completeCb = nil
		end
		if #seqQueue > 0 then
			local nxt = table.remove(seqQueue, 1)
			_G.ZundaVN.show(nxt.speaker, nxt.lines, nxt.onComplete)
		end
	end)
end

-- Typewriter effect
local function typeWrite(text)
	typing = true
	advArrow.Visible = false
	dlgText.Text = ""
	for i = 1, #text do
		if not typing then
			break
		end
		dlgText.Text = text:sub(1, i)
		local ch = text:sub(i, i)
		local delay = ch == "," and 0.07 or (ch == "." or ch == "!" or ch == "?") and 0.1 or 0.028
		task.wait(delay)
	end
	dlgText.Text = text
	typing = false
	advArrow.Visible = true
	-- Blink arrow
	task.spawn(function()
		while advArrow.Visible do
			TweenS:Create(advArrow, TweenInfo.new(0.45), { TextTransparency = 0.85 }):Play()
			task.wait(0.45)
			if not advArrow.Visible then
				break
			end
			TweenS:Create(advArrow, TweenInfo.new(0.45), { TextTransparency = 0 }):Play()
			task.wait(0.45)
		end
	end)
end

local function skipTyping()
	if typing and seqLines[seqIdx] then
		typing = false
		if typeThread then
			task.cancel(typeThread)
			typeThread = nil
		end
		local entry = seqLines[seqIdx]
		dlgText.Text = type(entry) == "string" and entry or (entry.text or "")
		if type(entry) == "table" and entry.expression then
			local sk = entry.speaker or seqLines._defaultSpeaker or "zundamon"
			setSpeaker(sk, entry.expression)
		end
		advArrow.Visible = true
	end
end

local function showLine(idx)
	if idx > #seqLines then
		closePanel()
		return
	end
	local entry = seqLines[idx]
	local speakerKey, text, expression
	if type(entry) == "string" then
		text = entry
		speakerKey = seqLines._defaultSpeaker or "zundamon"
		expression = seqLines._defaultExpression
	else
		speakerKey = entry.speaker or "zundamon"
		text = entry.text or ""
		expression = entry.expression or seqLines._defaultExpression
	end
	setSpeaker(speakerKey, expression)
	typeThread = task.spawn(function()
		typeWrite(text)
	end)
end

local function advanceLine()
	if typing then
		skipTyping()
	else
		seqIdx = seqIdx + 1
		showLine(seqIdx)
	end
end

-- ── Public API ────────────────────────────────────────────────
-- show(speakerOrKey, lines, onComplete?)
-- lines can be:
--   {"text", "text", ...}  (all use speakerOrKey)
--   {{speaker="key",text="..."}, ...}  (multi-speaker)
--
-- ── BRANCHING CHOICES helpers ───────────────────────────────────────
local clearChoices, showChoicesUI, playNode -- forward decls

clearChoices = function()
	for _, c in ipairs(choiceFrame:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	choiceFrame.Visible = false
	choiceFrame.Size = UDim2.new(1, -(PORT_W + 50), 0, 0)
end

showChoicesUI = function(choices, onPick)
	if type(choices) ~= "table" or #choices == 0 then
		return
	end
	clearChoices()
	advArrow.Visible = false
	local h = 0
	for i, c in ipairs(choices) do
		local btn = Instance.new("TextButton", choiceFrame)
		btn.Name = "Choice" .. i
		btn.Size = UDim2.new(1, -6, 0, 30)
		btn.BackgroundColor3 = Color3.fromRGB(245, 235, 215)
		btn.BorderSizePixel = 0
		btn.Text = "  \u{276F} " .. (c.text or "...")
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.TextColor3 = C_text
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.ZIndex = 16
		btn.AutoButtonColor = false
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
		local stk = Instance.new("UIStroke", btn)
		stk.Color = C_border
		stk.Thickness = 1.5
		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(235, 210, 180)
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(245, 235, 215)
		end)
		btn.MouseButton1Click:Connect(function()
			clearChoices()
			if onPick then
				pcall(onPick, i, c)
			end
		end)
		h = h + 34
	end
	choiceFrame.Size = UDim2.new(1, -(PORT_W + 50), 0, h)
	choiceFrame.Visible = true
end

-- Walk a dialogue node:
--   node = { speaker="key", lines={...}, prompt="?", choices={{text,next},..} }
playNode = function(node)
	if type(node) == "function" then
		node = node()
	end
	if type(node) ~= "table" then
		return
	end
	local speakerKey = node.speaker or "zundapal"

	local function presentChoices()
		if not node.choices then
			return
		end
		if not isOpen then
			openPanel()
		end
		setSpeaker(speakerKey)
		if node.prompt then
			-- Type the prompt as a final line, then show choices
			seqLines = { { speaker = speakerKey, text = node.prompt } }
			seqIdx = 1
			showLine(1)
			task.spawn(function()
				while typing do
					task.wait(0.05)
				end
				showChoicesUI(node.choices, function(_, choice)
					if choice.next then
						playNode(choice.next)
					end
				end)
			end)
		else
			showChoicesUI(node.choices, function(_, choice)
				if choice.next then
					playNode(choice.next)
				end
			end)
		end
	end

	if type(node.lines) == "table" and #node.lines > 0 then
		_G.ZundaVN.show(speakerKey, node.lines, function()
			presentChoices()
		end)
	else
		presentChoices()
	end
end

-- ── Public API ───────────────────────────────────────────────
_G.ZundaVN = {
	show = function(speakerKey, lines, onComplete)
		if type(lines) ~= "table" or #lines == 0 then
			return
		end
		if isOpen then
			table.insert(seqQueue, { speaker = speakerKey, lines = lines, onComplete = onComplete })
			return
		end
		seqLines = lines
		seqLines._defaultSpeaker = speakerKey
		seqIdx = 1
		completeCb = onComplete
		openPanel()
		setSpeaker(speakerKey)
		showLine(1)
	end,
	showBranching = function(rootNode)
		playNode(rootNode)
	end,
	hide = function()
		if isOpen then
			closePanel(true)
		end
	end,
	isOpen = function()
		return isOpen
	end,
}

-- ── Input handlers ────────────────────────────────────────────
advBtn.MouseButton1Click:Connect(function()
	advanceLine()
	local pos = advBtn.AbsolutePosition
	local sz = advBtn.AbsoluteSize
	UIHelper.spawnSparkles(panel, pos.X + sz.X / 2, pos.Y + sz.Y / 2, Color3.fromRGB(180, 150, 110), 3)
end)
closeBtn.MouseButton1Click:Connect(function()
	if isOpen then
		closePanel(true)
	end
	local pos = closeBtn.AbsolutePosition
	UIHelper.spawnSparkles(panel, pos.X + 15, pos.Y + 15, Color3.fromRGB(200, 140, 120), 4)
end)
UIS.InputBegan:Connect(function(inp, gpe)
	if gpe then
		return
	end
	if not isOpen then
		return
	end
	if inp.KeyCode == Enum.KeyCode.Space or inp.KeyCode == Enum.KeyCode.Return or inp.KeyCode == Enum.KeyCode.E then
		advanceLine()
	elseif inp.KeyCode == Enum.KeyCode.Escape then
		closePanel(true)
	end
end)

-- ── Player Level Tracking ────────────────────────────────────
local playerLevel = 1
local rewardEvents = RS:WaitForChild("RewardEvents")
local chefLevelUpdate = rewardEvents:FindFirstChild("ChefLevelUpdate")
if chefLevelUpdate then
	chefLevelUpdate.OnClientEvent:Connect(function(level)
		playerLevel = level
	end)
end

-- ── Side Dialogue Auto-Trigger ───────────────────────────────
-- Exposed as _G.ZundaTriggerSideDialogue(key) so any script can fire it
_G.ZundaTriggerSideDialogue = function(key)
	local sd = SIDE_DIALOGUES[key]
	if not sd then return end
	local speaker = sd.speaker or "zundamon"
	local lines = {}
	if sd.text then table.insert(lines, { speaker = speaker, text = sd.text }) end
	if sd.lore then table.insert(lines, { speaker = speaker, text = sd.lore }) end
	if sd.hint then table.insert(lines, { speaker = speaker, text = sd.hint }) end
	if sd.tip then table.insert(lines, { speaker = speaker, text = sd.tip }) end
	if sd.recipe then table.insert(lines, { speaker = speaker, text = sd.recipe }) end
	if #lines > 0 then
		_G.ZundaVN.show(speaker, lines)
	end
end

-- Listen for remote side dialogue triggers
local sideDlgRE = RE:FindFirstChild("TriggerSideDialogue")
if sideDlgRE then
	sideDlgRE.OnClientEvent:Connect(function(key)
		_G.ZundaTriggerSideDialogue(key)
	end)
end

-- ── Event listeners ───────────────────────────────────────────
local RE = RS:WaitForChild("RemoteEvents")

-- ── COMPANION DIALOGUE TREE BUILDER ───────────────────────────
-- Builds a branching dialogue tree unique to each companion type
local function buildCompanionTree(compType)
	local hour = tonumber(Lighting:GetAttribute("CurrentHour")) or 12
	local slot = hour >= 5 and hour < 12 and "morning"
		or hour >= 12 and hour < 18 and "afternoon"
		or hour >= 18 and hour < 21 and "evening"
		or "night"

	-- Pull the companion's dialogue data (fallback to zundapal)
	local compData = COMPANION_DIALOGUE[compType] or COMPANION_DIALOGUE.zundapal
	local greeting = compData[slot] or {}
	local levelGreeting = {}
	if playerLevel >= 21 and compData.level21_50 then
		levelGreeting = compData.level21_50
	elseif playerLevel >= 11 and compData.level11_20 then
		levelGreeting = compData.level11_20
	elseif compData.level1_10 then
		levelGreeting = compData.level1_10
	end

	-- Branching leaf nodes (shared across companions with unique flavor)
	local leafEnd = {
		speaker = compType,
		lines = { { speaker = compType, text = "Call me anytime, chef! 🔥" } },
	}

	-- ── Cook tips sub-tree ────────────────────────────────────
	local function buildCookingTips()
		if compType == "ankomon" then
			return {
				speaker = "ankomon",
				lines = {
					{ speaker = "ankomon", text = "🫘🥊 COOKING TIP: FOCUS. DISCIPLINE. BEANS." },
					{ speaker = "ankomon", text = "Watch the TIMING BAR like it's your RIVAL IN THE RING. When it glows — STRIKE." },
					{ speaker = "ankomon", text = "PERFECT COOKS BUILD MUSCLE!!! (and gold. and glory.) 💪🔥" },
				},
				prompt = "MORE WISDOM???",
				choices = {
					{ text = "Best protein dish?", next = { speaker = "ankomon", lines = { { speaker = "ankomon", text = "ANKOMON'S PROTEIN PUNCH!!! 5 Edamame Pods + 3 Zunda Peas + 1 Gold. It's not a meal, it's a STATEMENT." } } } },
					{ text = "How to train harder?", next = { speaker = "ankomon", lines = { { speaker = "ankomon", text = "COOK. SERVE. REPEAT. Every dish is a rep. Every perfect cook is a PERSONAL BEST. THE KITCHEN IS YOUR GYM. 🏋️🫘" } } } },
					{ text = "That's enough flexing", next = leafEnd },
				},
			}
		elseif compType == "cardamon" then
			return {
				speaker = "cardamon",
				lines = {
					{ speaker = "cardamon", text = "🌿🍋 A cooking tip... breathe first. Then cook." },
					{ speaker = "cardamon", text = "The timing bar is not a threat — it's a MEDITATION TOOL. When you're calm, your window WIDENS." },
					{ speaker = "cardamon", text = "I expand your perfect window by 30%. USE IT WISELY. Rushing disrespects the ingredients. 🧘" },
				},
				prompt = "Deeper wisdom?",
				choices = {
					{ text = "What's the most calming dish?", next = { speaker = "cardamon", lines = { { speaker = "cardamon", text = "Cardamon's Calm Cup. 3 Pea Flowers + 2 Zunda Leaves + 1 Sweet Pea. Sip. Exist. TRANSCEND. 🍵🌿" } } } },
					{ text = "How do I find peace in the chaos?", next = { speaker = "cardamon", lines = { { speaker = "cardamon", text = "The chaos IS the peace. Every sizzle. Every chop. Every perfect ding of the timer. Be present. Cook present. 🔥🧘" } } } },
					{ text = "I'm peaceful enough, thanks", next = leafEnd },
				},
			}
		elseif compType == "antimon" then
			return {
				speaker = "antimon",
				lines = {
					{ speaker = "antimon", text = "⚡💨 SPEED TIP: GO FASTER!!! THE BAR MOVES, YOU MOVE WITH IT!!!" },
					{ speaker = "antimon", text = "Don't WAIT for the perfect moment — CREATE IT!!! TIMING IS ILLUSION, SPEED IS TRUTH!!!" },
					{ speaker = "antimon", text = "Antimon's Speed Soup cooks in 3 SECONDS. THREE. That's not cooking, that's MAGIC AT MACH SPEED!!!" },
				},
				prompt = "FASTER???",
				choices = {
					{ text = "What's your favorite fast dish?", next = { speaker = "antimon", lines = { { speaker = "antimon", text = "ANTIMON'S SPEED SOUP!!! 4 Zunda Mushrooms + 3 Zunda Leaves. IN. OUT. DONE. TASTES LIKE LIGHTNING. ⚡🍄" } } } },
					{ text = "How do I gather faster?", next = { speaker = "antimon", lines = { { speaker = "antimon", text = "MY BUFF GIVES YOU +20% EXTRA DROPS!!! I'll WHISPER where the good stuff hides. WHISPERS AT THE SPEED OF SOUND. LISTEN CAREFULLY. 🏃‍♂️💨" } } } },
					{ text = "I need to rest...", next = leafEnd },
				},
			}
		elseif compType == "sakuradamon" then
			return {
				speaker = "sakuradamon",
				lines = {
					{ speaker = "sakuradamon", text = "🌸💥 COOKING TIP FROM THE BLOSSOM REALM!!!" },
					{ speaker = "sakuradamon", text = "Every dish is a FLOWER. Nurture it. Watch it BLOOM in the pan. Don't rush the petals!" },
					{ speaker = "sakuradamon", text = "PERFECT COOKS are like cherry blossoms — rare, beautiful, and worth every moment of patience. 🌸✨" },
				},
				prompt = "🌸 Petal more wisdom?",
				choices = {
					{ text = "Tell me about Blossom Bites!", next = { speaker = "sakuradamon", lines = { { speaker = "sakuradamon", text = "SAKURADAMON'S BLOSSOM BITES!!! 4 Pea Flowers + 3 Zunda Berries. Each one BLOOMS on your tongue!!! 🌸💥" } } } },
					{ text = "How do I find rare ingredients?", next = { speaker = "sakuradamon", lines = { { speaker = "sakuradamon", text = "The rare ones HIDE. But with +25% XP from my blessing, you'll LEVEL UP faster and unlock SECRET GATHERING SPOTS. Follow the glowing petals! 🔍🌸" } } } },
					{ text = "The petals are calling me away", next = leafEnd },
				},
			}
		end
		-- Default (zundapal)
		return {
			speaker = compType,
			lines = {
				{ speaker = compType, text = "COOKING TIP TIME!!!! EVERYBODY PANIC 👨‍🍳✨" },
				{ speaker = compType, text = "Watch the bar. THE GLOWY BAR. When it hits PEAK GREEN…" },
				{ speaker = compType, text = "…THAT'S A PERFECT COOK!!! BONUS GOLD!!! FREE EXTRA DISH!!! ABSOLUTE CINEMA!!! ✨🎉" },
			},
			prompt = "WANT MORE????????",
			choices = {
				{ text = "What about Zunda Mochi??", next = { speaker = compType, lines = { { speaker = compType, text = "ZUNDA MOCHI!!! 5 ZUNDA PEAS + 8 WHEAT = PEA HEAVEN 🍡🍡" }, { speaker = compType, text = "The peas are in the Kitchen Garden!!! THEY SPARKLE PINK!!! STARE AT THEM UNTIL THEY SUBMIT 💕💕" } } } },
				{ text = "And the LEGENDARY Zunda Paradise???", next = { speaker = compType, lines = { { speaker = compType, text = "OOOOOH YOU'RE AMBITIOUS I LIKE IT ✨✨" }, { speaker = compType, text = "ZUNDA PARADISE: 15 ZUNDA PEAS + 10 EDAMAME + 5 SWEET PEAS + 3 PEA FLOWERS. GO BIG OR GO HOME." }, { speaker = compType, text = "ONLY TRUE PEA MASTERS CAN PULL IT OFF!!! ARE YOU THE ONE??? 💛💛" } } } },
				{ text = "I'm full. Thanks.", next = leafEnd },
			},
		}
	end

	-- ── Quest hints sub-tree ──────────────────────────────────
	local function buildQuestHints()
		if compType == "ankomon" then
			return {
				speaker = "ankomon",
				lines = { { speaker = "ankomon", text = "QUESTS ARE TRAINING. COMPLETE THEM. GROW STRONGER. 🫘💪" } },
				prompt = "What quest knowledge do you seek?",
				choices = {
					{ text = "Where to find Edamame Pods?", next = { speaker = "ankomon", lines = { { speaker = "ankomon", text = "THE EDAMAME THICKET!!! Past the wheat fields, under the giant leaves. They hang like GREEN LANTERNS waiting for a warrior to claim them. 🌿👊" } } } },
					{ text = "Best gold-making quest?", next = { speaker = "ankomon", lines = { { speaker = "ankomon", text = "GOLD RUSH CHAIN!!! Start with Pocket Change (250g) and work up to Gold Rush Baron (10,000g). EACH STEP FORTIFIES THE BEAN WITHIN. 🫘💰" } } } },
					{ text = "I'll train on my own", next = leafEnd },
				},
			}
		elseif compType == "cardamon" then
			return {
				speaker = "cardamon",
				lines = { { speaker = "cardamon", text = "Quests are a journey... not a sprint. Walk each one mindfully. 🌿" } },
				prompt = "Which path shall we explore?",
				choices = {
					{ text = "Which quest is most peaceful?", next = { speaker = "cardamon", lines = { { speaker = "cardamon", text = "Cardamon's Path of Patience. Cook 5 GREAT dishes. Not good. GREAT. Each one a meditation. Each one a MASTERPIECE. 🧘🍳" } } } },
					{ text = "How do I unlock seasonal dishes?", next = { speaker = "cardamon", lines = { { speaker = "cardamon", text = "The Four Seasons Chef chain. Cook Seasonal Salad AND Warm Winter Stew. The seasons demand balance. 🌸❄️" } } } },
					{ text = "I'll meditate on it", next = leafEnd },
				},
			}
		elseif compType == "antimon" then
			return {
				speaker = "antimon",
				lines = { { speaker = "antimon", text = "QUESTS!!! COMPLETE THEM AT MAXIMUM VELOCITY!!! ⚡" } },
				prompt = "WHICH QUEST DO YOU NEED SPEED-BLITZED???",
				choices = {
					{ text = "Fastest quest to complete?", next = { speaker = "antimon", lines = { { speaker = "antimon", text = "ANTIMON'S SPEED TRIAL!!! Cook 3 dishes under 4 seconds EACH. That's not a quest, that's a SPRINT. GO GO GO!!! ⚡🏃‍♂️💨" } } } },
					{ text = "Best quest for rare loot?", next = { speaker = "antimon", lines = { { speaker = "antimon", text = "THE GREAT ZUNDA HUNT!!! 4 quests to gather EVERY Zunda ingredient. Rare drops EVERYWHERE. I CAN ALREADY SENSE THE LOOT. 👁️⚡" } } } },
					{ text = "Too slow for me (lol)", next = leafEnd },
				},
			}
		elseif compType == "sakuradamon" then
			return {
				speaker = "sakuradamon",
				lines = { { speaker = "sakuradamon", text = "🌸 The quests bloom before you like a garden of potential... which flower shall we pick?" } },
				prompt = "🌸✨",
				choices = {
					{ text = "Tell me about exploration quests!", next = { speaker = "sakuradamon", lines = { { speaker = "sakuradamon", text = "THE MAP IS A FLOWER YET TO BLOOM!!! Visit every corner — the Garden Alcove, the Old Well, the Waterfall Cave. 10 locations. 10 SECRETS. 🗺️🌸" } } } },
					{ text = "Which quest suits a blossom spirit?", next = { speaker = "sakuradamon", lines = { { speaker = "sakuradamon", text = "Sakuradamon's Blossom Festival!!! 3 Blossom Bites cooked with LOVE AND PETALS. Each one a celebration of BEAUTIFUL IMPERMANENCE. 🌸💥" } } } },
					{ text = "The wind carries me away", next = leafEnd },
				},
			}
		end
		-- Default (zundapal)
		return {
			speaker = compType,
			lines = { { speaker = compType, text = "QUEST BOARD!!! MY BELOVED!!! 📜📜" } },
			prompt = "WHAT DO YOU WANT TO KNOW???? (SCREAM IT)",
			choices = {
				{ text = "WHERE ARE THE ZUNDA PEAS", next = { speaker = compType, lines = { { speaker = compType, text = "KITCHEN GARDEN!!! BEHIND THE BAKERY!!! RUN DON'T WALK 🏃‍♂️" }, { speaker = compType, text = "THEY SPARKLE PINK YOU LITERALLY CANNOT MISS THEM 💕💕" } } } },
				{ text = "HOW DO I SERVE GUESTS", next = { speaker = compType, lines = { { speaker = compType, text = "COOK THE THING THEY WANT. PUT IT IN YOUR POUCH. WALK UP TO THEM. DOMINANCE." }, { speaker = compType, text = "CLICK THE GUEST!!! THEY EXPLODE INTO GOLD AND GRATITUDE ✨" } } } },
				{ text = "TELL ME ABOUT THE VILLAGE WHISPER", next = { speaker = "elder", lines = { { speaker = "elder", text = "...Zunda Village. Founded by chef-monks who REALLY liked peas. 🏭" }, { speaker = "elder", text = "Every dish here carries their obsession. COOK IT PROUDLY. 💛" } } } },
				{ text = "Never mind (coward)", next = leafEnd },
			},
		}
	end

	-- ── Companion identity sub-tree ───────────────────────────
	local function buildIdentityNode()
		local flavorTexts = {
			ankomon = { "I'm a RED BEAN SPIRIT 🫘🥊", "I buff YOUR GOLD by 15%. Every coin you earn? That's ME flexing from the spirit realm. 💪💰" },
			cardamon = { "I am CARDAMON 🌿🍋", "I expand your PERFECT COOKING WINDOW by 30%. More time. More precision. MORE GLORY. Breathe in. Cook well. 🧘" },
			antimon = { "I'M ANTIMON ⚡💨", "I grant +20% EXTRA DROP CHANCE. Ingredients literally CANNOT hide from me. I'll point. You gather. FAST. 🏃‍♂️" },
			sakuradamon = { "I AM SAKURADAMON 🌸💥", "I bless you with +25% XP from EVERYTHING. Every dish. Every serve. Every moment near a stove. MY PETALS CARRY KNOWLEDGE. 📚🌸" },
		}
		local ft = flavorTexts[compType]
		if ft then
			return { speaker = compType, lines = { { speaker = compType, text = ft[1] }, { speaker = compType, text = ft[2] }, { speaker = compType, text = "I chose YOU to cook alongside. Don't make me regret it (you won't). 🔥" } } }
		end
		return { speaker = compType, lines = { { speaker = compType, text = "I'M YOUR COMPANION!!! AND I'M THE BEST THING THAT'S HAPPENED TO YOUR KITCHEN EVER!!! 💚💚" } } }
	end

	-- ── BUILD ROOT ───────────────────────────────────────────
	local greetingLines = {}
	local compDisplay = compType or "zundapal"

	if #levelGreeting > 0 then
		table.insert(greetingLines, { speaker = "narrator", text = "[ Your companion senses your GROWING POWER and speaks with newfound respect... ] ⚡✨" })
		for _, l in ipairs(levelGreeting) do
			table.insert(greetingLines, { speaker = compDisplay, text = l })
		end
	elseif #greeting > 0 then
		local narratorIntros = {
			zundapal = "[ Zundapal explodes into view with sparkling eyes and pea aura ] 💥",
			ankomon = "[ Ankomon cracks his knuckles. BEAN AURA INTENSIFIES. ] 🫘🔥",
			cardamon = "[ Cardamon drifts in on a gentle herb-scented breeze... ] 🌿🍃",
			antimon = "[ ANTIMON ZOOMS INTO EXISTENCE AT TERMINAL VELOCITY ] ⚡💨",
			sakuradamon = "[ Sakura petals swirl as Sakuradamon descends from the cherry heavens... ] 🌸✨",
		}
		table.insert(greetingLines, { speaker = "narrator", text = narratorIntros[compType] or narratorIntros.zundapal })
		for _, l in ipairs(greeting) do
			table.insert(greetingLines, { speaker = compDisplay, text = l })
		end
	else
		table.insert(greetingLines, { speaker = "narrator", text = "[ Your companion awaits your command... ] 🎤" })
		table.insert(greetingLines, { speaker = compDisplay, text = "Hey " .. player.Name .. "! Ready to cook something AMAZING? 🔥" })
	end

	return {
		speaker = compDisplay,
		lines = greetingLines,
		prompt = "WHAT NOW??? 🎤",
		choices = {
			{ text = "GIVE ME A COOKING TIP 🍳🔥", next = buildCookingTips() },
			{ text = "I NEED QUEST HELP 📜", next = buildQuestHints() },
			{ text = "TELL ME ABOUT YOURSELF ✨", next = buildIdentityNode() },
			{ text = "BYE OR I'LL CRY", next = leafEnd },
		},
	}
end

-- Companion click → branching tree
RE:WaitForChild("OpenCompanionVN").OnClientEvent:Connect(function(compType, emoji)
	if isOpen then
		closePanel(true)
		return
	end
	_G.ZundaVN.showBranching(buildCompanionTree(compType))
end)

-- Quest completed
local qcRE = RE:FindFirstChild("QuestCompleted")
if qcRE then
	qcRE.OnClientEvent:Connect(function(quest)
		local lines = {
			{ speaker = "zundamon", text = 'QUEST COMPLETE!!!!!!!!! 🎉🎉🎉 "' .. quest.title .. '" HAS BEEN DESTROYED (in a good way)' },
			{ speaker = "zundapal", text = "YOU DID THE THING!!!! "
				.. player.Name
				.. "!!! ABSOLUTE LEGEND 🔥 +"
				.. (quest.reward or 0)
				.. " GOLD GET IN THE BAG 💰💰" },
			{ speaker = "zundamon", text = quest.unlock_hint or "MORE AWAITS YOU!!! THIS IS ONLY THE BEGINNING OF THE PEA-SPLOSION 🌱💥" },
			{ speaker = "zundapal", text = "I'M SO PROUD I COULD EAT A THOUSAND MOCHI (I won't though. maybe one.) 🍡" },
		}
		_G.ZundaVN.show("zundamon", lines)
	end)
end

-- Zone entry lore (BindableEvent fired by client zone ClickDetector handler)
local showZoneVNBindable = playerGui:FindFirstChild("ShowZoneVN")
if not showZoneVNBindable then
	showZoneVNBindable = Instance.new("BindableEvent")
	showZoneVNBindable.Name = "ShowZoneVN"
	showZoneVNBindable.Parent = player.PlayerGui
end
showZoneVNBindable.Event:Connect(function(zoneKey)
	local ok, loreCfg = pcall(function()
		return require(RS.ConfigurationFiles.ZoneLoreConfig)
	end)
	if not ok or not loreCfg then
		return
	end
	local lore = loreCfg[zoneKey]
	if not lore then
		return
	end
	local lines = {}
	for _, l in ipairs(lore.lines) do
		table.insert(lines, { speaker = lore.speaker, text = l })
	end
	_G.ZundaVN.show(lore.speaker, lines)
end)

-- Wait for _G.ZundaVN to be ready then fire welcome dialogue
task.delay(2.5, function()
	_G.ZundaVN.show("zundamon", {
		"WELCOME TO ZUNDA VILLAGE!!!!!!!!! 🌸🔥 " .. player.Name .. " YOU'RE HERE!!!!!",
		"I'M ZUNDAMON!!! I WILL GUIDE YOU THROUGH CULINARY... THINGS!!!",
		"Press M for map • I for pouch • J for QUESTS • and your BRAIN for FUN 🧠",
		"YOUR ZUNDAPAL COMPANION IS RIGHT THERE — CLICK THEM AND SCREAM TOGETHER 🍡💚",
		"WE'RE GONNA COOK SO HARD THE SUN WILL GET JEALOUS ☀️😤 READY?? LET'S PEA!!!!!!",
	})
end)

print("[ZundaVN] Unified VN controller ready — all triggers wired")

-- [[Script] QuestManager (ref: RBX3396935863214D0B8C8C694DA2DBBB6B)]]
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RE = RS:WaitForChild("RemoteEvents")
local ev = RE:FindFirstChild("UpdateQuests")
if not ev then
	ev = Instance.new("RemoteEvent")
	ev.Name = "UpdateQuests"
	ev.Parent = RE
end
local qcEv = RE:FindFirstChild("QuestCompleted")
if not qcEv then
	qcEv = Instance.new("RemoteEvent")
	qcEv.Name = "QuestCompleted"
	qcEv.Parent = RE
end

local configFiles = RS:WaitForChild("ConfigurationFiles")
local QuestConfig = require(configFiles:WaitForChild("QuestConfig"))
local QuestProgress = require(configFiles:WaitForChild("QuestProgress"))
local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local QUEST_DEFS = QuestConfig.default_quests
local CLIENT_QUESTS = {}
for _, quest in ipairs(QUEST_DEFS) do
	table.insert(CLIENT_QUESTS, QuestProgress.toClientQuest(quest))
end

local function ensureCompletedTable(data: { [string]: any })
	if type(data.completed_quests) ~= "table" then
		data.completed_quests = {}
	end
end

local function grantQuestRewards(player: Player, data: { [string]: any }, quest: { [string]: any })
	local rewards = quest.rewards or {}
	local gold = rewards.gold or 0
	if gold > 0 then
		data.Gold = (data.Gold or data.current_gold or 0) + gold
		data.current_gold = data.Gold
	end
	local tierPoints = rewards.tier_points or 0
	if tierPoints > 0 then
		data.tier_points = (data.tier_points or 0) + tierPoints
	end
	for _, itemName in ipairs(rewards.items or {}) do
		data[itemName] = (data[itemName] or 0) + 1
	end
	print("[QuestManager] Quest complete: " .. quest.id .. " for " .. player.Name .. " (+" .. gold .. " gold)")
end

local function eval(player: Player)
	local data = PlayerDataService.get(player)
	if not data then
		return
	end

	ensureCompletedTable(data)

	local prog = {}
	for _, quest in ipairs(QUEST_DEFS) do
		local current, goal = QuestProgress.evaluate(quest, data)
		local alreadyDone = data.completed_quests[quest.id] == true
		local done = alreadyDone or current >= goal
		prog[quest.id] = { current = current, goal = goal, done = done }

		if current >= goal and not alreadyDone then
			data.completed_quests[quest.id] = true
			grantQuestRewards(player, data, quest)
			local clientQuest = QuestProgress.toClientQuest(quest)
			qcEv:FireClient(player, {
				id = quest.id,
				title = clientQuest.emoji .. " " .. clientQuest.title,
				reward = (quest.rewards and quest.rewards.gold) or 0,
				unlock_hint = quest.unlock_hint,
			})
		end
	end

	ev:FireClient(player, CLIENT_QUESTS, prog)
end

Players.PlayerAdded:Connect(function(p)
	task.wait(7)
	while p and p.Parent do
		eval(p)
		task.wait(4)
	end
end)

for _, p in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		task.wait(3)
		while p and p.Parent do
			eval(p)
			task.wait(4)
		end
	end)
end

print("[QuestManager] Ready — " .. #QUEST_DEFS .. " quests from QuestConfig")

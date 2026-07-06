-- MasterChefZundaServer: kitchen mentor NPC click + LLM chat proxy.

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local MasterChefConfig = require(RS.ConfigurationFiles.MasterChefZundaConfig)
local ZundapalLLMService = require(script.Parent.Services.ZundapalLLMService)
local CompanionStats = require(script.Parent.Services.CompanionStats)
local RemoteRateLimiter = require(script.Parent.Services.RemoteRateLimiter)

local RE = RS:WaitForChild("RemoteEvents")
local PERSONA = MasterChefConfig.llmPersonaKey

local function ensureEvent(name: string)
	local ev = RE:FindFirstChild(name)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = name
		ev.Parent = RE
	end
	return ev
end

local openEv = ensureEvent("OpenMasterChefVN")
local sendEv = ensureEvent("MasterChefChatSend")
local replyEv = ensureEvent("MasterChefChatReply")
local errorEv = ensureEvent("MasterChefChatError")
local statusEv = ensureEvent("MasterChefChatStatus")

local function getInteractPart(inst: Instance): BasePart?
	if inst:IsA("BasePart") then
		return inst
	end
	if inst:IsA("Model") then
		return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
	end
	return nil
end

local function playerNear(player: Player, part: BasePart): boolean
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end
	return (hrp.Position - part.Position).Magnitude <= MasterChefConfig.interactDistance
end

local function bindNpc(inst: Instance)
	local part = getInteractPart(inst)
	if not part then
		return
	end
	local clickDetector = inst:FindFirstChildWhichIsA("ClickDetector", true)
	if not clickDetector then
		return
	end
	clickDetector.MouseClick:Connect(function(clicker: Player)
		if not clicker or not clicker:IsA("Player") then
			return
		end
		if not playerNear(clicker, part) then
			return
		end
		if not RemoteRateLimiter.allow(clicker, "openMasterChefVN", 2) then
			return
		end
		openEv:FireClient(clicker)
	end)
end

for _, inst in ipairs(CollectionService:GetTagged(MasterChefConfig.collectionTag)) do
	bindNpc(inst)
end
CollectionService:GetInstanceAddedSignal(MasterChefConfig.collectionTag):Connect(bindNpc)

sendEv.OnServerEvent:Connect(function(player: Player, message: any)
	if typeof(message) ~= "string" then
		errorEv:FireClient(player, "Invalid message.")
		return
	end

	statusEv:FireClient(player, "thinking")

	task.spawn(function()
		local ok, text, reason = ZundapalLLMService.chat(player, message, PERSONA)
		statusEv:FireClient(player, "ready")

		if ok then
			CompanionStats.recordNpcChat(player, MasterChefConfig.speakerKey)
			replyEv:FireClient(player, {
				text = text,
				speaker = MasterChefConfig.speakerKey,
			})
		else
			if reason == "cooldown" or reason == "too_long" or reason == "empty" or reason == "filtered" then
				errorEv:FireClient(player, text)
			else
				replyEv:FireClient(player, {
					text = text,
					speaker = MasterChefConfig.speakerKey,
					fallback = true,
				})
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	ZundapalLLMService.clearSession(player.UserId)
end)

print("[MasterChefZundaServer] Kitchen mentor NPC + LLM chat ready")

-- ZundapalChatServer: validates client chat and proxies to ZundapalLLMService.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local ZundapalLLMService = require(script.Parent.Services.ZundapalLLMService)
local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local RE = RS:WaitForChild("RemoteEvents")

local function ensureEvent(name: string)
	local ev = RE:FindFirstChild(name)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = name
		ev.Parent = RE
	end
	return ev
end

local sendEv = ensureEvent("ZundapalChatSend")
local replyEv = ensureEvent("ZundapalChatReply")
local errorEv = ensureEvent("ZundapalChatError")
local statusEv = ensureEvent("ZundapalChatStatus")

local function bumpCompanionChats(player: Player)
	local data = PlayerDataService.getOrCreate(player)
	if not data.stats then
		data.stats = { perfectCooks = 0, companion_chats = 0, npc_chats = 0 }
	end
	data.stats.companion_chats = (data.stats.companion_chats or 0) + 1
end

sendEv.OnServerEvent:Connect(function(player: Player, message: any)
	if typeof(message) ~= "string" then
		errorEv:FireClient(player, "Invalid message.")
		return
	end

	statusEv:FireClient(player, "thinking")

	task.spawn(function()
		local ok, text, reason = ZundapalLLMService.chat(player, message)
		statusEv:FireClient(player, "ready")

		if ok then
			bumpCompanionChats(player)
			replyEv:FireClient(player, {
				text = text,
				speaker = "zundapal",
			})
		else
			if reason == "cooldown" or reason == "too_long" or reason == "empty" or reason == "filtered" then
				errorEv:FireClient(player, text)
			else
				replyEv:FireClient(player, {
					text = text,
					speaker = "zundapal",
					fallback = true,
				})
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	ZundapalLLMService.clearSession(player.UserId)
end)

print("[ZundapalChatServer] Ready — LLM free chat via ZundapalChatSend/Reply")

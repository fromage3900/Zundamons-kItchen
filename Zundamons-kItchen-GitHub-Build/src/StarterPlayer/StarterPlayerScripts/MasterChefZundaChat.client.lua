-- [[LocalScript] MasterChefZundaChat]]
-- Wires Master Chef Zunda LLM remotes to VNController.

local RS = game:GetService("ReplicatedStorage")
local RE = RS:WaitForChild("RemoteEvents")

while not _G.ZundaVN do
	task.wait(0.1)
end

local sendEv = RE:WaitForChild("MasterChefChatSend", 30)
local replyEv = RE:WaitForChild("MasterChefChatReply", 30)
local errorEv = RE:WaitForChild("MasterChefChatError", 30)
local statusEv = RE:WaitForChild("MasterChefChatStatus", 30)

if not sendEv or not replyEv then
	warn("[MasterChefZundaChat] Remotes missing — mentor LLM disabled")
	return
end

local function onThinking()
	if _G.ZundaVN.setThinking then
		_G.ZundaVN.setThinking(true, "Master Chef Zunda is thinking… 🍙")
	end
end

_G.ZundaMasterChefChat = {
	submit = function(text: string)
		if typeof(text) ~= "string" or text == "" then
			return
		end
		onThinking()
		sendEv:FireServer(text)
	end,
}

statusEv.OnClientEvent:Connect(function(status)
	if status == "thinking" then
		onThinking()
	end
end)

replyEv.OnClientEvent:Connect(function(payload)
	if typeof(payload) ~= "table" then
		return
	end
	local text = payload.text
	if typeof(text) ~= "string" or text == "" then
		return
	end
	local speaker = payload.speaker or "master_chef"
	if _G.ZundaVN.showNpcLine then
		_G.ZundaVN.showNpcLine(speaker, text)
	elseif _G.ZundaVN.showCompanionLine then
		_G.ZundaVN.showCompanionLine(text)
	end
end)

errorEv.OnClientEvent:Connect(function(message)
	if typeof(message) ~= "string" then
		return
	end
	if _G.ZundaVN.showNpcLine then
		_G.ZundaVN.showNpcLine("master_chef", message)
	end
end)

print("[MasterChefZundaChat] Mentor LLM ready")

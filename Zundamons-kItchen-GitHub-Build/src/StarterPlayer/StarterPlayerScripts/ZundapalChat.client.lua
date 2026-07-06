-- [[LocalScript] ZundapalChat]]
-- Wires LLM free-chat remotes to VNController UI.

local RS = game:GetService("ReplicatedStorage")
local RE = RS:WaitForChild("RemoteEvents")

while not _G.ZundaVN do
	task.wait(0.1)
end

local sendEv = RE:WaitForChild("ZundapalChatSend", 30)
local replyEv = RE:WaitForChild("ZundapalChatReply", 30)
local errorEv = RE:WaitForChild("ZundapalChatError", 30)
local statusEv = RE:WaitForChild("ZundapalChatStatus", 30)

if not sendEv or not replyEv then
	warn("[ZundapalChat] Remotes missing — LLM chat disabled")
	return
end

_G.ZundaPalChat = {
	submit = function(text: string)
		if typeof(text) ~= "string" or text == "" then
			return
		end
		if _G.ZundaVN.setThinking then
			_G.ZundaVN.setThinking(true)
		end
		sendEv:FireServer(text)
	end,
}

statusEv.OnClientEvent:Connect(function(status)
	if status == "thinking" and _G.ZundaVN.setThinking then
		_G.ZundaVN.setThinking(true)
	elseif status == "ready" then
		-- reply handler will clear thinking state
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
	if _G.ZundaVN.showCompanionLine then
		_G.ZundaVN.showCompanionLine(text)
	end
end)

errorEv.OnClientEvent:Connect(function(message)
	if typeof(message) ~= "string" then
		return
	end
	if _G.ZundaVN.showCompanionLine then
		_G.ZundaVN.showCompanionLine(message)
	end
end)

print("[ZundapalChat] LLM free chat ready")

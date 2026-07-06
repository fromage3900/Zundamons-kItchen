--!strict
-- ZundapalLLMService: server-side LLM proxy for Zundapal free chat.

local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local TextService = game:GetService("TextService")

local Config = require(game.ReplicatedStorage.ConfigurationFiles.ZundapalLLMConfig)

export type ChatMessage = {
	role: string,
	content: string,
}

local sessions: { [number]: { ChatMessage } } = {}
local lastSendAt: { [number]: number } = {}
local cachedApiKey: string? = nil

local ZundapalLLMService = {}

local function getApiKey(): string?
	if cachedApiKey and cachedApiKey ~= "" then
		return cachedApiKey
	end
	local folder = ServerStorage:FindFirstChild(Config.secretsFolderName)
	if not folder then
		return nil
	end
	local keyValue = folder:FindFirstChild(Config.apiKeyValueName)
	if keyValue and keyValue:IsA("StringValue") and keyValue.Value ~= "" then
		cachedApiKey = keyValue.Value
		return cachedApiKey
	end
	return nil
end

local function filterForPlayer(text: string, userId: number): string?
	local ok, result = pcall(function()
		local filtered = TextService:FilterStringAsync(text, userId)
		return filtered:GetNonChatStringForBroadcastAsync()
	end)
	if ok and type(result) == "string" and result ~= "" then
		return result
	end
	return nil
end

local function trimHistory(userId: number)
	local history = sessions[userId]
	if not history then
		return
	end
	while #history > Config.maxHistoryMessages do
		table.remove(history, 1)
	end
end

local function pickFallback(playerName: string): string
	local options = Config.fallbackReplies
	local template = options[math.random(1, #options)]
	return string.gsub(template, "{playerName}", playerName or "Chef")
end

local function buildMessages(userId: number, playerName: string, userText: string): { ChatMessage }
	if not sessions[userId] then
		sessions[userId] = {}
	end
	local history = sessions[userId]

	local systemContent = Config.systemPrompt
		.. "\n\nThe player's Roblox display name is: "
		.. playerName
		.. ". Address them warmly by name when natural."

	table.insert(history, { role = "user", content = userText })

	trimHistory(userId)

	local messages: { ChatMessage } = { { role = "system", content = systemContent } }
	for _, msg in ipairs(history) do
		table.insert(messages, msg)
	end
	return messages
end

local function parseAssistantText(body: string): string?
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(body)
	end)
	if not ok or type(decoded) ~= "table" then
		return nil
	end
	local choices = decoded.choices
	if type(choices) ~= "table" or #choices == 0 then
		return nil
	end
	local message = choices[1].message
	if type(message) ~= "table" then
		return nil
	end
	local content = message.content
	if type(content) ~= "string" or content == "" then
		return nil
	end
	return content
end

function ZundapalLLMService.isEnabled(): boolean
	return Config.enabled == true
end

function ZundapalLLMService.checkCooldown(userId: number): (boolean, number?)
	local now = os.clock()
	local last = lastSendAt[userId]
	if last and (now - last) < Config.cooldownSeconds then
		return false, Config.cooldownSeconds - (now - last)
	end
	return true, nil
end

function ZundapalLLMService.clearSession(userId: number)
	sessions[userId] = nil
	lastSendAt[userId] = nil
end

function ZundapalLLMService.chat(player: Player, rawMessage: string): (boolean, string, string?)
	if not ZundapalLLMService.isEnabled() then
		return false, pickFallback(player.Name), "disabled"
	end

	local message = string.gsub(rawMessage, "^%s+", "")
	message = string.gsub(message, "%s+$", "")
	if message == "" then
		return false, "Say something and I'll listen~ 🍡", "empty"
	end
	if #message > Config.maxInputChars then
		return false, "That message is a little long~ Try a shorter question! ✨", "too_long"
	end

	local okCooldown, waitSec = ZundapalLLMService.checkCooldown(player.UserId)
	if not okCooldown then
		return false, string.format("Slow down a tiny bit~ %.0fs left ⏳", waitSec or 1), "cooldown"
	end

	local filteredInput = filterForPlayer(message, player.UserId)
	if not filteredInput then
		return false, "I couldn't read that message~ Try different words? 🍡", "filtered"
	end

	local apiKey = getApiKey()
	if not apiKey then
		warn("[ZundapalLLM] No ApiKey in ServerStorage." .. Config.secretsFolderName)
		return false, pickFallback(player.Name), "no_key"
	end

	local provider = Config.provider
	local endpoint = Config.endpoints[provider]
	local model = Config.models[provider]
	if not endpoint or not model then
		return false, pickFallback(player.Name), "bad_config"
	end

	lastSendAt[player.UserId] = os.clock()

	local messages = buildMessages(player.UserId, player.Name, filteredInput)
	local requestBody = HttpService:JSONEncode({
		model = model,
		messages = messages,
		max_tokens = Config.maxTokens,
		temperature = Config.temperature,
	})

	local success, response = pcall(function()
		return HttpService:RequestAsync({
			Url = endpoint,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = "Bearer " .. apiKey,
			},
			Body = requestBody,
		})
	end)

	if not success or not response then
		warn("[ZundapalLLM] Request failed:", response)
		return false, pickFallback(player.Name), "http_error"
	end

	if response.StatusCode < 200 or response.StatusCode >= 300 then
		warn("[ZundapalLLM] HTTP", response.StatusCode, response.Body)
		return false, pickFallback(player.Name), "http_status"
	end

	local assistantText = parseAssistantText(response.Body)
	if not assistantText then
		return false, pickFallback(player.Name), "parse_error"
	end

	if #assistantText > Config.maxOutputChars then
		assistantText = string.sub(assistantText, 1, Config.maxOutputChars) .. "…"
	end

	local history = sessions[player.UserId]
	if history then
		table.insert(history, { role = "assistant", content = assistantText })
		trimHistory(player.UserId)
	end

	return true, assistantText, nil
end

return ZundapalLLMService

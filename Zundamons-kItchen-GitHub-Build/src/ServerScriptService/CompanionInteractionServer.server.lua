-- CompanionInteractionServer: server validation for NPC dialogue quest counters.

local RS = game:GetService("ReplicatedStorage")
local RE = RS:WaitForChild("RemoteEvents")

local CompanionConfig = require(RS.ConfigurationFiles.CompanionConfig)
local CompanionStats = require(script.Parent.Services.CompanionStats)

local recordNpcEv = RE:FindFirstChild("RecordNpcChat")
if not recordNpcEv then
	recordNpcEv = Instance.new("RemoteEvent")
	recordNpcEv.Name = "RecordNpcChat"
	recordNpcEv.Parent = RE
end

local lastNpcChat: { [string]: number } = {}
local NPC_COOLDOWN = 5

recordNpcEv.OnServerEvent:Connect(function(player: Player, speakerKey: any)
	if typeof(speakerKey) ~= "string" then
		return
	end
	if not CompanionConfig.npcSpeakers[speakerKey] then
		return
	end

	local now = os.clock()
	local cooldownKey = tostring(player.UserId) .. ":" .. speakerKey
	local last = lastNpcChat[cooldownKey]
	if last and (now - last) < NPC_COOLDOWN then
		return
	end
	lastNpcChat[cooldownKey] = now

	if CompanionStats.recordNpcChat(player, speakerKey) then
		print("[CompanionInteraction] " .. player.Name .. " spoke with " .. speakerKey)
	end
end)

print("[CompanionInteractionServer] NPC chat tracking ready")

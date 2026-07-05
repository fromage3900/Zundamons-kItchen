-- ZoneVisitServer: records zone visits for quests and exploration progress.

local RS = game:GetService("ReplicatedStorage")
local PlayerDataService = require(script.Parent.Services.PlayerDataService)

local RE = RS:WaitForChild("RemoteEvents")
local zoneVisitedEv = RE:FindFirstChild("ZoneVisited")
if not zoneVisitedEv then
	zoneVisitedEv = Instance.new("RemoteEvent")
	zoneVisitedEv.Name = "ZoneVisited"
	zoneVisitedEv.Parent = RE
end

zoneVisitedEv.OnServerEvent:Connect(function(player, rawZoneKey)
	if type(rawZoneKey) ~= "string" then
		return
	end
	PlayerDataService.recordZoneVisit(player, rawZoneKey)
end)

print("[ZoneVisitServer] Ready")

--!strict
-- RemoteRateLimiter: per-player cooldowns for C→S remotes (exploit prevention).

local Players = game:GetService("Players")

local lastAction: { [number]: { [string]: number } } = {}

local RemoteRateLimiter = {}

function RemoteRateLimiter.allow(player: Player, action: string, cooldownSeconds: number): boolean
	if cooldownSeconds <= 0 then
		return true
	end
	local uid = player.UserId
	if not lastAction[uid] then
		lastAction[uid] = {}
	end
	local bucket = lastAction[uid]
	local now = os.clock()
	local last = bucket[action]
	if last and (now - last) < cooldownSeconds then
		return false
	end
	bucket[action] = now
	return true
end

function RemoteRateLimiter.clear(player: Player)
	lastAction[player.UserId] = nil
end

Players.PlayerRemoving:Connect(function(player)
	RemoteRateLimiter.clear(player)
end)

return RemoteRateLimiter

-- [[Script] RequestDataHandler (ref: RBX503CB1D186324F68A761F54B1BC9D8FE)]]
-- RequestDataHandler: Server-side handler for RequestData RemoteFunction.
-- Returns the player's _G.data table so clients can render materials inventory.

local RS = game:GetService("ReplicatedStorage")
local RF = RS:WaitForChild("RemoteFunctions")
local requestData = RF:FindFirstChild("RequestData") or Instance.new("RemoteFunction")
requestData.Name = "RequestData"
requestData.Parent = RF

requestData.OnServerInvoke = function(player)
	if not _G.data then return {} end
	local d = _G.data[player.Name]
	if not d then return {} end

	-- Build a shallow copy of numeric (material) fields only, hiding internals
	local HIDDEN = {
		recipes_unlocked = true,
		cosmetics_unlocked = true,
		furniture_unlocked = true,
		locations_unlocked = true,
		owned_clothing = true,
		owned_decorations = true,
		recipes_served_count = true,
		tools = true,
		keybinds = true,
	}
	local out = {}
	for k, v in pairs(d) do
		if not HIDDEN[k] then
			out[k] = v
		end
	end
	return out
end

print("[RequestDataHandler] Ready")

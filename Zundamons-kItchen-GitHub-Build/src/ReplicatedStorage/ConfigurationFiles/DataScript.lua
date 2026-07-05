-- [[ModuleScript] DataScript (ref: RBXCCE996BCAEBA4636AEC521B399400EDE)]]
local RS = game.ReplicatedStorage
local RF = RS:WaitForChild("RemoteFunctions")
local requestData = RF:WaitForChild("RequestData")

local data = {}

function data.getData()
	local resp = requestData:InvokeServer()
	print("local data", resp)
	return resp
end

return data

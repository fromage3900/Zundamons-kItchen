-- [[Script] ZundaGatherServer (ref: RBX382D14910F4C466898CDB20D388810EF)]]
-- Click-to-gather for ResourceType nodes (config: GatherConfig).
-- Tool mining (rocks/trees) uses Mineable.server + Tools.server — not this script.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local TweenS = game:GetService("TweenService")

local GatherConfig = require(RS.ConfigurationFiles.GatherConfig)
local lootMod = require(SSS.LootModule)

local RE_notify = RS:FindFirstChild("RemoteEvents") and RS.RemoteEvents:FindFirstChild("NotifyPlayer")

local function grantItems(player: Player, items: { string })
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end
	pcall(function()
		lootMod.generateLoot(player, items, hrp.Position)
	end)
end

local function notify(player: Player, message: string)
	if RE_notify then
		RE_notify:FireClient(player, "gather_success", message)
	end
end

local function consumeNode(node: BasePart, respawnSec: number)
	node:SetAttribute("Available", false)
	local cd = node:FindFirstChildOfClass("ClickDetector")
	if cd then
		cd.MaxActivationDistance = 0
	end
	local origTransparency = node.Transparency
	local tween = TweenS:Create(node, TweenInfo.new(0.4), { Transparency = 1, Size = node.Size * 0.4 })
	tween:Play()
	task.delay(respawnSec, function()
		if not node.Parent then
			return
		end
		node:SetAttribute("Available", true)
		node.Size = node:GetAttribute("_origSize") or node.Size
		local back = TweenS:Create(node, TweenInfo.new(0.4), { Transparency = origTransparency })
		back:Play()
		if cd then
			cd.MaxActivationDistance = 16
		end
	end)
end

local function grantClickResource(player: Player, node: BasePart, resourceType: string)
	local def = GatherConfig.getClickResource(resourceType)
	if not def then
		return
	end
	local yield = node:GetAttribute("Yield") or def.defaultYield
	local items: { string } = {}
	for _ = 1, yield do
		table.insert(items, def.itemName)
	end
	grantItems(player, items)
	notify(player, def.notifyEmoji .. " +" .. tostring(yield) .. " " .. def.itemName)
	consumeNode(node, def.respawnSeconds)
end

local function grantMysteryLoot(player: Player, node: BasePart)
	local items: { string } = {}
	local count = math.random(2, 3)
	for _ = 1, count do
		local pick = GatherConfig.mysteryLoot[math.random(1, #GatherConfig.mysteryLoot)]
		table.insert(items, pick)
	end
	grantItems(player, items)
	notify(player, "✨ Mystery loot found!")
	consumeNode(node, GatherConfig.mysteryRespawnSeconds)
end

local function bindNode(node: BasePart)
	local cd = node:FindFirstChildOfClass("ClickDetector")
	if not cd then
		return
	end
	node:SetAttribute("_origSize", node.Size)

	cd.MouseClick:Connect(function(player)
		if not node:GetAttribute("Available") then
			return
		end
		local rtype = node:GetAttribute("ResourceType")
		if type(rtype) ~= "string" then
			return
		end

		if rtype == GatherConfig.mysteryResourceType then
			grantMysteryLoot(player, node)
			return
		end

		grantClickResource(player, node, rtype)
	end)
end

local function scanFolder(folder: Instance)
	for _, node in ipairs(folder:GetDescendants()) do
		if node:IsA("BasePart") and node:GetAttribute("ResourceType") and node:FindFirstChildOfClass("ClickDetector") then
			bindNode(node)
		end
	end
end

local loopArea = workspace:WaitForChild("GameplayLoopArea", 10)
if loopArea then
	local loopGather = loopArea:WaitForChild("GatheringNodes", 5)
	if loopGather then
		scanFolder(loopGather)
		loopGather.ChildAdded:Connect(function(child)
			task.wait(0.1)
			if child:IsA("BasePart") and child:GetAttribute("ResourceType") and child:FindFirstChildOfClass("ClickDetector") then
				bindNode(child)
			end
		end)
	end
end

print("[ZundaGatherServer] Ready — click-gather via GatherConfig")

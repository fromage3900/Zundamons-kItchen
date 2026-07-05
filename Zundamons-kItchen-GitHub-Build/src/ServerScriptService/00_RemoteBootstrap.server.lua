-- RemoteBootstrap: ensures networking folders exist before other scripts WaitForChild.
-- Safe on published places — only creates missing instances (never duplicates).

local RS = game:GetService("ReplicatedStorage")
local Manifest = require(RS.ConfigurationFiles.RemoteManifest)

local function ensureFolder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("Folder") then
		return existing
	end
	if existing then
		existing:Destroy()
	end
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function ensureRemoteEvent(parent: Instance, name: string)
	if parent:FindFirstChild(name) then
		return
	end
	local ev = Instance.new("RemoteEvent")
	ev.Name = name
	ev.Parent = parent
end

local function ensureRemoteFunction(parent: Instance, name: string)
	if parent:FindFirstChild(name) then
		return
	end
	local fn = Instance.new("RemoteFunction")
	fn.Name = name
	fn.Parent = parent
end

local remoteEvents = ensureFolder(RS, "RemoteEvents")
for _, name in ipairs(Manifest.remoteEvents) do
	ensureRemoteEvent(remoteEvents, name)
end

local remoteFunctions = ensureFolder(RS, "RemoteFunctions")
for _, name in ipairs(Manifest.remoteFunctions) do
	ensureRemoteFunction(remoteFunctions, name)
end

local rewardEvents = ensureFolder(RS, "RewardEvents")
for _, name in ipairs(Manifest.rewardEvents.events) do
	ensureRemoteEvent(rewardEvents, name)
end
for _, name in ipairs(Manifest.rewardEvents.functions) do
	ensureRemoteFunction(rewardEvents, name)
end

local toolRemotes = ensureFolder(RS, "ToolRemotes")
for _, name in ipairs(Manifest.toolRemotes) do
	ensureRemoteFunction(toolRemotes, name)
end

local inventoryRoot = ensureFolder(RS, "InventoryReplicatedStorage")
local inventoryRemotes = ensureFolder(inventoryRoot, "RemoteEvents")
for _, name in ipairs(Manifest.inventoryRemoteEvents) do
	ensureRemoteEvent(inventoryRemotes, name)
end

ensureFolder(RS, "Loot")

print("[RemoteBootstrap] Networking instances ready")

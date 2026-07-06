--!strict
-- [[Script] ScatterService (ref: NEW)]]
-- Procedural node scattering — PCG chain adapted from env-portfolio:
--   Sampler → Exclusion → Density Filter → Self Prune → Transform → Spawn
-- Scatters harvestable nodes, decorations, and environment props on region load.

local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local RS = ReplicatedStorage
local ScatterConfig = require(RS.ConfigurationFiles.ScatterConfig)
local HarvestNodeVariants = require(RS.Shared.Config.HarvestNodeVariants)

local function isRealMeshId(id: string): boolean
	return id ~= "" and id:find("FILL_") == nil and id:find("rbxassetid://0$") == nil
end

local ScatterService = {}

-- Internal state
local spawnedRegions: { [string]: boolean } = {}
local activeNodes: { [Instance]: true } = {}

-- Weighted random pick from variant table
local function pickVariant(variants: { string }, weights: { number }): string
	local total = 0
	for _, w in ipairs(weights) do
		total += w
	end
	local roll = math.random() * total
	local cumulative = 0
	for i, w in ipairs(weights) do
		cumulative += w
		if roll <= cumulative then
			return variants[i]
		end
	end
	return variants[#variants]
end

-- Check if a position is excluded by proximity to tagged instances
local function isExcluded(position: Vector3, exclusionTags: { string }, minDistance: number): boolean
	for _, tag in ipairs(exclusionTags) do
		for _, instance in ipairs(CollectionService:GetTagged(tag)) do
			if instance:IsA("BasePart") then
				local dist = (position - instance.Position).Magnitude
				if dist < minDistance then
					return true
				end
			end
		end
	end
	return false
end

-- Density filter: skip based on density probability
local function densityFilter(density: number): boolean
	return math.random() <= density
end

-- Self-prune: distance-based check against already-placed positions
local function selfPrune(pos: Vector3, placed: { Vector3 }, minSpacing: number): boolean
	for _, p in ipairs(placed) do
		if (pos - p).Magnitude < minSpacing then
			return false
		end
	end
	return true
end

-- Find a surface point on terrain or parts within a bounds volume
local function sampleSurface(bounds: Instance, voxelSize: number, maxSlope: number): Vector3?
	local cframe = bounds:GetPrimaryPartCFrame() or CFrame.new(bounds:GetBoundingBox())
	local size = bounds:GetExtentsSize()

	local halfX = size.X / 2
	local halfZ = size.Z / 2
	local origin = cframe.Position

	-- Random point within bounds
	local localX = (math.random() * 2 - 1) * halfX
	local localZ = (math.random() * 2 - 1) * halfZ
	local samplePos = Vector3.new(origin.X + localX, origin.Y + 500, origin.Z + localZ)

	-- Raycast down to find terrain/ground
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = { Workspace.Terrain }

	local result = Workspace:Raycast(samplePos, Vector3.new(0, -1000, 0), raycastParams)
	if result and result.Position then
		-- Check slope
		local normal = result.Normal
		local slopeAngle = math.deg(math.acos(math.clamp(normal.Y, -1, 1)))
		if slopeAngle <= maxSlope then
			return result.Position
		end
	end
	return nil
end

-- Spawn a node instance at a target position
local function spawnNode(nodeType: string, variantId: string, position: Vector3, biomeName: string): Instance?
	local nodeConfig = ScatterConfig.biomes[biomeName].node_types[nodeType]
	if not nodeConfig then
		return nil
	end

	local yOffset = nodeConfig.yOffset or 0
	local surfacePos = position + Vector3.new(0, yOffset, 0)
	local scale = math.random() * (nodeConfig.scaleRange[2] - nodeConfig.scaleRange[1]) + nodeConfig.scaleRange[1]
	local yRot = nodeConfig.yRotationRandom and math.rad(math.random(0, 359)) or 0
	local baseCFrame = CFrame.new(surfacePos) * CFrame.Angles(0, yRot, 0)

	-- 1) Rojo-synced template in ReplicatedStorage.Models (Cline mesh import target)
	local modelsFolder = RS:FindFirstChild("Models")
	local templateName = nodeType:gsub("%s+", "") .. "_" .. variantId
	local template = modelsFolder and modelsFolder:FindFirstChild(templateName)
	if not template and modelsFolder then
		template = modelsFolder:FindFirstChild(variantId)
	end

	local node: Instance
	if template and (template:IsA("Model") or template:IsA("BasePart")) then
		node = template:Clone()
		node.Name = nodeType .. "_" .. variantId
		if node:IsA("Model") then
			node:PivotTo(baseCFrame)
			if node.ScaleTo then
				node:ScaleTo(scale)
			end
		elseif node:IsA("BasePart") then
			node.CFrame = baseCFrame
			node.Size = node.Size * scale
		end
	else
		-- 2) MeshPart from HarvestNodeVariants when rbxassetid is real
		local meshId = HarvestNodeVariants.getMesh(nodeType, variantId)
		if meshId ~= "" and isRealMeshId(meshId) then
			local mesh = Instance.new("MeshPart")
			mesh.Name = nodeType .. "_" .. variantId
			mesh.MeshId = meshId
			mesh.Size = Vector3.new(2, 2, 2) * scale
			mesh.CFrame = baseCFrame
			mesh.Anchored = true
			mesh.CanCollide = false
			mesh.CastShadow = true
			node = mesh
		else
			-- 3) Colored Part fallback (no mesh imported yet)
			local part = Instance.new("Part")
			part.Name = nodeType .. "_" .. variantId
			part.Size = Vector3.new(2, 2, 2) * scale
			part.CFrame = baseCFrame
			part.Anchored = true
			part.CanCollide = false
			part.Material = Enum.Material.SmoothPlastic
			part.Color = Color3.fromRGB(100, 200, 130)
			part.Transparency = 0
			node = part
		end
	end

	-- Attributes for harvesting system
	node:SetAttribute("ResourceType", nodeConfig.resourceType)
	node:SetAttribute("Available", true)
	node:SetAttribute("VariantId", variantId)
	if node:IsA("BasePart") then
		node:SetAttribute("_origSize", node.Size)
	elseif node:IsA("Model") then
		local primary = node.PrimaryPart or node:FindFirstChildWhichIsA("BasePart")
		if primary then
			node:SetAttribute("_origSize", primary.Size)
		end
	end
	node:SetAttribute("ScatterBiome", biomeName)

	-- ClickDetector for interaction
	local cd = Instance.new("ClickDetector")
	cd.MaxActivationDistance = 16
	cd.Parent = node:IsA("Model") and (node.PrimaryPart or node:FindFirstChildWhichIsA("BasePart") or node) or node

	-- Tag for CollectionService
	if node:IsA("BasePart") then
		CollectionService:AddTag(node, "GatheringNode")
	elseif node:IsA("Model") then
		for _, desc in ipairs(node:GetDescendants()) do
			if desc:IsA("BasePart") then
				CollectionService:AddTag(desc, "GatheringNode")
			end
		end
	end

	node.Parent = Workspace:FindFirstChild("GameplayLoopArea") and
		Workspace.GameplayLoopArea:FindFirstChild("GatheringNodes") or Workspace

	activeNodes[node] = true
	return node
end

-- Scatter a biome's nodes within a volume region
function ScatterService.scatterBiome(biomeName: string, region: Instance)
	if spawnedRegions[biomeName .. "_" .. region.Name] then
		return
	end

	local biome = ScatterConfig.biomes[biomeName]
	if not biome then
		warn("[ScatterService] Unknown biome: " .. biomeName)
		return
	end

	local placed: { Vector3 } = {}

	for nodeType, nodeConfig in pairs(biome.node_types) do
		local attempts = 0
		local maxAttempts = ScatterConfig.defaults.max_placement_attempts * 10

		while attempts < maxAttempts and #placed < 200 do
			attempts += 1

			-- Sampler
			local surfacePos = sampleSurface(region, biome.voxel_size, biome.max_slope)
			if not surfacePos then
				continue
			end

			-- Exclusion
			if isExcluded(surfacePos, biome.exclusion_tags, biome.voxel_size) then
				continue
			end

			-- Density filter
			if not densityFilter(nodeConfig.density) then
				continue
			end

			-- Self-prune
			if not selfPrune(surfacePos, placed, nodeConfig.spacing) then
				continue
			end

			-- Pick variant
			local variantId = pickVariant(nodeConfig.variants, nodeConfig.variantWeights)

			-- Spawn
			local node = spawnNode(nodeType, variantId, surfacePos, biomeName)
			if node then
				table.insert(placed, surfacePos)
			end
		end
	end

	spawnedRegions[biomeName .. "_" .. region.Name] = true
	print(string.format("[ScatterService] Scattered %s in %s (%d nodes)", biomeName, region.Name, #placed))
end

-- Clear all scattered nodes in a region
function ScatterService.clearBiome(biomeName: string, region: Instance)
	for node, _ in pairs(activeNodes) do
		if node:GetAttribute("ScatterBiome") == biomeName and node.Parent then
			Debris:AddItem(node, 0)
			activeNodes[node] = nil
		end
	end
	spawnedRegions[biomeName .. "_" .. region.Name] = nil
end

-- Clear all scattered nodes
function ScatterService.clearAll()
	for node, _ in pairs(activeNodes) do
		if node.Parent then
			Debris:AddItem(node, 0)
		end
	end
	activeNodes = {}
	spawnedRegions = {}
end

-- Expose public API
ScatterService.scatterBiome = ScatterService.scatterBiome
ScatterService.clearBiome = ScatterService.clearBiome
ScatterService.clearAll = ScatterService.clearAll

return ScatterService

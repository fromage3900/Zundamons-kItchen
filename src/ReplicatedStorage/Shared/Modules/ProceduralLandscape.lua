--!strict
-- Lightweight procedural landscape planner that turns biome rules into a placement plan.

local LandscapeConfig = require(script.Parent.Parent.Config.LandscapeConfig)
local PlacementRules = require(script.Parent.PlacementRules)

local ProceduralLandscape = {}

local function round(value: number)
	return math.floor(value + 0.5)
end

function ProceduralLandscape.generateBiomePlan(biomeName: string?, options)
	local biome = LandscapeConfig.getBiome(biomeName)
	local plan = {
		biomeName = biome.name,
		seed = (options and options.seed) or biome.seed,
		zones = {},
		placements = {},
	}

	math.randomseed(plan.seed)

	for _, zone in ipairs(biome.zones or {}) do
		local zonePlan = {
			name = zone.name,
			type = zone.type,
			size = zone.size,
			spawnProfile = zone.spawnProfile,
			candidates = PlacementRules.generateCandidates(zone, plan.seed + (#plan.zones * 7)),
		}

		local selectedAssets = PlacementRules.selectAssets(biome.assetProfiles[zone.spawnProfile] or {}, zone.maxBuildings or 1)
		local placed = {}

		for _, assetEntry in ipairs(selectedAssets) do
			local candidates = PlacementRules.filterBySpacing(zonePlan.candidates, placed, biome.constraints.pathSpacing or 4)
			if #candidates > 0 then
				local candidate = table.remove(candidates, 1)
				table.insert(placed, {
					asset = assetEntry.asset,
					category = assetEntry.category,
					x = candidate.x,
					z = candidate.z,
					score = round((candidate.score or 0.5) * 10) / 10,
				})
			end
		end

		table.insert(plan.zones, zonePlan)
		for _, placement in ipairs(placed) do
			table.insert(plan.placements, placement)
		end
	end

	return plan
end

function ProceduralLandscape.getPreviewSummary(plan)
	return {
		biome = plan.biomeName,
		zones = #plan.zones,
		placements = #plan.placements,
	}
end

return ProceduralLandscape

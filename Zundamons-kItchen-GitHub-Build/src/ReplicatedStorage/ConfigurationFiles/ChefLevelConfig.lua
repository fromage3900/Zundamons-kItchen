-- [[ModuleScript] ChefLevelConfig (ref: RBX2717298F6AD34291908D07599A4F6190)]]
local M = {}

M.tiers = {
	{ name = "Apprentice", minLevel = 1, color = Color3.fromRGB(180, 220, 140), badge = "🌱" },
	{ name = "Sous Chef", minLevel = 5, color = Color3.fromRGB(160, 200, 240), badge = "🍳" },
	{ name = "Chef", minLevel = 10, color = Color3.fromRGB(255, 200, 140), badge = "👨‍🍳" },
	{ name = "Head Chef", minLevel = 20, color = Color3.fromRGB(245, 160, 200), badge = "⭐" },
	{ name = "Grandmaster", minLevel = 30, color = Color3.fromRGB(220, 180, 255), badge = "👑" },
}

function M.tierForLevel(level)
	local current = M.tiers[1]
	for _, tier in ipairs(M.tiers) do
		if level >= tier.minLevel then
			current = tier
		end
	end
	return current
end

function M.xpForLevel(level)
	return math.floor(80 * (level ^ 1.4))
end

-- XP rewards per action
M.xpRewards = {
	gather = 4,
	craftSuccess = 18,
	craftPerfect = 32,
	serveGuest = 25,
	questComplete = 60,
	dailyLogin = 100,
	perfectCombo = 10,
}

return M

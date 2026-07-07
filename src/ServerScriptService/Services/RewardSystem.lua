--!strict
-- RewardSystem: canonical server-side rewards (gold, XP, combo, notifications).

local RewardSystem = {}

local RS = game.ReplicatedStorage
local rewardEvents = RS:WaitForChild("RewardEvents")
local PopupEvent = rewardEvents:WaitForChild("PopupEvent")
local ChefLevelUpdate = rewardEvents:WaitForChild("ChefLevelUpdate")
local ComboUpdate = rewardEvents:WaitForChild("ComboUpdate")
local LevelUpEvent = rewardEvents:WaitForChild("LevelUpEvent")
local RequestRewardSync = rewardEvents:WaitForChild("RequestRewardSync")
local NotifyAction = rewardEvents:WaitForChild("NotifyAction")

local ChefLevelConfig = require(RS.ConfigurationFiles.ChefLevelConfig)
local CompanionConfig = require(RS.ConfigurationFiles.CompanionConfig)
local PlayerDataService = require(script.Parent.PlayerDataService)

local COMBO_WINDOW = 8

local function ensureProfile(player: Player)
	local d = PlayerDataService.getOrCreate(player)
	d.inventory = d.inventory or {}
	d.gold = d.gold or 0
	d.chef = d.chef or { level = 1, xp = 0 }
	d.combo = d.combo or { count = 0, multiplier = 1.0, lastActionAt = 0 }
	d.mastery = d.mastery or {}
	d.toolTiers = d.toolTiers or { Axe = 1, PickAxe = 1, Sickle = 1 }
	d.guestRep = d.guestRep or {}
	d.achievements = d.achievements or {}
	d.daily = d.daily or { lastClaimDay = 0, streak = 0, todayQuestId = nil, todayProgress = 0, todayClaimed = false }
	d.powerups = d.powerups or {}
	return d
end

local function comboMultiplier(count: number): number
	if count < 2 then
		return 1.0
	end
	if count < 4 then
		return 1.25
	end
	if count < 7 then
		return 1.5
	end
	if count < 10 then
		return 2.0
	end
	if count < 15 then
		return 3.0
	end
	return 5.0
end

local function popup(player: Player, kind: string, text: string, color: Color3)
	PopupEvent:FireClient(player, kind, text, color)
end

local function companionBuff(player: Player, stat: string): number
	local d = PlayerDataService.get(player)
	if not d or not d.active_companion then
		return 0
	end
	local def = CompanionConfig.getCompanion(d.active_companion)
	if not def.buff or def.buff.stat ~= stat then
		return 0
	end
	return def.buff.magnitude
end

RewardSystem.companionBuff = companionBuff

function RewardSystem.addGold(player: Player, amount: number, reason: string?): number
	if amount <= 0 then
		return 0
	end
	local d = ensureProfile(player)
	local mult = 1
	if reason == "serve" or reason == "craft" or reason == "perfect" then
		mult = d.combo.multiplier
	end
	if d.powerups.LuckyCharm and d.powerups.LuckyCharm > os.time() then
		mult *= 1.5
	end
	if reason == "serve" then
		mult *= (1 + companionBuff(player, "gold"))
	end
	local finalAmount = math.floor(amount * mult)
	d.gold += finalAmount
	popup(player, "gold", "+" .. finalAmount .. "g", Color3.fromRGB(255, 220, 90))
	if mult > 1 then
		popup(player, "bonus", "x" .. string.format("%.1f", mult) .. " combo!", Color3.fromRGB(255, 150, 200))
	end
	return finalAmount
end

function RewardSystem.addXP(player: Player, amount: number, reason: string?)
	if amount <= 0 then
		return
	end
	local d = ensureProfile(player)
	local xpBuff = companionBuff(player, "xp")
	if xpBuff > 0 then
		amount = math.floor(amount * (1 + xpBuff))
	end
	d.chef.xp += amount
	popup(player, "xp", "+" .. amount .. " XP", Color3.fromRGB(180, 130, 255))

	while d.chef.xp >= ChefLevelConfig.xpForLevel(d.chef.level) do
		d.chef.xp -= ChefLevelConfig.xpForLevel(d.chef.level)
		d.chef.level += 1
		local tier = ChefLevelConfig.tierForLevel(d.chef.level)
		LevelUpEvent:FireClient(player, d.chef.level, tier.name, tier.color, tier.badge)
	end
	RewardSystem.syncLevel(player)
end

function RewardSystem.syncLevel(player: Player)
	local d = ensureProfile(player)
	local tier = ChefLevelConfig.tierForLevel(d.chef.level)
	local xpNeeded = ChefLevelConfig.xpForLevel(d.chef.level)
	ChefLevelUpdate:FireClient(player, d.chef.level, d.chef.xp, xpNeeded, tier.name, tier.color, tier.badge)
end

function RewardSystem.syncCombo(player: Player)
	local d = ensureProfile(player)
	ComboUpdate:FireClient(player, d.combo.count, d.combo.multiplier)
end

function RewardSystem.bumpCombo(player: Player)
	local d = ensureProfile(player)
	local now = os.clock()
	if now - d.combo.lastActionAt > COMBO_WINDOW then
		d.combo.count = 1
	else
		d.combo.count += 1
	end
	d.combo.lastActionAt = now
	d.combo.multiplier = comboMultiplier(d.combo.count)
	RewardSystem.syncCombo(player)
end

function RewardSystem.breakCombo(player: Player)
	local d = ensureProfile(player)
	d.combo.count = 0
	d.combo.multiplier = 1.0
	RewardSystem.syncCombo(player)
end

function RewardSystem.notify(player: Player, actionType: string, payload: { [string]: any }?)
	NotifyAction:Fire(player, actionType, payload)
end

function RewardSystem.reward(player: Player, opts: { [string]: any })
	if opts.combo then
		RewardSystem.bumpCombo(player)
	end
	local gained = 0
	if opts.gold then
		gained = RewardSystem.addGold(player, opts.gold, opts.reason)
	end
	if opts.xp then
		RewardSystem.addXP(player, opts.xp, opts.reason)
	end
	if opts.popupItem then
		popup(player, "item", "+" .. opts.popupItem, Color3.fromRGB(160, 240, 170))
	end
	RewardSystem.notify(player, opts.reason or "generic", { gold = gained, xp = opts.xp })
	return gained
end

task.spawn(function()
	while true do
		task.wait(1)
		for _, player in ipairs(game.Players:GetPlayers()) do
			local d = PlayerDataService.get(player)
			if d and d.combo and d.combo.count > 0 then
				if os.clock() - d.combo.lastActionAt > COMBO_WINDOW then
					RewardSystem.breakCombo(player)
				end
			end
		end
	end
end)

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		ensureProfile(player)
		RewardSystem.syncLevel(player)
		RewardSystem.syncCombo(player)
	end)
end)

RequestRewardSync.OnServerInvoke = function(player: Player)
	local d = ensureProfile(player)
	local tier = ChefLevelConfig.tierForLevel(d.chef.level)
	return {
		level = d.chef.level,
		xp = d.chef.xp,
		xpNeeded = ChefLevelConfig.xpForLevel(d.chef.level),
		tierName = tier.name,
		tierColor = tier.color,
		tierBadge = tier.badge,
		gold = d.gold,
		combo = d.combo,
		toolTiers = d.toolTiers,
		achievements = d.achievements,
		mastery = d.mastery,
		guestRep = d.guestRep,
		powerups = d.powerups,
	}
end

return RewardSystem

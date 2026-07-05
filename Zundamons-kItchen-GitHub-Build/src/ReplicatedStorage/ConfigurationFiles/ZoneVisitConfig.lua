-- ZoneVisitConfig: canonical zone keys for quests, teleporters, and lore entrances.
-- Studio `Workspace.Zones` model names map to teleporter keys via lore_to_canonical.
-- QuestConfig `target_zone` strings map via quest_aliases.

local ZoneVisitConfig = {}

-- Teleporter / QuestManager explore quest keys
ZoneVisitConfig.canonical_zones = { "village", "kitchen", "eastpeaks", "mystic" }

-- Workspace.Zones model Name → canonical key
ZoneVisitConfig.lore_to_canonical = {
	Zone_VillageGate = "village",
	Zone_KitchenCourt = "kitchen",
	Zone_MarketPromenade = "village",
	Zone_NorthernBridge = "eastpeaks",
	Zone_HilltopShrine = "eastpeaks",
	Zone_AncientRuins = "mystic",
}

-- QuestConfig visit_zone target_zone → canonical key
ZoneVisitConfig.quest_aliases = {
	Kitchen = "kitchen",
	Pagoda = "eastpeaks",
	AncientRuins = "mystic",
	Village = "village",
	Mystic = "mystic",
}

function ZoneVisitConfig.resolve(rawKey: string): string?
	if not rawKey or rawKey == "" then
		return nil
	end
	if ZoneVisitConfig.lore_to_canonical[rawKey] then
		return ZoneVisitConfig.lore_to_canonical[rawKey]
	end
	if ZoneVisitConfig.quest_aliases[rawKey] then
		return ZoneVisitConfig.quest_aliases[rawKey]
	end
	local lower = string.lower(rawKey)
	for _, key in ipairs(ZoneVisitConfig.canonical_zones) do
		if key == lower then
			return key
		end
	end
	return nil
end

return ZoneVisitConfig

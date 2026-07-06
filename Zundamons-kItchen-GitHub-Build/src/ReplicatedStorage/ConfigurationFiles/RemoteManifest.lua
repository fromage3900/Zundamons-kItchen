-- RemoteManifest: canonical list of networking instances for Rojo + bootstrap.
-- Keep in sync with docs/remotes.md

local RemoteManifest = {}

RemoteManifest.remoteEvents = {
	"NotifyPlayer",
	"UpdateQuests",
	"QuestCompleted",
	"PurchaseCompanion",
	"CompanionOwnedSync",
	"SetCompanion",
	"WeatherChanged",
	"MakeLootEvent",
	"RemoveCode",
	"ShowPlantingMenu",
	"plantEvent",
	"CookingResult",
	"OpenCompanionVN",
	"ZundapalChatSend",
	"ZundapalChatReply",
	"ZundapalChatError",
	"ZundapalChatStatus",
	"ZoneVisited",
	"PurchaseResult",
}

RemoteManifest.remoteFunctions = {
	"RequestData",
	"ServeGuest",
	"EquipTool",
	"CraftFunction",
	"GiveLoot",
	"sellLoot",
	"ClaimPlot",
	"BuyDecoration",
	"PlaceDecoration",
	"GetDecorationState",
	"GetCompanionCatalog",
	"GetOwnedCompanions",
	"GetActiveCompanionBuff",
	"PromptRobuxPurchase",
}

RemoteManifest.rewardEvents = {
	events = {
		"PopupEvent",
		"ChefLevelUpdate",
		"ComboUpdate",
		"LevelUpEvent",
		"NotifyAction",
		"DailyUpdate",
		"LoginBonusEvent",
		"AchievementUnlocked",
		"PowerupUpdate",
	},
	functions = {
		"RequestRewardSync",
		"UsePowerup",
		"UpgradeTool",
		"GetCompendium",
	},
}

RemoteManifest.toolRemotes = {
	"ConnectFunction",
	"FishingCast",
}

RemoteManifest.inventoryRemoteEvents = {
	"Equip",
	"Drop",
	"ToHotbar",
	"ToInventory",
}

return RemoteManifest

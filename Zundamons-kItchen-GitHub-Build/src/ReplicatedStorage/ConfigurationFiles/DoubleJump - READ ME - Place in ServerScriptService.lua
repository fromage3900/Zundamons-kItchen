-- [[ModuleScript] DoubleJump - READ ME - Place in ServerScriptService (ref: RBX2B1BDC6C91B4491DB7FD089646C1D822)]]
--[[
	By: Jersito4
	Date April 10th 2022
	
	Description:
		This script allows players to double jump.
		This script will work on any device and any character
	
	Instructions:
		Place this script in the ServerScriptService.
		you can rename this script to anything you like.
		You can change the settings for the jumping below.
]]

local Settings = {
	
	--Main Settings
	ExtraJumps = 2, --How many times the player can jump in the sky
	
	WhiteList = {}, --Only allow some people to double jump, if you leave this empty everyone will be able to.  -- Example: {17258879, 178439272, 57328573} The numbers are the player's User Id
}

return Settings
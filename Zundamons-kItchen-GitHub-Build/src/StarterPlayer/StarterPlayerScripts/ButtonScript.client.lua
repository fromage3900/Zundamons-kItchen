-- [[LocalScript] ButtonScript (ref: RBX57E5C935B5E849FFA013854069A37D08)]]
local player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")
local dataGUI = playerGui:WaitForChild("DataGUI")
local dataScript = require(dataGUI:WaitForChild("DataScript"))
local button = script.Parent
local sellLoot = playerGui:WaitForChild("SellLoot")
local invFrame = sellLoot:WaitForChild("Inv_Frame")
_G.mydata = {}


button.MouseButton1Down:Connect(function() 
	_G.mydata = dataScript.getData()
	invFrame.Visible = true
end)

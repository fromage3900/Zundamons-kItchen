-- [[LocalScript] LootRepeater (ref: RBX3DC09B0146744188BAD54AAAA274066A)]]
local sc_frame = script.Parent
local inv_Frame = sc_frame.Parent
local lootFrame = sc_frame:WaitForChild("Template")
lootFrame.Visible = false
local RS = game.ReplicatedStorage
local RF = RS:WaitForChild("RemoteFunctions")
local sellLoot = RF:WaitForChild("sellLoot")
local ui = inv_Frame.Parent
local goldFrame = ui:WaitForChild("GoldFrame")
local goldText = goldFrame:WaitForChild("Gold")

inv_Frame:GetPropertyChangedSignal("Visible"):Connect(function()
	if inv_Frame.Visible then
		for _, child in ipairs(sc_frame:GetChildren()) do
			if not child:IsA("UIListLayout") and not child:IsA("Script") and child.Name ~= "Template" then
				child:Destroy()
			end
		end
		if _G.mydata then
			for k, v in pairs(_G.mydata) do
				if k ~= "Gold" then
					local newLootFrame = lootFrame:Clone()
					newLootFrame.Name = k
					newLootFrame.ItemName.Text = k
					newLootFrame.Value.Text = tostring(v)
					newLootFrame.Parent = sc_frame
					newLootFrame.Visible = true
					newLootFrame.SellItem.MouseButton1Down:Connect(function ()
						local resp = sellLoot:InvokeServer(k)
						if resp then
							newLootFrame:Destroy()
							goldText.Text = resp
						end
					end)
				end
			end		
		end
    end
end)

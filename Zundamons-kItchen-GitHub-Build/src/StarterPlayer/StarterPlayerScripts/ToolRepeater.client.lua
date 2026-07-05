-- [[LocalScript] ToolRepeater (ref: RBXB5AE20460B4A472694E0E938D83E3A48)]]
local sc_frame = script.Parent
local tool_Frame = sc_frame.Parent
local toolTemplate = sc_frame:WaitForChild("Template")
toolTemplate.Visible = false
local RS = game.ReplicatedStorage
local RF = RS:WaitForChild("RemoteFunctions")
local equipTool = RF:WaitForChild("EquipTool")

local previousEquipBtn = nil

tool_Frame:GetPropertyChangedSignal("Visible"):Connect(function()
	if tool_Frame.Visible then
		for _, child in ipairs(sc_frame:GetChildren()) do
			if not child:IsA("UIGridLayout") and not child:IsA("Script") and child.Name ~= "Template" then
				child:Destroy()
			end
		end
		if _G.mydata and _G.mydata.tools then
			for k, v in pairs(_G.mydata.tools) do
				local newToolFrame = toolTemplate:Clone()
				newToolFrame.Name = k
				newToolFrame.ItemName.Text = k
				newToolFrame.Tier.Text = tostring(v.Tier)
				newToolFrame.Parent = sc_frame
				newToolFrame.Visible = true
				if v.Equiped then
					newToolFrame.Equip.Visible = false
					previousEquipBtn = newToolFrame.Equip
				end
				newToolFrame.Equip.MouseButton1Down:Connect(function ()
					local resp = equipTool:InvokeServer(k)
					if resp then
						newToolFrame.Equip.Visible = false
						if previousEquipBtn then
							previousEquipBtn.Visible = true
						end
						previousEquipBtn = newToolFrame.Equip
					end
				end)
			end		
		end
    end
end)

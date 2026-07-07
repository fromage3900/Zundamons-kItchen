-- [[Script] system (ref: RBX0890234A69EF4323B642E62DA80DA7FA)]]
local door = script.Parent
local Open = door.Open
local cantoggle = true
local TweenService = game:GetService("TweenService")
local TweenOpen = TweenService:Create(door.Hinge, TweenInfo.new(0.4), {CFrame = door.Hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)})
local TweenClose = TweenService:Create(door.Hinge, TweenInfo.new(0.4), {CFrame = door.Hinge.CFrame * CFrame.Angles(0, 0, 0)})

function close()
	TweenClose:Play()
	TweenClose.Completed:Wait()
	door.Hitbox.close:Play()
	task.wait(0.4)
	cantoggle = true
	
	door.Hitbox.CanCollide = true
end

function open()
	door.Hitbox.CanCollide = false
	
	door.Hitbox.open:Play()
	TweenOpen:Play()
	TweenOpen.Completed:Wait()
	task.wait(0.4)
	cantoggle = true
end

Open.Changed:Connect(function()
	if Open.Value == true then
		open()
	else
		close()
	end
end)

door.Hitbox.ClickDetector.MouseClick:Connect(function()
	if cantoggle == true then
		cantoggle = false
		if Open.Value == true then
			Open.Value = false
		else
			Open.Value = true
		end
	end
end)

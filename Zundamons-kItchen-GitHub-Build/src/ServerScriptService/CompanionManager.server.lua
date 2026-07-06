-- [[Script] CompanionManager (ref: RBXA3D4133A29B940DFBEF7B3E9A3CDF820)]]
-- CompanionManager v4: config-driven catalog, mesh clone, LLM/VN integration
local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")

local CompanionConfig = require(RS.ConfigurationFiles.CompanionConfig)
local COMPANIONS = CompanionConfig.companions
local PlayerDataService = require(script.Parent.Services.PlayerDataService)
local CompanionStats = require(script.Parent.Services.CompanionStats)

local function getTemplateMesh(compType: string)
	local path = CompanionConfig.resolveMeshPath(compType)
	local obj: Instance = workspace
	for _, part in ipairs(path) do
		if not obj then
			return nil
		end
		obj = obj:FindFirstChild(part)
	end
	if not obj then
		return nil
	end
	return obj:FindFirstChildOfClass("MeshPart")
end

local RE = RS:WaitForChild("RemoteEvents")
local setCompEv = RE:WaitForChild("SetCompanion")
local vnEv = RE:FindFirstChild("OpenCompanionVN")
if not vnEv then
	vnEv = Instance.new("RemoteEvent")
	vnEv.Name = "OpenCompanionVN"
	vnEv.Parent = RE
end

local activeCompanions: { [string]: Model } = {}

local function buildCompanion(player: Player, compType: string)
	local def = CompanionConfig.getCompanion(compType)
	local modelName = "ZundaCompanion_" .. player.Name

	local existing = workspace:FindFirstChild(modelName)
	if existing then
		existing:Destroy()
	end
	local prev = activeCompanions[player.Name]
	if prev then
		pcall(function()
			prev:Destroy()
		end)
	end

	local model = Instance.new("Model")
	model.Name = modelName
	model.Parent = workspace

	local body
	local templateMesh = getTemplateMesh(compType)

	if templateMesh then
		body = templateMesh:Clone()
		body.Name = "Body"
		body.Size = body.Size * 0.85
		body.Anchored = false
		body.CanCollide = false
		body.CastShadow = false
		body.Massless = true
		for _, c in ipairs(body:GetChildren()) do
			if not c:IsA("SurfaceAppearance") then
				c:Destroy()
			end
		end
	else
		body = Instance.new("Part")
		body.Name = "Body"
		body.Shape = Enum.PartType.Ball
		body.Size = Vector3.new(3, 3, 3)
		body.Material = Enum.Material.SmoothPlastic
		body.Color = def.glow
		body.Anchored = false
		body.CanCollide = false
		body.CastShadow = false
		body.Massless = true
	end

	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	body.CFrame = hrp and (hrp.CFrame * CFrame.new(4, 1, 0)) or CFrame.new(47, 8, -74)
	body.Parent = model
	model.PrimaryPart = body

	local sparkle = Instance.new("ParticleEmitter", body)
	sparkle.Name = "CompanionSparkles"
	sparkle.Texture = "rbxassetid://241685484"
	sparkle.Rate = 10
	sparkle.LightEmission = 0.9
	sparkle.LightInfluence = 0.2
	sparkle.SpreadAngle = Vector2.new(180, 180)
	sparkle.Speed = NumberRange.new(1.5, 4)
	sparkle.Lifetime = NumberRange.new(0.6, 1.8)
	sparkle.RotSpeed = NumberRange.new(-180, 180)
	sparkle.Rotation = NumberRange.new(0, 360)
	local sc = def.sparkleColors
	sparkle.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, sc[1]),
		ColorSequenceKeypoint.new(0.5, sc[2]),
		ColorSequenceKeypoint.new(1, sc[3]),
	})
	sparkle.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.25),
		NumberSequenceKeypoint.new(0.4, 0.45),
		NumberSequenceKeypoint.new(1, 0),
	})
	sparkle.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.7, 0.3),
		NumberSequenceKeypoint.new(1, 1),
	})

	local pl = Instance.new("PointLight", body)
	pl.Brightness = 1.2
	pl.Range = def.glowRange
	pl.Color = def.glow
	Tween
		:Create(
			pl,
			TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ Brightness = 2.2 }
		)
		:Play()

	local sz = body.Size.Z / 2 + 0.2
	local faceBg = Instance.new("BillboardGui", body)
	faceBg.Name = "FaceBg"
	faceBg.Size = UDim2.new(0, 72, 0, 72)
	faceBg.StudsOffset = Vector3.new(0, 0, sz)
	faceBg.AlwaysOnTop = false
	faceBg.LightInfluence = 0.25
	local faceLabel = Instance.new("TextLabel", faceBg)
	faceLabel.Size = UDim2.new(1, 0, 1, 0)
	faceLabel.BackgroundTransparency = 1
	faceLabel.Text = def.emoji
	faceLabel.Font = Enum.Font.GothamBold
	faceLabel.TextSize = 42

	local halfH = body.Size.Y / 2 + 2.2
	local nameBg = Instance.new("BillboardGui", body)
	nameBg.Name = "NameTag"
	nameBg.Size = UDim2.new(0, 160, 0, 28)
	nameBg.StudsOffset = Vector3.new(0, halfH, 0)
	nameBg.AlwaysOnTop = false
	local pill = Instance.new("Frame", nameBg)
	pill.Size = UDim2.new(1, 0, 1, 0)
	pill.BackgroundColor3 = Color3.fromRGB(30, 24, 40)
	pill.BackgroundTransparency = 0.15
	pill.BorderSizePixel = 0
	Instance.new("UICorner", pill).CornerRadius = UDim.new(0.5, 0)
	local nLbl = Instance.new("TextLabel", pill)
	nLbl.Size = UDim2.new(1, -8, 1, 0)
	nLbl.Position = UDim2.new(0, 4, 0, 0)
	nLbl.BackgroundTransparency = 1
	nLbl.Text = player.Name .. "'s " .. def.displayName .. " ✨"
	nLbl.Font = Enum.Font.FredokaOne
	nLbl.TextSize = 12
	nLbl.TextColor3 = Color3.fromRGB(240, 230, 255)
	nLbl.TextXAlignment = Enum.TextXAlignment.Center

	local cd = Instance.new("ClickDetector", body)
	cd.MaxActivationDistance = 20
	local lastClick = 0
	cd.MouseClick:Connect(function(clicker)
		if clicker ~= player then
			return
		end
		local now = tick()
		if now - lastClick < 3 then
			return
		end
		lastClick = now
		sparkle.Rate = 60
		task.delay(0.6, function()
			if sparkle.Parent then
				sparkle.Rate = 10
			end
		end)
		CompanionStats.recordCompanionChat(player)
		vnEv:FireClient(player, compType, def.emoji)
	end)

	activeCompanions[player.Name] = model

	task.spawn(function()
		local t = 0
		while body and body.Parent and model.Parent do
			t += 0.05
			local char2 = player.Character
			local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
			if hrp2 then
				local floatY = math.sin(t * 1.1) * 0.7 + 1.8
				local sideOff = hrp2.CFrame.RightVector * (3.5 + math.sin(t * 0.3) * 0.4)
				local target = hrp2.Position + sideOff + Vector3.new(0, floatY, 0)
				local dist = (body.Position - target).Magnitude
				if dist > 0.3 then
					body.AssemblyLinearVelocity = (target - body.Position).Unit * math.min(dist * 5, 35)
				end
			end
			task.wait(0.05)
		end
	end)

	return model
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function()
		task.wait(2)
		local data = PlayerDataService.getOrCreate(player)
		buildCompanion(player, data.active_companion or "zundamon")
	end)
end

setCompEv.OnServerEvent:Connect(function(player, compType)
	if not COMPANIONS[compType] then
		return
	end
	local data = PlayerDataService.getOrCreate(player)
	local def = COMPANIONS[compType]
	if not def.free and not data["companion_owned_" .. compType] then
		return
	end
	data.active_companion = compType
	buildCompanion(player, compType)
end)

Players.PlayerAdded:Connect(onPlayerAdded)
for _, p in ipairs(Players:GetPlayers()) do
	onPlayerAdded(p)
end

Players.PlayerRemoving:Connect(function(player)
	local m = activeCompanions[player.Name]
	if m then
		m:Destroy()
		activeCompanions[player.Name] = nil
	end
end)

print("[CompanionManager v4] Config-driven companions + quest stat tracking ready")

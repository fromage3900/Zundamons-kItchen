-- DEPRECATED: Use UIConfig.lua instead. This file was merged into UIConfig.
-- Zundamon's Kitchen Design System Configuration

local DesignSystemConfig = {}

-- ============================================
-- COLOR PALETTE
-- ============================================
DesignSystemConfig.COLORS = {
	-- Primary Greens (cooking, success, positive actions)
	PrimaryGreen = Color3.fromRGB(124, 184, 124),
	PrimaryGreenLight = Color3.fromRGB(168, 212, 163),
	PrimaryGreenDark = Color3.fromRGB(92, 154, 92),
	PrimaryGreenDeep = Color3.fromRGB(62, 122, 62),
	
	-- Leaf Greens (nature, ingredients)
	LeafGreen = Color3.fromRGB(143, 201, 143),
	LeafGreenLight = Color3.fromRGB(184, 224, 184),
	LeafGreenDark = Color3.fromRGB(110, 175, 110),
	
	-- Wood Colors (warm, natural, secondary elements)
	WoodLight = Color3.fromRGB(212, 184, 150),
	WoodDefault = Color3.fromRGB(196, 180, 148),
	WoodDark = Color3.fromRGB(168, 144, 112),
	
	-- Background Colors
	CreamWhite = Color3.fromRGB(252, 248, 240),
	CreamLight = Color3.fromRGB(255, 250, 245),
	CreamDark = Color3.fromRGB(248, 240, 230),
	
	-- Text Colors
	TextPrimary = Color3.fromRGB(45, 45, 45),
	TextSecondary = Color3.fromRGB(77, 77, 77),
	TextTertiary = Color3.fromRGB(110, 110, 110),
	TextDisabled = Color3.fromRGB(144, 144, 144),
	TextWhite = Color3.fromRGB(255, 255, 255),
	
	-- Semantic Colors
	Success = Color3.fromRGB(125, 217, 125),
	Warning = Color3.fromRGB(255, 207, 80),
	Error = Color3.fromRGB(255, 120, 120),
	Info = Color3.fromRGB(120, 184, 248),
	
	-- Rarity Colors (for items, recipes, achievements)
	RarityCommon = Color3.fromRGB(168, 168, 168),
	RarityUncommon = Color3.fromRGB(125, 217, 125),
	RarityRare = Color3.fromRGB(120, 184, 248),
	RarityEpic = Color3.fromRGB(184, 159, 247),
	RarityLegendary = Color3.fromRGB(255, 207, 80),
	
	-- UI Element Colors
	PanelBackground = Color3.fromRGB(252, 248, 240),
	PanelBorder = Color3.fromRGB(180, 150, 110),
	ButtonPrimary = Color3.fromRGB(124, 184, 124),
	ButtonSecondary = Color3.fromRGB(212, 184, 150),
	InputBackground = Color3.fromRGB(255, 247, 247),
	InputBorder = Color3.fromRGB(224, 215, 199),
	
	-- Special Colors
	SparkleGold = Color3.fromRGB(255, 220, 90),
	SparkleGreen = Color3.fromRGB(120, 200, 130),
	ComboFire = Color3.fromRGB(255, 100, 80),
	ComboWarm = Color3.fromRGB(255, 180, 80),
}

-- ============================================
-- TYPOGRAPHY
-- ============================================
DesignSystemConfig.FONTS = {
	-- Primary font for headings and important text
	Title = Enum.Font.FredokaOne,
	
	-- Secondary font for body text and UI elements
	Heading = Enum.Font.GothamBold,
	
	-- Body text font
	Body = Enum.Font.Gotham,
	
	-- Small text, labels
	Label = Enum.Font.Gotham,
	
	-- Decorative font for special elements
	Decorative = Enum.Font.FredokaOne,
}

DesignSystemConfig.FONT_SIZES = {
	TitleLarge = 36,
	Title = 28,
	Heading = 20,
	Body = 16,
	Small = 14,
	Tiny = 12,
}

-- ============================================
-- SPACING
-- ============================================
DesignSystemConfig.SPACING = {
	Tiny = 4,
	Small = 8,
	Medium = 16,
	Large = 24,
	XLarge = 32,
	XXLarge = 48,
}

-- ============================================
-- BORDER RADIUS
-- ============================================
DesignSystemConfig.RADIUS = {
	Pill = 24,
	Large = 20,
	Medium = 16,
	Small = 12,
	Tiny = 8,
}

-- ============================================
-- SHADOWS/EFFECTS
-- ============================================
DesignSystemConfig.EFFECTS = {
	-- Button shadow
	ButtonShadow = {
		Color = Color3.fromRGB(0, 0, 0),
		Transparency = 0.85,
		Offset = Vector2.new(0, 4),
		Size = 12,
	},
	
	-- Panel shadow
	PanelShadow = {
		Color = Color3.fromRGB(0, 0, 0),
		Transparency = 0.9,
		Offset = Vector2.new(0, 8),
		Size = 16,
	},
	
	-- Glow effect for important elements
	Glow = {
		Color = Color3.fromRGB(124, 184, 124),
		Transparency = 0.7,
		Offset = Vector2.new(0, 0),
		Size = 8,
	},
}

-- ============================================
-- ANIMATION TIMING
-- ============================================
DesignSystemConfig.ANIMATION = {
	Fast = 0.15,
	Normal = 0.3,
	Slow = 0.5,
	Slowest = 0.8,
	
	-- Easing styles
	EaseIn = Enum.EasingStyle.Quad,
	EaseOut = Enum.EasingStyle.Quad,
	EaseInOut = Enum.EasingStyle.Quad,
	Bounce = Enum.EasingStyle.Back,
	Spring = Enum.EasingStyle.Elastic,
}

-- ============================================
-- COMPONENT SPECIFICATIONS
-- ============================================
DesignSystemConfig.COMPONENTS = {
	-- Buttons
	Button = {
		Height = 48,
		Padding = 24,
		BorderRadius = 24,
	},
	
	ButtonLarge = {
		Height = 56,
		Padding = 32,
		BorderRadius = 28,
	},
	
	ButtonSmall = {
		Height = 36,
		Padding = 16,
		BorderRadius = 18,
	},
	
	-- Inputs
	Input = {
		Height = 48,
		Padding = 16,
		BorderRadius = 12,
		BorderThickness = 2,
	},
	
	-- Cards
	Card = {
		BorderRadius = 16,
		Padding = 20,
		BorderThickness = 3,
	},
	
	-- Panels
	Panel = {
		BorderRadius = 22,
		Padding = 24,
		BorderThickness = 4,
	},
	
	-- Progress bars
	ProgressBar = {
		Height = 8,
		BorderRadius = 4,
	},
}

-- ============================================
-- GAME-SPECIFIC COLORS
-- ============================================
DesignSystemConfig.GAME_COLORS = {
	-- Cooking minigame
	CookingTrack = Color3.fromRGB(235, 255, 225),
	CookingTarget = Color3.fromRGB(180, 245, 190),
	CookingPerfect = Color3.fromRGB(255, 200, 80),
	CookingGreat = Color3.fromRGB(120, 220, 140),
	CookingGood = Color3.fromRGB(180, 180, 220),
	CookingMiss = Color3.fromRGB(220, 100, 110),
	
	-- HUD elements
	HUDBackground = Color3.fromRGB(40, 32, 60),
	HUDText = Color3.fromRGB(255, 255, 255),
	HUDAccent = Color3.fromRGB(120, 200, 130),
	
	-- Progress panel
	ProgressBackground = Color3.fromRGB(255, 248, 235),
	ProgressText = Color3.fromRGB(80, 55, 35),
	ProgressSub = Color3.fromRGB(140, 110, 80),
	ProgressAccent = Color3.fromRGB(180, 150, 110),
}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Get color with alpha transparency
function DesignSystemConfig.getColorWithAlpha(colorName, alpha)
	local color = DesignSystemConfig.COLORS[colorName]
	if not color then
		warn("DesignSystemConfig: Color '" .. colorName .. "' not found")
		return Color3.fromRGB(128, 128, 128)
	end
	return Color3.new(color.R, color.G, color.B, alpha)
end

-- Get font by name
function DesignSystemConfig.getFont(fontName)
	return DesignSystemConfig.FONTS[fontName] or Enum.Font.Gotham
end

-- Get font size by name
function DesignSystemConfig.getFontSize(sizeName)
	return DesignSystemConfig.FONT_SIZES[sizeName] or 16
end

-- Create a styled button frame
function DesignSystemConfig.createButton(parent, text, style)
	style = style or "primary"
	local config = DesignSystemConfig.COMPONENTS.Button
	
	local button = Instance.new("TextButton")
	button.Name = "StyledButton"
	button.Size = UDim2.new(0, 200, 0, config.Height)
	button.BackgroundColor3 = style == "primary" and DesignSystemConfig.COLORS.ButtonPrimary or DesignSystemConfig.COLORS.ButtonSecondary
	button.Text = text
	button.Font = DesignSystemConfig.FONTS.Heading
	button.TextSize = DesignSystemConfig.FONT_SIZES.Body
	button.TextColor3 = DesignSystemConfig.COLORS.TextWhite
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, config.BorderRadius)
	corner.Parent = button
	
	if parent then
		button.Parent = parent
	end
	
	return button
end

-- Create a styled panel frame
function DesignSystemConfig.createPanel(parent, size, position)
	local config = DesignSystemConfig.COMPONENTS.Panel
	
	local panel = Instance.new("Frame")
	panel.Name = "StyledPanel"
	panel.Size = size or UDim2.new(0, 400, 0, 300)
	panel.Position = position or UDim2.new(0.5, -200, 0.5, -150)
	panel.BackgroundColor3 = DesignSystemConfig.COLORS.PanelBackground
	panel.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, config.BorderRadius)
	corner.Parent = panel
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = DesignSystemConfig.COLORS.PanelBorder
	stroke.Thickness = config.BorderThickness
	stroke.Parent = panel
	
	if parent then
		panel.Parent = parent
	end
	
	return panel
end

-- Create a styled input frame
function DesignSystemConfig.createInput(parent, placeholder)
	local config = DesignSystemConfig.COMPONENTS.Input
	
	local input = Instance.new("TextBox")
	input.Name = "StyledInput"
	input.Size = UDim2.new(1, 0, 0, config.Height)
	input.BackgroundColor3 = DesignSystemConfig.COLORS.InputBackground
	input.PlaceholderText = placeholder or "Enter text..."
	input.PlaceholderColor3 = DesignSystemConfig.COLORS.TextDisabled
	input.Text = ""
	input.TextColor3 = DesignSystemConfig.COLORS.TextPrimary
	input.Font = DesignSystemConfig.FONTS.Body
	input.TextSize = DesignSystemConfig.FONT_SIZES.Body
	input.ClearTextOnFocus = false
	input.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, config.BorderRadius)
	corner.Parent = input
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = DesignSystemConfig.COLORS.InputBorder
	stroke.Thickness = config.BorderThickness
	stroke.Parent = input
	
	if parent then
		input.Parent = parent
	end
	
	return input
end

return DesignSystemConfig

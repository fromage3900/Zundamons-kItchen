--!strict
-- [[ModuleScript] UIConfig]]
-- Centralized design tokens for all UI elements.
-- Colors, typography, spacing, corner radii, and animation curves live here.

local UIConfig = {
	-- Brand colors
	COLORS = {
		Primary       = Color3.fromRGB(100, 200, 80),   -- Zundamon green
		PrimaryDark   = Color3.fromRGB(60, 140, 50),
		Secondary     = Color3.fromRGB(255, 200, 80),   -- Warm gold
		SecondaryDark = Color3.fromRGB(200, 150, 40),
		Accent        = Color3.fromRGB(120, 180, 255),   -- Sky blue
		Danger        = Color3.fromRGB(220, 60, 60),
		Warning       = Color3.fromRGB(240, 180, 40),
		Success       = Color3.fromRGB(80, 200, 100),

		-- Neutrals
		Background    = Color3.fromRGB(30, 25, 20),
		Surface       = Color3.fromRGB(50, 42, 35),
		SurfaceLight  = Color3.fromRGB(70, 60, 50),
		Border        = Color3.fromRGB(200, 180, 150),
		BorderDim     = Color3.fromRGB(100, 90, 75),

		-- Text
		TextPrimary   = Color3.fromRGB(255, 250, 240),
		TextSecondary = Color3.fromRGB(200, 190, 170),
		TextDisabled  = Color3.fromRGB(120, 110, 100),
		TextOnPrimary = Color3.fromRGB(20, 15, 10),
	},

	-- Transparency presets (0 = opaque, 1 = invisible)
	TRANSPARENCY = {
		Opaque      = 0,
		Panel       = 0.1,
		Overlay     = 0.3,
		Ghost       = 0.6,
		Invisible   = 1,
	},

	-- Typography
	FONTS = {
		Title    = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
		Heading  = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
		Body     = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
		Caption  = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
		Mono     = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular),
	},

	FONT_SIZES = {
		Title   = 28,
		Heading = 22,
		Body    = 16,
		Caption = 12,
		Button  = 18,
		Tooltip = 14,
	},

	-- Spacing scale (pixels)
	SPACING = {
		XS = 4,
		SM = 8,
		MD = 12,
		LG = 16,
		XL = 24,
		XXL = 32,
	},

	-- Corner radius
	CORNER_RADIUS = {
		None   = UDim.new(0, 0),
		Small  = UDim.new(0, 4),
		Medium = UDim.new(0, 8),
		Large  = UDim.new(0, 12),
		Pill   = UDim.new(0, 999),
		Circle = UDim.new(0.5, 0),
	},

	-- Stroke / border
	STROKE = {
		Thin   = 1,
		Normal = 2,
		Thick  = 3,
	},

	-- Animation durations (seconds)
	ANIMATION = {
		Instant  = 0,
		Fast     = 0.15,
		Normal   = 0.25,
		Slow     = 0.4,
		FadeIn   = 0.3,
		FadeOut  = 0.2,
		SlideIn  = 0.35,
	},

	-- Easing styles
	EASING = {
		Default  = Enum.EasingStyle.Quad,
		Bounce   = Enum.EasingStyle.Back,
		Smooth   = Enum.EasingStyle.Sine,
		Snappy   = Enum.EasingStyle.Exponential,
	},

	-- Standard component sizes
	SIZES = {
		ButtonHeight      = 44,
		ButtonMinWidth    = 120,
		IconSmall         = 24,
		IconMedium        = 36,
		IconLarge         = 48,
		ItemSlot          = 64,
		ProgressBarHeight = 24,
		ProgressBarWidth  = 200,
		TooltipMaxWidth   = 280,
		PanelMinWidth     = 300,
	},

	-- Z-index layers
	LAYERS = {
		Background  = 1,
		Content     = 10,
		Panel       = 20,
		Overlay     = 30,
		Modal       = 40,
		Tooltip     = 50,
		Notification = 60,
	},
}

return UIConfig

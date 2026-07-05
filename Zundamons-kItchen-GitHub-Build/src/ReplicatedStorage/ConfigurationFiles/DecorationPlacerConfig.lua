-- DecorationPlacerConfig: plot decoration placement rules.

local DecorationPlacerConfig = {}

DecorationPlacerConfig.MAX_PER_PLOT = 8
DecorationPlacerConfig.MODEL_FOLDER = "Decorations"
DecorationPlacerConfig.WORLD_FOLDER = "PlotDecorations"
DecorationPlacerConfig.PLACE_Y_OFFSET = 1.5

-- Slot offsets around plot center (XZ plane, studs from center).
DecorationPlacerConfig.SLOT_OFFSETS = {
	Vector3.new(-7, 0, -7),
	Vector3.new(0, 0, -7),
	Vector3.new(7, 0, -7),
	Vector3.new(-7, 0, 0),
	Vector3.new(7, 0, 0),
	Vector3.new(-7, 0, 7),
	Vector3.new(0, 0, 7),
	Vector3.new(7, 0, 7),
}

return DecorationPlacerConfig

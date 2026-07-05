-- PlotConfig: shared plot progression and world positions.

local PlotConfig = {}

PlotConfig.MAX_PLOTS = 4

PlotConfig.PLOT_REQUIREMENTS = { 1, 10, 25, 50 }

PlotConfig.PLOT_CENTERS = {
	[1] = Vector3.new(145, -509, -420),
	[2] = Vector3.new(165, -509, -420),
	[3] = Vector3.new(145, -509, -440),
	[4] = Vector3.new(165, -509, -440),
}

return PlotConfig

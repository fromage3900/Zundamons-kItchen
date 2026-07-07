--!strict
-- ArchitectureVariants: mesh and asset wiring for procedural architecture.
-- Use this config to resolve generated Roblox mesh IDs once assets are imported.

local ArchitectureVariants = {
	buildings = {
		MarketHall = {
			meshes = {
				MarketHall_01 = "rbxassetid://123291677534606",
				MarketHall_02 = "rbxassetid://136185276682595",
			},
		},
		BakeryStall = {
			meshes = {
				BakeryStall_01 = "rbxassetid://137235619082706",
			},
		},
	},

	street_props = {
		StreetLamp = {
			meshes = {
				StreetLamp_01 = "rbxassetid://87975976577216",
			},
		},
		Bench = {
			meshes = {
				Bench_01 = "rbxassetid://136635427702568",
			},
		},
	},

	interiors = {
		CounterIsland = {
			meshes = {
				CounterIsland_01 = "rbxassetid://98998809643433",
			},
		},
	},

	decor = {
		Balcony = {
			meshes = {
				Balcony_01 = "rbxassetid://135653097559455",
			},
		},
	},
}

return ArchitectureVariants

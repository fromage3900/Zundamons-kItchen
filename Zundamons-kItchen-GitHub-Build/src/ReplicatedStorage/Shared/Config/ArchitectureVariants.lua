--!strict
-- ArchitectureVariants: mesh and asset wiring for procedural architecture.
-- Use this config to resolve generated Roblox mesh IDs once assets are imported.

local ArchitectureVariants = {
	buildings = {
		MarketHall = {
			meshes = {
				MarketHall_01 = "rbxassetid://FILL_ASSET_ID_MARKETHALL_01",
				MarketHall_02 = "rbxassetid://FILL_ASSET_ID_MARKETHALL_02",
			},
		},
		BakeryStall = {
			meshes = {
				BakeryStall_01 = "rbxassetid://FILL_ASSET_ID_BAKERYSTALL_01",
			},
		},
	},

	street_props = {
		StreetLamp = {
			meshes = {
				StreetLamp_01 = "rbxassetid://FILL_ASSET_ID_STREETLAMP_01",
			},
		},
		Bench = {
			meshes = {
				Bench_01 = "rbxassetid://FILL_ASSET_ID_BENCH_01",
			},
		},
	},

	interiors = {
		CounterIsland = {
			meshes = {
				CounterIsland_01 = "rbxassetid://FILL_ASSET_ID_COUNTERISLAND_01",
			},
		},
	},

	decor = {
		Balcony = {
			meshes = {
				Balcony_01 = "rbxassetid://FILL_ASSET_ID_BALCONY_01",
			},
		},
	},
}

return ArchitectureVariants

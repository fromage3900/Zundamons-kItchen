--!strict
-- ArchitectureVariants: mesh and asset wiring for procedural architecture.

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

	foliage = {
		ZundaFlower = {
			meshes = {
				ZundaFlower_Default = "rbxassetid://130899236683010",
				ZundaFlower_Rare = "rbxassetid://86582218951352",
			},
		},
		BerryBush = {
			meshes = {
				BerryBush_Default = "rbxassetid://91224321091798",
				BerryBush_Ripe = "rbxassetid://74222048987638",
			},
		},
		ZundaMushroom = {
			meshes = {
				ZundaMushroom_Default = "rbxassetid://76322051780722",
				ZundaMushroom_Glow = "rbxassetid://96331224587968",
				ZundaMushroom_Tall = "rbxassetid://85124051974569",
			},
		},
	},
}

return ArchitectureVariants

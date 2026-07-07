--!strict
-- ArchitectureVariants: mesh and asset wiring for procedural architecture.
-- These entries reuse the Kenney-style imported asset IDs already present in the project.

local ArchitectureVariants = {
	buildings = {
		MarketHall = {
			meshes = {
<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
				MarketHall_01 = "rbxassetid://123291677534606",
				MarketHall_02 = "rbxassetid://136185276682595",
=======
				MarketHall_01 = "rbxassetid://113753628820808",
				MarketHall_02 = "rbxassetid://113753628820808",
>>>>>>> 18d8295 (Add procedural landscape biomes and preview scaffold):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
			},
		},
		BakeryStall = {
			meshes = {
<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
				BakeryStall_01 = "rbxassetid://137235619082706",
=======
				BakeryStall_01 = "rbxassetid://110290651922538",
>>>>>>> 18d8295 (Add procedural landscape biomes and preview scaffold):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
			},
		},
	},

	street_props = {
		StreetLamp = {
			meshes = {
<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
				StreetLamp_01 = "rbxassetid://87975976577216",
=======
				StreetLamp_01 = "rbxassetid://91041813069462",
>>>>>>> 18d8295 (Add procedural landscape biomes and preview scaffold):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
			},
		},
		Bench = {
			meshes = {
<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
				Bench_01 = "rbxassetid://136635427702568",
=======
				Bench_01 = "rbxassetid://94125444857929",
>>>>>>> 18d8295 (Add procedural landscape biomes and preview scaffold):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
			},
		},
	},

	interiors = {
		CounterIsland = {
			meshes = {
<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
				CounterIsland_01 = "rbxassetid://98998809643433",
=======
				CounterIsland_01 = "rbxassetid://128478553136178",
>>>>>>> 18d8295 (Add procedural landscape biomes and preview scaffold):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
			},
		},
	},

	decor = {
		Balcony = {
			meshes = {
<<<<<<< HEAD:src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
				Balcony_01 = "rbxassetid://135653097559455",
=======
				Balcony_01 = "rbxassetid://85728145615215",
>>>>>>> 18d8295 (Add procedural landscape biomes and preview scaffold):Zundamons-kItchen-GitHub-Build/src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua
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
				BerryBush_01 = "rbxassetid://91224321091798",
				BerryBush_02 = "rbxassetid://74222048987638",
				BerryBush_03 = "rbxassetid://76322051780722",
			},
		},
		ZundaMushroom = {
			meshes = {
				Mushroom_01 = "rbxassetid://96331224587968",
				Mushroom_02 = "rbxassetid://85124051974569",
			},
		},
	},
}

return ArchitectureVariants

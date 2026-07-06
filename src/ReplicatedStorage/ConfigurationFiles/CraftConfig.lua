-- [[ModuleScript] CraftConfig (ref: RBXA87A5A8ED1144C28AF3B367DE07C83A3)]]
local craft = {}

craft.recipes = {
	-- Tier 1: Starter recipes
	["Apple Pie"] = {["Apple"] = 3, ["Wheat"] = 5},
	["Bread"] = {["Wheat"] = 10},
	
	-- Tier 2: Intermediate recipes (unlock after 5 guests)
	["Zunda Bread"] = {["Wheat"] = 15, ["Apple"] = 2},
	["Royal Stew"] = {["Wheat"] = 8, ["Apple"] = 5, ["Gold"] = 1}, -- uses 1 gold as premium ingredient
	["Zunda Mochi"] = {["Zunda Pea"] = 5, ["Wheat"] = 8}, -- NEW: Zunda specialty!
	["Edamame Snack"] = {["Edamame Pod"] = 3, ["Zunda Leaf"] = 2}, -- NEW
	
	-- Tier 3: Advanced recipes (unlock after 20 guests)
	["Fancy Pie"] = {["Apple"] = 7, ["Wheat"] = 12, ["Gold"] = 2},
	["Zundamon's Banquet"] = {["Wheat"] = 20, ["Apple"] = 10, ["Gold"] = 3},
	["Sweet Pea Cake"] = {["Sweet Pea"] = 4, ["Wheat"] = 10, ["Zunda Pea"] = 3}, -- NEW
	["Pea Flower Tea"] = {["Pea Flower"] = 5, ["Zunda Leaf"] = 3}, -- NEW
	
	-- Tier 4: Expert recipe (unlock after 50 guests)
	["Ultimate Feast"] = {["Wheat"] = 30, ["Apple"] = 20, ["Gold"] = 5},
	["Zunda Paradise"] = {["Zunda Pea"] = 15, ["Edamame Pod"] = 10, ["Sweet Pea"] = 5, ["Pea Flower"] = 3} -- NEW: Ultimate Zunda dish!
}

-- Cooking time multipliers (for timed cooking mechanic)
craft.cookingTimes = {
	["Apple Pie"] = 5,
	["Bread"] = 4,
	["Zunda Bread"] = 6,
	["Royal Stew"] = 8,
	["Zunda Mochi"] = 7,
	["Edamame Snack"] = 3,
	["Fancy Pie"] = 10,
	["Zundamon's Banquet"] = 12,
	["Sweet Pea Cake"] = 9,
	["Pea Flower Tea"] = 4,
	["Ultimate Feast"] = 15,
	["Zunda Paradise"] = 20
}

return craft

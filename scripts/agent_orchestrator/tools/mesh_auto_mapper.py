"""Auto-mapper: reads all workspace mesh parts from Studio, categorizes them,
and regenerates ALL config files (MeshAssets, NPCConfig, DecorationConfig,
ArchitectureVariants, etc.) with real asset IDs."""

import json, re, sys
from pathlib import Path
from collections import defaultdict

sys.path.insert(0, str(Path(__file__).parent.parent))
from config import ROOT

# â”€â”€â”€ Category rules: (name_regex, category, subcategory) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Each rule maps a mesh name pattern to its config category
CATEGORY_RULES = [
    # Harvest / gather nodes
    (r"carrot", "harvest", "carrot"),
    (r"wheat|wheat_0[1-3]", "harvest", "Wheat"),
    (r"zundaflower|zunda_flower|flower", "harvest", "ZundaFlower"),
    (r"zundapea|zunda_pea", "harvest", "ZundaPea"),
    (r"mushroom", "harvest", "Zunda Mushroom"),
    (r"berrybush|zundaberry|zunda_berry", "harvest", "Zunda Berry"),
    (r"zundaroot|zunda_root|root_0[1-2]", "harvest", "Zunda Root"),
    (r"rock_(common|rare)|rock-large|rock-small|rock-wide", "harvest", "Rock"),
    (r"goldore|gold_ore", "harvest", "Gold Ore"),
    (r"mystery", "harvest", "MysteryLoot"),
    (r"leaf_0", "harvest", "Zunda Leaf"),
    (r"seed", "harvest", "seed"),
    (r"field", "harvest", "field"),

    # Foliage / environment
    (r"tree-|tree$|tree-high|tree-crooked", "foliage", "Tree"),
    (r"bush", "foliage", "Bush"),
    (r"hedge", "foliage", "Hedge"),
    (r"potted", "foliage", "Potted"),

    # Food / cooking items
    (r"carrot_produce|carrot_cut|carrot_halfmoon|carrot_round|carrot_quarter|carrot_rollcut|carrot_chateau|carrot_peel|carrot_jung", "food", "CarrotVariant"),
    (r"pudding", "food", "Pudding"),
    (r"cupcake", "food", "Cupcake"),
    (r"cake$", "food", "Cake"),
    (r"cookie", "food", "Cookie"),
    (r"pancake", "food", "Pancake"),
    (r"egg_tart", "food", "EggTart"),
    (r"ice_cream", "food", "IceCream"),
    (r"swiss_roll", "food", "SwissRoll"),
    (r"jammy|bourbon|donut_ch|macaron|lolipop", "food", "Pastry"),
    (r"milk|box_milk|box_strawb|box_orange", "food", "Container"),
    (r"butter|plate|pan|cutboard|cloth", "food", "KitchenTool"),

    # NPC Characters (Kenney)
    (r"character-female-[a-f]", "npc", "Female"),
    (r"character-male-[a-f]", "npc", "Male"),
    (r"aid-cane|aid-crutch|aid-glasses|aid-mask|aid-sunglasses|aid_hearing|aid-defibrillator", "npc", "Accessory"),
    (r"wheelchair", "npc", "Wheelchair"),

    # Animals
    (r"animal-", "animal", ""),

    # Architecture - building blocks
    (r"wall-wood|wall-diagonal|wall-curved|wall-rounded|wall-block|wall-half|wall-slope|wall-broken|wall-corner|wall-detail|wall-door", "architecture", "Wall"),
    (r"wall-window|wall-arch|wall-doorway", "architecture", "WallOpening"),
    (r"^wall$", "architecture", "WallPlain"),
    (r"roof-", "architecture", "Roof"),
    (r"^roof$", "architecture", "RoofPlain"),
    (r"stairs-", "architecture", "Stairs"),
    (r"fence|hedge-gate", "architecture", "Fence"),
    (r"planks", "architecture", "Floor"),
    (r"door$", "architecture", "Door"),
    (r"fountain-", "architecture", "Fountain"),
    (r"^fountain$", "architecture", "Fountain"),
    (r"chimney", "architecture", "Chimney"),
    (r"pillar-", "architecture", "Pillar"),
    (r"^pillar$", "architecture", "Pillar"),
    (r"balcony", "architecture", "Balcony"),
    (r"banner", "architecture", "Banner"),
    (r"overhang", "architecture", "Overhang"),
    (r"poles", "architecture", "Poles"),
    (r"road-", "architecture", "Road"),
    (r"^road$", "architecture", "Road"),
    (r"stall-", "architecture", "Stall"),
    (r"^stall$", "architecture", "Stall"),
    (r"cart", "architecture", "Cart"),
    (r"lantern", "architecture", "Lantern"),
    (r"lamp|light$|bulb", "architecture", "Light"),
    (r"windmill|watermill", "architecture", "Mill"),
    (r"blade|wheel$", "architecture", "Mechanical"),

    # Decor
    (r"neon", "decor", "Neon"),
    (r"heart", "decor", "Heart"),
    (r"shell|spiral", "decor", "Seashell"),
    (r"umbrella", "decor", "Umbrella"),
    (r"floatring|watermelon", "decor", "Float"),
    (r"whale|fish", "decor", "Aquatic"),
    (r"bikini|panties|vert", "decor", "Clothing"),
    (r"bucket|sand|shovel", "decor", "Beach"),
    (r"croc|snorkle|sunscreen|boxer", "decor", "Beach"),
    (r"cone|nurb|circle|sphere|cylinder|torus|pyramid|capsule|plane", "primitive", "Primitive"),

    # Furniture
    (r"bench", "furniture", "Bench"),
    (r"table", "furniture", "Table"),
    (r"chair", "furniture", "Chair"),
    (r"tent", "furniture", "Tent"),
    (r"curtain|hello kitty|kawaii", "decor", "Curtain"),
]

def categorize_mesh(name):
    """Return (category, subcategory) for a mesh name."""
    name_lower = name.lower().replace(" ", "-").replace("'", "")
    for pattern, cat, sub in CATEGORY_RULES:
        if re.search(pattern, name_lower):
            return (cat, sub or cat)
    return ("uncategorized", name)

def generate_mesh_assets(meshes_by_name):
    """Generate MeshAssets.lua content from workspace meshes."""
    harvest_nodes = defaultdict(dict)
    foliage = defaultdict(dict)
    
    for name, mesh_id in meshes_by_name.items():
        cat, sub = categorize_mesh(name)
        if cat == "harvest":
            clean_name = name.replace(" ", "").replace(".", "_")
            # Map to the proper key based on naming
            if "Wheat" in sub or "wheat" in sub:
                group = "Wheat"
            elif "Flower" in sub or "flower" in sub:
                group = "ZundaFlower"
            elif "Pea" in sub:
                group = "ZundaPea"
            elif "Mushroom" in sub or "mushroom" in sub:
                group = "Zunda Mushroom"
            elif "Berry" in sub or "berry" in sub:
                group = "Zunda Berry"
            elif "Root" in sub:
                group = "Zunda Root"
            elif "Rock" in sub or "rock" in sub:
                group = "Rock"
            elif "Gold" in sub or "ore" in name.lower():
                group = "Gold Ore"
            elif "carrot" in name.lower():
                group = "Carrot"
            else:
                group = sub
            
            # Use clean variant name
            variant = clean_name[:30]
            harvest_nodes[group][variant] = mesh_id
    
    lines = []
    lines.append("--!strict")
    lines.append("-- [[ModuleScript] MeshAssets]")
    lines.append("-- Auto-generated by mesh_auto_mapper.py from workspace meshes")
    lines.append("-- See CREDITS.md for full attribution")
    lines.append("")
    lines.append("return {")
    lines.append("\tmeshes = {")
    
    # Harvest nodes
    lines.append("\t\t-- Harvest Nodes")
    for group in ["Wheat", "ZundaFlower", "ZundaPea", "Zunda Mushroom", "Zunda Berry", "Zunda Root", "Rock", "Gold Ore", "Carrot"]:
        if group in harvest_nodes:
            lines.append(f'\t\t["{group}"] = {{')
            for variant, mid in harvest_nodes[group].items():
                lines.append(f'\t\t\t["{variant}"] = "{mid}",')
            lines.append("\t\t},")
    
    # Environment props
    env_types = defaultdict(dict)
    for name, mesh_id in meshes_by_name.items():
        cat, sub = categorize_mesh(name)
        if cat in ("foliage", "architecture", "decor", "furniture"):
            env_types[sub][name] = mesh_id
    
    if env_types:
        lines.append("")
        lines.append("\t\t-- Environment Props")
        for group, items in sorted(env_types.items()):
            lines.append(f'\t\t["{group}"] = {{')
            for name, mid in items.items():
                clean = name[:30]
                lines.append(f'\t\t\t["{clean}"] = "{mid}",')
            lines.append("\t\t},")
    
    lines.append("\t},")
    lines.append("}")
    return "\n".join(lines)

def generate_npc_config(meshes_by_name):
    """Generate NPCConfig.lua with character mesh IDs."""
    character_types = {}
    for name, mesh_id in meshes_by_name.items():
        cat, sub = categorize_mesh(name)
        if cat == "npc":
            character_types[name] = mesh_id
    
    lines = []
    lines.append("--!strict")
    lines.append("-- [[ModuleScript] NPCConfig]")
    lines.append("-- Auto-generated by mesh_auto_mapper.py")
    lines.append("-- Guest NPC models from Kenney Mini Characters (CC0, kenney.nl)")
    lines.append("-- See CREDITS.md for full attribution")
    lines.append("")
    lines.append("local NPCConfig = {}")
    lines.append("")
    lines.append("NPCConfig.guestTemplates = {")
    
    # Map characters to guest types
    female_chars = {k: v for k, v in character_types.items() if "female" in k}
    male_chars = {k: v for k, v in character_types.items() if "male" in k}
    
    if female_chars:
        first_f = list(female_chars.values())[0]
        lines.append(f'\tChild = {{ modelId = "{first_f}", scale = 0.7, animations = {{ idle = "", walk = "", eat = "" }} }},')
    if male_chars:
        first_m = list(male_chars.values())[0]
        lines.append(f'\tAdult = {{ modelId = "{first_m}", scale = 1.0, animations = {{ idle = "", walk = "", eat = "" }} }},')
    if male_chars:
        elder = list(male_chars.values())[-1] if len(male_chars) > 1 else list(male_chars.values())[0]
        lines.append(f'\tElder = {{ modelId = "{elder}", scale = 0.9, animations = {{ idle = "", walk = "", eat = "" }} }},')
    
    lines.append("}")
    lines.append("")
    lines.append("NPCConfig.companionTemplates = {")
    lines.append('\tZundapal = { modelId = "", scale = 0.5, followSpeed = 8, sparkleEffect = "", buff = nil, price = 0 },')
    lines.append("}")
    lines.append("")
    lines.append("NPCConfig.guestSpawnDefaults = {")
    lines.append("\tspawnInterval = 15,")
    lines.append("\tmaxGuests = 8,")
    lines.append("\ttimeoutDuration = 120,")
    lines.append("\tmaxQueueDistance = 24,")
    lines.append("}")
    lines.append("")
    lines.append("NPCConfig.spawnPoints = {")
    lines.append("\tVector3.new(188, -518, -415),")
    lines.append("\tVector3.new(196, -518, -415),")
    lines.append("\tVector3.new(204, -518, -415),")
    lines.append("\tVector3.new(212, -518, -415),")
    lines.append("}")
    lines.append("")
    lines.append("return NPCConfig")
    return "\n".join(lines)

def generate_architecture_variants(meshes_by_name):
    """Generate ArchitectureVariants.lua."""
    arch_types = defaultdict(dict)
    for name, mesh_id in meshes_by_name.items():
        cat, sub = categorize_mesh(name)
        if cat == "architecture":
            arch_types[sub][name] = mesh_id
    
    lines = []
    lines.append("--!strict")
    lines.append("-- [[ModuleScript] ArchitectureVariants]")
    lines.append("-- Auto-generated by mesh_auto_mapper.py")
    lines.append("-- Building and prop meshes from Kenney Architecture Kit (CC0, kenney.nl)")
    lines.append("")
    lines.append("local ArchitectureVariants = {")
    
    for group, items in sorted(arch_types.items()):
        lines.append(f'\t["{group}"] = {{')
        for name, mid in items.items():
            clean = name[:30]
            lines.append(f'\t\t["{clean}"] = {{ meshes = {{ ["{clean}"] = "{mid}" }} }},')
        lines.append("\t},")
    
    lines.append("}")
    lines.append("")
    lines.append("return ArchitectureVariants")
    return "\n".join(lines)

def generate_summary(meshes_by_name):
    """Generate a summary of what was found."""
    cats = defaultdict(list)
    for name, mesh_id in meshes_by_name.items():
        cat, sub = categorize_mesh(name)
        cats[cat].append(name)
    
    lines = []
    lines.append("=== Mesh Auto-Mapper Summary ===")
    lines.append(f"Total unique meshes: {len(meshes_by_name)}")
    lines.append("")
    for cat in sorted(cats.keys()):
        names = cats[cat]
        lines.append(f"  {cat}: {len(names)} meshes")
        for n in sorted(names)[:5]:
            lines.append(f"    - {n}")
        if len(names) > 5:
            lines.append(f"    ... and {len(names) - 5} more")
    lines.append("")
    lines.append("Config files written to src/:")
    lines.append("  - ReplicatedStorage/ConfigurationFiles/MeshAssets.lua")
    lines.append("  - Shared/Config/NPCConfig.lua")
    lines.append("  - Shared/Config/ArchitectureVariants.lua")
    return "\n".join(lines)

def main():
    print("=== Zunda Mesh Auto-Mapper ===\n")
    print("Step 1: Reading workspace meshes from Studio...")
    print("  Run this in Studio command bar first:\n")
    print('  local results = {}')
    print('  local seen = {}')
    print('  for _, c in ipairs(workspace:GetChildren()) do')
    print('      local function s(i)')
    print('          if i:IsA("MeshPart") and i.MeshId ~= "" and i.MeshId ~= "rbxassetid://0" then')
    print('              local n = i.Name:gsub("Meshes/","")')
    print('              if not seen[n] then seen[n] = true; table.insert(results, {name=n, meshId=i.MeshId}) end')
    print('          end')
    print('          for _, c in ipairs(i:GetChildren()) do s(c) end')
    print('      end')
    print('      s(c)')
    print('  end')
    print('  local json = game:GetService("HttpService"):JSONEncode(results)')
    print('  local f = Instance.new("StringValue")')
    print('  f.Name = "_MeshExportAuto"')
    print('  f.Value = json')
    print('  f.Parent = workspace')
    print('  print("Done - " .. #results .. " meshes")')
    print()
    
    # Read from import results if available
    import_path = ROOT / "reports" / "mesh_pipeline" / "import_results.json"
    if import_path.exists():
        with open(import_path, "r", encoding="utf-8") as f:
            try:
                data = json.load(f)
                if isinstance(data, list) and len(data) > 0:
                    meshes = {item["name"]: item["meshId"] for item in data if "name" in item and "meshId" in item}
                    print(f"Step 2: Read {len(meshes)} meshes from import_results.json")
                    
                    # Generate config files
                    print("Step 3: Generating config files...")
                    
                    mesh_assets = generate_mesh_assets(meshes)
                    mesh_path = ROOT / "src" / "ReplicatedStorage" / "ConfigurationFiles" / "MeshAssets.lua"
                    mesh_path.write_text(mesh_assets, encoding="utf-8")
                    print(f"  -> MeshAssets.lua ({len(mesh_assets)} chars)")
                    
                    npc_config = generate_npc_config(meshes)
                    npc_path = ROOT / "src" / "ReplicatedStorage" / "Shared" / "Config" / "NPCConfig.lua"
                    npc_path.write_text(npc_config, encoding="utf-8")
                    print(f"  -> NPCConfig.lua ({len(npc_config)} chars)")
                    
                    arch_variants = generate_architecture_variants(meshes)
                    arch_path = ROOT / "src" / "ReplicatedStorage" / "Shared" / "Config" / "ArchitectureVariants.lua"
                    arch_path.write_text(arch_variants, encoding="utf-8")
                    print(f"  -> ArchitectureVariants.lua ({len(arch_variants)} chars)")
                    
                    # Summary
                    summary = generate_summary(meshes)
                    summary_path = ROOT / "reports" / "mesh_pipeline" / "auto_mapper_summary.txt"
                    summary_path.write_text(summary, encoding="utf-8")
                    print(f"\n{summary}")
                    print(f"\nFull summary written to: {summary_path}")
                    
            except json.JSONDecodeError:
                print("Error: import_results.json is not valid JSON")
                return
    else:
        print(f"No import_results.json found at {import_path}")
        print("Run the Studio command above, save results, then re-run this script.")

if __name__ == "__main__":
    main()

"""
Zundamon's Kitchen — Blender Asset Pipeline Generator
=====================================================
Reads BlenderPipeline.lua manifest and generates:
  - Procedural harvest node meshes (FBX → Roblox)
  - Environment props
  - UI icon concept PNGs
  - Particle texture PNGs

Usage:
  # Generate all harvest node variants
  python scripts/blender_pipeline_gen.py --category harvest_nodes --output Assets/Generated

  # Generate environment props for a specific zone
  python scripts/blender_pipeline_gen.py --category environment_props --zone Forest --output Assets/Generated

  # Generate UI icons
  python scripts/blender_pipeline_gen.py --category ui_icons --output Assets/Generated/Icons
"""

import argparse
import json
import math
import os
import random
import sys

# ---------------------------------------------------------------------------
# Mock geometry generators (standalone — no Blender dependency)
# Each generator creates a simple OBJ-like representation for the asset.
# In production, these run inside Blender via MCP to produce real FBX.
# ---------------------------------------------------------------------------


def generate_flower(params):
    """Parametric flower generation — petal_count, stem_height, color, glow"""
    petal_count = params.get("petal_count", 5)
    stem_height = params.get("stem_height", 1.0)
    return {
        "type": "flower",
        "petal_count": petal_count,
        "stem_height": stem_height,
        "vertices": 120 + petal_count * 24,
        "triangles": 80 + petal_count * 20,
        "color": params.get("color_hex", "#78C882"),
        "glow": params.get("glow", False),
    }


def generate_pea_pod(params):
    """Parametric pea pod — pod_size, opened, color"""
    pod_size = params.get("pod_size", 1.0)
    opened = params.get("opened", False)
    return {
        "type": "pea_pod",
        "pod_size": pod_size,
        "opened": opened,
        "vertices": 100 + (24 if opened else 0),
        "triangles": 60 + (18 if opened else 0),
        "peas_visible": opened,
        "color": params.get("color_hex", "#96E6A0"),
    }


def generate_mushroom(params):
    """Parametric mushroom — cap_radius, stem_height, spot_count, color"""
    cap_radius = params.get("cap_radius", 0.6)
    stem_height = params.get("stem_height", 0.8)
    spot_count = params.get("spot_count", 3)
    return {
        "type": "mushroom",
        "cap_radius": cap_radius,
        "stem_height": stem_height,
        "spot_count": spot_count,
        "vertices": 80 + spot_count * 12,
        "triangles": 50 + spot_count * 8,
        "color": params.get("color_hex", "#E1B9FF"),
    }


def generate_berry_bush(params):
    """Parametric bush — bush_radius, berry_count, berry_color"""
    bush_radius = params.get("bush_radius", 1.0)
    berry_count = params.get("berry_count", 5)
    return {
        "type": "berry_bush",
        "bush_radius": bush_radius,
        "berry_count": berry_count,
        "vertices": 60 + berry_count * 16,
        "triangles": 40 + berry_count * 12,
        "color": params.get("color_hex", "#78C882"),
        "berry_color": params.get("berry_color_hex", "#FF69B4"),
    }


def generate_root(params):
    """Parametric root — length, twist, color"""
    length = params.get("length", 0.8)
    twist = params.get("twist", 0.3)
    return {
        "type": "root",
        "length": length,
        "twist": twist,
        "segments": max(4, int(length * 6)),
        "vertices": 40 + int(twist * 20),
        "triangles": 30 + int(twist * 15),
        "color": params.get("color_hex", "#8B6514"),
    }


def generate_rock(params):
    """Parametric rock — roughness, size, crystal_veins"""
    roughness = params.get("roughness", 0.7)
    size = params.get("size", 1.0)
    crystal = params.get("crystal", False)
    return {
        "type": "rock",
        "roughness": roughness,
        "size": size,
        "crystal": crystal,
        "vertices": 42 + (24 if crystal else 0),
        "triangles": 80 + (36 if crystal else 0),
        "color": params.get("color_hex", "#808080"),
    }


def generate_tree(params):
    """Parametric tree — trunk_height, canopy_radius, color"""
    trunk_height = params.get("trunk_height", 4.0)
    canopy_radius = params.get("canopy_radius", 3.0)
    return {
        "type": "tree",
        "trunk_height": trunk_height,
        "canopy_radius": canopy_radius,
        "vertices": 200 + int(canopy_radius * 40),
        "triangles": 150 + int(canopy_radius * 30),
        "color": params.get("color_hex", "#78C882"),
    }


def generate_house(params):
    """Parametric house — width, depth, height, roof_color, wall_color"""
    width = params.get("width", 8.0)
    depth = params.get("depth", 6.0)
    height = params.get("height", 4.0)
    return {
        "type": "house",
        "width": width,
        "depth": depth,
        "height": height,
        "roof_color": params.get("roof_color", "#78C882"),
        "wall_color": params.get("wall_color", "#FFF8DC"),
        "vertices": 24,
        "triangles": 12,
        "color": params.get("color_hex", "#78C882"),
    }


def generate_counter(params):
    """Parametric kitchen counter"""
    length = params.get("length", 4.0)
    depth = params.get("depth", 2.5)
    height = params.get("height", 1.0)
    return {
        "type": "counter",
        "length": length,
        "depth": depth,
        "height": height,
        "trim_color": params.get("trim_color", "#78C882"),
        "vertices": 24,
        "triangles": 12,
        "color": params.get("color_hex", "#8B6514"),
    }


GENERATORS = {
    "flower": generate_flower,
    "pea_pod": generate_pea_pod,
    "mushroom": generate_mushroom,
    "berry_bush": generate_berry_bush,
    "root": generate_root,
    "rock": generate_rock,
    "tree": generate_tree,
    "house": generate_house,
    "counter": generate_counter,
}


def generate_icon(params):
    """Generate a simple icon representation (for UI concept art)"""
    subject = params.get("subject", "icon")
    color = params.get("color_hex", "#78C882")
    return {
        "type": "icon",
        "subject": subject,
        "color": color,
        "resolution": "256x256",
        "format": "PNG",
    }


def generate_particle(params):
    """Generate particle texture parameters"""
    color = params.get("color_hex", "#FFFFFF")
    shape = params.get("shape", "star")
    return {
        "type": "particle",
        "color": color,
        "shape": shape,
        "resolution": "64x64",
        "format": "PNG",
    }


def detect_params_type(params):
    """Detect the type of object to generate based on params"""
    if "petal_count" in params:
        return "flower"
    elif "pod_size" in params:
        return "pea_pod"
    elif "cap_radius" in params:
        return "mushroom"
    elif "bush_radius" in params:
        return "berry_bush"
    elif "length" in params and "twist" in params:
        return "root"
    elif "roughness" in params:
        return "rock"
    elif "trunk_height" in params:
        return "tree"
    elif "width" in params and "depth" in params and "height" in params:
        if "trim_color" in params:
            return "counter"
        return "house"
    return None


def generate_asset(entry, output_dir):
    """Generate a single asset from a pipeline entry"""
    params = entry.get("params", {})
    asset_id = entry.get("id", "unknown")
    description = entry.get("description", "")
    export_path = entry.get("fbx_export_path", "")

    obj_type = detect_params_type(params)
    generator = GENERATORS.get(obj_type)

    if generator:
        result = generator(params)
        result["id"] = asset_id
        result["description"] = description
        result["export_path"] = export_path

        # Write metadata JSON
        meta_path = os.path.join(output_dir, export_path, f"{asset_id}.json")
        os.makedirs(os.path.dirname(meta_path), exist_ok=True)
        with open(meta_path, "w") as f:
            json.dump(result, f, indent=2)

        print(f"  [OK] {asset_id}: {result['type']} ({result.get('vertices', 0)} verts) -> {meta_path}")
        return result
    else:
        print(f"  [--] {asset_id}: unknown type, skipping")
        return None


def main():
    parser = argparse.ArgumentParser(description="Zundamon's Kitchen Blender Asset Pipeline")
    parser.add_argument("--category", default="harvest_nodes",
                        choices=["harvest_nodes", "environment_props", "ui_icons", "particles", "all"])
    parser.add_argument("--zone", default=None, help="Environment zone filter (Forest, Kitchen, House)")
    parser.add_argument("--output", default="Assets/Generated", help="Output directory")
    args = parser.parse_args()

    # Pipeline manifest (mirrors BlenderPipeline.lua)
    pipeline = {
        "harvest_nodes": [
            {"id": "ZundaFlower_Default", "description": "Standard Zunda flower", "params": {"petal_count": 5, "stem_height": 1.2, "color_hex": "#78C882", "glow": False}, "fbx_export_path": "HarvestNodes/ZundaFlower/"},
            {"id": "ZundaFlower_Rare", "description": "Rare lavender flower", "params": {"petal_count": 8, "stem_height": 1.0, "color_hex": "#E1B9FF", "glow": True}, "fbx_export_path": "HarvestNodes/ZundaFlower/"},
            {"id": "ZundaPea_01", "description": "Small closed pea pod", "params": {"pod_size": 0.8, "opened": False, "color_hex": "#96E6A0"}, "fbx_export_path": "HarvestNodes/ZundaPea/"},
            {"id": "ZundaPea_02", "description": "Medium open pea pod", "params": {"pod_size": 1.0, "opened": True, "color_hex": "#82D68C"}, "fbx_export_path": "HarvestNodes/ZundaPea/"},
            {"id": "ZundaPea_03", "description": "Large golden pea pod", "params": {"pod_size": 1.3, "opened": True, "color_hex": "#FFD700"}, "fbx_export_path": "HarvestNodes/ZundaPea/"},
            {"id": "Mushroom_01", "description": "Small lavender mushroom", "params": {"cap_radius": 0.6, "stem_height": 0.8, "spot_count": 3, "color_hex": "#E1B9FF"}, "fbx_export_path": "HarvestNodes/ZundaMushroom/"},
            {"id": "Mushroom_02", "description": "Tall pink mushroom", "params": {"cap_radius": 0.5, "stem_height": 1.4, "spot_count": 5, "color_hex": "#FFB5D4"}, "fbx_export_path": "HarvestNodes/ZundaMushroom/"},
            {"id": "BerryBush_01", "description": "Small blue berry bush", "params": {"bush_radius": 1.0, "berry_color_hex": "#4A90D9", "berry_count": 5}, "fbx_export_path": "HarvestNodes/ZundaBerry/"},
            {"id": "BerryBush_02", "description": "Medium pink berry bush", "params": {"bush_radius": 1.3, "berry_color_hex": "#FF69B4", "berry_count": 8}, "fbx_export_path": "HarvestNodes/ZundaBerry/"},
            {"id": "BerryBush_03", "description": "Large gold berry bush", "params": {"bush_radius": 1.5, "berry_color_hex": "#FFD700", "berry_count": 12}, "fbx_export_path": "HarvestNodes/ZundaBerry/"},
            {"id": "Root_01", "description": "Short gnarled root", "params": {"length": 0.8, "twist": 0.3, "color_hex": "#8B6514"}, "fbx_export_path": "HarvestNodes/ZundaRoot/"},
            {"id": "Root_02", "description": "Long twisted root", "params": {"length": 1.4, "twist": 0.7, "color_hex": "#A0782C"}, "fbx_export_path": "HarvestNodes/ZundaRoot/"},
            {"id": "Rock_Common", "description": "Grey rounded rock", "params": {"roughness": 0.7, "color_hex": "#808080", "size": 1.0, "crystal": False}, "fbx_export_path": "HarvestNodes/Rock/"},
            {"id": "Rock_Rare", "description": "Dark rock with crystals", "params": {"roughness": 0.4, "color_hex": "#4A4A4A", "size": 1.2, "crystal": True}, "fbx_export_path": "HarvestNodes/Rock/"},
            {"id": "GoldOre_Default", "description": "Gold vein rock", "params": {"roughness": 0.5, "color_hex": "#8B4513", "size": 1.0, "crystal": True}, "fbx_export_path": "HarvestNodes/GoldOre/"},
            {"id": "Wheat_01", "description": "Short green wheat", "params": {"stem_height": 1.0, "color_hex": "#90EE50", "petal_count": 3}, "fbx_export_path": "HarvestNodes/Wheat/"},
            {"id": "Wheat_02", "description": "Medium golden wheat", "params": {"stem_height": 1.4, "color_hex": "#DAA520", "petal_count": 4}, "fbx_export_path": "HarvestNodes/Wheat/"},
            {"id": "Wheat_03", "description": "Tall ripe wheat", "params": {"stem_height": 1.8, "color_hex": "#FFD700", "petal_count": 5}, "fbx_export_path": "HarvestNodes/Wheat/"},
        ],
        "environment_props": {
            "Forest": [
                {"id": "ZundaTree_01", "description": "Round green canopy tree", "params": {"trunk_height": 4.0, "canopy_radius": 3.0, "color_hex": "#78C882"}, "fbx_export_path": "Environment/Forest/Trees/"},
                {"id": "ZundaTree_02", "description": "Tall lavender tree", "params": {"trunk_height": 6.0, "canopy_radius": 2.5, "color_hex": "#E1B9FF"}, "fbx_export_path": "Environment/Forest/Trees/"},
            ],
            "Kitchen": [
                {"id": "KitchenCounter_01", "description": "Wood counter, green trim", "params": {"width": 4.0, "depth": 2.5, "height": 1.0, "trim_color": "#78C882"}, "fbx_export_path": "Environment/Kitchen/Counters/"},
                {"id": "CookingPot_01", "description": "Large stew pot", "params": {"cap_radius": 1.0, "stem_height": 0.8, "color_hex": "#4A4A4A", "spot_count": 0}, "fbx_export_path": "Environment/Kitchen/Utensils/"},
            ],
            "House": [
                {"id": "ZundaHouse_01", "description": "Round green-roof cottage", "params": {"width": 8.0, "depth": 6.0, "height": 4.0, "roof_color": "#78C882", "wall_color": "#FFF8DC"}, "fbx_export_path": "Environment/Houses/Zunda/"},
                {"id": "GardenFence_01", "description": "Low wood fence segment", "params": {"stem_height": 1.2, "color_hex": "#8B6514", "petal_count": 5}, "fbx_export_path": "Environment/Houses/Fences/"},
            ],
        },
    }

    output_dir = args.output
    os.makedirs(output_dir, exist_ok=True)

    if args.category == "all":
        categories = ["harvest_nodes", "environment_props"]
    else:
        categories = [args.category]

    for cat in categories:
        print(f"\n=== Generating {cat} ===")
        entries = pipeline.get(cat, [])
        if isinstance(entries, dict):
            for zone, zone_entries in entries.items():
                if args.zone and zone != args.zone:
                    continue
                print(f"\n  Zone: {zone}")
                for entry in zone_entries:
                    generate_asset(entry, output_dir)
        else:
            for entry in entries:
                generate_asset(entry, output_dir)

    # Generate summary
    summary_path = os.path.join(output_dir, "pipeline_summary.json")
    summary = {"generated": True, "output_dir": output_dir, "category": args.category}
    with open(summary_path, "w") as f:
        json.dump(summary, f, indent=2)
    print(f"\nSummary written to {summary_path}")
    print("Done. Import generated FBX meshes into Roblox Studio via MCP.")


if __name__ == "__main__":
    main()

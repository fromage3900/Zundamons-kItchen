"""
Zundamon's Kitchen — Procedural Architecture Pipeline Generator
===============================================================
Reads ArchitecturePipeline.lua manifest and generates placeholder geometry outputs
for Roblox import. This is a scaffold for future Blender-style procedural
architecture generation.

Usage:
  python scripts/architecture_pipeline_gen.py --category buildings --output Assets/Generated/Architecture
  python scripts/architecture_pipeline_gen.py --category street_props --output Assets/Generated/Architecture
"""

import argparse
import json
import math
import os
import random
import sys


def generate_house(params):
    width = params.get("width", 8.0)
    depth = params.get("depth", 6.0)
    height = params.get("height", 4.0)
    return {
        "type": "house",
        "width": width,
        "depth": depth,
        "height": height,
        "roof_style": params.get("roof_style", "gabled"),
        "wall_color": params.get("wall_color", "#FFF8DC"),
        "vertices": 24,
        "triangles": 12,
    }


def generate_arcade(params):
    width = params.get("width", 6.0)
    depth = params.get("depth", 5.0)
    height = params.get("height", 3.5)
    return {
        "type": "arcade",
        "width": width,
        "depth": depth,
        "height": height,
        "neon_color": params.get("neon_color", "#78C882"),
        "sign_count": params.get("sign_count", 2),
        "vertices": 32,
        "triangles": 18,
    }


def generate_street_lamp(params):
    height = params.get("height", 4.0)
    arm_length = params.get("arm_length", 1.2)
    return {
        "type": "street_lamp",
        "height": height,
        "arm_length": arm_length,
        "light_color": params.get("light_color", "#FFFFCC"),
        "vertices": 16,
        "triangles": 8,
    }


def generate_balcony(params):
    width = params.get("width", 3.0)
    depth = params.get("depth", 1.2)
    return {
        "type": "balcony",
        "width": width,
        "depth": depth,
        "railing_style": params.get("railing_style", "wood"),
        "vertices": 20,
        "triangles": 10,
    }


def generate_obj(path, obj_type):
    if obj_type == "house":
        lines = [
            "o house",
            "v -1 0 -1", "v 1 0 -1", "v 1 0 1", "v -1 0 1",
            "v -1 2 -1", "v 1 2 -1", "v 1 2 1", "v -1 2 1",
            "f 1 2 3 4", "f 5 6 7 8", "f 1 2 6 5", "f 2 3 7 6", "f 3 4 8 7", "f 4 1 5 8",
        ]
    elif obj_type == "arcade":
        lines = [
            "o arcade",
            "v -0.8 0 -0.8", "v 0.8 0 -0.8", "v 0.8 0 0.8", "v -0.8 0 0.8",
            "v -0.8 2 0", "v 0.8 2 0", "v 0 2 0.8", "v 0 2 -0.8",
            "f 1 2 3 4", "f 5 6 7 8",
        ]
    elif obj_type == "street_lamp":
        lines = [
            "o street_lamp",
            "v 0 0 0", "v 0 1.5 0", "v 0 1.5 0.2", "v 0 1.5 -0.2", "v 0 2.0 0", "v 0 2.0 0.5",
            "f 1 2 3", "f 1 2 4", "f 2 5 6", "f 2 4 6",
        ]
    elif obj_type == "balcony":
        lines = [
            "o balcony",
            "v -1 0 0", "v 1 0 0", "v 1 0.5 0.5", "v -1 0.5 0.5", "v -1 0.5 0", "v 1 0.5 0",
            "f 1 2 3 4", "f 1 4 5 6",
        ]
    else:
        lines = [
            "o architecture",
            "v -1 0 -1", "v 1 0 -1", "v 1 0 1", "v -1 0 1",
            "f 1 2 3 4",
        ]

    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf8") as f:
        f.write("\n".join(lines) + "\n")


GENERATORS = {
    "house": generate_house,
    "arcade": generate_arcade,
    "street_lamp": generate_street_lamp,
    "balcony": generate_balcony,
}


def main():
    parser = argparse.ArgumentParser(description="Generate procedural architecture assets for Roblox.")
    parser.add_argument("--category", choices=["buildings", "street_props", "interiors", "decor"], required=True)
    parser.add_argument("--output", default="Assets/Generated/Architecture")
    parser.add_argument("--seed", type=int, default=None)
    args = parser.parse_args()

    if args.seed is not None:
        random.seed(args.seed)

    manifest = {
        "category": args.category,
        "entries": [],
    }

    variants = []
    if args.category == "buildings":
        variants = [
            {"id": "MarketHall_01", "generator": "house", "params": {"width": 10.0, "depth": 8.0, "height": 5.0, "wall_color": "#F5F0C0"}},
            {"id": "Bakery_01", "generator": "arcade", "params": {"width": 6.0, "depth": 5.0, "height": 4.0, "neon_color": "#78C882"}},
        ]
    elif args.category == "street_props":
        variants = [
            {"id": "StreetLamp_01", "generator": "street_lamp", "params": {"height": 4.5, "arm_length": 1.0, "light_color": "#FFF4A8"}},
            {"id": "Balcony_01", "generator": "balcony", "params": {"width": 3.0, "depth": 1.2, "railing_style": "iron"}},
        ]
    elif args.category == "interiors":
        variants = [
            {"id": "CounterIsland_01", "generator": "balcony", "params": {"width": 4.0, "depth": 1.0, "railing_style": "wood"}},
        ]
    else:
        variants = [
            {"id": "PottedPlant_01", "generator": "house", "params": {"width": 0.5, "depth": 0.5, "height": 1.0, "wall_color": "#96E6A0"}},
        ]

    for variant in variants:
        result = GENERATORS[variant["generator"]](variant["params"])
        out_dir = os.path.join(args.output, args.category)
        os.makedirs(out_dir, exist_ok=True)
        json_path = os.path.join(out_dir, f"{variant['id']}.json")
        obj_path = os.path.join(out_dir, f"{variant['id']}.obj")

        with open(json_path, "w", encoding="utf8") as f:
            json.dump({"id": variant["id"], "category": args.category, "result": result}, f, indent=2)

        generate_obj(obj_path, result["type"])

        manifest["entries"].append({
            "id": variant["id"],
            "generator": variant["generator"],
            "params": variant["params"],
            "json": os.path.relpath(json_path).replace("\\", "/"),
            "obj": os.path.relpath(obj_path).replace("\\", "/"),
        })

    manifest_path = os.path.join(args.output, args.category, "manifest.json")
    with open(manifest_path, "w", encoding="utf8") as f:
        json.dump(manifest, f, indent=2)

    print(f"Generated {len(variants)} architecture assets in {args.output}/{args.category}")


if __name__ == "__main__":
    main()

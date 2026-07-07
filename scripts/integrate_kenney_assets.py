#!/usr/bin/env python3
"""
Kenney Asset Integration Helper for Zundamon's Kitchen
Generates a checklist and asset mapping for UI icons and SFX.
"""

import os
import json
from pathlib import Path

# Asset mapping for UI icons (item -> expected filename patterns)
ICON_MAPPING = {
    "Wheat": ["grass", "wheat"],
    "Zunda Flower": ["flower", "blossom"],
    "Zunda Pea": ["pea", "bean"],
    "Zunda Berry": ["berry", "fruit", "bush"],
    "Zunda Mushroom": ["mushroom", "fungi"],
    "Zunda Root": ["carrot", "beet", "root"],
    "Apple": ["apple", "fruit-green"],
    "Bread": ["bread", "loaf"],
    "Cupcake": ["cupcake", "cake"],
    "Apple Pie": ["pie", "apple-pie"],
    "Zunda Bread": ["bread-green", "special-bread"],
    "Zunda Mochi": ["mochi", "rice-cake"],
    "Royal Stew": ["stew", "soup", "bowl"],
    "Salted Pea Bouquet": ["bouquet", "flower-bundle"],
    "Gold Ore": ["gold", "coin", "precious"],
    "Rock": ["rock", "stone"],
}

# Sound mapping (action -> description)
SFX_MAPPING = {
    "harvest_start": "pickup or grab sound",
    "harvest_complete": "collect or success chime",
    "craft_start": "cooking or start sound",
    "craft_perfect": "success or achievement jingle",
    "serve_success": "cash register or coin pickup",
    "level_up": "level up or fanfare",
    "gather_fail": "error or miss sound",
    "ui_click": "interface click or button press",
}

def scan_kenney_folder(downloads_path):
    """Scan for available PNG and WAV files in Kenney packs."""
    found_assets = {"icons": [], "sounds": []}
    
    for root, dirs, files in os.walk(downloads_path):
        for f in files:
            if f.endswith('.png'):
                found_assets["icons"].append(os.path.join(root, f))
            elif f.endswith('.wav') or f.endswith('.ogg'):
                found_assets["sounds"].append(os.path.join(root, f))
    
    return found_assets

def generate_checklist():
    """Generate an integration checklist."""
    checklist = {
        "icons_to_find": list(ICON_MAPPING.keys()),
        "sounds_to_find": list(SFX_MAPPING.keys()),
        "color_palette": {
            "zundamon_green": "#78C882",
            "zundapal_pink": "#E1B9FF",
            "warm_gold": "#FFD700",
            "dark_text": "#2D2D2D",
        },
        "target_sizes": "32x32 or 64x64 pixels",
    }
    
    print(json.dumps(checklist, indent=2))

if __name__ == "__main__":
    # Generate checklist
    generate_checklist()
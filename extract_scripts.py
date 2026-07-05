"""
Extract all Script/LocalScript/ModuleScript from .rbxlx into separate .lua files
organized by their Roblox hierarchy.
"""
import re
import os
import html

RBXLX_PATH = r"C:\Users\froma\Desktop\source\beantown.rbxlx"
OUTPUT_DIR = r"C:\Users\froma\Desktop\Zundamons-kItchen-GitHub-Build\src"

def extract_all_scripts():
    with open(RBXLX_PATH, 'r', encoding='utf-8', errors='replace') as f:
        content = f.read()
    
    # Find all Item tags recursively across all nesting levels
    # Match complete Item blocks with their class
    item_pattern = re.compile(
        r'<Item class="(Script|LocalScript|ModuleScript)" referent="([^"]+)"(.*?)</Item>',
        re.DOTALL
    )
    
    matches = list(item_pattern.finditer(content))
    print(f"Total raw Item matches: {len(matches)}")
    
    scripts_extracted = 0
    for m in matches:
        cls = m.group(1)
        ref = m.group(2)
        body = m.group(3)
        
        # Extract name from <string name="Name">value</string>
        name_m = re.search(r'<string name="Name">([^<]+)</string>', body)
        name = name_m.group(1) if name_m else "Unnamed"
        
        # Extract source from CDATA
        src_m = re.search(
            r'<ProtectedString name="Source"><!\[CDATA\[(.*?)\]\]></ProtectedString>',
            body, re.DOTALL
        )
        
        if src_m and src_m.group(1).strip():
            scripts_extracted += 1
            source = src_m.group(1)
            
            # Determine output path based on class
            if cls == "Script":
                subdir = "ServerScriptService"
                suffix = ".server.lua"
            elif cls == "LocalScript":
                subdir = "StarterPlayer/StarterPlayerScripts"
                suffix = ".client.lua"
            else:  # ModuleScript
                subdir = "ReplicatedStorage/Shared/Modules"
                suffix = ".lua"
            
            out_dir = os.path.join(OUTPUT_DIR, subdir)
            os.makedirs(out_dir, exist_ok=True)
            
            filename = name + suffix
            filepath = os.path.join(out_dir, filename)
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(f"-- [[{cls}] {name} (ref: {ref})]]\n")
                f.write(source)
            
            if scripts_extracted <= 30:
                print(f"[{scripts_extracted}] {cls} -> {subdir}/{filename} ({len(source)} chars)")
                # Show first line of source
                first_line = source.strip().split('\n')[0] if source.strip() else "(empty)"
                print(f"    First line: {first_line[:120]}")
    
    print(f"\nTotal scripts extracted: {scripts_extracted}")

def find_harvesting_scripts():
    """Search all extracted scripts for harvesting-related content."""
    print("\n--- Searching for harvesting-related scripts ---")
    harvest_terms = ['harvest', 'wheat', 'crop', 'plant', 'seed', 'farm']
    
    for root, dirs, files in os.walk(OUTPUT_DIR):
        for fname in files:
            if fname.endswith('.lua'):
                path = os.path.join(root, fname)
                with open(path, 'r', encoding='utf-8', errors='replace') as f:
                    content = f.read().lower()
                for term in harvest_terms:
                    if term in content:
                        rel = os.path.relpath(path, OUTPUT_DIR)
                        print(f"  {rel} (mentions '{term}')")
                        break

if __name__ == '__main__':
    extract_all_scripts()
    find_harvesting_scripts()
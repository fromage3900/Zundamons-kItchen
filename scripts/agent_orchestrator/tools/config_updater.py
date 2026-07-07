"""Auto-update Lua config files with real asset IDs from Studio import.
Takes JSON import results and patches MeshAssets.lua, NPCConfig, UIAssets, etc."""

import json, re, os, sys
from pathlib import Path
from typing import Optional

sys.path.insert(0, str(Path(__file__).parent.parent))
from config import ROOT

class ConfigUpdater:
    def __init__(self):
        self.results = {"updated": [], "skipped": [], "errors": []}

    def read_import_json(self, path: str) -> list[dict]:
        """Read JSON results from Studio mesh import."""
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
        if isinstance(data, list):
            return data
        if isinstance(data, dict) and "results" in data:
            return data["results"]
        return []

    def name_to_config_path(self, name: str) -> Optional[dict]:
        """Map an asset name to its config file + Lua path."""
        name_lower = name.lower().replace(" ", "_")

        mapping = [
            # MeshAssets.lua - harvest nodes
            (r"wheat_0[1-3]", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Wheat"]["{name}"]'),
            (r"zundaflower_(default|rare)", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["ZundaFlower"]["{name}"]'),
            (r"zundapea_0[1-3]", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["ZundaPea"]["{name}"]'),
            (r"mushroom_0[1-2]", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Zunda Mushroom"]["{name}"]'),
            (r"berrybush_0[1-3]", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Zunda Berry"]["{name}"]'),
            (r"root_0[1-2]", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Zunda Root"]["{name}"]'),
            (r"rock_(common|rare)", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Rock"]["{name}"]'),
            (r"goldore_default", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Gold Ore"]["{name}"]'),
            # MeshAssets.lua - environment
            (r"zundatree_0[1-2]", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Tree"]["{name}"]'),
            (r"zundahouse_01", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["House"]["{name}"]'),
            (r"gardenfence_01", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Fence"]["{name}"]'),
            (r"kitchencounter_01", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Kitchen"]["{name}"]'),
            (r"cookingpot_01", "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua", f'meshes["Kitchen"]["{name}"]'),
            (r"bakery_01|markethall_01", "src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua", f'buildings.?meshes["{name}"]'),
            # NPCConfig - guests
            (r"npc_child", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'guestTemplates.Child.modelId'),
            (r"npc_adult", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'guestTemplates.Adult.modelId'),
            (r"npc_elder", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'guestTemplates.Elder.modelId'),
            # NPCConfig - companions
            (r"zundamon", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'companionTemplates.Zundapal.modelId'),
            (r"ankomon", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'companionTemplates.Ankomon.modelId'),
            (r"cardamon", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'companionTemplates.Cardamon.modelId'),
            (r"antimon", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'companionTemplates.Antimon.modelId'),
            (r"sakuradamon", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'companionTemplates.Sakuradamon.modelId'),
            (r"zundapal", "src/ReplicatedStorage/Shared/Config/NPCConfig.lua", 'companionTemplates.Zundapal.modelId'),
            # CompanionManager - mesh IDs
            (r"companion_", "src/ServerScriptService/CompanionManager.server.lua", None),
        ]

        for pattern, filepath, lua_path in mapping:
            if re.search(pattern, name_lower):
                return {"file": filepath, "lua_path": lua_path, "asset_name": name}
        return None

    def update_file(self, filepath: str, old_id: str, new_id: str, asset_name: str) -> bool:
        """Replace an old rbxassetid with a new one in a config file."""
        full_path = ROOT / filepath
        if not full_path.exists():
            self.results["errors"].append(f"File not found: {filepath}")
            return False

        content = full_path.read_text(encoding="utf-8")

        if old_id in content:
            content = content.replace(old_id, new_id)
            full_path.write_text(content, encoding="utf-8")
            self.results["updated"].append(f"{filepath}: {asset_name}")
            return True

        # Try to find by asset name pattern
        pattern = re.compile(rf'{re.escape(asset_name)}\s*=\s*"rbxassetid://\d+"', re.IGNORECASE)
        match = pattern.search(content)
        if match:
            old_line = match.group()
            new_line = f'{asset_name} = "{new_id}"'
            content = content.replace(old_line, new_line)
            full_path.write_text(content, encoding="utf-8")
            self.results["updated"].append(f"{filepath}: {asset_name} (by name)")
            return True

        # If old_id is a known placeholder, try all rbxassetid in the file
        if old_id == "PLACEHOLDER":
            self.results["skipped"].append(f"{filepath}: {asset_name} (placeholder, set manually)")
            return False

        self.results["skipped"].append(f"{filepath}: {asset_name} (ID not found)")
        return False

    def apply_results(self, import_results: list[dict], dry_run: bool = False):
        """Apply import results to config files."""
        print("=== Config Updater ===\n" if not dry_run else "=== Config Updater (DRY RUN) ===\n")

        for item in import_results:
            name = item.get("name", "")
            new_id = item.get("meshId", item.get("assetId", ""))

            if not new_id:
                self.results["skipped"].append(f"{name}: no asset ID")
                continue

            if new_id.startswith("rbxassetid://"):
                new_id_str = new_id
            else:
                new_id_str = f"rbxassetid://{new_id}"

            mapping = self.name_to_config_path(name)
            if not mapping:
                self.results["skipped"].append(f"{name}: no config mapping (unknown asset)")
                continue

            if dry_run:
                print(f"  Would update: {mapping['file']} → {mapping['lua_path']} = {new_id_str}")
                continue

            print(f"  Updating: {mapping['file']} [{mapping['asset_name']}]")
            old_id = item.get("oldId", "PLACEHOLDER")
            self.update_file(mapping["file"], old_id, new_id_str, mapping["asset_name"])

        print(f"\nUpdated: {len(self.results['updated'])}")
        if self.results["skipped"]:
            print(f"Skipped: {len(self.results['skipped'])}")
            for s in self.results["skipped"]:
                print(f"  ✗ {s}")
        if self.results["errors"]:
            print(f"Errors: {len(self.results['errors'])}")
            for e in self.results["errors"]:
                print(f"  ! {e}")

        return self.results

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Update Lua configs with asset IDs from Studio import")
    parser.add_argument("json_path", help="Path to import results JSON file")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be updated without changing files")
    args = parser.parse_args()

    updater = ConfigUpdater()
    results = updater.read_import_json(args.json_path)
    if not results:
        print(f"No import results found in {args.json_path}")
        return
    updater.apply_results(results, dry_run=args.dry_run)

if __name__ == "__main__":
    main()

"""One-command batch import pipeline:
1. Scan Assets/Upload/ for OBJ/FBX files
2. Generate Studio import script
3. (user runs script in Studio, gets IDs back)
4. Accept the ID JSON → auto-update all config files"""

import json, sys, os
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))
from config import ROOT
from tools.mesh_pipeline import MeshPipeline
from tools.config_updater import ConfigUpdater

def phase1_scan():
    """Phase 1: Scan source files and generate import script."""
    print("╔══════════════════════════════════════════╗")
    print("║  Zunda Batch Import Pipeline             ║")
    print("╚══════════════════════════════════════════╝\n")

    pipe = MeshPipeline()
    files = pipe.scan_source_files()

    if not files:
        print("No OBJ/FBX files found in Assets/Upload/")
        print("Place files there first, then re-run.")
        return None

    print(f"Phase 1: Found {len(files)} source files")
    for f in files:
        print(f"  {f['name']}{f['ext']} ({f['size_kb']:.1f} KB)")

    output_dir = ROOT / "reports" / "mesh_pipeline"
    output_dir.mkdir(parents=True, exist_ok=True)

    script = pipe.generate_studio_import_script(files)
    script_path = output_dir / "batch_import.luau"
    script_path.write_text(script, encoding="utf-8")

    print(f"\nPhase 2: Import script written to:")
    print(f"  {script_path}")
    print(f"\nNEXT: Paste that script into Studio command bar.")
    print(f"AFTER: Save the output JSON to reports/mesh_pipeline/import_results.json")
    print(f"THEN:  python scripts/agent_orchestrator/tools/batch_import.py --apply")

    return script_path

def phase2_apply(json_path: str = None):
    """Phase 2: Apply import results to config files."""
    if not json_path:
        candidates = [
            ROOT / "reports" / "mesh_pipeline" / "import_results.json",
            ROOT / "reports" / "mesh_pipeline" / "studio_results.json",
        ]
        for c in candidates:
            if c.exists():
                json_path = str(c)
                break
        if not json_path:
            print("No import results JSON found.")
            print("Place the JSON from Studio at: reports/mesh_pipeline/import_results.json")
            return

    print(f"Phase 3: Reading import results from {json_path}")

    updater = ConfigUpdater()
    results = updater.read_import_json(json_path)
    if not results:
        print(f"No valid import results found in {json_path}")
        return

    print(f"Found {len(results)} imported assets")
    updater.apply_results(results)

    print(f"\nDone. Verify changes with: npm run overnight")

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Batch import pipeline for mesh assets")
    parser.add_argument("--scan", action="store_true", help="Phase 1: scan + generate import script")
    parser.add_argument("--apply", type=str, nargs="?", const="auto", help="Phase 2: apply import JSON to configs")
    args = parser.parse_args()

    if args.scan:
        phase1_scan()
    elif args.apply:
        json_path = None if args.apply == "auto" else args.apply
        phase2_apply(json_path)
    else:
        phase1_scan()

if __name__ == "__main__":
    main()

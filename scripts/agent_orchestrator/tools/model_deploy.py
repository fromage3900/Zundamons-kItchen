"""Auto-deploy Ollama models needed by the Zunda Agent Orchestrator.
Checks available models, pulls missing ones, verifies they work."""

import sys, time, json
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent))
from tools.ollama_client import OllamaClient
from config import MODELS

REQUIRED = {
    "llama3.1:8b": "Orchestrator + Reviewer (general reasoning)",
    "qwen2.5:7b": "Research + Gameplay design (128K context)",
    "codellama:7b": "Code generation + Blender Python",
    "deepseek-coder:6.7b": "Roblox Luau code generation",
    "nomic-embed-text": "Knowledge base embeddings (0.5GB)",
}

def check_ollama_running() -> bool:
    client = OllamaClient()
    try:
        models = client.list_models()
        return True
    except Exception as e:
        print(f"  Error: {e}")
        return False

def get_available_models() -> set:
    client = OllamaClient()
    try:
        return set(client.list_models())
    except:
        return set()

def pull_model(name: str) -> bool:
    import httpx
    print(f"  Pulling {name}...", end=" ", flush=True)
    try:
        resp = httpx.post(
            "http://localhost:11434/api/pull",
            json={"name": name, "stream": False},
            timeout=600
        )
        if resp.status_code == 200:
            print("OK")
            return True
        else:
            print(f"Failed ({resp.status_code})")
            return False
    except Exception as e:
        print(f"Error: {e}")
        return False

def verify_model(name: str) -> bool:
    client = OllamaClient(model=name)
    try:
        resp = client.chat([{"role": "user", "content": "Reply with just: OK"}], format="")
        return "OK" in resp
    except:
        return False

def deploy_all():
    print("=== Zunda Model Auto-Deploy ===\n")

    # Step 1: Check Ollama
    print("Step 1: Checking Ollama server...")
    if not check_ollama_running():
        print("  Ollama is not running. Start it with: ollama serve")
        print("  Or download from: https://ollama.com")
        return False
    print("  Ollama server OK\n")

    # Step 2: Check available models
    print("Step 2: Checking available models...")
    available = get_available_models()
    print(f"  {len(available)} models currently available\n")

    # Step 3: Pull missing models
    print("Step 3: Pulling missing models...")
    all_ok = True
    for name, purpose in REQUIRED.items():
        if name in available:
            print(f"  {name} - Already available ({purpose})")
        else:
            print(f"  {name} - Needed for: {purpose}")
            if pull_model(name):
                print(f"  {name} - Pulled successfully")
            else:
                print(f"  {name} - FAILED to pull")
                all_ok = False
        print()

    if not all_ok:
        print("Some models failed to pull. Check internet connection and disk space.")
        print("Minimum requirements: ~15GB free disk for all models")
        print("You can pull individually: ollama pull <model_name>")
        return False

    # Step 4: Verify models work
    print("Step 4: Verifying models...")
    for name in REQUIRED:
        print(f"  Testing {name}...", end=" ", flush=True)
        if verify_model(name):
            print("OK")
        else:
            print("Failed - may need re-pull")

    # Step 5: Summary
    print("\n=== Deploy Complete ===")
    print(f"Models deployed: {len(REQUIRED)}")
    print(f"Config path: {__import__('os').path.expanduser('~/.ollama/models')}")
    print(f"Usage: python scripts/agent_orchestrator/run.py <task>")
    print(f"       python scripts/agent_orchestrator/run.py --generate-quests 5")
    return True

if __name__ == "__main__":
    success = deploy_all()
    sys.exit(0 if success else 1)

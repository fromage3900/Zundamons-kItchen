import os
from pathlib import Path

ROOT = Path(os.environ.get("ZUNDA_ROOT", "G:\\Zundamons-kItchen"))
OLLAMA_HOST = os.environ.get("OLLAMA_HOST", "http://localhost:11434")

MODELS = {
    "orchestrator": os.environ.get("ZUNDA_MODEL_ORCH", "llama3.1:8b"),
    "research": os.environ.get("ZUNDA_MODEL_RESEARCH", "qwen2.5:7b"),
    "code": os.environ.get("ZUNDA_MODEL_CODE", "codellama:7b"),
    "roblox": os.environ.get("ZUNDA_MODEL_ROBLOX", "deepseek-coder:6.7b"),
    "reviewer": os.environ.get("ZUNDA_MODEL_REVIEW", "llama3.1:8b"),
    "embeddings": os.environ.get("ZUNDA_MODEL_EMBED", "nomic-embed-text"),
}

MAX_RECURSION_DEPTH = 3
MAX_SUBTASKS = 5
CONTEXT_WINDOW_SIZE = 8192
KNOWLEDGE_BASE_DIR = ROOT / "scripts" / "agent_orchestrator" / "knowledge"
SEED_KNOWLEDGE_DIR = KNOWLEDGE_BASE_DIR / "seed_knowledge"

from tools.ollama_client import OllamaClient
from config import MODELS

class BaseAgent:
    def __init__(self, role: str, model_key: str = "orchestrator"):
        self.role = role
        self.client = OllamaClient(model=MODELS.get(model_key, "llama3.1:8b"))

    def run(self, task: str, context: str = "", format: str = "") -> str:
        messages = []
        if context:
            messages.append({"role": "system", "content": context})
        messages.append({"role": "user", "content": task})
        return self.client.chat(messages, format=format)

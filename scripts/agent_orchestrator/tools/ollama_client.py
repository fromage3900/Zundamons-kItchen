import httpx
import json
from typing import Optional
from config import OLLAMA_HOST

class OllamaClient:
    def __init__(self, host: str = OLLAMA_HOST, model: str = "llama3.1:8b"):
        self.host = host.rstrip("/")
        self.model = model
        self._http = httpx.Client(timeout=120)

    def chat(self, messages: list[dict], format: Optional[str] = None, options: Optional[dict] = None) -> str:
        payload = {"model": self.model, "messages": messages, "stream": False, "options": options or {}}
        if format: payload["format"] = format
        try:
            resp = self._http.post(f"{self.host}/api/chat", json=payload)
            resp.raise_for_status()
            data = resp.json()
            return data["message"]["content"]
        except Exception as e:
            return f"Error: {e}"

    def embed(self, text: str) -> list[float]:
        resp = self._http.post(f"{self.host}/api/embed", json={"model": "nomic-embed-text", "input": text})
        resp.raise_for_status()
        return resp.json()["embeddings"][0]

    def list_models(self) -> list[str]:
        resp = self._http.get(f"{self.host}/api/tags")
        resp.raise_for_status()
        return [m["name"] for m in resp.json()["models"]]

    def check_health(self) -> bool:
        try:
            resp = self._http.get(f"{self.host}/api/tags", timeout=5)
            return resp.status_code == 200
        except: return False

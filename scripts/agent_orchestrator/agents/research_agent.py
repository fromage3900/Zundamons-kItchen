import json
from agents.base_agent import BaseAgent
from config import MAX_RECURSION_DEPTH

SYSTEM_PROMPT = """You are a research scientist investigating technical topics for game development.
For each query, structure findings as JSON with keys: topic, subtopics (list), findings (list of dicts with title, summary, code), sources (list).
If the topic has subtopics needing investigation, include them."""

class ResearchAgent(BaseAgent):
    def __init__(self):
        super().__init__("researcher", "research")

    def investigate(self, query: str, depth: int = 0) -> dict:
        if depth >= MAX_RECURSION_DEPTH:
            return {"topic": query, "summary": "Max recursion depth", "subtopics": []}
        result = self.run(query, SYSTEM_PROMPT, format="json")
        try: return json.loads(result)
        except: return {"topic": query, "summary": result[:500], "subtopics": []}

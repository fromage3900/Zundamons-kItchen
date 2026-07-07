import json
from agents.base_agent import BaseAgent

SYSTEM_PROMPT = """Review code for: 1) bugs/logic errors 2) security 3) performance 4) edge cases 5) style.
Return JSON array: [{"severity": "high|medium|low", "file": "", "issue": "", "suggestion": ""}]"""

class ReviewerAgent(BaseAgent):
    def __init__(self):
        super().__init__("reviewer", "reviewer")

    def review(self, code: str, file_path: str = "") -> list[dict]:
        prompt = f"Review this code from {file_path}:\n```\n{code}\n```"
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        try: return json.loads(result)
        except: return [{"severity": "unknown", "file": file_path, "issue": "Failed to parse review", "suggestion": ""}]

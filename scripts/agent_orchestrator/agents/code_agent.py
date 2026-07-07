import subprocess, tempfile, os, re
from agents.base_agent import BaseAgent

SYSTEM_PROMPTS = {
    "python": "You are a senior Python developer. Generate complete, working code with proper error handling. Return ONLY the code.",
    "luau": "You are a Roblox Luau expert. Generate complete ModuleScripts with --!strict. Return ONLY the code.",
}

class CodeAgent(BaseAgent):
    def __init__(self):
        super().__init__("code_generator", "code")

    def generate(self, spec: str, language: str = "python") -> str:
        prompt = SYSTEM_PROMPTS.get(language, SYSTEM_PROMPTS["python"])
        result = self.run(spec, prompt)
        return self._extract_code(result)

    def _extract_code(self, text: str) -> str:
        match = re.search(r"```(?:\w+)?\n(.*?)```", text, re.DOTALL)
        return match.group(1).strip() if match else text.strip()

    def validate_python(self, code: str) -> tuple[bool, str]:
        try:
            compile(code, "<string>", "exec")
            return True, "Syntax OK"
        except SyntaxError as e:
            return False, str(e)

    def fix_code(self, code: str, error: str, spec: str) -> str:
        prompt = f"Fix this code:\n```python\n{code}\n```\nError: {error}\nSpec: {spec}\nReturn ONLY the fixed code."
        result = self.run(prompt)
        return self._extract_code(result)

    def generate_with_validation(self, spec: str, max_attempts: int = 3) -> str:
        for attempt in range(max_attempts):
            code = self.generate(spec)
            valid, msg = self.validate_python(code)
            if valid: return code
            if attempt < max_attempts - 1:
                code = self.fix_code(code, msg, spec)
        return code

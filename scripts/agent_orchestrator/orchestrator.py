import json, sys, os
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))

from tools.ollama_client import OllamaClient
from agents.research_agent import ResearchAgent
from agents.code_agent import CodeAgent
from agents.blender_agent import BlenderAgent
from agents.roblox_agent import RobloxAgent
from agents.reviewer_agent import ReviewerAgent
from config import MODELS, MAX_RECURSION_DEPTH, ROOT

ORCHESTRATOR_PROMPT = """You are the Zunda Orchestrator for a Roblox game at G:\\Zundamons-kItchen.
Your specialist agents: research (investigates topics), code_gen (generates Python), roblox (generates Luau), blender (generates Blender Python addons), reviewer (reviews code).
For any task: 1) Decompose into subtasks 2) Assign to specialists 3) Collect results 4) If insufficient, research deeper 5) Validate 6) Report.

Return subtasks as JSON array: [{"agent": "research|code_gen|roblox|blender|reviewer", "task": "description"}]"""

class ZundaOrchestrator:
    def __init__(self):
        self.client = OllamaClient(model=MODELS["orchestrator"])
        self.research = ResearchAgent()
        self.code = CodeAgent()
        self.blender = BlenderAgent()
        self.roblox = RobloxAgent()
        self.reviewer = ReviewerAgent()
        self.log = []

    def log_msg(self, msg: str):
        self.log.append(msg)
        print(f"  {msg}")

    def call_llm(self, prompt: str, system: str = "", fmt: str = "") -> str:
        messages = []
        if system: messages.append({"role": "system", "content": system})
        messages.append({"role": "user", "content": prompt})
        return self.client.chat(messages, format=fmt)

    def decompose(self, task: str) -> list[dict]:
        self.log_msg(f"Decomposing: {task[:80]}...")
        result = self.call_llm(task, ORCHESTRATOR_PROMPT, fmt="json")
        try:
            subtasks = json.loads(result)
            self.log_msg(f"  -> {len(subtasks)} subtasks")
            return subtasks
        except:
            self.log_msg(f"  -> Failed to parse, running directly")
            return [{"agent": "research", "task": task}]

    def execute_subtask(self, subtask: dict, depth: int = 0) -> dict:
        agent_type = subtask.get("agent", "research")
        task = subtask.get("task", "")
        result = {"agent": agent_type, "task": task, "depth": depth}

        if depth >= MAX_RECURSION_DEPTH:
            result["output"] = "Max recursion depth"
            return result

        self.log_msg(f"  [{agent_type}] {task[:60]}...")

        try:
            if agent_type == "research":
                output = self.research.investigate(task, depth)
                result["output"] = json.dumps(output)[:1000]
                if output.get("subtopics"):
                    for sub in output["subtopics"][:3]:
                        sub_result = self.execute_subtask({"agent": "research", "task": sub}, depth + 1)
                        result[f"sub_{sub[:30]}"] = sub_result
            elif agent_type == "code_gen":
                result["output"] = self.code.generate_with_validation(task)
            elif agent_type == "roblox":
                result["output"] = self.roblox.generate_code(task)
            elif agent_type == "blender":
                result["output"] = self.blender.generate_addon(task)
            elif agent_type == "reviewer":
                result["output"] = json.dumps(self.reviewer.review(task))
            else:
                result["output"] = self.call_llm(task)
        except Exception as e:
            result["output"] = f"Error: {e}"
            result["error"] = str(e)

        return result

    def run_task(self, task_description: str) -> list[dict]:
        print(f"\n{'='*60}")
        print(f"Zunda Orchestrator — Task: {task_description}")
        print(f"{'='*60}")

        subtasks = self.decompose(task_description)
        results = []
        for st in subtasks:
            r = self.execute_subtask(st)
            results.append(r)

        print(f"\n{'='*60}")
        print(f"Task complete — {len(results)} subtasks, {len(self.log)} log lines")
        print(f"{'='*60}")

        # Save results
        report_dir = ROOT / "reports"
        report_dir.mkdir(exist_ok=True)
        report = report_dir / f"orchestrator-{__import__('datetime').datetime.now().strftime('%Y%m%d_%H%M')}.json"
        with open(report, "w") as f:
            json.dump({"task": task_description, "results": results, "log": self.log}, f, indent=2)
        print(f"Report saved to {report}")

        return results

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Zunda Agent Orchestrator")
    parser.add_argument("task", nargs="?", default="", help="Task description")
    parser.add_argument("--daemon", action="store_true", help="Run in continuous improvement loop")
    parser.add_argument("--interval", type=int, default=3600, help="Daemon loop interval in seconds")
    parser.add_argument("--seed-kb", action="store_true", help="Seed knowledge base from project files")
    args = parser.parse_args()

    orch = ZundaOrchestrator()

    if args.seed_kb:
        print("Seeding knowledge base...")
        print("(Run overnight-build.mjs for project validation)")
        return

    if args.daemon:
        import time
        print(f"Daemon mode — checking every {args.interval}s")
        while True:
            orch.run_task("Review project state, identify next task from master plan, execute")
            time.sleep(args.interval)

    if args.task:
        orch.run_task(args.task)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()

import json, sys, os
from datetime import datetime
from pathlib import Path

# Ensure we're running from project root (find default.project.json)
_script_dir = Path(__file__).resolve().parent
_possible_roots = [_script_dir, _script_dir.parent.parent, _script_dir.parent]
_root_found = False
for _p in _possible_roots:
    if (_p / "default.project.json").exists():
        os.chdir(str(_p))
        _root_found = True
        break
if not _root_found:
    print("Error: Run this script from G:\\Zundamons-kItchen")
    print(f"  cd G:\\Zundamons-kItchen")
    print(f"  python scripts\\agent_orchestrator\\run.py <task>")
    sys.exit(1)

sys.path.insert(0, str(Path(__file__).parent))

from tools.ollama_client import OllamaClient
from agents.research_agent import ResearchAgent
from agents.code_agent import CodeAgent
from agents.blender_agent import BlenderAgent
from agents.roblox_agent import RobloxAgent
from agents.reviewer_agent import ReviewerAgent
from agents.quest_agent import QuestAgent
from agents.gameplay_agent import GameplayAgent
from agents.config_writer_agent import ConfigWriterAgent
from config import MODELS, MAX_RECURSION_DEPTH, ROOT

ORCHESTRATOR_PROMPT = r"""You are the Zunda Orchestrator for a Roblox game at G:\Zundamons-kItchen.
Your specialist agents: research, code_gen, roblox, blender, reviewer, quest (quest designer), gameplay (gameplay systems designer), config_writer (writes Lua config files).
For any task: 1) Decompose 2) Assign 3) Collect 4) Research deeper if needed 5) Validate 6) Report.
Return subtasks as JSON array: [{"agent": "agent_type", "task": "description"}]"""

GENERATE_QUESTS_PROMPT = """Analyze the current quest state and generate new quests to fill gameplay gaps.

Current state:
- 19 recipes exist (Tier 1: Bread, Apple Pie | Tier 2: Zunda Bread, Royal Stew, Zunda Mochi, Edamame Snack, Antimon's Speed Soup, Cardamon's Calm Cup | Tier 3: Fancy Pie, Zundamon's Banquet, Sweet Pea Cake, Pea Flower Tea, Seasonal Salad, Sakuradamon's Blossom Bites | Tier 4: Ultimate Feast, Zunda Paradise, Warm Winter Stew, Ankomon's Protein Punch, Golden Harvest Platter)
- 10 gatherable items: Zunda Flower, Zunda Pea, Zunda Mushroom, Zunda Berry, Zunda Root, Edamame Pod, Zunda Leaf, Sweet Pea, Pea Flower, Salted Pea Bouquet
- 6 guest types: Hopeful Visitor (12-20g), Food Critic (40-60g), Regular Customer (18-28g), Picnic Guest (30-45g), Timed Challenge (80-120g)
- 6 quest chains: great_zunda_hunt (gathering), culinary_ascension (cooking), seasons_of_flavor (seasonal), friend_of_all (companion), gold_rush (economy), zunda_legend (mastery)
- 5 progression milestones at 0, 5, 12, 25, 50 guests served
- 14 recipes are quest-only (not milestone-unlocked)

Task: Identify gaps in quest coverage and generate specific quest ids/types to fill them."""

class ZundaOrchestrator:
    def __init__(self):
        self.client = OllamaClient(model=MODELS["orchestrator"])
        self.research = ResearchAgent()
        self.code = CodeAgent()
        self.blender = BlenderAgent()
        self.roblox = RobloxAgent()
        self.reviewer = ReviewerAgent()
        self.quest = QuestAgent()
        self.gameplay = GameplayAgent()
        self.config = ConfigWriterAgent()
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
        import re
        try:
            arr_match = re.search(r'\[.*?\]', result, re.DOTALL)
            if arr_match:
                subtasks = json.loads(arr_match.group())
            else:
                subtasks = json.loads(result)
            if isinstance(subtasks, list) and len(subtasks) > 0:
                self.log_msg(f"  -> {len(subtasks)} subtasks")
                return subtasks
        except:
            pass
        self.log_msg(f"  -> Running directly")
        return [{"agent": "research", "task": task}]

    def execute_subtask(self, subtask, depth: int = 0) -> dict:
        if isinstance(subtask, str):
            subtask = {"agent": "research", "task": subtask}
        agent_type = subtask.get("agent", "research") if isinstance(subtask, dict) else "research"
        task = subtask.get("task", "") if isinstance(subtask, dict) else str(subtask)
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
            elif agent_type == "quest":
                result["output"] = json.dumps(self.quest.generate_quest_chain(task, 3, "cozy"))
            elif agent_type == "gameplay":
                result["output"] = json.dumps(self.gameplay.analyze_economy(task))
            elif agent_type == "config_writer":
                result["output"] = self.config.write_quests(subtask.get("data", []))
            else:
                result["output"] = self.call_llm(task)
        except Exception as e:
            result["output"] = f"Error: {e}"
            result["error"] = str(e)

        return result

    def generate_quests(self, count: int = 5):
        """High-level quest generation: analyze gaps → design → write"""
        print(f"\n{'='*60}")
        print(f"Quest Generator — Analyzing gaps and generating {count} quests")
        print(f"{'='*60}")

        # Phase 1: Analyze gaps
        print("\nPhase 1: Analyzing quest gaps...")
        gap_analysis = self.call_llm(GENERATE_QUESTS_PROMPT)
        self.log_msg(f"Gap analysis: {gap_analysis[:200]}...")

        # Phase 2: Generate quests for each identified gap
        print(f"\nPhase 2: Generating {count} quests...")
        all_quests = []
        recipes = [
            ("Edamame Snack", {"Edamame Pod": 3, "Zunda Leaf": 2}),
            ("Fancy Pie", {"Apple": 7, "Wheat": 12, "Gold": 2}),
            ("Sweet Pea Cake", {"Sweet Pea": 4, "Wheat": 10, "Zunda Pea": 3}),
            ("Pea Flower Tea", {"Pea Flower": 5, "Zunda Leaf": 3}),
            ("Warm Winter Stew", {"Zunda Root": 3, "Zunda Mushroom": 2, "Gold": 1}),
        ]
        for recipe_name, ings in recipes[:count]:
            quests = self.quest.generate_filler_quests(1, recipe_name, ings)
            all_quests.extend(quests)
            self.log_msg(f"  Generated quest for {recipe_name}")

        # Phase 3: Sanitize and write to Lua format
        print("\nPhase 3: Sanitizing and writing Lua config snippet...")
        sanitized = [self._sanitize_quest(q) for q in all_quests if isinstance(q, dict)]
        lua_output = self._quests_to_lua(sanitized)

        # Phase 4: Save
        output_dir = ROOT / "reports" / "generated"
        output_dir.mkdir(parents=True, exist_ok=True)
        ts = datetime.now().strftime('%Y%m%d_%H%M')
        output_path = output_dir / f"generated_quests_{ts}.lua"
        with open(output_path, "w", encoding="utf-8") as f:
            f.write("-- Auto-generated quests by Zunda Orchestrator\n")
            f.write("-- Review and integrate into QuestConfig.lua default_quests table\n\n")
            f.write(lua_output)
        print(f"\nQuests written to {output_path}")
        print("Review the generated file, then merge into QuestConfig.lua manually or with /reload plugin")

        return all_quests

    def _sanitize_quest(self, q: dict) -> dict:
        """Fix common LLM inconsistencies before formatting."""
        result = dict(q)
        # Map :emoji: style to proper emoji
        emoji_map = {
            ":apple:": "🍎", ":wheat:": "🌾", ":pea:": "🫛", ":pea_pod:": "🫛",
            ":mushroom:": "🍄", ":berry:": "🫐", ":root:": "🌱", ":leaf:": "🍃",
            ":flower:": "🌸", ":bouquet:": "💐", ":gold:": "💛", ":rock:": "🪨",
            ":pie:": "🥧", ":bread:": "🍞", ":mochi:": "🍡", ":stew:": "🍲",
            ":cake:": "🍰", ":tea:": "🍵", ":salad:": "🥗", ":punch:": "💪",
            ":soup:": "🍜", ":feast:": "🏛️", ":paradise:": "✨", ":chef:": "👨‍🍳",
            ":zunda:": "🫛", ":guest:": "👤", ":gold_coin:": "🪙", ":compass:": "🧭",
        }
        icon = result.get("icon", "")
        if icon in emoji_map:
            result["icon"] = emoji_map[icon]
        elif icon and icon.startswith(":") and icon.endswith(":"):
            result["icon"] = "📋"  # fallback for unknown emoji codes
        # Fix quest type
        valid_types = {"serve","cook","cook_perfect","cook_quality","cook_speed",
            "cook_unique","cook_unique_zunda","cook_unique_seasonal",
            "gather","gather_unique","earn_gold","visit_zone","visit_zones_unique",
            "companion_chat","npc_chat","npc_chat_all","set_companion"}
        qtype = str(result.get("type", "gather"))
        if qtype not in valid_types:
            if "gather" in qtype or "collect" in qtype: result["type"] = "gather"
            elif "cook" in qtype or "craft" in qtype: result["type"] = "cook"
            elif "serve" in qtype or "guest" in qtype: result["type"] = "serve"
            elif "gold" in qtype or "earn" in qtype: result["type"] = "earn_gold"
            elif "chat" in qtype or "talk" in qtype: result["type"] = "companion_chat"
            elif "visit" in qtype or "explore" in qtype or "zone" in qtype: result["type"] = "visit_zone"
            else: result["type"] = "gather"
        # Clamp difficulty to 1-5
        diff = result.get("difficulty", 1)
        if isinstance(diff, (int, float)):
            result["difficulty"] = max(1, min(5, int(diff)))
        else:
            result["difficulty"] = 1
        return result

    def _quests_to_lua(self, quests: list) -> str:
        """Convert quest data to properly formatted Lua without calling an LLM."""
        lines = []
        lines.append("return {")
        for q in quests:
            if isinstance(q, str):
                continue
            if not isinstance(q, dict):
                continue
            lines.append("\t{")
            for field in ["id", "name", "description", "icon", "type", "target_item",
                          "chain_id", "chain_step", "difficulty"]:
                val = q.get(field)
                if val is not None:
                    self._add_lua_field(lines, field, val, indent=2)
            # target: can be int or dict (ingredient map)
            target = q.get("target")
            if target is not None:
                if isinstance(target, dict):
                    items = ", ".join(f'["{k}"] = {v}' for k, v in target.items())
                    lines.append(f"\t\ttarget = {{{items}}},")
                else:
                    self._add_lua_field(lines, "target", target, indent=2)
            # rewards
            rewards = q.get("rewards")
            if rewards and isinstance(rewards, dict):
                lines.append("\t\trewards = {")
                if rewards.get("gold"):
                    self._add_lua_field(lines, "gold", rewards["gold"], indent=3)
                if rewards.get("tier_points"):
                    self._add_lua_field(lines, "tier_points", rewards["tier_points"], indent=3)
                r_items = rewards.get("items", [])
                if isinstance(r_items, list) and r_items:
                    items_str = ", ".join(f'"{i}"' for i in r_items)
                    lines.append(f"\t\t\titems = {{{items_str}}},")
                else:
                    lines.append("\t\t\titems = {},")
                lines.append("\t\t},")
            # subtext
            if q.get("subtext"):
                self._add_lua_field(lines, "subtext", q["subtext"], indent=2)
            # npc_dialogue
            dia = q.get("npc_dialogue")
            if dia and isinstance(dia, dict):
                speaker = dia.get("speaker") or next(iter(dia.keys()), "narrator")
                dlines_raw = dia.get("lines") or dia.get(speaker, [])
                if isinstance(dlines_raw, str):
                    dlines_raw = [dlines_raw]
                if isinstance(dlines_raw, list) and dlines_raw:
                    lines.append(f'\t\tnpc_dialogue = {{ speaker = "{speaker}", lines = {{')
                    for dl in dlines_raw:
                        escaped = str(dl).replace("\\", "\\\\").replace('"', '\\"')
                        lines.append(f'\t\t\t"{escaped}",')
                    lines.append("\t\t} },")
            lines.append("\t},")
        lines.append("}")
        return "\n".join(lines)

    def _add_lua_field(self, lines: list[str], name: str, value, indent: int = 1, skip_name: bool = False):
        tab = "\t" * indent
        if skip_name:
            prefix = tab
        else:
            prefix = f"{tab}{name} = "
        if isinstance(value, str):
            escaped = str(value).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
            lines.append(f'{prefix}"{escaped}",')
        elif isinstance(value, bool):
            lines.append(f'{prefix}{str(value).lower()},')
        elif isinstance(value, (int, float)):
            lines.append(f'{prefix}{value},')

    def run_task(self, task_description: str) -> list[dict]:
        print(f"\n{'='*60}")
        print(f"Zunda Orchestrator — Task: {task_description}")
        print(f"{'='*60}")

        subtasks = self.decompose(task_description)
        results = []
        for st in subtasks:
            if isinstance(st, str):
                st = {"agent": "research", "task": st}
            r = self.execute_subtask(st)
            results.append(r)

        print(f"\n{'='*60}")
        print(f"Task complete — {len(results)} subtasks, {len(self.log)} log lines")
        print(f"{'='*60}")

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
    parser.add_argument("--interval", type=int, default=3600, help="Daemon loop interval")
    parser.add_argument("--seed-kb", action="store_true", help="Seed knowledge base")
    parser.add_argument("--generate-quests", type=int, nargs="?", const=5, default=0, help="Generate N quests autonomously")
    args = parser.parse_args()

    orch = ZundaOrchestrator()

    if args.seed_kb:
        print("Seeding knowledge base...")
        return

    if args.generate_quests:
        orch.generate_quests(args.generate_quests)
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

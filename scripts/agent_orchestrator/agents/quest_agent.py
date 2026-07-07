import json, re
from agents.base_agent import BaseAgent

SYSTEM_PROMPT = """You are a quest designer for a cozy cooking RPG (Zundamon's Kitchen).
You know the QuestConfig format inside out.

Rules:
- 19 recipes exist. 14 are quest-only (no milestone unlock).
- 10 gatherable items: Zunda Flower, Zunda Pea, Zunda Mushroom, Zunda Berry, Zunda Root, Edamame Pod, Zunda Leaf, Sweet Pea, Pea Flower, Salted Pea Bouquet
- Base items: Apple, Wheat, Gold, Wood Log, Pine Cone
- 6 quest chains exist but may have step gaps
- Each quest needs: id, name, description, icon (emoji), type, target, rewards {gold, tier_points, items}, difficulty(1-5)
- Optional: subtext (flavor paragraph), npc_dialogue {speaker, lines}, chain_id, chain_step
- subtext should be whimsical, cozy, Zunda-themed. Example: "The village elder says the first Zunda Peas were discovered by a chef who chased a rainbow into a field..."
- npc_dialogue should match character voices: zundapal (excited, ALL CAPS), chef (grumpy but encouraging), elder (wise, cryptic), narrator (dramatic flavor text), ankomon (protein/beans), cardamon (calm/zen), antimon (speed/energy), sakuradamon (flowers/beauty)

Return ONLY the Lua table entries as a JSON array. Each entry is a quest table."""

class QuestAgent(BaseAgent):
    def __init__(self):
        super().__init__("quest_designer", "research")

    def generate_quest_chain(self, chain_name: str, steps: int, theme: str) -> list[dict]:
        prompt = f"""Generate a {steps}-step quest chain called '{chain_name}' with theme: {theme}.
Each step should escalate in difficulty (1 to 5).
Include a chain_id and chain_step in each quest.
At least one step should reward a recipe item.
Each step should have subtext and some should have npc_dialogue.

Return as JSON array of quest objects (one per step)."""
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        return self._parse_quests(result)

    def generate_filler_quests(self, count: int, recipe_name: str, recipe_ingredients: dict) -> list[dict]:
        prompt = f"""Generate {count} quest(s) that help a player gather ingredients for '{recipe_name}' which needs: {json.dumps(recipe_ingredients)}.
The quests should chain together: first gather the base ingredients, then cook the recipe.
Include subtext and npc_dialogue.
Return as JSON array of quest objects."""
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        return self._parse_quests(result)

    def generate_milestone_quest(self, milestone_name: str, guests_required: int) -> dict:
        prompt = f"""Generate ONE quest for milestone '{milestone_name}' unlocked at {guests_required} guests served.
This should be a serve-type quest that culminates in this milestone.
Include dramatic subtext and npc_dialogue from the chef.
Return as a single JSON quest object."""
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        quests = self._parse_quests(result)
        return quests[0] if quests else {}

    def _parse_quests(self, text: str) -> list[dict]:
        match = re.search(r"\[.*?\]", text, re.DOTALL)
        if match:
            try: return json.loads(match.group())
            except: pass
        try: return json.loads(text)
        except: return [{"error": "Failed to parse", "raw": text[:200]}]

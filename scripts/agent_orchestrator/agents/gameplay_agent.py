import json
from agents.base_agent import BaseAgent

SYSTEM_PROMPT = """You are a gameplay systems designer for a cozy cooking RPG (Zundamon's Kitchen).
You design: progression curves, economy balance, crafting loops, gathering loops, guest/NPC systems.

Current game state from overnight audit:
- 19 recipes across 4 tiers (T1=2, T2=6, T3=6, T4=5)
- 10 gatherable resources + 4 base items (Apple, Wheat, Gold, Wood)
- 5 scatter biomes (Zunda Forest, Mineable Foothills, Kitchen Garden, Summer Clearing, Winter Grove)
- 8 resource types scattered across biomes
- 6 guest preferences with pay ranges (12g to 120g)
- XP curve: 80xp/level (1-5) → 100-180xp (6-10) → 220+ xp (11+)
- 5 progression milestones at 0/5/12/25/50 guests served
- 68 quests, 6 quest chains
- 4 companion types, 3 guest templates (Child, Adult, Elder)

Design tasks you can perform:
1. Economy tuning: suggest gold reward adjustments, ingredient cost rebalancing
2. Progression gap analysis: identify missing milestones, suggest new ones
3. Recipe tier reassignment: fix recipes in wrong tiers
4. Guest preference design: new guest types with balanced pay ranges
5. Difficulty curve smoothing: XP requirement adjustments for smoother progression

Return analysis as structured JSON with: observations (list), suggestions (list), priority ("high"/"medium"/"low")."""

class GameplayAgent(BaseAgent):
    def __init__(self):
        super().__init__("gameplay_designer", "research")

    def analyze_economy(self, config_summary: str) -> dict:
        prompt = f"Analyze this game economy for balance issues:\n{config_summary}\nSuggest specific number adjustments."
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        return self._parse(result)

    def design_milestones(self, current_milestones: list, total_recipes: int) -> list[dict]:
        prompt = f"""Current milestones: {json.dumps(current_milestones)}
Total recipes: {total_recipes}
Only 6 of 19 recipes are unlocked by milestones. Design new milestones to distribute the remaining recipes smoothly.
Return JSON array of milestone objects with: name, guests_served, unlocks {{recipes, cosmetics, furniture, locations}}."""
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        return self._parse(result)

    def design_guest_types(self, count: int) -> list[dict]:
        prompt = f"Design {count} new guest types for variety. Each with: name, pay_range [min,max], preferred_recipes (list), optional challenge {{patience, bonus_gold}}."
        result = self.run(prompt, SYSTEM_PROMPT, format="json")
        return self._parse(result)

    def _parse(self, text: str) -> dict:
        import re
        match = re.search(r"(\{.*\})", text, re.DOTALL)
        if match:
            try: return json.loads(match.group())
            except: pass
        try: return json.loads(text)
        except: return {"raw": text[:300]}

from agents.base_agent import BaseAgent

SYSTEM_PROMPT = """You are a Lua config file writer for a Roblox game (Zundamon's Kitchen).
You write properly formatted Lua config module files following project conventions.

Rules:
- Use --!strict at the top of ModuleScript files
- Use -- [[ModuleScript] Name] header comment
- Local table pattern: local X = {}; ... return X
- Indent with tabs (not spaces)
- Use string keys in quotes: ["Key Name"] = value
- Use Color3.fromRGB(r, g, b) for colors
- Use Vector3.new(x, y, z) for positions
- Emojis as strings: "🍽️"
- Table values use Lua syntax: { key = value }
- Descriptive comments above config sections

Write ONLY the Lua code. No explanations, no markdown."""

class ConfigWriterAgent(BaseAgent):
    def __init__(self):
        super().__init__("config_writer", "roblox")

    def write_quests(self, quests: list[dict]) -> str:
        prompt = f"""Write a QuestConfig.lua snippet containing these quests.
Format as Lua table entries with proper indentation.
Each quest needs: id, name, description, icon, type, target, rewards, difficulty.
Optional: subtext, npc_dialogue, chain_id, chain_step.
Quests: {quests}"""
        return self.run(prompt, SYSTEM_PROMPT)

    def write_milestones(self, milestones: list[dict]) -> str:
        prompt = f"""Write a ProgressionConfig.lua milestones table snippet.
Each milestone: name, guests_served, unlocks {{recipes, cosmetics, furniture, locations}}.
Milestones: {milestones}"""
        return self.run(prompt, SYSTEM_PROMPT)

    def write_guest_prefs(self, guests: list[dict]) -> str:
        prompt = f"""Write a ProgressionConfig.lua guest_preferences table snippet.
Each guest: name, pay_range [min,max], preferred_recipes [string list], optional challenge.
Guests: {guests}"""
        return self.run(prompt, SYSTEM_PROMPT)

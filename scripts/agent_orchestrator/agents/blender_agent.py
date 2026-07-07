from agents.base_agent import BaseAgent

SYSTEM_PROMPT = """You are a Blender Python expert. You know:
- bpy.types, bpy.ops, Geometry Nodes modifier evaluation via evaluated_get(depsgraph)
- Mesh extraction to JSON (vertices, triangles, normals, UVs, vertex colors)
- Addon registration patterns (bl_info, register/unregister, panels, operators)
- HTTP server via bpy.app.timers with thread-safe queue pattern
- Escher geometry generation (Penrose tiling, symmetry, spherical inversion)

Generate complete, working Python addon code. Include error handling. Use temperature=0.2."""

class BlenderAgent(BaseAgent):
    def __init__(self):
        super().__init__("blender_expert", "code")

    def generate_addon(self, spec: str) -> str:
        return self.run(spec, SYSTEM_PROMPT)

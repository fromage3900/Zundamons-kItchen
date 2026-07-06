# MCP Setup Guide — Figma & Roblox Integration

**Date:** 2026-07-05  
**Purpose:** Connect AI assistants (Claude, Cursor, Windsurf, etc.) to Figma and Roblox via MCP (Model Context Protocol) servers.

---

## What is MCP?

MCP (Model Context Protocol) is Anthropic's open standard that lets AI assistants connect to external tools and data sources. Each MCP "server" exposes capabilities (read files, call APIs, manipulate designs) that the AI can use during a session.

---

## 1. Figma MCP Server

### Option A: Official `figma-developer-mcp` (Recommended)

Figma's official MCP server provides read access to Figma files, components, styles, and design tokens.

**Install:**
```bash
npm install -g @anthropic/figma-developer-mcp
```

**Or use npx (no install):**
```bash
npx @anthropic/figma-developer-mcp --figma-api-key=YOUR_KEY
```

**Get a Figma API key:**
1. Open Figma → click your profile icon → **Settings**
2. Scroll to **Personal access tokens**
3. Click **Generate new token** → name it (e.g., `mcp-access`) → copy the token

### Option B: Community `@anthropic-ai/figma-mcp`

```bash
npm install -g @anthropic-ai/figma-mcp
```

### Option C: `figma-mcp` by Sonnet

```bash
npx figma-mcp --token=YOUR_FIGMA_TOKEN
```

### Claude Desktop Configuration

Add to your Claude Desktop config file:

- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": [
        "@anthropic/figma-developer-mcp",
        "--figma-api-key=YOUR_FIGMA_API_KEY"
      ]
    }
  }
}
```

### Cursor / Windsurf / Continue Configuration

These editors use a similar MCP config format. Add to your editor's MCP settings:

**Cursor** (`~/.cursor/mcp.json`):
```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["@anthropic/figma-developer-mcp", "--figma-api-key=YOUR_FIGMA_API_KEY"]
    }
  }
}
```

**Windsurf** (Settings → MCP Servers → Add):
```json
{
  "figma": {
    "command": "npx",
    "args": ["@anthropic/figma-developer-mcp", "--figma-api-key=YOUR_FIGMA_API_KEY"]
  }
}
```

### What Figma MCP Can Do

| Capability | Description |
|---|---|
| `get_file` | Read a Figma file's structure, pages, frames |
| `get_file_styles` | Extract color styles, text styles, effect styles |
| `get_file_components` | List all components and variants |
| `get_node` | Read a specific node/frame by ID |
| `get_images` | Export frames/nodes as PNG/SVG |

### Using Figma MCP for This Project

Once connected, you can ask the AI to:
- Pull color tokens from your Figma design file and sync them into `UIConfig.lua`
- Extract component specs (sizes, spacing, corner radii) and update `UIComponents.lua`
- Compare Figma designs against the implemented Roblox UI for consistency audits

---

## 2. Roblox MCP Server

### Option A: `roblox-mcp` (Community)

A community MCP server that connects to Roblox's Open Cloud API.

```bash
npm install -g roblox-mcp
```

**Get Roblox Open Cloud API key:**
1. Go to [create.roblox.com/credentials](https://create.roblox.com/credentials)
2. Click **Create API Key**
3. Add permissions for your experience (Universe ID)
4. Copy the API key

### Option B: Rojo as the Bridge (Already Set Up ✅)

For this project, **Rojo is already the primary bridge** between code and Roblox Studio. MCP for Roblox is supplementary — Rojo handles the file sync pipeline.

The workflow is:
```
AI edits src/*.lua → Rojo syncs to Studio → Studio runs the game
```

### Option C: Roblox Studio Plugin MCP

Some community plugins expose a local MCP server from within Roblox Studio:

1. Install a Studio MCP plugin (search Roblox Creator Hub for "MCP" or "AI Bridge")
2. The plugin runs a local HTTP server (e.g., `localhost:3002`)
3. Configure your AI tool to connect to it

### Claude Desktop Configuration (Roblox)

```json
{
  "mcpServers": {
    "roblox": {
      "command": "npx",
      "args": [
        "roblox-mcp",
        "--api-key=YOUR_ROBLOX_OPEN_CLOUD_KEY",
        "--universe-id=YOUR_UNIVERSE_ID"
      ]
    }
  }
}
```

### What Roblox MCP Can Do

| Capability | Description |
|---|---|
| `list_datastores` | List DataStores in your experience |
| `get_datastore_entry` | Read a DataStore entry |
| `publish_place` | Publish a place file |
| `get_universe_info` | Read experience metadata |
| `list_assets` | Browse uploaded assets |

---

## 3. Combined Configuration (Figma + Roblox + Filesystem)

For full AI-assisted design-to-code workflow, combine all MCP servers:

### Claude Desktop — Full Config

**File:** `%APPDATA%\Claude\claude_desktop_config.json` (Windows)

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": [
        "@anthropic/figma-developer-mcp",
        "--figma-api-key=YOUR_FIGMA_API_KEY"
      ]
    },
    "roblox": {
      "command": "npx",
      "args": [
        "roblox-mcp",
        "--api-key=YOUR_ROBLOX_OPEN_CLOUD_KEY",
        "--universe-id=YOUR_UNIVERSE_ID"
      ]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "@anthropic/mcp-filesystem",
        "--root=G:\\Zundamons-kItchen"
      ]
    }
  }
}
```

### Cursor — Full Config

**File:** `~/.cursor/mcp.json`

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["@anthropic/figma-developer-mcp", "--figma-api-key=YOUR_FIGMA_API_KEY"]
    },
    "roblox": {
      "command": "npx",
      "args": ["roblox-mcp", "--api-key=YOUR_ROBLOX_OPEN_CLOUD_KEY", "--universe-id=YOUR_UNIVERSE_ID"]
    }
  }
}
```

### Windsurf — Full Config

In Windsurf settings (Settings → Features → MCP Servers):

```json
{
  "figma": {
    "command": "npx",
    "args": ["@anthropic/figma-developer-mcp", "--figma-api-key=YOUR_FIGMA_API_KEY"]
  },
  "roblox": {
    "command": "npx",
    "args": ["roblox-mcp", "--api-key=YOUR_ROBLOX_OPEN_CLOUD_KEY", "--universe-id=YOUR_UNIVERSE_ID"]
  }
}
```

---

## 4. Current MCP Connections on This Machine

The following MCP servers are already configured in `~/.cursor/mcp.json`:

| Server | Status | Details |
|---|---|---|
| **Roblox Studio** | ✅ Connected | Via `StudioMCP.exe` (official Roblox MCP, stdio transport) |
| **Figma** | 🔑 Needs API key | Added via `@anthropic/figma-developer-mcp` — replace `YOUR_FIGMA_API_KEY` in `~/.cursor/mcp.json` |
| **Unreal Engine** | ✅ Connected | Via `it-is-unreal` Python server on port 55557 |
| **Blender** | ✅ Connected | Via `blender-mcp-enhanced` on port 9877 |

### To activate Figma MCP:
1. Get your Figma API key (Profile → Settings → Personal access tokens)
2. Edit `C:\Users\froma\.cursor\mcp.json`
3. Replace `YOUR_FIGMA_API_KEY` with your actual token
4. Restart Cursor

---

## 5. How Other AIs Connect (Reference)

### Claude (Anthropic)
- **Desktop app:** `claude_desktop_config.json` (not installed on this machine — install Claude Desktop to use)
- **API (Claude Code / Junie):** MCP servers must be configured in the IDE/agent environment settings, not in the project. Junie currently does not support custom MCP server connections.
- **Claude.ai (web):** No MCP support — web-only, no local tool access

### Cursor
- Config file: `~/.cursor/mcp.json`
- Also supports: Settings UI → Features → MCP Servers
- Docs: [cursor.com/docs/mcp](https://docs.cursor.com/context/model-context-protocol)

### Windsurf (Codeium)
- Config: Settings → Features → MCP Servers (JSON editor)
- Supports same `command` + `args` format as Claude Desktop
- Docs: Check Windsurf settings panel

### Continue (VS Code extension)
- Config file: `~/.continue/config.json` under `"mcpServers"` key
- Same format as Claude Desktop

### Cline (VS Code extension)
- Config: VS Code settings → Cline → MCP Servers
- Supports `command` + `args` format

### GitHub Copilot
- As of mid-2026, Copilot supports MCP in VS Code via `settings.json`:
```json
{
  "github.copilot.chat.mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["@anthropic/figma-developer-mcp", "--figma-api-key=YOUR_KEY"]
    }
  }
}
```

---

## 6. Verification Checklist

After configuring MCP servers:

- [ ] Restart your AI tool (Claude Desktop, Cursor, etc.)
- [ ] Check that the MCP server icon/indicator shows "connected"
- [ ] Test Figma: ask the AI to "read my Figma file at [URL]"
- [ ] Test Roblox: ask the AI to "list DataStores in my experience"
- [ ] Test workflow: ask the AI to "pull colors from Figma and update UIConfig.lua"

### Troubleshooting

| Issue | Fix |
|---|---|
| MCP server not starting | Check that `npx` is in your PATH; run the command manually to see errors |
| Figma auth failed | Regenerate your Personal Access Token; ensure it has read scope |
| Roblox auth failed | Check API key permissions include your Universe ID |
| "No MCP servers configured" | Restart the AI tool after editing config; check JSON syntax |
| Server crashes on start | Update Node.js to v18+; run `npm cache clean --force` |

---

## 7. Recommended Workflow for This Project

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│  Figma MCP  │────▶│  AI Agent    │────▶│  src/*.lua   │
│  (design    │     │  (Claude /   │     │  (UIConfig,  │
│   tokens)   │     │   Cursor)    │     │  UIComponents│
└─────────────┘     └──────┬───────┘     └──────┬───────┘
                           │                     │
                           │                     ▼
                    ┌──────▼───────┐     ┌──────────────┐
                    │  Roblox MCP  │     │    Rojo      │
                    │  (DataStore, │     │  (file sync) │
                    │   publish)   │     └──────┬───────┘
                    └──────────────┘            │
                                               ▼
                                        ┌──────────────┐
                                        │Roblox Studio │
                                        └──────────────┘
```

1. **Design** in Figma → AI pulls tokens via Figma MCP
2. **Code** updated in `src/` → `UIConfig.lua` and `UIComponents.lua` stay in sync
3. **Sync** via Rojo → changes appear in Roblox Studio automatically
4. **Publish** via Roblox MCP or Studio → live experience updated

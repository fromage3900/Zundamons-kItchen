# Roblox Studio MCP — Port 58741 Troubleshooting

**Place:** `108617605497926` · **Repo:** `G:\Zundamons-kItchen`

Studio MCP (`robloxstudio-mcp` v2.6+) uses HTTP port **`58741`** by default. This is **not** Rojo — Rojo uses **`34872`** (fallback **`34873+`**).

| Service | Port | Required for v0.1 playtest? |
|---------|------|----------------------------|
| **Rojo** | 34872 / 34873+ | **Yes** — syncs `src/` Lua into Studio |
| **Studio MCP** | 58741 | No — optional AI bridge into Studio |

For gather → craft → serve, **Rojo alone is enough**. Do not block playtesting on MCP.

---

## Project identity check

Confirm you opened the correct repo before debugging MCP:

```powershell
G:
cd G:\Zundamons-kItchen
git remote -v
git log -1 --oneline
```

| Check | Expected |
|-------|----------|
| Folder | `G:\Zundamons-kItchen` |
| Remote | `github.com/fromage3900/Zundamons-kItchen` |
| Place | `108617605497926` (`SyncConfig.lua`) |
| Rojo project | `default.project.json` at repo root |

If the folder is `C:\Users\froma\Zundamons-kItchen` or `Zundamons-kItchen-GitHub-Build`, switch to **`G:\Zundamons-kItchen`**.

Run `git pull origin main` — stale local copies cause confusion with sync labels and configs.

---

## Why MCP sticks on "connecting localhost:58741"

1. **Wrong startup order** — Node MCP server must run before the Studio plugin connects.
2. **Stale `node.exe`** — old MCP instance holds the port.
3. **Port mismatch** — server shifted to 58742+ but plugin still targets 58741.
4. **Studio security** — Game Settings → Security → **Allow HTTP Requests** off.
5. **Firewall** blocking `127.0.0.1:58741`.

---

## Fix procedure (Windows)

### 1. Kill stale Node processes

Close Cursor/OpenCode first, then:

```powershell
taskkill /F /IM node.exe
```

### 2. Start MCP server manually (watch for errors)

```powershell
npx -y robloxstudio-mcp@latest --port 58741
```

Leave this terminal open until the plugin connects.

### 3. Pin port in Cursor MCP config

Edit `C:\Users\froma\.cursor\mcp.json` (or Cursor → Settings → MCP):

```json
{
  "mcpServers": {
    "robloxstudio-mcp": {
      "command": "npx",
      "args": ["-y", "robloxstudio-mcp@latest", "--port", "58741"]
    }
  }
}
```

Restart Cursor after saving. See [`docs/cursor-mcp.example.json`](cursor-mcp.example.json).

### 4. Studio side

1. Open place **108617605497926**.
2. **Game Settings → Security → Allow HTTP Requests** = ON.
3. MCP plugin → Server URL = `http://localhost:58741`.
4. Connect **after** step 2 shows the server listening.

### 5. Verify HTTP

```powershell
curl http://localhost:58741/health
```

If this fails, check the terminal for a different port (58742, 58743) and update the plugin URL to match.

---

## Symptom table

| Symptom | Fix |
|---------|-----|
| "Waiting for MCP server" | Start Cursor/OpenCode first; confirm `npx robloxstudio-mcp` is running |
| "HTTP OK" but never Connected | `taskkill /F /IM node.exe`, restart Cursor and Studio |
| Server on 58742/58743 | Update plugin URL or pin `--port 58741` |
| Tools never appear in Cursor | Known v2.6 quirk — use Rojo for code edits |
| Only need v0.1 playtest | Skip MCP; `npm run rojo:serve` → connect Rojo on **34872/34873** |

---

## v0.1 daily workflow (Rojo only)

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run security
npm run rojo:serve
```

Studio: Plugins → Rojo → Connect `localhost:34872` (or port shown in terminal).

Output on Play should include: `[ROJO SYNC OK] Client — <SyncConfig.label>`

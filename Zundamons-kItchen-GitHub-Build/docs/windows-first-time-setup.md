# Windows First-Time Setup (PowerShell)

Use this if you see `not a git repository`, `path does not exist`, or `rokit is not recognized`.

---

## 0. Prerequisites (install once if missing)

| Tool | Check | Install |
|------|-------|---------|
| **Git** | `git --version` | https://git-scm.com/download/win |
| **Node.js** | `node --version` | https://nodejs.org (LTS) |

---

## 1. Clone the repo (one time)

Open **PowerShell** and run:

```powershell
cd $HOME
git clone https://github.com/fromage3900/Zundamons-kItchen.git
cd Zundamons-kItchen\Zundamons-kItchen-GitHub-Build
```

Your project path should be:

```
C:\Users\froma\Zundamons-kItchen\Zundamons-kItchen-GitHub-Build
```

> **Note:** The Rojo project is in the **nested** `Zundamons-kItchen-GitHub-Build` folder, not `C:\Users\froma` directly.

---

## 2. Install Rokit (one time)

Still in PowerShell:

```powershell
Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression
```

**Close PowerShell completely.** Open a **new** PowerShell window (so PATH updates).

---

## 3. Install Rojo + plugin (one time)

```powershell
cd $HOME\Zundamons-kItchen\Zundamons-kItchen-GitHub-Build

rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene
rokit install
rojo plugin install
```

Restart **Roblox Studio** after `rojo plugin install`.

---

## 4. Every time you develop

**Terminal A** — leave this running:

```powershell
cd $HOME\Zundamons-kItchen\Zundamons-kItchen-GitHub-Build
git pull origin main
npm install
npm run rojo:serve
```

Wait for:

```
Rojo server listening:
  Port:    34872
```

**Roblox Studio:**

1. Open **Zundamon's kItchen** (experience `108617605497926`) from Creator Hub
2. **Plugins → Rojo → Connect**
3. Press **Play** → Output should show `[ROJO SYNC OK]`

---

## Common errors on Windows

| Error | Fix |
|-------|-----|
| `not a git repository` | Run `git clone` first (step 1) |
| `Cannot find path ... GitHub-Build` | You're in `C:\Users\froma` — cd into cloned repo |
| `rokit is not recognized` | Run Rokit installer (step 2), then **new** PowerShell window |
| `Couldn't connect to Rojo server` | `npm run rojo:serve` not running, or terminal was closed |
| `npm is not recognized` | Install Node.js LTS, restart PowerShell |

---

## Optional: Roblox Studio MCP (local Cursor)

Separate from Rojo. In Studio: **Assistant → Manage MCP Servers → Enable Studio as MCP server**, then Quick connect → Cursor.

See [`mcp-setup-guide.md`](mcp-setup-guide.md).

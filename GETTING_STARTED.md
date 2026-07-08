# Welcome to Zundamon's Kitchen, Electra!

**Roblox:** @tekashiwannaminaj  
**Repo:** `G:\Zundamons-kItchen`  
**Studio place:** `108617605497926` (cloud — **not** the old 48MB file on disk)

This guide assumes you're new to git and VS Code. Follow one step at a time.

**Coming from the old ~48MB place file?** Read [`docs/migration-from-legacy-place.md`](docs/migration-from-legacy-place.md) once, then return here.

---

## How this project works (30 seconds)

```
You edit src/  →  npm run rojo:serve  →  Roblox Studio (cloud place)  →  Play
```

- **Code** lives in git (`src/` folder).
- **World** (map, meshes, guests) lives in Roblox cloud place `108617605497926`.
- **Never** use the old `.rbxlx` file for daily work after migration.

---

## Step 1: Install the basics

### Visual Studio Code
1. https://code.visualstudio.com/ → Download → install → open once.

### Git
1. https://git-scm.com/download/win → install (keep all defaults).

### Node.js
1. https://nodejs.org/ → download **LTS** → install.
2. Restart VS Code after installing Node.

---

## Step 2: Get the project

1. Open VS Code.
2. Press **Ctrl + `** to open the terminal.
3. Run these one at a time:

```powershell
G:
cd G:\
git clone https://github.com/fromage3900/Zundamons-kItchen.git
cd Zundamons-kItchen
npm install
code .
```

You should see `G:\Zundamons-kItchen` in the terminal. Use **this** VS Code window from now on.

---

## Step 3: Every work session

Run these **every time** you sit down to work:

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

**Leave `rojo:serve` running.** Do not close that terminal.

### In Roblox Studio

1. Open place **`108617605497926`** from Roblox Creator (your experience → Edit).
   - **Do not** File → Open the old 48MB `.rbxlx` for daily work.
2. Plugins → **Rojo** → **Connect** → `localhost:34872` (or `34873` if the terminal shows a different port).
3. Press **Play**.
4. In **Output**, look for: `[ROJO SYNC OK] Client — ...`

If you don't see that line, Rojo isn't connected — fix before testing the game.

---

## Step 4: Edit the game

- Change scripts in the **`src/`** folder in VS Code.
- They sync to Studio automatically while `rojo:serve` runs.
- **Don't** edit the same scripts only inside Studio — Rojo will overwrite them.

### If you change the map or place objects in Studio

Use **File → Save to Roblox** so teammates get your world changes. Map changes don't go through git.

---

## Step 5: Save your code to GitHub

1. Click the **Source Control** icon on the left (branch icon).
2. Review changed files under `src/`.
3. Type a short message (e.g. "fix bread recipe display").
4. Click **Commit** (✓).
5. Click **Sync** / **Push** to upload.

**Before your first push on a new task**, ask which branch to use. Usually: create a branch from `main`, don't push straight to `main`.

More detail: [`docs/git-workflow.md`](docs/git-workflow.md).

---

## Quick reference

| I want to… | Command |
|------------|---------|
| Start syncing | `npm run rojo:serve` |
| Get latest code | `git pull origin main` |
| Check project OK | `npm run validate` |
| Full audit (optional) | `npm run overnight` |

| Port | What |
|------|------|
| **34872** (or 34873) | **Rojo** — you need this |
| 58741 | Studio MCP — optional, skip if stuck |

---

## If something breaks

| Problem | Try |
|---------|-----|
| Rojo won't connect | Close Studio, restart `npm run rojo:serve`, reconnect |
| Changes don't appear | Wrong place open — use cloud `108617605497926` |
| Grey screen / double UI | Legacy StarterGui — see migration doc Phase 3 |
| `git pull` errors | Ask in chat before force-pushing |

---

## Next reads

| Doc | When |
|-----|------|
| [`docs/migration-from-legacy-place.md`](docs/migration-from-legacy-place.md) | One-time move from old 48MB file |
| [`docs/git-workflow.md`](docs/git-workflow.md) | Branches, PRs, what goes in git |
| [`docs/rojo-workflow.md`](docs/rojo-workflow.md) | Technical Rojo details |
| [`BUILD.md`](BUILD.md) | Advanced build + mesh pipeline |

Welcome to the team!

# Getting Started — So Simple Your Cat Could Do It

You want to help build Zundamon's Kitchen, but you've never used any of these tools before.
**That's fine.** Follow these steps in order. Don't skip any.

---

## Step 1: Install Just 2 Things

### 1a. Install Visual Studio Code
1. Go to https://code.visualstudio.com/
2. Click the big blue "Download" button
3. Open the downloaded file
4. Click "Next" a bunch of times until it finishes
5. Open VS Code

### 1b. Install Git
1. Go to https://git-scm.com/download/win
2. Click the download link (it should start automatically)
3. Open the downloaded file
4. Click "Next" on every screen (don't change any settings)
5. When it asks about "Adjusting your PATH environment" — make sure "Git from the command line" is selected
6. Keep clicking "Next" until it finishes

---

## Step 2: Get the Project

1. Open VS Code
2. Press `` Ctrl+` `` (Control + backtick key — it's the key next to the 1 key)
   - This opens the **terminal** at the bottom of VS Code
   - You'll see a blinking cursor where you can type
3. **Copy-paste** this entire block into the terminal and press Enter:
```powershell
cd G:\
git clone https://github.com/fromage3900/Zundamons-kItchen.git
```
4. Wait for it to finish (you'll see a new line appear when it's done)
5. Then paste this and press Enter:
```powershell
cd Zundamons-kItchen
```

**You are now in the project.** (You should see `G:\Zundamons-kItchen` in your terminal)

---

## Step 3: Open the Project in VS Code

```powershell
code .
```

This opens the project. From now on, use this VS Code window for everything.

---

## Step 4: Install Node.js (this lets us run build tools)

1. Go to https://nodejs.org/
2. Click the big green button that says "LTS" (not "Current")
3. Open the downloaded file
4. Click "Next" on every screen
5. Restart VS Code

---

## Step 5: Install the Project Tools

In the VS Code terminal (press `` Ctrl+` `` if you closed it), paste this and press Enter:
```powershell
npm install
```

Wait for it to finish (it might take a minute). You'll see a blinking cursor when done.

---

## Step 6: Install the AI Tools

Paste this and press Enter:
```powershell
pip install -r scripts\agent_orchestrator\requirements.txt
```

If you see an error about "pip not found", try `pip3 install -r scripts\agent_orchestrator\requirements.txt` instead.

---

## Step 7: You're Done Installing

Run this to make sure everything works:
```powershell
npm run validate
```

If you see "Rojo project valid" — **you did it!**

---

## Your Daily Workflow

From now on, every time you work:

### A) Start Rojo Sync (connects your code to Roblox Studio)

In the VS Code terminal:
```powershell
npm run rojo:serve
```

Leave this running. Open Roblox Studio, go to the **Plugins** tab, click **Rojo**, and click **Connect**.

### B) Edit Code

Open the `src/` folder in VS Code. Every time you save a file, Rojo automatically sends it to Studio.

### C) Test Your Changes

In Roblox Studio, click the **Play** button. Your changes are already there.

### D) Save Your Work to GitHub

When you're done for the day:

1. In VS Code, click the **Source Control** icon on the left (looks like a tree branch)
2. Type a message about what you changed
3. Click the **Commit** button (checkmark icon)
4. Click **Sync Changes** (refresh icon at the bottom)

---

## What NOT to Do

- ❌ Don't edit files in `workspace/` — those are auto-generated
- ❌ Don't open `Zundamons-kItchen.rbxlx` in a text editor — it's a binary file
- ❌ Don't delete any folders in `src/` — they sync to Studio
- ❌ Don't worry if you break something — you can always undo with `Ctrl+Z` in VS Code

---

## Need Help?

- Things not working? Close VS Code, open it again, and try `npm run rojo:serve` again
- Error about "port already in use"? Restart your computer
- Anything else? Just ask in the project chat

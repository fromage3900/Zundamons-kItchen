# ✨ Welcome to Zundamon's Kitchen, Electra! ✨

**Roblox:** @tekashiwannaminaj 🎀

This guide is written JUST for you. Carry your laptop, follow each step one at a time, and you'll be building in no time!

---

## 🌸 Step 1: Install the Basics

Even if you've never coded before, you can do these:

### 📥 1a. Download Visual Studio Code
1. Ask your browser to go to: **https://code.visualstudio.com/**
2. Click the big blue **Download** button ✨
3. Open the downloaded file when it finishes
4. Keep clicking "Next" until it installs
5. Open VS Code once it's done

### 📥 1b. Download Git
1. Ask your browser to go to: **https://git-scm.com/download/win**
2. It should download automatically — open the file
3. Keep clicking "Next" on every page (don't change anything!)
4. When it finishes, Git is installed 🎉

---

## 🌸 Step 2: Get the Game Project

1. Open VS Code ✨
2. Press **Ctrl + \`** (that's the key to the top-left of your keyboard, above Tab)
   - A black panel should appear at the bottom — that's the **terminal** 🖥️
3. **Copy** this line below by highlighting it and pressing Ctrl+C, then **paste** it into the terminal with Ctrl+V, and press **Enter**:
```powershell
cd G:\
```
4. Now copy and paste this, press Enter:
```powershell
git clone https://github.com/fromage3900/Zundamons-kItchen.git
```
5. Wait for it to finish (you'll see the blinking cursor come back) ⏳
6. Then paste this and press Enter:
```powershell
cd Zundamons-kItchen
```

**You're now inside the project!** 🎉 You should see `G:\Zundamons-kItchen` in your terminal.

7. Type this and press Enter:
```powershell
code .
```
This opens the project in VS Code. From now on, use THIS VS Code window ✨

---

## 🌸 Step 3: Install the Last Thing (Node.js)

1. Look at your browser and go to: **https://nodejs.org/**
2. Click the big green button that says **LTS** (not "Current") ✨
3. Open the downloaded file, click "Next" until it finishes
4. **Close VS Code and open it again** (this is important!)
5. In the terminal (Ctrl+`), paste this and press Enter:
```powershell
npm install
```
6. Wait... it might take a minute. You'll see the blinking cursor when it's done ✨

---

## 🌸 Step 4: One-Click Setup

Now paste this magic command and press Enter:
```powershell
npm run rojo:serve
```

**Leave this running!** Don't close it or press Ctrl+C. It connects your code to Roblox Studio.

---

## 🌸 Step 5: Your Daily Work

### 🎮 To work on the game:
1. `cd G:\Zundamons-kItchen` (always start here)
2. `npm run rojo:serve` (keep this running!)
3. Open Roblox Studio, go to the **Plugins** tab, click **Rojo**, click **Connect**
4. Edit files in the `src/` folder — they auto-sync to Studio ✨

### 💾 To save your work:
1. In VS Code, click the tree-branch icon on the left sidebar (Source Control) 🌿
2. Type a message about what you changed
3. Click the ✓ button (Commit)
4. Click the ↻ button (Sync) to upload to GitHub

---

## ✨ Quick Reference

| What you want to do | Type this |
|---------------------|-----------|
| Start syncing to Studio | `npm run rojo:serve` |
| Check everything is OK | `npm run overnight` |
| Generate new quests | `npm run generate-quests` |
| Deploy AI models | `npm run deploy-models` |
| Validate files | `npm run validate` |

---

## 💖 You DID IT! 

If something breaks:
- Close VS Code and open it again
- Make sure you ran `npm install`
- Ask in the chat — everyone was new once!

**Welcome to the team, Electra!** 🎀✨🌸💖

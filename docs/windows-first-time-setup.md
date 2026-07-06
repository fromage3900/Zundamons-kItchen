# Windows First-Time Setup (PowerShell)

**Canonical project path:** `G:\Zundamons-kItchen` — see [`AI/WORKSPACE.md`](../AI/WORKSPACE.md).

---

## 1. Clone to G: (one time)

```powershell
G:
git clone https://github.com/fromage3900/Zundamons-kItchen.git Zundamons-kItchen
cd G:\Zundamons-kItchen
npm install
```

### Already on C:?

```powershell
Move-Item C:\Users\froma\Zundamons-kItchen G:\Zundamons-kItchen
cd G:\Zundamons-kItchen
```

Reopen Cursor/VS Code on `G:\Zundamons-kItchen`.

---

## 2. Rojo + Studio

```powershell
G:
cd G:\Zundamons-kItchen
npm run rojo:serve
```

Studio: open place `108617605497926` → Plugins → Rojo → Connect → Play.

Output should show `[ROJO SYNC OK] Client — main-2026-07-06-g-drive-workspace`.

---

## Daily workflow

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

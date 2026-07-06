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

## Troubleshooting

### Port 34872 already in use (`os error 10048`)

Another Rojo (or old terminal) is still bound to port 34872. Only **one** `rojo serve` can run at a time.

**Find and stop it:**

```powershell
netstat -ano | findstr :34872
```

Note the PID in the last column, then:

```powershell
taskkill /PID <PID> /F
```

Or close the other PowerShell window that is already running `npm run rojo:serve`.

Then start again:

```powershell
cd G:\Zundamons-kItchen
npm run rojo:serve
```

**Rule:** leave exactly one serve terminal open while Studio is connected.

---

## Daily workflow

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

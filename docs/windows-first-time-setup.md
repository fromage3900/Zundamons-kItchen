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

Another Rojo instance is still bound to port 34872. The project scripts handle this automatically:

```powershell
cd G:\Zundamons-kItchen
npm run rojo:stop
npm run rojo:serve
```

`rojo:serve` will also try to stop a stale **node.exe** on 34872 before starting. If a different app holds the port, close it or run `netstat -ano | findstr :34872` then `taskkill /PID <pid> /F`.

**Rule:** only one `npm run rojo:serve` at a time.

---

## Daily workflow

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

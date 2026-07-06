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

**Stale Rojo/node:** `npm run rojo:serve` stops old `node.exe` on 34872 automatically.

**Cursor holds 34872:** Cursor sometimes port-forwards 34872. The serve script **falls back to 34873** (or next free port). In Studio Rojo plugin, set port to match the terminal (e.g. `34873`), not always `34872`.

Manual cleanup:

```powershell
npm run rojo:stop
npm run rojo:serve
```

Custom port: `$env:ROJO_PORT=34900; npm run rojo:serve`

**Rule:** only one `npm run rojo:serve` at a time.

---

## Daily workflow

```powershell
G:
cd G:\Zundamons-kItchen
git pull origin main
npm run rojo:serve
```

# Zundamon's kItchen

The Rojo project lives in **`Zundamons-kItchen-GitHub-Build/`** (not this repo root).

## Sync code into Roblox Studio

```bash
git pull origin main
cd Zundamons-kItchen-GitHub-Build
rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene
rokit install
rojo plugin install
npm run rojo:serve
```

In Studio:

1. Open experience **108617605497926** (published place — not an empty `rojo build` file)
2. **Plugins → Rojo → Connect** to `localhost:34872`
3. Press **Play** and check **Output** for `[ROJO SYNC OK]`

Full troubleshooting: [`Zundamons-kItchen-GitHub-Build/docs/rojo-sync-troubleshooting.md`](Zundamons-kItchen-GitHub-Build/docs/rojo-sync-troubleshooting.md)

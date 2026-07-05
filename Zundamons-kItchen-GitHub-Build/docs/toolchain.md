# Toolchain

Zundamon's kItchen uses **[Rokit](https://github.com/rojo-rbx/rokit)** to pin CLI tools and **Node** only for small validation scripts. Roblox Studio remains the editor for world art and instances.

## Pinned tools (`rokit.toml`)

| Tool | Version | Purpose |
|------|---------|---------|
| [rojo](https://github.com/rojo-rbx/rojo) | 7.7.0 | Sync `src/` ↔ Studio, CI `rojo build` |
| [StyLua](https://github.com/JohnnyMorganz/StyLua) | 2.5.2 | Luau formatting |
| [selene](https://github.com/Kampfkarren/selene) | 0.31.0 | Static analysis |

**Deferred:** [Wally](https://wally.run/) — add when the first external Luau package is needed.  
**Deferred:** Git LFS — add when a versioned `assets/` binary folder exists.

## One-time setup

```bash
cd Zundamons-kItchen-GitHub-Build

# Install Rokit (pick one)
# macOS/Linux: https://github.com/rojo-rbx/rokit#installation
# Or CI-style bootstrap:
npm run rokit:install

# Trust and install tools from rokit.toml
rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene
rokit install

# Rojo Studio plugin (once per machine)
rojo plugin install
```

Binaries are linked under `~/.rokit/bin/`. npm scripts resolve that path automatically via `scripts/ensure-rokit.mjs`.

## Daily commands

```bash
rojo serve default.project.json    # or: npm run rojo:serve
npm run validate                   # structure check + rojo build
npm run lint                       # StyLua + Selene
npm run sourcemap                  # sourcemap.json for Luau LSP
```

## Lint scope

| Checker | Scope | Notes |
|---------|--------|-------|
| **StyLua** | `Services/`, `Validation/`, `ConfigurationFiles/`, `Controllers/` | Formatted core; expand to full `src/` after a one-time `stylua src` pass |
| **Selene** | All of `src/` (with `--allow-warnings`) | Legacy vendor scripts excluded in `selene.toml` |

Excluded from Selene (legacy / vendor): `Package.server.lua`, `qTexture`, `qPerfectionWeld`, `PoseTexture`, `LightConfig`, `EasyConfig`, `Type.lua`.

## Luau LSP

Generate a sourcemap after pulling:

```bash
npm run sourcemap
```

Point your editor's Luau language server at `sourcemap.json` (see `.vscode/extensions.json`).

## CI

GitHub Actions runs `node scripts/install-rokit-ci.mjs`, then `npm run validate` and `npm run lint`. No npm `rojo` wrapper or Selene zip download in CI anymore.

## Migrating off npm Rojo

Older clones used `npm install` for `rojo@1.0.3-rojo7.6.1`. That dependency is removed. If `rojo` is not found, run `rokit install` and ensure `~/.rokit/bin` is on your `PATH`, or use `npm run rokit:install`.

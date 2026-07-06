# Quick Reference - Zundamon's Kitchen

## 🚀 Commands

### Rojo
```bash
# Sync with Studio
rojo sync

# Build model
rojo build --output output/model.rbxm

# Watch mode (auto-sync)
rojo serve
```

### Git
```bash
# Get latest
git pull

# Save your changes
git add -A
git commit -m "feat: your change description"
git push
```

---

## 🔑 Key Files

| System                      | File                                                                              |
| --------------------------- | --------------------------------------------------------------------------------- |
| Harvest Config              | `src/ReplicatedStorage/Shared/Config/HarvestConfig.lua`                           |
| Harvest Controller (Client) | `src/StarterPlayer/StarterPlayerScripts/Controllers/HarvestController.client.lua` |
| Craft Config                | `src/ReplicatedStorage/Shared/Modules/CraftConfig.lua`                            |
| Quest Config                | `src/ReplicatedStorage/ConfigurationFiles/QuestConfig.lua`                        |
| UI Assets                   | `src/ReplicatedStorage/Shared/Config/UIAssets.lua`                                |
| Security Validator          | `src/ServerScriptService/Validation/HarvestValidator.server.lua`                  |

---

## ⚡ Harvest Node Setup

1. Part with `ClickDetector`
2. Attributes:
   - `ResourceType = "Wheat"` or `"ZundaFlower"`, etc.
   - `Yield = number` (optional, default varies)
3. CollectionService tag: `Plantable`

### Node Types
- `Wheat` - Basic crop
- `ZundaFlower` - Forest flower
- `ZundaPea` - Pea plant
- `ZundaMushroom` - Forest mushroom
- `ZundaBerry` - Berry bush
- `ZundaRoot` - Root vegetable

---

## 🍳 Recipe Format

```lua
CraftConfig.recipes.Cupcake = {
    Wheat = 2,
    ["Zunda Berry"] = 3,
    locked = true, -- optional
}

-- Unlock condition
CraftConfig.unlocks.Cupcake = {
    requires_achievement = "q_sweet_tooth",
}
```

---

## 🎯 Quest Format

```lua
{
    id = "q_harvest_daily",
    title = "Daily Harvest",
    goal = 10,
    metric = "totalGather",
    reward = { gold = 50, xp = 100 },
    icon = "🌿",
}
```

---

## 🧪 Test Checklist

- [ ] Harvest wheat → get item
- [ ] Craft bread → get dish
- [ ] Serve guest → get gold/xp
- [ ] Check combo system
- [ ] Check quest progress

---

## 🆘 Get Help

- Check `docs/` for full docs
- Ask in Discord: #zunda-kitchen-dev
- File issues on GitHub
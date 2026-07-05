# Legacy Notes

## DoubleJump module (removed from repo)

The former `DoubleJump - READ ME - Place in ServerScriptService.lua` was a **settings stub**, not runtime code.

Original attribution: Jersito4 (April 10, 2022)

**Instructions (Studio):** Place a double-jump server script in `ServerScriptService`. Settings from the removed module:

```lua
local Settings = {
	ExtraJumps = 2,
	WhiteList = {}, -- empty = everyone; or { userId, ... }
}
```

If double-jump is needed, implement as `ServerScriptService/DoubleJump.server.lua` under Rojo.

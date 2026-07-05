-- Prints a loud banner on server start so you can confirm Rojo synced from git.

local RS = game:GetService("ReplicatedStorage")
local SyncConfig = require(RS:WaitForChild("ConfigurationFiles"):WaitForChild("SyncConfig"))

local line = string.rep("=", 58)
print(line)
print("[ROJO SYNC OK] Zundamon's kItchen — " .. SyncConfig.label)
print("[ROJO SYNC OK] ServerScriptService scripts loaded from git via Rojo")
print("[ROJO SYNC OK] Expect: 000_RojoSyncMarker, 00_RemoteBootstrap, DecorationPlacer")
print(line)

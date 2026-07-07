# LLM Production Setup — Zundapal Chat

**Experience:** Zundamon's kItchen — Place ID `108617605497926`  
**Stack:** DeepSeek HTTP API (default) or OpenAI — **not** Ollama/local inference

---

## Studio configuration

1. Enable **HttpService** in Game Settings → Security.
2. Create folder `ServerStorage.ZundapalLLMSecrets` with `StringValue` child `ApiKey`.
3. Paste your DeepSeek API key (from [platform.deepseek.com](https://platform.deepseek.com)).
4. Whitelist `api.deepseek.com` (or `api.openai.com` if using OpenAI) in Creator Hub API access.

---

## Code references

| File | Purpose |
|------|---------|
| `src/ReplicatedStorage/ConfigurationFiles/ZundapalLLMConfig.lua` | Provider, model, limits |
| `src/ServerScriptService/Services/ZundapalLLMService.lua` | Server proxy, session history |
| `src/ServerScriptService/ZundapalChatServer.server.lua` | RemoteEvent handler |
| `src/StarterPlayer/StarterPlayerScripts/ZundapalChat.client.lua` | Client UI wiring |
| `src/StarterPlayer/StarterPlayerScripts/DisclaimerGate.client.lua` | AI disclosure gate |

---

## Limits (default)

- 20 messages/day per user
- 3 second cooldown between sends
- 300 char input / 600 char output max
- Session history: 16 turns (not persisted to DataStore)

---

## Optional: ship without AI

Set `enabled = false` in `ZundapalLLMConfig.lua`. Disclaimer gate and scripted VN still work.

---

## MasterChefZunda (deferred)

Second mentor persona documented but not in tree. Restore from branch `cursor/master-chef-zunda-594f` if needed.

---

## Ollama / local models

Roblox servers cannot reach `localhost`. In-game Ollama requires a cloud-hosted OpenAI-compatible endpoint. For dev-time Cursor use, configure Ollama in Cursor Settings → Models (external to this repo).

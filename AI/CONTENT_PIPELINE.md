# Content Pipeline

## Adding New Ingredients
1. **Config**: Add the item to `src/ReplicatedStorage/ConfigurationFiles/ItemConfig.lua`.
2. **Gathering Node**: (Studio) Create a model with a `ClickDetector` and `ResourceType` attribute.
3. **Server Logic**: Update `src/ServerScriptService/ZundaGatherServer.server.lua` to handle the new `ResourceType`.
4. **Validation**: Ensure `HarvestValidator.server.lua` covers the new item if it has special harvest rules.

## Adding New Recipes
1. **Config**: Add the recipe to `src/ReplicatedStorage/ConfigurationFiles/CraftConfig.lua`.
2. **UI**: Ensure icons/emojis are available for the new dish.
3. **Requirement**: Set the `ChefLevel` or `Quest` requirement in the config.

## Adding Dialogue
1. **Speaker**: If it's a new character, add them to `VNDialogueData.lua`.
2. **Lines**: Add dialogue trees to `VNDialogueData.lua`.
3. **Trigger**: Implement the trigger in the relevant client or server script (e.g., `QuestScript.client.lua` or a specific event).

## Adding Quests
1. **Config**: Add the quest details to `QuestConfig.lua` or `DailyQuestConfig.lua`.
2. **Rewards**: Define rewards using the `LootModule` schema.
3. **Logic**: Quests are handled by `QuestManager.server.lua`.

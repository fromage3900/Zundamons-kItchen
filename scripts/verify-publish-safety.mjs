#!/usr/bin/env node
/**
 * Post-merge smoke checks for publish-safety artifacts (CI + local).
 * Studio playtest steps: docs/studio-playtest-smoke.md
 *
 * LLM chat stack (ZundapalLLMService) is optional until Phase 1.2 — see AI/PUBLISH-PLAN.md
 */
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL("..", import.meta.url)));

const requiredFiles = [
	"src/ReplicatedStorage/ConfigurationFiles/DisclaimerConfig.lua",
	"src/ReplicatedStorage/ConfigurationFiles/MarketplaceConfig.lua",
	"src/ReplicatedStorage/ConfigurationFiles/ClientGuiBootstrap.lua",
	"src/ReplicatedStorage/ConfigurationFiles/LegacyGuiConfig.lua",
	"src/ServerScriptService/Services/MarketplaceService.lua",
	"src/StarterPlayer/StarterPlayerScripts/DisclaimerGate.client.lua",
	"src/StarterPlayer/StarterPlayerScripts/000_LegacyOverlayCleanup.client.lua",
	"src/ServerScriptService/LlmDisclaimerServer.server.lua",
	"scripts/check-publish-readiness.mjs",
	"PRIVACY.md",
	"SECURITY.md",
	"docs/legal-publish-checklist.md",
	"docs/atmosphere-gameplay-audit.md",
	"docs/studio-playtest-smoke.md",
	"docs/studio-legacy-ui-deletion.md",
	"docs/ELECTRA-SETUP.md",
	"AI/PUBLISH-PLAN.md",
	"src/ServerScriptService/Services/ZundapalLLMService.lua",
	"src/ServerScriptService/ZundapalChatServer.server.lua",
	"src/StarterPlayer/StarterPlayerScripts/ZundapalChat.client.lua",
	"src/ReplicatedStorage/RemoteFunctions/init.meta.json",
	"src/ReplicatedStorage/RewardEvents/init.meta.json",
];

const requiredPatterns = [
	{
		file: "src/ServerScriptService/CompanionShopServer.server.lua",
		pattern: /TEST grant|PromptProductPurchase/,
		label: "Companion shop purchase or test-grant path",
	},
	{
		file: "src/ServerScriptService/RobuxStoreServer.server.lua",
		pattern: /MarketplaceService/,
		label: "RobuxStore delegates to MarketplaceService",
	},
	{
		file: "src/StarterPlayer/StarterPlayerScripts/CompanionShopScript.client.lua",
		pattern: /ClientGuiBootstrap/,
		label: "CompanionShop Rojo bootstrap",
	},
	{
		file: "src/ReplicatedStorage/ConfigurationFiles/LegacyGuiConfig.lua",
		pattern: /ZundaPouch|QuestPanel|destroyLegacyStarterShells/,
		label: "Legacy StarterGui shell list",
	},
	{
		file: "src/ServerScriptService/LlmDisclaimerServer.server.lua",
		pattern: /GetLlmDisclaimerStatus|llm_disclaimer_accepted/,
		label: "LLM disclaimer remotes + persistence field",
	},
	{
		file: "src/ServerScriptService/QuestManager.server.lua",
		pattern: /ConfigurationFiles\.QuestConfig/,
		label: "QuestManager uses canonical QuestConfig",
	},
	{
		file: "default.project.json",
		pattern: /RemoteFunctions/,
		label: "Rojo project includes RemoteFunctions",
	},
	{
		file: "src/ServerScriptService/Services/ZundapalLLMService.lua",
		pattern: /maxDailyMessagesPerUser|llm_disclaimer_accepted/,
		label: "LLM daily cap + disclaimer enforcement",
	},
];

const optionalPatterns = [];

let failed = false;
let warned = false;

for (const rel of requiredFiles) {
	const path = join(root, rel);
	if (!existsSync(path)) {
		console.error(`[verify-publish-safety] Missing file: ${rel}`);
		failed = true;
	}
}

for (const { file, pattern, label } of requiredPatterns) {
	const path = join(root, file);
	if (!existsSync(path)) {
		console.error(`[verify-publish-safety] Missing: ${file}`);
		failed = true;
		continue;
	}
	const text = readFileSync(path, "utf8");
	if (!pattern.test(text)) {
		console.error(`[verify-publish-safety] Pattern fail (${label}): ${file}`);
		failed = true;
	}
}

for (const { file, pattern, label } of optionalPatterns) {
	const path = join(root, file);
	if (!existsSync(path)) {
		console.warn(`[verify-publish-safety] Optional missing: ${file} (${label})`);
		warned = true;
		continue;
	}
	const text = readFileSync(path, "utf8");
	if (!pattern.test(text)) {
		console.warn(`[verify-publish-safety] Optional pattern (${label}): ${file}`);
		warned = true;
	}
}

if (failed) {
	console.error("\nPublish safety verification failed.");
	process.exit(1);
}

console.log("Publish safety verification OK (files + key patterns).");
if (warned) {
	console.log("Optional LLM stack not present — see AI/PUBLISH-PLAN.md Phase 1.2.");
}
console.log("Next: Studio playtest — docs/studio-playtest-smoke.md");

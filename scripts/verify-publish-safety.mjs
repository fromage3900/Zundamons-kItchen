#!/usr/bin/env node
/**
 * Post-merge smoke checks for publish-safety artifacts (CI + local).
 * Studio playtest steps: docs/studio-playtest-smoke.md
 */
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL("..", import.meta.url)));

const requiredFiles = [
	"src/ReplicatedStorage/ConfigurationFiles/DisclaimerConfig.lua",
	"src/ReplicatedStorage/ConfigurationFiles/MarketplaceConfig.lua",
	"src/ReplicatedStorage/ConfigurationFiles/ClientGuiBootstrap.lua",
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
];

const requiredPatterns = [
	{
		file: "src/ServerScriptService/CompanionShopServer.server.lua",
		pattern: /RunService:IsStudio\(\)/,
		label: "Companion test grant Studio-gated",
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
		file: "src/ServerScriptService/Services/ZundapalLLMService.lua",
		pattern: /maxDailyMessagesPerUser|llm_disclaimer_accepted/,
		label: "LLM daily cap + disclaimer enforcement",
	},
	{
		file: "src/StarterPlayer/StarterPlayerScripts/VNController.client.lua",
		pattern: /AiBadge|AI mentor/,
		label: "VN AI mentor badge",
	},
	{
		file: "default.project.json",
		pattern: /GetLlmDisclaimerStatus/,
		label: "Disclaimer remotes in Rojo project",
	},
	{
		file: "src/ReplicatedStorage/ConfigurationFiles/RemoteManifest.lua",
		pattern: /GetLlmDisclaimerStatus/,
		label: "Disclaimer remotes in manifest",
	},
];

let failed = false;

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

if (failed) {
	console.error("\nPublish safety verification failed.");
	process.exit(1);
}

console.log("Publish safety verification OK (files + key patterns).");
console.log("Next: Studio playtest — docs/studio-playtest-smoke.md");

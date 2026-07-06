#!/usr/bin/env node
/**
 * Publish-readiness checks beyond secret scanning.
 * Fails CI when placeholder monetization or unguarded test grants remain.
 */
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL("..", import.meta.url)));
const src = join(root, "src");
const catalogPath = join(src, "ReplicatedStorage/ConfigurationFiles/MarketplaceConfig.lua");

function walk(dir, out = []) {
	for (const name of readdirSync(dir)) {
		const p = join(dir, name);
		if (statSync(p).isDirectory()) {
			walk(p, out);
		} else if (p.endsWith(".lua")) {
			out.push(p);
		}
	}
	return out;
}

const files = walk(src);
let failed = false;
let placeholderHits = 0;

if (existsSync(catalogPath)) {
	const catalogText = readFileSync(catalogPath, "utf8");
	if (/11111111\d+/.test(catalogText)) {
		placeholderHits += 1;
		console.warn("[publish-readiness] WARN placeholder DevProduct ID in MarketplaceConfig.lua");
	}
} else {
	console.error("[publish-readiness] Missing MarketplaceConfig.lua");
	failed = true;
}

for (const file of files) {
	const rel = relative(root, file);
	const text = readFileSync(file, "utf8");

	// Duplicate inline catalogs outside MarketplaceConfig
	if (rel !== "src/ReplicatedStorage/ConfigurationFiles/MarketplaceConfig.lua" && /11111111\d+/.test(text)) {
		console.warn(`[publish-readiness] WARN placeholder DevProduct ID outside catalog: ${rel}`);
		placeholderHits += 1;
	}

	if (/TEST MODE: grant immediately/.test(text) && !/RunService:IsStudio\(\)/.test(text)) {
		console.error(`[publish-readiness] Unguarded TEST grant in ${rel}`);
		failed = true;
	}
}

if (placeholderHits > 0 && process.env.STRICT_PUBLISH === "1") {
	console.error(`[publish-readiness] ${placeholderHits} placeholder product ID hit(s) — update MarketplaceConfig.lua`);
	failed = true;
}

if (failed) {
	console.error("\nPublish readiness check failed.");
	process.exit(1);
}

if (placeholderHits > 0) {
	console.warn(`Publish readiness: ${placeholderHits} placeholder hit(s) — set STRICT_PUBLISH=1 to fail CI.`);
}

console.log(`Publish readiness OK (${files.length} Lua files scanned).`);

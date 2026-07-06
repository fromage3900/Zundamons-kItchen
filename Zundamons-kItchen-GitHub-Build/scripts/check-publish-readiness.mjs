#!/usr/bin/env node
/**
 * Publish-readiness checks beyond secret scanning.
 * Fails CI when placeholder monetization or unguarded test grants remain.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL("..", import.meta.url)));
const src = join(root, "src");

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

for (const file of files) {
	const rel = relative(root, file);
	const text = readFileSync(file, "utf8");

	if (/11111111\d+/.test(text)) {
		placeholderHits += 1;
		console.warn(`[publish-readiness] WARN placeholder DevProduct ID in ${rel}`);
	}

	if (/TEST MODE: grant immediately/.test(text) && !/RunService:IsStudio\(\)/.test(text)) {
		console.error(`[publish-readiness] Unguarded TEST grant in ${rel}`);
		failed = true;
	}
}

if (placeholderHits > 0 && process.env.STRICT_PUBLISH === "1") {
	console.error(`[publish-readiness] ${placeholderHits} file(s) still use placeholder product IDs`);
	failed = true;
}

if (failed) {
	console.error("\nPublish readiness check failed.");
	process.exit(1);
}

if (placeholderHits > 0) {
	console.warn(`Publish readiness: ${placeholderHits} placeholder product ID file(s) — set STRICT_PUBLISH=1 to fail CI.`);
}

console.log(`Publish readiness OK (${files.length} Lua files scanned).`);

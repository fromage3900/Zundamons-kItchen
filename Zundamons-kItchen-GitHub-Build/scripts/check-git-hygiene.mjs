#!/usr/bin/env node
/**
 * Git hygiene checks for publish safety.
 */
import { execSync } from "node:child_process";
import { existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { join, dirname } from "node:path";

function findGitRoot(start) {
	let dir = start;
	while (dir !== dirname(dir)) {
		if (existsSync(join(dir, ".git"))) {
			return dir;
		}
		dir = dirname(dir);
	}
	return start;
}

const root = findGitRoot(join(dirname(fileURLToPath(import.meta.url)), ".."));

function gitLines(cmd) {
	return execSync(cmd, { cwd: root, encoding: "utf8" })
		.split("\n")
		.map((l) => l.trim())
		.filter(Boolean);
}

const errors = [];
const tracked = gitLines("git ls-files");

const forbiddenExtensions = [".rbxl", ".rbxlx", ".rbxmx"];
for (const path of tracked) {
	for (const ext of forbiddenExtensions) {
		if (path.endsWith(ext)) {
			errors.push(`Place export committed: ${path}`);
		}
	}
	if (path.startsWith("workspace/") || path.includes("/workspace/")) {
		errors.push(`Build output committed: ${path}`);
	}
	if (/\.env(\.|$)/i.test(path) && !path.endsWith(".example")) {
		errors.push(`Env file committed: ${path} — use Studio ServerStorage for secrets`);
	}
}

try {
	const gdataHits = execSync('git grep -n "_G\\.data\\[" -- "src/ServerScriptService" || true', {
		cwd: root,
		encoding: "utf8",
	});
	const lines = gdataHits.split("\n").filter((l) => l.trim());
	if (lines.length > 0) {
		errors.push(`Server still uses _G.data[...]:\n    ${lines.join("\n    ")}`);
	}
} catch {
	// ignore
}

if (errors.length > 0) {
	console.error("Git hygiene check failed:\n" + errors.map((e) => `- ${e}`).join("\n"));
	process.exit(1);
}

console.log(`Git hygiene passed (${tracked.length} tracked files).`);

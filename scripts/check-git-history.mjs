#!/usr/bin/env node
/**
 * Full git history secret scan (requires gitleaks CLI).
 * Falls back with exit 0 + warning when gitleaks is not installed (local dev).
 * Set STRICT_HISTORY=1 to fail when gitleaks is missing.
 */
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { join } from "node:path";

const root = join(fileURLToPath(new URL("..", import.meta.url)));

const result = spawnSync("gitleaks", ["detect", "--source", root, "--verbose", "--no-banner"], {
	encoding: "utf8",
});

if (result.error && result.error.code === "ENOENT") {
	const msg =
		"[git-history] gitleaks not installed — install from https://github.com/gitleaks/gitleaks";
	if (process.env.STRICT_HISTORY === "1") {
		console.error(msg);
		process.exit(1);
	}
	console.warn(msg);
	console.warn("[git-history] Skipped — run `npm run security` for HEAD-only scan.");
	process.exit(0);
}

if (result.stdout) {
	process.stdout.write(result.stdout);
}
if (result.stderr) {
	process.stderr.write(result.stderr);
}

if (result.status !== 0) {
	console.error("\nGit history secret scan failed.");
	process.exit(result.status ?? 1);
}

console.log("Git history secret scan OK.");

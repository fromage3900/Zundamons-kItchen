#!/usr/bin/env node
import { copyFileSync, chmodSync, existsSync, mkdirSync } from "node:fs";
import { execSync } from "node:child_process";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const buildRoot = join(dirname(fileURLToPath(import.meta.url)), "..");
const gitRoot = execSync("git rev-parse --show-toplevel", { cwd: buildRoot, encoding: "utf8" }).trim();
const hooksDir = join(gitRoot, ".git", "hooks");
const srcHook = join(buildRoot, ".githooks", "pre-push");
const destHook = join(hooksDir, "pre-push");

mkdirSync(hooksDir, { recursive: true });
if (!existsSync(srcHook)) {
	console.error("Missing .githooks/pre-push");
	process.exit(1);
}
copyFileSync(srcHook, destHook);
chmodSync(destHook, 0o755);
console.log("Installed pre-push hook → runs npm run security before git push");

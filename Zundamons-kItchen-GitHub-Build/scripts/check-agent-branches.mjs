#!/usr/bin/env node
/**
 * Agent branch monitor — run on a loop or in CI to detect OpenCode/Cline activity.
 * Usage: node scripts/check-agent-branches.mjs
 */
import { execSync } from "node:child_process";

const root = new URL("..", import.meta.url).pathname;

function run(cmd) {
	return execSync(cmd, { cwd: root, encoding: "utf8" }).trim();
}

try {
	run("git fetch origin --quiet");
} catch {
	console.warn("[monitor] git fetch failed — using cached refs");
}

const branches = run("git branch -r")
	.split("\n")
	.map((b) => b.trim().replace(/^origin\//, ""))
	.filter(Boolean);

const agentPrefixes = ["opencode/", "cline/", "cursor/"];
const agentBranches = branches.filter((b) => agentPrefixes.some((p) => b.startsWith(p)));

const mainHead = run("git rev-parse origin/main");
const localMain = run("git rev-parse main 2>/dev/null || echo unknown");

console.log("=== Agent branch monitor ===");
console.log("Time:", new Date().toISOString());
console.log("origin/main:", mainHead.slice(0, 8));
console.log("local main: ", localMain.slice(0, 8));

if (agentBranches.length === 0) {
	console.log("\nNo agent branches on remote (opencode/*, cline/*, cursor/*).");
} else {
	console.log("\nAgent branches:");
	for (const branch of agentBranches.sort()) {
		const ahead = run(`git rev-list --count origin/main..origin/${branch} 2>/dev/null || echo 0`);
		const behind = run(`git rev-list --count origin/${branch}..origin/main 2>/dev/null || echo 0`);
		console.log(`  ${branch}  (+${ahead} / -${behind} vs main)`);
	}
}

const opencode = agentBranches.filter((b) => b.startsWith("opencode/"));
const cline = agentBranches.filter((b) => b.startsWith("cline/"));

if (opencode.length === 0 && cline.length === 0) {
	console.log("\nOpenCode/Cline: no remote activity yet.");
	process.exit(0);
}

console.log("\nReview: diff each branch against main and run npm run validate");
process.exit(0);

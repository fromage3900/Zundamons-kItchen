#!/usr/bin/env node
/**
 * Scans tracked text files for accidental secret commits.
 * Run before push: npm run security:secrets
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

const ALLOWLIST_PATH_FRAGMENTS = [
	"docs/mcp-setup-guide.md",
	"docs/git-security.md",
	"AI/ZUNDAPAL_LLM_PLAN.md",
	"check-secrets.mjs",
];

const PATTERNS = [
	{ name: "OpenAI/DeepSeek API key", regex: /\bsk-[a-zA-Z0-9]{20,}\b/ },
	{ name: "Bearer token", regex: /Bearer\s+[a-zA-Z0-9._-]{20,}/ },
	{ name: "Roblox Open Cloud key", regex: /roblox[_-]?api[_-]?key\s*[:=]\s*["'][^"']{16,}["']/i },
	{ name: "Generic api_key assignment", regex: /api[_-]?key\s*[:=]\s*["'][a-zA-Z0-9._-]{24,}["']/i },
	{ name: "Private key block", regex: /-----BEGIN (RSA |EC )?PRIVATE KEY-----/ },
];

function listTrackedFiles() {
	const raw = execSync("git ls-files", { cwd: root, encoding: "utf8" });
	return raw
		.split("\n")
		.map((l) => l.trim())
		.filter(Boolean)
		.filter((p) => /\.(lua|md|json|mjs|js|toml|yml|yaml|env|txt)$/i.test(p));
}

function isAllowlisted(path) {
	return ALLOWLIST_PATH_FRAGMENTS.some((frag) => path.includes(frag));
}

function isPlaceholder(line) {
	return (
		/YOUR[_-]?KEY/i.test(line) ||
		/YOUR[_-]?FIGMA/i.test(line) ||
		/placeholder/i.test(line) ||
		/never commit/i.test(line) ||
		/example\.com/i.test(line)
	);
}

const files = listTrackedFiles();
const hits = [];

for (const rel of files) {
	if (isAllowlisted(rel)) {
		continue;
	}
	let content;
	try {
		content = execSync(`git show HEAD:${rel}`, { cwd: root, encoding: "utf8" });
	} catch {
		continue;
	}
	const lines = content.split("\n");
	for (let i = 0; i < lines.length; i++) {
		const line = lines[i];
		if (isPlaceholder(line)) {
			continue;
		}
		for (const { name, regex } of PATTERNS) {
			if (regex.test(line)) {
				hits.push({ rel, line: i + 1, name, snippet: line.trim().slice(0, 80) });
			}
		}
	}
}

if (hits.length > 0) {
	console.error("Secret scan failed — possible credentials in git:\n");
	for (const h of hits) {
		console.error(`  ${h.rel}:${h.line} [${h.name}] ${h.snippet}`);
	}
	process.exit(1);
}

console.log(`Secret scan passed (${files.length} tracked text files).`);

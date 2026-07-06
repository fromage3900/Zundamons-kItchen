#!/usr/bin/env node
/**
 * Ensures RemoteManifest.lua remote lists match default.project.json.
 */
import { readFileSync, existsSync } from "node:fs";
import { execSync } from "node:child_process";
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

const buildRoot = join(dirname(fileURLToPath(import.meta.url)), "..");
const root = findGitRoot(buildRoot);
const projectPath = join(buildRoot, "default.project.json");
const manifestPath = join(buildRoot, "src/ReplicatedStorage/ConfigurationFiles/RemoteManifest.lua");

const project = JSON.parse(readFileSync(projectPath, "utf8"));
const manifestSrc = readFileSync(manifestPath, "utf8");

function extractManifestArray(key) {
	const pattern = new RegExp(`${key}\\s*=\\s*\\{([^}]+)\\}`, "s");
	const match = manifestSrc.match(pattern);
	if (!match) {
		return [];
	}
	return [...match[1].matchAll(/"([^"]+)"/g)].map((m) => m[1]);
}

const projectEvents = Object.keys(project.tree.ReplicatedStorage.RemoteEvents).filter((k) => k !== "$className");
const projectFunctions = Object.keys(project.tree.ReplicatedStorage.RemoteFunctions).filter(
	(k) => k !== "$className"
);

const manifestEvents = extractManifestArray("remoteEvents");
const manifestFunctions = extractManifestArray("remoteFunctions");

const errors = [];

function diff(label, a, b) {
	const setA = new Set(a);
	const setB = new Set(b);
	for (const name of setA) {
		if (!setB.has(name)) {
			errors.push(`${label} "${name}" in default.project.json but missing from RemoteManifest.lua`);
		}
	}
	for (const name of setB) {
		if (!setA.has(name)) {
			errors.push(`${label} "${name}" in RemoteManifest.lua but missing from default.project.json`);
		}
	}
}

diff("RemoteEvent", projectEvents, manifestEvents);
diff("RemoteFunction", projectFunctions, manifestFunctions);

if (errors.length > 0) {
	console.error("Remote sync check failed:\n" + errors.map((e) => `- ${e}`).join("\n"));
	process.exit(1);
}

console.log(`Remote sync OK (${projectEvents.length} events, ${projectFunctions.length} functions).`);

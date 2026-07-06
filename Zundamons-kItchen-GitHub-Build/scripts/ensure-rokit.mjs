#!/usr/bin/env node
/**
 * Resolves Rokit-managed tool binaries for npm scripts and CI.
 * Checks ~/.rokit/bin (and Windows .exe names).
 */
import { existsSync } from "node:fs";
import { homedir, platform } from "node:os";
import { join } from "node:path";

function candidateBinDirs() {
	const dirs = [];
	if (process.env.ROKIT_ROOT) {
		dirs.push(join(process.env.ROKIT_ROOT, "bin"));
	}
	dirs.push(join(homedir(), ".rokit", "bin"));
	if (process.env.LOCALAPPDATA) {
		dirs.push(join(process.env.LOCALAPPDATA, ".rokit", "bin"));
	}
	if (process.env.USERPROFILE) {
		const userBin = join(process.env.USERPROFILE, ".rokit", "bin");
		if (!dirs.includes(userBin)) {
			dirs.push(userBin);
		}
	}
	return dirs;
}

function resolveToolInDir(dir, name) {
	const isWin = platform() === "win32";
	const candidates = isWin
		? [join(dir, `${name}.exe`), join(dir, `${name}.cmd`), join(dir, name)]
		: [join(dir, name)];
	for (const candidate of candidates) {
		if (existsSync(candidate)) {
			return candidate;
		}
	}
	return null;
}

export function rokitBinDir() {
	for (const dir of candidateBinDirs()) {
		if (resolveToolInDir(dir, "rojo")) {
			return dir;
		}
	}
	return null;
}

export function toolPath(name) {
	for (const dir of candidateBinDirs()) {
		const found = resolveToolInDir(dir, name);
		if (found) {
			return found;
		}
	}
	return name;
}

export function withRokitPath(env = process.env) {
	const dir = rokitBinDir();
	if (!dir) {
		return env;
	}
	const pathKey = Object.keys(env).find((k) => k.toLowerCase() === "path") ?? "PATH";
	const sep = platform() === "win32" ? ";" : ":";
	const existing = env[pathKey] ?? "";
	return {
		...env,
		[pathKey]: existing ? `${dir}${sep}${existing}` : dir,
	};
}

export function printRokitInstallHint() {
	console.error("\nRojo was not found.");
	console.error("Install tools with Rokit, then retry:\n");
	console.error("  rokit trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene");
	console.error("  rokit install");
	console.error("  npm run rojo:serve\n");
	console.error("If rokit is not installed:");
	console.error(
		"  Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression"
	);
	console.error("\nThen close PowerShell, open a new window, and run rokit install again.");
	console.error("Windows direct serve (if install worked):");
	console.error('  & "$env:USERPROFILE\\.rokit\\bin\\rojo.exe" serve default.project.json');
}

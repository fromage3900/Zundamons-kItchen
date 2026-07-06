#!/usr/bin/env node
/**
 * Start Rojo serve on port 34872. If the port is held by a stale node/rojo
 * process (common after closing a terminal without stopping serve), free it first.
 */
import { spawn, execSync } from "node:child_process";
import net from "node:net";
import { existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const PORT = 34872;
const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const project = join(root, "default.project.json");

const SAFE_WIN_PROCESS = new Set(["node.exe", "rojo.exe"]);

function sleep(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

function isPortFree(port) {
	return new Promise((resolve) => {
		const server = net.createServer();
		server.once("error", () => resolve(false));
		server.once("listening", () => server.close(() => resolve(true)));
		server.listen(port, "127.0.0.1");
	});
}

function getListeningPidsWindows(port) {
	try {
		const out = execSync(`netstat -ano | findstr :${port}`, {
			encoding: "utf8",
			stdio: ["pipe", "pipe", "ignore"],
		});
		const pids = new Set();
		for (const line of out.split("\n")) {
			if (!line.includes("LISTENING")) {
				continue;
			}
			const parts = line.trim().split(/\s+/);
			const pid = Number.parseInt(parts[parts.length - 1], 10);
			if (pid > 0) {
				pids.add(pid);
			}
		}
		return [...pids];
	} catch {
		return [];
	}
}

function getProcessNameWindows(pid) {
	try {
		const out = execSync(`tasklist /FI "PID eq ${pid}" /FO CSV /NH`, {
			encoding: "utf8",
			stdio: ["pipe", "pipe", "ignore"],
		});
		const match = out.match(/^"([^"]+)"/);
		return match ? match[1].toLowerCase() : "";
	} catch {
		return "";
	}
}

function killPidWindows(pid) {
	execSync(`taskkill /PID ${pid} /F`, { stdio: "inherit" });
}

async function freePort(port) {
	if (await isPortFree(port)) {
		return;
	}

	console.log(`[rojo:serve] Port ${port} is in use — checking for stale Rojo/node...`);

	if (process.platform === "win32") {
		const pids = getListeningPidsWindows(port);
		let freed = false;
		for (const pid of pids) {
			const name = getProcessNameWindows(pid);
			if (SAFE_WIN_PROCESS.has(name)) {
				console.log(`[rojo:serve] Stopping ${name} (PID ${pid})`);
				killPidWindows(pid);
				freed = true;
			} else {
				console.warn(
					`[rojo:serve] Port held by ${name || "unknown"} (PID ${pid}) — not auto-killing.`,
				);
				console.warn(`[rojo:serve] Run: taskkill /PID ${pid} /F`);
			}
		}
		if (freed) {
			await sleep(600);
		}
	} else {
		try {
			execSync(`fuser -k ${port}/tcp`, { stdio: "ignore" });
			await sleep(400);
		} catch {
			// fuser may be unavailable
		}
	}

	if (await isPortFree(port)) {
		return;
	}

	console.error(`[rojo:serve] Port ${port} is still busy.`);
	if (process.platform === "win32") {
		console.error(`[rojo:serve] Run: netstat -ano | findstr :${port}`);
		console.error(`[rojo:serve] Then: taskkill /PID <pid> /F`);
	}
	process.exit(1);
}

function spawnRojo() {
	const args = ["exec", "rojo", "--", "serve", "default.project.json", "--port", String(PORT)];
	const npm = process.platform === "win32" ? "npm.cmd" : "npm";
	return spawn(npm, args, {
		cwd: root,
		stdio: "inherit",
		shell: process.platform === "win32",
	});
}

async function main() {
	if (!existsSync(project)) {
		console.error("[rojo:serve] Missing default.project.json in:", root);
		process.exit(1);
	}

	await freePort(PORT);

	console.log(`[rojo:serve] Starting on http://127.0.0.1:${PORT}`);
	console.log("[rojo:serve] Studio: Plugins → Rojo → Connect (leave this terminal open)\n");

	const child = spawnRojo();

	child.on("error", (err) => {
		console.error("[rojo:serve]", err.message);
		process.exit(1);
	});

	child.on("exit", (code) => process.exit(code ?? 1));
}

main();

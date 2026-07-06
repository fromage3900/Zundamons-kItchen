#!/usr/bin/env node
/**
 * Start Rojo serve. Prefers port 34872; frees stale node/rojo there, or falls
 * back to 34873+ when another app (e.g. Cursor port-forward) holds 34872.
 */
import { spawn, execSync } from "node:child_process";
import net from "node:net";
import { existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const DEFAULT_PORT = 34872;
const FALLBACK_PORTS = [34873, 34874, 34875, 34876, 34877, 34878, 34879];
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

/** Try to clear stale node/rojo on port. Returns true if port is free after. */
async function tryClearStaleRojo(port) {
	if (await isPortFree(port)) {
		return true;
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
					`[rojo:serve] Port ${port} held by ${name || "unknown"} (PID ${pid}) — skipping.`,
				);
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

	return isPortFree(port);
}

async function resolvePort() {
	const envPort = Number(process.env.ROJO_PORT);
	if (envPort > 0) {
		if (await tryClearStaleRojo(envPort)) {
			return envPort;
		}
		console.error(`[rojo:serve] ROJO_PORT=${envPort} is busy.`);
		process.exit(1);
	}

	if (await tryClearStaleRojo(DEFAULT_PORT)) {
		return DEFAULT_PORT;
	}

	for (const port of FALLBACK_PORTS) {
		if (await isPortFree(port)) {
			console.log(
				`[rojo:serve] Port ${DEFAULT_PORT} busy (often Cursor port-forward) — using ${port} instead.`,
			);
			console.log(
				`[rojo:serve] In Studio: Plugins → Rojo → Connect → host localhost, port ${port}`,
			);
			return port;
		}
	}

	console.error(`[rojo:serve] No free port in ${DEFAULT_PORT}–${FALLBACK_PORTS[FALLBACK_PORTS.length - 1]} range.`);
	if (process.platform === "win32") {
		console.error(`[rojo:serve] Run: netstat -ano | findstr :${DEFAULT_PORT}`);
	}
	process.exit(1);
}

function spawnRojo(port) {
	const args = ["exec", "rojo", "--", "serve", "default.project.json", "--port", String(port)];
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

	const port = await resolvePort();

	console.log(`[rojo:serve] Starting on http://127.0.0.1:${port}`);
	console.log("[rojo:serve] Studio: Plugins → Rojo → Connect (leave this terminal open)\n");

	const child = spawnRojo(port);

	child.on("error", (err) => {
		console.error("[rojo:serve]", err.message);
		process.exit(1);
	});

	child.on("exit", (code) => process.exit(code ?? 1));
}

main();

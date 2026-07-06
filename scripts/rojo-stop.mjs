#!/usr/bin/env node
/** Stop whatever is listening on Rojo's default port (34872). */
import { execSync } from "node:child_process";

const PORT = 34872;

if (process.platform === "win32") {
	try {
		const out = execSync(`netstat -ano | findstr :${PORT}`, {
			encoding: "utf8",
			stdio: ["pipe", "pipe", "ignore"],
		});
		const pids = new Set();
		for (const line of out.split("\n")) {
			if (!line.includes("LISTENING")) {
				continue;
			}
			const pid = Number.parseInt(line.trim().split(/\s+/).pop(), 10);
			if (pid > 0) {
				pids.add(pid);
			}
		}
		if (pids.size === 0) {
			console.log(`[rojo:stop] Nothing listening on port ${PORT}`);
			process.exit(0);
		}
		for (const pid of pids) {
			console.log(`[rojo:stop] taskkill /PID ${pid} /F`);
			execSync(`taskkill /PID ${pid} /F`, { stdio: "inherit" });
		}
	} catch {
		console.log(`[rojo:stop] Nothing listening on port ${PORT}`);
	}
} else {
	try {
		execSync(`fuser -k ${PORT}/tcp`, { stdio: "inherit" });
	} catch {
		console.log(`[rojo:stop] Nothing listening on port ${PORT}`);
	}
}

#!/usr/bin/env node
import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { printRokitInstallHint, toolPath, withRokitPath } from "./ensure-rokit.mjs";

const root = join(fileURLToPath(new URL("..", import.meta.url)));
const project = join(root, "default.project.json");

if (!existsSync(project)) {
	console.error("Missing default.project.json in:", root);
	console.error("Run this from Zundamons-kItchen-GitHub-Build/ (or npm run rojo:serve from repo root).");
	process.exit(1);
}

const rojo = toolPath("rojo");
if (!existsSync(rojo) && rojo === "rojo") {
	printRokitInstallHint();
	process.exit(1);
}

console.log("Starting Rojo server...");
console.log("  project:", project);
console.log("  rojo:   ", rojo);
console.log("  connect Studio plugin to localhost:34872");
console.log("  (leave this terminal open while Studio is connected)\n");

const child = spawn(rojo, ["serve", "default.project.json"], {
	cwd: root,
	stdio: "inherit",
	env: withRokitPath(),
	shell: false,
});

child.on("error", (err) => {
	console.error(err.message);
	printRokitInstallHint();
	process.exit(1);
});

child.on("exit", (code) => process.exit(code ?? 1));

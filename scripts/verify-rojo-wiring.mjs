#!/usr/bin/env node
/**
 * P0 Rojo wiring checks: remotes, module paths, no duplicate ServeGuest in RemoteEvents.
 */
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL("..", import.meta.url)));
let failed = false;

function read(rel) {
	return readFileSync(join(root, rel), "utf8");
}

function requireFile(rel) {
	if (!existsSync(join(root, rel))) {
		console.error(`[verify-rojo-wiring] Missing: ${rel}`);
		failed = true;
		return "";
	}
	return read(rel);
}

const requiredPaths = [
	"src/ReplicatedStorage/RemoteFunctions/init.meta.json",
	"src/ReplicatedStorage/RewardEvents/init.meta.json",
	"src/ReplicatedStorage/Loot/init.meta.json",
	"src/Workspace/GameplayLoopArea/init.meta.json",
];

for (const rel of requiredPaths) {
	requireFile(rel);
}

const rfMeta = read("src/ReplicatedStorage/RemoteFunctions/init.meta.json");
const reMeta = read("src/ReplicatedStorage/RemoteEvents/init.meta.json");
const project = read("default.project.json");

const requiredRF = ["ServeGuest", "CraftFunction", "RequestData", "GiveLoot"];
for (const name of requiredRF) {
	if (!rfMeta.includes(`"${name}"`)) {
		console.error(`[verify-rojo-wiring] RemoteFunctions missing ${name}`);
		failed = true;
	}
}

if (reMeta.includes('"ServeGuest"')) {
	console.error("[verify-rojo-wiring] ServeGuest must be RemoteFunction only (remove from RemoteEvents)");
	failed = true;
}

if (!project.includes("RemoteFunctions")) {
	console.error("[verify-rojo-wiring] default.project.json missing RemoteFunctions");
	failed = true;
}

const badRequires = [
	["src/ServerScriptService/ZundaGatherServer.server.lua", /Shared.*LootModule/],
	["src/ServerScriptService/Mineable.server.lua", /SSS:WaitForChild\("LootModule"\)/],
	["src/ServerScriptService/ServingSystem.server.lua", /ServerScriptService:WaitForChild\("RewardCore"\)/],
	["src/ServerScriptService/ServingSystem.server.lua", /playerData\.Gold\s=/],
];

for (const [file, pattern] of badRequires) {
	const text = requireFile(file);
	if (text && pattern.test(text)) {
		console.error(`[verify-rojo-wiring] Bad pattern in ${file}: ${pattern}`);
		failed = true;
	}
}

const guestDetector = requireFile("src/StarterPlayer/StarterPlayerScripts/VNController.client.lua");
if (guestDetector.includes("character = script.Parent")) {
	console.error("[verify-rojo-wiring] GuestDetector still uses script.Parent as character");
	failed = true;
}

const vnController = requireFile("src/StarterPlayer/StarterPlayerScripts/VNController.client.lua");
if (vnController.includes("script.Parent") && !vnController.includes("ClientGuiBootstrap")) {
	console.error("[verify-rojo-wiring] VNController still uses script.Parent without bootstrap");
	failed = true;
}
if (!vnController.includes("ZundaVNGui")) {
	console.error("[verify-rojo-wiring] VNController missing ZundaVNGui bootstrap");
	failed = true;
}

if (failed) {
	console.error("\nRojo wiring verification failed.");
	process.exit(1);
}

console.log("Rojo wiring verification OK (RemoteFunctions, module paths, GuestDetector).");

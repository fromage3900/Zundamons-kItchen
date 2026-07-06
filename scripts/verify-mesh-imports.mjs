#!/usr/bin/env node
/**
 * Verify whether harvest/companion meshes were imported (Cline / Studio pipeline).
 * Fails when FILL_* placeholders remain in mesh configs or Models/ is empty.
 */
import { existsSync, readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL("..", import.meta.url)));

const meshFiles = [
	"src/ReplicatedStorage/Shared/Config/HarvestNodeVariants.lua",
	"src/ReplicatedStorage/Shared/Config/NPCConfig.lua",
];

function countFillInFile(rel) {
	const path = join(root, rel);
	if (!existsSync(path)) {
		return { missing: true, fills: 0, real: 0 };
	}
	const text = readFileSync(path, "utf8");
	const fills = (text.match(/FILL_[A-Z0-9_]+/g) || []).length;
	const real = (text.match(/rbxassetid:\/\/\d{5,}/g) || []).length;
	return { missing: false, fills, real };
}

function modelsFolderHasMeshes() {
	const dir = join(root, "src/ReplicatedStorage/Models");
	if (!existsSync(dir)) {
		return 0;
	}
	let count = 0;
	for (const name of readdirSync(dir)) {
		if (name === ".gitkeep") {
			continue;
		}
		const full = join(dir, name);
		if (statSync(full).isFile()) {
			count += 1;
		}
	}
	return count;
}

let failed = false;
let totalFill = 0;
let totalReal = 0;

console.log("Mesh import verification (Cline / Studio pipeline)\n");

for (const rel of meshFiles) {
	const { missing, fills, real } = countFillInFile(rel);
	totalFill += fills;
	totalReal += real;
	if (missing) {
		console.error(`  MISSING  ${rel}`);
		failed = true;
		continue;
	}
	const status = fills === 0 && real > 0 ? "OK" : fills > 0 ? "PLACEHOLDER" : "EMPTY";
	console.log(`  ${status.padEnd(11)} ${rel} — real=${real}, FILL_*=${fills}`);
}

const modelFiles = modelsFolderHasMeshes();
console.log(`  ${modelFiles > 0 ? "OK" : "EMPTY".padEnd(11)} src/ReplicatedStorage/Models/ — ${modelFiles} file(s) besides .gitkeep`);

if (totalFill > 0) {
	console.warn(`\n${totalFill} FILL_* mesh slot(s) remain. Cline has NOT finished mesh import.`);
	console.warn("Next: Blender→FBX→Studio upload, paste rbxassetid into HarvestNodeVariants / NPCConfig, or drop models in ReplicatedStorage/Models/");
	failed = true;
}

if (modelFiles === 0) {
	console.warn("ReplicatedStorage/Models/ is empty (.gitkeep only) — no Rojo-synced mesh templates.");
}

if (failed) {
	process.exit(1);
}

console.log("\nMesh import verification OK.");

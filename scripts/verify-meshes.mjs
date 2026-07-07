#!/usr/bin/env node
import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = join(fileURLToPath(import.meta.url), "..");
const ROOT = join(__dirname, "..");

const files = [
  "src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua",
  "src/ReplicatedStorage/Shared/Config/HarvestNodeVariants.lua",
  "src/ReplicatedStorage/Shared/Config/NPCConfig.lua",
  "src/ReplicatedStorage/Shared/Config/VNDialoguePortraits.lua",
  "src/ReplicatedStorage/ConfigurationFiles/CursorConfig.lua",
  "src/ReplicatedStorage/Shared/Config/UIAssets.lua",
  "src/ReplicatedStorage/Shared/Config/ArchitectureVariants.lua",
  "src/ReplicatedStorage/ConfigurationFiles/DecorationConfig.lua",
  "src/ServerScriptService/CompanionManager.server.lua",
];

let totalRefs = 0;
let suspiciousRefs = 0;
let results = [];

for (const file of files) {
  const path = join(ROOT, file);
  if (!existsSync(path)) continue;
  const content = readFileSync(path, "utf-8");
  const refs = content.match(/rbxassetid:\/\/\d+/g) || [];
  const suspicious = refs.filter(id => {
    const num = parseInt(id.replace("rbxassetid://", ""));
    // Known fake patterns: sequential numbers, very short, or known placeholder ranges
    return num < 100000 || (num >= 12345670 && num <= 12345680) || id.includes("FILL_");
  });
  const real = refs.filter(id => !suspicious.includes(id));
  totalRefs += refs.length;
  suspiciousRefs += suspicious.length;
  if (refs.length > 0) {
    results.push({ file, total: refs.length, suspicious: suspicious.length, sample: refs.slice(0, 3) });
  }
}

console.log("=== Mesh ID Verification ===");
console.log(`Files scanned: ${files.length}`);
console.log(`Total asset refs: ${totalRefs}`);
console.log(`Suspicious (fake/placeholder): ${suspiciousRefs}`);
console.log(`Likely real: ${totalRefs - suspiciousRefs}`);
console.log("");
for (const r of results) {
  const status = r.suspicious === r.total ? "ALL FAKE" : r.suspicious > 0 ? `${r.suspicious}/${r.total} FAKE` : "ALL REAL";
  console.log(`${r.file}: ${r.total} refs (${status})`);
}
console.log("\nNote: 'Real' means the number isn't in known placeholder ranges.");
console.log("True verification requires trying to load each asset in Roblox.");

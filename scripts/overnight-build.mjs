#!/usr/bin/env node
import { existsSync, readFileSync, writeFileSync, readdirSync, mkdirSync } from "node:fs";
import { execSync } from "node:child_process";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const ROOT = join(__filename, "../..");
const LOG = [];
const WARN = [];
const ERR = [];

function log(msg) { LOG.push(`[INFO] ${msg}`); console.log(`  ${msg}`); }
function warn(msg) { WARN.push(`[WARN] ${msg}`); console.warn(`  ⚠ ${msg}`); }
function err(msg) { ERR.push(`[ERR]  ${msg}`); console.error(`  ✗ ${msg}`); }

function readFile(path) {
  const full = join(ROOT, path);
  if (!existsSync(full)) { err(`Missing: ${path}`); return ""; }
  return readFileSync(full, "utf-8");
}

// Extract entries matching pattern from Lua source
function extractEntries(src, pattern) {
  const results = [];
  const regex = new RegExp(pattern, "g");
  let match;
  while ((match = regex.exec(src)) !== null) results.push(match[1] || match[0]);
  return [...new Set(results)];
}

function extractEntriesWithDupes(src, pattern) {
  const results = [];
  const regex = new RegExp(pattern, "g");
  let match;
  while ((match = regex.exec(src)) !== null) results.push(match[1] || match[0]);
  return results;
}

function countPattern(src, pattern) {
  return (src.match(new RegExp(pattern, "g")) || []).length;
}

const SRC = join(ROOT, "src");

log("=== OVERNIGHT BUILD — Config Validation & Generation ===");
log(`Root: ${ROOT}`);
log("");

// ─── Phase 1: Load configs ──────────────────────────────────
log("Phase 1: Loading configs...");

const craftConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/CraftConfig.lua");
const progressionConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/ProgressionConfig.lua");
const questConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/QuestConfig.lua");
const gatherConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/GatherConfig.lua");
const chefLevelConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/ChefLevelConfig.lua");
const scatterConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/ScatterConfig.lua");
const meshAssets = readFile("src/ReplicatedStorage/ConfigurationFiles/MeshAssets.lua");
const decorationConfig = readFile("src/ReplicatedStorage/ConfigurationFiles/DecorationConfig.lua");
const npcConfig = readFile("src/ReplicatedStorage/Shared/Config/NPCConfig.lua");
const harvestVariants = readFile("src/ReplicatedStorage/Shared/Config/HarvestNodeVariants.lua");

const allConfigs = {
  craft: craftConfig, progression: progressionConfig, quests: questConfig,
  gather: gatherConfig, chef: chefLevelConfig, scatter: scatterConfig,
  meshes: meshAssets, decor: decorationConfig, npc: npcConfig, harvest: harvestVariants
};
Object.entries(allConfigs).forEach(([name, content]) => {
  if (content.length < 10) warn(`${name}Config appears empty or unreadable`);
  else log(`  ${name}: ${content.length} bytes`);
});

// ─── Phase 2: Cross-reference validation ────────────────────
log("");
log("Phase 2: Cross-reference validation...");

// Extract all recipe names and ingredients
const recipePattern = /\["([^"]+)"\]\s*=\s*\{([^}]+)\}/g;
const recipes = {};
let rMatch;
while ((rMatch = recipePattern.exec(craftConfig)) !== null) {
  const name = rMatch[1];
  const ings = rMatch[2];
  const ingredients = {};
  const ingPattern = /\["([^"]+)"\]\s*=\s*(\d+)/g;
  let iMatch;
  while ((iMatch = ingPattern.exec(ings)) !== null) {
    ingredients[iMatch[1]] = parseInt(iMatch[2]);
  }
  recipes[name] = ingredients;
}

log(`  ${Object.keys(recipes).length} recipes found`);

// Extract all gatherable items from GatherConfig
const gatherItems = extractEntries(gatherConfig, /itemName\s*=\s*"([^"]+)"/g);
log(`  ${gatherItems.length} gatherable items`);
log(`    ${gatherItems.join(", ")}`);

// Check recipe ingredients against gatherable items + base items
const baseItems = ["Gold", "Apple", "Wheat", "Wood Log", "Pine Cone", "WheatSeed", "Iron Ore", "Marble Rock"];
const allItems = new Set([...gatherItems, ...baseItems]);
const missingIngredients = [];

for (const [recipeName, ings] of Object.entries(recipes)) {
  for (const ing of Object.keys(ings)) {
    if (!allItems.has(ing) && ing !== "Gold") {
      missingIngredients.push(`${recipeName} → ${ing}`);
    }
  }
}
if (missingIngredients.length > 0) {
  warn(`Recipes reference ungatherable items: ${missingIngredients.join(", ")}`);
} else {
  log("  All recipe ingredients reference valid items");
}

// Extract progression milestones
const milestoneRecipes = extractEntries(progressionConfig, /[{\s]recipes\s*=\s*\{([^}]+)\}/g);
const unlockedRecipes = milestoneRecipes.flatMap(m => extractEntries(m, /"([^"]+)"/g));
log(`  Progression milestones: ${countPattern(progressionConfig, "guests_served")} tiers`);
log(`  Recipes unlocked by milestones: ${unlockedRecipes.length}`);

const notUnlocked = Object.keys(recipes).filter(r => !unlockedRecipes.includes(r));
if (notUnlocked.length > 0) {
  log(`  ${notUnlocked.length} recipes unlocked via quests only:`);
  notUnlocked.forEach(r => log(`    ${r}`));
}

// ─── Phase 3: Quest audit ───────────────────────────────────
log("");
log("Phase 3: Quest audit...");

const questIds = extractEntries(questConfig, /id\s*=\s*"([^"]+)"/g);
const questTypes = extractEntries(questConfig, /type\s*=\s*"([^"]+)"/g);
const questChains = extractEntriesWithDupes(questConfig, /chain_id\s*=\s*"([^"]+)"/g);
const questRewards = extractEntries(questConfig, /items\s*=\s*\{([^}]+)\}/g);

log(`  ${questIds.length} quests`);
log(`  Types: ${[...new Set(questTypes)].join(", ")}`);

const chainCounts = {};
questChains.forEach(c => { chainCounts[c] = (chainCounts[c] || 0) + 1; });
if (Object.keys(chainCounts).length > 0) {
  log("  Chains:");
  Object.entries(chainCounts).forEach(([chain, count]) => log(`    ${chain}: ${count} steps`));
}

// Check that cook quest target_items match actual recipe names
const cookTargets = [];
const cookPattern = /type\s*=\s*"cook"[^}]*target_item\s*=\s*"([^"]+)"/gs;
let cMatch;
while ((cMatch = cookPattern.exec(questConfig)) !== null) cookTargets.push(cMatch[1]);

const unmatchedTargets = cookTargets.filter(t => !recipes[t]);
if (unmatchedTargets.length > 0) {
  warn(`Cook quests target nonexistent recipes: ${unmatchedTargets.join(", ")}`);
} else {
  log(`  All cook quest targets match recipes`);
}

const gatherTargets = [];
const gPattern = /type\s*=\s*"gather"[^}]*target_item\s*=\s*"([^"]+)"/gs;
let gMatch;
while ((gMatch = gPattern.exec(questConfig)) !== null) gatherTargets.push(gMatch[1]);

const unmatchedGather = gatherTargets.filter(t => !allItems.has(t));
if (unmatchedGather.length > 0) {
  warn(`Gather quests target ungatherable items: ${unmatchedGather.join(", ")}`);
}

// ─── Phase 4: Asset scan ────────────────────────────────────
log("");
log("Phase 4: Asset ID scan...");

// Check all Lua files for asset IDs
function scanFiles(dir) {
  const entries = readdirSync(dir, { withFileTypes: true });
  let count = 0;
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) count += scanFiles(full);
    else if (entry.name.endsWith(".lua")) {
      try {
        const content = readFileSync(full, "utf-8");
        count += (content.match(/rbxassetid:\/\/\d+/g) || []).length;
      } catch {}
    }
  }
  return count;
}

const totalAssetIds = scanFiles(join(ROOT, "src"));
const placeholderCount = countPattern(meshAssets, "FILL_") + countPattern(decorationConfig, "FILL_") + countPattern(chefLevelConfig, "1234567\\d");
log(`  ${totalAssetIds} total rbxassetid:// references in src/`);
if (placeholderCount > 0) warn(`${placeholderCount} FILL_ or placeholder IDs remaining`);
else log("  No placeholder IDs found");

// ─── Phase 5: Scatter ecosystem check ───────────────────────
log("");
log("Phase 5: Scatter ecosystem check...");

const biomes = extractEntries(scatterConfig, /display\s*=\s*"([^"]+)"/g);
const resourceTypes = extractEntries(scatterConfig, /resourceType\s*=\s*"([^"]+)"/g);
log(`  ${biomes.length} biomes: ${biomes.join(", ")}`);
log(`  ${resourceTypes.length} resource types scattered`);

const scatterScript = readFile("src/ServerScriptService/Services/ScatterService.server.lua");
const hasCubeFallback = scatterScript.includes("RESOURCE_COLORS") || scatterScript.includes('Color3.fromRGB');
log(`  Cube fallback: ${hasCubeFallback ? "✅" : "❌"}`);

const envBootstrap = readFile("src/ServerScriptService/EnvironmentBootstrap.server.lua");
const autoScatterDisabled = envBootstrap.includes("DISABLED: bootstrapEnvironment()");
log(`  Auto-scatter disabled: ${autoScatterDisabled ? "✅" : "❌"}`);

// Check that all biomes have matching mesh assets
const meshTypes = extractEntries(meshAssets, /(\w+)\s*=\s*\{/g);
log(`  Mesh asset types: ${meshTypes.length}`);

// ─── Phase 6: Script health ─────────────────────────────────
log("");
log("Phase 6: Script health...");

let serverScripts = 0, clientScripts = 0, moduleScripts = 0;
function countScripts(dir) {
  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) countScripts(full);
    else if (entry.name.endsWith(".lua")) {
      if (entry.name.includes(".server.lua")) serverScripts++;
      else if (entry.name.includes(".client.lua")) clientScripts++;
      else moduleScripts++;
    }
  }
}
countScripts(SRC);
log(`  ${serverScripts} server, ${clientScripts} client, ${moduleScripts} module scripts`);

// Check WaitForChild patterns
let wfcTotal = 0, wfcUnsafe = 0;
function checkWFC(dir) {
  const entries = readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) checkWFC(full);
    else if (entry.name.endsWith(".lua")) {
      try {
        const content = readFileSync(full, "utf-8");
        const wfcCalls = content.match(/:WaitForChild\(/g);
        if (wfcCalls) {
          wfcTotal += wfcCalls.length;
          const timed = content.match(/:WaitForChild\("[^"]+",\s*\d+/g) || [];
          wfcUnsafe += wfcCalls.length - timed.length;
        }
      } catch {}
    }
  }
}
checkWFC(SRC);
log(`  WaitForChild calls: ${wfcTotal} total, ${wfcUnsafe} without timeout`);
if (wfcUnsafe > 10) warn(`${wfcUnsafe} WaitForChild calls without timeout — potential startup hangs`);

// ─── Phase 7: Generate report ───────────────────────────────
log("");
log("Phase 7: Generating report...");

const reportsDir = join(ROOT, "reports");
if (!existsSync(reportsDir)) mkdirSync(reportsDir, { recursive: true });

const date = new Date().toISOString().slice(0, 10);
const reportPath = join(reportsDir, `overnight-${date}.md`);
const report = [
  `# Overnight Build Report — ${date}`,
  "",
  "## Summary",
  `| Check | Result |`,
  `|-------|--------|`,
  `| Recipes | ${Object.keys(recipes).length} defined |`,
  `| Quests | ${questIds.length} defined |`,
  `| Chains | ${Object.keys(chainCounts).length} active |`,
  `| Scatter biomes | ${biomes.length} configured |`,
  `| Asset IDs | ${totalAssetIds} total |`,
  `| Scripts | ${serverScripts}S + ${clientScripts}C + ${moduleScripts}M |`,
  `| WaitForChild unsafe | ${wfcUnsafe} |`,
  `| Placeholder IDs | ${placeholderCount} |`,
  `| Errors | ${ERR.length} |`,
  `| Warnings | ${WARN.length} |`,
  "",
  "## Recipes",
  ...Object.entries(recipes).map(([name, ings]) =>
    `- **${name}**: ${Object.entries(ings).map(([i, c]) => `${i}×${c}`).join(", ")}`
  ),
  "",
  "## Biomes",
  ...biomes.map(b => `- ${b}`),
  "",
  "## Errors",
  ...(ERR.length ? ERR.map(e => `- ${e}`) : ["None"]),
  "",
  "## Warnings",
  ...(WARN.length ? WARN.map(w => `- ${w}`) : ["None"]),
  "",
  "## Quest Types",
  ...[...new Set(questTypes)].map(t => `- ${t}`),
  "",
  "## Not unlocked by milestones",
  ...(notUnlocked.length ? notUnlocked.map(r => `- ${r} (quest-only)`) : ["All recipes unlocked by milestones"]),
];

writeFileSync(reportPath, report.join("\n"));
log(`  Report: reports/overnight-${date}.md`);

// ─── Phase 8: Build ─────────────────────────────────────────
log("");
log("Phase 8: Build verification...");

try {
  execSync(`rojo build default.project.json -o "${join(ROOT, "reports/zunda-build-test.rbxl")}"`, {
    cwd: ROOT, encoding: "utf-8", timeout: 30000, stdio: "pipe"
  });
  log("  Build: PASSED ✅");
  report.push("\n## Build\n✅ Passed");
} catch (e) {
  err(`Build failed: ${e.stderr?.slice(0, 500) || e.message}`);
  report.push(`\n## Build\n❌ Failed`);
}

// Final summary
report.push("");
report.push("---");
report.push(`Generated: ${new Date().toISOString()}`);
writeFileSync(reportPath, report.join("\n"));

log("");
log("=== OVERNIGHT BUILD COMPLETE ===");
log(`  ${LOG.length} lines, ${WARN.length} warnings, ${ERR.length} errors`);
log(`  Report: reports/overnight-${date}.md`);

if (ERR.length > 0) process.exit(1);

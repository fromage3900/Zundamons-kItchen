#!/usr/bin/env node
import { existsSync, readdirSync, statSync } from "node:fs";
import { execSync } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

function countLuaFiles(dir) {
  let count = 0;
  const files = readdirSync(dir);
  for (const file of files) {
    const full = join(dir, file);
    if (statSync(full).isDirectory()) {
      count += countLuaFiles(full);
    } else if (file.endsWith(".lua")) {
      count++;
    }
  }
  return count;
}

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const errors = [];

function requirePath(relativePath, kind = "path") {
  const fullPath = join(root, relativePath);
  if (!existsSync(fullPath)) {
    errors.push(`Missing ${kind}: ${relativePath}`);
  }
}

requirePath("default.project.json", "Rojo project file");
requirePath("src/ServerScriptService", "directory");
requirePath("src/ReplicatedStorage/ConfigurationFiles", "directory");
requirePath("src/StarterPlayer/StarterPlayerScripts", "directory");

let luaCount = 0;
try {
  luaCount = countLuaFiles(join(root, "src"));
} catch (e) {
  errors.push(`Error counting Lua files: ${e.message}`);
}

if (luaCount < 1) {
  errors.push("No .lua files found under src/");
}

if (existsSync(join(root, "source"))) {
  errors.push("Legacy source/ directory still exists; Rojo workflow uses src/ only");
}

try {
  const outputPath = join(root, "rojo-build-test.rbxl");
  execSync(`npx rojo build default.project.json -o "${outputPath}"`, {
    cwd: root,
    stdio: "pipe",
  });
} catch (error) {
  errors.push("rojo build failed — check default.project.json and src/ layout");
  if (error.stderr) {
    errors.push(String(error.stderr));
  }
}

if (errors.length > 0) {
  console.error("Validation failed:\n" + errors.map((e) => `- ${e}`).join("\n"));
  process.exit(1);
}

console.log(`Rojo project valid (${luaCount} Lua files under src/).`);

#!/usr/bin/env node
import { existsSync } from "node:fs";
import { execSync } from "node:child_process";
import { join } from "node:path";
import { toolPath, withRokitPath } from "./ensure-rokit.mjs";

const root = new URL("..", import.meta.url).pathname;
const errors = [];

function requirePath(relativePath, kind = "path") {
  const fullPath = join(root, relativePath);
  if (!existsSync(fullPath)) {
    errors.push(`Missing ${kind}: ${relativePath}`);
  }
}

requirePath("default.project.json", "Rojo project file");
requirePath("rokit.toml", "Rokit manifest");
requirePath("src/ServerScriptService", "directory");
requirePath("src/ReplicatedStorage/ConfigurationFiles", "directory");
requirePath("src/StarterPlayer/StarterPlayerScripts", "directory");

const luaCount = Number(
  execSync('find src -name "*.lua" | wc -l', { cwd: root, encoding: "utf8" }).trim()
);

if (luaCount < 1) {
  errors.push("No .lua files found under src/");
}

if (existsSync(join(root, "source"))) {
  errors.push("Legacy source/ directory still exists; Rojo workflow uses src/ only");
}

const rojo = toolPath("rojo");
try {
  execSync(`${rojo} build default.project.json -o /tmp/zundamon-rojo-test.rbxl`, {
    cwd: root,
    stdio: "pipe",
    env: withRokitPath(),
  });
} catch (error) {
  errors.push("rojo build failed — check default.project.json, rokit.toml, and src/ layout");
  if (error.stderr) {
    errors.push(String(error.stderr));
  }
}

if (errors.length > 0) {
  console.error("Validation failed:\n" + errors.map((e) => `- ${e}`).join("\n"));
  process.exit(1);
}

console.log(`Rojo project valid (${luaCount} Lua files under src/).`);

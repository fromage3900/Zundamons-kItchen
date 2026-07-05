#!/usr/bin/env node
import { execSync } from "node:child_process";
import { mkdirSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { toolPath, withRokitPath } from "./ensure-rokit.mjs";

const root = join(fileURLToPath(new URL("..", import.meta.url)));
const outDir = join(root, "workspace");
mkdirSync(outDir, { recursive: true });
const output = join(outDir, "Zundamons-kItchen.rbxl");
const rojo = toolPath("rojo");

execSync(`${JSON.stringify(rojo)} build default.project.json -o ${JSON.stringify(output)}`, {
  cwd: root,
  stdio: "inherit",
  env: withRokitPath(),
});

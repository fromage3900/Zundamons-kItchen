#!/usr/bin/env node
import { execSync } from "node:child_process";
import { join } from "node:path";
import { toolPath, withRokitPath } from "./ensure-rokit.mjs";

const root = new URL("..", import.meta.url).pathname;
const out = join(root, "sourcemap.json");
const rojo = toolPath("rojo");

execSync(`${rojo} sourcemap default.project.json -o ${out}`, {
  cwd: root,
  stdio: "inherit",
  env: withRokitPath(),
});

console.log("Wrote", out);

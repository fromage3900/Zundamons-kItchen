#!/usr/bin/env node
import { execSync } from "node:child_process";
import { toolPath, withRokitPath } from "./ensure-rokit.mjs";

const root = new URL("..", import.meta.url).pathname;
const targets = [
  "src/ServerScriptService/Services",
  "src/ServerScriptService/Validation",
  "src/ReplicatedStorage/ConfigurationFiles",
  "src/StarterPlayer/StarterPlayerScripts/Controllers",
];

const stylua = toolPath("stylua");
execSync(`${stylua} --check ${targets.join(" ")}`, {
  cwd: root,
  stdio: "inherit",
  env: withRokitPath(),
});

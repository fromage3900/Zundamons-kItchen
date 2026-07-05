#!/usr/bin/env node
import { execSync } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";

const root = new URL("..", import.meta.url).pathname;
const target = join(root, "src/ServerScriptService/Services");
const seleneBin = "/tmp/selene-bin/selene";

if (!existsSync(target)) {
  console.error("Selene lint target missing:", target);
  process.exit(1);
}

if (!existsSync(seleneBin)) {
  execSync(
    "curl -fsSL https://github.com/Kampfkarren/selene/releases/download/0.31.0/selene-0.31.0-linux.zip -o /tmp/selene.zip && unzip -o /tmp/selene.zip -d /tmp/selene-bin && chmod +x /tmp/selene-bin/selene",
    { stdio: "pipe" }
  );
}

execSync(`${seleneBin} ${target}`, { cwd: root, stdio: "inherit" });

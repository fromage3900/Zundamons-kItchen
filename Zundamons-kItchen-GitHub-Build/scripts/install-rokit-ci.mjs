#!/usr/bin/env node
/**
 * CI helper: install Rokit and project tools from rokit.toml.
 */
import { execSync } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";
import { homedir } from "node:os";

const root = new URL("..", import.meta.url).pathname;
const rokitVersion = "1.2.0";
const rokitZip = `/tmp/rokit-${rokitVersion}.zip`;
const rokitBin = "/tmp/rokit-bin/rokit";

if (!existsSync(rokitBin)) {
  execSync(
    `curl -fsSL https://github.com/rojo-rbx/rokit/releases/download/v${rokitVersion}/rokit-${rokitVersion}-linux.zip -o ${rokitZip} && unzip -o ${rokitZip} -d /tmp/rokit-bin && chmod +x ${rokitBin}`,
    { stdio: "inherit" }
  );
}

execSync(`${rokitBin} trust rojo-rbx/rojo JohnnyMorganz/StyLua Kampfkarren/selene`, {
  cwd: root,
  stdio: "inherit",
});

execSync(`${rokitBin} install`, { cwd: root, stdio: "inherit" });

const homeBin = join(homedir(), ".rokit", "bin");
for (const tool of ["rojo", "stylua", "selene"]) {
  if (!existsSync(join(homeBin, tool))) {
    console.error(`Rokit install did not produce ${tool} at ${homeBin}`);
    process.exit(1);
  }
}

console.log("Rokit tools installed:", homeBin);

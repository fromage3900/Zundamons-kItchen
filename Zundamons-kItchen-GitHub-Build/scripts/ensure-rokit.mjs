#!/usr/bin/env node
/**
 * Resolves Rokit-managed tool binaries for npm scripts and CI.
 * Prefers ~/.rokit/bin (after `rokit install`), falls back to `rokit` on PATH.
 */
import { existsSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const homeBin = join(homedir(), ".rokit", "bin");

export function rokitBinDir() {
  if (existsSync(join(homeBin, "rojo"))) {
    return homeBin;
  }
  return null;
}

export function toolPath(name) {
  const dir = rokitBinDir();
  if (dir) {
    const full = join(dir, name);
    if (existsSync(full)) {
      return full;
    }
  }
  return name;
}

export function withRokitPath(env = process.env) {
  const dir = rokitBinDir();
  if (!dir) {
    return env;
  }
  const pathKey = Object.keys(env).find((k) => k.toLowerCase() === "path") ?? "PATH";
  const sep = process.platform === "win32" ? ";" : ":";
  const existing = env[pathKey] ?? "";
  return {
    ...env,
    [pathKey]: existing ? `${dir}${sep}${existing}` : dir,
  };
}

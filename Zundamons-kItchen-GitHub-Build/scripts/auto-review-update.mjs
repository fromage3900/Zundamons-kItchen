#!/usr/bin/env node

import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';

const ROOT = process.cwd();
const SKIP_GIT = process.env.DRY_RUN === '1' || (!process.env.GITHUB_ACTIONS && !process.env.GITHUB_TOKEN);
const REPORT_PATH = path.join('.github', 'skills', 'auto-review-report.json');

function isBinaryFile(filePath) {
	const binExt = ['.png', '.jpg', '.jpeg', '.gif', '.rbxl', '.rbxlx', '.rbxmx'];
	return binExt.includes(path.extname(filePath).toLowerCase());
}

function walkDir(dir, cb) {
	const entries = fs.readdirSync(dir, { withFileTypes: true });
	for (const e of entries) {
		const full = path.join(dir, e.name);
		if (e.isDirectory()) {
			if (['.git', 'node_modules'].includes(e.name)) continue;
			walkDir(full, cb);
		} else {
			cb(full);
		}
	}
}

function sortKeysDeep(value) {
	if (Array.isArray(value)) return value.map(sortKeysDeep);
	if (value && typeof value === 'object' && !(value instanceof Date)) {
		const sorted = {};
		for (const key of Object.keys(value).sort()) {
			sorted[key] = sortKeysDeep(value[key]);
		}
		return sorted;
	}
	return value;
}

function canonicalJsonString(obj) {
	return JSON.stringify(sortKeysDeep(obj), null, 2) + '\n';
}

function findJsonFiles() {
	const files = [];
	walkDir(ROOT, (file) => {
		if (isBinaryFile(file)) return;
		if (file.endsWith('.json')) files.push(file);
	});
	return files;
}

function runGit(cmd) {
	try {
		return execSync(cmd, { stdio: 'pipe' }).toString().trim();
	} catch (err) {
		console.error('Git command failed:', cmd, err.message);
		throw err;
	}
}

async function main() {
	console.log('Auto procedural review started. DRY_RUN=%s GITHUB_ACTIONS=%s', process.env.DRY_RUN || '0', process.env.GITHUB_ACTIONS || '0');

	const jsonFiles = findJsonFiles();
	const modified = [];

	for (const f of jsonFiles) {
		try {
			const text = fs.readFileSync(f, 'utf8');
			let parsed;
			try {
				parsed = JSON.parse(text);
			} catch (err) {
				// skip invalid JSON files
				continue;
			}

			const canonical = canonicalJsonString(parsed);
			if (canonical !== text) {
				fs.writeFileSync(f, canonical, 'utf8');
				modified.push(path.relative(ROOT, f).replace(/\\/g, '/'));
				console.log('Reformatted JSON:', f);
			}
		} catch (err) {
			console.error('Failed processing', f, err.message);
		}
	}

	const findings = {
		timestamp: new Date().toISOString(),
		modifiedFiles: modified,
		notes: []
	};

	// Simple heuristic scan for procedural geometry markers in scripts
	const proceduralMatches = [];
	walkDir(ROOT, (file) => {
		if (file.endsWith('.luau') || file.endsWith('.lua') || file.endsWith('.mjs') || file.endsWith('.js')) {
			try {
				const content = fs.readFileSync(file, 'utf8');
				if (/procedur(al|e)?|generator|mesh|vertices|triangul/i.test(content)) {
					proceduralMatches.push(path.relative(ROOT, file).replace(/\\/g, '/'));
				}
			} catch (e) { }
		}
	});

	if (proceduralMatches.length) {
		findings.notes.push(`Procedural-related files: ${proceduralMatches.join(', ')}`);
	}

	// save report (do not commit this artifact)
	try {
		fs.mkdirSync(path.dirname(REPORT_PATH), { recursive: true });
		fs.writeFileSync(REPORT_PATH, JSON.stringify(findings, null, 2) + '\n', 'utf8');
	} catch (err) {
		console.error('Failed to write report', err.message);
	}

	if (modified.length === 0) {
		console.log('No changes detected. Exiting.');
		process.exit(0);
	}

	// Automatic expansions for HarvestNodes (only in CI or when AUTO_EXPAND=1)
	const AUTO_EXPAND = process.env.AUTO_EXPAND === '1' || !!process.env.GITHUB_ACTIONS;
	if (AUTO_EXPAND) {
		console.log('AUTO_EXPAND is enabled; applying safe expansions to HarvestNodes.');
		try {
			const harvestRoot = path.join(ROOT, 'Assets', 'Generated', 'HarvestNodes');
			if (fs.existsSync(harvestRoot)) {
				walkDir(harvestRoot, (file) => {
					if (!file.endsWith('.json')) return;
					try {
						const rel = path.relative(ROOT, file).replace(/\\/g, '/');
						const txt = fs.readFileSync(file, 'utf8');
						const obj = JSON.parse(txt);
						if (!obj.metadata) obj.metadata = {};
						// mark as auto-reviewed/expanded safely
						const prev = obj.metadata.autoReviewed || null;
						obj.metadata.autoReviewed = true;
						obj.metadata.reviewedAt = new Date().toISOString();
						const newText = canonicalJsonString(obj);
						if (newText !== txt) {
							fs.writeFileSync(file, newText, 'utf8');
							if (!modified.includes(rel)) modified.push(rel);
							console.log('Auto-expanded:', rel);
						}
					} catch (e) {
						// ignore per-file errors
					}
				});
			}
		} catch (err) {
			console.error('Auto-expand failed:', err.message);
		}
	} else {
		console.log('AUTO_EXPAND disabled (set AUTO_EXPAND=1 or run in CI to enable).');
	}

	console.log('Files changed:', modified);

	if (SKIP_GIT) {
		console.log('SKIP_GIT is true; printing a summary but not committing/pushing changes.');
		console.log(JSON.stringify(findings, null, 2));
		process.exit(0);
	}

	// Git commit and push
	try {
		runGit('git config user.email "actions@github.com"');
		runGit('git config user.name "GitHub Actions"');
		runGit('git checkout -B auto/review-updates');
		runGit('git add ' + modified.map(f => JSON.stringify(f)).join(' '));
		runGit(`git commit -m "Auto procedural review updates (${findings.timestamp})" || true`);
		runGit('git push --set-upstream origin auto/review-updates');
		console.log('Pushed changes to branch auto/review-updates');
	} catch (err) {
		console.error('Git operations failed:', err.message);
		process.exit(1);
	}
}

main().catch((err) => {
	console.error(err);
	process.exit(1);
});

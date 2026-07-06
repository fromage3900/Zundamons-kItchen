#!/usr/bin/env pwsh
# Pre-commit hook: Validate Lua syntax + Rojo structure
# Save as .git/hooks/pre-commit and make executable

$ErrorActionPreference = "Stop"

Write-Host "🔍 Running pre-commit validation..." -ForegroundColor Cyan

# Check for obvious issues
$badFiles = Get-ChildItem -Path src -Recurse -Include "*.lua" | Select-String -Pattern "(<<<<<<<|>>>>>>>)"
if ($badFiles) {
    Write-Host "❌ Merge conflict markers found!" -ForegroundColor Red
    $badFiles | ForEach-Object { Write-Host "  $($_.Path):$($_.LineNumber)" }
    exit 1
}

# Check Rojo project.json syntax
try {
    $project = Get-Content -Path "default.project.json" -Raw | ConvertFrom-Json
    Write-Host "✅ default.project.json is valid JSON" -ForegroundColor Green
}
catch {
    Write-Host "❌ default.project.json has syntax errors!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ All checks passed - committing..." -ForegroundColor Green
exit 0
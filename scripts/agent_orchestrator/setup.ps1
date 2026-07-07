param(
    [switch]$PullModels,
    [switch]$SeedKB,
    [switch]$All
)

$ZUNDA_ROOT = "G:\Zundamons-kItchen"
$ORCH_DIR = "$ZUNDA_ROOT\scripts\agent_orchestrator"

Write-Output "=== Zunda Agent Orchestrator Setup ==="
Write-Output "Root: $ZUNDA_ROOT"

# Step 1: Install Python dependencies
Write-Output "`nStep 1: Installing Python dependencies..."
pip install -r "$ORCH_DIR\requirements.txt" 2>&1 | Out-Null
Write-Output "  Done"

# Step 2: Deploy Ollama models (auto-detect missing)
if ($PullModels -or $All) {
    Write-Output "`nStep 2: Deploying Ollama models..."
    python "$ORCH_DIR\tools\model_deploy.py"
} else {
    Write-Output "`nStep 2: Skipped (use -PullModels or -All)"
}

# Step 3: Seed knowledge base
if ($SeedKB -or $All) {
    Write-Output "`nStep 3: Seeding knowledge base..."
    $seedDir = "$ORCH_DIR\knowledge\seed_knowledge"
    @("$ZUNDA_ROOT\AI\DESIGN_SYSTEM.md", "$ZUNDA_ROOT\AI\ARCHITECTURE.md", "$ZUNDA_ROOT\AI\STYLE_GUIDE.md") | ForEach-Object {
        if (Test-Path $_) {
            Copy-Item $_ "$seedDir\" -Force
            Write-Output "  Seeded: $_"
        }
    }
    Write-Output "  Done"
}

# Step 4: Verify Ollama is running
Write-Output "`nStep 4: Verifying Ollama..."
try {
    $resp = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -TimeoutSec 5
    Write-Output "  Connected ($($resp.models.Count) models available)"
} catch {
    Write-Output "  Not running - start with 'ollama serve'"
}

Write-Output "`n=== Setup Complete ==="
Write-Output ""
Write-Output "Quick start:"
Write-Output "  python scripts\agent_orchestrator\run.py --generate-quests 5"
Write-Output "  python scripts\agent_orchestrator\run.py --daemon"
Write-Output "  python scripts\agent_orchestrator\tools\model_deploy.py"

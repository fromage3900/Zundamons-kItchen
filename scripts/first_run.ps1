param([switch]$Full)

Write-Output "╔══════════════════════════════════════════════════╗"
Write-Output "║    Zundamon's Kitchen — First-Run Setup         ║"
Write-Output "╚══════════════════════════════════════════════════╝"
Write-Output ""

$root = "G:\Zundamons-kItchen"
if (!(Test-Path "$root\default.project.json")) {
    Write-Output "ERROR: Run this from G:\Zundamons-kItchen"
    exit 1
}
Set-Location $root

# Step 1: Install Node deps
Write-Output "[1/5] Installing Node dependencies..."
npm install 2>&1 | Out-Null
Write-Output "  ok"

# Step 2: Install Python deps
Write-Output "[2/5] Installing Python dependencies..."
pip install -r scripts/agent_orchestrator/requirements.txt 2>&1 | Out-Null
Write-Output "  ok"

# Step 3: Verify Ollama
Write-Output "[3/5] Checking Ollama..."
try {
    $models = Invoke-RestMethod "http://localhost:11434/api/tags" -TimeoutSec 5
    Write-Output "  Ollama running ($($models.models.Count) models)"
    if ($Full) {
        Write-Output "  Deploying AI models..."
        python scripts/agent_orchestrator/tools/model_deploy.py 2>&1 | Out-Null
        Write-Output "  Models deployed"
    }
} catch {
    Write-Output "  Ollama not running. Start: ollama serve"
    Write-Output "  Then re-run with: -Full"
}

# Step 4: Validate structure
Write-Output "[4/5] Validating project structure..."
npm run validate 2>&1 | Out-Null
Write-Output "  ok"

# Step 5: Quick build test
Write-Output "[5/5] Build test..."
npm run rojo:build 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Output "  Build: ok"
} else {
    Write-Output "  Build: FAILED"
}

Write-Output ""
Write-Output "╔══════════════════════════════════════════════════╗"
Write-Output "║    Setup Complete                                ║"
Write-Output "║                                                  ║"
Write-Output "║    Next: npm run rojo:serve                      ║"
Write-Output "║    Then: Open Zundamons-kItchen.rbxlx in Studio  ║"
Write-Output "╚══════════════════════════════════════════════════╝"

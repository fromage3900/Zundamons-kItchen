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

# Step 2: Pull Ollama models
if ($PullModels -or $All) {
    Write-Output "`nStep 2: Pulling Ollama models..."
    $models = @("llama3.1:8b", "qwen2.5:7b", "codellama:7b", "deepseek-coder:6.7b", "nomic-embed-text")
    foreach ($m in $models) {
        Write-Output "  Pulling $m..."
        ollama pull $m 2>&1 | Out-Null
    }
    Write-Output "  All models pulled"
}

# Step 3: Seed knowledge base
if ($SeedKB -or $All) {
    Write-Output "`nStep 3: Seeding knowledge base..."
    $seedDir = "$ORCH_DIR\knowledge\seed_knowledge"
    
    # Copy key project docs as seed knowledge
    @(
        "$ZUNDA_ROOT\AI\DESIGN_SYSTEM.md",
        "$ZUNDA_ROOT\AI\ARCHITECTURE.md",
        "$ZUNDA_ROOT\AI\STYLE_GUIDE.md"
    ) | ForEach-Object {
        if (Test-Path $_) {
            Copy-Item $_ "$seedDir\" -Force
            Write-Output "  Seeded: $_"
        }
    }
    Write-Output "  Knowledge base seeded"
}

# Step 4: Verify Ollama is running
Write-Output "`nStep 4: Verifying Ollama..."
try {
    $resp = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -TimeoutSec 5
    Write-Output "  Ollama: Connected ($($resp.models.Count) models available)"
} catch {
    Write-Output "  Ollama: Not running — start with 'ollama serve'"
}

Write-Output "`n=== Setup Complete ==="
Write-Output ""
Write-Output "Run a task:   python scripts\agent_orchestrator\run.py 'Implement BendModifier'"
Write-Output "Daemon mode:  python scripts\agent_orchestrator\run.py --daemon"

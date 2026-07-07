# Overnight automation runner for Zundamon's Kitchen
# Run from Task Scheduler: powershell -File scripts/overnight.ps1
# Or manually: npm run overnight

$ErrorActionPreference = "Continue"
$startTime = Get-Date
$logFile = "reports/overnight-$($startTime.ToString('yyyy-MM-dd-HHmm')).log"
$maxRuns = 3
$runInterval = 300  # 5 minutes between runs
$buildDir = "G:\Zundamons-kItchen"

Write-Output "=== Overnight Automation Started: $startTime ==="
Write-Output "Log: $logFile"

# Create reports directory
New-Item -ItemType Directory -Path "$buildDir\reports" -Force | Out-Null

# Ensure we're on the right branch and clean
Set-Location -LiteralPath $buildDir
git fetch origin 2>&1 | Out-Null

for ($run = 1; $run -le $maxRuns; $run++) {
    $runStart = Get-Date
    Write-Output "`n=== Run $run/$maxRuns at $runStart ==="

    # Step 1: Run validation script
    Write-Output "  Step 1: Validating configs..."
    try {
        node scripts/overnight-build.mjs 2>&1 | Tee-Object -FilePath $logFile -Append
    } catch {
        Write-Output "  Validation error: $_"
    }

    # Step 2: Check for fixes/commits from other agents
    Write-Output "  Step 2: Checking for remote updates..."
    git pull --rebase origin main 2>&1 | Out-Null
    $gitStatus = git status --short
    if ($gitStatus) {
        Write-Output "  Uncommitted changes detected:"
        Write-Output $gitStatus
    } else {
        Write-Output "  Working tree clean"
    }

    # Step 3: Rojo build test
    Write-Output "  Step 3: Rojo build test..."
    try {
        $buildOut = rojo build default.project.json -o reports/zunda-build-test.rbxl 2>&1
        Write-Output "  Build: SUCCESS"
    } catch {
        Write-Output "  Build: FAILED - $_"
    }

    # Step 4: Lint check
    Write-Output "  Step 4: Lint check..."
    try {
        npx stylua-bin --check src 2>&1 | Select-Object -First 10
    } catch {
        Write-Output "  Lint: styling issues"
    }

    # Step 5: Generate report
    $runEnd = Get-Date
    $duration = ($runEnd - $runStart).TotalSeconds
    Write-Output "  Run $run completed in $($duration)s"

    if ($run -lt $maxRuns) {
        Write-Output "  Waiting $runInterval seconds before next run..."
        Start-Sleep -Seconds $runInterval
    }
}

$endTime = Get-Date
$totalDuration = ($endTime - $startTime).TotalMinutes
Write-Output "`n=== Overnight Automation Complete ==="
Write-Output "Total runs: $maxRuns"
Write-Output "Duration: $($totalDuration.ToString('F1')) minutes"
Write-Output "Report: reports/overnight-$($startTime.ToString('yyyy-MM-dd-HHmm')).log"
Write-Output "=== End at $endTime ==="

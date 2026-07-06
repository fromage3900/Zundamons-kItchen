# PowerShell script to monitor git changes from DeepSeek
# Usage: .\monitor-deepseek.ps1

$LAST_COMMIT_FILE = "$env:TEMP\zunda_last_commit.txt"
$ITERATION = 0

function Get-LastCommitHash {
    git rev-parse HEAD
}

while ($true) {
    $ITERATION++
    $CURRENT_COMMIT = Get-LastCommitHash
    
    if (Test-Path $LAST_COMMIT_FILE) {
        $LAST_COMMIT = Get-Content $LAST_COMMIT_FILE
        if ($CURRENT_COMMIT -ne $LAST_COMMIT) {
            Write-Host "$(Get-Date): [CHANGE DETECTED] New commit detected!" -ForegroundColor Yellow
            git log --oneline -1
            Write-Host "Changed files:" -ForegroundColor Cyan
            git diff --name-only $LAST_COMMIT $CURRENT_COMMIT | ForEach-Object { Write-Host "  $_" }
            $CURRENT_COMMIT | Set-Content $LAST_COMMIT_FILE
        }
    } else {
        $CURRENT_COMMIT | Set-Content $LAST_COMMIT_FILE
    }
    
    Write-Host "$(Get-Date): Monitoring iteration $ITERATION - no changes" -ForegroundColor Gray
    Start-Sleep -Seconds 30
}
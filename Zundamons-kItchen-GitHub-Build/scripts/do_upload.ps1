param([string]$UserId = "3930496852")

$apiKey = [Environment]::GetEnvironmentVariable("ROBLOX_OPEN_CLOUD_API_KEY", "User")
if (-not $apiKey) { Write-Error "No API key"; exit 1 }

$rootDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$generatedDir = Join-Path $rootDir "Assets\Generated"

$assets = @{}
Get-ChildItem $generatedDir -Recurse -Filter "*.fbx" | ForEach-Object {
    $metaPath = Join-Path $_.Directory "$($_.BaseName).json"
    $desc = ""
    if (Test-Path $metaPath) { $desc = ((Get-Content $metaPath -Raw | ConvertFrom-Json).description) }
    $assets[$_.BaseName] = @{ fbx = $_.FullName; desc = $desc }
}

Write-Host "Uploading $($assets.Count) assets..."
$results = @{}

foreach ($name in ($assets.Keys | Sort-Object)) {
    $info = $assets[$name]
    Write-Host "`n--- $name ---"
    
    $requestJson = "{`"assetType`":`"Model`",`"displayName`":`"$name`",`"description`":`"$($info.desc)`",`"creationContext`":{`"creator`":{`"userId`":`"$UserId`"}}}"
    $boundary = "----M$(Get-Random)"
    $lf = "`r`n"
    $bodyStream = [System.IO.MemoryStream]::new()

    $h1 = "--$boundary$lf" + "Content-Disposition: form-data; name=`"request`"$lf" + "Content-Type: application/json$lf$lf" + $requestJson + "$lf"
    $bodyStream.Write([Text.Encoding]::UTF8.GetBytes($h1), 0, $h1.Length)
    $h2 = "--$boundary$lf" + "Content-Disposition: form-data; name=`"fileContent`"; filename=`"$name.fbx`"$lf" + "Content-Type: model/fbx$lf$lf"
    $bodyStream.Write([Text.Encoding]::UTF8.GetBytes($h2), 0, $h2.Length)
    $fbxBytes = [IO.File]::ReadAllBytes($info.fbx)
    $bodyStream.Write($fbxBytes, 0, $fbxBytes.Length)
    $ft = "$lf--$boundary--$lf"
    $bodyStream.Write([Text.Encoding]::UTF8.GetBytes($ft), 0, $ft.Length)
    $bodyStream.Position = 0

    $wc = New-Object Net.WebClient
    $wc.Headers.Add("x-api-key", $apiKey)
    $wc.Headers.Add("Content-Type", "multipart/form-data; boundary=$boundary")
    
    try {
        $resp = [Text.Encoding]::UTF8.GetString($wc.UploadData("https://apis.roblox.com/assets/v1/assets", "POST", $bodyStream.ToArray())) | ConvertFrom-Json
        $opId = $resp.operationId
        do { Start-Sleep -Seconds 2; $poll = Invoke-RestMethod -Uri "https://apis.roblox.com/assets/v1/operations/$opId" -Headers @{"x-api-key"=$apiKey} } while (-not $poll.done)
        if ($poll.error) { Write-Warning "FAIL: $($poll.error.message)" }
        else { 
            $aid = $poll.response.assetId
            Write-Host " -> $aid"
            $results[$name] = $aid
        }
    } catch { Write-Warning "ERR: $_" }
    $wc.Dispose(); $bodyStream.Dispose()
}

$results | ConvertTo-Json | Set-Content (Join-Path $generatedDir "asset_ids.json") -Encoding UTF8
Write-Host "`n=== DONE: $($results.Count) uploaded ==="
return $results

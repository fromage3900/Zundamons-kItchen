param(
    [string]$Category = "all",
    [string]$RobloxUserId = "3930496852"
)

$ErrorActionPreference = "Stop"
$apiKey = [Environment]::GetEnvironmentVariable("ROBLOX_OPEN_CLOUD_API_KEY", "User")
if (-not $apiKey) {
    Write-Error "ROBLOX_OPEN_CLOUD_API_KEY not set"
    exit 1
}

$rootDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$generatedDir = Join-Path $rootDir "Assets\Generated"
$resultPath = Join-Path $generatedDir "asset_ids.json"

# Discover all assets
$assets = @()
Get-ChildItem $generatedDir -Recurse -Filter "*.obj" | ForEach-Object {
    $dir = $_.Directory
    $metaPath = Join-Path $dir "$($_.BaseName).json"
    if (Test-Path $metaPath) {
        $meta = Get-Content $metaPath -Raw | ConvertFrom-Json
        $assets += @{
            objPath = $_.FullName
            id = $_.BaseName
            description = $meta.description
            exportPath = $meta.export_path
        }
    }
}

Write-Host "Found $($assets.Count) assets to upload"
$assetIds = @{}

foreach ($asset in $assets) {
    Write-Host "`n--- $($asset.id) ---"

    $fbxPath = Join-Path $asset.objPath.Directory "$($asset.id).fbx"

    # Step 1: Convert OBJ to FBX via Blender
    & "C:\Program Files\Blender Foundation\Blender 4.3\blender.exe" --background --python-expr "
import bpy, os
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()
bpy.ops.wm.obj_import(filepath='$($asset.objPath -replace "'","''")')
bpy.ops.export_scene.fbx(filepath='$($fbxPath -replace "'","''")', use_selection=True, object_types={'MESH'}, axis_forward='-Z', axis_up='Y')
print('FBX_DONE')
" 2>&1 | Out-Null
    
    if (-not (Test-Path $fbxPath)) {
        Write-Warning "FBX export failed for $($asset.id), skipping"
        continue
    }

    # Step 2: Upload to Roblox
    $requestJson = "{`"assetType`":`"Model`",`"displayName`":`"$($asset.id)`",`"description`":`"$($asset.description)`",`"creationContext`":{`"creator`":{`"userId`":`"$RobloxUserId`"}}}"
    $boundary = "----MultipartBoundary$(Get-Random)"
    $lf = "`r`n"

    $bodyStream = [System.IO.MemoryStream]::new()
    function Write-Part($name, $value, $contentType) {
        $header = "--$boundary$lf" + "Content-Disposition: form-data; name=`"$name`"$lf" + "Content-Type: $contentType$lf$lf" + $value + "$lf"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($header)
        $bodyStream.Write($bytes, 0, $bytes.Length)
    }

    Write-Part "request" $requestJson "application/json"
    $header = "--$boundary$lf" + "Content-Disposition: form-data; name=`"fileContent`"; filename=`"$($asset.id).fbx`"$lf" + "Content-Type: model/fbx$lf$lf"
    $bodyStream.Write([System.Text.Encoding]::UTF8.GetBytes($header), 0, $header.Length)
    $bodyStream.Write([System.IO.File]::ReadAllBytes($fbxPath), 0, (Get-Item $fbxPath).Length)
    $bodyStream.Write([System.Text.Encoding]::UTF8.GetBytes("$lf--$boundary--$lf"), 0, ("$lf--$boundary--$lf").Length)

    $bodyStream.Position = 0
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("x-api-key", $apiKey)
    $webClient.Headers.Add("Content-Type", "multipart/form-data; boundary=$boundary")

    try {
        $responseBytes = $webClient.UploadData("https://apis.roblox.com/assets/v1/assets", "POST", $bodyStream.ToArray())
        $opResult = [System.Text.Encoding]::UTF8.GetString($responseBytes) | ConvertFrom-Json
        $opId = $opResult.operationId

        # Poll for completion
        do {
            Start-Sleep -Seconds 2
            $pollResult = Invoke-RestMethod -Uri "https://apis.roblox.com/assets/v1/operations/$opId" -Headers @{"x-api-key"=$apiKey} -Method Get
        } while (-not $pollResult.done)

        if ($pollResult.error) {
            Write-Warning "$($asset.id): Upload failed - $($pollResult.error.message)"
        } else {
            $robloxId = $pollResult.response.assetId
            Write-Host "$($asset.id) -> $robloxId (Active)"
            $assetIds[$asset.id] = @{
                assetId = $robloxId
                description = $asset.description
                path = $asset.exportPath
            }
        }
    } catch {
        Write-Warning "$($asset.id): Upload error - $_"
    }

    $webClient.Dispose()
    $bodyStream.Dispose()

    # Cleanup FBX
    Remove-Item $fbxPath -Force -ErrorAction SilentlyContinue
}

# Save results
$assetIds | ConvertTo-Json -Depth 5 | Set-Content $resultPath -Encoding UTF8
Write-Host "`n=== Upload complete ==="
Write-Host "Results saved to: $resultPath"
Write-Host "$($assetIds.Count) / $($assets.Count) assets uploaded successfully"
return $assetIds

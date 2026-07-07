# ✨ Mesh ID Fixer — One-Command Pipeline ✨
# Step 1: Run the Studio script below
# Step 2: Come back here and press Enter
# Step 3: Configs are updated automatically!

Write-Output "╔══════════════════════════════════════════════╗"
Write-Output "║          ✨ Mesh ID Fixer ✨               ║"
Write-Output "╚══════════════════════════════════════════════╝"
Write-Output ""

$ZUNDA_ROOT = "G:\Zundamons-kItchen"

# Check if import results already exist
$resultsPath = "$ZUNDA_ROOT\reports\mesh_pipeline\import_results.json"
if (Test-Path $resultsPath) {
    Write-Output "✅ Found import results!"
    Write-Output "   Running config updater..."
    python "$ZUNDA_ROOT\scripts\agent_orchestrator\tools\batch_import.py" --apply
    Write-Output ""
    Write-Output "✨ Done! Run 'npm run overnight' to verify."
    exit
}

Write-Output "📋 Step 1: Copy this script and run it in Studio command bar:"
Write-Output ""
Write-Output 'local results = {}'
Write-Output 'local seen = {}'
Write-Output 'for _, c in ipairs(workspace:GetChildren()) do'
Write-Output '    local function s(i)'
Write-Output '        if i:IsA("MeshPart") and i.MeshId ~= "" and i.MeshId ~= "rbxassetid://0" then'
Write-Output '            local n = i.Name:gsub("Meshes/","")'
Write-Output '            if not seen[n] then seen[n] = true; table.insert(results, {name=n, meshId=i.MeshId}) end'
Write-Output '        end'
Write-Output '        for _, c in ipairs(i:GetChildren()) do s(c) end'
Write-Output '    end'
Write-Output '    s(c)'
Write-Output 'end'
Write-Output 'local json = game:GetService("HttpService"):JSONEncode(results)'
Write-Output 'print(json)'
Write-Output 'print("--END--")'
Write-Output ''
Write-Output "📋 Step 2: Copy the JSON output from Studio, save it to:"
Write-Output "   reports\mesh_pipeline\import_results.json"
Write-Output ""
Write-Output "📋 Step 3: Run this script again (without --save flag)"
Write-Output "   Or just run: npm run import:apply"
Write-Output ""

# Check if --save flag is used with a file path
if ($args.Count -gt 0 -and $args[0] -eq "--save") {
    $jsonContent = $input | Out-String
    if ($jsonContent -and $jsonContent.Length -gt 10) {
        $resultsPath | Out-File -FilePath $resultsPath -InputObject $jsonContent -Encoding utf8
        Write-Output "✅ Saved to $resultsPath"
        Write-Output "   Running config updater..."
        python "$ZUNDA_ROOT\scripts\agent_orchestrator\tools\batch_import.py" --apply
    } else {
        Write-Output "❌ No JSON content received. Paste the Studio output and try again."
    }
}

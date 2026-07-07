# =================================================================
# マウスカーソル自動一括設定スクリプト (Windows用)
# - カーソルファイルを C:\Windows\Cursors\<スキーム名> にコピー
# - コピー先のファイルを Windows のカーソル設定へ適用
# =================================================================

$ErrorActionPreference = "Stop"

# 文字化け対策: 出力エンコーディングをUTF-8に設定
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# このスクリプトが置かれているフォルダを基準にする
$ScriptDir = Split-Path -Parent $PSCommandPath
if ([string]::IsNullOrWhiteSpace($ScriptDir)) {
    $ScriptDir = Get-Location
}

function Test-IsAdministrator {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# C:\Windows\Cursors へのコピーには管理者権限が必要なため、自動で昇格する
if (-not (Test-IsAdministrator)) {
    Write-Host "管理者権限で再実行します。UACの確認が表示されたら許可してください。" -ForegroundColor Yellow
    $argList = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", "`"$PSCommandPath`""
    ) -join " "

    Start-Process -FilePath "powershell.exe" -ArgumentList $argList -WorkingDirectory $ScriptDir -Verb RunAs -Wait
    exit
}

# --- 設定エリア: 配布するファイル名に合わせて書き換えてください ---
$CursorFiles = [ordered]@{
    "Arrow"       = "normal.ani"      # 通常の選択
    "Help"        = "help.ani"        # ヘルプの選択
    "AppStarting" = "working.ani"     # バックグラウンドで作業中
    "Wait"        = "busy.ani"        # 待ち状態
    "Crosshair"   = "cross.ani"       # 精密選択
    "IBeam"       = "text.ani"        # テキスト選択
    "NWPen"       = "handwriting.ani" # 手書き
    "No"          = "unavailable.ani" # 利用不可
    "SizeNS"      = "resize_ns.ani"   # 垂直に再サイズ
    "SizeWE"      = "resize_we.ani"   # 水平に再サイズ
    "SizeNWSE"    = "resize_nwse.ani" # 斜めに再サイズ 1
    "SizeNESW"    = "resize_nesw.ani" # 斜めに再サイズ 2
    "SizeAll"     = "move.ani"        # 移動
    "UpArrow"     = "alternate.ani"   # 代替選択
    "Hand"        = "link.ani"        # リンクの選択
    "Pin"         = "location.ani"    # 場所の選択
    "Person"      = "person.ani"      # 人の選択
}

# スキーム名（コントロールパネルに表示される名前）
$SchemeName = "Zundamon_Cursor"

# コピー先: Windows既定のカーソルフォルダ内に、スキーム専用フォルダを作る
$InstallDir = Join-Path $env:WINDIR ("Cursors\" + $SchemeName)

# レジストリパス
$RegistryPath = "HKCU:\Control Panel\Cursors"
$SchemesPath  = "HKCU:\Control Panel\Cursors\Schemes"

Write-Host "カーソルの設定を開始します..." -ForegroundColor Cyan
Write-Host "コピー元: $ScriptDir"
Write-Host "コピー先: $InstallDir"

# 1. コピー先フォルダ作成
New-Item -Path $InstallDir -ItemType Directory -Force | Out-Null

# 2. カーソルファイルを C:\Windows\Cursors\<スキーム名> にコピーし、コピー先のパスを記録
$InstalledCursorPaths = @{}

foreach ($Key in $CursorFiles.Keys) {
    $FileName = $CursorFiles[$Key]
    $SourcePath = Join-Path $ScriptDir $FileName
    $DestPath   = Join-Path $InstallDir $FileName

    if (Test-Path $SourcePath) {
        Copy-Item -Path $SourcePath -Destination $DestPath -Force
        $InstalledCursorPaths[$Key] = $DestPath
        Write-Host "[OK] コピーしました: $FileName"
    } else {
        $InstalledCursorPaths[$Key] = ""
        Write-Warning "[Skip] ファイルが見つかりません: $FileName ($Key)"
    }
}

# 3. 各カーソルのレジストリ更新：コピー先のパスを登録
foreach ($Key in $CursorFiles.Keys) {
    $DestPath = $InstalledCursorPaths[$Key]

    if (-not [string]::IsNullOrWhiteSpace($DestPath) -and (Test-Path $DestPath)) {
        Set-ItemProperty -Path $RegistryPath -Name $Key -Value $DestPath
        Write-Host "[OK] $Key を設定しました: $DestPath"
    }
}

# 4. スキーム（デザイン一覧）への登録
# Windowsのカーソルスキームは、この順序のカンマ区切り文字列で保存される
$SchemeKeysOrder = @(
    "Arrow", "Help", "AppStarting", "Wait", "Crosshair", "IBeam", "NWPen", "No",
    "SizeNS", "SizeWE", "SizeNWSE", "SizeNESW", "SizeAll", "UpArrow", "Hand", "Pin", "Person"
)

$SchemePaths = $SchemeKeysOrder | ForEach-Object {
    $p = $InstalledCursorPaths[$_]
    if ([string]::IsNullOrWhiteSpace($p)) { "" } else { $p }
}
$SchemeValue = $SchemePaths -join ","

if (-not (Test-Path $SchemesPath)) {
    New-Item -Path $SchemesPath -Force | Out-Null
}

Set-ItemProperty -Path $SchemesPath -Name $SchemeName -Value $SchemeValue
Set-ItemProperty -Path $RegistryPath -Name "(Default)" -Value $SchemeName

# 任意: ユーザー定義スキームとして扱わせる
New-ItemProperty -Path $RegistryPath -Name "Scheme Source" -Value 1 -PropertyType DWord -Force | Out-Null

# 5. システムに設定の変更を通知
$Signature = @'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo", SetLastError = true)]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);
'@

$Win32API = Add-Type -MemberDefinition $Signature -Name "Win32SystemParametersInfo" -Namespace "Win32Functions" -PassThru
$SPI_SETCURSORS = 0x0057
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE    = 0x02

$result = [Win32Functions.Win32SystemParametersInfo]::SystemParametersInfo(
    $SPI_SETCURSORS,
    0,
    [IntPtr]::Zero,
    ($SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
)

if (-not $result) {
    Write-Warning "設定変更の通知に失敗した可能性があります。必要なら一度サインアウトするか、マウスのプロパティからスキームを選び直してください。"
}

Write-Host "`nすべての設定が完了しました。" -ForegroundColor Green
Write-Host "デザイン(S) の一覧に『$SchemeName』が追加されています。"
Write-Host "コピー先: $InstallDir"

Read-Host "Enterキーを押すと終了します"

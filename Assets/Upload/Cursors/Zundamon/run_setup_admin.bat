@echo off
setlocal
cd /d %~dp0

rem 文字コードをUTF-8 (65001) に変更
chcp 65001 > nul

echo ======================================================
echo   マウスカーソル自動設定を開始します...
echo   C:\Windows\Cursors へコピーするため、UACが表示される場合があります。
echo ======================================================
echo.

rem PowerShellスクリプトを実行
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0set_cursors_copy_to_windows_cursors.ps1"

echo.
echo 処理が終了しました。
pause

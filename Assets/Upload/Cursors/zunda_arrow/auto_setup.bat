:: 
:: cursor_setup
:: 
:: Copyright (c) 2022 wappon_28_dev
:: 
:: This software is released under the MIT License.
:: see https://opensource.org/licenses/MIT
:: 

echo off
chcp 65001
prompt ^>
cd /d %~dp0

set cursor_ver=v1
set cursor_name=zunda_arrow
set setup_ver=v2

cls
echo.
echo --------------------
echo はじめに
echo --------------------
echo.

type "%cd%\readme.txt"
if %errorlevel% neq 0 (
    echo ユーザー名が不正またはファイルを参照できません
    echo 詳しくは上記のエラーを参照してください
    echo.
    echo auto_setup は終了します
    goto exit
)

echo.

:ask1
echo --------------------
echo 続けるには `y` を入力して Enter を押してください
echo 終了するには `n` を入力してEnter を押してください
set /p check=" > "

if {%check%}=={y} (
    goto work1
) else if {%check%}=={n} (
    goto exit
) else (
    goto ask1
)


:work1
cls
echo.
echo --------------------
echo 操作の選択
echo --------------------
echo.

:ask2
echo インストール       :  `y` を入力して Enter を押してください
echo アンインストール    :  `n` を入力して Enter を押してください
echo キャンセル         :  `c` を入力して Enter を押してください
set /p check= " > "
if {%check%}=={y} (
    goto install
) else if {%check%}=={n} (
    goto uninstall
) else if {%check%}=={c} (
    goto exit
) else (
    goto ask2
)

:install
cls
echo.
echo --------------------
echo インストール
echo --------------------
echo.

echo インストールをはじめますか？
echo.

:ask3
echo --------------------
echo 続けるには `y` を入力して Enter を押してください
echo 終了するには `n` を入力してEnter を押してください
set /p check=" > "

if {%check%}=={y} (
    goto work3
) else if {%check%}=={n} (
    goto exit
) else (
    goto ask3
)

:work3
cls
echo.
echo --------------------
echo カーソルのコピー
echo --------------------
echo.

echo カーソルをコピーしています...
timeout 1  >nul
xcopy "%cd%\assets\*" "%userprofile%\documents\%cursor_name%_%cursor_ver%\" /S /Y
if %errorlevel% equ 0 (
    echo カーソルのコピーに成功しました
    timeout 2 >nul
) else (
    echo カーソルのコピーに失敗しました
    echo 詳しくは上記のエラーを参照してください
    echo.
    echo auto_setup は終了します
    goto exit
)

cls
echo.
echo --------------------
echo レジストリへの登録
echo --------------------
echo.

echo コピーしたカーソルをレジストリに登録しています...
timeout 2 >nul

cd "%userprofile%\documents\%cursor_name%_%cursor_ver%\"

set p=HKCU\Control Panel\Cursors

echo.
echo __: 
reg add "%p%" /ve /t "REG_SZ" /d "%cursor_name%" /f
set /a e+=%errorlevel%

echo.
echo AppStarting:
reg add "%p%" /v "AppStarting" /t "REG_EXPAND_SZ" /d "%cd%\03_AppStarting.ani" /f
set /a e+=%errorlevel%

echo.
echo Arrow:
reg add "%p%" /v "Arrow" /t "REG_EXPAND_SZ" /d "%cd%\01_Arrow.cur" /f
set /a e+=%errorlevel%

echo.
echo Crosshair:
reg add "%p%" /v "Crosshair" /t "REG_EXPAND_SZ" /d "%cd%\05_Crosshair.cur" /f
set /a e+=%errorlevel%

echo.
echo Hand:
reg add "%p%" /v "Hand" /t "REG_EXPAND_SZ" /d "%cd%\15_Hand.cur" /f
set /a e+=%errorlevel%

echo.
echo Help:
reg add "%p%" /v "Help" /t "REG_EXPAND_SZ" /d "%cd%\02_Help.cur" /f
set /a e+=%errorlevel%

echo.
echo IBeam:
reg add "%p%" /v "IBeam" /t "REG_EXPAND_SZ" /d "%cd%\06_IBeam.cur" /f
set /a e+=%errorlevel%

echo.
echo No:
reg add "%p%" /v "No" /t "REG_EXPAND_SZ" /d "%cd%\08_No.cur" /f
set /a e+=%errorlevel%

echo.
echo NWPen:
reg add "%p%" /v "NWPen" /t "REG_EXPAND_SZ" /d "%cd%\07_NWPen.cur" /f
set /a e+=%errorlevel%

echo.
echo Person:
reg add "%p%" /v "Person" /t "REG_EXPAND_SZ" /d "%cd%\17_Person.ani" /f
set /a e+=%errorlevel%

echo.
echo Pin:
reg add "%p%" /v "Pin" /t "REG_EXPAND_SZ" /d "%cd%\16_Pin.cur" /f
set /a e+=%errorlevel%

echo.
echo SizeAll:
reg add "%p%" /v "SizeAll" /t "REG_EXPAND_SZ" /d "%cd%\13_SizeAll.ani" /f
set /a e+=%errorlevel%

echo.
echo SizeNESW:
reg add "%p%" /v "SizeNESW" /t "REG_EXPAND_SZ" /d "%cd%\12_SizeNESW.ani" /f
set /a e+=%errorlevel%

echo.
echo SizeNS:
reg add "%p%" /v "SizeNS" /t "REG_EXPAND_SZ" /d "%cd%\09_SizeNS.ani" /f
set /a e+=%errorlevel%

echo.
echo SizeNWSE:
reg add "%p%" /v "SizeNWSE" /t "REG_EXPAND_SZ" /d "%cd%\11_SizeNWSE.ani" /f
set /a e+=%errorlevel%

echo.
echo SizeWE:
reg add "%p%" /v "SizeWE" /t "REG_EXPAND_SZ" /d "%cd%\10_SizeWE.ani" /f
set /a e+=%errorlevel%

echo.
echo UpArrow:
reg add "%p%" /v "UpArrow" /t "REG_EXPAND_SZ" /d "%cd%\14_UpArrow.cur" /f
set /a e+=%errorlevel%

echo.
echo Wait:
reg add "%p%" /v "Wait" /t "REG_EXPAND_SZ" /d "%cd%\04_Wait.ani" /f
set /a e+=%errorlevel%

echo.
echo AppStarting:
reg add "%p%" /v "AppStarting" /t "REG_EXPAND_SZ" /d "%cd%\03_AppStarting.ani" /f
set /a e+=%errorlevel%

echo.
echo __: 
reg add "%p%\Schemes" /v "%cursor_name%" /t "REG_EXPAND_SZ" /d "%cd%\01_Arrow.cur,%cd%\02_Help.cur,%cd%\03_AppStarting.ani,%cd%\04_Wait.ani,%cd%\05_Crosshair.cur,%cd%\06_IBeam.cur,%cd%\07_NWPen.cur,%cd%\08_No.cur,%cd%\09_SizeNS.ani,%cd%\10_SizeWE.ani,%cd%\11_SizeNWSE.ani,%cd%\12_SizeNESW.ani,%cd%\13_SizeAll.ani,%cd%\14_UpArrow.cur,%cd%\15_Hand.cur,%cd%\16_Pin.cur,%cd%\17_Person.ani" /f
set /a e+=%errorlevel%

echo.
echo override:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /t "REG_DWORD" /d "0" /f
set /a e+=%errorlevel%

echo.
if %e% equ 0 (
    echo レジストリへの書き込みに成功しました
    echo.
    echo.
    timeout 2 >nul
) else (
    echo レジストリへの書き込みにしました
    echo 詳しくは上記のエラーを参照してください
    echo.
    echo auto_setup は終了します
    goto exit
)

:logoff
cls
echo.
echo --------------------
echo ログオフ
echo --------------------
echo.

echo カーソルの変更には, ログオフが必要です

echo.
:ask4
echo --------------------
echo ログオフする場合は `y` を入力して Enter を押してください
echo 後でログオフする場合は `n` を入力してEnter を押してください
set /p check=" > "

if {%check%}=={y} (
    echo ログオフしてます...
    echo.
    echo cursor_setup_v2
    echo programmed by wappon_28_dev
    timeout 2 >nul
    shutdown /l /f
    exit
) else if {%check%}=={n} (
    goto exit
) else (
    goto ask4
)


:uninstall
cls
echo.
echo --------------------
echo アンインストールの確認
echo --------------------
echo.

echo 本当にアンインストールしますか？
echo.

:ask5
echo --------------------
echo 続けるには `y` を入力して Enter を押してください
echo 終了するには `n` を入力してEnter を押してください
set /p check=" > "

if {%check%}=={y} (
    goto work5
    exit
) else if {%check%}=={n} (
    goto exit
) else (
    goto ask5
)

:work5
cls
echo.
echo --------------------
echo カーソルの削除
echo --------------------
echo.

echo カーソルを削除しています...
echo.
timeout 1 >nul
cd "%userprofile%\documents\"
rd /s /q %cursor_name%_%cursor_ver%
if %errorlevel% equ 0 (
    echo カーソルの削除に成功しました
    timeout 2 >nul
) else (
    echo カーソルの削除に失敗しました
    echo 詳しくは上記のエラーを参照してください
    echo.
    echo auto_setup は終了します
    goto exit
)

cls
echo.
echo --------------------
echo カーソルのレジストリの初期化
echo --------------------
echo.

echo 初期カーソルをレジストリに再登録しています...
timeout 2 >nul

set p=HKCU\Control Panel\Cursors
echo.

echo __: 
reg add "%p%" /ve /t "REG_SZ" /d "Windows 標準" /f
set /a e+=%errorlevel%

echo.
echo AppStarting: 
reg add "%p%" /v "AppStarting" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_working.ani" /f
set /a e+=%errorlevel%

echo.
echo Arrow: 
reg add "%p%" /v "Arrow" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_arrow.cur" /f
set /a e+=%errorlevel%

echo.
echo Crosshair: 
reg add "%p%" /v "Crosshair" /t "REG_EXPAND_SZ" /d "" /f
set /a e+=%errorlevel%

echo.
echo Hand: 
reg add "%p%" /v "Hand" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_link.cur" /f
set /a e+=%errorlevel%

echo.
echo Help: 
reg add "%p%" /v "Help" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_helpsel.cur" /f
set /a e+=%errorlevel%

echo.
echo IBeam: 
reg add "%p%" /v "IBeam" /t "REG_EXPAND_SZ" /d "" /f
set /a e+=%errorlevel%

echo.
echo No: 
reg add "%p%" /v "No" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_unavail.cur" /f
set /a e+=%errorlevel%

echo.
echo NWPen: 
reg add "%p%" /v "NWPen" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_pen.cur" /f
set /a e+=%errorlevel%

echo.
echo Person:
reg add "%p%" /v "Person" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_person.cur" /f
set /a e+=%errorlevel%

echo.
echo Pin:
reg add "%p%" /v "Pin" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_pin.cur" /f
set /a e+=%errorlevel%

echo.
echo SizeAll:
reg add "%p%" /v "SizeAll" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_move.cur" /f
set /a e+=%errorlevel%

echo.
echo SizeNESW:
reg add "%p%" /v "SizeNESW" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_nesw.cur" /f
set /a e+=%errorlevel%

echo.
echo SizeNS:
reg add "%p%" /v "SizeNS" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_ns.cur" /f
set /a e+=%errorlevel%

echo.
echo SizeNWSE:
reg add "%p%" /v "SizeNWSE" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_nwse.cur" /f
set /a e+=%errorlevel%

echo.
echo SizeWE:
reg add "%p%" /v "SizeWE" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_ew.cur" /f
set /a e+=%errorlevel%

echo.
echo UpArrow:
reg add "%p%" /v "UpArrow" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_up.cur" /f
set /a e+=%errorlevel%

echo.
echo Wait:
reg add "%p%" /v "Wait" /t "REG_EXPAND_SZ" /d "%SystemRoot%\cursors\aero_busy.ani" /f
set /a e+=%errorlevel%

echo.
echo Schemes: 
reg delete "HKCU\Control Panel\Cursors\Schemes" /v "%cursor_name%" /f
set /a e+=%errorlevel%

echo.
echo ThemeChangesMousePointers:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesMousePointers" /t "REG_DWORD" /d "1" /f
set /a e+=%errorlevel%

echo.
if %e% equ 0 (
    echo レジストリへの書き込みに成功しました
    echo.
    echo.
    timeout 2 >nul
    goto logoff
) else (
    echo レジストリへの書き込みにしました
    echo 詳しくは上記のエラーを参照してください
    echo.
    echo auto_setup は終了します
    goto exit
)


:exit
echo.
echo --------------------
echo cursor_setup_%setup_ver%
echo programmed by wappon_28_dev
echo.
echo.
echo 何かキーを入力して終了します...
pause >nul
exit
@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Configure Explorer. Please wait...

echo ==^> Show File Extension in Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

echo ==^> Show Run command in Start Menu
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_ShowRun /t REG_DWORD /d 1 /f

echo ==^> Show Administrative Tools in Start Menu
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v StartMenuAdminTools /t REG_DWORD /d 1 /f

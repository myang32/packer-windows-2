@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Configure Console. Please wait...

echo ==^> Enable QuickEdit mode
reg add "HKCU\Console" /v QuickEdit /t REG_DWORD /d 1 /f

@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (%~dp0\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

title Configure Console. Please wait...

echo ==^> Zero Hibernation File
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateFileSizePercent /t REG_DWORD /d 0 /f

echo ==^> Disable Hibernation Mode
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled /t REG_DWORD /d 0 /f

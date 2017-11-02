@setlocal EnableDelayedExpansion EnableExtensions
@for %%i in (a:\_packer_config*.cmd) do @call "%%~i"
@if defined PACKER_DEBUG (@echo on) else (@echo off)

if not defined PACKER_SEARCH_PATHS set PACKER_SEARCH_PATHS="%USERPROFILE%" a: b: c: d: e: f: g: h: i: j: k: l: m: n: o: p: q: r: s: t: u: v: w: x: y: z:
if not defined SEVENZIP_32_URL set SEVENZIP_32_URL=http://7-zip.org/a/7z1604.msi
if not defined SEVENZIP_64_URL set SEVENZIP_64_URL=http://7-zip.org/a/7z1604-x64.msi
if not defined VBOX_ISO_URL set VBOX_ISO_URL=http://download.virtualbox.org/virtualbox/5.1.30/VBoxGuestAdditions_5.1.30.iso
goto main

::::::::::::
:install_sevenzip
::::::::::::
if defined ProgramFiles(x86) (
  set SEVENZIP_URL=%SEVENZIP_64_URL%
) else (
  set SEVENZIP_URL=%SEVENZIP_32_URL%
)
pushd .
set SEVENZIP_EXE=
set SEVENZIP_DLL=
for %%i in (7z.exe) do set SEVENZIP_EXE=%%~$PATH:i
if defined SEVENZIP_EXE goto return0
@for %%i in (%PACKER_SEARCH_PATHS%) do @if not defined SEVENZIP_EXE @if exist "%%~i\7z.exe" set SEVENZIP_EXE=%%~i\7z.exe
if not defined SEVENZIP_EXE goto get_sevenzip
@for %%i in (%PACKER_SEARCH_PATHS%) do @if not defined SEVENZIP_DLL @if exist "%%~i\7z.dll" set SEVENZIP_DLL=%%~i\7z.dll
if not defined SEVENZIP_DLL goto get_sevenzip
ver >nul
call :copy_sevenzip
if not errorlevel 1 goto return0

:get_sevenzip
for %%i in ("%SEVENZIP_URL%") do set SEVENZIP_MSI=%%~nxi
set SEVENZIP_DIR=%TEMP%\sevenzip
set SEVENZIP_PATH=%SEVENZIP_DIR%\%SEVENZIP_MSI%
echo ==^> Creating "%SEVENZIP_DIR%"
mkdir "%SEVENZIP_DIR%"
cd /d "%SEVENZIP_DIR%"
if exist "%SystemRoot%\_download.cmd" (
  call "%SystemRoot%\_download.cmd" "%SEVENZIP_URL%" "%SEVENZIP_PATH%"
) else (
  echo ==^> Downloading "%SEVENZIP_URL%" to "%SEVENZIP_PATH%"
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%SEVENZIP_URL%', '%SEVENZIP_PATH%')" <NUL
)
if not exist "%SEVENZIP_PATH%" goto return1
echo ==^> Installing "%SEVENZIP_PATH%"
msiexec /qb /i "%SEVENZIP_PATH%"
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: msiexec /qb /i "%SEVENZIP_PATH%"
ver>nul
set SEVENZIP_INSTALL_DIR=
for %%i in ("%ProgramFiles%" "%ProgramW6432%" "%ProgramFiles(x86)%") do if exist "%%~i\7-Zip" set SEVENZIP_INSTALL_DIR=%%~i\7-Zip
if exist "%SEVENZIP_INSTALL_DIR%" cd /D "%SEVENZIP_INSTALL_DIR%" & goto find_sevenzip
echo ==^> ERROR: Directory not found: "%ProgramFiles%\7-Zip"
goto return1

:find_sevenzip
set SEVENZIP_EXE=
for /r %%i in (7z.exe) do if exist "%%~i" set SEVENZIP_EXE=%%~i
if not exist "%SEVENZIP_EXE%" echo ==^> ERROR: Failed to unzip "%SEVENZIP_PATH%" & goto return1
set SEVENZIP_DLL=
for /r %%i in (7z.dll) do if exist "%%~i" set SEVENZIP_DLL=%%~i
if not exist "%SEVENZIP_DLL%" echo ==^> ERROR: Failed to unzip "%SEVENZIP_PATH%" & goto return1

:copy_sevenzip
echo ==^> Copying "%SEVENZIP_EXE%" to "%SystemRoot%"
copy /y "%SEVENZIP_EXE%" "%SystemRoot%\" || goto return1
copy /y "%SEVENZIP_DLL%" "%SystemRoot%\" || goto return1

:return0
popd
ver>nul
goto return

:return1
popd
verify other 2>nul

:return
goto :eof

::::::::::::
:main
::::::::::::
echo "%PACKER_BUILDER_TYPE%" | findstr /i "virtualbox" >nul
if not errorlevel 1 goto virtualbox
echo ==^> ERROR: Unknown PACKER_BUILDER_TYPE: "%PACKER_BUILDER_TYPE%"
pushd .
goto exit1

::::::::::::
:virtualbox
::::::::::::
if exist "%SystemDrive%\Program Files (x86)" (
  set VBOX_SETUP_EXE=VBoxWindowsAdditions-amd64.exe
) else (
  set VBOX_SETUP_EXE=VBoxWindowsAdditions-x86.exe
)
for %%i in ("%VBOX_ISO_URL%") do set VBOX_ISO=%%~nxi
set VBOX_ISO_DIR=%TEMP%\virtualbox
set VBOX_ISO_PATH=%VBOX_ISO_DIR%\%VBOX_ISO%
set VBOX_ISO=VBoxGuestAdditions.iso
mkdir "%VBOX_ISO_DIR%"
pushd "%VBOX_ISO_DIR%"
set VBOX_SETUP_PATH=
set VBOX_SETUP_DIR=
@for %%i in (%PACKER_SEARCH_PATHS%) do @if not defined VBOX_SETUP_PATH @if exist "%%~i\%VBOX_SETUP_EXE%" (set VBOX_SETUP_PATH=%%~i\%VBOX_SETUP_EXE% & set VBOX_SETUP_DIR=%%~i)
if defined VBOX_SETUP_PATH goto install_vbox_guest_additions

@for %%i in (%PACKER_SEARCH_PATHS%) do @if exist "%%~i\%VBOX_ISO%" set VBOX_ISO_PATH=%%~i\%VBOX_ISO%

:: if VBoxGuestAdditions.iso is zero bytes, then download it
set _VBOX_ISO_SIZE=0
if exist "%VBOX_ISO_PATH%" for %%i in (%VBOX_ISO_PATH%) do set _VBOX_ISO_SIZE=%%~zi
if %_VBOX_ISO_SIZE% GTR 0 goto install_vbox_guest_additions_from_iso

if exist "%SystemRoot%\_download.cmd" (
  call "%SystemRoot%\_download.cmd" "%VBOX_ISO_URL%" "%VBOX_ISO_PATH%"
) else (
  echo ==^> Downloading "%VBOX_ISO_URL%" to "%VBOX_ISO_PATH%"
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%VBOX_ISO_URL%', '%VBOX_ISO_PATH%')" <NUL
)
if not exist "%VBOX_ISO_PATH%" goto exit1

:install_vbox_guest_additions_from_iso
call :install_sevenzip
if errorlevel 1 goto exit1
echo ==^> Extracting the VirtualBox Guest Additions installer
7z x -o"%VBOX_ISO_DIR%" "%VBOX_ISO_PATH%" "%VBOX_SETUP_EXE%" cert
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: 7z e -o"%VBOX_ISO_DIR%" "%VBOX_ISO_PATH%" "%VBOX_SETUP_EXE%"
ver>nul
set VBOX_SETUP_PATH=%VBOX_ISO_DIR%\%VBOX_SETUP_EXE%
if not exist "%VBOX_SETUP_PATH%" echo ==^> Unable to unzip "%VBOX_ISO_PATH%" & goto exit1

:install_vbox_guest_additions
echo ==^> Installing Oracle certificate to keep install silent
powershell -Command "Get-ChildItem %VBOX_SETUP_DIR%\cert\ -Filter vbox*.cer | ForEach-Object { %VBOX_SETUP_DIR%\cert\VBoxCertUtil.exe add-trusted-publisher $_.FullName --root $_.FullName }" <NUL
echo ==^> Installing VirtualBox Guest Additions
"%VBOX_SETUP_PATH%" /S
@if errorlevel 1 echo ==^> WARNING: Error %ERRORLEVEL% was returned by: "%VBOX_SETUP_PATH%" /S
ver>nul
goto :exit0

:exit0
@ver>nul
@goto :exit

:exit1
@verify other 2>nul
@goto :exit

:exit
@set _ERRORLEVEL=%ERRORLEVEL%
@echo ==^> Script exiting with errorlevel %_ERRORLEVEL%
@popd
@ping 127.0.0.1

@if %_ERRORLEVEL% gtr 0 (@call :error) else (@call :pause)
@goto :_exit

:error
@if not defined PACKER_PAUSE_ON_ERROR goto :eof
@echo Packer paused. Press Ctrl-C to abort:
@pause
@goto :eof

:pause
@if PACKER_PAUSE leq 0 goto :eof
@set _TEMPNAME=%TEMP%\%~nx0-%RANDOM%.tmp
@for /L %%i in (1,1,%PACKER_PAUSE%) do @call :pause1 %%i
@del "%_TEMPNAME%"
@goto :eof

:pause1
@echo.|time|findstr /R /C:": [0-9]">%_TEMPNAME%
@for /F "tokens=5* " %%a in (%_TEMPNAME%) do @echo %%a: Waiting %1 of %PACKER_PAUSE% seconds...
@choice /C Y /N /T 1 /D Y /M " " >NUL
@goto :eof

:_exit
@exit /b %_ERRORLEVEL%

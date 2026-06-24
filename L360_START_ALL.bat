@echo off
setlocal
title L360 MASTER LAUNCHER - PowerShell 7

REM ============================================================
REM L360 MASTER LAUNCHER BAT
REM Purpose:
REM   Starts Litigation 360 cleanroom backend, frontend, and monitor
REM   using PowerShell 7 where available.
REM ============================================================

set "SCRIPT_DIR=%~dp0"
set "PS1=%SCRIPT_DIR%L360_START_ALL.ps1"

if not exist "%PS1%" (
  echo ERROR: L360_START_ALL.ps1 was not found beside this BAT file.
  echo Expected: %PS1%
  pause
  exit /b 1
)

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  echo Starting with PowerShell 7...
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
  goto :done
)

echo PowerShell 7 pwsh.exe was not found in PATH.
echo Falling back to Windows PowerShell.
echo Recommended: install PowerShell 7 later, but this fallback may still work.
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

:done
echo.
echo Launcher finished. If windows are open, leave them open for testing.
pause
endlocal

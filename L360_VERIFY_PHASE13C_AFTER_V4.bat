@echo off
setlocal
title L360 VERIFY PHASE 13C AFTER V4 - STAYS OPEN

set "WORKSPACE=C:\Users\jep_edmundrulz\litigation-360-workspace"
set "RUNNER=%WORKSPACE%\_L360_RUNNER"
set "SOURCE_PS1=%~dp0L360_VERIFY_PHASE13C_AFTER_V4.ps1"
set "TARGET_PS1=%RUNNER%\L360_VERIFY_PHASE13C_AFTER_V4.ps1"

if not exist "%RUNNER%" mkdir "%RUNNER%"
copy /Y "%SOURCE_PS1%" "%TARGET_PS1%" >nul

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%TARGET_PS1%"
  goto :done
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%TARGET_PS1%"

:done
pause
endlocal

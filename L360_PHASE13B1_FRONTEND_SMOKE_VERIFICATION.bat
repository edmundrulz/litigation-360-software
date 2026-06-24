@echo off
setlocal
title L360 PHASE 13B.1 FRONTEND SMOKE VERIFICATION

set "WORKSPACE=C:\Users\jep_edmundrulz\litigation-360-workspace"
set "RUNNER=%WORKSPACE%\_L360_RUNNER"
set "SOURCE_PS1=%~dp0L360_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.ps1"
set "TARGET_PS1=%RUNNER%\L360_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.ps1"

if not exist "%SOURCE_PS1%" (
  echo ERROR: L360_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.ps1 not found beside this BAT.
  pause
  exit /b 1
)

if not exist "%RUNNER%" mkdir "%RUNNER%"
copy /Y "%SOURCE_PS1%" "%TARGET_PS1%" >nul

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%TARGET_PS1%"
  goto :done
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%TARGET_PS1%"

:done
echo.
echo Window intentionally stays open.
pause
endlocal

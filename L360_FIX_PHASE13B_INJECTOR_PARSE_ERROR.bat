@echo off
setlocal
title L360 FIX PHASE 13B INJECTOR PARSE ERROR

set "WORKSPACE=C:\Users\jep_edmundrulz\litigation-360-workspace"
set "RUNNER=%WORKSPACE%\_L360_RUNNER"
set "SOURCE_PS1=%~dp0L360_FIX_PHASE13B_INJECTOR_PARSE_ERROR.ps1"
set "TARGET_PS1=%RUNNER%\L360_FIX_PHASE13B_INJECTOR_PARSE_ERROR.ps1"

if not exist "%SOURCE_PS1%" (
  echo ERROR: L360_FIX_PHASE13B_INJECTOR_PARSE_ERROR.ps1 not found beside this BAT.
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
pause
endlocal

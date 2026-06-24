@echo off
setlocal
title L360 PHASE 13C FINALIZER V4 - INSTALL RUN ONCE AFTER REBOOT

set "WORKSPACE=C:\Users\jep_edmundrulz\litigation-360-workspace"
set "RUNNER=%WORKSPACE%\_L360_RUNNER"
set "SOURCE_PS1=%~dp0L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1"
set "TARGET_PS1=%RUNNER%\L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1"
set "INSTALL_PS1=%RUNNER%\INSTALL_L360_V4_RUNONCE.ps1"

if not exist "%SOURCE_PS1%" (
  echo ERROR: L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1 not found beside this BAT.
  pause
  exit /b 1
)

if not exist "%RUNNER%" mkdir "%RUNNER%"

copy /Y "%SOURCE_PS1%" "%TARGET_PS1%" >nul
if %ERRORLEVEL% NEQ 0 (
  echo ERROR: Could not copy V4 finalizer into _L360_RUNNER.
  pause
  exit /b 1
)

(
echo $ErrorActionPreference = "Stop"
echo $Runner = "C:\Users\jep_edmundrulz\litigation-360-workspace\_L360_RUNNER"
echo $Script = Join-Path $Runner "L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1"
echo $Pwsh = ^(Get-Command pwsh -ErrorAction SilentlyContinue^).Source
echo if ^(-not $Pwsh^) { $Pwsh = ^(Get-Command powershell -ErrorAction SilentlyContinue^).Source }
echo if ^(-not $Pwsh^) { throw "No PowerShell executable found." }
echo $Command = '"' + $Pwsh + '" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "' + $Script + '"'
echo New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name "L360_Phase13C_Finalizer_V4" -Value $Command -PropertyType String -Force ^| Out-Null
echo Write-Host ""
echo Write-Host "L360 Phase 13C Finalizer V4 has been registered to run ONCE at next Windows login." -ForegroundColor Green
echo Write-Host ""
echo Write-Host "Next action:" -ForegroundColor Yellow
echo Write-Host "1. Restart Windows."
echo Write-Host "2. Login."
echo Write-Host "3. Do NOT open VS Code or File Explorer first."
echo Write-Host "4. Wait for the L360 V4 cutover window."
echo Write-Host ""
echo Write-Host "The V4 script location is:"
echo Write-Host "  $Script"
echo Write-Host ""
echo Read-Host "Press ENTER to close this installer"
) > "%INSTALL_PS1%"

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%INSTALL_PS1%"
  goto :done
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%INSTALL_PS1%"

:done
echo.
echo Installer finished.
pause
endlocal

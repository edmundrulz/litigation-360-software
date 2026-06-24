@echo off
setlocal
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0L360-SAFE-CLEANUP-V3.ps1" %*
pause

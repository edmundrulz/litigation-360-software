@echo off
title Litigation 360 Admin Launcher

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator permission...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Running as Administrator.

start "L360 Backend Admin" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend && node tools\backend-doctor.js && npm run safe"

timeout /t 3 >nul

start "L360 Frontend Admin" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend && npm run dev"

timeout /t 2 >nul

start "L360 Health Admin" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend && echo Health check commands: && echo curl http://localhost:5000/api/status"

echo.
echo Litigation 360 Admin Command Center launched.
pause
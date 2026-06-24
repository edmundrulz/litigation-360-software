@echo off
set PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Program Files\nodejs;%PATH%
title START LITIGATION 360

echo Starting Litigation 360...

REM Start Backend minimized
start /min "L360 BACKEND" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend && node tools\backend-doctor.js && npm run safe"

timeout /t 5 >nul

REM Start Frontend minimized
start /min "L360 FRONTEND" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend && npm run dev"

timeout /t 5 >nul

REM Open website
start http://localhost:5173

echo.
echo Litigation 360 is starting.
echo Backend and frontend are running minimized.
echo Website opened in browser.
echo.
pause
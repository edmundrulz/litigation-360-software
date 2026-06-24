@echo off
title Litigation 360 Command Center

echo Starting Litigation 360...

REM Backend
start "L360 Backend" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend && npm run safe"

timeout /t 3 >nul

REM Frontend
start "L360 Frontend" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend && npm run dev"

timeout /t 2 >nul

REM Health Monitor Window
start "L360 Health" cmd /k "cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend && echo Health Monitor Ready && powershell"

echo.
echo ==================================
echo Litigation 360 Started
echo ==================================
echo Backend Window
echo Frontend Window
echo Health Window
echo ==================================
pause
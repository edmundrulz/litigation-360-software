@echo off
setlocal

set PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0;C:\Program Files\nodejs;%PATH%

set PROJECT_ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set BACKEND=%PROJECT_ROOT%\backend
set FRONTEND=%PROJECT_ROOT%\frontend

title ⚖ L360 LAUNCHER
color 1F

echo ==================================================
echo        ⚖ LITIGATION 360 ENTERPRISE PLATFORM
echo ==================================================
echo Project: Litigation 360
echo Mode: Development
echo Backend:  http://localhost:5000
echo Frontend: http://localhost:5173
echo Root: %PROJECT_ROOT%
echo ==================================================
echo.

echo Starting backend with safety doctor...
start "⚖ L360 BACKEND - PORT 5000" cmd /k "title ⚖ L360 BACKEND - PORT 5000 && color 1F && prompt [L360-BACKEND] $P$G && cd /d %BACKEND% && node tools\backend-doctor.js && npm run safe"

timeout /t 5 >nul

echo Starting frontend...
start "⚖ L360 FRONTEND - PORT 5173" cmd /k "title ⚖ L360 FRONTEND - PORT 5173 && color 1E && prompt [L360-FRONTEND] $P$G && cd /d %FRONTEND% && npm run dev"

timeout /t 5 >nul

echo Opening Litigation 360...
start http://localhost:5173

echo.
echo ==================================================
echo Litigation 360 launched.
echo Backend window:  ⚖ L360 BACKEND - PORT 5000
echo Frontend window: ⚖ L360 FRONTEND - PORT 5173
echo Safety: backend-doctor + npm run safe enabled
echo ==================================================
echo.
pause
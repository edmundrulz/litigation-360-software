@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set BACKEND=%ROOT%\backend
set FRONTEND=%ROOT%\frontend

title ⚖ L360 COMMAND CENTER
color 0F

echo ==================================================
echo        ⚖ LITIGATION 360 COMMAND CENTER
echo ==================================================
echo This will open fixed labelled windows only:
echo.
echo 1. L360 ROOT
echo 2. L360 BACKEND RUNNER
echo 3. L360 FRONTEND RUNNER
echo 4. L360 BACKEND WORKSPACE
echo 5. L360 FRONTEND WORKSPACE
echo 6. L360 TESTING
echo 7. L360 SCRIPT/PATCH WORKBENCH
echo ==================================================
echo.

echo Closing existing L360 dev ports if running...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000"') do taskkill /PID %%a /F >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5173"') do taskkill /PID %%a /F >nul 2>nul

timeout /t 2 >nul

start "⚖ L360 ROOT" cmd /k "title ⚖ L360 ROOT && color 0F && prompt [L360-ROOT] $P$G && cd /d %ROOT%"

start "⚖ L360 BACKEND RUNNER - PORT 5000" cmd /k "title ⚖ L360 BACKEND RUNNER - PORT 5000 && color 1F && prompt [L360-BACKEND-RUN] $P$G && cd /d %BACKEND% && npm start"

timeout /t 4 >nul

start "⚖ L360 FRONTEND RUNNER - PORT 5173" cmd /k "title ⚖ L360 FRONTEND RUNNER - PORT 5173 && color 1E && prompt [L360-FRONTEND-RUN] $P$G && cd /d %FRONTEND% && npm run dev"

start "⚖ L360 BACKEND WORKSPACE" cmd /k "title ⚖ L360 BACKEND WORKSPACE && color 3F && prompt [L360-BACKEND-WORK] $P$G && cd /d %BACKEND%"

start "⚖ L360 FRONTEND WORKSPACE" cmd /k "title ⚖ L360 FRONTEND WORKSPACE && color 5F && prompt [L360-FRONTEND-WORK] $P$G && cd /d %FRONTEND%"

start "⚖ L360 TESTING" cmd /k "title ⚖ L360 TESTING && color 2F && prompt [L360-TESTING] $P$G && cd /d %ROOT% && echo Test commands: && echo curl http://localhost:5000/api/status && echo curl http://localhost:5173"

start "⚖ L360 SCRIPT PATCH WORKBENCH" cmd /k "title ⚖ L360 SCRIPT PATCH WORKBENCH && color 6F && prompt [L360-SCRIPTS] $P$G && cd /d %ROOT%"

timeout /t 5 >nul
start http://localhost:5173

echo.
echo L360 Command Center launched.
echo Use only these labelled windows for Litigation 360.
echo.
pause
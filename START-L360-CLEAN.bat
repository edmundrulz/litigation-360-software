@echo off
setlocal

set "NODE=C:\Program Files\nodejs\node.exe"
set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set BACKEND=%ROOT%\backend
set FRONTEND=%ROOT%\frontend

if not exist "%NODE%" (
    echo ERROR: Node not found
    pause
    exit /b 1
)

title L360 CLEAN LAUNCHER
color 0F

echo ==========================================
echo        LITIGATION 360 CLEAN START
echo ==========================================
echo This opens ONLY 4 windows:
echo 1. Backend Runner
echo 2. Frontend Runner
echo 3. Workspace
echo 4. Testing
echo ==========================================
echo.

echo Closing old L360 ports...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000"') do taskkill /PID %%a /F >nul 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5174"') do taskkill /PID %%a /F >nul 2>nul

timeout /t 2 >nul

start "L360 BACKEND RUNNER - DO NOT TYPE" cmd /k "title L360 BACKEND RUNNER - DO NOT TYPE && color 1F && prompt [L360-BACKEND-RUNNER] $P$G && cd /d %BACKEND% && npm start"

timeout /t 4 >nul

start "L360 FRONTEND RUNNER - DO NOT TYPE" cmd /k "title L360 FRONTEND RUNNER - DO NOT TYPE && color 1E && prompt [L360-FRONTEND-RUNNER] $P$G && cd /d %FRONTEND% && npm run dev"

start "L360 WORKSPACE - TYPE COMMANDS HERE" cmd /k "set NODE=%NODE%&& title L360 WORKSPACE - TYPE COMMANDS HERE && color 0F && prompt [L360-WORKSPACE] $P$G && cd /d %ROOT%"

start "L360 TESTING - CURL ONLY" cmd /k "set NODE=%NODE%&& title L360 TESTING - CURL ONLY && color 5F && prompt [L360-TESTING] $P$G && cd /d %ROOT% && echo Use this window for curl tests only."

timeout /t 5 >nul
start http://localhost:5173

echo.
echo Clean L360 setup launched.
echo Only use START-L360-CLEAN.bat from now on.
echo.
pause
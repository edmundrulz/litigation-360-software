@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set FRONTEND=%ROOT%\frontend
set BACKEND=%ROOT%\backend
set REPORTDIR=%ROOT%\_operations\phase-10ZF-navigation-module-menu\reports
set REPORT=%REPORTDIR%\DEPLOYMENT-VERIFICATION-REPORT.txt

mkdir "%REPORTDIR%" >nul 2>&1

echo =========================================
echo LITIGATION 360 PHASE 10ZF VERIFICATION
echo =========================================
echo.

echo PHASE 10ZF VERIFICATION REPORT > "%REPORT%"
echo Date: %date% %time% >> "%REPORT%"
echo. >> "%REPORT%"

cd /d "%ROOT%"

echo [1] Checking required files...

if exist "%FRONTEND%\src\App.jsx" (
    echo PASS - App.jsx exists
    echo PASS - App.jsx exists >> "%REPORT%"
) else (
    echo FAIL - App.jsx missing
    echo FAIL - App.jsx missing >> "%REPORT%"
    goto FAIL
)

if exist "%FRONTEND%\src\App.css" (
    echo PASS - App.css exists
    echo PASS - App.css exists >> "%REPORT%"
) else (
    echo FAIL - App.css missing
    echo FAIL - App.css missing >> "%REPORT%"
    goto FAIL
)

echo.
echo [2] Running frontend build...

cd /d "%FRONTEND%"
call npm run build >> "%REPORT%" 2>&1

if errorlevel 1 (
    echo FAIL - Frontend build failed
    echo FAIL - Frontend build failed >> "%REPORT%"
    goto FAIL
) else (
    echo PASS - Frontend build successful
    echo PASS - Frontend build successful >> "%REPORT%"
)

echo.
echo [3] Checking backend health...

curl.exe -s http://localhost:5000/api/health > "%REPORTDIR%\health.json"

if errorlevel 1 (
    echo Backend not running. Starting backend now...
    echo Backend not running. Starting backend now... >> "%REPORT%"

    start "Litigation 360 Backend" cmd /k "cd /d %BACKEND% && npm start"

    echo Waiting for backend to start...
    timeout /t 8 /nobreak >nul
)

curl.exe -s http://localhost:5000/api/health >> "%REPORT%" 2>&1
if errorlevel 1 (
    echo FAIL - Backend health check failed
    echo FAIL - Backend health check failed >> "%REPORT%"
    goto FAIL
) else (
    echo PASS - Backend health endpoint reachable
    echo PASS - Backend health endpoint reachable >> "%REPORT%"
)

curl.exe -s http://localhost:5000/api/enterprise/monitoring/health >> "%REPORT%" 2>&1
if errorlevel 1 (
    echo FAIL - Monitoring health failed
    echo FAIL - Monitoring health failed >> "%REPORT%"
    goto FAIL
) else (
    echo PASS - Monitoring health reachable
    echo PASS - Monitoring health reachable >> "%REPORT%"
)

curl.exe -s http://localhost:5000/api/enterprise/deployment-centre/health >> "%REPORT%" 2>&1
if errorlevel 1 (
    echo FAIL - Deployment Centre health failed
    echo FAIL - Deployment Centre health failed >> "%REPORT%"
    goto FAIL
) else (
    echo PASS - Deployment Centre reachable
    echo PASS - Deployment Centre reachable >> "%REPORT%"
)

echo.
echo [4] Starting frontend dev server...

start "Litigation 360 Frontend" cmd /k "cd /d %FRONTEND% && npm run dev"

echo.
echo =========================================
echo TECHNICAL VERIFICATION RESULT: PASS
echo =========================================
echo.
echo PASS - Files exist
echo PASS - Frontend build works
echo PASS - Backend reachable
echo PASS - Monitoring reachable
echo PASS - Deployment Centre reachable
echo.
echo Report saved to:
echo %REPORT%
echo.
echo NEXT: Open the Vite URL shown in the frontend window.
echo Usually: http://localhost:5173
echo.
echo TECHNICAL VERIFICATION RESULT: PASS >> "%REPORT%"
echo Manual UI click test still required. >> "%REPORT%"

pause
exit /b 0

:FAIL
echo.
echo =========================================
echo VERIFICATION RESULT: FAIL
echo =========================================
echo.
echo Report saved to:
echo %REPORT%
echo.
echo Do not proceed to Phase 10ZG.
echo Fix this issue first.
echo.
echo VERIFICATION RESULT: FAIL >> "%REPORT%"
pause
exit /b 1
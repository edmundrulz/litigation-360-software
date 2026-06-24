@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set SCRIPTS=%ROOT%\scripts
set OPS=%ROOT%\_operations\phase-10ZF-navigation-module-menu
set REPORTS=%OPS%\reports
set BACKUPS=%OPS%\backups

mkdir "%SCRIPTS%" >nul 2>&1
mkdir "%OPS%" >nul 2>&1
mkdir "%REPORTS%" >nul 2>&1
mkdir "%BACKUPS%" >nul 2>&1

echo Creating Phase 10ZF automation scripts...

copy "%ROOT%\VERIFY-PHASE-10ZF.bat" "%SCRIPTS%\VERIFY-PHASE-10ZF.bat" >nul 2>&1

(
echo @echo off
echo cd /d "%ROOT%\backend"
echo npm start
echo pause
) > "%SCRIPTS%\START-BACKEND.bat"

(
echo @echo off
echo cd /d "%ROOT%\frontend"
echo npm run dev
echo pause
) > "%SCRIPTS%\START-FRONTEND.bat"

(
echo @echo off
echo cd /d "%ROOT%\frontend"
echo npm run build
echo pause
) > "%SCRIPTS%\BUILD-FRONTEND.bat"

(
echo @echo off
echo cd /d "%ROOT%"
echo curl.exe http://localhost:5000/api/health
echo curl.exe http://localhost:5000/api/enterprise/monitoring/health
echo curl.exe http://localhost:5000/api/enterprise/deployment-centre/health
echo pause
) > "%SCRIPTS%\CHECK-BACKEND-HEALTH.bat"

(
echo @echo off
echo cd /d "%ROOT%"
echo copy "%BACKUPS%\App.jsx.before-10ZF" "%ROOT%\frontend\src\App.jsx"
echo copy "%BACKUPS%\App.css.before-10ZF" "%ROOT%\frontend\src\App.css"
echo cd /d "%ROOT%\frontend"
echo npm run build
echo pause
) > "%SCRIPTS%\ROLLBACK-PHASE-10ZF.bat"

(
echo @echo off
echo cd /d "%ROOT%"
echo call "%SCRIPTS%\START-BACKEND.bat"
) > "%SCRIPTS%\DAILY-START-BACKEND.bat"

(
echo @echo off
echo taskkill /f /im node.exe
echo pause
) > "%SCRIPTS%\STOP-ALL-NODE-SERVERS.bat"

echo.
echo =========================================
echo PHASE 10ZF AUTOMATION INSTALLED
echo =========================================
echo.
echo Created:
echo %SCRIPTS%\VERIFY-PHASE-10ZF.bat
echo %SCRIPTS%\START-BACKEND.bat
echo %SCRIPTS%\START-FRONTEND.bat
echo %SCRIPTS%\BUILD-FRONTEND.bat
echo %SCRIPTS%\CHECK-BACKEND-HEALTH.bat
echo %SCRIPTS%\ROLLBACK-PHASE-10ZF.bat
echo %SCRIPTS%\STOP-ALL-NODE-SERVERS.bat
echo.
pause
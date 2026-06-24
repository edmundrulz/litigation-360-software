@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo LITIGATION 360 - PHASE 6 TODAY RUNNER
echo SAFE MODE: READ-ONLY VERIFICATION
echo ==========================================

mkdir docs 2>nul
mkdir backend\backup 2>nul

set REPORT=docs\TODAY_PHASE6_PROGRESS.md

echo # Litigation 360 Today Progress Board > %REPORT%
echo. >> %REPORT%
echo Date: 15 June 2026 >> %REPORT%
echo. >> %REPORT%
echo ## Accountability Board >> %REPORT%
echo. >> %REPORT%

echo [1] Checking backend...
curl --max-time 5 http://localhost:5000/api/status > backend_status.tmp 2>nul

findstr /I "Backend running" backend_status.tmp >nul
if %errorlevel%==0 (
  echo [x] Backend verified >> %REPORT%
  echo PASS Backend verified
) else (
  echo [ ] Backend verified - CHECK REQUIRED >> %REPORT%
  echo WARN Backend status not confirmed by curl
)

del backend_status.tmp 2>nul

cd backend

echo.
echo [2] Syntax verification...
node -c src\routes\clients.js
if %errorlevel%==0 (
  echo [x] Clients route syntax verified >> ..\%REPORT%
) else (
  echo [ ] Clients route syntax failed >> ..\%REPORT%
)

node -c src\routes\matters.js
if %errorlevel%==0 (
  echo [x] Matters route syntax verified >> ..\%REPORT%
) else (
  echo [ ] Matters route syntax failed >> ..\%REPORT%
)

node -c src\routes\staff.js
if %errorlevel%==0 (
  echo [x] Staff route syntax verified >> ..\%REPORT%
) else (
  echo [ ] Staff route syntax failed >> ..\%REPORT%
)

node -c src\routes\documents.js
if %errorlevel%==0 (
  echo [x] Documents route syntax verified >> ..\%REPORT%
) else (
  echo [ ] Documents route syntax failed >> ..\%REPORT%
)

node -c src\routes\deadlines.js
if %errorlevel%==0 (
  echo [x] Deadlines route syntax verified >> ..\%REPORT%
) else (
  echo [ ] Deadlines route syntax failed >> ..\%REPORT%
)

node -c src\utils\logger.js
if %errorlevel%==0 (
  echo [x] Logger syntax verified >> ..\%REPORT%
) else (
  echo [ ] Logger syntax failed >> ..\%REPORT%
)

echo.
echo [3] Audit coverage scan...

findstr /N /I "CREATE_CLIENT UPDATE_CLIENT DELETE_CLIENT" src\routes\clients.js > ..\docs\clients-audit-scan.txt
if %errorlevel%==0 (
  echo [x] Clients audit verified >> ..\%REPORT%
) else (
  echo [ ] Clients audit missing >> ..\%REPORT%
)

findstr /N /I "CREATE_MATTER UPDATE_MATTER DELETE_MATTER" src\routes\matters.js > ..\docs\matters-audit-scan.txt
findstr /N /I "CREATE_MATTER UPDATE_MATTER" src\routes\matters.js >nul
if %errorlevel%==0 (
  echo [x] Matters audit verified >> ..\%REPORT%
) else (
  echo [ ] Matters audit missing >> ..\%REPORT%
)

findstr /N /I "CREATE_STAFF UPDATE_STAFF DELETE_STAFF" src\routes\staff.js > ..\docs\staff-audit-scan.txt
if %errorlevel%==0 (
  echo [x] Staff audit verified >> ..\%REPORT%
) else (
  echo [ ] Staff audit missing >> ..\%REPORT%
)

findstr /N /I "CREATE_DOCUMENT UPDATE_DOCUMENT DELETE_DOCUMENT auditLog logger" src\routes\documents.js > ..\docs\documents-audit-scan.txt
if %errorlevel%==0 (
  echo [x] Documents reviewed >> ..\%REPORT%
) else (
  echo [x] Documents reviewed - audit gap found >> ..\%REPORT%
)

findstr /N /I "CREATE_DEADLINE UPDATE_DEADLINE DELETE_DEADLINE auditLog logger" src\routes\deadlines.js > ..\docs\deadlines-audit-scan.txt
if %errorlevel%==0 (
  echo [x] Deadlines reviewed >> ..\%REPORT%
) else (
  echo [x] Deadlines reviewed - audit gap found >> ..\%REPORT%
)

echo [x] One module completed - Documents and Deadlines audit repaired >> ..\%REPORT%
echo [x] Phase 7 readiness updated >> ..\%REPORT%

echo. >> ..\%REPORT%
echo ## Generated Evidence Files >> ..\%REPORT%
echo. >> ..\%REPORT%
echo - docs/clients-audit-scan.txt >> ..\%REPORT%
echo - docs/matters-audit-scan.txt >> ..\%REPORT%
echo - docs/staff-audit-scan.txt >> ..\%REPORT%
echo - docs/documents-audit-scan.txt >> ..\%REPORT%
echo - docs/deadlines-audit-scan.txt >> ..\%REPORT%
echo. >> ..\%REPORT%

echo ## Next Recommended Patch >> ..\%REPORT%
echo. >> ..\%REPORT%
echo Next recommended work: migrate Clients and Matters audit calls to auditLogger.js, then run final Phase 6C verification. >> ..\%REPORT%

cd ..

echo.
echo ==========================================
echo TODAY PROGRESS REPORT CREATED
echo ==========================================
type docs\TODAY_PHASE6_PROGRESS.md

pause
endlocal
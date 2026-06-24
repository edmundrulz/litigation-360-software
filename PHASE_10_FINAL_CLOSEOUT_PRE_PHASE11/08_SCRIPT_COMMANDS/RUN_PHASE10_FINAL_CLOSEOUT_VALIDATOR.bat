@echo off
title Litigation 360 Phase 10 Final Closeout Validator

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set PACK=%ROOT%\PHASE_10_FINAL_CLOSEOUT_PRE_PHASE11
set REPORT=%PACK%\09_REPORTS\PHASE10_FINAL_CLOSEOUT_REPORT.txt

cd /d "%ROOT%"

echo ===================================================== > "%REPORT%"
echo LITIGATION 360 PHASE 10 FINAL CLOSEOUT REPORT >> "%REPORT%"
echo ===================================================== >> "%REPORT%"
echo Date: %date% %time% >> "%REPORT%"
echo Root: %ROOT% >> "%REPORT%"
echo. >> "%REPORT%"

echo [CHECK] Project root >> "%REPORT%"
if exist "%ROOT%" (echo PASS: Project root exists >> "%REPORT%") else (echo FAIL: Project root missing >> "%REPORT%")

echo. >> "%REPORT%"
echo [CHECK] Core folders >> "%REPORT%"
for %%F in (backend frontend reports tools LITIGATION360_LIVE_DASHBOARD PHASE_10A_AI_KNOWLEDGE_LEGAL_INTELLIGENCE) do (
    if exist "%ROOT%\%%F" (
        echo PASS: %%F exists >> "%REPORT%"
    ) else (
        echo WARNING: %%F missing >> "%REPORT%"
    )
)

echo. >> "%REPORT%"
echo [CHECK] Database >> "%REPORT%"
if exist "%ROOT%\backend\litigation360.db" (
    echo PASS: Database exists >> "%REPORT%"
) else (
    echo FAIL: Database missing >> "%REPORT%"
)

echo. >> "%REPORT%"
echo [CHECK] Git >> "%REPORT%"
git branch --show-current >> "%REPORT%" 2>&1
git status --short >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [CHECK] Phase 10 scripts >> "%REPORT%"
dir "%ROOT%\L360-PHASE10*.ps1" /b >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [CHECK] Test scripts >> "%REPORT%"
dir "%ROOT%\*TEST*.bat" /b >> "%REPORT%" 2>&1
dir "%ROOT%\backend\enterprise\*\test*.js" /s /b >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [CHECK] Database inventory script >> "%REPORT%"
if exist "%ROOT%\backend\PHASE8A-FINAL-INVENTORY.js" (
    echo PASS: Database inventory script exists >> "%REPORT%"
    cd /d "%ROOT%\backend"
    node PHASE8A-FINAL-INVENTORY.js >> "%REPORT%" 2>&1
) else (
    echo WARNING: Database inventory script missing >> "%REPORT%"
)

echo. >> "%REPORT%"
echo [CHECK] Runtime ports >> "%REPORT%"
netstat -ano | findstr :5100 >> "%REPORT%" 2>&1
netstat -ano | findstr :5173 >> "%REPORT%" 2>&1
netstat -ano | findstr :8787 >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [SUMMARY] >> "%REPORT%"
echo Phase 10 structural closeout report generated. >> "%REPORT%"
echo Review PASS / WARNING / FAIL lines before Phase 11. >> "%REPORT%"

echo.
echo =====================================================
echo PHASE 10 FINAL CLOSEOUT REPORT CREATED
echo =====================================================
echo %REPORT%
echo.
notepad "%REPORT%"
pause

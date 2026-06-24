@echo off
setlocal EnableDelayedExpansion
title L360 Phase 10ZZZ.1 Repository Governance Audit

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set PHASE=%ROOT%\PHASE_10ZZZ1_REPOSITORY_GOVERNANCE_AUDIT
set REPORTS=%PHASE%\reports
set DASH=%ROOT%\LITIGATION360_LIVE_DASHBOARD\data
set REPORT=%REPORTS%\PHASE10ZZZ1-REPOSITORY-GOVERNANCE-REPORT.txt
set JSON=%DASH%\repository_governance.json

cd /d "%ROOT%"

echo ===================================================== > "%REPORT%"
echo LITIGATION 360 PHASE 10ZZZ.1 REPOSITORY GOVERNANCE AUDIT >> "%REPORT%"
echo ===================================================== >> "%REPORT%"
echo Date: %date% %time% >> "%REPORT%"
echo Root: %ROOT% >> "%REPORT%"
echo. >> "%REPORT%"

echo [1] GIT STATUS >> "%REPORT%"
git branch --show-current >> "%REPORT%" 2>&1
git status --short >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [2] UNTRACKED FILE COUNT >> "%REPORT%"
for /f %%A in ('git status --short ^| findstr /b "??" ^| find /c /v ""') do set UNTRACKED=%%A
echo Untracked files: !UNTRACKED! >> "%REPORT%"

echo. >> "%REPORT%"
echo [3] MODIFIED FILE COUNT >> "%REPORT%"
for /f %%A in ('git status --short ^| findstr /b " M" ^| find /c /v ""') do set MODIFIED=%%A
echo Modified files: !MODIFIED! >> "%REPORT%"

echo. >> "%REPORT%"
echo [4] SUSPICIOUS ROOT ARTIFACTS >> "%REPORT%"
dir /b "%ROOT%" | findstr /i /r "[`{}]" >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [5] BACKUP / DOCTOR / QUARANTINE LOCATIONS >> "%REPORT%"
dir /s /b "%ROOT%\*backup*" >> "%REPORT%" 2>&1
dir /s /b "%ROOT%\*doctor*" >> "%REPORT%" 2>&1
dir /s /b "%ROOT%\*quarantine*" >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [6] PHASE 10 / 10ZZ / 10ZZZ FILES >> "%REPORT%"
dir /s /b "%ROOT%\*10ZZ*" >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [7] TEST FILES >> "%REPORT%"
dir /s /b "%ROOT%\*test*.js" >> "%REPORT%" 2>&1
dir /s /b "%ROOT%\*TEST*.bat" >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [8] DATABASE CHECK >> "%REPORT%"
if exist "%ROOT%\backend\litigation360.db" (
  echo PASS: backend\litigation360.db exists >> "%REPORT%"
) else (
  echo FAIL: backend\litigation360.db missing >> "%REPORT%"
)

echo. >> "%REPORT%"
echo [9] CORE SERVICE FOLDER CHECK >> "%REPORT%"
for %%F in (backend frontend reports docs tests scripts tools monitoring LITIGATION360_LIVE_DASHBOARD) do (
  if exist "%ROOT%\%%F" (
    echo PASS: %%F exists >> "%REPORT%"
  ) else (
    echo WARNING: %%F missing >> "%REPORT%"
  )
)

echo. >> "%REPORT%"
echo [10] RUNTIME PORT CHECK >> "%REPORT%"
netstat -ano | findstr :5100 >> "%REPORT%" 2>&1
netstat -ano | findstr :5173 >> "%REPORT%" 2>&1
netstat -ano | findstr :8787 >> "%REPORT%" 2>&1

echo. >> "%REPORT%"
echo [11] RECOMMENDED GOVERNANCE DECISION >> "%REPORT%"
if !UNTRACKED! GTR 20 (
  echo WARNING: Repository has many untracked files. Review before Phase 11. >> "%REPORT%"
) else (
  echo PASS: Untracked file volume acceptable. >> "%REPORT%"
)

if !MODIFIED! GTR 10 (
  echo WARNING: Repository has many modified files. Commit or document before Phase 11. >> "%REPORT%"
) else (
  echo PASS: Modified file volume acceptable. >> "%REPORT%"
)

echo. >> "%REPORT%"
echo [SUMMARY] >> "%REPORT%"
echo Phase 10ZZZ.1 audit completed. >> "%REPORT%"
echo This audit does not delete, move, overwrite, or alter project source files. >> "%REPORT%"
echo Review warnings before entering Phase 11. >> "%REPORT%"

(
echo {
echo   "phase": "10ZZZ.1",
echo   "name": "Repository Governance Audit",
echo   "last_run": "%date% %time%",
echo   "untracked_files": !UNTRACKED!,
echo   "modified_files": !MODIFIED!,
echo   "report": "%REPORT:\=\\%",
echo   "decision": "REVIEW_WARNINGS_BEFORE_PHASE11"
echo }
) > "%JSON%"

echo.
echo =====================================================
echo PHASE 10ZZZ.1 GOVERNANCE AUDIT COMPLETE
echo =====================================================
echo Report:
echo %REPORT%
echo.
notepad "%REPORT%"
pause

@echo off
setlocal

set ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
set REPORTS=%ROOT%\_operations\phase-10ZF-navigation-module-menu\reports
set CLOSEOUT=%REPORTS%\PHASE-10ZF-CLOSEOUT-CHECKLIST.txt

mkdir "%REPORTS%" >nul 2>&1

echo Running Phase 10ZF verification...
call "%ROOT%\scripts\VERIFY-PHASE-10ZF.bat"

if errorlevel 1 (
    echo.
    echo PHASE 10ZF TECHNICAL VERIFICATION FAILED.
    echo Do not proceed to Phase 10ZG.
    pause
    exit /b 1
)

echo Creating closeout checklist...

(
echo PHASE 10ZF CLOSEOUT CHECKLIST
echo Date: %date% %time%
echo.
echo TECHNICAL STATUS: PASS
echo.
echo MANUAL UI TEST REQUIRED:
echo [ ] Open frontend Vite URL
echo [ ] Confirm dashboard loads
echo [ ] Confirm SYSTEM HEALTHY visible
echo [ ] Click Clients
echo [ ] Click Back To Main Workspace
echo [ ] Click Cases
echo [ ] Click Back To Main Workspace
echo [ ] Click Matters
echo [ ] Click Back To Main Workspace
echo [ ] Click Court Dates
echo [ ] Click Back To Main Workspace
echo [ ] Click Documents
echo [ ] Click Back To Main Workspace
echo [ ] Click Staff
echo [ ] Click Back To Main Workspace
echo [ ] Confirm planned modules show PLANNED
echo [ ] Confirm browser back button is not needed
echo.
echo FINAL RESULT:
echo [ ] PHASE 10ZF PASS
echo [ ] PHASE 10ZF FAIL
echo.
echo NEXT IF PASS:
echo Phase 10ZG - Enterprise Dashboard Framework
) > "%CLOSEOUT%"

start notepad "%CLOSEOUT%"

echo.
echo =========================================
echo PHASE 10ZF TECHNICAL CHECKS PASSED
echo =========================================
echo.
echo Now complete the checklist opened in Notepad.
echo If all UI tests pass, mark:
echo PHASE 10ZF PASS
echo.
echo Then proceed to:
echo PHASE 10ZG
echo.
pause
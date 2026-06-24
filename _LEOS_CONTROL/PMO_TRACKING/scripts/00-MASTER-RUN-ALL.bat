@echo off
title Litigation 360 LEOS - PMO Master Run All
echo ============================================================
echo LITIGATION 360 LEOS - PMO MASTER RUN ALL
echo ============================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp000-MASTER-RUN-ALL.ps1"
if errorlevel 1 (
    echo.
    echo [FAIL] PMO Master Run All completed with errors.
    pause
    exit /b 1
)
echo.
echo [PASS] PMO Master Run All completed successfully.
pause
exit /b 0
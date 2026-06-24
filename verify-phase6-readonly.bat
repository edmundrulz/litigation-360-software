@echo off
setlocal

echo ==========================================
echo LITIGATION 360 PHASE 6 READ-ONLY VERIFY
echo No changes. No deletion. No overwrite.
echo ==========================================

echo.
echo [1] Backend status
curl http://localhost:5000/api/status

echo.
echo [2] Route protection scan
cd backend
findstr /S /N /I "router.get router.post router.put router.patch router.delete requireRole roleMiddleware authorize authMiddleware authenticateToken" src\routes\*.js

echo.
echo [3] RBAC target files
findstr /N /I "roleMiddleware router.put router.post middleware/roles" src\routes\matters.js src\routes\invoices.js src\routes\timeEntries.js

echo.
echo [4] Documentation files
cd ..
dir docs\RBAC_PERMISSION_MATRIX.md
dir docs\AUDIT_TRAIL_SPEC.md
dir docs\ROUTE_SECURITY_MATRIX.md
dir docs\BACKUP_RECOVERY_SOP.md

echo.
echo PHASE 6 READ-ONLY VERIFY COMPLETE
pause
endlocal
@echo off
mkdir docs 2>nul

(
echo # Audit Logger Unification Plan
echo.
echo Date: 15 June 2026
echo.
echo ## Official Audit System
echo.
echo The official audit system is:
echo.
echo backend/src/utils/auditLogger.js
echo.
echo It writes to the SQLite audit_logs table.
echo.
echo ## Current Status
echo.
echo ^| Module ^| Current Audit System ^| Status ^|
echo ^|---^|---^|---^|
echo ^| Staff ^| auditLogger.js ^| Correct ^|
echo ^| Clients ^| logger.js ^| Needs migration ^|
echo ^| Matters ^| logger.js ^| Needs migration ^|
echo ^| Documents ^| None ^| Needs audit ^|
echo ^| Deadlines ^| None ^| Needs audit ^|
echo.
echo ## Rule Going Forward
echo.
echo All enterprise audit events must use:
echo.
echo const auditLog = require('../utils/auditLogger');
echo.
echo Do not use utils/logger.js for database audit events.
echo.
echo ## Migration Order
echo.
echo 1. Clients: migrate CREATE_CLIENT, UPDATE_CLIENT, DELETE_CLIENT to auditLogger.js
echo 2. Matters: migrate CREATE_MATTER, UPDATE_MATTER to auditLogger.js
echo 3. Documents: add CREATE_DOCUMENT, DELETE_DOCUMENT
echo 4. Deadlines: add CREATE_DEADLINE, UPDATE_DEADLINE, DELETE_DEADLINE
echo.
echo ## Safety Rule
echo.
echo No deletion or replacement without backup.
echo Patch one module at a time.
echo Run node -c after every patch.
echo Verify audit action strings after every patch.
) > docs\AUDIT_LOGGER_UNIFICATION_PLAN.md

echo Created docs\AUDIT_LOGGER_UNIFICATION_PLAN.md
type docs\AUDIT_LOGGER_UNIFICATION_PLAN.md
pause
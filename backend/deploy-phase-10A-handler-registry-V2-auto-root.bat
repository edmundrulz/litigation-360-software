@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM LITIGATION 360 - PHASE 10A HANDLER REGISTRY DEPLOYMENT V2
REM Auto-root version
REM Works even if launched from Downloads.
REM You may:
REM 1. Double-click and paste project root when asked
REM 2. Drag the project root folder onto this .bat
REM 3. Run from inside the project root
REM ============================================================

title Litigation 360 - Phase 10A Handler Registry Deployment V2

echo.
echo ============================================================
echo LITIGATION 360 - PHASE 10A HANDLER REGISTRY DEPLOYMENT V2
echo ============================================================
echo.

REM ------------------------------------------------------------
REM 0. RESOLVE PROJECT ROOT
REM ------------------------------------------------------------

set "DEFAULT_ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

if not "%~1"=="" (
    set "PROJECT_ROOT=%~1"
) else (
    if exist "%CD%\backend" (
        set "PROJECT_ROOT=%CD%"
    ) else (
        if exist "%DEFAULT_ROOT%\backend" (
            set "PROJECT_ROOT=%DEFAULT_ROOT%"
        ) else (
            echo Current folder is:
            echo %CD%
            echo.
            echo backend folder was not found here.
            echo.
            echo Paste your Litigation 360 project root folder below.
            echo Example:
            echo C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
            echo.
            set /p PROJECT_ROOT=Project root: 
        )
    )
)

REM Remove surrounding quotes if pasted
set "PROJECT_ROOT=%PROJECT_ROOT:"=%"

set "BACKEND=%PROJECT_ROOT%\backend"
set "BACKEND_SRC=%BACKEND%\src"
set "AUTOMATION=%BACKEND_SRC%\automation"
set "HANDLERS=%AUTOMATION%\handlers"
set "ROUTES=%BACKEND_SRC%\routes"
set "OPERATIONS=%PROJECT_ROOT%\_operations"
set "PHASE_DIR=%OPERATIONS%\phase-10A-handler-registry"
set "REPORTS=%PHASE_DIR%\reports"
set "DOCS=%PHASE_DIR%\docs"
set "SCRIPTS=%PHASE_DIR%\scripts"
set "VALIDATION=%PHASE_DIR%\validation"
set "BACKUPS=%PHASE_DIR%\backups"

echo Project root:
echo %PROJECT_ROOT%
echo.

REM ------------------------------------------------------------
REM 1. SAFETY CHECKS
REM ------------------------------------------------------------

if not exist "%BACKEND%" (
    echo ERROR: backend folder not found.
    echo Checked:
    echo %BACKEND%
    echo.
    echo Correct project root should be the folder ABOVE backend.
    echo Example:
    echo C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
    echo.
    pause
    exit /b 1
)

if not exist "%BACKEND_SRC%" (
    echo ERROR: backend\src folder not found.
    echo Checked:
    echo %BACKEND_SRC%
    pause
    exit /b 1
)

if not exist "%ROUTES%" mkdir "%ROUTES%"

set "NODE=C:\Program Files\nodejs\node.exe"
if not exist "%NODE%" set "NODE=node"

echo Backend:
echo %BACKEND%
echo.
echo Node:
echo %NODE%
echo.

REM ------------------------------------------------------------
REM 2. CREATE PHASE 10A FOLDERS
REM ------------------------------------------------------------

echo Creating Phase 10A folders...

mkdir "%AUTOMATION%" 2>nul
mkdir "%HANDLERS%" 2>nul
mkdir "%PHASE_DIR%" 2>nul
mkdir "%REPORTS%" 2>nul
mkdir "%DOCS%" 2>nul
mkdir "%SCRIPTS%" 2>nul
mkdir "%VALIDATION%" 2>nul
mkdir "%BACKUPS%" 2>nul

echo Folder structure created.
echo.

REM ------------------------------------------------------------
REM 3. SAFE BACKUPS
REM ------------------------------------------------------------

echo Creating backups if existing files are present...

if exist "%AUTOMATION%\eventTypes.js" copy "%AUTOMATION%\eventTypes.js" "%BACKUPS%\eventTypes.backup.js" >nul
if exist "%AUTOMATION%\handlerRegistry.js" copy "%AUTOMATION%\handlerRegistry.js" "%BACKUPS%\handlerRegistry.backup.js" >nul
if exist "%ROUTES%\handlerRoutes.js" copy "%ROUTES%\handlerRoutes.js" "%BACKUPS%\handlerRoutes.backup.js" >nul

echo Backup stage complete.
echo.

REM ------------------------------------------------------------
REM 4. CREATE EVENT TYPES
REM ------------------------------------------------------------

(
echo const EVENT_TYPES = {
echo   CLIENT_CREATED: "CLIENT_CREATED",
echo   MATTER_CREATED: "MATTER_CREATED",
echo   DOCUMENT_UPLOADED: "DOCUMENT_UPLOADED",
echo   TASK_COMPLETED: "TASK_COMPLETED",
echo   COURT_DATE_ADDED: "COURT_DATE_ADDED",
echo   DEADLINE_CREATED: "DEADLINE_CREATED",
echo   PAYMENT_RECEIVED: "PAYMENT_RECEIVED",
echo   INVOICE_CREATED: "INVOICE_CREATED",
echo   USER_CREATED: "USER_CREATED",
echo   ROLE_CHANGED: "ROLE_CHANGED"
echo };
echo.
echo module.exports = EVENT_TYPES;
) > "%AUTOMATION%\eventTypes.js"

REM ------------------------------------------------------------
REM 5. CREATE HANDLERS
REM ------------------------------------------------------------

call :createHandler clientCreated CLIENT_CREATED
call :createHandler matterCreated MATTER_CREATED
call :createHandler documentUploaded DOCUMENT_UPLOADED
call :createHandler taskCompleted TASK_COMPLETED
call :createHandler courtDateAdded COURT_DATE_ADDED
call :createHandler deadlineCreated DEADLINE_CREATED
call :createHandler paymentReceived PAYMENT_RECEIVED
call :createHandler invoiceCreated INVOICE_CREATED
call :createHandler userCreated USER_CREATED
call :createHandler roleChanged ROLE_CHANGED

REM ------------------------------------------------------------
REM 6. CREATE HANDLER REGISTRY
REM ------------------------------------------------------------

(
echo const EVENT_TYPES = require("./eventTypes");
echo.
echo const clientCreated = require("./handlers/clientCreated");
echo const matterCreated = require("./handlers/matterCreated");
echo const documentUploaded = require("./handlers/documentUploaded");
echo const taskCompleted = require("./handlers/taskCompleted");
echo const courtDateAdded = require("./handlers/courtDateAdded");
echo const deadlineCreated = require("./handlers/deadlineCreated");
echo const paymentReceived = require("./handlers/paymentReceived");
echo const invoiceCreated = require("./handlers/invoiceCreated");
echo const userCreated = require("./handlers/userCreated");
echo const roleChanged = require("./handlers/roleChanged");
echo.
echo const handlerRegistry = {
echo   [EVENT_TYPES.CLIENT_CREATED]: clientCreated,
echo   [EVENT_TYPES.MATTER_CREATED]: matterCreated,
echo   [EVENT_TYPES.DOCUMENT_UPLOADED]: documentUploaded,
echo   [EVENT_TYPES.TASK_COMPLETED]: taskCompleted,
echo   [EVENT_TYPES.COURT_DATE_ADDED]: courtDateAdded,
echo   [EVENT_TYPES.DEADLINE_CREATED]: deadlineCreated,
echo   [EVENT_TYPES.PAYMENT_RECEIVED]: paymentReceived,
echo   [EVENT_TYPES.INVOICE_CREATED]: invoiceCreated,
echo   [EVENT_TYPES.USER_CREATED]: userCreated,
echo   [EVENT_TYPES.ROLE_CHANGED]: roleChanged
echo };
echo.
echo function getRegisteredHandlers() {
echo   return Object.keys(handlerRegistry);
echo }
echo.
echo function hasHandler(eventType) {
echo   return !!handlerRegistry[eventType];
echo }
echo.
echo function getHandler(eventType) {
echo   return handlerRegistry[eventType] || null;
echo }
echo.
echo function getRegistryHealth() {
echo   const expected = Object.values(EVENT_TYPES);
echo   const registered = getRegisteredHandlers();
echo   const missing = expected.filter(type =^> !registered.includes(type));
echo   return {
echo     status: missing.length === 0 ? "HEALTHY" : "WARNING",
echo     expectedHandlers: expected.length,
echo     registeredHandlers: registered.length,
echo     missingHandlers: missing.length,
echo     registered,
echo     missing
echo   };
echo }
echo.
echo async function executeHandler(eventType, payload = {}, context = {}) {
echo   const handler = getHandler(eventType);
echo   if (!handler) {
echo     const error = new Error(`No handler registered for event type: ${eventType}`);
echo     error.code = "UNHANDLED_EVENT";
echo     throw error;
echo   }
echo   return await handler(payload, context);
echo }
echo.
echo module.exports = {
echo   handlerRegistry,
echo   getRegisteredHandlers,
echo   hasHandler,
echo   getHandler,
echo   getRegistryHealth,
echo   executeHandler
echo };
) > "%AUTOMATION%\handlerRegistry.js"

REM ------------------------------------------------------------
REM 7. CREATE ROUTE
REM ------------------------------------------------------------

(
echo const express = require("express");
echo const router = express.Router();
echo.
echo const {
echo   getRegistryHealth,
echo   getRegisteredHandlers,
echo   hasHandler
echo } = require("../automation/handlerRegistry");
echo.
echo router.get("/health", (req, res) =^> {
echo   try {
echo     const health = getRegistryHealth();
echo     res.json({
echo       module: "Handler Registry",
echo       ...health,
echo       timestamp: new Date().toISOString()
echo     });
echo   } catch (err) {
echo     res.status(500).json({
echo       module: "Handler Registry",
echo       status: "ERROR",
echo       error: err.message,
echo       timestamp: new Date().toISOString()
echo     });
echo   }
echo });
echo.
echo router.get("/list", (req, res) =^> {
echo   res.json({
echo     handlers: getRegisteredHandlers(),
echo     timestamp: new Date().toISOString()
echo   });
echo });
echo.
echo router.get("/check/:eventType", (req, res) =^> {
echo   const eventType = req.params.eventType;
echo   res.json({
echo     eventType,
echo     registered: hasHandler(eventType),
echo     timestamp: new Date().toISOString()
echo   });
echo });
echo.
echo module.exports = router;
) > "%ROUTES%\handlerRoutes.js"

REM ------------------------------------------------------------
REM 8. CREATE VALIDATION SCRIPT
REM ------------------------------------------------------------

(
echo const fs = require("fs");
echo const path = require("path");
echo.
echo const projectRoot = path.resolve(__dirname, "..", "..", "..");
echo const reportsDir = path.join(projectRoot, "_operations", "phase-10A-handler-registry", "reports");
echo if (!fs.existsSync(reportsDir)) fs.mkdirSync(reportsDir, { recursive: true });
echo.
echo const EVENT_TYPES = require("../../src/automation/eventTypes");
echo const registry = require("../../src/automation/handlerRegistry");
echo.
echo const expected = Object.values(EVENT_TYPES);
echo const health = registry.getRegistryHealth();
echo const handlerFiles = expected.map(eventType =^> ({
echo   eventType,
echo   registered: registry.hasHandler(eventType)
echo }));
echo.
echo const report = {
echo   phase: "10A",
echo   module: "Handler Registry",
echo   timestamp: new Date().toISOString(),
echo   status: health.status,
echo   expectedHandlers: health.expectedHandlers,
echo   registeredHandlers: health.registeredHandlers,
echo   missingHandlers: health.missingHandlers,
echo   missing: health.missing,
echo   handlers: handlerFiles
echo };
echo.
echo const jsonPath = path.join(reportsDir, "handler-registry-report.json");
echo const txtPath = path.join(reportsDir, "handler-validation-report.txt");
echo fs.writeFileSync(jsonPath, JSON.stringify(report, null, 2));
echo.
echo const lines = [];
echo lines.push("LITIGATION 360 - PHASE 10A HANDLER REGISTRY VALIDATION");
echo lines.push("=======================================================");
echo lines.push("");
echo lines.push("Timestamp: " + report.timestamp);
echo lines.push("Status: " + report.status);
echo lines.push("Expected handlers: " + report.expectedHandlers);
echo lines.push("Registered handlers: " + report.registeredHandlers);
echo lines.push("Missing handlers: " + report.missingHandlers);
echo lines.push("");
echo lines.push("HANDLER CHECKLIST");
echo lines.push("-----------------");
echo for (const h of handlerFiles) {
echo   lines.push(`${h.registered ? "PASS" : "FAIL"} - ${h.eventType}`);
echo }
echo fs.writeFileSync(txtPath, lines.join("\n"));
echo console.log(lines.join("\n"));
echo if (report.status !== "HEALTHY") process.exit(1);
) > "%VALIDATION%\validate-handler-registry.js"

REM ------------------------------------------------------------
REM 9. CREATE LIVE MONITOR
REM ------------------------------------------------------------

(
echo @echo off
echo setlocal EnableExtensions
echo title Litigation 360 - Phase 10A Live Monitor
echo set "NODE=C:\Program Files\nodejs\node.exe"
echo if not exist "%%NODE%%" set "NODE=node"
echo :loop
echo cls
echo echo ============================================================
echo echo LITIGATION 360 - PHASE 10A LIVE MONITOR
echo echo ============================================================
echo echo Time: %%date%% %%time%%
echo echo.
echo "%%NODE%%" "%VALIDATION%\validate-handler-registry.js"
echo echo.
echo echo Refreshing every 10 seconds. Press CTRL+C to stop.
echo timeout /t 10 /nobreak ^>nul
echo goto loop
) > "%SCRIPTS%\monitor-phase-10A.bat"

REM ------------------------------------------------------------
REM 10. CREATE DOC
REM ------------------------------------------------------------

(
echo # LITIGATION 360 - PHASE 10A HANDLER REGISTRY PROTOCOL
echo.
echo ## Correct Project Root
echo %PROJECT_ROOT%
echo.
echo ## Created Paths
echo backend\src\automation
echo backend\src\automation\handlers
echo backend\src\routes\handlerRoutes.js
echo _operations\phase-10A-handler-registry
echo _operations\phase-10A-handler-registry\reports
echo _operations\phase-10A-handler-registry\scripts
echo _operations\phase-10A-handler-registry\validation
echo _operations\phase-10A-handler-registry\backups
echo.
echo ## Backend Route Mount Required
echo If active backend file is backend\src\index.js, add:
echo app.use("/api/enterprise/handlers", require("./routes/handlerRoutes"));
echo.
echo If active backend file is backend\server.js, add:
echo app.use("/api/enterprise/handlers", require("./src/routes/handlerRoutes"));
) > "%DOCS%\PHASE-10A-HANDLER-REGISTRY-PROTOCOL.md"

REM ------------------------------------------------------------
REM 11. VALIDATE
REM ------------------------------------------------------------

echo Running validation...
echo.

"%NODE%" "%VALIDATION%\validate-handler-registry.js"

if errorlevel 1 (
    echo.
    echo PHASE 10A VALIDATION FAILED.
    echo Reports:
    echo %REPORTS%
    pause
    exit /b 1
)

echo.
echo ============================================================
echo PHASE 10A DEPLOYMENT COMPLETE
echo STATUS: PASS
echo ============================================================
echo.
echo Project root:
echo %PROJECT_ROOT%
echo.
echo Reports:
echo %REPORTS%
echo.
echo Live monitor:
echo %SCRIPTS%\monitor-phase-10A.bat
echo.
echo NEXT STEP:
echo Mount the handler route in your active backend entry file.
echo.
echo For backend\src\index.js:
echo app.use("/api/enterprise/handlers", require("./routes/handlerRoutes"));
echo.
echo For backend\server.js:
echo app.use("/api/enterprise/handlers", require("./src/routes/handlerRoutes"));
echo.
pause
exit /b 0

:createHandler
set "HANDLER_NAME=%~1"
set "EVENT_NAME=%~2"

(
echo module.exports = async function %HANDLER_NAME%(payload = {}, context = {}) {
echo   return {
echo     status: "HANDLED",
echo     eventType: "%EVENT_NAME%",
echo     handler: "%HANDLER_NAME%",
echo     payloadReceived: !!payload,
echo     contextReceived: !!context,
echo     timestamp: new Date().toISOString()
echo   };
echo };
) > "%HANDLERS%\%HANDLER_NAME%.js"

exit /b 0

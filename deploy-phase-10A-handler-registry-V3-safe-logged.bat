@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM LITIGATION 360 - PHASE 10A SAFE DEPLOYMENT V3
REM Adds:
REM - Permanent log file
REM - Guaranteed pause on exit
REM - Auto-root detection
REM - Safe validation
REM - No deletion
REM ============================================================

title L360 Phase 10A Safe Deployment V3

set "DEFAULT_ROOT=C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
set "PROJECT_ROOT=%DEFAULT_ROOT%"

if not "%~1"=="" set "PROJECT_ROOT=%~1"
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
set "LOGS=%PHASE_DIR%\logs"
set "LOGFILE=%LOGS%\phase-10A-deployment-log.txt"

mkdir "%LOGS%" 2>nul

call :log "============================================================"
call :log "LITIGATION 360 - PHASE 10A SAFE DEPLOYMENT V3"
call :log "============================================================"
call :log "Project root: %PROJECT_ROOT%"
call :log "Backend: %BACKEND%"

echo.
echo ============================================================
echo LITIGATION 360 - PHASE 10A SAFE DEPLOYMENT V3
echo ============================================================
echo.
echo Project root:
echo %PROJECT_ROOT%
echo.
echo Log file:
echo %LOGFILE%
echo.

if not exist "%BACKEND%" (
    call :log "ERROR: backend folder not found."
    echo ERROR: backend folder not found.
    goto fail
)

if not exist "%BACKEND_SRC%" (
    call :log "ERROR: backend\src folder not found."
    echo ERROR: backend\src folder not found.
    goto fail
)

set "NODE=C:\Program Files\nodejs\node.exe"
if not exist "%NODE%" set "NODE=node"

call :log "Node command: %NODE%"

"%NODE%" -v >> "%LOGFILE%" 2>&1
if errorlevel 1 (
    call :log "ERROR: Node command failed."
    echo ERROR: Node command failed.
    goto fail
)

call :log "Creating folders..."

mkdir "%AUTOMATION%" 2>>"%LOGFILE%"
mkdir "%HANDLERS%" 2>>"%LOGFILE%"
mkdir "%ROUTES%" 2>>"%LOGFILE%"
mkdir "%PHASE_DIR%" 2>>"%LOGFILE%"
mkdir "%REPORTS%" 2>>"%LOGFILE%"
mkdir "%DOCS%" 2>>"%LOGFILE%"
mkdir "%SCRIPTS%" 2>>"%LOGFILE%"
mkdir "%VALIDATION%" 2>>"%LOGFILE%"
mkdir "%BACKUPS%" 2>>"%LOGFILE%"

call :log "Folders ready."

if exist "%AUTOMATION%\eventTypes.js" copy "%AUTOMATION%\eventTypes.js" "%BACKUPS%\eventTypes.backup.js" >> "%LOGFILE%" 2>&1
if exist "%AUTOMATION%\handlerRegistry.js" copy "%AUTOMATION%\handlerRegistry.js" "%BACKUPS%\handlerRegistry.backup.js" >> "%LOGFILE%" 2>&1
if exist "%ROUTES%\handlerRoutes.js" copy "%ROUTES%\handlerRoutes.js" "%BACKUPS%\handlerRoutes.backup.js" >> "%LOGFILE%" 2>&1

call :log "Writing eventTypes.js"

> "%AUTOMATION%\eventTypes.js" (
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
)

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

call :log "Writing handlerRegistry.js"

> "%AUTOMATION%\handlerRegistry.js" (
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
echo   const handler = handlerRegistry[eventType];
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
echo   getRegistryHealth,
echo   executeHandler
echo };
)

call :log "Writing handlerRoutes.js"

> "%ROUTES%\handlerRoutes.js" (
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
echo   res.json({
echo     eventType: req.params.eventType,
echo     registered: hasHandler(req.params.eventType),
echo     timestamp: new Date().toISOString()
echo   });
echo });
echo.
echo module.exports = router;
)

call :log "Writing validator"

> "%VALIDATION%\validate-handler-registry.js" (
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
echo const health = registry.getRegistryHealth();
echo const expected = Object.values(EVENT_TYPES);
echo const handlers = expected.map(eventType =^> ({
echo   eventType,
echo   registered: registry.hasHandler(eventType)
echo }));
echo.
echo const report = {
echo   phase: "10A",
echo   module: "Handler Registry",
echo   timestamp: new Date().toISOString(),
echo   ...health,
echo   handlers
echo };
echo.
echo fs.writeFileSync(path.join(reportsDir, "handler-registry-report.json"), JSON.stringify(report, null, 2));
echo.
echo const lines = [
echo   "LITIGATION 360 - PHASE 10A HANDLER REGISTRY VALIDATION",
echo   "=======================================================",
echo   "",
echo   "Timestamp: " + report.timestamp,
echo   "Status: " + report.status,
echo   "Expected handlers: " + report.expectedHandlers,
echo   "Registered handlers: " + report.registeredHandlers,
echo   "Missing handlers: " + report.missingHandlers,
echo   "",
echo   "HANDLER CHECKLIST",
echo   "-----------------",
echo   ...handlers.map(h =^> `${h.registered ? "PASS" : "FAIL"} - ${h.eventType}`)
echo ];
echo.
echo fs.writeFileSync(path.join(reportsDir, "handler-validation-report.txt"), lines.join("\n"));
echo console.log(lines.join("\n"));
echo.
echo if (report.status !== "HEALTHY") process.exit(1);
)

call :log "Writing live monitor"

> "%SCRIPTS%\monitor-phase-10A.bat" (
echo @echo off
echo setlocal EnableExtensions
echo title Litigation 360 - Phase 10A Live Monitor
echo set "ROOT=%PROJECT_ROOT%"
echo set "NODE=C:\Program Files\nodejs\node.exe"
echo if not exist "%%NODE%%" set "NODE=node"
echo :loop
echo cls
echo echo ============================================================
echo echo LITIGATION 360 - PHASE 10A LIVE MONITOR
echo echo ============================================================
echo echo Time: %%date%% %%time%%
echo echo.
echo "%%NODE%%" "%%ROOT%%\_operations\phase-10A-handler-registry\validation\validate-handler-registry.js"
echo echo.
echo echo Refreshing every 10 seconds. Press CTRL+C to stop.
echo timeout /t 10 /nobreak ^>nul
echo goto loop
)

call :log "Writing protocol document"

> "%DOCS%\PHASE-10A-HANDLER-REGISTRY-PROTOCOL.md" (
echo # LITIGATION 360 - PHASE 10A HANDLER REGISTRY PROTOCOL
echo.
echo ## Purpose
echo Create a central handler registry so no automation event is silent or untracked.
echo.
echo ## Project Root
echo %PROJECT_ROOT%
echo.
echo ## Created Paths
echo - backend\src\automation
echo - backend\src\automation\handlers
echo - backend\src\routes\handlerRoutes.js
echo - _operations\phase-10A-handler-registry\reports
echo - _operations\phase-10A-handler-registry\validation
echo - _operations\phase-10A-handler-registry\scripts
echo - _operations\phase-10A-handler-registry\logs
echo.
echo ## Manual Route Mount
echo For backend\src\index.js:
echo app.use("/api/enterprise/handlers", require("./routes/handlerRoutes"));
echo.
echo For backend\server.js:
echo app.use("/api/enterprise/handlers", require("./src/routes/handlerRoutes"));
)

call :log "Running validation"

"%NODE%" "%VALIDATION%\validate-handler-registry.js" >> "%LOGFILE%" 2>&1
if errorlevel 1 (
    call :log "ERROR: Validation failed."
    echo Validation failed. See:
    echo %LOGFILE%
    goto fail
)

echo.
echo ============================================================
echo PHASE 10A DEPLOYMENT COMPLETE
echo STATUS: PASS
echo ============================================================
echo.
echo Reports:
echo %REPORTS%
echo.
echo Log:
echo %LOGFILE%
echo.
echo Live monitor:
echo %SCRIPTS%\monitor-phase-10A.bat
echo.
call :log "PHASE 10A DEPLOYMENT COMPLETE - PASS"
goto end

:fail
echo.
echo ============================================================
echo PHASE 10A DEPLOYMENT STOPPED
echo STATUS: CHECK LOG
echo ============================================================
echo.
echo Log:
echo %LOGFILE%
echo.
call :log "PHASE 10A DEPLOYMENT STOPPED"

:end
echo.
echo Press any key to close...
pause >nul
exit /b 0

:createHandler
set "HANDLER_NAME=%~1"
set "EVENT_NAME=%~2"
call :log "Writing handler %HANDLER_NAME%.js"

> "%HANDLERS%\%HANDLER_NAME%.js" (
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
)
exit /b 0

:log
echo [%date% %time%] %~1>> "%LOGFILE%"
exit /b 0

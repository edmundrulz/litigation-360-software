param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend = Join-Path $ProjectRoot "backend"
$Src = Join-Path $Backend "src"
$Routes = Join-Path $Src "routes"
$Automation = Join-Path $Src "automation"
$Handlers = Join-Path $Automation "handlers"
$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10A-handler-registry-finisher"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Handlers,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10A-finisher-log.txt"

function Log($Text) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -LiteralPath $LogFile -Value "[$stamp] $Text"
}

function Backup-IfExists($Path) {
    if (Test-Path -LiteralPath $Path) {
        $name = Split-Path $Path -Leaf
        $dest = Join-Path $Backups ($name + "." + (Get-Date -Format "yyyyMMdd_HHmmss") + ".bak")
        Copy-Item -LiteralPath $Path -Destination $dest -Force
        Log "Backup created: $Path --> $dest"
    }
}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10A HANDLER REGISTRY FINISHER"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10A FINISHER START"
Log "Mode: $Mode"

if (!(Test-Path -LiteralPath (Join-Path $Src "index.js"))) {
    Write-Host "ERROR: backend\src\index.js not found."
    Log "ERROR: index.js missing"
    Read-Host "Press Enter to close"
    exit 1
}

$EventTypesPath = Join-Path $Automation "eventTypes.js"
$RegistryPath = Join-Path $Automation "handlerRegistry.js"
$RoutesPath = Join-Path $Routes "handlerRoutes.js"
$IndexPath = Join-Path $Src "index.js"

$handlersMap = @(
    @{file="clientCreated.js"; func="clientCreated"; event="CLIENT_CREATED"},
    @{file="matterCreated.js"; func="matterCreated"; event="MATTER_CREATED"},
    @{file="documentUploaded.js"; func="documentUploaded"; event="DOCUMENT_UPLOADED"},
    @{file="taskCompleted.js"; func="taskCompleted"; event="TASK_COMPLETED"},
    @{file="courtDateAdded.js"; func="courtDateAdded"; event="COURT_DATE_ADDED"},
    @{file="deadlineCreated.js"; func="deadlineCreated"; event="DEADLINE_CREATED"},
    @{file="paymentReceived.js"; func="paymentReceived"; event="PAYMENT_RECEIVED"},
    @{file="invoiceCreated.js"; func="invoiceCreated"; event="INVOICE_CREATED"},
    @{file="userCreated.js"; func="userCreated"; event="USER_CREATED"},
    @{file="roleChanged.js"; func="roleChanged"; event="ROLE_CHANGED"}
)

if ($Mode -eq "APPLY") {
    Backup-IfExists $EventTypesPath
    Backup-IfExists $RegistryPath
    Backup-IfExists $RoutesPath
    Backup-IfExists $IndexPath

@'
const EVENT_TYPES = {
  CLIENT_CREATED: "CLIENT_CREATED",
  MATTER_CREATED: "MATTER_CREATED",
  DOCUMENT_UPLOADED: "DOCUMENT_UPLOADED",
  TASK_COMPLETED: "TASK_COMPLETED",
  COURT_DATE_ADDED: "COURT_DATE_ADDED",
  DEADLINE_CREATED: "DEADLINE_CREATED",
  PAYMENT_RECEIVED: "PAYMENT_RECEIVED",
  INVOICE_CREATED: "INVOICE_CREATED",
  USER_CREATED: "USER_CREATED",
  ROLE_CHANGED: "ROLE_CHANGED"
};

module.exports = EVENT_TYPES;
'@ | Out-File -LiteralPath $EventTypesPath -Encoding UTF8

    foreach ($h in $handlersMap) {
        $handlerPath = Join-Path $Handlers $h.file
        Backup-IfExists $handlerPath
        @"
module.exports = async function $($h.func)(payload = {}, context = {}) {
  return {
    status: "HANDLED",
    eventType: "$($h.event)",
    handler: "$($h.func)",
    payloadReceived: !!payload,
    contextReceived: !!context,
    timestamp: new Date().toISOString()
  };
};
"@ | Out-File -LiteralPath $handlerPath -Encoding UTF8
    }

@'
const EVENT_TYPES = require("./eventTypes");

const clientCreated = require("./handlers/clientCreated");
const matterCreated = require("./handlers/matterCreated");
const documentUploaded = require("./handlers/documentUploaded");
const taskCompleted = require("./handlers/taskCompleted");
const courtDateAdded = require("./handlers/courtDateAdded");
const deadlineCreated = require("./handlers/deadlineCreated");
const paymentReceived = require("./handlers/paymentReceived");
const invoiceCreated = require("./handlers/invoiceCreated");
const userCreated = require("./handlers/userCreated");
const roleChanged = require("./handlers/roleChanged");

const handlerRegistry = {
  [EVENT_TYPES.CLIENT_CREATED]: clientCreated,
  [EVENT_TYPES.MATTER_CREATED]: matterCreated,
  [EVENT_TYPES.DOCUMENT_UPLOADED]: documentUploaded,
  [EVENT_TYPES.TASK_COMPLETED]: taskCompleted,
  [EVENT_TYPES.COURT_DATE_ADDED]: courtDateAdded,
  [EVENT_TYPES.DEADLINE_CREATED]: deadlineCreated,
  [EVENT_TYPES.PAYMENT_RECEIVED]: paymentReceived,
  [EVENT_TYPES.INVOICE_CREATED]: invoiceCreated,
  [EVENT_TYPES.USER_CREATED]: userCreated,
  [EVENT_TYPES.ROLE_CHANGED]: roleChanged
};

function getRegisteredHandlers() {
  return Object.keys(handlerRegistry);
}

function hasHandler(eventType) {
  return !!handlerRegistry[eventType];
}

function getRegistryHealth() {
  const expected = Object.values(EVENT_TYPES);
  const registered = getRegisteredHandlers();
  const missing = expected.filter(type => !registered.includes(type));

  return {
    status: missing.length === 0 ? "HEALTHY" : "WARNING",
    expectedHandlers: expected.length,
    registeredHandlers: registered.length,
    missingHandlers: missing.length,
    registered,
    missing
  };
}

async function executeHandler(eventType, payload = {}, context = {}) {
  const handler = handlerRegistry[eventType];

  if (!handler) {
    const error = new Error(`No handler registered for event type: ${eventType}`);
    error.code = "UNHANDLED_EVENT";
    throw error;
  }

  return await handler(payload, context);
}

module.exports = {
  handlerRegistry,
  getRegisteredHandlers,
  hasHandler,
  getRegistryHealth,
  executeHandler
};
'@ | Out-File -LiteralPath $RegistryPath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  getRegistryHealth,
  getRegisteredHandlers,
  hasHandler
} = require("../automation/handlerRegistry");

router.get("/health", (req, res) => {
  try {
    const health = getRegistryHealth();
    res.json({
      module: "Handler Registry",
      ...health,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    res.status(500).json({
      module: "Handler Registry",
      status: "ERROR",
      error: err.message,
      timestamp: new Date().toISOString()
    });
  }
});

router.get("/list", (req, res) => {
  res.json({
    handlers: getRegisteredHandlers(),
    timestamp: new Date().toISOString()
  });
});

router.get("/check/:eventType", (req, res) => {
  const eventType = req.params.eventType;
  res.json({
    eventType,
    registered: hasHandler(eventType),
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
'@ | Out-File -LiteralPath $RoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/handlers", require("./routes/handlerRoutes"));'

    if ($indexText -notlike '*handlerRoutes*') {
        if ($indexText -match 'app\.use\("/api/enterprise",\s*require\("\./routes/enterpriseRoutes"\)\);') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise",\s*require\("\./routes/enterpriseRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10A Handler Registry Route`r`n" + $mountLine + "`r`n"
        }
        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted handler route in index.js"
    } else {
        Log "handlerRoutes already mounted in index.js"
    }
}

# Validation stage
$validationJs = Join-Path $Validation "validate-phase10A-finisher.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10A-handler-registry-finisher", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const EVENT_TYPES = require(path.join(srcRoot, "automation", "eventTypes"));
const registry = require(path.join(srcRoot, "automation", "handlerRegistry"));

const health = registry.getRegistryHealth();
const indexPath = path.join(srcRoot, "index.js");
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10A",
  module: "Handler Registry Finisher",
  timestamp: new Date().toISOString(),
  registryHealth: health,
  routeFileExists: fs.existsSync(path.join(srcRoot, "routes", "handlerRoutes.js")),
  registryFileExists: fs.existsSync(path.join(srcRoot, "automation", "handlerRegistry.js")),
  routeMountedInIndex: indexText.includes("handlerRoutes"),
  status: (
    health.status === "HEALTHY" &&
    fs.existsSync(path.join(srcRoot, "routes", "handlerRoutes.js")) &&
    fs.existsSync(path.join(srcRoot, "automation", "handlerRegistry.js")) &&
    indexText.includes("handlerRoutes")
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10A-finisher-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10A HANDLER REGISTRY FINISHER REPORT",
  "===========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Registry Health: " + health.status,
  "Expected Handlers: " + health.expectedHandlers,
  "Registered Handlers: " + health.registeredHandlers,
  "Missing Handlers: " + health.missingHandlers,
  "Route File Exists: " + report.routeFileExists,
  "Registry File Exists: " + report.registryFileExists,
  "Route Mounted In index.js: " + report.routeMountedInIndex
];

fs.writeFileSync(path.join(reportsDir, "phase10A-finisher-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $validationJs -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $validationJs
$exit = $LASTEXITCODE

@"
# LITIGATION 360 - PHASE 10A HANDLER REGISTRY FINISHER

## Mode
$Mode

## Project Root
$ProjectRoot

## Files Controlled
- backend\src\automation\eventTypes.js
- backend\src\automation\handlerRegistry.js
- backend\src\automation\handlers\*.js
- backend\src\routes\handlerRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/handlers/health
- GET /api/enterprise/handlers/list
- GET /api/enterprise/handlers/check/:eventType

## Reports
_operations\phase-10A-handler-registry-finisher\reports

## Backups
_operations\phase-10A-handler-registry-finisher\backups

## Next Test
Start backend, then open:
http://localhost:5100/api/enterprise/handlers/health
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10A-FINISHER-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if ($exit -eq 0) {
    Write-Host "PHASE 10A FINISHER STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10A FINISHER PASS"
} else {
    Write-Host "PHASE 10A FINISHER STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10A FINISHER FAIL"
}

Read-Host "Press Enter to close"
exit $exit

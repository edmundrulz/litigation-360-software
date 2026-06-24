param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src = Join-Path $ProjectRoot "backend\src"
$Automation = Join-Path $Src "automation"
$Routes = Join-Path $Src "routes"
$IndexPath = Join-Path $Src "index.js"

$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10B-universal-event-bus"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10B-event-bus-log.txt"

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
Write-Host "LITIGATION 360 - PHASE 10B UNIVERSAL EVENT BUS"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10B EVENT BUS START"
Log "Mode: $Mode"

if (!(Test-Path -LiteralPath $IndexPath)) {
    Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
    Log "ERROR: index.js missing"
    Read-Host "Press Enter to close"
    exit 1
}

if (!(Test-Path -LiteralPath (Join-Path $Automation "handlerRegistry.js"))) {
    Write-Host "ERROR: Phase 10A handlerRegistry.js missing. Complete Phase 10A first." -ForegroundColor Red
    Log "ERROR: handlerRegistry.js missing"
    Read-Host "Press Enter to close"
    exit 1
}

$EventBusPath = Join-Path $Automation "eventBus.js"
$EventRoutesPath = Join-Path $Routes "eventBusRoutes.js"

if ($Mode -eq "APPLY") {
    Backup-IfExists $EventBusPath
    Backup-IfExists $EventRoutesPath
    Backup-IfExists $IndexPath

@'
const { executeHandler, hasHandler } = require("./handlerRegistry");

const eventStore = [];
const eventMetrics = {
  emitted: 0,
  handled: 0,
  failed: 0,
  unhandled: 0
};

function createEventRecord(eventType, payload = {}, context = {}) {
  return {
    id: `EVT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    eventType,
    payload,
    context,
    status: "CREATED",
    createdAt: new Date().toISOString(),
    handledAt: null,
    error: null
  };
}

async function emitEvent(eventType, payload = {}, context = {}) {
  const event = createEventRecord(eventType, payload, context);
  eventMetrics.emitted += 1;

  if (!hasHandler(eventType)) {
    event.status = "UNHANDLED";
    event.error = `No handler registered for event type: ${eventType}`;
    eventMetrics.unhandled += 1;
    eventStore.push(event);
    return { ok: false, status: "UNHANDLED", event };
  }

  try {
    event.status = "HANDLING";
    const result = await executeHandler(eventType, payload, { ...context, eventId: event.id });
    event.status = "HANDLED";
    event.handledAt = new Date().toISOString();
    event.result = result;
    eventMetrics.handled += 1;
    eventStore.push(event);
    return { ok: true, status: "HANDLED", event, result };
  } catch (err) {
    event.status = "FAILED";
    event.error = err.message;
    event.handledAt = new Date().toISOString();
    eventMetrics.failed += 1;
    eventStore.push(event);
    return { ok: false, status: "FAILED", event, error: err.message };
  }
}

function getRecentEvents(limit = 25) {
  return eventStore.slice(-limit).reverse();
}

function getEventMetrics() {
  return {
    ...eventMetrics,
    storedEvents: eventStore.length,
    status: eventMetrics.failed === 0 && eventMetrics.unhandled === 0 ? "HEALTHY" : "WARNING",
    timestamp: new Date().toISOString()
  };
}

function getEventBusHealth() {
  const metrics = getEventMetrics();
  return {
    module: "Universal Event Bus",
    status: metrics.status,
    emitted: metrics.emitted,
    handled: metrics.handled,
    failed: metrics.failed,
    unhandled: metrics.unhandled,
    storedEvents: metrics.storedEvents,
    timestamp: metrics.timestamp
  };
}

function resetEventBusForTestOnly() {
  eventStore.length = 0;
  eventMetrics.emitted = 0;
  eventMetrics.handled = 0;
  eventMetrics.failed = 0;
  eventMetrics.unhandled = 0;
}

module.exports = {
  emitEvent,
  getRecentEvents,
  getEventMetrics,
  getEventBusHealth,
  resetEventBusForTestOnly
};
'@ | Out-File -LiteralPath $EventBusPath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  emitEvent,
  getRecentEvents,
  getEventMetrics,
  getEventBusHealth
} = require("../automation/eventBus");

router.get("/health", (req, res) => {
  res.json(getEventBusHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getEventMetrics());
});

router.get("/recent", (req, res) => {
  const limit = Number(req.query.limit || 25);
  res.json({
    events: getRecentEvents(limit),
    timestamp: new Date().toISOString()
  });
});

router.post("/emit", async (req, res) => {
  try {
    const { eventType, payload, context } = req.body || {};
    if (!eventType) {
      return res.status(400).json({ ok: false, error: "eventType is required" });
    }
    const result = await emitEvent(eventType, payload || {}, context || {});
    res.status(result.ok ? 200 : 202).json(result);
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message, timestamp: new Date().toISOString() });
  }
});

router.get("/test/:eventType", async (req, res) => {
  const eventType = req.params.eventType;
  const result = await emitEvent(eventType, {
    source: "eventBusTestEndpoint",
    test: true
  }, {
    route: "/api/enterprise/events/test/:eventType"
  });
  res.status(result.ok ? 200 : 202).json(result);
});

module.exports = router;
'@ | Out-File -LiteralPath $EventRoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/events", require("./routes/eventBusRoutes"));'

    if ($indexText -notlike '*eventBusRoutes*') {
        if ($indexText -like '*handlerRoutes*') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise/handlers",\s*require\("\./routes/handlerRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10B Universal Event Bus Route`r`n" + $mountLine + "`r`n"
        }
        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted Event Bus route in index.js"
    } else {
        Log "eventBusRoutes already mounted in index.js"
    }
}

$ValidationJs = Join-Path $Validation "validate-phase10B-event-bus.js"

@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10B-universal-event-bus", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const indexPath = path.join(srcRoot, "index.js");
const eventBusPath = path.join(srcRoot, "automation", "eventBus.js");
const eventRoutesPath = path.join(srcRoot, "routes", "eventBusRoutes.js");

if (!fs.existsSync(eventBusPath)) {
  console.log("Event Bus file missing. Run APPLY mode.");
  process.exit(1);
}

const eventBus = require(eventBusPath);

async function run() {
  eventBus.resetEventBusForTestOnly();

  const handled = await eventBus.emitEvent("CLIENT_CREATED", { testClientName: "Phase 10B Validation Client" }, { source: "phase10BValidation" });
  const unhandled = await eventBus.emitEvent("UNKNOWN_EVENT_TYPE", { test: true }, { source: "phase10BValidation" });

  const metrics = eventBus.getEventMetrics();
  const health = eventBus.getEventBusHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10B",
    module: "Universal Event Bus",
    timestamp: new Date().toISOString(),
    files: {
      eventBusExists: fs.existsSync(eventBusPath),
      eventBusRoutesExists: fs.existsSync(eventRoutesPath),
      routeMountedInIndex: indexText.includes("eventBusRoutes")
    },
    handledTest: { ok: handled.ok, status: handled.status, eventType: handled.event.eventType },
    unhandledTest: { ok: unhandled.ok, status: unhandled.status, eventType: unhandled.event.eventType },
    metrics,
    health,
    status: (
      fs.existsSync(eventBusPath) &&
      fs.existsSync(eventRoutesPath) &&
      indexText.includes("eventBusRoutes") &&
      handled.ok === true &&
      handled.status === "HANDLED" &&
      unhandled.ok === false &&
      unhandled.status === "UNHANDLED" &&
      metrics.emitted === 2 &&
      metrics.handled === 1 &&
      metrics.unhandled === 1
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10B-event-bus-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10B UNIVERSAL EVENT BUS REPORT",
    "=====================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Event Bus File Exists: " + report.files.eventBusExists,
    "Event Routes File Exists: " + report.files.eventBusRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Handled Test: " + report.handledTest.status,
    "Unhandled Test: " + report.unhandledTest.status,
    "Metrics Emitted: " + metrics.emitted,
    "Metrics Handled: " + metrics.handled,
    "Metrics Failed: " + metrics.failed,
    "Metrics Unhandled: " + metrics.unhandled,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10B-event-bus-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10B UNIVERSAL EVENT BUS PROTOCOL

## Purpose
Create a Universal Event Bus that allows system modules to emit standardized enterprise events.

## Why
The Handler Registry knows which handlers exist. The Event Bus sends events into those handlers.

## Created Files
- backend\src\automation\eventBus.js
- backend\src\routes\eventBusRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/events/health
- GET /api/enterprise/events/metrics
- GET /api/enterprise/events/recent
- POST /api/enterprise/events/emit
- GET /api/enterprise/events/test/:eventType

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/events/health
- http://localhost:5000/api/enterprise/events/test/CLIENT_CREATED
- http://localhost:5000/api/enterprise/events/recent

## Rules
- No deletion.
- Backup before modification.
- Every phase must create reports.
- Every runtime feature must expose a health endpoint.
- Unhandled events must be visible, not silent.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10B-EVENT-BUS-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $ValidationJs
$exit = $LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if ($exit -eq 0) {
    Write-Host "PHASE 10B EVENT BUS STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10B EVENT BUS PASS"
} else {
    Write-Host "PHASE 10B EVENT BUS STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10B EVENT BUS FAIL"
}

Read-Host "Press Enter to close"
exit $exit

param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src = Join-Path $ProjectRoot "backend\src"
$Automation = Join-Path $Src "automation"
$Routes = Join-Path $Src "routes"
$IndexPath = Join-Path $Src "index.js"

$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10F-court-operations-engine"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10F-court-operations-log.txt"

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
Write-Host "LITIGATION 360 - PHASE 10F COURT OPERATIONS ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10F COURT OPERATIONS ENGINE START"
Log "Mode: $Mode"

if (!(Test-Path -LiteralPath $IndexPath)) {
    Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

foreach ($required in @("eventBus.js","notificationService.js","workflowEngine.js")) {
    if (!(Test-Path -LiteralPath (Join-Path $Automation $required))) {
        Write-Host "ERROR: Required dependency missing: $required" -ForegroundColor Red
        Read-Host "Press Enter to close"
        exit 1
    }
}

$CourtEnginePath = Join-Path $Automation "courtOperationsEngine.js"
$CourtRoutesPath = Join-Path $Routes "courtOperationsRoutes.js"

if ($Mode -eq "APPLY") {
    Backup-IfExists $CourtEnginePath
    Backup-IfExists $CourtRoutesPath
    Backup-IfExists $IndexPath

@'
const { emitEvent } = require("./eventBus");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow } = require("./workflowEngine");

const courtStore = [];
const courtTaskStore = [];

const COURT_EVENT_TYPES = {
  MENTION: "MENTION",
  HEARING: "HEARING",
  TRIAL: "TRIAL",
  CASE_MANAGEMENT: "CASE_MANAGEMENT",
  DECISION: "DECISION",
  FILING_DEADLINE: "FILING_DEADLINE",
  SUBMISSION: "SUBMISSION",
  OTHER: "OTHER"
};

const courtMetrics = {
  courtDatesCreated: 0,
  deadlinesGenerated: 0,
  remindersGenerated: 0,
  tasksGenerated: 0,
  workflowsStarted: 0,
  overdue: 0,
  upcoming: 0
};

function toDate(value) {
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    throw new Error(`Invalid date: ${value}`);
  }
  return date;
}

function addDays(date, days) {
  const next = new Date(date);
  next.setDate(next.getDate() + days);
  return next;
}

function subtractDays(date, days) {
  const next = new Date(date);
  next.setDate(next.getDate() - days);
  return next;
}

function createCourtDate({
  matterId,
  caseTitle = null,
  courtName,
  courtAddress = null,
  courtRoom = null,
  eventType = COURT_EVENT_TYPES.MENTION,
  eventDate,
  eventTime = null,
  assignedTo = null,
  notes = null,
  payload = {}
} = {}) {
  if (!matterId) throw new Error("matterId is required");
  if (!courtName) throw new Error("courtName is required");
  if (!eventDate) throw new Error("eventDate is required");

  const courtDate = toDate(eventDate);
  const normalizedEventType = Object.values(COURT_EVENT_TYPES).includes(eventType) ? eventType : COURT_EVENT_TYPES.OTHER;

  const courtEvent = {
    id: `CRT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    matterId,
    caseTitle,
    courtName,
    courtAddress,
    courtRoom,
    eventType: normalizedEventType,
    eventDate: courtDate.toISOString(),
    eventTime,
    assignedTo,
    notes,
    payload,
    status: "SCHEDULED",
    deadlines: [],
    reminders: [],
    tasks: [],
    workflowId: null,
    history: [
      {
        action: "CREATED",
        timestamp: new Date().toISOString(),
        note: "Court date created"
      }
    ],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };

  courtStore.push(courtEvent);
  courtMetrics.courtDatesCreated += 1;

  courtEvent.deadlines = generateDeadlines(courtEvent);
  courtEvent.reminders = generateReminders(courtEvent);
  courtEvent.tasks = generateCourtTasks(courtEvent);

  emitEvent("COURT_DATE_ADDED", {
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    courtName: courtEvent.courtName,
    eventType: courtEvent.eventType,
    eventDate: courtEvent.eventDate
  }, {
    module: "CourtOperationsEngine"
  });

  createNotification({
    title: `Court Date Added: ${courtEvent.courtName}`,
    message: `${courtEvent.eventType} scheduled for matter ${courtEvent.matterId}.`,
    level: "COURT",
    source: "COURT_OPERATIONS",
    eventType: "COURT_DATE_ADDED",
    matterId: courtEvent.matterId,
    payload: {
      courtEventId: courtEvent.id,
      eventDate: courtEvent.eventDate
    }
  });

  return courtEvent;
}

function generateDeadlines(courtEvent) {
  const eventDate = toDate(courtEvent.eventDate);
  const rules = [];

  if (courtEvent.eventType === COURT_EVENT_TYPES.HEARING || courtEvent.eventType === COURT_EVENT_TYPES.TRIAL) {
    rules.push({ name: "Prepare hearing bundle", daysBefore: 14 });
    rules.push({ name: "Internal review deadline", daysBefore: 7 });
    rules.push({ name: "Final preparation deadline", daysBefore: 1 });
  } else if (courtEvent.eventType === COURT_EVENT_TYPES.MENTION || courtEvent.eventType === COURT_EVENT_TYPES.CASE_MANAGEMENT) {
    rules.push({ name: "Prepare case update", daysBefore: 7 });
    rules.push({ name: "Confirm attendance and instructions", daysBefore: 1 });
  } else {
    rules.push({ name: "Prepare court event", daysBefore: 7 });
  }

  const deadlines = rules.map(rule => ({
    id: `DDL-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    name: rule.name,
    dueDate: subtractDays(eventDate, rule.daysBefore).toISOString(),
    daysBefore: rule.daysBefore,
    status: "OPEN",
    createdAt: new Date().toISOString()
  }));

  courtMetrics.deadlinesGenerated += deadlines.length;
  return deadlines;
}

function generateReminders(courtEvent) {
  const eventDate = toDate(courtEvent.eventDate);
  const reminderDays = [14, 7, 3, 1];

  const reminders = reminderDays.map(daysBefore => ({
    id: `REM-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    name: `${daysBefore} day court reminder`,
    reminderDate: subtractDays(eventDate, daysBefore).toISOString(),
    daysBefore,
    status: "PENDING",
    createdAt: new Date().toISOString()
  }));

  courtMetrics.remindersGenerated += reminders.length;
  return reminders;
}

function generateCourtTasks(courtEvent) {
  const tasks = [
    "Review court file",
    "Confirm client instructions",
    "Prepare attendance notes",
    "Prepare court bundle",
    "Update matter after court"
  ].map(name => ({
    id: `CTK-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    name,
    assignedTo: courtEvent.assignedTo,
    status: "OPEN",
    createdAt: new Date().toISOString()
  }));

  courtTaskStore.push(...tasks);
  courtMetrics.tasksGenerated += tasks.length;
  return tasks;
}

async function startCourtPreparationWorkflow(courtEventId, actor = "SYSTEM") {
  const courtEvent = getCourtEventById(courtEventId);

  if (!courtEvent) {
    return { ok: false, error: "Court event not found" };
  }

  const workflow = createWorkflow({
    workflowType: "COURT_DATE_PREPARATION",
    title: `Court Preparation: ${courtEvent.courtName}`,
    payload: {
      courtEventId: courtEvent.id,
      matterId: courtEvent.matterId,
      eventType: courtEvent.eventType,
      eventDate: courtEvent.eventDate
    },
    context: {
      source: "COURT_OPERATIONS",
      actor
    }
  });

  courtEvent.workflowId = workflow.id;
  courtEvent.history.push({
    action: "COURT_PREPARATION_WORKFLOW_STARTED",
    workflowId: workflow.id,
    actor,
    timestamp: new Date().toISOString()
  });

  courtMetrics.workflowsStarted += 1;
  await startWorkflow(workflow.id);

  createNotification({
    title: "Court Preparation Workflow Started",
    message: `Preparation workflow started for ${courtEvent.courtName}.`,
    level: "COURT",
    source: "COURT_OPERATIONS",
    eventType: "COURT_PREPARATION_WORKFLOW_STARTED",
    matterId: courtEvent.matterId,
    payload: {
      courtEventId: courtEvent.id,
      workflowId: workflow.id
    }
  });

  return {
    ok: true,
    courtEvent,
    workflow
  };
}

function getCourtEventById(id) {
  return courtStore.find(c => c.id === id) || null;
}

function getCourtEvents({ limit = 25, matterId = null, status = null, eventType = null } = {}) {
  let items = [...courtStore];

  if (matterId) items = items.filter(c => c.matterId === matterId);
  if (status) items = items.filter(c => c.status === status);
  if (eventType) items = items.filter(c => c.eventType === eventType);

  return items.slice(-limit).reverse();
}

function getUpcomingCourtEvents(days = 30) {
  const now = new Date();
  const until = addDays(now, days);

  return courtStore
    .filter(c => {
      const d = toDate(c.eventDate);
      return d >= now && d <= until;
    })
    .sort((a, b) => new Date(a.eventDate) - new Date(b.eventDate));
}

function getOverdueCourtDeadlines() {
  const now = new Date();
  const overdue = [];

  for (const courtEvent of courtStore) {
    for (const deadline of courtEvent.deadlines) {
      if (deadline.status === "OPEN" && toDate(deadline.dueDate) < now) {
        overdue.push(deadline);
      }
    }
  }

  return overdue;
}

function getCourtTasks({ limit = 25, matterId = null, status = null } = {}) {
  let items = [...courtTaskStore];

  if (matterId) items = items.filter(t => t.matterId === matterId);
  if (status) items = items.filter(t => t.status === status);

  return items.slice(-limit).reverse();
}

function getCourtOperationsMetrics() {
  const upcoming = getUpcomingCourtEvents(30).length;
  const overdue = getOverdueCourtDeadlines().length;

  courtMetrics.upcoming = upcoming;
  courtMetrics.overdue = overdue;

  return {
    ...courtMetrics,
    storedCourtEvents: courtStore.length,
    storedCourtTasks: courtTaskStore.length,
    status: overdue > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getCourtOperationsHealth() {
  const metrics = getCourtOperationsMetrics();

  return {
    module: "Court Operations Engine",
    status: metrics.status,
    courtDatesCreated: metrics.courtDatesCreated,
    deadlinesGenerated: metrics.deadlinesGenerated,
    remindersGenerated: metrics.remindersGenerated,
    tasksGenerated: metrics.tasksGenerated,
    workflowsStarted: metrics.workflowsStarted,
    upcoming: metrics.upcoming,
    overdue: metrics.overdue,
    storedCourtEvents: metrics.storedCourtEvents,
    storedCourtTasks: metrics.storedCourtTasks,
    timestamp: metrics.timestamp
  };
}

function resetCourtOperationsForTestOnly() {
  courtStore.length = 0;
  courtTaskStore.length = 0;
  courtMetrics.courtDatesCreated = 0;
  courtMetrics.deadlinesGenerated = 0;
  courtMetrics.remindersGenerated = 0;
  courtMetrics.tasksGenerated = 0;
  courtMetrics.workflowsStarted = 0;
  courtMetrics.overdue = 0;
  courtMetrics.upcoming = 0;
}

module.exports = {
  COURT_EVENT_TYPES,
  createCourtDate,
  startCourtPreparationWorkflow,
  getCourtEventById,
  getCourtEvents,
  getUpcomingCourtEvents,
  getOverdueCourtDeadlines,
  getCourtTasks,
  getCourtOperationsMetrics,
  getCourtOperationsHealth,
  resetCourtOperationsForTestOnly
};
'@ | Out-File -LiteralPath $CourtEnginePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  COURT_EVENT_TYPES,
  createCourtDate,
  startCourtPreparationWorkflow,
  getCourtEventById,
  getCourtEvents,
  getUpcomingCourtEvents,
  getOverdueCourtDeadlines,
  getCourtTasks,
  getCourtOperationsMetrics,
  getCourtOperationsHealth
} = require("../automation/courtOperationsEngine");

router.get("/health", (req, res) => {
  res.json(getCourtOperationsHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getCourtOperationsMetrics());
});

router.get("/event-types", (req, res) => {
  res.json({
    eventTypes: COURT_EVENT_TYPES,
    timestamp: new Date().toISOString()
  });
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);

  res.json({
    courtEvents: getCourtEvents({
      limit,
      matterId: req.query.matterId || null,
      status: req.query.status || null,
      eventType: req.query.eventType || null
    }),
    timestamp: new Date().toISOString()
  });
});

router.get("/upcoming", (req, res) => {
  const days = Number(req.query.days || 30);

  res.json({
    courtEvents: getUpcomingCourtEvents(days),
    days,
    timestamp: new Date().toISOString()
  });
});

router.get("/overdue-deadlines", (req, res) => {
  res.json({
    deadlines: getOverdueCourtDeadlines(),
    timestamp: new Date().toISOString()
  });
});

router.get("/tasks", (req, res) => {
  const limit = Number(req.query.limit || 25);

  res.json({
    tasks: getCourtTasks({
      limit,
      matterId: req.query.matterId || null,
      status: req.query.status || null
    }),
    timestamp: new Date().toISOString()
  });
});

router.get("/:id", (req, res) => {
  const courtEvent = getCourtEventById(req.params.id);

  if (!courtEvent) {
    return res.status(404).json({
      ok: false,
      error: "Court event not found"
    });
  }

  res.json({
    ok: true,
    courtEvent
  });
});

router.post("/create", (req, res) => {
  try {
    const courtEvent = createCourtDate(req.body || {});
    res.status(201).json({
      ok: true,
      courtEvent
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.post("/:id/start-preparation", async (req, res) => {
  const result = await startCourtPreparationWorkflow(req.params.id, req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.get("/test/court-preparation", async (req, res) => {
  const future = new Date();
  future.setDate(future.getDate() + 30);

  const courtEvent = createCourtDate({
    matterId: "MATTER-PHASE-10F-TEST",
    caseTitle: "Phase 10F Test Case",
    courtName: "Shah Alam High Court",
    courtAddress: "Shah Alam, Selangor",
    courtRoom: "Test Court Room",
    eventType: "HEARING",
    eventDate: future.toISOString(),
    eventTime: "09:00",
    assignedTo: "PHASE_10F_TEST",
    notes: "Automated test court event"
  });

  const workflowResult = await startCourtPreparationWorkflow(courtEvent.id, "PHASE_10F_TEST");

  res.json({
    ok: true,
    courtEvent: getCourtEventById(courtEvent.id),
    workflowResult
  });
});

module.exports = router;
'@ | Out-File -LiteralPath $CourtRoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/court-operations", require("./routes/courtOperationsRoutes"));'

    if ($indexText -notlike '*courtOperationsRoutes*') {
        if ($indexText -like '*documentLifecycleRoutes*') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise/documents/lifecycle",\s*require\("\./routes/documentLifecycleRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10F Court Operations Engine Route`r`n" + $mountLine + "`r`n"
        }

        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted Court Operations route in index.js"
    } else {
        Log "courtOperationsRoutes already mounted in index.js"
    }
}

$ValidationJs = Join-Path $Validation "validate-phase10F-court-operations.js"

@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10F-court-operations-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const courtPath = path.join(srcRoot, "automation", "courtOperationsEngine.js");
const courtRoutesPath = path.join(srcRoot, "routes", "courtOperationsRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(courtPath)) {
  console.log("Court Operations Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(courtPath);

async function run() {
  engine.resetCourtOperationsForTestOnly();

  const future = new Date();
  future.setDate(future.getDate() + 30);

  const courtEvent = engine.createCourtDate({
    matterId: "MATTER-VALIDATION-10F",
    caseTitle: "Phase 10F Validation Case",
    courtName: "Validation High Court",
    courtAddress: "Validation Address",
    courtRoom: "Validation Room",
    eventType: "HEARING",
    eventDate: future.toISOString(),
    eventTime: "09:00",
    assignedTo: "VALIDATION"
  });

  const workflowResult = await engine.startCourtPreparationWorkflow(courtEvent.id, "VALIDATION");
  const metrics = engine.getCourtOperationsMetrics();
  const health = engine.getCourtOperationsHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10F",
    module: "Court Operations Engine",
    timestamp: new Date().toISOString(),
    files: {
      courtOperationsEngineExists: fs.existsSync(courtPath),
      courtOperationsRoutesExists: fs.existsSync(courtRoutesPath),
      routeMountedInIndex: indexText.includes("courtOperationsRoutes")
    },
    tests: {
      courtEventCreated: !!courtEvent.id,
      deadlinesGenerated: courtEvent.deadlines.length,
      remindersGenerated: courtEvent.reminders.length,
      tasksGenerated: courtEvent.tasks.length,
      workflowStarted: workflowResult.ok === true
    },
    metrics,
    health,
    status: (
      fs.existsSync(courtPath) &&
      fs.existsSync(courtRoutesPath) &&
      indexText.includes("courtOperationsRoutes") &&
      !!courtEvent.id &&
      courtEvent.deadlines.length >= 3 &&
      courtEvent.reminders.length >= 4 &&
      courtEvent.tasks.length >= 5 &&
      workflowResult.ok === true &&
      metrics.courtDatesCreated === 1 &&
      metrics.workflowsStarted === 1 &&
      metrics.overdue === 0
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10F-court-operations-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10F COURT OPERATIONS ENGINE REPORT",
    "=========================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Court Operations Engine Exists: " + report.files.courtOperationsEngineExists,
    "Court Operations Routes Exists: " + report.files.courtOperationsRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Court Event Created: " + report.tests.courtEventCreated,
    "Deadlines Generated: " + report.tests.deadlinesGenerated,
    "Reminders Generated: " + report.tests.remindersGenerated,
    "Tasks Generated: " + report.tests.tasksGenerated,
    "Workflow Started: " + report.tests.workflowStarted,
    "Metrics Court Dates Created: " + metrics.courtDatesCreated,
    "Metrics Deadlines Generated: " + metrics.deadlinesGenerated,
    "Metrics Reminders Generated: " + metrics.remindersGenerated,
    "Metrics Tasks Generated: " + metrics.tasksGenerated,
    "Metrics Workflows Started: " + metrics.workflowsStarted,
    "Metrics Upcoming: " + metrics.upcoming,
    "Metrics Overdue: " + metrics.overdue,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10F-court-operations-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10F COURT OPERATIONS ENGINE PROTOCOL

## Purpose
Create court operations automation so court dates generate deadlines, reminders, tasks, workflows, and visible notifications.

## Why
Court dates are high-risk legal operation events. The system must not rely on memory or manual follow-up.

## Created Files
- backend\src\automation\courtOperationsEngine.js
- backend\src\routes\courtOperationsRoutes.js
- backend\src\index.js route mount

## Court Event Types
- MENTION
- HEARING
- TRIAL
- CASE_MANAGEMENT
- DECISION
- FILING_DEADLINE
- SUBMISSION
- OTHER

## API Endpoints
- GET /api/enterprise/court-operations/health
- GET /api/enterprise/court-operations/metrics
- GET /api/enterprise/court-operations/event-types
- GET /api/enterprise/court-operations/list
- GET /api/enterprise/court-operations/upcoming
- GET /api/enterprise/court-operations/overdue-deadlines
- GET /api/enterprise/court-operations/tasks
- GET /api/enterprise/court-operations/:id
- POST /api/enterprise/court-operations/create
- POST /api/enterprise/court-operations/:id/start-preparation
- GET /api/enterprise/court-operations/test/court-preparation

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/court-operations/health
- http://localhost:5000/api/enterprise/court-operations/event-types
- http://localhost:5000/api/enterprise/court-operations/test/court-preparation

## Rules
- No deletion.
- Backup before modification.
- Every court date must generate deadlines, reminders, and tasks.
- Every court preparation must be workflow-trackable.
- Overdue deadlines must be visible in health metrics.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10F-COURT-OPERATIONS-PROTOCOL.md") -Encoding UTF8

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
    Write-Host "PHASE 10F COURT OPERATIONS ENGINE STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10F COURT OPERATIONS ENGINE PASS"
} else {
    Write-Host "PHASE 10F COURT OPERATIONS ENGINE STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10F COURT OPERATIONS ENGINE FAIL"
}

Read-Host "Press Enter to close"
exit $exit

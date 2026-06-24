param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src = Join-Path $ProjectRoot "backend\src"
$Automation = Join-Path $Src "automation"
$Routes = Join-Path $Src "routes"
$IndexPath = Join-Path $Src "index.js"

$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10D-workflow-automation-engine"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10D-workflow-engine-log.txt"

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
Write-Host "LITIGATION 360 - PHASE 10D WORKFLOW AUTOMATION ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10D WORKFLOW ENGINE START"
Log "Mode: $Mode"

if (!(Test-Path -LiteralPath $IndexPath)) {
    Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

if (!(Test-Path -LiteralPath (Join-Path $Automation "eventBus.js"))) {
    Write-Host "ERROR: Phase 10B eventBus.js missing. Complete Phase 10B first." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

if (!(Test-Path -LiteralPath (Join-Path $Automation "notificationService.js"))) {
    Write-Host "ERROR: Phase 10C notificationService.js missing. Complete Phase 10C first." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

$WorkflowEnginePath = Join-Path $Automation "workflowEngine.js"
$WorkflowRoutesPath = Join-Path $Routes "workflowRoutes.js"

if ($Mode -eq "APPLY") {
    Backup-IfExists $WorkflowEnginePath
    Backup-IfExists $WorkflowRoutesPath
    Backup-IfExists $IndexPath

@'
const { emitEvent } = require("./eventBus");
const { createNotification } = require("./notificationService");

const workflowStore = [];

const workflowMetrics = {
  created: 0,
  started: 0,
  completed: 0,
  failed: 0,
  active: 0
};

const WORKFLOW_TEMPLATES = {
  NEW_CLIENT_INTAKE: {
    name: "New Client Intake",
    steps: [
      "Capture client identity",
      "Run conflict check",
      "Open client profile",
      "Create initial matter",
      "Assign responsible user",
      "Create intake notification"
    ]
  },
  MATTER_OPENING: {
    name: "Matter Opening",
    steps: [
      "Create matter record",
      "Assign matter owner",
      "Create document folder",
      "Create opening task",
      "Notify responsible team"
    ]
  },
  COURT_DATE_PREPARATION: {
    name: "Court Date Preparation",
    steps: [
      "Record court date",
      "Calculate internal reminders",
      "Create court preparation task",
      "Notify assigned user",
      "Mark preparation workflow active"
    ]
  },
  DOCUMENT_REVIEW: {
    name: "Document Review",
    steps: [
      "Receive document",
      "Assign reviewer",
      "Review document",
      "Approve or reject document",
      "Archive review trail"
    ]
  }
};

function createWorkflow({ workflowType, title, payload = {}, context = {} } = {}) {
  const template = WORKFLOW_TEMPLATES[workflowType];

  if (!template) {
    throw new Error(`Unknown workflow type: ${workflowType}`);
  }

  const workflow = {
    id: `WF-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    workflowType,
    title: title || template.name,
    status: "CREATED",
    currentStepIndex: 0,
    steps: template.steps.map((step, index) => ({
      index,
      name: step,
      status: "PENDING",
      startedAt: null,
      completedAt: null,
      error: null
    })),
    payload,
    context,
    history: [
      {
        action: "CREATED",
        timestamp: new Date().toISOString(),
        note: "Workflow created"
      }
    ],
    createdAt: new Date().toISOString(),
    startedAt: null,
    completedAt: null,
    error: null
  };

  workflowStore.push(workflow);
  workflowMetrics.created += 1;

  return workflow;
}

async function startWorkflow(workflowId) {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  if (workflow.status !== "CREATED") {
    return { ok: false, error: `Workflow cannot be started from status ${workflow.status}` };
  }

  workflow.status = "ACTIVE";
  workflow.startedAt = new Date().toISOString();
  workflowMetrics.started += 1;
  workflowMetrics.active += 1;

  workflow.history.push({
    action: "STARTED",
    timestamp: new Date().toISOString(),
    note: "Workflow started"
  });

  if (workflow.steps[0]) {
    workflow.steps[0].status = "ACTIVE";
    workflow.steps[0].startedAt = new Date().toISOString();
  }

  await emitEvent("TASK_COMPLETED", {
    source: "workflowEngine",
    workflowId: workflow.id,
    workflowType: workflow.workflowType,
    action: "WORKFLOW_STARTED"
  }, {
    module: "WorkflowEngine"
  });

  createNotification({
    title: `Workflow Started: ${workflow.title}`,
    message: `${workflow.workflowType} workflow is now active.`,
    level: "INFO",
    source: "WORKFLOW_ENGINE",
    eventType: "WORKFLOW_STARTED",
    payload: {
      workflowId: workflow.id,
      workflowType: workflow.workflowType
    }
  });

  return { ok: true, workflow };
}

async function completeCurrentStep(workflowId, note = "Step completed") {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  if (workflow.status !== "ACTIVE") {
    return { ok: false, error: `Workflow is not active. Current status: ${workflow.status}` };
  }

  const step = workflow.steps[workflow.currentStepIndex];

  if (!step) {
    return completeWorkflow(workflowId, "No remaining steps");
  }

  step.status = "COMPLETED";
  step.completedAt = new Date().toISOString();

  workflow.history.push({
    action: "STEP_COMPLETED",
    timestamp: new Date().toISOString(),
    stepIndex: step.index,
    stepName: step.name,
    note
  });

  workflow.currentStepIndex += 1;

  const nextStep = workflow.steps[workflow.currentStepIndex];

  if (nextStep) {
    nextStep.status = "ACTIVE";
    nextStep.startedAt = new Date().toISOString();

    workflow.history.push({
      action: "STEP_STARTED",
      timestamp: new Date().toISOString(),
      stepIndex: nextStep.index,
      stepName: nextStep.name
    });

    return { ok: true, status: "STEP_COMPLETED", workflow };
  }

  return completeWorkflow(workflowId, "All workflow steps completed");
}

function failWorkflow(workflowId, error = "Workflow failed") {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  workflow.status = "FAILED";
  workflow.error = error;
  workflow.completedAt = new Date().toISOString();

  workflowMetrics.failed += 1;
  workflowMetrics.active = Math.max(0, workflowMetrics.active - 1);

  workflow.history.push({
    action: "FAILED",
    timestamp: new Date().toISOString(),
    error
  });

  createNotification({
    title: `Workflow Failed: ${workflow.title}`,
    message: error,
    level: "CRITICAL",
    source: "WORKFLOW_ENGINE",
    eventType: "WORKFLOW_FAILED",
    payload: {
      workflowId: workflow.id,
      workflowType: workflow.workflowType,
      error
    }
  });

  return { ok: true, workflow };
}

function completeWorkflow(workflowId, note = "Workflow completed") {
  const workflow = getWorkflowById(workflowId);

  if (!workflow) {
    return { ok: false, error: "Workflow not found" };
  }

  workflow.status = "COMPLETED";
  workflow.completedAt = new Date().toISOString();

  workflowMetrics.completed += 1;
  workflowMetrics.active = Math.max(0, workflowMetrics.active - 1);

  workflow.history.push({
    action: "COMPLETED",
    timestamp: new Date().toISOString(),
    note
  });

  createNotification({
    title: `Workflow Completed: ${workflow.title}`,
    message: `${workflow.workflowType} workflow completed successfully.`,
    level: "INFO",
    source: "WORKFLOW_ENGINE",
    eventType: "WORKFLOW_COMPLETED",
    payload: {
      workflowId: workflow.id,
      workflowType: workflow.workflowType
    }
  });

  return { ok: true, status: "COMPLETED", workflow };
}

function getWorkflowById(workflowId) {
  return workflowStore.find(w => w.id === workflowId) || null;
}

function getWorkflows({ limit = 25, status = null, workflowType = null } = {}) {
  let items = [...workflowStore];

  if (status) {
    items = items.filter(w => w.status === status);
  }

  if (workflowType) {
    items = items.filter(w => w.workflowType === workflowType);
  }

  return items.slice(-limit).reverse();
}

function getWorkflowMetrics() {
  return {
    ...workflowMetrics,
    storedWorkflows: workflowStore.length,
    status: workflowMetrics.failed > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getWorkflowHealth() {
  const metrics = getWorkflowMetrics();

  return {
    module: "Workflow Automation Engine",
    status: metrics.status,
    created: metrics.created,
    started: metrics.started,
    active: metrics.active,
    completed: metrics.completed,
    failed: metrics.failed,
    storedWorkflows: metrics.storedWorkflows,
    timestamp: metrics.timestamp
  };
}

function getWorkflowTemplates() {
  return WORKFLOW_TEMPLATES;
}

function resetWorkflowsForTestOnly() {
  workflowStore.length = 0;
  workflowMetrics.created = 0;
  workflowMetrics.started = 0;
  workflowMetrics.completed = 0;
  workflowMetrics.failed = 0;
  workflowMetrics.active = 0;
}

module.exports = {
  createWorkflow,
  startWorkflow,
  completeCurrentStep,
  completeWorkflow,
  failWorkflow,
  getWorkflowById,
  getWorkflows,
  getWorkflowMetrics,
  getWorkflowHealth,
  getWorkflowTemplates,
  resetWorkflowsForTestOnly
};
'@ | Out-File -LiteralPath $WorkflowEnginePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  createWorkflow,
  startWorkflow,
  completeCurrentStep,
  failWorkflow,
  getWorkflowById,
  getWorkflows,
  getWorkflowMetrics,
  getWorkflowHealth,
  getWorkflowTemplates
} = require("../automation/workflowEngine");

router.get("/health", (req, res) => {
  res.json(getWorkflowHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getWorkflowMetrics());
});

router.get("/templates", (req, res) => {
  res.json({
    templates: getWorkflowTemplates(),
    timestamp: new Date().toISOString()
  });
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);
  const status = req.query.status || null;
  const workflowType = req.query.workflowType || null;

  res.json({
    workflows: getWorkflows({ limit, status, workflowType }),
    timestamp: new Date().toISOString()
  });
});

router.get("/:id", (req, res) => {
  const workflow = getWorkflowById(req.params.id);

  if (!workflow) {
    return res.status(404).json({
      ok: false,
      error: "Workflow not found"
    });
  }

  res.json({
    ok: true,
    workflow
  });
});

router.post("/create", (req, res) => {
  try {
    const workflow = createWorkflow(req.body || {});
    res.status(201).json({
      ok: true,
      workflow
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.post("/:id/start", async (req, res) => {
  const result = await startWorkflow(req.params.id);
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/complete-step", async (req, res) => {
  const result = await completeCurrentStep(req.params.id, req.body?.note || "Step completed from API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/fail", (req, res) => {
  const result = failWorkflow(req.params.id, req.body?.error || "Workflow failed from API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.get("/test/new-client-intake", async (req, res) => {
  const workflow = createWorkflow({
    workflowType: "NEW_CLIENT_INTAKE",
    title: "Phase 10D Test Client Intake",
    payload: {
      test: true,
      clientName: "Phase 10D Test Client"
    },
    context: {
      source: "PHASE_10D_TEST"
    }
  });

  await startWorkflow(workflow.id);
  await completeCurrentStep(workflow.id, "Validation step 1 completed");

  res.json({
    ok: true,
    workflow: getWorkflowById(workflow.id)
  });
});

module.exports = router;
'@ | Out-File -LiteralPath $WorkflowRoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/workflows", require("./routes/workflowRoutes"));'

    if ($indexText -notlike '*workflowRoutes*') {
        if ($indexText -like '*notificationRoutes*') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise/notifications",\s*require\("\./routes/notificationRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10D Workflow Automation Engine Route`r`n" + $mountLine + "`r`n"
        }

        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted Workflow route in index.js"
    } else {
        Log "workflowRoutes already mounted in index.js"
    }
}

$ValidationJs = Join-Path $Validation "validate-phase10D-workflow-engine.js"

@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10D-workflow-automation-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const workflowPath = path.join(srcRoot, "automation", "workflowEngine.js");
const workflowRoutesPath = path.join(srcRoot, "routes", "workflowRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(workflowPath)) {
  console.log("Workflow Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const workflowEngine = require(workflowPath);

async function run() {
  workflowEngine.resetWorkflowsForTestOnly();

  const workflow = workflowEngine.createWorkflow({
    workflowType: "NEW_CLIENT_INTAKE",
    title: "Phase 10D Validation Workflow",
    payload: { test: true },
    context: { source: "phase10DValidation" }
  });

  const startResult = await workflowEngine.startWorkflow(workflow.id);
  const stepResult = await workflowEngine.completeCurrentStep(workflow.id, "First validation step completed");
  const metrics = workflowEngine.getWorkflowMetrics();
  const health = workflowEngine.getWorkflowHealth();
  const templates = workflowEngine.getWorkflowTemplates();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10D",
    module: "Workflow Automation Engine",
    timestamp: new Date().toISOString(),
    files: {
      workflowEngineExists: fs.existsSync(workflowPath),
      workflowRoutesExists: fs.existsSync(workflowRoutesPath),
      routeMountedInIndex: indexText.includes("workflowRoutes")
    },
    tests: {
      workflowCreated: !!workflow.id,
      workflowStarted: startResult.ok === true,
      stepCompleted: stepResult.ok === true,
      templatesAvailable: Object.keys(templates).length
    },
    metrics,
    health,
    status: (
      fs.existsSync(workflowPath) &&
      fs.existsSync(workflowRoutesPath) &&
      indexText.includes("workflowRoutes") &&
      !!workflow.id &&
      startResult.ok === true &&
      stepResult.ok === true &&
      metrics.created === 1 &&
      metrics.started === 1 &&
      metrics.active === 1 &&
      Object.keys(templates).length >= 4
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10D-workflow-engine-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10D WORKFLOW AUTOMATION ENGINE REPORT",
    "============================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Workflow Engine Exists: " + report.files.workflowEngineExists,
    "Workflow Routes Exists: " + report.files.workflowRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Workflow Created: " + report.tests.workflowCreated,
    "Workflow Started: " + report.tests.workflowStarted,
    "Step Completed: " + report.tests.stepCompleted,
    "Templates Available: " + report.tests.templatesAvailable,
    "Metrics Created: " + metrics.created,
    "Metrics Started: " + metrics.started,
    "Metrics Active: " + metrics.active,
    "Metrics Completed: " + metrics.completed,
    "Metrics Failed: " + metrics.failed,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10D-workflow-engine-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10D WORKFLOW AUTOMATION ENGINE PROTOCOL

## Purpose
Create a workflow engine that tracks legal operational processes from creation to completion.

## Why
The Event Bus moves events. The Notification Framework makes alerts visible. The Workflow Engine turns operations into trackable, step-based processes.

## Created Files
- backend\src\automation\workflowEngine.js
- backend\src\routes\workflowRoutes.js
- backend\src\index.js route mount

## Workflow Templates
- NEW_CLIENT_INTAKE
- MATTER_OPENING
- COURT_DATE_PREPARATION
- DOCUMENT_REVIEW

## API Endpoints
- GET /api/enterprise/workflows/health
- GET /api/enterprise/workflows/metrics
- GET /api/enterprise/workflows/templates
- GET /api/enterprise/workflows/list
- GET /api/enterprise/workflows/:id
- POST /api/enterprise/workflows/create
- POST /api/enterprise/workflows/:id/start
- POST /api/enterprise/workflows/:id/complete-step
- POST /api/enterprise/workflows/:id/fail
- GET /api/enterprise/workflows/test/new-client-intake

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/workflows/health
- http://localhost:5000/api/enterprise/workflows/templates
- http://localhost:5000/api/enterprise/workflows/test/new-client-intake

## Rules
- No deletion.
- Backup before modification.
- Every workflow must have status, steps, history, createdAt, and payload.
- Failed workflows must create critical notifications.
- Workflow health must expose created, started, active, completed, and failed counts.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10D-WORKFLOW-ENGINE-PROTOCOL.md") -Encoding UTF8

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
    Write-Host "PHASE 10D WORKFLOW ENGINE STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10D WORKFLOW ENGINE PASS"
} else {
    Write-Host "PHASE 10D WORKFLOW ENGINE STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10D WORKFLOW ENGINE FAIL"
}

Read-Host "Press Enter to close"
exit $exit

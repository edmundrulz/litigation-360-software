param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src = Join-Path $ProjectRoot "backend\src"
$Automation = Join-Path $Src "automation"
$Routes = Join-Path $Src "routes"
$IndexPath = Join-Path $Src "index.js"

$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10E-document-lifecycle-engine"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10E-document-lifecycle-log.txt"

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
Write-Host "LITIGATION 360 - PHASE 10E DOCUMENT LIFECYCLE ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10E DOCUMENT LIFECYCLE ENGINE START"
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

if (!(Test-Path -LiteralPath (Join-Path $Automation "workflowEngine.js"))) {
    Write-Host "ERROR: Phase 10D workflowEngine.js missing. Complete Phase 10D first." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

$DocumentLifecyclePath = Join-Path $Automation "documentLifecycleEngine.js"
$DocumentLifecycleRoutesPath = Join-Path $Routes "documentLifecycleRoutes.js"

if ($Mode -eq "APPLY") {
    Backup-IfExists $DocumentLifecyclePath
    Backup-IfExists $DocumentLifecycleRoutesPath
    Backup-IfExists $IndexPath

@'
const { emitEvent } = require("./eventBus");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow } = require("./workflowEngine");

const documentStore = [];

const DOCUMENT_STATES = {
  UPLOADED: "UPLOADED",
  CLASSIFIED: "CLASSIFIED",
  ASSIGNED_TO_MATTER: "ASSIGNED_TO_MATTER",
  REVIEW: "REVIEW",
  APPROVED: "APPROVED",
  FILED: "FILED",
  ARCHIVED: "ARCHIVED",
  SUPERSEDED: "SUPERSEDED",
  REJECTED: "REJECTED"
};

const VALID_TRANSITIONS = {
  [DOCUMENT_STATES.UPLOADED]: [DOCUMENT_STATES.CLASSIFIED, DOCUMENT_STATES.REJECTED],
  [DOCUMENT_STATES.CLASSIFIED]: [DOCUMENT_STATES.ASSIGNED_TO_MATTER, DOCUMENT_STATES.REJECTED],
  [DOCUMENT_STATES.ASSIGNED_TO_MATTER]: [DOCUMENT_STATES.REVIEW, DOCUMENT_STATES.ARCHIVED],
  [DOCUMENT_STATES.REVIEW]: [DOCUMENT_STATES.APPROVED, DOCUMENT_STATES.REJECTED],
  [DOCUMENT_STATES.APPROVED]: [DOCUMENT_STATES.FILED, DOCUMENT_STATES.ARCHIVED, DOCUMENT_STATES.SUPERSEDED],
  [DOCUMENT_STATES.FILED]: [DOCUMENT_STATES.ARCHIVED, DOCUMENT_STATES.SUPERSEDED],
  [DOCUMENT_STATES.ARCHIVED]: [],
  [DOCUMENT_STATES.SUPERSEDED]: [],
  [DOCUMENT_STATES.REJECTED]: [DOCUMENT_STATES.ARCHIVED]
};

const documentMetrics = {
  created: 0,
  uploaded: 0,
  classified: 0,
  assigned: 0,
  review: 0,
  approved: 0,
  filed: 0,
  archived: 0,
  superseded: 0,
  rejected: 0,
  invalidTransitions: 0,
  orphaned: 0
};

function createDocumentRecord({
  fileName,
  documentType = "UNKNOWN",
  matterId = null,
  uploadedBy = null,
  storagePath = null,
  payload = {}
} = {}) {
  if (!fileName) {
    throw new Error("fileName is required");
  }

  const document = {
    id: `DOC-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    fileName,
    documentType,
    matterId,
    uploadedBy,
    storagePath,
    state: DOCUMENT_STATES.UPLOADED,
    payload,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    history: [
      {
        action: "CREATED",
        state: DOCUMENT_STATES.UPLOADED,
        timestamp: new Date().toISOString(),
        note: "Document record created"
      }
    ],
    reviewWorkflowId: null,
    error: null
  };

  documentStore.push(document);
  documentMetrics.created += 1;
  documentMetrics.uploaded += 1;

  emitEvent("DOCUMENT_UPLOADED", {
    documentId: document.id,
    fileName: document.fileName,
    documentType: document.documentType,
    matterId: document.matterId
  }, {
    module: "DocumentLifecycleEngine"
  });

  createNotification({
    title: `Document Uploaded: ${document.fileName}`,
    message: `Document ${document.fileName} entered lifecycle state UPLOADED.`,
    level: matterId ? "INFO" : "WARNING",
    source: "DOCUMENT_LIFECYCLE",
    eventType: "DOCUMENT_UPLOADED",
    matterId,
    payload: {
      documentId: document.id,
      state: document.state
    }
  });

  return document;
}

function transitionDocument(documentId, nextState, note = "State transition", actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  if (!DOCUMENT_STATES[nextState] && !Object.values(DOCUMENT_STATES).includes(nextState)) {
    return {
      ok: false,
      error: `Invalid document state: ${nextState}`
    };
  }

  const allowed = VALID_TRANSITIONS[document.state] || [];

  if (!allowed.includes(nextState)) {
    documentMetrics.invalidTransitions += 1;
    const error = `Invalid transition from ${document.state} to ${nextState}`;
    document.error = error;

    document.history.push({
      action: "INVALID_TRANSITION",
      from: document.state,
      to: nextState,
      actor,
      timestamp: new Date().toISOString(),
      error
    });

    createNotification({
      title: "Invalid Document Transition",
      message: error,
      level: "CRITICAL",
      source: "DOCUMENT_LIFECYCLE",
      eventType: "DOCUMENT_TRANSITION_INVALID",
      matterId: document.matterId,
      payload: {
        documentId: document.id,
        from: document.state,
        to: nextState
      }
    });

    return {
      ok: false,
      error,
      document
    };
  }

  const previousState = document.state;
  document.state = nextState;
  document.updatedAt = new Date().toISOString();
  document.error = null;

  document.history.push({
    action: "STATE_CHANGED",
    from: previousState,
    to: nextState,
    actor,
    timestamp: new Date().toISOString(),
    note
  });

  incrementStateMetric(nextState);

  emitEvent("DOCUMENT_UPLOADED", {
    documentId: document.id,
    fileName: document.fileName,
    from: previousState,
    to: nextState,
    matterId: document.matterId
  }, {
    module: "DocumentLifecycleEngine",
    action: "DOCUMENT_STATE_CHANGED"
  });

  createNotification({
    title: `Document State Updated: ${document.fileName}`,
    message: `Document moved from ${previousState} to ${nextState}.`,
    level: nextState === DOCUMENT_STATES.REJECTED ? "WARNING" : "INFO",
    source: "DOCUMENT_LIFECYCLE",
    eventType: "DOCUMENT_STATE_CHANGED",
    matterId: document.matterId,
    payload: {
      documentId: document.id,
      from: previousState,
      to: nextState
    }
  });

  return {
    ok: true,
    document
  };
}

async function startDocumentReview(documentId, actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  if (document.state !== DOCUMENT_STATES.ASSIGNED_TO_MATTER) {
    return {
      ok: false,
      error: `Document must be ASSIGNED_TO_MATTER before review. Current state: ${document.state}`
    };
  }

  const transition = transitionDocument(documentId, DOCUMENT_STATES.REVIEW, "Document review started", actor);

  if (!transition.ok) {
    return transition;
  }

  const workflow = createWorkflow({
    workflowType: "DOCUMENT_REVIEW",
    title: `Document Review: ${document.fileName}`,
    payload: {
      documentId: document.id,
      fileName: document.fileName,
      matterId: document.matterId
    },
    context: {
      source: "DOCUMENT_LIFECYCLE",
      actor
    }
  });

  document.reviewWorkflowId = workflow.id;
  await startWorkflow(workflow.id);

  document.history.push({
    action: "REVIEW_WORKFLOW_STARTED",
    workflowId: workflow.id,
    actor,
    timestamp: new Date().toISOString()
  });

  return {
    ok: true,
    document,
    workflow
  };
}

function assignDocumentToMatter(documentId, matterId, actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  if (!matterId) {
    return {
      ok: false,
      error: "matterId is required"
    };
  }

  document.matterId = matterId;
  document.history.push({
    action: "MATTER_LINKED",
    matterId,
    actor,
    timestamp: new Date().toISOString()
  });

  return transitionDocument(documentId, DOCUMENT_STATES.ASSIGNED_TO_MATTER, `Linked to matter ${matterId}`, actor);
}

function classifyDocument(documentId, documentType, actor = "SYSTEM") {
  const document = getDocumentById(documentId);

  if (!document) {
    return {
      ok: false,
      error: "Document not found"
    };
  }

  document.documentType = documentType || document.documentType;
  document.history.push({
    action: "CLASSIFIED",
    documentType: document.documentType,
    actor,
    timestamp: new Date().toISOString()
  });

  return transitionDocument(documentId, DOCUMENT_STATES.CLASSIFIED, `Classified as ${document.documentType}`, actor);
}

function getDocumentById(documentId) {
  return documentStore.find(d => d.id === documentId) || null;
}

function getDocuments({ limit = 25, state = null, matterId = null, orphanedOnly = false } = {}) {
  let items = [...documentStore];

  if (state) {
    items = items.filter(d => d.state === state);
  }

  if (matterId) {
    items = items.filter(d => d.matterId === matterId);
  }

  if (orphanedOnly) {
    items = items.filter(d => !d.matterId);
  }

  return items.slice(-limit).reverse();
}

function getOrphanedDocuments() {
  return documentStore.filter(d => !d.matterId && ![DOCUMENT_STATES.ARCHIVED, DOCUMENT_STATES.REJECTED].includes(d.state));
}

function getDocumentLifecycleMetrics() {
  const orphaned = getOrphanedDocuments().length;
  documentMetrics.orphaned = orphaned;

  return {
    ...documentMetrics,
    storedDocuments: documentStore.length,
    status: orphaned > 0 || documentMetrics.invalidTransitions > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getDocumentLifecycleHealth() {
  const metrics = getDocumentLifecycleMetrics();

  return {
    module: "Document Lifecycle Engine",
    status: metrics.status,
    created: metrics.created,
    uploaded: metrics.uploaded,
    classified: metrics.classified,
    assigned: metrics.assigned,
    review: metrics.review,
    approved: metrics.approved,
    filed: metrics.filed,
    archived: metrics.archived,
    superseded: metrics.superseded,
    rejected: metrics.rejected,
    orphaned: metrics.orphaned,
    invalidTransitions: metrics.invalidTransitions,
    storedDocuments: metrics.storedDocuments,
    timestamp: metrics.timestamp
  };
}

function incrementStateMetric(state) {
  if (state === DOCUMENT_STATES.CLASSIFIED) documentMetrics.classified += 1;
  if (state === DOCUMENT_STATES.ASSIGNED_TO_MATTER) documentMetrics.assigned += 1;
  if (state === DOCUMENT_STATES.REVIEW) documentMetrics.review += 1;
  if (state === DOCUMENT_STATES.APPROVED) documentMetrics.approved += 1;
  if (state === DOCUMENT_STATES.FILED) documentMetrics.filed += 1;
  if (state === DOCUMENT_STATES.ARCHIVED) documentMetrics.archived += 1;
  if (state === DOCUMENT_STATES.SUPERSEDED) documentMetrics.superseded += 1;
  if (state === DOCUMENT_STATES.REJECTED) documentMetrics.rejected += 1;
}

function resetDocumentLifecycleForTestOnly() {
  documentStore.length = 0;
  documentMetrics.created = 0;
  documentMetrics.uploaded = 0;
  documentMetrics.classified = 0;
  documentMetrics.assigned = 0;
  documentMetrics.review = 0;
  documentMetrics.approved = 0;
  documentMetrics.filed = 0;
  documentMetrics.archived = 0;
  documentMetrics.superseded = 0;
  documentMetrics.rejected = 0;
  documentMetrics.invalidTransitions = 0;
  documentMetrics.orphaned = 0;
}

module.exports = {
  DOCUMENT_STATES,
  createDocumentRecord,
  classifyDocument,
  assignDocumentToMatter,
  transitionDocument,
  startDocumentReview,
  getDocumentById,
  getDocuments,
  getOrphanedDocuments,
  getDocumentLifecycleMetrics,
  getDocumentLifecycleHealth,
  resetDocumentLifecycleForTestOnly
};
'@ | Out-File -LiteralPath $DocumentLifecyclePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  DOCUMENT_STATES,
  createDocumentRecord,
  classifyDocument,
  assignDocumentToMatter,
  transitionDocument,
  startDocumentReview,
  getDocumentById,
  getDocuments,
  getOrphanedDocuments,
  getDocumentLifecycleMetrics,
  getDocumentLifecycleHealth
} = require("../automation/documentLifecycleEngine");

router.get("/health", (req, res) => {
  res.json(getDocumentLifecycleHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getDocumentLifecycleMetrics());
});

router.get("/states", (req, res) => {
  res.json({
    states: DOCUMENT_STATES,
    timestamp: new Date().toISOString()
  });
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);
  const state = req.query.state || null;
  const matterId = req.query.matterId || null;
  const orphanedOnly = String(req.query.orphanedOnly || "false").toLowerCase() === "true";

  res.json({
    documents: getDocuments({ limit, state, matterId, orphanedOnly }),
    timestamp: new Date().toISOString()
  });
});

router.get("/orphaned", (req, res) => {
  res.json({
    documents: getOrphanedDocuments(),
    timestamp: new Date().toISOString()
  });
});

router.get("/:id", (req, res) => {
  const document = getDocumentById(req.params.id);

  if (!document) {
    return res.status(404).json({
      ok: false,
      error: "Document not found"
    });
  }

  res.json({
    ok: true,
    document
  });
});

router.post("/create", (req, res) => {
  try {
    const document = createDocumentRecord(req.body || {});
    res.status(201).json({
      ok: true,
      document
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.post("/:id/classify", (req, res) => {
  const result = classifyDocument(req.params.id, req.body?.documentType || "GENERAL", req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/assign", (req, res) => {
  const result = assignDocumentToMatter(req.params.id, req.body?.matterId, req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/transition", (req, res) => {
  const result = transitionDocument(
    req.params.id,
    req.body?.nextState,
    req.body?.note || "API state transition",
    req.body?.actor || "API"
  );

  res.status(result.ok ? 200 : 400).json(result);
});

router.post("/:id/start-review", async (req, res) => {
  const result = await startDocumentReview(req.params.id, req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.get("/test/document-review", async (req, res) => {
  const document = createDocumentRecord({
    fileName: "phase-10E-test-document.pdf",
    documentType: "PLEADING",
    uploadedBy: "PHASE_10E_TEST",
    payload: {
      test: true
    }
  });

  classifyDocument(document.id, "PLEADING", "PHASE_10E_TEST");
  assignDocumentToMatter(document.id, "MATTER-PHASE-10E-TEST", "PHASE_10E_TEST");
  const reviewResult = await startDocumentReview(document.id, "PHASE_10E_TEST");

  res.json({
    ok: true,
    document: getDocumentById(document.id),
    reviewResult
  });
});

module.exports = router;
'@ | Out-File -LiteralPath $DocumentLifecycleRoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/documents/lifecycle", require("./routes/documentLifecycleRoutes"));'

    if ($indexText -notlike '*documentLifecycleRoutes*') {
        if ($indexText -like '*workflowRoutes*') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise/workflows",\s*require\("\./routes/workflowRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10E Document Lifecycle Engine Route`r`n" + $mountLine + "`r`n"
        }

        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted Document Lifecycle route in index.js"
    } else {
        Log "documentLifecycleRoutes already mounted in index.js"
    }
}

$ValidationJs = Join-Path $Validation "validate-phase10E-document-lifecycle.js"

@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10E-document-lifecycle-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const lifecyclePath = path.join(srcRoot, "automation", "documentLifecycleEngine.js");
const lifecycleRoutesPath = path.join(srcRoot, "routes", "documentLifecycleRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(lifecyclePath)) {
  console.log("Document Lifecycle Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(lifecyclePath);

async function run() {
  engine.resetDocumentLifecycleForTestOnly();

  const document = engine.createDocumentRecord({
    fileName: "phase-10E-validation-document.pdf",
    documentType: "PLEADING",
    uploadedBy: "phase10EValidation"
  });

  const classify = engine.classifyDocument(document.id, "PLEADING", "VALIDATION");
  const assign = engine.assignDocumentToMatter(document.id, "MATTER-VALIDATION-10E", "VALIDATION");
  const review = await engine.startDocumentReview(document.id, "VALIDATION");
  const metrics = engine.getDocumentLifecycleMetrics();
  const health = engine.getDocumentLifecycleHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10E",
    module: "Document Lifecycle Engine",
    timestamp: new Date().toISOString(),
    files: {
      documentLifecycleEngineExists: fs.existsSync(lifecyclePath),
      documentLifecycleRoutesExists: fs.existsSync(lifecycleRoutesPath),
      routeMountedInIndex: indexText.includes("documentLifecycleRoutes")
    },
    tests: {
      documentCreated: !!document.id,
      classified: classify.ok === true,
      assigned: assign.ok === true,
      reviewStarted: review.ok === true,
      finalState: engine.getDocumentById(document.id).state
    },
    metrics,
    health,
    status: (
      fs.existsSync(lifecyclePath) &&
      fs.existsSync(lifecycleRoutesPath) &&
      indexText.includes("documentLifecycleRoutes") &&
      !!document.id &&
      classify.ok === true &&
      assign.ok === true &&
      review.ok === true &&
      engine.getDocumentById(document.id).state === "REVIEW" &&
      metrics.created === 1 &&
      metrics.classified === 1 &&
      metrics.assigned === 1 &&
      metrics.review === 1 &&
      metrics.orphaned === 0
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10E-document-lifecycle-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10E DOCUMENT LIFECYCLE ENGINE REPORT",
    "===========================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Document Lifecycle Engine Exists: " + report.files.documentLifecycleEngineExists,
    "Document Lifecycle Routes Exists: " + report.files.documentLifecycleRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Document Created: " + report.tests.documentCreated,
    "Classified: " + report.tests.classified,
    "Assigned To Matter: " + report.tests.assigned,
    "Review Started: " + report.tests.reviewStarted,
    "Final State: " + report.tests.finalState,
    "Metrics Created: " + metrics.created,
    "Metrics Classified: " + metrics.classified,
    "Metrics Assigned: " + metrics.assigned,
    "Metrics Review: " + metrics.review,
    "Metrics Orphaned: " + metrics.orphaned,
    "Invalid Transitions: " + metrics.invalidTransitions,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10E-document-lifecycle-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10E DOCUMENT LIFECYCLE ENGINE PROTOCOL

## Purpose
Create document lifecycle governance so uploaded documents are never orphaned, unreviewed, untracked, or silently superseded.

## Why
Documents are a legal-practice risk point. Every document needs matter linkage, state tracking, review history, and audit visibility.

## Created Files
- backend\src\automation\documentLifecycleEngine.js
- backend\src\routes\documentLifecycleRoutes.js
- backend\src\index.js route mount

## Lifecycle States
- UPLOADED
- CLASSIFIED
- ASSIGNED_TO_MATTER
- REVIEW
- APPROVED
- FILED
- ARCHIVED
- SUPERSEDED
- REJECTED

## API Endpoints
- GET /api/enterprise/documents/lifecycle/health
- GET /api/enterprise/documents/lifecycle/metrics
- GET /api/enterprise/documents/lifecycle/states
- GET /api/enterprise/documents/lifecycle/list
- GET /api/enterprise/documents/lifecycle/orphaned
- GET /api/enterprise/documents/lifecycle/:id
- POST /api/enterprise/documents/lifecycle/create
- POST /api/enterprise/documents/lifecycle/:id/classify
- POST /api/enterprise/documents/lifecycle/:id/assign
- POST /api/enterprise/documents/lifecycle/:id/transition
- POST /api/enterprise/documents/lifecycle/:id/start-review
- GET /api/enterprise/documents/lifecycle/test/document-review

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/documents/lifecycle/health
- http://localhost:5000/api/enterprise/documents/lifecycle/states
- http://localhost:5000/api/enterprise/documents/lifecycle/test/document-review

## Rules
- No deletion.
- Backup before modification.
- No document should remain orphaned unless intentionally rejected or archived.
- Invalid state transitions must create critical notifications.
- Review start must create a workflow.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10E-DOCUMENT-LIFECYCLE-PROTOCOL.md") -Encoding UTF8

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
    Write-Host "PHASE 10E DOCUMENT LIFECYCLE ENGINE STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10E DOCUMENT LIFECYCLE ENGINE PASS"
} else {
    Write-Host "PHASE 10E DOCUMENT LIFECYCLE ENGINE STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10E DOCUMENT LIFECYCLE ENGINE FAIL"
}

Read-Host "Press Enter to close"
exit $exit

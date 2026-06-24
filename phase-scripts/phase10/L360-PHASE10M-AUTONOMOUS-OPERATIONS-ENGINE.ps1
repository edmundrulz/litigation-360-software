param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$IndexPath=Join-Path $Src "index.js"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10M-autonomous-operations-engine"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile=Join-Path $Logs "phase-10M-autonomous-operations-log.txt"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10M AUTONOMOUS OPERATIONS ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Log "PHASE 10M START Mode=$Mode"

if(!(Test-Path -LiteralPath $IndexPath)){Write-Host "ERROR: backend\src\index.js not found" -ForegroundColor Red;Read-Host "Press Enter";exit 1}

foreach($r in @("executiveCommandCentre.js","predictiveAnalyticsEngine.js","legalOperationsAssistant.js","notificationService.js","workflowEngine.js","courtOperationsEngine.js","documentLifecycleEngine.js","matterIntelligenceEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Automation $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

$AutoPath=Join-Path $Automation "autonomousOperationsEngine.js"
$AutoRoutesPath=Join-Path $Routes "autonomousOperationsRoutes.js"

if($Mode -eq "APPLY"){
  Backup-IfExists $AutoPath
  Backup-IfExists $AutoRoutesPath
  Backup-IfExists $IndexPath

@'
const { generateExecutiveDashboard } = require("./executiveCommandCentre");
const { generatePredictiveDashboard, forecastDeadlines, forecastWorkload, forecastCapacity, forecastMatter } = require("./predictiveAnalyticsEngine");
const { generateDailyBriefing } = require("./legalOperationsAssistant");
const { createNotification } = require("./notificationService");
const { createWorkflow, startWorkflow, getWorkflows } = require("./workflowEngine");
const { getUpcomingCourtEvents, startCourtPreparationWorkflow } = require("./courtOperationsEngine");
const { getOrphanedDocuments } = require("./documentLifecycleEngine");
const { getMatterIntelligenceSummary } = require("./matterIntelligenceEngine");

const autonomousActions = [];
const escalationQueue = [];
const decisionHistory = [];

const autonomousMetrics = {
  cyclesRun: 0,
  decisionsMade: 0,
  actionsCreated: 0,
  actionsExecuted: 0,
  escalationsCreated: 0,
  notificationsCreated: 0,
  workflowsTriggered: 0,
  skippedActions: 0,
  lastRunAt: null
};

const RULES = [
  {
    id: "AUTO-COURT-7D-PREP",
    name: "Court event within 7 days requires preparation",
    severity: "HIGH",
    enabled: true,
    description: "Detects upcoming court events and recommends/prepares workflow action."
  },
  {
    id: "AUTO-DEADLINE-RISK",
    name: "Deadline risk requires triage",
    severity: "HIGH",
    enabled: true,
    description: "Detects predicted deadline failure risk and creates escalation."
  },
  {
    id: "AUTO-CAPACITY-OVERLOAD",
    name: "Capacity overload requires leadership alert",
    severity: "HIGH",
    enabled: true,
    description: "Detects capacity pressure and escalates."
  },
  {
    id: "AUTO-ORPHAN-DOCUMENTS",
    name: "Orphan documents require review",
    severity: "MEDIUM",
    enabled: true,
    description: "Detects unlinked documents and creates corrective action."
  },
  {
    id: "AUTO-FAILED-WORKFLOWS",
    name: "Failed workflows require recovery review",
    severity: "HIGH",
    enabled: true,
    description: "Detects failed workflows and creates recovery escalation."
  },
  {
    id: "AUTO-MATTER-RISK",
    name: "High-risk matter requires review",
    severity: "HIGH",
    enabled: true,
    description: "Detects matter intelligence deterioration and recommends intervention."
  }
];

function now() {
  return new Date().toISOString();
}

function createDecision({ ruleId, ruleName, severity, reason, source, data = {} }) {
  const decision = {
    id: `DEC-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    ruleId,
    ruleName,
    severity,
    reason,
    source,
    data,
    createdAt: now()
  };

  decisionHistory.push(decision);
  autonomousMetrics.decisionsMade += 1;
  return decision;
}

function createAutonomousAction({ decisionId, actionType, title, description, priority = "MEDIUM", source = "AUTONOMOUS_OPERATIONS", payload = {}, executable = false }) {
  const action = {
    id: `ACT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    decisionId,
    actionType,
    title,
    description,
    priority,
    source,
    payload,
    executable,
    status: "CREATED",
    createdAt: now(),
    executedAt: null,
    result: null
  };

  autonomousActions.push(action);
  autonomousMetrics.actionsCreated += 1;
  return action;
}

function createEscalation({ decisionId, title, message, severity = "HIGH", matterId = null, payload = {} }) {
  const escalation = {
    id: `ESC-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    decisionId,
    title,
    message,
    severity,
    matterId,
    payload,
    status: "OPEN",
    createdAt: now(),
    resolvedAt: null
  };

  escalationQueue.push(escalation);
  autonomousMetrics.escalationsCreated += 1;

  createNotification({
    title,
    message,
    level: severity === "HIGH" ? "CRITICAL" : "WARNING",
    source: "AUTONOMOUS_OPERATIONS",
    eventType: "AUTONOMOUS_ESCALATION_CREATED",
    matterId,
    payload: escalation
  });

  autonomousMetrics.notificationsCreated += 1;
  return escalation;
}

async function runAutonomousCycle({ executeSafeActions = false } = {}) {
  const executive = generateExecutiveDashboard();
  const predictive = generatePredictiveDashboard();
  const briefing = generateDailyBriefing();

  const decisions = [];
  const actions = [];
  const escalations = [];

  autonomousMetrics.cyclesRun += 1;
  autonomousMetrics.lastRunAt = now();

  const upcoming7 = getUpcomingCourtEvents(7);

  if (upcoming7.length > 0) {
    const rule = RULES.find(r => r.id === "AUTO-COURT-7D-PREP");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: `${upcoming7.length} court event(s) within 7 days.`,
      source: "COURT_OPERATIONS",
      data: { count: upcoming7.length }
    });
    decisions.push(decision);

    for (const courtEvent of upcoming7.slice(0, 5)) {
      const action = createAutonomousAction({
        decisionId: decision.id,
        actionType: "COURT_PREPARATION_WORKFLOW",
        title: `Prepare for court event: ${courtEvent.courtName}`,
        description: "Start or verify court preparation workflow.",
        priority: "HIGH",
        payload: { courtEventId: courtEvent.id, matterId: courtEvent.matterId },
        executable: true
      });
      actions.push(action);

      if (executeSafeActions) {
        try {
          const result = await startCourtPreparationWorkflow(courtEvent.id, "AUTONOMOUS_OPERATIONS");
          action.status = result.ok ? "EXECUTED" : "FAILED";
          action.executedAt = now();
          action.result = result;
          if (result.ok) {
            autonomousMetrics.actionsExecuted += 1;
            autonomousMetrics.workflowsTriggered += 1;
          }
        } catch (err) {
          action.status = "FAILED";
          action.result = { error: err.message };
        }
      } else {
        autonomousMetrics.skippedActions += 1;
      }
    }
  }

  const deadlineForecast = forecastDeadlines();
  if (deadlineForecast.predictedDeadlineFailureRisk === "HIGH") {
    const rule = RULES.find(r => r.id === "AUTO-DEADLINE-RISK");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: deadlineForecast.recommendedAction,
      source: "PREDICTIVE_ANALYTICS",
      data: deadlineForecast
    });
    decisions.push(decision);

    const escalation = createEscalation({
      decisionId: decision.id,
      title: "Autonomous Escalation: Deadline Risk",
      message: deadlineForecast.recommendedAction,
      severity: "HIGH",
      payload: deadlineForecast
    });
    escalations.push(escalation);
  }

  const capacityForecast = forecastCapacity();
  if (capacityForecast.predictedCapacityStatus === "OVERLOADED") {
    const rule = RULES.find(r => r.id === "AUTO-CAPACITY-OVERLOAD");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: capacityForecast.recommendedAction,
      source: "PREDICTIVE_ANALYTICS",
      data: capacityForecast
    });
    decisions.push(decision);

    escalations.push(createEscalation({
      decisionId: decision.id,
      title: "Autonomous Escalation: Capacity Overload",
      message: capacityForecast.recommendedAction,
      severity: "HIGH",
      payload: capacityForecast
    }));
  }

  const orphaned = getOrphanedDocuments();
  if (orphaned.length > 0) {
    const rule = RULES.find(r => r.id === "AUTO-ORPHAN-DOCUMENTS");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: `${orphaned.length} orphan document(s) detected.`,
      source: "DOCUMENT_LIFECYCLE",
      data: { count: orphaned.length }
    });
    decisions.push(decision);

    actions.push(createAutonomousAction({
      decisionId: decision.id,
      actionType: "DOCUMENT_REVIEW_ACTION",
      title: "Review orphan documents",
      description: "Link orphan documents to correct matter, reject, or archive.",
      priority: "MEDIUM",
      payload: { orphanedCount: orphaned.length },
      executable: false
    }));
  }

  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });
  if (failedWorkflows.length > 0) {
    const rule = RULES.find(r => r.id === "AUTO-FAILED-WORKFLOWS");
    const decision = createDecision({
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      reason: `${failedWorkflows.length} failed workflow(s) require recovery.`,
      source: "WORKFLOW_ENGINE",
      data: { count: failedWorkflows.length }
    });
    decisions.push(decision);

    escalations.push(createEscalation({
      decisionId: decision.id,
      title: "Autonomous Escalation: Failed Workflows",
      message: "Failed workflows require recovery review.",
      severity: "HIGH",
      payload: { failedWorkflows: failedWorkflows.map(w => w.id) }
    }));
  }

  const matterSummary = getMatterIntelligenceSummary();
  for (const profile of (matterSummary.profiles || []).slice(0, 20)) {
    const forecast = forecastMatter(profile.matterId);
    if (forecast.predictedRisk === "HIGH" || forecast.predictedRisk === "CRITICAL") {
      const rule = RULES.find(r => r.id === "AUTO-MATTER-RISK");
      const decision = createDecision({
        ruleId: rule.id,
        ruleName: rule.name,
        severity: rule.severity,
        reason: `Matter ${profile.matterId} predicted risk is ${forecast.predictedRisk}.`,
        source: "MATTER_INTELLIGENCE",
        data: forecast
      });
      decisions.push(decision);

      escalations.push(createEscalation({
        decisionId: decision.id,
        title: `Autonomous Escalation: High Risk Matter ${profile.matterId}`,
        message: forecast.recommendedAction,
        severity: forecast.predictedRisk === "CRITICAL" ? "HIGH" : "MEDIUM",
        matterId: profile.matterId,
        payload: forecast
      }));
    }
  }

  return {
    module: "Autonomous Operations Engine",
    status: escalations.length > 0 ? "ATTENTION" : "HEALTHY",
    executeSafeActions,
    decisions,
    actions,
    escalations,
    summary: {
      decisions: decisions.length,
      actions: actions.length,
      escalations: escalations.length,
      executiveStatus: executive.enterpriseStatus,
      predictiveStatus: predictive.status,
      topAssistantAction: briefing.recommendedActions?.[0] || null
    },
    generatedAt: now()
  };
}

function getAutonomousDashboard() {
  return {
    module: "Autonomous Operations Engine",
    status: escalationQueue.filter(e => e.status === "OPEN").length > 0 ? "ATTENTION" : "HEALTHY",
    metrics: getAutonomousMetrics(),
    openEscalations: getEscalations({ status: "OPEN" }),
    recentActions: getActions({ limit: 25 }),
    recentDecisions: getDecisions({ limit: 25 }),
    rules: getRules(),
    generatedAt: now()
  };
}

function getRules() {
  return RULES;
}

function getActions({ limit = 25, status = null } = {}) {
  let items = [...autonomousActions];
  if (status) items = items.filter(a => a.status === status);
  return items.slice(-limit).reverse();
}

function getEscalations({ limit = 25, status = null } = {}) {
  let items = [...escalationQueue];
  if (status) items = items.filter(e => e.status === status);
  return items.slice(-limit).reverse();
}

function getDecisions({ limit = 25 } = {}) {
  return decisionHistory.slice(-limit).reverse();
}

function resolveEscalation(escalationId, note = "Resolved") {
  const escalation = escalationQueue.find(e => e.id === escalationId);
  if (!escalation) return { ok: false, error: "Escalation not found" };

  escalation.status = "RESOLVED";
  escalation.resolvedAt = now();
  escalation.resolutionNote = note;
  return { ok: true, escalation };
}

function getAutonomousHealth() {
  const openEscalations = escalationQueue.filter(e => e.status === "OPEN").length;

  return {
    module: "Autonomous Operations Engine",
    status: openEscalations > 0 ? "ATTENTION" : "HEALTHY",
    cyclesRun: autonomousMetrics.cyclesRun,
    decisionsMade: autonomousMetrics.decisionsMade,
    actionsCreated: autonomousMetrics.actionsCreated,
    actionsExecuted: autonomousMetrics.actionsExecuted,
    escalationsCreated: autonomousMetrics.escalationsCreated,
    openEscalations,
    workflowsTriggered: autonomousMetrics.workflowsTriggered,
    lastRunAt: autonomousMetrics.lastRunAt,
    timestamp: now()
  };
}

function getAutonomousMetrics() {
  return {
    ...autonomousMetrics,
    openEscalations: escalationQueue.filter(e => e.status === "OPEN").length,
    storedActions: autonomousActions.length,
    storedEscalations: escalationQueue.length,
    storedDecisions: decisionHistory.length,
    timestamp: now()
  };
}

function resetAutonomousForTestOnly() {
  autonomousActions.length = 0;
  escalationQueue.length = 0;
  decisionHistory.length = 0;
  autonomousMetrics.cyclesRun = 0;
  autonomousMetrics.decisionsMade = 0;
  autonomousMetrics.actionsCreated = 0;
  autonomousMetrics.actionsExecuted = 0;
  autonomousMetrics.escalationsCreated = 0;
  autonomousMetrics.notificationsCreated = 0;
  autonomousMetrics.workflowsTriggered = 0;
  autonomousMetrics.skippedActions = 0;
  autonomousMetrics.lastRunAt = null;
}

module.exports = {
  runAutonomousCycle,
  getAutonomousDashboard,
  getAutonomousHealth,
  getAutonomousMetrics,
  getRules,
  getActions,
  getEscalations,
  getDecisions,
  resolveEscalation,
  resetAutonomousForTestOnly
};
'@ | Out-File -LiteralPath $AutoPath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  runAutonomousCycle,
  getAutonomousDashboard,
  getAutonomousHealth,
  getAutonomousMetrics,
  getRules,
  getActions,
  getEscalations,
  getDecisions,
  resolveEscalation
} = require("../automation/autonomousOperationsEngine");

router.get("/health", (req, res) => res.json(getAutonomousHealth()));
router.get("/metrics", (req, res) => res.json(getAutonomousMetrics()));
router.get("/dashboard", (req, res) => res.json(getAutonomousDashboard()));
router.get("/rules", (req, res) => res.json({ rules: getRules(), timestamp: new Date().toISOString() }));
router.get("/actions", (req, res) => res.json({ actions: getActions({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.get("/escalations", (req, res) => res.json({ escalations: getEscalations({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.get("/decisions", (req, res) => res.json({ decisions: getDecisions(), timestamp: new Date().toISOString() }));

router.post("/run", async (req, res) => {
  const result = await runAutonomousCycle({ executeSafeActions: !!req.body?.executeSafeActions });
  res.json(result);
});

router.get("/test/run", async (req, res) => {
  const result = await runAutonomousCycle({ executeSafeActions: false });
  res.json({ ok: true, result });
});

router.post("/escalations/:id/resolve", (req, res) => {
  const result = resolveEscalation(req.params.id, req.body?.note || "Resolved from API");
  res.status(result.ok ? 200 : 404).json(result);
});

module.exports = router;
'@ | Out-File -LiteralPath $AutoRoutesPath -Encoding UTF8

  $indexText=Get-Content -LiteralPath $IndexPath -Raw
  $mount='app.use("/api/enterprise/autonomous", require("./routes/autonomousOperationsRoutes"));'
  if($indexText -notlike '*autonomousOperationsRoutes*'){
    if($indexText -like '*mapsIntegrationRoutes*'){
      $indexText=$indexText -replace 'app\.use\("/api/enterprise/maps",\s*require\("\./routes/mapsIntegrationRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $indexText=$indexText+"`r`n// Phase 10M Autonomous Operations Engine Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
    Log "Mounted autonomous operations route"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10M-autonomous-operations.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10M-autonomous-operations-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "autonomousOperationsEngine.js");
const routePath = path.join(srcRoot, "routes", "autonomousOperationsRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Autonomous Operations Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

async function run() {
  engine.resetAutonomousForTestOnly();

  const cycle = await engine.runAutonomousCycle({ executeSafeActions: false });
  const dashboard = engine.getAutonomousDashboard();
  const health = engine.getAutonomousHealth();
  const metrics = engine.getAutonomousMetrics();
  const rules = engine.getRules();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10M",
    module: "Autonomous Operations Engine",
    timestamp: new Date().toISOString(),
    files: {
      engineExists: fs.existsSync(enginePath),
      routeExists: fs.existsSync(routePath),
      routeMountedInIndex: indexText.includes("autonomousOperationsRoutes")
    },
    tests: {
      cycleRan: !!cycle.status,
      dashboardGenerated: !!dashboard.status,
      healthGenerated: !!health.status,
      rulesAvailable: rules.length >= 6,
      metricsGenerated: typeof metrics.cyclesRun === "number"
    },
    health,
    metrics,
    status: (
      fs.existsSync(enginePath) &&
      fs.existsSync(routePath) &&
      indexText.includes("autonomousOperationsRoutes") &&
      !!cycle.status &&
      !!dashboard.status &&
      !!health.status &&
      rules.length >= 6 &&
      typeof metrics.cyclesRun === "number"
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10M-autonomous-operations-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10M AUTONOMOUS OPERATIONS ENGINE REPORT",
    "=============================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Engine Exists: " + report.files.engineExists,
    "Route Exists: " + report.files.routeExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Cycle Ran: " + report.tests.cycleRan,
    "Dashboard Generated: " + report.tests.dashboardGenerated,
    "Health Generated: " + report.tests.healthGenerated,
    "Rules Available: " + report.tests.rulesAvailable,
    "Cycles Run: " + metrics.cyclesRun,
    "Decisions Made: " + metrics.decisionsMade,
    "Actions Created: " + metrics.actionsCreated,
    "Escalations Created: " + metrics.escalationsCreated,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10M-autonomous-operations-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10M AUTONOMOUS OPERATIONS ENGINE

## Purpose
Create autonomous rules, decisions, actions, escalations, and operational cycle monitoring.

## Created Files
- backend\src\automation\autonomousOperationsEngine.js
- backend\src\routes\autonomousOperationsRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/autonomous/health
- GET /api/enterprise/autonomous/metrics
- GET /api/enterprise/autonomous/dashboard
- GET /api/enterprise/autonomous/rules
- GET /api/enterprise/autonomous/actions
- GET /api/enterprise/autonomous/escalations
- GET /api/enterprise/autonomous/decisions
- POST /api/enterprise/autonomous/run
- GET /api/enterprise/autonomous/test/run
- POST /api/enterprise/autonomous/escalations/:id/resolve

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/autonomous/health
- http://localhost:5000/api/enterprise/autonomous/rules
- http://localhost:5000/api/enterprise/autonomous/test/run

## Safety Rule
This phase is safe-by-default. It does not delete records and does not execute destructive operations.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10M-AUTONOMOUS-OPERATIONS-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $ValidationJs
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10M AUTONOMOUS OPERATIONS STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10M AUTONOMOUS OPERATIONS STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit

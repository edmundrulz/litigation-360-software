param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$IndexPath=Join-Path $Src "index.js"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10H-executive-command-centre"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"
New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile=Join-Path $Logs "phase-10H-executive-command-centre-log.txt"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10H EXECUTIVE COMMAND CENTRE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Log "PHASE 10H START Mode=$Mode"

if(!(Test-Path -LiteralPath $IndexPath)){Write-Host "ERROR: backend\src\index.js not found" -ForegroundColor Red;Read-Host "Press Enter";exit 1}
foreach($r in @("eventBus.js","notificationService.js","workflowEngine.js","documentLifecycleEngine.js","courtOperationsEngine.js","matterIntelligenceEngine.js","handlerRegistry.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Automation $r))){Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red;Read-Host "Press Enter";exit 1}
}

$EnginePath=Join-Path $Automation "executiveCommandCentre.js"
$RoutePath=Join-Path $Routes "executiveCommandRoutes.js"

if($Mode -eq "APPLY"){
  Backup-IfExists $EnginePath
  Backup-IfExists $RoutePath
  Backup-IfExists $IndexPath

@'
const { getRegistryHealth } = require("./handlerRegistry");
const { getEventBusHealth } = require("./eventBus");
const { getNotificationHealth, getNotifications } = require("./notificationService");
const { getWorkflowHealth, getWorkflows } = require("./workflowEngine");
const { getDocumentLifecycleHealth, getOrphanedDocuments } = require("./documentLifecycleEngine");
const { getCourtOperationsHealth, getUpcomingCourtEvents, getOverdueCourtDeadlines } = require("./courtOperationsEngine");
const { getMatterIntelligenceHealth, getMatterIntelligenceSummary } = require("./matterIntelligenceEngine");

const metrics = { dashboardGenerated: 0, lastGeneratedAt: null };

function weight(status) {
  const s = String(status || "").toUpperCase();
  if (s === "HEALTHY" || s === "PASS") return 100;
  if (s === "WARNING" || s === "ATTENTION") return 70;
  if (s === "HIGH_RISK") return 40;
  if (s === "FAIL" || s === "ERROR" || s === "CRITICAL") return 0;
  return 60;
}

function statusFromScore(score) {
  if (score >= 90) return "HEALTHY";
  if (score >= 70) return "ATTENTION";
  if (score >= 50) return "WARNING";
  return "CRITICAL";
}

function avgScore(modules) {
  const total = modules.reduce((sum, m) => sum + weight(m.status), 0);
  return Math.round(total / Math.max(1, modules.length));
}

function generateExecutiveDashboard() {
  const handler = getRegistryHealth();
  const eventBus = getEventBusHealth();
  const notifications = getNotificationHealth();
  const workflows = getWorkflowHealth();
  const documents = getDocumentLifecycleHealth();
  const courts = getCourtOperationsHealth();
  const matters = getMatterIntelligenceHealth();

  const moduleHealth = [
    { module: "Handler Registry", status: handler.status, details: handler },
    { module: "Universal Event Bus", status: eventBus.status, details: eventBus },
    { module: "Notification Framework", status: notifications.status, details: notifications },
    { module: "Workflow Automation Engine", status: workflows.status, details: workflows },
    { module: "Document Lifecycle Engine", status: documents.status, details: documents },
    { module: "Court Operations Engine", status: courts.status, details: courts },
    { module: "Matter Intelligence Engine", status: matters.status, details: matters }
  ];

  const enterpriseScore = avgScore(moduleHealth);
  const enterpriseStatus = statusFromScore(enterpriseScore);

  const upcomingCourtEvents = getUpcomingCourtEvents(30);
  const overdueCourtDeadlines = getOverdueCourtDeadlines();
  const orphanedDocuments = getOrphanedDocuments();
  const activeWorkflows = getWorkflows({ limit: 100, status: "ACTIVE" });
  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });
  const unreadNotifications = getNotifications({ limit: 100, unreadOnly: true });
  const criticalNotifications = getNotifications({ limit: 100, level: "CRITICAL" });
  const matterSummary = getMatterIntelligenceSummary();

  const riskItems = [];
  if (overdueCourtDeadlines.length) riskItems.push({ code: "OVERDUE_COURT_DEADLINES", severity: "HIGH", count: overdueCourtDeadlines.length, message: "Overdue court deadlines require action." });
  if (orphanedDocuments.length) riskItems.push({ code: "ORPHANED_DOCUMENTS", severity: "HIGH", count: orphanedDocuments.length, message: "Documents without matter linkage require action." });
  if (failedWorkflows.length) riskItems.push({ code: "FAILED_WORKFLOWS", severity: "HIGH", count: failedWorkflows.length, message: "Failed workflows require recovery." });
  if (criticalNotifications.length) riskItems.push({ code: "CRITICAL_NOTIFICATIONS", severity: "HIGH", count: criticalNotifications.length, message: "Critical notifications require action." });
  if (upcomingCourtEvents.length) riskItems.push({ code: "UPCOMING_COURT_EVENTS", severity: "MEDIUM", count: upcomingCourtEvents.length, message: "Court events exist within 30 days." });

  metrics.dashboardGenerated += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Executive Command Centre",
    enterpriseStatus,
    enterpriseScore,
    generatedAt: metrics.lastGeneratedAt,
    moduleHealth,
    executiveSummary: {
      upcomingCourtEvents: upcomingCourtEvents.length,
      overdueCourtDeadlines: overdueCourtDeadlines.length,
      orphanedDocuments: orphanedDocuments.length,
      activeWorkflows: activeWorkflows.length,
      failedWorkflows: failedWorkflows.length,
      unreadNotifications: unreadNotifications.length,
      criticalNotifications: criticalNotifications.length,
      matterProfiles: matterSummary.totalProfiles
    },
    riskItems,
    panels: {
      automation: { handlerRegistry: handler, eventBus },
      notifications: { health: notifications, unreadNotifications, criticalNotifications },
      workflows: { health: workflows, activeWorkflows, failedWorkflows },
      documentLifecycle: { health: documents, orphanedDocuments },
      courtOperations: { health: courts, upcomingCourtEvents, overdueCourtDeadlines },
      matters: { health: matters, summary: matterSummary }
    }
  };
}

function getExecutiveCommandHealth() {
  const dashboard = generateExecutiveDashboard();
  return {
    module: "Executive Command Centre",
    status: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    dashboardGenerated: metrics.dashboardGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    riskItems: dashboard.riskItems.length,
    timestamp: new Date().toISOString()
  };
}

function getExecutiveCommandMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = { generateExecutiveDashboard, getExecutiveCommandHealth, getExecutiveCommandMetrics };
'@ | Out-File -LiteralPath $EnginePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateExecutiveDashboard,
  getExecutiveCommandHealth,
  getExecutiveCommandMetrics
} = require("../automation/executiveCommandCentre");

router.get("/health", (req, res) => res.json(getExecutiveCommandHealth()));
router.get("/metrics", (req, res) => res.json(getExecutiveCommandMetrics()));
router.get("/dashboard", (req, res) => res.json(generateExecutiveDashboard()));
router.get("/summary", (req, res) => {
  const dashboard = generateExecutiveDashboard();
  res.json({
    module: dashboard.module,
    enterpriseStatus: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    generatedAt: dashboard.generatedAt,
    executiveSummary: dashboard.executiveSummary,
    riskItems: dashboard.riskItems
  });
});
router.get("/risk", (req, res) => {
  const dashboard = generateExecutiveDashboard();
  res.json({ riskItems: dashboard.riskItems, count: dashboard.riskItems.length, timestamp: new Date().toISOString() });
});
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: generateExecutiveDashboard() }));

module.exports = router;
'@ | Out-File -LiteralPath $RoutePath -Encoding UTF8

  $indexText=Get-Content -LiteralPath $IndexPath -Raw
  $mount='app.use("/api/enterprise/command-centre", require("./routes/executiveCommandRoutes"));'
  if($indexText -notlike '*executiveCommandRoutes*'){
    if($indexText -like '*matterIntelligenceRoutes*'){
      $indexText=$indexText -replace 'app\.use\("/api/enterprise/matters/intelligence",\s*require\("\./routes/matterIntelligenceRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $indexText=$indexText+"`r`n// Phase 10H Executive Command Centre Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
    Log "Mounted command centre route"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10H-executive-command-centre.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10H-executive-command-centre", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "executiveCommandCentre.js");
const routePath = path.join(srcRoot, "routes", "executiveCommandRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Executive Command Centre missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const dashboard = engine.generateExecutiveDashboard();
const health = engine.getExecutiveCommandHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10H",
  module: "Executive Command Centre",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("executiveCommandRoutes")
  },
  dashboard: {
    enterpriseStatus: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    moduleHealthPanels: dashboard.moduleHealth.length,
    riskItems: dashboard.riskItems.length,
    hasSummary: !!dashboard.executiveSummary,
    hasPanels: !!dashboard.panels
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("executiveCommandRoutes") &&
    !!dashboard.enterpriseStatus &&
    typeof dashboard.enterpriseScore === "number" &&
    dashboard.moduleHealth.length >= 7 &&
    !!dashboard.executiveSummary &&
    !!dashboard.panels
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10H-executive-command-centre-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10H EXECUTIVE COMMAND CENTRE REPORT",
  "==========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Enterprise Score: " + report.dashboard.enterpriseScore,
  "Enterprise Status: " + report.dashboard.enterpriseStatus,
  "Module Health Panels: " + report.dashboard.moduleHealthPanels,
  "Risk Items: " + report.dashboard.riskItems,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10H-executive-command-centre-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10H EXECUTIVE COMMAND CENTRE PROTOCOL

## Purpose
Create one executive command dashboard that summarizes health, risk, automation, court operations, workflows, documents, notifications, and matters.

## Created Files
- backend\src\automation\executiveCommandCentre.js
- backend\src\routes\executiveCommandRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/command-centre/health
- GET /api/enterprise/command-centre/metrics
- GET /api/enterprise/command-centre/dashboard
- GET /api/enterprise/command-centre/summary
- GET /api/enterprise/command-centre/risk
- GET /api/enterprise/command-centre/test/dashboard

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/command-centre/health
- http://localhost:5000/api/enterprise/command-centre/summary
- http://localhost:5000/api/enterprise/command-centre/test/dashboard

## Rules
- No deletion.
- Backup before modification.
- Critical risks must be visible.
- Dashboard must show enterprise score and module health panels.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10H-EXECUTIVE-COMMAND-CENTRE-PROTOCOL.md") -Encoding UTF8

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

if($exit -eq 0){Write-Host "PHASE 10H EXECUTIVE COMMAND CENTRE STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10H EXECUTIVE COMMAND CENTRE STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit

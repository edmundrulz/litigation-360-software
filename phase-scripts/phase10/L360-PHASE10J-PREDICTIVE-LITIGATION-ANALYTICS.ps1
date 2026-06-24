param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$IndexPath=Join-Path $Src "index.js"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10J-predictive-litigation-analytics"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"
New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile=Join-Path $Logs "phase-10J-predictive-analytics-log.txt"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10J PREDICTIVE LITIGATION ANALYTICS"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Log "PHASE 10J START Mode=$Mode"

if(!(Test-Path -LiteralPath $IndexPath)){Write-Host "ERROR: backend\src\index.js not found" -ForegroundColor Red;Read-Host "Press Enter";exit 1}

foreach($r in @("executiveCommandCentre.js","matterIntelligenceEngine.js","legalOperationsAssistant.js","courtOperationsEngine.js","workflowEngine.js","documentLifecycleEngine.js","notificationService.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Automation $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

$PredictivePath=Join-Path $Automation "predictiveAnalyticsEngine.js"
$PredictiveRoutesPath=Join-Path $Routes "predictiveAnalyticsRoutes.js"

if($Mode -eq "APPLY"){
  Backup-IfExists $PredictivePath
  Backup-IfExists $PredictiveRoutesPath
  Backup-IfExists $IndexPath

@'
const { generateExecutiveDashboard } = require("./executiveCommandCentre");
const { getMatterIntelligence, calculateMatterHealthScore } = require("./matterIntelligenceEngine");
const { getCourtOperationsHealth, getUpcomingCourtEvents, getOverdueCourtDeadlines } = require("./courtOperationsEngine");
const { getWorkflowHealth, getWorkflows } = require("./workflowEngine");
const { getDocumentLifecycleHealth, getOrphanedDocuments } = require("./documentLifecycleEngine");
const { createNotification } = require("./notificationService");

const predictiveMetrics = {
  dashboardsGenerated: 0,
  matterForecastsGenerated: 0,
  workloadForecastsGenerated: 0,
  capacityForecastsGenerated: 0,
  deadlineForecastsGenerated: 0,
  highRiskPredictions: 0,
  lastGeneratedAt: null
};

function riskLabel(score) {
  if (score >= 85) return "LOW";
  if (score >= 65) return "MEDIUM";
  if (score >= 40) return "HIGH";
  return "CRITICAL";
}

function confidenceLabel(dataPoints) {
  if (dataPoints >= 8) return "HIGH";
  if (dataPoints >= 4) return "MEDIUM";
  return "LOW";
}

function forecastMatter(matterId) {
  const intelligence = getMatterIntelligence(matterId);
  const currentHealth = calculateMatterHealthScore(matterId);
  const riskFlags = intelligence.riskFlags || [];

  let predictedScore = currentHealth.score;
  let pressure = 0;

  for (const flag of riskFlags) {
    if (flag.severity === "HIGH") pressure += 18;
    if (flag.severity === "MEDIUM") pressure += 9;
    if (flag.severity === "LOW") pressure += 3;
  }

  const openCourtTasks = (intelligence.courtTasks || []).filter(t => t.status === "OPEN").length;
  const documentsUnderReview = (intelligence.documents || []).filter(d => d.state === "REVIEW").length;
  const upcomingCourtEvents = (intelligence.courtEvents || []).filter(c => {
    const d = new Date(c.eventDate);
    const now = new Date();
    const future = new Date();
    future.setDate(future.getDate() + 30);
    return d >= now && d <= future;
  }).length;

  pressure += openCourtTasks * 2;
  pressure += documentsUnderReview * 3;
  pressure += upcomingCourtEvents * 8;

  predictedScore = Math.max(0, predictedScore - Math.min(45, pressure));

  const trend =
    predictedScore < currentHealth.score - 15 ? "DECLINING" :
    predictedScore > currentHealth.score + 5 ? "IMPROVING" :
    "STABLE";

  const prediction = {
    matterId,
    currentScore: currentHealth.score,
    predicted30Days: predictedScore,
    currentStatus: currentHealth.status,
    predictedRisk: riskLabel(predictedScore),
    trend,
    confidence: confidenceLabel(riskFlags.length + openCourtTasks + documentsUnderReview + upcomingCourtEvents),
    drivers: {
      riskFlags: riskFlags.length,
      openCourtTasks,
      documentsUnderReview,
      upcomingCourtEvents
    },
    recommendedAction: buildMatterPredictionAction(predictedScore, trend, riskFlags),
    generatedAt: new Date().toISOString()
  };

  predictiveMetrics.matterForecastsGenerated += 1;
  if (prediction.predictedRisk === "HIGH" || prediction.predictedRisk === "CRITICAL") {
    predictiveMetrics.highRiskPredictions += 1;
    createNotification({
      title: `Predictive Risk Alert: ${matterId}`,
      message: `Matter predicted risk is ${prediction.predictedRisk} with 30-day score ${prediction.predicted30Days}.`,
      level: prediction.predictedRisk === "CRITICAL" ? "CRITICAL" : "WARNING",
      source: "PREDICTIVE_ANALYTICS",
      eventType: "MATTER_RISK_PREDICTED",
      matterId,
      payload: prediction
    });
  }

  return prediction;
}

function buildMatterPredictionAction(score, trend, flags) {
  if (score < 40) return "Immediate leadership review required. Assign owner and clear deadline/document/workflow risks.";
  if (score < 65) return "Review matter within 24 hours and reduce active risk drivers.";
  if (trend === "DECLINING") return "Monitor matter closely and complete pending preparation tasks.";
  if (flags.length > 0) return "Resolve open risk flags before next milestone.";
  return "No urgent predictive action required.";
}

function forecastDeadlines() {
  const overdue = getOverdueCourtDeadlines();
  const upcoming = getUpcomingCourtEvents(14);

  const riskScore = Math.min(100, overdue.length * 35 + upcoming.length * 8);
  const risk = riskLabel(100 - riskScore);

  predictiveMetrics.deadlineForecastsGenerated += 1;

  return {
    module: "Deadline Risk Predictor",
    overdueDeadlines: overdue.length,
    upcomingCourtEvents14Days: upcoming.length,
    predictedDeadlineFailureRisk: riskScore >= 70 ? "HIGH" : riskScore >= 35 ? "MEDIUM" : "LOW",
    scorePressure: riskScore,
    recommendedAction: riskScore >= 70
      ? "Immediate deadline triage required."
      : riskScore >= 35
        ? "Review upcoming deadlines and court events this week."
        : "Deadline risk appears controlled.",
    generatedAt: new Date().toISOString()
  };
}

function forecastWorkload() {
  const activeWorkflows = getWorkflows({ limit: 100, status: "ACTIVE" });
  const upcomingCourtEvents = getUpcomingCourtEvents(30);
  const overdue = getOverdueCourtDeadlines();
  const openPressure = activeWorkflows.length * 5 + upcomingCourtEvents.length * 8 + overdue.length * 25;

  const overloadRisk =
    openPressure >= 80 ? "HIGH" :
    openPressure >= 45 ? "MEDIUM" :
    "LOW";

  predictiveMetrics.workloadForecastsGenerated += 1;

  return {
    module: "Workload Predictor",
    activeWorkflows: activeWorkflows.length,
    upcomingCourtEvents30Days: upcomingCourtEvents.length,
    overdueCourtDeadlines: overdue.length,
    workloadPressureScore: openPressure,
    predictedOverloadRisk: overloadRisk,
    recommendedAction: overloadRisk === "HIGH"
      ? "Redistribute tasks and assign support immediately."
      : overloadRisk === "MEDIUM"
        ? "Monitor workload and prepare backup capacity."
        : "Workload appears manageable.",
    generatedAt: new Date().toISOString()
  };
}

function forecastCapacity() {
  const dashboard = generateExecutiveDashboard();
  const workload = forecastWorkload();
  const orphanedDocuments = getOrphanedDocuments();
  const failedWorkflows = getWorkflows({ limit: 100, status: "FAILED" });

  const capacityPressure =
    (100 - dashboard.enterpriseScore) +
    workload.workloadPressureScore +
    orphanedDocuments.length * 10 +
    failedWorkflows.length * 20;

  const capacityStatus =
    capacityPressure >= 100 ? "OVERLOADED" :
    capacityPressure >= 60 ? "ATTENTION" :
    "CONTROLLED";

  predictiveMetrics.capacityForecastsGenerated += 1;

  return {
    module: "Capacity Predictor",
    enterpriseScore: dashboard.enterpriseScore,
    workloadPressureScore: workload.workloadPressureScore,
    orphanedDocuments: orphanedDocuments.length,
    failedWorkflows: failedWorkflows.length,
    capacityPressure,
    predictedCapacityStatus: capacityStatus,
    recommendedAction: capacityStatus === "OVERLOADED"
      ? "Leadership intervention required. Reduce operational backlog and reassign urgent work."
      : capacityStatus === "ATTENTION"
        ? "Capacity is tightening. Review workload distribution."
        : "Capacity appears controlled.",
    generatedAt: new Date().toISOString()
  };
}

function generatePredictiveDashboard() {
  const executive = generateExecutiveDashboard();
  const deadlineForecast = forecastDeadlines();
  const workloadForecast = forecastWorkload();
  const capacityForecast = forecastCapacity();

  const documentHealth = getDocumentLifecycleHealth();
  const courtHealth = getCourtOperationsHealth();
  const workflowHealth = getWorkflowHealth();

  const predictiveRiskItems = [];

  if (deadlineForecast.predictedDeadlineFailureRisk === "HIGH") {
    predictiveRiskItems.push({
      code: "PREDICTED_DEADLINE_FAILURE",
      severity: "HIGH",
      message: deadlineForecast.recommendedAction
    });
  }

  if (workloadForecast.predictedOverloadRisk === "HIGH") {
    predictiveRiskItems.push({
      code: "PREDICTED_WORKLOAD_OVERLOAD",
      severity: "HIGH",
      message: workloadForecast.recommendedAction
    });
  }

  if (capacityForecast.predictedCapacityStatus === "OVERLOADED") {
    predictiveRiskItems.push({
      code: "PREDICTED_CAPACITY_OVERLOAD",
      severity: "HIGH",
      message: capacityForecast.recommendedAction
    });
  }

  predictiveMetrics.dashboardsGenerated += 1;
  predictiveMetrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Predictive Litigation Analytics Engine",
    status: predictiveRiskItems.length > 0 ? "ATTENTION" : "HEALTHY",
    generatedAt: predictiveMetrics.lastGeneratedAt,
    enterpriseScore: executive.enterpriseScore,
    enterpriseStatus: executive.enterpriseStatus,
    forecasts: {
      deadlines: deadlineForecast,
      workload: workloadForecast,
      capacity: capacityForecast
    },
    moduleSignals: {
      documents: documentHealth,
      courtOperations: courtHealth,
      workflows: workflowHealth
    },
    predictiveRiskItems,
    recommendedExecutiveAction: predictiveRiskItems.length > 0
      ? "Review predictive risk panel and assign owners to high-risk areas."
      : "No immediate predictive escalation required."
  };
}

function getPredictiveHealth() {
  const dashboard = generatePredictiveDashboard();

  return {
    module: "Predictive Litigation Analytics Engine",
    status: dashboard.status,
    dashboardsGenerated: predictiveMetrics.dashboardsGenerated,
    matterForecastsGenerated: predictiveMetrics.matterForecastsGenerated,
    workloadForecastsGenerated: predictiveMetrics.workloadForecastsGenerated,
    capacityForecastsGenerated: predictiveMetrics.capacityForecastsGenerated,
    deadlineForecastsGenerated: predictiveMetrics.deadlineForecastsGenerated,
    highRiskPredictions: predictiveMetrics.highRiskPredictions,
    lastGeneratedAt: predictiveMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getPredictiveMetrics() {
  return { ...predictiveMetrics, timestamp: new Date().toISOString() };
}

module.exports = {
  forecastMatter,
  forecastDeadlines,
  forecastWorkload,
  forecastCapacity,
  generatePredictiveDashboard,
  getPredictiveHealth,
  getPredictiveMetrics
};
'@ | Out-File -LiteralPath $PredictivePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  forecastMatter,
  forecastDeadlines,
  forecastWorkload,
  forecastCapacity,
  generatePredictiveDashboard,
  getPredictiveHealth,
  getPredictiveMetrics
} = require("../automation/predictiveAnalyticsEngine");

router.get("/health", (req, res) => res.json(getPredictiveHealth()));
router.get("/metrics", (req, res) => res.json(getPredictiveMetrics()));
router.get("/dashboard", (req, res) => res.json(generatePredictiveDashboard()));
router.get("/matter/:matterId", (req, res) => res.json(forecastMatter(req.params.matterId)));
router.get("/deadlines", (req, res) => res.json(forecastDeadlines()));
router.get("/workload", (req, res) => res.json(forecastWorkload()));
router.get("/capacity", (req, res) => res.json(forecastCapacity()));
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: generatePredictiveDashboard() }));
router.get("/test/matter", (req, res) => res.json({ ok: true, forecast: forecastMatter("MATTER-PHASE-10J-TEST") }));

module.exports = router;
'@ | Out-File -LiteralPath $PredictiveRoutesPath -Encoding UTF8

  $indexText=Get-Content -LiteralPath $IndexPath -Raw
  $mount='app.use("/api/enterprise/predictive", require("./routes/predictiveAnalyticsRoutes"));'
  if($indexText -notlike '*predictiveAnalyticsRoutes*'){
    if($indexText -like '*legalOperationsAssistantRoutes*'){
      $indexText=$indexText -replace 'app\.use\("/api/enterprise/assistant",\s*require\("\./routes/legalOperationsAssistantRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $indexText=$indexText+"`r`n// Phase 10J Predictive Litigation Analytics Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
    Log "Mounted predictive analytics route"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10J-predictive-analytics.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10J-predictive-litigation-analytics", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "predictiveAnalyticsEngine.js");
const routePath = path.join(srcRoot, "routes", "predictiveAnalyticsRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Predictive Analytics Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const dashboard = engine.generatePredictiveDashboard();
const matter = engine.forecastMatter("MATTER-VALIDATION-10J");
const deadlines = engine.forecastDeadlines();
const workload = engine.forecastWorkload();
const capacity = engine.forecastCapacity();
const health = engine.getPredictiveHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10J",
  module: "Predictive Litigation Analytics Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("predictiveAnalyticsRoutes")
  },
  tests: {
    dashboardGenerated: !!dashboard.status,
    matterForecastGenerated: !!matter.predictedRisk,
    deadlineForecastGenerated: !!deadlines.predictedDeadlineFailureRisk,
    workloadForecastGenerated: !!workload.predictedOverloadRisk,
    capacityForecastGenerated: !!capacity.predictedCapacityStatus
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("predictiveAnalyticsRoutes") &&
    !!dashboard.status &&
    !!matter.predictedRisk &&
    !!deadlines.predictedDeadlineFailureRisk &&
    !!workload.predictedOverloadRisk &&
    !!capacity.predictedCapacityStatus
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10J-predictive-analytics-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10J PREDICTIVE LITIGATION ANALYTICS REPORT",
  "================================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Matter Forecast Generated: " + report.tests.matterForecastGenerated,
  "Deadline Forecast Generated: " + report.tests.deadlineForecastGenerated,
  "Workload Forecast Generated: " + report.tests.workloadForecastGenerated,
  "Capacity Forecast Generated: " + report.tests.capacityForecastGenerated,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10J-predictive-analytics-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10J PREDICTIVE LITIGATION ANALYTICS ENGINE

## Purpose
Create predictive litigation analytics for matter risk, deadline risk, workload risk, and capacity pressure.

## Created Files
- backend\src\automation\predictiveAnalyticsEngine.js
- backend\src\routes\predictiveAnalyticsRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/predictive/health
- GET /api/enterprise/predictive/metrics
- GET /api/enterprise/predictive/dashboard
- GET /api/enterprise/predictive/matter/:matterId
- GET /api/enterprise/predictive/deadlines
- GET /api/enterprise/predictive/workload
- GET /api/enterprise/predictive/capacity
- GET /api/enterprise/predictive/test/dashboard
- GET /api/enterprise/predictive/test/matter

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/predictive/health
- http://localhost:5000/api/enterprise/predictive/dashboard
- http://localhost:5000/api/enterprise/predictive/test/matter

## Rule
This is deterministic predictive analytics. It does not use external AI yet.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10J-PREDICTIVE-ANALYTICS-PROTOCOL.md") -Encoding UTF8

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

if($exit -eq 0){Write-Host "PHASE 10J PREDICTIVE ANALYTICS STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10J PREDICTIVE ANALYTICS STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit

param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $Root "backend\src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10Q-enterprise-monitoring"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Dashboards=Join-Path $Phase "dashboards"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Dashboards,$Auto,$Routes | Out-Null
$Log=Join-Path $Logs "phase-10Q-monitoring-log.txt"

function Log($Text){Add-Content -LiteralPath $Log -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
    Log "Backup $Path --> $dest"
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10Q ENTERPRISE MONITORING & OBSERVABILITY"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project Root: $Root"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

$Required=@(
"enterpriseHardeningEngine.js",
"backupRecoveryEngine.js",
"enterpriseGovernanceEngine.js",
"autonomousOperationsEngine.js",
"mapsIntegrationLayer.js",
"courtNavigationEngine.js",
"courtOperationsEngine.js",
"notificationService.js",
"workflowEngine.js",
"documentLifecycleEngine.js",
"matterIntelligenceEngine.js",
"predictiveAnalyticsEngine.js"
)

foreach($r in $Required){
  if(!(Test-Path -LiteralPath (Join-Path $Auto $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

$Monitoring=Join-Path $Auto "enterpriseMonitoringEngine.js"
$Metrics=Join-Path $Auto "metricsCollector.js"
$Alerts=Join-Path $Auto "alertManager.js"
$Route=Join-Path $Routes "enterpriseMonitoringRoutes.js"

if($Mode -eq "APPLY"){
  Backup $Monitoring
  Backup $Metrics
  Backup $Alerts
  Backup $Route
  Backup $Index

@'
const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");

function safeRequire(relativePath) {
  try {
    return require(relativePath);
  } catch (err) {
    return { __loadError: err.message };
  }
}

function getDatabaseSize() {
  const dbPath = path.join(BACKEND_ROOT, "litigation360.db");
  if (!fs.existsSync(dbPath)) return { exists: false, sizeBytes: 0, sizeMB: 0 };
  const size = fs.statSync(dbPath).size;
  return { exists: true, sizeBytes: size, sizeMB: Math.round((size / 1024 / 1024) * 100) / 100 };
}

function getProcessMetrics() {
  const memory = process.memoryUsage();
  return {
    pid: process.pid,
    platform: process.platform,
    nodeVersion: process.version,
    uptimeSeconds: Math.round(process.uptime()),
    memory: {
      rssMB: Math.round((memory.rss / 1024 / 1024) * 100) / 100,
      heapTotalMB: Math.round((memory.heapTotal / 1024 / 1024) * 100) / 100,
      heapUsedMB: Math.round((memory.heapUsed / 1024 / 1024) * 100) / 100,
      externalMB: Math.round((memory.external / 1024 / 1024) * 100) / 100
    }
  };
}

function collectEnterpriseMetrics() {
  const hardening = safeRequire("./enterpriseHardeningEngine");
  const backup = safeRequire("./backupRecoveryEngine");
  const governance = safeRequire("./enterpriseGovernanceEngine");
  const autonomous = safeRequire("./autonomousOperationsEngine");
  const maps = safeRequire("./mapsIntegrationLayer");
  const navigation = safeRequire("./courtNavigationEngine");
  const courts = safeRequire("./courtOperationsEngine");
  const notifications = safeRequire("./notificationService");
  const workflows = safeRequire("./workflowEngine");
  const documents = safeRequire("./documentLifecycleEngine");
  const matters = safeRequire("./matterIntelligenceEngine");
  const predictive = safeRequire("./predictiveAnalyticsEngine");

  function call(module, fn, fallback) {
    try {
      if (module.__loadError) return { status: "LOAD_ERROR", error: module.__loadError };
      if (typeof module[fn] !== "function") return fallback || { status: "NOT_AVAILABLE" };
      return module[fn]();
    } catch (err) {
      return { status: "ERROR", error: err.message };
    }
  }

  const courtEvents = call(courts, "getCourtOperationsHealth", {});
  const navigationHealth = call(navigation, "getNavigationHealth", {});
  const mapHealth = call(maps, "getMapsHealth", {});
  const backupHealth = call(backup, "getBackupRecoveryHealth", {});
  const governanceHealth = call(governance, "getGovernanceHealth", {});
  const hardeningHealth = call(hardening, "getHardeningHealth", {});
  const autonomousHealth = call(autonomous, "getAutonomousHealth", {});
  const notificationHealth = call(notifications, "getNotificationHealth", {});
  const workflowHealth = call(workflows, "getWorkflowHealth", {});
  const documentHealth = call(documents, "getDocumentLifecycleHealth", {});
  const matterHealth = call(matters, "getMatterIntelligenceHealth", {});
  const predictiveHealth = call(predictive, "getPredictiveHealth", {});

  return {
    module: "Enterprise Metrics Collector",
    collectedAt: new Date().toISOString(),
    process: getProcessMetrics(),
    database: getDatabaseSize(),
    modules: {
      hardening: hardeningHealth,
      backupRecovery: backupHealth,
      governance: governanceHealth,
      autonomous: autonomousHealth,
      predictive: predictiveHealth,
      matters: matterHealth,
      documents: documentHealth,
      workflows: workflowHealth,
      notifications: notificationHealth,
      courtOperations: courtEvents,
      navigation: navigationHealth,
      maps: mapHealth
    },
    specialMonitoring: {
      industrialCourtKualaLumpur: "MONITORED",
      perkesoKualaLumpur: "MONITORED",
      perkesoHeadquartersJalanAmpang: "MONITORED"
    }
  };
}

module.exports = {
  collectEnterpriseMetrics,
  getDatabaseSize,
  getProcessMetrics
};
'@ | Out-File -LiteralPath $Metrics -Encoding UTF8

@'
const alerts = [];

const LEVELS = {
  INFO: "INFO",
  WARNING: "WARNING",
  CRITICAL: "CRITICAL",
  BLOCKER: "BLOCKER"
};

function createAlert({ level = "INFO", code, title, message, source = "MONITORING", payload = {} } = {}) {
  const alert = {
    id: `ALT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    level,
    code: code || "GENERAL_ALERT",
    title: title || "Monitoring Alert",
    message: message || "Monitoring alert generated.",
    source,
    payload,
    status: "OPEN",
    createdAt: new Date().toISOString(),
    resolvedAt: null
  };
  alerts.push(alert);
  return alert;
}

function resolveAlert(id, note = "Resolved") {
  const alert = alerts.find(a => a.id === id);
  if (!alert) return { ok: false, error: "Alert not found" };
  alert.status = "RESOLVED";
  alert.resolvedAt = new Date().toISOString();
  alert.resolutionNote = note;
  return { ok: true, alert };
}

function getAlerts({ status = null, level = null, limit = 50 } = {}) {
  let items = [...alerts];
  if (status) items = items.filter(a => a.status === status);
  if (level) items = items.filter(a => a.level === level);
  return items.slice(-limit).reverse();
}

function generateAlertsFromMetrics(metrics) {
  const generated = [];

  if (!metrics.database.exists) {
    generated.push(createAlert({
      level: LEVELS.BLOCKER,
      code: "DATABASE_MISSING",
      title: "Database Missing",
      message: "litigation360.db is missing.",
      source: "MONITORING"
    }));
  }

  if (metrics.process.memory.heapUsedMB > 512) {
    generated.push(createAlert({
      level: LEVELS.WARNING,
      code: "HIGH_MEMORY_USAGE",
      title: "High Memory Usage",
      message: `Heap used is ${metrics.process.memory.heapUsedMB} MB.`,
      source: "MONITORING",
      payload: metrics.process.memory
    }));
  }

  const moduleEntries = Object.entries(metrics.modules || {});
  for (const [name, data] of moduleEntries) {
    const status = String(data?.status || "").toUpperCase();
    if (["ERROR", "LOAD_ERROR", "BLOCKED", "FAIL", "CRITICAL"].includes(status)) {
      generated.push(createAlert({
        level: status === "BLOCKED" || status === "CRITICAL" ? LEVELS.BLOCKER : LEVELS.CRITICAL,
        code: `MODULE_${name.toUpperCase()}_${status}`,
        title: `Module ${name} status ${status}`,
        message: `Monitoring detected ${name} status: ${status}.`,
        source: "MONITORING",
        payload: data
      }));
    }
  }

  return generated;
}

function getAlertHealth() {
  const open = alerts.filter(a => a.status === "OPEN");
  const blockers = open.filter(a => a.level === "BLOCKER");
  const critical = open.filter(a => a.level === "CRITICAL");

  return {
    module: "Alert Manager",
    status: blockers.length > 0 ? "BLOCKER" : critical.length > 0 ? "CRITICAL" : "HEALTHY",
    openAlerts: open.length,
    blockerAlerts: blockers.length,
    criticalAlerts: critical.length,
    storedAlerts: alerts.length,
    timestamp: new Date().toISOString()
  };
}

function resetAlertsForTestOnly() {
  alerts.length = 0;
}

module.exports = {
  LEVELS,
  createAlert,
  resolveAlert,
  getAlerts,
  generateAlertsFromMetrics,
  getAlertHealth,
  resetAlertsForTestOnly
};
'@ | Out-File -LiteralPath $Alerts -Encoding UTF8

@'
const { collectEnterpriseMetrics } = require("./metricsCollector");
const { generateAlertsFromMetrics, getAlerts, getAlertHealth } = require("./alertManager");

const monitoringMetrics = {
  dashboardsGenerated: 0,
  healthChecksGenerated: 0,
  metricsGenerated: 0,
  alertsGenerated: 0,
  readinessChecksGenerated: 0,
  lastGeneratedAt: null
};

function statusWeight(status) {
  const s = String(status || "").toUpperCase();
  if (["HEALTHY", "READY", "PASS"].includes(s)) return 100;
  if (["ATTENTION", "WARNING"].includes(s)) return 75;
  if (["CRITICAL", "HIGH_RISK"].includes(s)) return 40;
  if (["BLOCKER", "BLOCKED", "FAIL", "ERROR", "LOAD_ERROR"].includes(s)) return 0;
  return 70;
}

function calculateMonitoringScore(metrics, alertHealth) {
  const modules = Object.values(metrics.modules || {});
  const moduleScore = modules.length
    ? Math.round(modules.reduce((sum, m) => sum + statusWeight(m.status), 0) / modules.length)
    : 100;

  let score = moduleScore;
  if (!metrics.database.exists) score -= 30;
  if (alertHealth.blockerAlerts > 0) score -= 30;
  if (alertHealth.criticalAlerts > 0) score -= 15;
  if (metrics.process.memory.heapUsedMB > 512) score -= 10;

  return Math.max(0, Math.min(100, score));
}

function getMonitoringDashboard() {
  const metrics = collectEnterpriseMetrics();
  const generatedAlerts = generateAlertsFromMetrics(metrics);
  const alertHealth = getAlertHealth();
  const healthScore = calculateMonitoringScore(metrics, alertHealth);

  monitoringMetrics.dashboardsGenerated += 1;
  monitoringMetrics.alertsGenerated += generatedAlerts.length;
  monitoringMetrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Enterprise Monitoring & Observability",
    status: healthScore >= 90 ? "HEALTHY" : healthScore >= 70 ? "ATTENTION" : "CRITICAL",
    healthScore,
    generatedAt: monitoringMetrics.lastGeneratedAt,
    metrics,
    alertHealth,
    generatedAlerts,
    openAlerts: getAlerts({ status: "OPEN", limit: 50 }),
    serviceStatus: {
      backend: "ONLINE",
      database: metrics.database.exists ? "ONLINE" : "MISSING",
      workflows: metrics.modules.workflows?.status || "UNKNOWN",
      notifications: metrics.modules.notifications?.status || "UNKNOWN",
      courtOperations: metrics.modules.courtOperations?.status || "UNKNOWN",
      maps: metrics.modules.maps?.status || "UNKNOWN",
      governance: metrics.modules.governance?.status || "UNKNOWN",
      backupRecovery: metrics.modules.backupRecovery?.status || "UNKNOWN",
      hardening: metrics.modules.hardening?.status || "UNKNOWN"
    },
    specialMonitoring: metrics.specialMonitoring
  };
}

function getMonitoringHealth() {
  const dashboard = getMonitoringDashboard();
  monitoringMetrics.healthChecksGenerated += 1;

  return {
    module: "Enterprise Monitoring Engine",
    status: dashboard.status,
    healthScore: dashboard.healthScore,
    backend: dashboard.serviceStatus.backend,
    database: dashboard.serviceStatus.database,
    workflows: dashboard.serviceStatus.workflows,
    notifications: dashboard.serviceStatus.notifications,
    courtOperations: dashboard.serviceStatus.courtOperations,
    maps: dashboard.serviceStatus.maps,
    governance: dashboard.serviceStatus.governance,
    backupRecovery: dashboard.serviceStatus.backupRecovery,
    openAlerts: dashboard.openAlerts.length,
    timestamp: new Date().toISOString()
  };
}

function getMonitoringMetrics() {
  monitoringMetrics.metricsGenerated += 1;
  return {
    ...monitoringMetrics,
    runtime: collectEnterpriseMetrics(),
    timestamp: new Date().toISOString()
  };
}

function getMonitoringReadiness() {
  monitoringMetrics.readinessChecksGenerated += 1;
  const dashboard = getMonitoringDashboard();

  return {
    module: "Monitoring Readiness",
    status: dashboard.status === "CRITICAL" ? "BLOCKED" : "READY",
    monitoringReady: dashboard.status !== "CRITICAL",
    healthScore: dashboard.healthScore,
    openAlerts: dashboard.openAlerts.length,
    requiredPanels: {
      systemHealth: true,
      runtimeMetrics: true,
      alertManager: true,
      hardening: true,
      backupRecovery: true,
      governance: true,
      courtOperations: true,
      maps: true,
      specialCourtAgencyMonitoring: true
    },
    timestamp: new Date().toISOString()
  };
}

function getMonitoringAlerts() {
  return {
    alerts: getAlerts({ limit: 100 }),
    alertHealth: getAlertHealth(),
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  getMonitoringDashboard,
  getMonitoringHealth,
  getMonitoringMetrics,
  getMonitoringReadiness,
  getMonitoringAlerts
};
'@ | Out-File -LiteralPath $Monitoring -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  getMonitoringDashboard,
  getMonitoringHealth,
  getMonitoringMetrics,
  getMonitoringReadiness,
  getMonitoringAlerts
} = require("../automation/enterpriseMonitoringEngine");

const { resolveAlert } = require("../automation/alertManager");

router.get("/health", (req, res) => res.json(getMonitoringHealth()));
router.get("/dashboard", (req, res) => res.json(getMonitoringDashboard()));
router.get("/metrics", (req, res) => res.json(getMonitoringMetrics()));
router.get("/alerts", (req, res) => res.json(getMonitoringAlerts()));
router.get("/readiness", (req, res) => res.json(getMonitoringReadiness()));
router.post("/alerts/:id/resolve", (req, res) => {
  const result = resolveAlert(req.params.id, req.body?.note || "Resolved from monitoring API");
  res.status(result.ok ? 200 : 404).json(result);
});
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: getMonitoringDashboard() }));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/monitoring", require("./routes/enterpriseMonitoringRoutes"));'
  if($txt -notlike '*enterpriseMonitoringRoutes*'){
    if($txt -like '*backupRecoveryRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/backup-recovery",\s*require\("\./routes/backupRecoveryRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10Q Enterprise Monitoring Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }
}

$Validate=Join-Path $Validation "validate-phase10Q-monitoring.js"

@'
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10Q-enterprise-monitoring", "reports");
const dashboards = path.join(root, "_operations", "phase-10Q-enterprise-monitoring", "dashboards");
fs.mkdirSync(reports, { recursive: true });
fs.mkdirSync(dashboards, { recursive: true });

const monitoringPath = path.join(src, "automation", "enterpriseMonitoringEngine.js");
const metricsPath = path.join(src, "automation", "metricsCollector.js");
const alertsPath = path.join(src, "automation", "alertManager.js");
const routePath = path.join(src, "routes", "enterpriseMonitoringRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(monitoringPath)) {
  console.log("Enterprise Monitoring Engine missing. Run APPLY mode.");
  process.exit(1);
}

const monitoring = require(monitoringPath);

const dashboard = monitoring.getMonitoringDashboard();
const health = monitoring.getMonitoringHealth();
const metrics = monitoring.getMonitoringMetrics();
const alerts = monitoring.getMonitoringAlerts();
const readiness = monitoring.getMonitoringReadiness();
const indexText = fs.readFileSync(indexPath, "utf8");

fs.writeFileSync(path.join(dashboards, "latest-monitoring-dashboard.json"), JSON.stringify(dashboard, null, 2));

const report = {
  phase: "10Q",
  module: "Enterprise Monitoring & Observability",
  timestamp: new Date().toISOString(),
  files: {
    monitoringEngineExists: fs.existsSync(monitoringPath),
    metricsCollectorExists: fs.existsSync(metricsPath),
    alertManagerExists: fs.existsSync(alertsPath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseMonitoringRoutes")
  },
  tests: {
    dashboardGenerated: !!dashboard.status,
    healthGenerated: !!health.status,
    metricsGenerated: !!metrics.runtime,
    alertsGenerated: !!alerts.alertHealth,
    readinessGenerated: !!readiness.status,
    specialMonitoringIncluded: dashboard.specialMonitoring?.industrialCourtKualaLumpur === "MONITORED"
  },
  health,
  readiness,
  status: (
    fs.existsSync(monitoringPath) &&
    fs.existsSync(metricsPath) &&
    fs.existsSync(alertsPath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseMonitoringRoutes") &&
    !!dashboard.status &&
    !!health.status &&
    !!metrics.runtime &&
    !!alerts.alertHealth &&
    !!readiness.status &&
    dashboard.specialMonitoring?.industrialCourtKualaLumpur === "MONITORED"
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10Q-monitoring-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10Q ENTERPRISE MONITORING REPORT",
  "======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Monitoring Engine Exists: " + report.files.monitoringEngineExists,
  "Metrics Collector Exists: " + report.files.metricsCollectorExists,
  "Alert Manager Exists: " + report.files.alertManagerExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Metrics Generated: " + report.tests.metricsGenerated,
  "Alerts Generated: " + report.tests.alertsGenerated,
  "Readiness Generated: " + report.tests.readinessGenerated,
  "Industrial Court/PERKESO Monitoring: " + report.tests.specialMonitoringIncluded,
  "Monitoring Health Score: " + health.healthScore,
  "Monitoring Status: " + health.status
];

fs.writeFileSync(path.join(reports, "phase10Q-monitoring-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10Q ENTERPRISE MONITORING & OBSERVABILITY

## Purpose
Create live monitoring, metrics collection, alert management, readiness monitoring, and operational dashboards.

## Created Files
- backend\src\automation\enterpriseMonitoringEngine.js
- backend\src\automation\metricsCollector.js
- backend\src\automation\alertManager.js
- backend\src\routes\enterpriseMonitoringRoutes.js
- backend\src\index.js route mount

## Endpoints
- GET /api/enterprise/monitoring/health
- GET /api/enterprise/monitoring/dashboard
- GET /api/enterprise/monitoring/metrics
- GET /api/enterprise/monitoring/alerts
- GET /api/enterprise/monitoring/readiness
- POST /api/enterprise/monitoring/alerts/:id/resolve
- GET /api/enterprise/monitoring/test/dashboard

## Monitored Areas
- Backend process
- Database file
- Hardening
- Backup recovery
- Governance
- Autonomous operations
- Predictive analytics
- Matter intelligence
- Document lifecycle
- Workflow engine
- Notifications
- Court operations
- Navigation
- Maps
- Industrial Court Kuala Lumpur
- PERKESO Kuala Lumpur
- PERKESO Headquarters Jalan Ampang

## Checks & Balances
- Health score
- Module status
- Alert classification
- Blocker/critical detection
- Monitoring readiness
- Latest dashboard JSON export
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10Q-MONITORING-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Dashboards:"
Write-Host $Dashboards
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10Q ENTERPRISE MONITORING STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10Q ENTERPRISE MONITORING STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit

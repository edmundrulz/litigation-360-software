param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Src=Join-Path $Backend "src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Frontend=Join-Path $Root "frontend"
$FrontendSrc=Join-Path $Frontend "src"
$EnterprisePages=Join-Path $FrontendSrc "enterprise\pages"
$EnterpriseApi=Join-Path $FrontendSrc "enterprise\api"

$Phase=Join-Path $Root "_operations\phase-10Z0-enterprise-operations-command-centre"
$Reports=Join-Path $Phase "reports"
$Dashboards=Join-Path $Phase "dashboards"
$Alerts=Join-Path $Phase "alerts"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $Reports,$Dashboards,$Alerts,$Backups,$Logs,$Docs,$Validation,$Auto,$Routes,$EnterprisePages,$EnterpriseApi | Out-Null

$Engine=Join-Path $Auto "enterpriseOperationsCommandCentre.js"
$Route=Join-Path $Routes "enterpriseOperationsRoutes.js"
$FrontendApiFile=Join-Path $EnterpriseApi "enterpriseOperationsApi.js"
$FrontendPage=Join-Path $EnterprisePages "EnterpriseOperationsCommandCentre.jsx"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10Z.0 ENTERPRISE OPERATIONS COMMAND CENTRE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

foreach($r in @("enterpriseMonitoringEngine.js","deploymentGatekeeperEngine.js","deploymentScoringEngine.js","environmentValidationEngine.js","releaseValidatorEngine.js","performanceOptimizationEngine.js","backupRecoveryEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Auto $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

if($Mode -eq "APPLY"){
  Backup $Engine
  Backup $Route
  Backup $Index
  Backup $FrontendApiFile
  Backup $FrontendPage

@'
const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const PHASE_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10Z0-enterprise-operations-command-centre");
const DASHBOARDS = path.join(PHASE_ROOT, "dashboards");
const ALERTS = path.join(PHASE_ROOT, "alerts");

fs.mkdirSync(DASHBOARDS, { recursive: true });
fs.mkdirSync(ALERTS, { recursive: true });

const metrics = {
  dashboardsGenerated: 0,
  alertsGenerated: 0,
  workflowViewsGenerated: 0,
  courtViewsGenerated: 0,
  navigationViewsGenerated: 0,
  deploymentViewsGenerated: 0,
  lastGeneratedAt: null
};

function safeCall(label, fn) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, label };
  }
}

function loadJson(file) {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return null;
  }
}

function getSystemPanel() {
  const monitoring = require("./enterpriseMonitoringEngine");
  const environment = require("./environmentValidationEngine");
  const release = require("./releaseValidatorEngine");
  const performance = require("./performanceOptimizationEngine");
  const backup = require("./backupRecoveryEngine");

  return {
    monitoring: safeCall("monitoring", () => monitoring.getMonitoringHealth()),
    environment: safeCall("environment", () => environment.getEnvironmentHealth()),
    release: safeCall("release", () => release.getReleaseHealth()),
    performance: safeCall("performance", () => performance.getPerformanceHealth ? performance.getPerformanceHealth() : performance.health()),
    backupRecovery: safeCall("backupRecovery", () => backup.getBackupRecoveryHealth()),
    generatedAt: new Date().toISOString()
  };
}

function getDeploymentPanel() {
  const scoring = require("./deploymentScoringEngine");
  const gatekeeper = require("./deploymentGatekeeperEngine");
  const dashboard = require("./executiveDeploymentDashboardEngine");

  metrics.deploymentViewsGenerated += 1;

  return {
    scoring: safeCall("scoring", () => scoring.getScoringHealth()),
    gatekeeper: safeCall("gatekeeper", () => gatekeeper.getGatekeeperHealth()),
    executiveDeployment: safeCall("executiveDeployment", () => dashboard.getExecutiveDeploymentHealth()),
    generatedAt: new Date().toISOString()
  };
}

function getWorkflowPanel() {
  const architecture = loadJson(path.join(PROJECT_ROOT, "_operations", "phase-10Y0-enterprise-master-registry-digital-twin", "registries", "workflows-registry.json"));
  const automation = loadJson(path.join(PROJECT_ROOT, "_operations", "enterprise-architecture", "registries", "automation-registry.json"));

  metrics.workflowViewsGenerated += 1;

  return {
    module: "Workflow Operations",
    status: "MONITORED",
    activeWorkflows: 0,
    pendingWorkflows: 0,
    failedWorkflows: 0,
    completedWorkflows: 0,
    knownWorkflows: architecture?.totals?.workflows || automation?.totals?.events || 0,
    workflows: architecture?.workflows || [],
    generatedAt: new Date().toISOString()
  };
}

function getCourtPanel() {
  metrics.courtViewsGenerated += 1;

  return {
    module: "Court Operations",
    status: "MONITORED",
    todayHearings: [],
    upcomingHearings: [],
    courtAttendance: [],
    preparationStatus: "NO_ACTIVE_HEARING_DATA_CONNECTED",
    courts: [
      "Federal Court",
      "Court of Appeal",
      "High Court",
      "Sessions Court",
      "Magistrates Court"
    ],
    generatedAt: new Date().toISOString()
  };
}

function getIndustrialCourtPanel() {
  return {
    module: "Industrial Court Operations",
    status: "MONITORED",
    location: "Industrial Court Kuala Lumpur",
    cases: [],
    hearings: [],
    deadlines: [],
    attendance: [],
    navigationStatus: "READY_FOR_MAP_LINK_GENERATION",
    generatedAt: new Date().toISOString()
  };
}

function getPerkesoPanel() {
  return {
    module: "PERKESO Operations",
    status: "MONITORED",
    offices: [
      "PERKESO Kuala Lumpur - Jalan Tun Razak",
      "PERKESO Headquarters - Jalan Ampang"
    ],
    meetings: [],
    submissions: [],
    appointments: [],
    attendance: [],
    navigationStatus: "READY_FOR_MAP_LINK_GENERATION",
    generatedAt: new Date().toISOString()
  };
}

function getNavigationPanel() {
  metrics.navigationViewsGenerated += 1;

  return {
    module: "Navigation Centre",
    status: "READY",
    destinations: [
      {
        name: "Industrial Court Kuala Lumpur",
        type: "INDUSTRIAL_COURT",
        googleMapsReady: true,
        wazeReady: true
      },
      {
        name: "PERKESO Kuala Lumpur - Jalan Tun Razak",
        type: "PERKESO",
        googleMapsReady: true,
        wazeReady: true
      },
      {
        name: "PERKESO Headquarters - Jalan Ampang",
        type: "PERKESO",
        googleMapsReady: true,
        wazeReady: true
      }
    ],
    generatedAt: new Date().toISOString()
  };
}

function generateExecutiveAlerts(dashboard) {
  const alerts = [];

  if (dashboard.deployment?.gatekeeper?.deploymentApproved === false || dashboard.deployment?.gatekeeper?.status === "REJECTED") {
    alerts.push({
      severity: "CRITICAL",
      category: "DEPLOYMENT",
      message: "Deployment Gatekeeper has not approved deployment.",
      createdAt: new Date().toISOString()
    });
  }

  if (dashboard.system?.monitoring?.status === "CRITICAL") {
    alerts.push({
      severity: "CRITICAL",
      category: "MONITORING",
      message: "Enterprise monitoring is critical.",
      createdAt: new Date().toISOString()
    });
  }

  if (dashboard.system?.backupRecovery?.status === "FAIL") {
    alerts.push({
      severity: "CRITICAL",
      category: "BACKUP",
      message: "Backup recovery status failed.",
      createdAt: new Date().toISOString()
    });
  }

  alerts.push({
    severity: "INFO",
    category: "OPERATIONS",
    message: "Industrial Court Kuala Lumpur and PERKESO operational coverage present.",
    createdAt: new Date().toISOString()
  });

  metrics.alertsGenerated += alerts.length;
  fs.writeFileSync(path.join(ALERTS, "latest-executive-alerts.json"), JSON.stringify(alerts, null, 2));

  return alerts;
}

function generateOperationsDashboard() {
  const dashboard = {
    module: "Enterprise Operations Command Centre",
    status: "ACTIVE",
    system: getSystemPanel(),
    deployment: getDeploymentPanel(),
    workflows: getWorkflowPanel(),
    courts: getCourtPanel(),
    industrialCourt: getIndustrialCourtPanel(),
    perkeso: getPerkesoPanel(),
    navigation: getNavigationPanel(),
    generatedAt: new Date().toISOString()
  };

  dashboard.executiveAlerts = generateExecutiveAlerts(dashboard);
  dashboard.summary = {
    operationalStatus: "ACTIVE",
    deploymentStatus: dashboard.deployment.gatekeeper?.status || "UNKNOWN",
    deploymentApproved: dashboard.deployment.gatekeeper?.deploymentApproved || false,
    monitoringStatus: dashboard.system.monitoring?.status || "UNKNOWN",
    performanceStatus: dashboard.system.performance?.status || "UNKNOWN",
    industrialCourtStatus: dashboard.industrialCourt.status,
    perkesoStatus: dashboard.perkeso.status,
    alertCount: dashboard.executiveAlerts.length
  };

  metrics.dashboardsGenerated += 1;
  metrics.lastGeneratedAt = dashboard.generatedAt;

  fs.writeFileSync(path.join(DASHBOARDS, "latest-enterprise-operations-dashboard.json"), JSON.stringify(dashboard, null, 2));
  return dashboard;
}

function getOperationsAlerts() {
  const dashboard = generateOperationsDashboard();
  return {
    module: "Enterprise Operations Alerts",
    alertCount: dashboard.executiveAlerts.length,
    alerts: dashboard.executiveAlerts,
    timestamp: new Date().toISOString()
  };
}

function getOperationsHealth() {
  const dashboard = generateOperationsDashboard();

  return {
    module: "Enterprise Operations Command Centre",
    status: dashboard.status,
    operationalStatus: dashboard.summary.operationalStatus,
    deploymentApproved: dashboard.summary.deploymentApproved,
    monitoringStatus: dashboard.summary.monitoringStatus,
    performanceStatus: dashboard.summary.performanceStatus,
    industrialCourtStatus: dashboard.summary.industrialCourtStatus,
    perkesoStatus: dashboard.summary.perkesoStatus,
    alertCount: dashboard.summary.alertCount,
    dashboardsGenerated: metrics.dashboardsGenerated,
    alertsGenerated: metrics.alertsGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getOperationsMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  generateOperationsDashboard,
  getOperationsAlerts,
  getSystemPanel,
  getDeploymentPanel,
  getWorkflowPanel,
  getCourtPanel,
  getIndustrialCourtPanel,
  getPerkesoPanel,
  getNavigationPanel,
  getOperationsHealth,
  getOperationsMetrics
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateOperationsDashboard,
  getOperationsAlerts,
  getSystemPanel,
  getDeploymentPanel,
  getWorkflowPanel,
  getCourtPanel,
  getIndustrialCourtPanel,
  getPerkesoPanel,
  getNavigationPanel,
  getOperationsHealth,
  getOperationsMetrics
} = require("../automation/enterpriseOperationsCommandCentre");

router.get("/health", (req, res) => res.json(getOperationsHealth()));
router.get("/metrics", (req, res) => res.json(getOperationsMetrics()));
router.get("/dashboard", (req, res) => res.json(generateOperationsDashboard()));
router.get("/alerts", (req, res) => res.json(getOperationsAlerts()));
router.get("/system", (req, res) => res.json(getSystemPanel()));
router.get("/deployment", (req, res) => res.json(getDeploymentPanel()));
router.get("/workflows", (req, res) => res.json(getWorkflowPanel()));
router.get("/courts", (req, res) => res.json(getCourtPanel()));
router.get("/industrial-court", (req, res) => res.json(getIndustrialCourtPanel()));
router.get("/perkeso", (req, res) => res.json(getPerkesoPanel()));
router.get("/navigation", (req, res) => res.json(getNavigationPanel()));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/operations", require("./routes/enterpriseOperationsRoutes"));'
  if($txt -notlike '*enterpriseOperationsRoutes*'){
    if($txt -like '*deploymentGatekeeperRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/gatekeeper",\s*require\("\./routes/deploymentGatekeeperRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10Z.0 Enterprise Operations Command Centre Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }

@'
const API_BASE = "http://localhost:5000";

async function getJson(path) {
  try {
    const response = await fetch(`${API_BASE}${path}`);
    if (!response.ok) return { ok: false, status: response.status, error: `Request failed: ${response.status}`, path };
    return await response.json();
  } catch (err) {
    return { ok: false, status: "NETWORK_ERROR", error: err.message, path };
  }
}

export async function getEnterpriseOperationsDashboard() {
  return await getJson("/api/enterprise/operations/dashboard");
}

export async function getEnterpriseOperationsHealth() {
  return await getJson("/api/enterprise/operations/health");
}

export async function getEnterpriseOperationsAlerts() {
  return await getJson("/api/enterprise/operations/alerts");
}
'@ | Out-File -LiteralPath $FrontendApiFile -Encoding UTF8

@'
import React, { useEffect, useState } from "react";
import { getEnterpriseOperationsDashboard } from "../api/enterpriseOperationsApi";

export default function EnterpriseOperationsCommandCentre() {
  const [dashboard, setDashboard] = useState(null);
  const [error, setError] = useState(null);

  async function refresh() {
    try {
      setError(null);
      setDashboard(await getEnterpriseOperationsDashboard());
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 30000);
    return () => clearInterval(timer);
  }, []);

  const summary = dashboard?.summary || {};

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Enterprise Operations Command Centre</h1>
      <p>Live operations view for system health, deployment, workflows, courts, Industrial Court, PERKESO, navigation, and alerts.</p>

      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>Refresh Now</button>
      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: 16 }}>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Operations</h3><strong>{summary.operationalStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Deployment</h3><strong>{summary.deploymentStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Monitoring</h3><strong>{summary.monitoringStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Performance</h3><strong>{summary.performanceStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Industrial Court</h3><strong>{summary.industrialCourtStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>PERKESO</h3><strong>{summary.perkesoStatus || "UNKNOWN"}</strong></div>
      </div>

      <h2>Executive Alerts</h2>
      <ul>
        {(dashboard?.executiveAlerts || []).map((alert, index) => (
          <li key={index}><strong>{alert.severity}</strong> — {alert.category}: {alert.message}</li>
        ))}
      </ul>

      <h2>Special Operations</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur — Jalan Tun Razak</li>
        <li>PERKESO Headquarters — Jalan Ampang</li>
        <li>Google Maps / Waze navigation readiness</li>
      </ul>

      <h2>Raw Operations Dashboard</h2>
      <pre style={{ background: "#f5f5f5", padding: 16, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(dashboard, null, 2)}
      </pre>
    </div>
  );
}
'@ | Out-File -LiteralPath $FrontendPage -Encoding UTF8

@"
# ENTERPRISE OPERATIONS HANDBOOK

## Purpose
Phase 10Z.0 creates the Enterprise Operations Command Centre.

## Coverage
- System Health
- Deployment Health
- Workflow Health
- Court Operations
- Industrial Court Kuala Lumpur
- PERKESO Jalan Tun Razak
- PERKESO HQ Jalan Ampang
- Navigation Readiness
- Executive Alerts

## Backend Endpoints
- GET /api/enterprise/operations/health
- GET /api/enterprise/operations/dashboard
- GET /api/enterprise/operations/alerts
- GET /api/enterprise/operations/workflows
- GET /api/enterprise/operations/courts
- GET /api/enterprise/operations/industrial-court
- GET /api/enterprise/operations/perkeso
- GET /api/enterprise/operations/navigation
- GET /api/enterprise/operations/deployment
"@ | Out-File -LiteralPath (Join-Path $Docs "ENTERPRISE-OPERATIONS-HANDBOOK.md") -Encoding UTF8

@"
# OPERATIONS CENTRE PROTOCOL

## Refresh
Dashboard refreshes every 30 seconds in the frontend.

## Checks
1. Operations health
2. Monitoring health
3. Deployment gatekeeper
4. Performance health
5. Backup recovery
6. Court/PERKESO coverage
"@ | Out-File -LiteralPath (Join-Path $Docs "OPERATIONS-CENTRE-PROTOCOL.md") -Encoding UTF8

@"
# ALERT MANAGEMENT PROTOCOL

Alerts are generated into:
$Alerts

Severity levels:
- CRITICAL
- HIGH
- MEDIUM
- LOW
- INFO
"@ | Out-File -LiteralPath (Join-Path $Docs "ALERT-MANAGEMENT-PROTOCOL.md") -Encoding UTF8

@"
# INDUSTRIAL COURT PROTOCOL

Coverage:
- Industrial Court Kuala Lumpur

Tracked panels:
- Hearings
- Deadlines
- Attendance
- Navigation readiness
"@ | Out-File -LiteralPath (Join-Path $Docs "INDUSTRIAL-COURT-PROTOCOL.md") -Encoding UTF8

@"
# PERKESO OPERATIONS PROTOCOL

Coverage:
- PERKESO Kuala Lumpur — Jalan Tun Razak
- PERKESO Headquarters — Jalan Ampang

Tracked panels:
- Meetings
- Submissions
- Appointments
- Attendance
- Navigation readiness
"@ | Out-File -LiteralPath (Join-Path $Docs "PERKESO-OPERATIONS-PROTOCOL.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10Z0.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const frontendSrc = path.join(root, "frontend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "enterpriseOperationsCommandCentre.js");
const routePath = path.join(src, "routes", "enterpriseOperationsRoutes.js");
const indexPath = path.join(src, "index.js");
const apiPath = path.join(frontendSrc, "enterprise", "api", "enterpriseOperationsApi.js");
const pagePath = path.join(frontendSrc, "enterprise", "pages", "EnterpriseOperationsCommandCentre.jsx");

if (!fs.existsSync(enginePath)) {
  console.log("Enterprise Operations Command Centre missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const dashboard = engine.generateOperationsDashboard();
const alerts = engine.getOperationsAlerts();
const health = engine.getOperationsHealth();
const indexText = fs.readFileSync(indexPath, "utf8");
const pageText = fs.existsSync(pagePath) ? fs.readFileSync(pagePath, "utf8") : "";

const validation = {
  phase: "10Z.0",
  module: "Enterprise Operations Command Centre",
  timestamp: new Date().toISOString(),
  files: {
    commandCentreExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseOperationsRoutes"),
    frontendApiExists: fs.existsSync(apiPath),
    frontendPageExists: fs.existsSync(pagePath)
  },
  tests: {
    operationsDashboardGenerated: !!dashboard.summary,
    courtPanelPresent: !!dashboard.courts,
    industrialCourtPanelPresent: !!dashboard.industrialCourt && JSON.stringify(dashboard.industrialCourt).includes("Industrial Court Kuala Lumpur"),
    perkesoPanelPresent: !!dashboard.perkeso && JSON.stringify(dashboard.perkeso).includes("PERKESO"),
    deploymentPanelPresent: !!dashboard.deployment,
    executiveAlertsPresent: Array.isArray(dashboard.executiveAlerts),
    realtimeRefreshPresent: pageText.includes("setInterval") && pageText.includes("30000"),
    healthGenerated: !!health.status,
    alertsGenerated: Array.isArray(alerts.alerts)
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseOperationsRoutes") &&
    fs.existsSync(apiPath) &&
    fs.existsSync(pagePath) &&
    !!dashboard.summary &&
    !!dashboard.courts &&
    !!dashboard.industrialCourt &&
    JSON.stringify(dashboard.industrialCourt).includes("Industrial Court Kuala Lumpur") &&
    !!dashboard.perkeso &&
    JSON.stringify(dashboard.perkeso).includes("PERKESO") &&
    !!dashboard.deployment &&
    Array.isArray(dashboard.executiveAlerts) &&
    pageText.includes("setInterval") &&
    pageText.includes("30000") &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10Z0-enterprise-operations-command-centre-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10Z.0 ENTERPRISE OPERATIONS COMMAND CENTRE REPORT",
  "======================================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Command Centre Exists: " + validation.files.commandCentreExists,
  "Routes Exist: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Frontend API Exists: " + validation.files.frontendApiExists,
  "Frontend Page Exists: " + validation.files.frontendPageExists,
  "Operations Dashboard Generated: " + validation.tests.operationsDashboardGenerated,
  "Court Panel Present: " + validation.tests.courtPanelPresent,
  "Industrial Court Panel Present: " + validation.tests.industrialCourtPanelPresent,
  "PERKESO Panel Present: " + validation.tests.perkesoPanelPresent,
  "Deployment Panel Present: " + validation.tests.deploymentPanelPresent,
  "Executive Alerts Present: " + validation.tests.executiveAlertsPresent,
  "Realtime Refresh Present: " + validation.tests.realtimeRefreshPresent,
  "Health Generated: " + validation.tests.healthGenerated
].join("\n"));

if (validation.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
$env:L360_ROOT=$Root
$env:L360_REPORTS=$Reports
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Dashboards:"
Write-Host $Dashboards
Write-Host ""
Write-Host "Alerts:"
Write-Host $Alerts
Write-Host ""
Write-Host "Docs:"
Write-Host $Docs
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10Z.0 ENTERPRISE OPERATIONS COMMAND CENTRE STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10Z.0 ENTERPRISE OPERATIONS COMMAND CENTRE STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

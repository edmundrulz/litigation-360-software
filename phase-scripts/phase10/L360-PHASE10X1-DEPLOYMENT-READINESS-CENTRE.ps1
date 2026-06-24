param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Src=Join-Path $Backend "src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10X1-deployment-readiness-centre"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Dashboards=Join-Path $Phase "dashboards"
$BaselineRegistries=Join-Path $Root "_operations\phase-10X0-deployment-readiness-baseline-audit\registries"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Dashboards,$Auto,$Routes | Out-Null

$Engine=Join-Path $Auto "deploymentReadinessCentre.js"
$Route=Join-Path $Routes "deploymentReadinessCentreRoutes.js"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.1 DEPLOYMENT READINESS CENTRE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath (Join-Path $BaselineRegistries "_master_baseline_registry.json"))){
  Write-Host "ERROR: Phase 10X.0 master baseline registry missing. Run Phase 10X.0 first." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $Engine
  Backup $Route
  Backup $Index

@'
const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BASELINE_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X0-deployment-readiness-baseline-audit", "registries");
const OUTPUT_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X1-deployment-readiness-centre", "dashboards");

fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const metrics = {
  readinessChecksRun: 0,
  dashboardsGenerated: 0,
  executiveSummariesGenerated: 0,
  lastGeneratedAt: null
};

function readJson(file) {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch (err) {
    return null;
  }
}

function loadBaseline() {
  const files = {
    backend: "_backend_inventory.json",
    frontend: "_frontend_inventory.json",
    routes: "_route_registry.json",
    enterprise: "_enterprise_registry.json",
    database: "_database_registry.json",
    deployment: "_deployment_registry.json",
    master: "_master_baseline_registry.json"
  };

  const loaded = {};
  for (const [key, file] of Object.entries(files)) {
    loaded[key] = readJson(path.join(BASELINE_DIR, file));
  }

  return loaded;
}

function scoreSection(name, checks, weight) {
  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;
  const score = Math.round((passed / Math.max(1, checks.length)) * 100);

  return {
    name,
    weight,
    status: failed === 0 ? "PASS" : "FAIL",
    score,
    passed,
    failed,
    checks
  };
}

function calculateDeploymentReadiness() {
  const baseline = loadBaseline();

  const backend = baseline.backend || {};
  const frontend = baseline.frontend || {};
  const routes = baseline.routes || {};
  const enterprise = baseline.enterprise || {};
  const database = baseline.database || {};
  const deployment = baseline.deployment || {};

  const sections = [
    scoreSection("Backend", [
      { name: "Backend inventory exists", pass: !!baseline.backend },
      { name: "Backend files discovered", pass: (backend.totals?.files || 0) > 0 },
      { name: "Automation files discovered", pass: (backend.totals?.automationFiles || 0) > 0 },
      { name: "Route files discovered", pass: (backend.totals?.routeFiles || 0) > 0 }
    ], 15),

    scoreSection("Frontend", [
      { name: "Frontend inventory exists", pass: !!baseline.frontend },
      { name: "Frontend files discovered", pass: (frontend.totals?.files || 0) > 0 },
      { name: "Frontend enterprise files discovered", pass: (frontend.totals?.enterpriseFiles || 0) > 0 },
      { name: "Frontend dist exists", pass: deployment.frontend?.distExists === true }
    ], 15),

    scoreSection("Routes", [
      { name: "Route registry exists", pass: !!baseline.routes },
      { name: "Route mounts discovered", pass: (routes.totals?.mounts || 0) > 0 },
      { name: "Enterprise route mounts discovered", pass: (routes.mounts || []).some(m => String(m.basePath).includes("/api/enterprise")) },
      { name: "Extracted routes discovered", pass: (routes.totals?.extractedRoutes || 0) > 0 }
    ], 15),

    scoreSection("Enterprise Modules", [
      { name: "Enterprise registry exists", pass: !!baseline.enterprise },
      { name: "At least 15 expected enterprise modules exist", pass: (enterprise.totals?.existingExpectedModules || 0) >= 15 },
      { name: "All expected enterprise modules exist", pass: (enterprise.totals?.existingExpectedModules || 0) === (enterprise.totals?.expectedModules || 999) },
      { name: "Automation inventory exists", pass: (enterprise.totals?.automationFiles || 0) > 0 }
    ], 20),

    scoreSection("Database", [
      { name: "Database registry exists", pass: !!baseline.database },
      { name: "Database exists", pass: database.databaseExists === true },
      { name: "Database non-zero size", pass: (database.databaseSizeBytes || 0) > 0 },
      { name: "Database tables detected or sqlite fallback recorded", pass: (database.totals?.tables || 0) > 0 || database.sqliteAvailable === false }
    ], 15),

    scoreSection("Environment", [
      { name: "Deployment registry exists", pass: !!baseline.deployment },
      { name: "Node version detected", pass: !!deployment.environment?.nodeVersion },
      { name: "NPM version detected", pass: !!deployment.environment?.npmVersion },
      { name: "Backend package exists", pass: deployment.backend?.packageExists === true },
      { name: "Frontend package exists", pass: deployment.frontend?.packageExists === true }
    ], 10),

    scoreSection("Build & Release", [
      { name: "Frontend build script exists", pass: !!deployment.frontend?.scripts?.build },
      { name: "Frontend dev script exists", pass: !!deployment.frontend?.scripts?.dev },
      { name: "Backend scripts exist", pass: Object.keys(deployment.backend?.scripts || {}).length > 0 },
      { name: "Default backend port registered", pass: deployment.ports?.backendDefault === 5000 }
    ], 10)
  ];

  let weighted = 0;
  let totalWeight = 0;
  for (const section of sections) {
    weighted += section.score * section.weight;
    totalWeight += section.weight;
  }

  const deploymentScore = Math.round(weighted / Math.max(1, totalWeight));

  const blockingIssues = [];
  const warnings = [];

  for (const section of sections) {
    for (const check of section.checks) {
      if (!check.pass) {
        if (section.weight >= 15) blockingIssues.push(`${section.name}: ${check.name}`);
        else warnings.push(`${section.name}: ${check.name}`);
      }
    }
  }

  const riskLevel =
    deploymentScore >= 90 && blockingIssues.length === 0 ? "LOW" :
    deploymentScore >= 75 ? "MEDIUM" :
    deploymentScore >= 50 ? "HIGH" :
    "CRITICAL";

  const deploymentReady = deploymentScore >= 85 && blockingIssues.length === 0;

  metrics.readinessChecksRun += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Enterprise Deployment Readiness Centre",
    status: deploymentReady ? "READY" : "BLOCKED",
    deploymentReady,
    deploymentScore,
    riskLevel,
    blockingIssues,
    blockingIssuesCount: blockingIssues.length,
    warnings,
    warningsCount: warnings.length,
    sections,
    keyCounts: {
      backendFiles: backend.totals?.files || 0,
      frontendFiles: frontend.totals?.files || 0,
      routeMounts: routes.totals?.mounts || 0,
      extractedRoutes: routes.totals?.extractedRoutes || 0,
      expectedEnterpriseModules: enterprise.totals?.expectedModules || 0,
      existingEnterpriseModules: enterprise.totals?.existingExpectedModules || 0,
      databaseTables: database.totals?.tables || 0,
      databaseIndexes: database.totals?.indexes || 0
    },
    generatedAt: metrics.lastGeneratedAt
  };
}

function getDeploymentDashboard() {
  const readiness = calculateDeploymentReadiness();
  metrics.dashboardsGenerated += 1;

  const dashboard = {
    module: "Deployment Readiness Dashboard",
    generatedAt: new Date().toISOString(),
    summary: {
      status: readiness.status,
      deploymentReady: readiness.deploymentReady,
      deploymentScore: readiness.deploymentScore,
      riskLevel: readiness.riskLevel,
      blockingIssues: readiness.blockingIssuesCount,
      warnings: readiness.warningsCount
    },
    readiness
  };

  fs.writeFileSync(path.join(OUTPUT_DIR, "latest-deployment-readiness-dashboard.json"), JSON.stringify(dashboard, null, 2));
  return dashboard;
}

function getExecutiveDeploymentSummary() {
  const readiness = calculateDeploymentReadiness();
  metrics.executiveSummariesGenerated += 1;

  return {
    title: "Litigation 360 Deployment Readiness Executive Summary",
    status: readiness.status,
    deploymentReady: readiness.deploymentReady,
    score: readiness.deploymentScore,
    risk: readiness.riskLevel,
    blockingIssues: readiness.blockingIssuesCount,
    warnings: readiness.warningsCount,
    plainEnglish: readiness.deploymentReady
      ? `Deployment status READY. Score ${readiness.deploymentScore}. Risk ${readiness.riskLevel}.`
      : `Deployment status BLOCKED. Score ${readiness.deploymentScore}. ${readiness.blockingIssuesCount} blocking issue(s) must be resolved.`,
    generatedAt: new Date().toISOString()
  };
}

function getDeploymentCentreHealth() {
  const readiness = calculateDeploymentReadiness();

  return {
    module: "Deployment Readiness Centre",
    status: readiness.status,
    deploymentReady: readiness.deploymentReady,
    deploymentScore: readiness.deploymentScore,
    riskLevel: readiness.riskLevel,
    blockingIssuesCount: readiness.blockingIssuesCount,
    warningsCount: readiness.warningsCount,
    readinessChecksRun: metrics.readinessChecksRun,
    dashboardsGenerated: metrics.dashboardsGenerated,
    executiveSummariesGenerated: metrics.executiveSummariesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getDeploymentCentreMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  loadBaseline,
  calculateDeploymentReadiness,
  getDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getDeploymentCentreHealth,
  getDeploymentCentreMetrics
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  loadBaseline,
  calculateDeploymentReadiness,
  getDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getDeploymentCentreHealth,
  getDeploymentCentreMetrics
} = require("../automation/deploymentReadinessCentre");

router.get("/health", (req, res) => res.json(getDeploymentCentreHealth()));
router.get("/metrics", (req, res) => res.json(getDeploymentCentreMetrics()));
router.get("/baseline", (req, res) => res.json(loadBaseline()));
router.get("/readiness", (req, res) => res.json(calculateDeploymentReadiness()));
router.get("/dashboard", (req, res) => res.json(getDeploymentDashboard()));
router.get("/executive-summary", (req, res) => res.json(getExecutiveDeploymentSummary()));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/deployment-centre", require("./routes/deploymentReadinessCentreRoutes"));'
  if($txt -notlike '*deploymentReadinessCentreRoutes*'){
    if($txt -like '*performanceOptimizationRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/performance",\s*require\("\./routes/performanceOptimizationRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10X.1 Deployment Readiness Centre Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }

@"
# LITIGATION 360 - PHASE 10X.1 DEPLOYMENT READINESS CENTRE

## Purpose
Convert Phase 10X.0 baseline registries into deployment score, risk level, blocking issues, warnings, dashboard, and executive deployment summary.

## Created Files
- backend\src\automation\deploymentReadinessCentre.js
- backend\src\routes\deploymentReadinessCentreRoutes.js
- backend\src\index.js route mount

## Endpoints
- GET /api/enterprise/deployment-centre/health
- GET /api/enterprise/deployment-centre/metrics
- GET /api/enterprise/deployment-centre/baseline
- GET /api/enterprise/deployment-centre/readiness
- GET /api/enterprise/deployment-centre/dashboard
- GET /api/enterprise/deployment-centre/executive-summary

## Inputs
Reads:
- _operations\phase-10X0-deployment-readiness-baseline-audit\registries\_master_baseline_registry.json
- backend inventory
- frontend inventory
- route registry
- enterprise registry
- database registry
- deployment registry

## Scoring
- Backend 15%
- Frontend 15%
- Routes 15%
- Enterprise Modules 20%
- Database 15%
- Environment 10%
- Build & Release 10%
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10X1-DEPLOYMENT-READINESS-CENTRE.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X1.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "deploymentReadinessCentre.js");
const routePath = path.join(src, "routes", "deploymentReadinessCentreRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Deployment Readiness Centre missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const baseline = engine.loadBaseline();
const readiness = engine.calculateDeploymentReadiness();
const dashboard = engine.getDeploymentDashboard();
const summary = engine.getExecutiveDeploymentSummary();
const health = engine.getDeploymentCentreHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10X.1",
  module: "Deployment Readiness Centre",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("deploymentReadinessCentreRoutes")
  },
  tests: {
    baselineLoaded: !!baseline.master,
    readinessGenerated: typeof readiness.deploymentScore === "number",
    dashboardGenerated: !!dashboard.summary,
    summaryGenerated: !!summary.plainEnglish,
    healthGenerated: !!health.status
  },
  readiness,
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("deploymentReadinessCentreRoutes") &&
    !!baseline.master &&
    typeof readiness.deploymentScore === "number" &&
    !!dashboard.summary &&
    !!summary.plainEnglish &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X1-deployment-readiness-centre-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.1 DEPLOYMENT READINESS CENTRE REPORT",
  "==============================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Baseline Loaded: " + report.tests.baselineLoaded,
  "Readiness Generated: " + report.tests.readinessGenerated,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Executive Summary Generated: " + report.tests.summaryGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Deployment Status: " + readiness.status,
  "Deployment Ready: " + readiness.deploymentReady,
  "Deployment Score: " + readiness.deploymentScore,
  "Risk Level: " + readiness.riskLevel,
  "Blocking Issues: " + readiness.blockingIssuesCount,
  "Warnings: " + readiness.warningsCount
].join("\n"));

if (report.status !== "PASS") process.exit(1);
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
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10X.1 DEPLOYMENT READINESS CENTRE STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.1 DEPLOYMENT READINESS CENTRE STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

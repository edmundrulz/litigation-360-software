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

$Phase=Join-Path $Root "_operations\phase-10X5-executive-deployment-dashboard"
$Reports=Join-Path $Phase "reports"
$Dashboards=Join-Path $Phase "dashboards"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $Reports,$Dashboards,$Backups,$Logs,$Docs,$Validation,$Auto,$Routes,$EnterprisePages,$EnterpriseApi | Out-Null

$Engine=Join-Path $Auto "executiveDeploymentDashboardEngine.js"
$Route=Join-Path $Routes "executiveDeploymentDashboardRoutes.js"
$FrontendApiFile=Join-Path $EnterpriseApi "deploymentDashboardApi.js"
$FrontendPage=Join-Path $EnterprisePages "ExecutiveDeploymentDashboard.jsx"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.5 EXECUTIVE DEPLOYMENT DASHBOARD"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

foreach($r in @("deploymentScoringEngine.js","deploymentReadinessCentre.js","environmentValidationEngine.js","releaseValidatorEngine.js")){
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
const DASHBOARD_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X5-executive-deployment-dashboard", "dashboards");
fs.mkdirSync(DASHBOARD_DIR, { recursive: true });

const metrics = {
  dashboardsGenerated: 0,
  summariesGenerated: 0,
  lastGeneratedAt: null
};

function safeCall(name, fn) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, name };
  }
}

function generateExecutiveDeploymentDashboard() {
  const scoring = require("./deploymentScoringEngine");
  const deployment = require("./deploymentReadinessCentre");
  const environment = require("./environmentValidationEngine");
  const release = require("./releaseValidatorEngine");
  const monitoring = require("./enterpriseMonitoringEngine");
  const performance = require("./performanceOptimizationEngine");

  const scoringReport = safeCall("scoring", () => scoring.generateScoringReport());
  const scoringReadiness = safeCall("scoringReadiness", () => scoring.getScoringReadiness());
  const deploymentReadiness = safeCall("deployment", () => deployment.calculateDeploymentReadiness());
  const environmentReadiness = safeCall("environment", () => environment.getEnvironmentReadiness());
  const releaseValidation = safeCall("release", () => release.validateRelease());
  const monitoringHealth = safeCall("monitoring", () => monitoring.getMonitoringHealth());
  const performanceHealth = safeCall("performance", () => performance.health());

  const approvalStatus =
    scoringReadiness.deploymentReady && scoringReport.releaseApproved
      ? "APPROVED_FOR_DEPLOYMENT"
      : "NOT_APPROVED";

  const executiveSummary = {
    deploymentStatus: scoringReadiness.status,
    approvalStatus,
    overallScore: scoringReport.overallScore,
    enterpriseGrade: scoringReport.enterpriseGrade,
    risk: scoringReport.risk,
    deploymentReady: scoringReadiness.deploymentReady,
    releaseApproved: scoringReport.releaseApproved,
    blockers: scoringReport.blockerCount || 0,
    warnings: scoringReport.warningCount || 0,
    plainEnglish: approvalStatus === "APPROVED_FOR_DEPLOYMENT"
      ? `Deployment approved. Score ${scoringReport.overallScore}. Grade ${scoringReport.enterpriseGrade}. Risk ${scoringReport.risk}.`
      : `Deployment not approved. Score ${scoringReport.overallScore}. Grade ${scoringReport.enterpriseGrade}. Blockers ${scoringReport.blockerCount}.`
  };

  const dashboard = {
    module: "Executive Deployment Dashboard",
    status: approvalStatus,
    executiveSummary,
    panels: {
      scoring: scoringReport,
      scoringReadiness,
      deploymentReadiness,
      environmentReadiness,
      releaseValidation,
      monitoringHealth,
      performanceHealth,
      specialOperations: {
        industrialCourtKualaLumpur: "MONITORED",
        perkesoKualaLumpur: "MONITORED",
        perkesoHeadquartersJalanAmpang: "MONITORED",
        mapsIntegration: "MONITORED",
        courtNavigation: "MONITORED"
      }
    },
    generatedAt: new Date().toISOString()
  };

  metrics.dashboardsGenerated += 1;
  metrics.lastGeneratedAt = dashboard.generatedAt;

  fs.writeFileSync(path.join(DASHBOARD_DIR, "latest-executive-deployment-dashboard.json"), JSON.stringify(dashboard, null, 2));
  return dashboard;
}

function getExecutiveDeploymentSummary() {
  const dashboard = generateExecutiveDeploymentDashboard();
  metrics.summariesGenerated += 1;

  return {
    module: "Executive Deployment Summary",
    status: dashboard.status,
    ...dashboard.executiveSummary,
    generatedAt: new Date().toISOString()
  };
}

function getExecutiveDeploymentHealth() {
  const summary = getExecutiveDeploymentSummary();

  return {
    module: "Executive Deployment Dashboard Engine",
    status: summary.status,
    overallScore: summary.overallScore,
    enterpriseGrade: summary.enterpriseGrade,
    risk: summary.risk,
    deploymentReady: summary.deploymentReady,
    releaseApproved: summary.releaseApproved,
    dashboardsGenerated: metrics.dashboardsGenerated,
    summariesGenerated: metrics.summariesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getExecutiveDeploymentMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  generateExecutiveDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getExecutiveDeploymentHealth,
  getExecutiveDeploymentMetrics
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateExecutiveDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getExecutiveDeploymentHealth,
  getExecutiveDeploymentMetrics
} = require("../automation/executiveDeploymentDashboardEngine");

router.get("/health", (req, res) => res.json(getExecutiveDeploymentHealth()));
router.get("/metrics", (req, res) => res.json(getExecutiveDeploymentMetrics()));
router.get("/dashboard", (req, res) => res.json(generateExecutiveDeploymentDashboard()));
router.get("/summary", (req, res) => res.json(getExecutiveDeploymentSummary()));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/executive-deployment", require("./routes/executiveDeploymentDashboardRoutes"));'
  if($txt -notlike '*executiveDeploymentDashboardRoutes*'){
    if($txt -like '*deploymentScoringRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/scoring",\s*require\("\./routes/deploymentScoringRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10X.5 Executive Deployment Dashboard Route`r`n"+$mount+"`r`n"
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

export async function getExecutiveDeploymentDashboard() {
  return await getJson("/api/enterprise/executive-deployment/dashboard");
}

export async function getExecutiveDeploymentSummary() {
  return await getJson("/api/enterprise/executive-deployment/summary");
}

export async function getExecutiveDeploymentHealth() {
  return await getJson("/api/enterprise/executive-deployment/health");
}
'@ | Out-File -LiteralPath $FrontendApiFile -Encoding UTF8

@'
import React, { useEffect, useState } from "react";
import { getExecutiveDeploymentDashboard } from "../api/deploymentDashboardApi";

export default function ExecutiveDeploymentDashboard() {
  const [dashboard, setDashboard] = useState(null);
  const [error, setError] = useState(null);

  async function refresh() {
    try {
      setError(null);
      setDashboard(await getExecutiveDeploymentDashboard());
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 30000);
    return () => clearInterval(timer);
  }, []);

  const summary = dashboard?.executiveSummary || {};

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Executive Deployment Dashboard</h1>
      <p>Single executive view of deployment score, release approval, risk, blockers, warnings, monitoring, and performance.</p>

      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>Refresh Now</button>
      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: 16 }}>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Approval</h3>
          <strong>{dashboard?.status || "UNKNOWN"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Overall Score</h3>
          <strong>{summary.overallScore ?? "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Enterprise Grade</h3>
          <strong>{summary.enterpriseGrade || "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Risk</h3>
          <strong>{summary.risk || "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Blockers</h3>
          <strong>{summary.blockers ?? "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Warnings</h3>
          <strong>{summary.warnings ?? "N/A"}</strong>
        </div>
      </div>

      <h2>Plain English Summary</h2>
      <p>{summary.plainEnglish || "Waiting for dashboard data..."}</p>

      <h2>Special Operations Coverage</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur — Jalan Tun Razak</li>
        <li>PERKESO Headquarters — Jalan Ampang</li>
        <li>Maps Integration</li>
        <li>Court Navigation</li>
      </ul>

      <h2>Raw Executive Dashboard</h2>
      <pre style={{ background: "#f5f5f5", padding: 16, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(dashboard, null, 2)}
      </pre>
    </div>
  );
}
'@ | Out-File -LiteralPath $FrontendPage -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10X.5 EXECUTIVE DEPLOYMENT DASHBOARD

## Purpose
Provide one executive command-centre dashboard for deployment approval, score, grade, risk, blockers, warnings, release status, environment status, and performance status.

## Backend Files
- backend\src\automation\executiveDeploymentDashboardEngine.js
- backend\src\routes\executiveDeploymentDashboardRoutes.js

## Frontend Files
- frontend\src\enterprise\api\deploymentDashboardApi.js
- frontend\src\enterprise\pages\ExecutiveDeploymentDashboard.jsx

## Endpoints
- GET /api/enterprise/executive-deployment/health
- GET /api/enterprise/executive-deployment/metrics
- GET /api/enterprise/executive-deployment/dashboard
- GET /api/enterprise/executive-deployment/summary
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10X5-EXECUTIVE-DEPLOYMENT-DASHBOARD.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X5.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const frontendSrc = path.join(root, "frontend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "executiveDeploymentDashboardEngine.js");
const routePath = path.join(src, "routes", "executiveDeploymentDashboardRoutes.js");
const apiPath = path.join(frontendSrc, "enterprise", "api", "deploymentDashboardApi.js");
const pagePath = path.join(frontendSrc, "enterprise", "pages", "ExecutiveDeploymentDashboard.jsx");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Executive Deployment Dashboard Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const dashboard = engine.generateExecutiveDeploymentDashboard();
const summary = engine.getExecutiveDeploymentSummary();
const health = engine.getExecutiveDeploymentHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10X.5",
  module: "Executive Deployment Dashboard",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("executiveDeploymentDashboardRoutes"),
    frontendApiExists: fs.existsSync(apiPath),
    frontendPageExists: fs.existsSync(pagePath)
  },
  tests: {
    dashboardGenerated: !!dashboard.executiveSummary,
    summaryGenerated: !!summary.plainEnglish,
    healthGenerated: !!health.status,
    specialCoverageIncluded: JSON.stringify(dashboard).includes("industrialCourtKualaLumpur")
  },
  health,
  summary,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("executiveDeploymentDashboardRoutes") &&
    fs.existsSync(apiPath) &&
    fs.existsSync(pagePath) &&
    !!dashboard.executiveSummary &&
    !!summary.plainEnglish &&
    !!health.status &&
    JSON.stringify(dashboard).includes("industrialCourtKualaLumpur")
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X5-executive-deployment-dashboard-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.5 EXECUTIVE DEPLOYMENT DASHBOARD REPORT",
  "=================================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Frontend API Exists: " + report.files.frontendApiExists,
  "Frontend Page Exists: " + report.files.frontendPageExists,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Summary Generated: " + report.tests.summaryGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Special Coverage Included: " + report.tests.specialCoverageIncluded,
  "Dashboard Status: " + dashboard.status,
  "Overall Score: " + summary.overallScore,
  "Enterprise Grade: " + summary.enterpriseGrade,
  "Risk: " + summary.risk
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
Write-Host "Docs:"
Write-Host $Docs
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10X.5 EXECUTIVE DEPLOYMENT DASHBOARD STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.5 EXECUTIVE DEPLOYMENT DASHBOARD STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

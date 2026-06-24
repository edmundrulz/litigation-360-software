param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Src=Join-Path $Backend "src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10X4-deployment-scoring-engine"
$Reports=Join-Path $Phase "reports"
$Dashboards=Join-Path $Phase "dashboards"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Trends=Join-Path $Phase "trends"

New-Item -ItemType Directory -Force -Path $Reports,$Dashboards,$Backups,$Logs,$Docs,$Validation,$Trends,$Auto,$Routes | Out-Null

$Engine=Join-Path $Auto "deploymentScoringEngine.js"
$Route=Join-Path $Routes "deploymentScoringRoutes.js"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.4 DEPLOYMENT SCORING ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

foreach($r in @("deploymentReadinessCentre.js","environmentValidationEngine.js","releaseValidatorEngine.js","enterpriseMonitoringEngine.js","enterpriseHardeningEngine.js","backupRecoveryEngine.js","performanceOptimizationEngine.js")){
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

@'
const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const SCORE_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10X4-deployment-scoring-engine");
const DASHBOARD_DIR = path.join(SCORE_ROOT, "dashboards");
const TRENDS_DIR = path.join(SCORE_ROOT, "trends");

fs.mkdirSync(DASHBOARD_DIR, { recursive: true });
fs.mkdirSync(TRENDS_DIR, { recursive: true });

const metrics = {
  reportsGenerated: 0,
  dashboardsGenerated: 0,
  readinessChecksGenerated: 0,
  trendsGenerated: 0,
  lastGeneratedAt: null
};

function safeCall(label, fn, fallback = {}) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, label, ...fallback };
  }
}

function clampScore(value) {
  const n = Number(value);
  if (Number.isNaN(n)) return 0;
  return Math.max(0, Math.min(100, Math.round(n)));
}

function scoreFromStatus(status) {
  const s = String(status || "").toUpperCase();
  if (["READY", "HEALTHY", "PASS", "RELEASE_CANDIDATE_READY"].includes(s)) return 100;
  if (["ATTENTION", "WARNING", "MEDIUM"].includes(s)) return 75;
  if (["HIGH_RISK", "CRITICAL"].includes(s)) return 40;
  if (["BLOCKED", "BLOCKER", "FAIL", "ERROR", "RELEASE_BLOCKED"].includes(s)) return 0;
  return 65;
}

function gradeFromScore(score, blocked) {
  if (blocked) return "FAIL";
  if (score >= 97) return "A+";
  if (score >= 90) return "A";
  if (score >= 80) return "B";
  if (score >= 70) return "C";
  if (score >= 60) return "D";
  return "FAIL";
}

function riskFromScore(score, blockers) {
  if (blockers > 0 || score < 60) return "CRITICAL";
  if (score < 70) return "HIGH";
  if (score < 85) return "MEDIUM";
  return "LOW";
}

function loadArchitectureCriticality() {
  const file = path.join(PROJECT_ROOT, "_operations", "enterprise-architecture", "registries", "criticality-registry.json");
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return null;
  }
}

function collectScoreInputs() {
  const deploymentCentre = require("./deploymentReadinessCentre");
  const environment = require("./environmentValidationEngine");
  const release = require("./releaseValidatorEngine");
  const monitoring = require("./enterpriseMonitoringEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");
  const performance = require("./performanceOptimizationEngine");

  return {
    deployment: safeCall("deployment", () => deploymentCentre.calculateDeploymentReadiness()),
    environment: safeCall("environment", () => environment.getEnvironmentReadiness()),
    release: safeCall("release", () => release.validateRelease()),
    monitoring: safeCall("monitoring", () => monitoring.getMonitoringHealth()),
    hardening: safeCall("hardening", () => hardening.getDeploymentReadiness()),
    backup: safeCall("backup", () => backup.getBackupRecoveryHealth()),
    performance: safeCall("performance", () => performance.health()),
    architecture: loadArchitectureCriticality()
  };
}

function calculateCategoryScores(inputs) {
  const deploymentScore = clampScore(inputs.deployment.deploymentScore);
  const environmentScore = clampScore(inputs.environment.environmentScore);
  const releaseScore = clampScore(inputs.release.releaseScore);
  const monitoringScore = clampScore(inputs.monitoring.healthScore);
  const hardeningScore = clampScore(inputs.hardening.healthScore);
  const backupScore = scoreFromStatus(inputs.backup.status);
  const performanceScore = scoreFromStatus(inputs.performance.status);
  const architectureScore = inputs.architecture ? 100 : 50;

  return {
    deployment: deploymentScore,
    environment: environmentScore,
    release: releaseScore,
    monitoring: monitoringScore,
    hardening: hardeningScore,
    backupRecovery: backupScore,
    performance: performanceScore,
    architecture: architectureScore,
    operations: clampScore((monitoringScore + backupScore + performanceScore) / 3),
    security: hardeningScore,
    database: inputs.deployment.keyCounts?.databaseTables > 0 || inputs.environment.deploymentReady ? 90 : 60,
    workflow: inputs.architecture?.systemCriticality ? 90 : 70
  };
}

function detectBlockers(inputs, categoryScores) {
  const blockers = [];
  const warnings = [];

  function add(condition, text, severity = "blocker") {
    if (!condition) return;
    if (severity === "warning") warnings.push(text);
    else blockers.push(text);
  }

  add(String(inputs.hardening.status || "").toUpperCase() === "BLOCKED", "Hardening is BLOCKED.");
  add(String(inputs.release.status || "").toUpperCase() === "RELEASE_BLOCKED", "Release validator is BLOCKED.");
  add(String(inputs.environment.risk || "").toUpperCase() === "CRITICAL", "Environment risk is CRITICAL.");
  add(String(inputs.monitoring.status || "").toUpperCase() === "CRITICAL", "Monitoring is CRITICAL.");
  add(String(inputs.backup.status || "").toUpperCase() === "FAIL", "Backup recovery failed.");
  add(String(inputs.performance.status || "").toUpperCase() === "FAIL", "Performance benchmark failed.");

  add(categoryScores.deployment < 75, "Deployment score below 75.", "warning");
  add(categoryScores.environment < 75, "Environment score below 75.", "warning");
  add(categoryScores.release < 75, "Release score below 75.", "warning");
  add(categoryScores.architecture < 80, "Architecture registry incomplete.", "warning");

  return { blockers, warnings };
}

function calculateOverallScore(categoryScores) {
  const weights = {
    deployment: 18,
    environment: 12,
    release: 18,
    monitoring: 10,
    hardening: 14,
    backupRecovery: 8,
    performance: 8,
    architecture: 7,
    workflow: 5
  };

  let weighted = 0;
  let total = 0;

  for (const [key, weight] of Object.entries(weights)) {
    weighted += clampScore(categoryScores[key]) * weight;
    total += weight;
  }

  return clampScore(weighted / Math.max(1, total));
}

function generateScoringReport() {
  const inputs = collectScoreInputs();
  const categoryScores = calculateCategoryScores(inputs);
  const { blockers, warnings } = detectBlockers(inputs, categoryScores);
  const overallScore = calculateOverallScore(categoryScores);
  const risk = riskFromScore(overallScore, blockers.length);
  const enterpriseGrade = gradeFromScore(overallScore, blockers.length > 0);
  const deploymentReady = overallScore >= 85 && blockers.length === 0;
  const releaseApproved = deploymentReady && String(inputs.release.status).toUpperCase() === "RELEASE_CANDIDATE_READY";

  metrics.reportsGenerated += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  const report = {
    module: "Deployment Scoring Engine",
    status: deploymentReady ? "READY" : "NOT_READY",
    deploymentReady,
    enterpriseReady: deploymentReady,
    releaseApproved,
    overallScore,
    enterpriseGrade,
    risk,
    categoryScores,
    blockers,
    blockerCount: blockers.length,
    warnings,
    warningCount: warnings.length,
    inputs,
    generatedAt: metrics.lastGeneratedAt
  };

  fs.writeFileSync(path.join(DASHBOARD_DIR, "latest-deployment-scoring-report.json"), JSON.stringify(report, null, 2));
  writeTrend(report);

  return report;
}

function writeTrend(report) {
  const latestFile = path.join(TRENDS_DIR, "latest-score.json");
  let previous = null;

  try {
    previous = JSON.parse(fs.readFileSync(latestFile, "utf8"));
  } catch {}

  const trend = {
    timestamp: report.generatedAt,
    currentScore: report.overallScore,
    previousScore: previous ? previous.currentScore : null,
    change: previous ? report.overallScore - previous.currentScore : 0,
    direction: !previous ? "BASELINE" : report.overallScore > previous.currentScore ? "IMPROVING" : report.overallScore < previous.currentScore ? "DECLINING" : "STABLE",
    grade: report.enterpriseGrade,
    risk: report.risk
  };

  fs.writeFileSync(path.join(TRENDS_DIR, `score-${report.generatedAt.replace(/[:.]/g, "-")}.json`), JSON.stringify(trend, null, 2));
  fs.writeFileSync(latestFile, JSON.stringify(trend, null, 2));

  return trend;
}

function getScoringDashboard() {
  const report = generateScoringReport();
  metrics.dashboardsGenerated += 1;

  return {
    module: "Enterprise Deployment Scoring Dashboard",
    status: report.status,
    overallScore: report.overallScore,
    enterpriseGrade: report.enterpriseGrade,
    risk: report.risk,
    deploymentReady: report.deploymentReady,
    releaseApproved: report.releaseApproved,
    categoryScores: report.categoryScores,
    blockers: report.blockers,
    warnings: report.warnings,
    generatedAt: new Date().toISOString()
  };
}

function getScoringReadiness() {
  const report = generateScoringReport();
  metrics.readinessChecksGenerated += 1;

  return {
    module: "Scoring Readiness",
    status: report.deploymentReady ? "READY" : "BLOCKED",
    deploymentReady: report.deploymentReady,
    releaseApproved: report.releaseApproved,
    overallScore: report.overallScore,
    enterpriseGrade: report.enterpriseGrade,
    risk: report.risk,
    blockerCount: report.blockerCount,
    warningCount: report.warningCount,
    timestamp: new Date().toISOString()
  };
}

function getEnterpriseGrade() {
  const report = generateScoringReport();
  return {
    module: "Enterprise Grade Engine",
    grade: report.enterpriseGrade,
    overallScore: report.overallScore,
    risk: report.risk,
    deploymentReady: report.deploymentReady,
    timestamp: new Date().toISOString()
  };
}

function getTrends() {
  metrics.trendsGenerated += 1;
  const latest = path.join(TRENDS_DIR, "latest-score.json");
  try {
    return JSON.parse(fs.readFileSync(latest, "utf8"));
  } catch {
    const report = generateScoringReport();
    return writeTrend(report);
  }
}

function getScoringHealth() {
  const readiness = getScoringReadiness();

  return {
    module: "Deployment Scoring Engine",
    status: readiness.status,
    overallScore: readiness.overallScore,
    enterpriseGrade: readiness.enterpriseGrade,
    risk: readiness.risk,
    deploymentReady: readiness.deploymentReady,
    releaseApproved: readiness.releaseApproved,
    reportsGenerated: metrics.reportsGenerated,
    dashboardsGenerated: metrics.dashboardsGenerated,
    readinessChecksGenerated: metrics.readinessChecksGenerated,
    trendsGenerated: metrics.trendsGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getScoringMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  collectScoreInputs,
  calculateCategoryScores,
  generateScoringReport,
  getScoringDashboard,
  getScoringReadiness,
  getEnterpriseGrade,
  getTrends,
  getScoringHealth,
  getScoringMetrics
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateScoringReport,
  getScoringDashboard,
  getScoringReadiness,
  getEnterpriseGrade,
  getTrends,
  getScoringHealth,
  getScoringMetrics
} = require("../automation/deploymentScoringEngine");

router.get("/health", (req, res) => res.json(getScoringHealth()));
router.get("/metrics", (req, res) => res.json(getScoringMetrics()));
router.get("/report", (req, res) => res.json(generateScoringReport()));
router.get("/dashboard", (req, res) => res.json(getScoringDashboard()));
router.get("/readiness", (req, res) => res.json(getScoringReadiness()));
router.get("/grade", (req, res) => res.json(getEnterpriseGrade()));
router.get("/trends", (req, res) => res.json(getTrends()));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/scoring", require("./routes/deploymentScoringRoutes"));'
  if($txt -notlike '*deploymentScoringRoutes*'){
    if($txt -like '*releaseValidatorRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/release",\s*require\("\./routes/releaseValidatorRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10X.4 Deployment Scoring Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }

@"
# ENTERPRISE SCORING PROTOCOL

## Purpose
Calculate one authoritative enterprise deployment score.

## Inputs
- Deployment Readiness Centre
- Environment Validation
- Release Validator
- Monitoring
- Hardening
- Backup Recovery
- Performance
- Architecture Registry

## Outputs
- Overall score
- Enterprise grade
- Risk level
- Deployment readiness
- Release approval
- Blockers
- Warnings
"@ | Out-File -LiteralPath (Join-Path $Docs "ENTERPRISE-SCORING-PROTOCOL.md") -Encoding UTF8

@"
# ENTERPRISE GRADE MODEL

A+ = 97-100
A  = 90-96
B  = 80-89
C  = 70-79
D  = 60-69
FAIL = Below 60 or blockers present
"@ | Out-File -LiteralPath (Join-Path $Docs "ENTERPRISE-GRADE-MODEL.md") -Encoding UTF8

@"
# ENTERPRISE RISK MODEL

LOW = score >= 85 and no blockers
MEDIUM = score 70-84
HIGH = score 60-69
CRITICAL = score below 60 or blockers present
"@ | Out-File -LiteralPath (Join-Path $Docs "ENTERPRISE-RISK-MODEL.md") -Encoding UTF8

@"
# ENTERPRISE DEPLOYMENT CRITERIA

Deployment can be approved only when:
- Overall score >= 85
- No blockers
- Hardening not blocked
- Release not blocked
- Environment not critical
- Monitoring not critical
- Backup not failed
- Performance not failed
"@ | Out-File -LiteralPath (Join-Path $Docs "ENTERPRISE-DEPLOYMENT-CRITERIA.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X4.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "deploymentScoringEngine.js");
const routePath = path.join(src, "routes", "deploymentScoringRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Deployment Scoring Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const report = engine.generateScoringReport();
const dashboard = engine.getScoringDashboard();
const readiness = engine.getScoringReadiness();
const grade = engine.getEnterpriseGrade();
const trends = engine.getTrends();
const health = engine.getScoringHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const validation = {
  phase: "10X.4",
  module: "Deployment Scoring Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("deploymentScoringRoutes")
  },
  tests: {
    reportGenerated: typeof report.overallScore === "number",
    dashboardGenerated: typeof dashboard.overallScore === "number",
    readinessGenerated: !!readiness.status,
    gradeGenerated: !!grade.grade,
    trendsGenerated: !!trends.direction,
    healthGenerated: !!health.status
  },
  health,
  readiness,
  grade,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("deploymentScoringRoutes") &&
    typeof report.overallScore === "number" &&
    typeof dashboard.overallScore === "number" &&
    !!readiness.status &&
    !!grade.grade &&
    !!trends.direction &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X4-deployment-scoring-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.4 DEPLOYMENT SCORING ENGINE REPORT",
  "============================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Engine Exists: " + validation.files.engineExists,
  "Route Exists: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Report Generated: " + validation.tests.reportGenerated,
  "Dashboard Generated: " + validation.tests.dashboardGenerated,
  "Readiness Generated: " + validation.tests.readinessGenerated,
  "Grade Generated: " + validation.tests.gradeGenerated,
  "Trends Generated: " + validation.tests.trendsGenerated,
  "Health Generated: " + validation.tests.healthGenerated,
  "Overall Score: " + report.overallScore,
  "Enterprise Grade: " + report.enterpriseGrade,
  "Risk: " + report.risk,
  "Deployment Ready: " + report.deploymentReady,
  "Release Approved: " + report.releaseApproved,
  "Blockers: " + report.blockerCount,
  "Warnings: " + report.warningCount
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
Write-Host "Trends:"
Write-Host $Trends
Write-Host ""
Write-Host "Docs:"
Write-Host $Docs
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10X.4 DEPLOYMENT SCORING ENGINE STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.4 DEPLOYMENT SCORING ENGINE STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

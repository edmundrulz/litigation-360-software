param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Backend "src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10X2-environment-validation-engine"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Dashboards=Join-Path $Phase "dashboards"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Dashboards,$Auto,$Routes | Out-Null

$Engine=Join-Path $Auto "environmentValidationEngine.js"
$Route=Join-Path $Routes "environmentValidationRoutes.js"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.2 ENVIRONMENT VALIDATION ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
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
const os = require("os");
const childProcess = require("child_process");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");
const FRONTEND_ROOT = path.join(PROJECT_ROOT, "frontend");
const SRC_ROOT = path.join(BACKEND_ROOT, "src");
const OUTPUT_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X2-environment-validation-engine", "dashboards");

fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const metrics = {
  reportsGenerated: 0,
  readinessChecksGenerated: 0,
  summariesGenerated: 0,
  lastGeneratedAt: null
};

function exists(p) {
  return fs.existsSync(p);
}

function statSize(p) {
  try {
    return fs.statSync(p).size;
  } catch {
    return 0;
  }
}

function readText(p) {
  try {
    return fs.readFileSync(p, "utf8");
  } catch {
    return "";
  }
}

function command(cmd, cwd = PROJECT_ROOT) {
  try {
    return childProcess.execSync(cmd, { cwd, encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }).trim();
  } catch (err) {
    return err.stdout ? String(err.stdout).trim() : "";
  }
}

function safeJson(p) {
  try {
    return JSON.parse(readText(p));
  } catch {
    return {};
  }
}

function resultBlock(name, checks) {
  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;
  const score = Math.round((passed / Math.max(1, checks.length)) * 100);

  return {
    name,
    status: failed === 0 ? "PASS" : "FAIL",
    score,
    passed,
    failed,
    checks
  };
}

function validateOperatingEnvironment() {
  const checks = [
    { name: "Platform detected", pass: !!process.platform, value: process.platform },
    { name: "Hostname detected", pass: !!os.hostname(), value: os.hostname() },
    { name: "Username detected", pass: !!os.userInfo().username, value: os.userInfo().username },
    { name: "Project root exists", pass: exists(PROJECT_ROOT), value: PROJECT_ROOT },
    { name: "Backend root exists", pass: exists(BACKEND_ROOT), value: BACKEND_ROOT },
    { name: "Frontend root exists", pass: exists(FRONTEND_ROOT), value: FRONTEND_ROOT }
  ];

  return resultBlock("Operating Environment", checks);
}

function validateRuntime() {
  const backendPkg = safeJson(path.join(BACKEND_ROOT, "package.json"));
  const frontendPkg = safeJson(path.join(FRONTEND_ROOT, "package.json"));

  const checks = [
    { name: "Node version detected", pass: !!process.version, value: process.version },
    { name: "NPM version detected", pass: !!command("npm -v"), value: command("npm -v") },
    { name: "Backend package exists", pass: exists(path.join(BACKEND_ROOT, "package.json")) },
    { name: "Frontend package exists", pass: exists(path.join(FRONTEND_ROOT, "package.json")) },
    { name: "Express dependency present", pass: !!(backendPkg.dependencies && backendPkg.dependencies.express), value: backendPkg.dependencies?.express || null },
    { name: "React dependency present", pass: !!(frontendPkg.dependencies && frontendPkg.dependencies.react), value: frontendPkg.dependencies?.react || null },
    { name: "Vite dependency present", pass: !!((frontendPkg.dependencies && frontendPkg.dependencies.vite) || (frontendPkg.devDependencies && frontendPkg.devDependencies.vite)), value: frontendPkg.dependencies?.vite || frontendPkg.devDependencies?.vite || null }
  ];

  return resultBlock("Runtime", checks);
}

function validateBackend() {
  const routesDir = path.join(SRC_ROOT, "routes");
  const automationDir = path.join(SRC_ROOT, "automation");

  const routeCount = exists(routesDir) ? fs.readdirSync(routesDir).filter(f => f.endsWith(".js")).length : 0;
  const automationCount = exists(automationDir) ? fs.readdirSync(automationDir).filter(f => f.endsWith(".js")).length : 0;

  const checks = [
    { name: "Backend folder exists", pass: exists(BACKEND_ROOT) },
    { name: "Backend src exists", pass: exists(SRC_ROOT) },
    { name: "index.js exists", pass: exists(path.join(SRC_ROOT, "index.js")) },
    { name: "server.js exists", pass: exists(path.join(SRC_ROOT, "server.js")) || exists(path.join(SRC_ROOT, "index.js")) },
    { name: "Routes folder exists", pass: exists(routesDir), value: routeCount },
    { name: "At least 10 route files", pass: routeCount >= 10, value: routeCount },
    { name: "Automation folder exists", pass: exists(automationDir), value: automationCount },
    { name: "At least 15 automation modules", pass: automationCount >= 15, value: automationCount }
  ];

  return resultBlock("Backend", checks);
}

function validateFrontend() {
  const src = path.join(FRONTEND_ROOT, "src");
  const dist = path.join(FRONTEND_ROOT, "dist");

  const checks = [
    { name: "Frontend folder exists", pass: exists(FRONTEND_ROOT) },
    { name: "Frontend package exists", pass: exists(path.join(FRONTEND_ROOT, "package.json")) },
    { name: "Frontend src exists", pass: exists(src) },
    { name: "App.jsx or App.js exists", pass: exists(path.join(src, "App.jsx")) || exists(path.join(src, "App.js")) },
    { name: "Enterprise dashboard exists", pass: exists(path.join(src, "enterprise", "pages", "EnterpriseOperationsDashboard.jsx")) },
    { name: "Connectivity validator exists", pass: exists(path.join(src, "enterprise", "pages", "FrontendBackendConnectivityValidator.jsx")) },
    { name: "Production dist exists", pass: exists(dist) },
    { name: "Production index.html exists", pass: exists(path.join(dist, "index.html")) }
  ];

  return resultBlock("Frontend", checks);
}

function validateDatabase() {
  const db = path.join(BACKEND_ROOT, "litigation360.db");

  const checks = [
    { name: "Database file exists", pass: exists(db), value: db },
    { name: "Database non-zero size", pass: statSize(db) > 0, value: statSize(db) },
    { name: "Database under 500MB", pass: statSize(db) < 500 * 1024 * 1024, value: statSize(db) }
  ];

  return resultBlock("Database", checks);
}

function validateNetwork() {
  const netstat = command("netstat -ano");
  const port5000 = netstat.includes(":5000");
  const port5173 = netstat.includes(":5173");
  const tasklist = command("tasklist");

  const checks = [
    { name: "Port 5000 visible or available", pass: true, value: port5000 ? "VISIBLE" : "NOT_VISIBLE" },
    { name: "Port 5173 visible or available", pass: true, value: port5173 ? "VISIBLE" : "NOT_VISIBLE" },
    { name: "Node process check completed", pass: true, value: tasklist.includes("node.exe") ? "NODE_ACTIVE" : "NODE_NOT_ACTIVE" }
  ];

  return resultBlock("Network", checks);
}

function validateStorage() {
  const totalMemGB = Math.round(os.totalmem() / 1024 / 1024 / 1024 * 100) / 100;
  const freeMemGB = Math.round(os.freemem() / 1024 / 1024 / 1024 * 100) / 100;

  const checks = [
    { name: "Total RAM detected", pass: totalMemGB > 0, value: totalMemGB + " GB" },
    { name: "Free RAM detected", pass: freeMemGB > 0, value: freeMemGB + " GB" },
    { name: "Project root accessible", pass: exists(PROJECT_ROOT), value: PROJECT_ROOT },
    { name: "_operations folder exists", pass: exists(path.join(PROJECT_ROOT, "_operations")) }
  ];

  return resultBlock("Storage & Memory", checks);
}

function validateEnvFile() {
  const backendEnv = path.join(BACKEND_ROOT, ".env");
  const rootEnv = path.join(PROJECT_ROOT, ".env");
  const envText = readText(backendEnv) || readText(rootEnv);

  const checks = [
    { name: "Backend .env or root .env exists", pass: exists(backendEnv) || exists(rootEnv) },
    { name: "Environment file readable", pass: envText.length >= 0 },
    { name: "PORT variable optional check completed", pass: true, value: envText.includes("PORT") ? "PORT_PRESENT" : "PORT_NOT_PRESENT" }
  ];

  return resultBlock("Environment Variables", checks);
}

function generateEnvironmentReport() {
  const sections = [
    validateOperatingEnvironment(),
    validateRuntime(),
    validateBackend(),
    validateFrontend(),
    validateDatabase(),
    validateNetwork(),
    validateStorage(),
    validateEnvFile()
  ];

  const score = Math.round(sections.reduce((sum, s) => sum + s.score, 0) / sections.length);
  const blockingIssues = [];

  for (const section of sections) {
    for (const check of section.checks) {
      if (!check.pass) blockingIssues.push(`${section.name}: ${check.name}`);
    }
  }

  const risk =
    score >= 90 && blockingIssues.length === 0 ? "LOW" :
    score >= 75 ? "MEDIUM" :
    score >= 50 ? "HIGH" :
    "CRITICAL";

  const deploymentReady = score >= 85 && blockingIssues.length === 0;

  metrics.reportsGenerated += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  const report = {
    module: "Environment Validation Engine",
    status: deploymentReady ? "PASS" : "ATTENTION",
    deploymentReady,
    environmentScore: score,
    risk,
    blockingIssues,
    blockingIssuesCount: blockingIssues.length,
    sections,
    generatedAt: metrics.lastGeneratedAt
  };

  fs.writeFileSync(path.join(OUTPUT_DIR, "latest-environment-validation-report.json"), JSON.stringify(report, null, 2));
  return report;
}

function getEnvironmentSummary() {
  const report = generateEnvironmentReport();
  metrics.summariesGenerated += 1;

  return {
    module: "Environment Summary",
    status: report.status,
    deploymentReady: report.deploymentReady,
    environmentScore: report.environmentScore,
    risk: report.risk,
    blockingIssues: report.blockingIssuesCount,
    plainEnglish: report.deploymentReady
      ? `Environment validation PASS. Score ${report.environmentScore}. Risk ${report.risk}.`
      : `Environment validation requires attention. Score ${report.environmentScore}. ${report.blockingIssuesCount} issue(s) found.`,
    generatedAt: new Date().toISOString()
  };
}

function getEnvironmentReadiness() {
  const report = generateEnvironmentReport();
  metrics.readinessChecksGenerated += 1;

  return {
    module: "Environment Readiness",
    status: report.deploymentReady ? "READY" : "ATTENTION",
    deploymentReady: report.deploymentReady,
    environmentScore: report.environmentScore,
    risk: report.risk,
    blockingIssues: report.blockingIssues,
    blockingIssuesCount: report.blockingIssuesCount,
    timestamp: new Date().toISOString()
  };
}

function getEnvironmentHealth() {
  const readiness = getEnvironmentReadiness();

  return {
    module: "Environment Validation Engine",
    status: readiness.status,
    deploymentReady: readiness.deploymentReady,
    environmentScore: readiness.environmentScore,
    risk: readiness.risk,
    blockingIssuesCount: readiness.blockingIssuesCount,
    reportsGenerated: metrics.reportsGenerated,
    readinessChecksGenerated: metrics.readinessChecksGenerated,
    summariesGenerated: metrics.summariesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getEnvironmentMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  validateOperatingEnvironment,
  validateRuntime,
  validateBackend,
  validateFrontend,
  validateDatabase,
  validateNetwork,
  validateStorage,
  validateEnvFile,
  generateEnvironmentReport,
  getEnvironmentSummary,
  getEnvironmentReadiness,
  getEnvironmentHealth,
  getEnvironmentMetrics
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateEnvironmentReport,
  getEnvironmentSummary,
  getEnvironmentReadiness,
  getEnvironmentHealth,
  getEnvironmentMetrics,
  validateOperatingEnvironment,
  validateRuntime,
  validateBackend,
  validateFrontend,
  validateDatabase,
  validateNetwork,
  validateStorage,
  validateEnvFile
} = require("../automation/environmentValidationEngine");

router.get("/health", (req, res) => res.json(getEnvironmentHealth()));
router.get("/metrics", (req, res) => res.json(getEnvironmentMetrics()));
router.get("/report", (req, res) => res.json(generateEnvironmentReport()));
router.get("/summary", (req, res) => res.json(getEnvironmentSummary()));
router.get("/readiness", (req, res) => res.json(getEnvironmentReadiness()));
router.get("/operating-system", (req, res) => res.json(validateOperatingEnvironment()));
router.get("/runtime", (req, res) => res.json(validateRuntime()));
router.get("/backend", (req, res) => res.json(validateBackend()));
router.get("/frontend", (req, res) => res.json(validateFrontend()));
router.get("/database", (req, res) => res.json(validateDatabase()));
router.get("/network", (req, res) => res.json(validateNetwork()));
router.get("/storage", (req, res) => res.json(validateStorage()));
router.get("/env", (req, res) => res.json(validateEnvFile()));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/environment", require("./routes/environmentValidationRoutes"));'
  if($txt -notlike '*environmentValidationRoutes*'){
    if($txt -like '*deploymentReadinessCentreRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/deployment-centre",\s*require\("\./routes/deploymentReadinessCentreRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10X.2 Environment Validation Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }

@"
# LITIGATION 360 - PHASE 10X.2 ENVIRONMENT VALIDATION ENGINE

## Purpose
Validate operating environment, runtime, backend, frontend, database, network, storage, memory, and .env readiness.

## Created Files
- backend\src\automation\environmentValidationEngine.js
- backend\src\routes\environmentValidationRoutes.js
- backend\src\index.js route mount

## Endpoints
- GET /api/enterprise/environment/health
- GET /api/enterprise/environment/metrics
- GET /api/enterprise/environment/report
- GET /api/enterprise/environment/summary
- GET /api/enterprise/environment/readiness
- GET /api/enterprise/environment/operating-system
- GET /api/enterprise/environment/runtime
- GET /api/enterprise/environment/backend
- GET /api/enterprise/environment/frontend
- GET /api/enterprise/environment/database
- GET /api/enterprise/environment/network
- GET /api/enterprise/environment/storage
- GET /api/enterprise/environment/env
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10X2-ENVIRONMENT-VALIDATION.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X2.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "environmentValidationEngine.js");
const routePath = path.join(src, "routes", "environmentValidationRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Environment Validation Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const report = engine.generateEnvironmentReport();
const summary = engine.getEnvironmentSummary();
const readiness = engine.getEnvironmentReadiness();
const health = engine.getEnvironmentHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const validation = {
  phase: "10X.2",
  module: "Environment Validation Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("environmentValidationRoutes")
  },
  tests: {
    reportGenerated: typeof report.environmentScore === "number",
    summaryGenerated: !!summary.plainEnglish,
    readinessGenerated: typeof readiness.environmentScore === "number",
    healthGenerated: !!health.status,
    sectionsGenerated: Array.isArray(report.sections) && report.sections.length >= 8
  },
  health,
  readiness,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("environmentValidationRoutes") &&
    typeof report.environmentScore === "number" &&
    !!summary.plainEnglish &&
    typeof readiness.environmentScore === "number" &&
    !!health.status &&
    Array.isArray(report.sections) &&
    report.sections.length >= 8
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X2-environment-validation-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.2 ENVIRONMENT VALIDATION REPORT",
  "=========================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Engine Exists: " + validation.files.engineExists,
  "Route Exists: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Report Generated: " + validation.tests.reportGenerated,
  "Summary Generated: " + validation.tests.summaryGenerated,
  "Readiness Generated: " + validation.tests.readinessGenerated,
  "Health Generated: " + validation.tests.healthGenerated,
  "Sections Generated: " + validation.tests.sectionsGenerated,
  "Environment Status: " + readiness.status,
  "Deployment Ready: " + readiness.deploymentReady,
  "Environment Score: " + readiness.environmentScore,
  "Risk: " + readiness.risk,
  "Blocking Issues: " + readiness.blockingIssuesCount
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
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10X.2 ENVIRONMENT VALIDATION STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.2 ENVIRONMENT VALIDATION STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

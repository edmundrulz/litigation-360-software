param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Src=Join-Path $Backend "src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10X3-release-validator"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Release=Join-Path $Phase "release-candidates"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Release,$Auto,$Routes | Out-Null

$Engine=Join-Path $Auto "releaseValidatorEngine.js"
$Route=Join-Path $Routes "releaseValidatorRoutes.js"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.3 RELEASE VALIDATOR"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

foreach($r in @("deploymentReadinessCentre.js","environmentValidationEngine.js","enterpriseHardeningEngine.js","backupRecoveryEngine.js","enterpriseMonitoringEngine.js","performanceOptimizationEngine.js")){
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
const crypto = require("crypto");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");
const FRONTEND_ROOT = path.join(PROJECT_ROOT, "frontend");
const RELEASE_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10X3-release-validator", "release-candidates");

fs.mkdirSync(RELEASE_ROOT, { recursive: true });

const metrics = {
  validationsRun: 0,
  candidatesGenerated: 0,
  lastGeneratedAt: null
};

function exists(p) {
  return fs.existsSync(p);
}

function readJson(p) {
  try { return JSON.parse(fs.readFileSync(p, "utf8")); } catch { return {}; }
}

function hashFile(p) {
  if (!exists(p)) return null;
  return crypto.createHash("sha256").update(fs.readFileSync(p)).digest("hex");
}

function scoreBlock(name, checks, weight) {
  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;
  const score = Math.round((passed / Math.max(1, checks.length)) * 100);
  return { name, weight, status: failed === 0 ? "PASS" : "FAIL", score, passed, failed, checks };
}

function validateRelease() {
  const deploymentCentre = require("./deploymentReadinessCentre");
  const environment = require("./environmentValidationEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");
  const monitoring = require("./enterpriseMonitoringEngine");
  const performance = require("./performanceOptimizationEngine");

  const deployment = deploymentCentre.calculateDeploymentReadiness();
  const envReady = environment.getEnvironmentReadiness();
  const hardeningReady = hardening.getDeploymentReadiness();
  const backupHealth = backup.getBackupRecoveryHealth();
  const monitoringHealth = monitoring.getMonitoringHealth();
  const perfHealth = performance.health();

  const backendPkg = readJson(path.join(BACKEND_ROOT, "package.json"));
  const frontendPkg = readJson(path.join(FRONTEND_ROOT, "package.json"));

  const blocks = [
    scoreBlock("Deployment Centre", [
      { name: "Deployment centre generated score", pass: typeof deployment.deploymentScore === "number", value: deployment.deploymentScore },
      { name: "Deployment score >= 75", pass: deployment.deploymentScore >= 75, value: deployment.deploymentScore },
      { name: "Blocking issues below 5", pass: deployment.blockingIssuesCount < 5, value: deployment.blockingIssuesCount }
    ], 20),

    scoreBlock("Environment", [
      { name: "Environment score generated", pass: typeof envReady.environmentScore === "number", value: envReady.environmentScore },
      { name: "Environment score >= 75", pass: envReady.environmentScore >= 75, value: envReady.environmentScore },
      { name: "Environment risk not critical", pass: envReady.risk !== "CRITICAL", value: envReady.risk }
    ], 15),

    scoreBlock("Hardening", [
      { name: "Hardening score generated", pass: typeof hardeningReady.healthScore === "number", value: hardeningReady.healthScore },
      { name: "Hardening score >= 75", pass: hardeningReady.healthScore >= 75, value: hardeningReady.healthScore },
      { name: "Hardening blocking issues below 5", pass: hardeningReady.blockingIssuesCount < 5, value: hardeningReady.blockingIssuesCount }
    ], 15),

    scoreBlock("Backup Recovery", [
      { name: "Backup recovery health generated", pass: !!backupHealth.status, value: backupHealth.status },
      { name: "Backup recovery not failed", pass: backupHealth.status !== "FAIL", value: backupHealth.status },
      { name: "Backup recovery engine available", pass: true }
    ], 10),

    scoreBlock("Monitoring", [
      { name: "Monitoring health generated", pass: !!monitoringHealth.status, value: monitoringHealth.status },
      { name: "Monitoring score generated", pass: typeof monitoringHealth.healthScore === "number", value: monitoringHealth.healthScore },
      { name: "Monitoring not critical", pass: monitoringHealth.status !== "CRITICAL", value: monitoringHealth.status }
    ], 10),

    scoreBlock("Performance", [
      { name: "Performance health generated", pass: !!perfHealth.status, value: perfHealth.status },
      { name: "Performance not failed", pass: perfHealth.status !== "FAIL", value: perfHealth.status },
      { name: "Benchmark max under 5000ms", pass: (perfHealth.maxMs || 0) < 5000, value: perfHealth.maxMs }
    ], 10),

    scoreBlock("Build Artifacts", [
      { name: "Frontend dist exists", pass: exists(path.join(FRONTEND_ROOT, "dist")) },
      { name: "Frontend index.html exists", pass: exists(path.join(FRONTEND_ROOT, "dist", "index.html")) },
      { name: "Backend package exists", pass: exists(path.join(BACKEND_ROOT, "package.json")) },
      { name: "Frontend package exists", pass: exists(path.join(FRONTEND_ROOT, "package.json")) }
    ], 10),

    scoreBlock("Version Registry", [
      { name: "Backend package name present", pass: !!backendPkg.name, value: backendPkg.name || null },
      { name: "Frontend package name present", pass: !!frontendPkg.name, value: frontendPkg.name || null },
      { name: "Node runtime hash inputs available", pass: !!process.version, value: process.version }
    ], 10)
  ];

  const weighted = blocks.reduce((sum, b) => sum + b.score * b.weight, 0);
  const weightTotal = blocks.reduce((sum, b) => sum + b.weight, 0);
  const releaseScore = Math.round(weighted / Math.max(1, weightTotal));

  const blockers = [];
  const warnings = [];

  for (const block of blocks) {
    for (const check of block.checks) {
      if (!check.pass) {
        if (block.weight >= 15) blockers.push(`${block.name}: ${check.name}`);
        else warnings.push(`${block.name}: ${check.name}`);
      }
    }
  }

  const risk =
    releaseScore >= 90 && blockers.length === 0 ? "LOW" :
    releaseScore >= 75 ? "MEDIUM" :
    releaseScore >= 50 ? "HIGH" :
    "CRITICAL";

  const releaseReady = releaseScore >= 80 && blockers.length === 0;

  metrics.validationsRun += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Release Validator Engine",
    status: releaseReady ? "RELEASE_CANDIDATE_READY" : "RELEASE_BLOCKED",
    releaseReady,
    releaseScore,
    risk,
    blockers,
    blockerCount: blockers.length,
    warnings,
    warningCount: warnings.length,
    blocks,
    versions: {
      backend: { name: backendPkg.name || null, version: backendPkg.version || null },
      frontend: { name: frontendPkg.name || null, version: frontendPkg.version || null },
      node: process.version
    },
    hashes: {
      backendPackage: hashFile(path.join(BACKEND_ROOT, "package.json")),
      frontendPackage: hashFile(path.join(FRONTEND_ROOT, "package.json")),
      frontendIndex: hashFile(path.join(FRONTEND_ROOT, "dist", "index.html")),
      database: hashFile(path.join(BACKEND_ROOT, "litigation360.db"))
    },
    generatedAt: metrics.lastGeneratedAt
  };
}

function generateReleaseCandidate(label = "candidate") {
  const validation = validateRelease();
  const id = `RC-${new Date().toISOString().replace(/[:.]/g, "-")}`;
  const release = {
    releaseCandidateId: id,
    label,
    validation,
    generatedAt: new Date().toISOString()
  };

  fs.writeFileSync(path.join(RELEASE_ROOT, `${id}.json`), JSON.stringify(release, null, 2));
  fs.writeFileSync(path.join(RELEASE_ROOT, "latest-release-candidate.json"), JSON.stringify(release, null, 2));

  metrics.candidatesGenerated += 1;
  return release;
}

function getReleaseSummary() {
  const validation = validateRelease();

  return {
    module: "Release Summary",
    status: validation.status,
    releaseReady: validation.releaseReady,
    releaseScore: validation.releaseScore,
    risk: validation.risk,
    blockerCount: validation.blockerCount,
    warningCount: validation.warningCount,
    plainEnglish: validation.releaseReady
      ? `Release candidate is ready. Score ${validation.releaseScore}. Risk ${validation.risk}.`
      : `Release is blocked. Score ${validation.releaseScore}. ${validation.blockerCount} blocker(s) require action.`,
    generatedAt: new Date().toISOString()
  };
}

function getReleaseHealth() {
  const summary = getReleaseSummary();
  return {
    module: "Release Validator Engine",
    status: summary.status,
    releaseReady: summary.releaseReady,
    releaseScore: summary.releaseScore,
    risk: summary.risk,
    blockerCount: summary.blockerCount,
    warningCount: summary.warningCount,
    validationsRun: metrics.validationsRun,
    candidatesGenerated: metrics.candidatesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getReleaseMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  validateRelease,
  generateReleaseCandidate,
  getReleaseSummary,
  getReleaseHealth,
  getReleaseMetrics
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  validateRelease,
  generateReleaseCandidate,
  getReleaseSummary,
  getReleaseHealth,
  getReleaseMetrics
} = require("../automation/releaseValidatorEngine");

router.get("/health", (req, res) => res.json(getReleaseHealth()));
router.get("/metrics", (req, res) => res.json(getReleaseMetrics()));
router.get("/validate", (req, res) => res.json(validateRelease()));
router.get("/summary", (req, res) => res.json(getReleaseSummary()));
router.post("/candidate", (req, res) => res.status(201).json({ ok: true, release: generateReleaseCandidate(req.body?.label || "api") }));
router.get("/test/candidate", (req, res) => res.json({ ok: true, release: generateReleaseCandidate("phase-10X3-test") }));

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/release", require("./routes/releaseValidatorRoutes"));'
  if($txt -notlike '*releaseValidatorRoutes*'){
    if($txt -like '*environmentValidationRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/environment",\s*require\("\./routes/environmentValidationRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10X.3 Release Validator Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }

@"
# LITIGATION 360 - PHASE 10X.3 RELEASE VALIDATOR

## Purpose
Validate whether the current platform state can be labelled as a release candidate.

## Created Files
- backend\src\automation\releaseValidatorEngine.js
- backend\src\routes\releaseValidatorRoutes.js
- backend\src\index.js route mount

## Endpoints
- GET /api/enterprise/release/health
- GET /api/enterprise/release/metrics
- GET /api/enterprise/release/validate
- GET /api/enterprise/release/summary
- POST /api/enterprise/release/candidate
- GET /api/enterprise/release/test/candidate

## Checks
- Deployment Centre
- Environment Validation
- Hardening
- Backup Recovery
- Monitoring
- Performance
- Build Artifacts
- Version Registry
- Release Candidate JSON generation
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10X3-RELEASE-VALIDATOR.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X3.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "releaseValidatorEngine.js");
const routePath = path.join(src, "routes", "releaseValidatorRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Release Validator Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const validation = engine.validateRelease();
const summary = engine.getReleaseSummary();
const health = engine.getReleaseHealth();
const candidate = engine.generateReleaseCandidate("validation");
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10X.3",
  module: "Release Validator",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("releaseValidatorRoutes")
  },
  tests: {
    validationGenerated: typeof validation.releaseScore === "number",
    summaryGenerated: !!summary.plainEnglish,
    healthGenerated: !!health.status,
    candidateGenerated: !!candidate.releaseCandidateId,
    candidateHasValidation: !!candidate.validation
  },
  health,
  validation,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("releaseValidatorRoutes") &&
    typeof validation.releaseScore === "number" &&
    !!summary.plainEnglish &&
    !!health.status &&
    !!candidate.releaseCandidateId &&
    !!candidate.validation
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X3-release-validator-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.3 RELEASE VALIDATOR REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Validation Generated: " + report.tests.validationGenerated,
  "Summary Generated: " + report.tests.summaryGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Candidate Generated: " + report.tests.candidateGenerated,
  "Release Status: " + validation.status,
  "Release Ready: " + validation.releaseReady,
  "Release Score: " + validation.releaseScore,
  "Risk: " + validation.risk,
  "Blockers: " + validation.blockerCount,
  "Warnings: " + validation.warningCount
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
Write-Host "Release Candidates:"
Write-Host $Release
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10X.3 RELEASE VALIDATOR STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.3 RELEASE VALIDATOR STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

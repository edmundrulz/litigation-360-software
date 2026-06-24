param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $Root "backend\src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10O-enterprise-hardening"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Auto,$Routes | Out-Null
$Log=Join-Path $Logs "phase-10O-hardening-log.txt"

function Write-Log($Text){Add-Content -LiteralPath $Log -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup($Path){if(Test-Path -LiteralPath $Path){$name=Split-Path $Path -Leaf;$dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $dest -Force;Write-Log "Backup $Path --> $dest"}}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10O ENTERPRISE HARDENING"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){Write-Host "ERROR: index.js not found";Read-Host "Press Enter";exit 1}

$HardeningEngine=Join-Path $Auto "enterpriseHardeningEngine.js"
$HardeningRoutes=Join-Path $Routes "enterpriseHardeningRoutes.js"

if($Mode -eq "APPLY"){
  Backup $HardeningEngine
  Backup $HardeningRoutes
  Backup $Index

@'
const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..");
const SRC_ROOT = path.join(PROJECT_ROOT, "backend", "src");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");

const REQUIRED_AUTOMATION_FILES = [
  "handlerRegistry.js",
  "eventBus.js",
  "notificationService.js",
  "workflowEngine.js",
  "documentLifecycleEngine.js",
  "courtOperationsEngine.js",
  "matterIntelligenceEngine.js",
  "executiveCommandCentre.js",
  "legalOperationsAssistant.js",
  "predictiveAnalyticsEngine.js",
  "courtNavigationEngine.js",
  "mapsIntegrationLayer.js",
  "autonomousOperationsEngine.js",
  "enterpriseGovernanceEngine.js"
];

const REQUIRED_ROUTE_FILES = [
  "handlerRoutes.js",
  "eventBusRoutes.js",
  "notificationRoutes.js",
  "workflowRoutes.js",
  "documentLifecycleRoutes.js",
  "courtOperationsRoutes.js",
  "matterIntelligenceRoutes.js",
  "executiveCommandRoutes.js",
  "legalOperationsAssistantRoutes.js",
  "predictiveAnalyticsRoutes.js",
  "courtNavigationRoutes.js",
  "mapsIntegrationRoutes.js",
  "autonomousOperationsRoutes.js",
  "enterpriseGovernanceRoutes.js"
];

const REQUIRED_MOUNTS = [
  "handlerRoutes",
  "eventBusRoutes",
  "notificationRoutes",
  "workflowRoutes",
  "documentLifecycleRoutes",
  "courtOperationsRoutes",
  "matterIntelligenceRoutes",
  "executiveCommandRoutes",
  "legalOperationsAssistantRoutes",
  "predictiveAnalyticsRoutes",
  "courtNavigationRoutes",
  "mapsIntegrationRoutes",
  "autonomousOperationsRoutes",
  "enterpriseGovernanceRoutes"
];

const REQUIRED_DATABASE_FILES = [
  "litigation360.db"
];

const hardeningMetrics = {
  validationsRun: 0,
  readinessChecksRun: 0,
  dashboardsGenerated: 0,
  lastRunAt: null
};

function exists(p) {
  return fs.existsSync(p);
}

function fileSize(p) {
  try {
    return fs.statSync(p).size;
  } catch {
    return 0;
  }
}

function validateConfiguration() {
  const packagePath = path.join(BACKEND_ROOT, "package.json");
  const envPath = path.join(BACKEND_ROOT, ".env");
  const indexPath = path.join(SRC_ROOT, "index.js");

  const checks = [
    { name: "backend package.json exists", pass: exists(packagePath), path: packagePath },
    { name: "backend .env exists", pass: exists(envPath), path: envPath },
    { name: "backend src index.js exists", pass: exists(indexPath), path: indexPath }
  ];

  return resultBlock("Configuration", checks);
}

function validateDatabase() {
  const checks = REQUIRED_DATABASE_FILES.map(file => {
    const p = path.join(BACKEND_ROOT, file);
    return {
      name: `${file} exists and non-zero`,
      pass: exists(p) && fileSize(p) > 0,
      path: p,
      size: fileSize(p)
    };
  });

  return resultBlock("Database Integrity", checks);
}

function validateAutomation() {
  const checks = REQUIRED_AUTOMATION_FILES.map(file => {
    const p = path.join(SRC_ROOT, "automation", file);
    return {
      name: `${file} exists`,
      pass: exists(p),
      path: p
    };
  });

  return resultBlock("Automation Integrity", checks);
}

function validateRoutes() {
  const routeChecks = REQUIRED_ROUTE_FILES.map(file => {
    const p = path.join(SRC_ROOT, "routes", file);
    return {
      name: `${file} exists`,
      pass: exists(p),
      path: p
    };
  });

  const indexPath = path.join(SRC_ROOT, "index.js");
  const indexText = exists(indexPath) ? fs.readFileSync(indexPath, "utf8") : "";

  const mountChecks = REQUIRED_MOUNTS.map(mount => ({
    name: `${mount} mounted in index.js`,
    pass: indexText.includes(mount),
    path: indexPath
  }));

  return resultBlock("Route Integrity", [...routeChecks, ...mountChecks]);
}

function validateSecurity() {
  const checks = [
    {
      name: "authentication route exists",
      pass: exists(path.join(SRC_ROOT, "routes", "auth.js")) || exists(path.join(SRC_ROOT, "routes", "sqliteAuth.js"))
    },
    {
      name: "middleware folder exists",
      pass: exists(path.join(SRC_ROOT, "middleware"))
    },
    {
      name: ".env file exists",
      pass: exists(path.join(BACKEND_ROOT, ".env"))
    },
    {
      name: "governance engine exists",
      pass: exists(path.join(SRC_ROOT, "automation", "enterpriseGovernanceEngine.js"))
    }
  ];

  return resultBlock("Security Validation", checks);
}

function validatePerformance() {
  const nodeModules = path.join(BACKEND_ROOT, "node_modules");
  const packageLock = path.join(BACKEND_ROOT, "package-lock.json");

  const checks = [
    { name: "node_modules exists", pass: exists(nodeModules), path: nodeModules },
    { name: "package-lock exists", pass: exists(packageLock), path: packageLock },
    { name: "backend source folder exists", pass: exists(SRC_ROOT), path: SRC_ROOT }
  ];

  return resultBlock("Performance Baseline", checks);
}

function validateStartup() {
  const modules = [
    "handlerRegistry",
    "eventBus",
    "notificationService",
    "workflowEngine",
    "documentLifecycleEngine",
    "courtOperationsEngine",
    "matterIntelligenceEngine",
    "executiveCommandCentre",
    "legalOperationsAssistant",
    "predictiveAnalyticsEngine",
    "courtNavigationEngine",
    "mapsIntegrationLayer",
    "autonomousOperationsEngine",
    "enterpriseGovernanceEngine"
  ];

  const checks = modules.map(moduleName => {
    try {
      require(path.join(SRC_ROOT, "automation", moduleName));
      return { name: `${moduleName} loads`, pass: true };
    } catch (err) {
      return { name: `${moduleName} loads`, pass: false, error: err.message };
    }
  });

  return resultBlock("Startup Validation", checks);
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

function calculateHealthScore(sections) {
  const weights = {
    "Configuration": 5,
    "Database Integrity": 20,
    "Automation Integrity": 20,
    "Route Integrity": 20,
    "Security Validation": 15,
    "Performance Baseline": 10,
    "Startup Validation": 10
  };

  let total = 0;
  let weightTotal = 0;

  for (const section of sections) {
    const weight = weights[section.name] || 5;
    total += section.score * weight;
    weightTotal += weight;
  }

  return Math.round(total / Math.max(1, weightTotal));
}

function getEnterpriseHardeningDashboard() {
  const sections = [
    validateConfiguration(),
    validateDatabase(),
    validateAutomation(),
    validateRoutes(),
    validateSecurity(),
    validatePerformance(),
    validateStartup()
  ];

  const healthScore = calculateHealthScore(sections);
  const failedSections = sections.filter(s => s.status !== "PASS");
  const blockingIssues = [];

  for (const section of sections) {
    for (const check of section.checks) {
      if (!check.pass) blockingIssues.push(`${section.name}: ${check.name}`);
    }
  }

  const status = blockingIssues.length === 0 ? "READY" : "BLOCKED";

  hardeningMetrics.dashboardsGenerated += 1;
  hardeningMetrics.lastRunAt = new Date().toISOString();

  return {
    module: "Enterprise Hardening & Deployment Readiness",
    status,
    deploymentReady: blockingIssues.length === 0,
    healthScore,
    blockingIssues,
    blockingIssuesCount: blockingIssues.length,
    sections,
    generatedAt: hardeningMetrics.lastRunAt
  };
}

function getDeploymentReadiness() {
  hardeningMetrics.readinessChecksRun += 1;
  const dashboard = getEnterpriseHardeningDashboard();

  return {
    module: "Deployment Readiness Engine",
    status: dashboard.status,
    deploymentReady: dashboard.deploymentReady,
    healthScore: dashboard.healthScore,
    blockingIssues: dashboard.blockingIssues,
    blockingIssuesCount: dashboard.blockingIssuesCount,
    warnings: dashboard.sections.filter(s => s.status !== "PASS").length,
    timestamp: new Date().toISOString()
  };
}

function runFullValidation() {
  hardeningMetrics.validationsRun += 1;
  return getEnterpriseHardeningDashboard();
}

function getEnterpriseHealthScore() {
  const dashboard = getEnterpriseHardeningDashboard();
  return {
    module: "Enterprise Health Score Engine",
    status: dashboard.status,
    healthScore: dashboard.healthScore,
    deploymentReady: dashboard.deploymentReady,
    blockingIssuesCount: dashboard.blockingIssuesCount,
    timestamp: new Date().toISOString()
  };
}

function getHardeningHealth() {
  const readiness = getDeploymentReadiness();

  return {
    module: "Enterprise Hardening Engine",
    status: readiness.status,
    healthScore: readiness.healthScore,
    deploymentReady: readiness.deploymentReady,
    blockingIssuesCount: readiness.blockingIssuesCount,
    validationsRun: hardeningMetrics.validationsRun,
    readinessChecksRun: hardeningMetrics.readinessChecksRun,
    dashboardsGenerated: hardeningMetrics.dashboardsGenerated,
    lastRunAt: hardeningMetrics.lastRunAt,
    timestamp: new Date().toISOString()
  };
}

function getHardeningMetrics() {
  return {
    ...hardeningMetrics,
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  validateConfiguration,
  validateDatabase,
  validateAutomation,
  validateRoutes,
  validateSecurity,
  validatePerformance,
  validateStartup,
  runFullValidation,
  getEnterpriseHardeningDashboard,
  getDeploymentReadiness,
  getEnterpriseHealthScore,
  getHardeningHealth,
  getHardeningMetrics
};
'@ | Out-File -LiteralPath $HardeningEngine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  validateConfiguration,
  validateDatabase,
  validateAutomation,
  validateRoutes,
  validateSecurity,
  validatePerformance,
  validateStartup,
  runFullValidation,
  getEnterpriseHardeningDashboard,
  getDeploymentReadiness,
  getEnterpriseHealthScore,
  getHardeningHealth,
  getHardeningMetrics
} = require("../automation/enterpriseHardeningEngine");

router.get("/health", (req, res) => res.json(getHardeningHealth()));
router.get("/metrics", (req, res) => res.json(getHardeningMetrics()));
router.get("/dashboard", (req, res) => res.json(getEnterpriseHardeningDashboard()));
router.get("/validate", (req, res) => res.json(runFullValidation()));
router.get("/healthscore", (req, res) => res.json(getEnterpriseHealthScore()));
router.get("/deployment/readiness", (req, res) => res.json(getDeploymentReadiness()));
router.get("/startup/validate", (req, res) => res.json(validateStartup()));
router.get("/configuration/validate", (req, res) => res.json(validateConfiguration()));
router.get("/database/validate", (req, res) => res.json(validateDatabase()));
router.get("/routes/validate", (req, res) => res.json(validateRoutes()));
router.get("/automation/validate", (req, res) => res.json(validateAutomation()));
router.get("/security/validate", (req, res) => res.json(validateSecurity()));
router.get("/performance/validate", (req, res) => res.json(validatePerformance()));

module.exports = router;
'@ | Out-File -LiteralPath $HardeningRoutes -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/hardening", require("./routes/enterpriseHardeningRoutes"));'
  if($txt -notlike '*enterpriseHardeningRoutes*'){
    if($txt -like '*enterpriseGovernanceRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/governance",\s*require\("\./routes/enterpriseGovernanceRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10O Enterprise Hardening Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }
}

$Validate=Join-Path $Validation "validate-phase10O-hardening.js"
@'
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10O-enterprise-hardening", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "enterpriseHardeningEngine.js");
const routePath = path.join(src, "routes", "enterpriseHardeningRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Enterprise Hardening Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const validation = engine.runFullValidation();
const readiness = engine.getDeploymentReadiness();
const healthScore = engine.getEnterpriseHealthScore();
const health = engine.getHardeningHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10O",
  module: "Enterprise Hardening",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseHardeningRoutes")
  },
  validation,
  readiness,
  healthScore,
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseHardeningRoutes") &&
    typeof readiness.healthScore === "number" &&
    typeof healthScore.healthScore === "number" &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10O-hardening-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10O ENTERPRISE HARDENING REPORT",
  "======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Deployment Status: " + readiness.status,
  "Deployment Ready: " + readiness.deploymentReady,
  "Health Score: " + readiness.healthScore,
  "Blocking Issues: " + readiness.blockingIssuesCount,
  "Hardening Health: " + health.status
];

fs.writeFileSync(path.join(reports, "phase10O-hardening-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10O ENTERPRISE HARDENING

## Purpose
Create deployment readiness, validation, enterprise health score, startup validation, route validation, database validation, automation validation, security validation, and performance validation.

## Created Files
- backend\src\automation\enterpriseHardeningEngine.js
- backend\src\routes\enterpriseHardeningRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/hardening/health
- GET /api/enterprise/hardening/metrics
- GET /api/enterprise/hardening/dashboard
- GET /api/enterprise/hardening/validate
- GET /api/enterprise/hardening/healthscore
- GET /api/enterprise/hardening/deployment/readiness
- GET /api/enterprise/hardening/startup/validate
- GET /api/enterprise/hardening/configuration/validate
- GET /api/enterprise/hardening/database/validate
- GET /api/enterprise/hardening/routes/validate
- GET /api/enterprise/hardening/automation/validate
- GET /api/enterprise/hardening/security/validate
- GET /api/enterprise/hardening/performance/validate
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10O-HARDENING-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10O ENTERPRISE HARDENING STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10O ENTERPRISE HARDENING STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit

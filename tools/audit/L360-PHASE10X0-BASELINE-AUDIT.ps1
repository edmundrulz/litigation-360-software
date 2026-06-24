param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Frontend=Join-Path $Root "frontend"
$Phase=Join-Path $Root "_operations\phase-10X0-deployment-readiness-baseline-audit"
$Reports=Join-Path $Phase "reports"
$Registries=Join-Path $Phase "registries"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Backups=Join-Path $Phase "backups"
$AuditScript=Join-Path $Root "PHASE10X0-BASELINE-AUDIT.js"

New-Item -ItemType Directory -Force -Path $Reports,$Registries,$Logs,$Docs,$Validation,$Backups | Out-Null

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.0 DEPLOYMENT READINESS BASELINE AUDIT"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project Root: $Root"
Write-Host ""

if(!(Test-Path -LiteralPath $Root)){
  Write-Host "ERROR: Project root not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath $Backend)){
  Write-Host "ERROR: backend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $AuditScript

@'
const fs = require("fs");
const path = require("path");
const childProcess = require("child_process");

const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
const BACKEND = path.join(ROOT, "backend");
const FRONTEND = path.join(ROOT, "frontend");
const SRC = path.join(BACKEND, "src");
const FRONTEND_SRC = path.join(FRONTEND, "src");
const PHASE = path.join(ROOT, "_operations", "phase-10X0-deployment-readiness-baseline-audit");
const REPORTS = path.join(PHASE, "reports");
const REGISTRIES = path.join(PHASE, "registries");

fs.mkdirSync(REPORTS, { recursive: true });
fs.mkdirSync(REGISTRIES, { recursive: true });

function exists(p) {
  return fs.existsSync(p);
}

function statSafe(p) {
  if (!exists(p)) return null;
  const s = fs.statSync(p);
  return {
    isDirectory: s.isDirectory(),
    isFile: s.isFile(),
    sizeBytes: s.size,
    modifiedAt: s.mtime.toISOString()
  };
}

function readSafe(p) {
  return exists(p) && fs.statSync(p).isFile() ? fs.readFileSync(p, "utf8") : "";
}

function walk(dir, options = {}) {
  const maxFiles = options.maxFiles || 10000;
  const ignore = new Set(["node_modules", ".git", "dist", "build", ".vite"]);
  const output = [];

  function inner(current) {
    if (!exists(current)) return;
    if (output.length >= maxFiles) return;

    const items = fs.readdirSync(current, { withFileTypes: true });
    for (const item of items) {
      if (ignore.has(item.name)) continue;
      const p = path.join(current, item.name);
      const rel = path.relative(ROOT, p);
      const s = statSafe(p);
      output.push({
        name: item.name,
        path: p,
        relativePath: rel,
        type: item.isDirectory() ? "directory" : "file",
        sizeBytes: s ? s.sizeBytes : 0,
        modifiedAt: s ? s.modifiedAt : null
      });
      if (item.isDirectory()) inner(p);
      if (output.length >= maxFiles) break;
    }
  }

  inner(dir);
  return output;
}

function listFiles(dir, ext = null) {
  return walk(dir)
    .filter(x => x.type === "file")
    .filter(x => !ext || x.name.toLowerCase().endsWith(ext.toLowerCase()));
}

function command(cmd) {
  try {
    return childProcess.execSync(cmd, { cwd: ROOT, encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }).trim();
  } catch (err) {
    return err.stdout ? String(err.stdout).trim() : "";
  }
}

function inventoryBackend() {
  const folders = [
    "routes",
    "services",
    "middleware",
    "automation",
    "jobs",
    "database",
    "migrations",
    "models",
    "utils",
    "config"
  ];

  const details = {};
  for (const folder of folders) {
    const dir = path.join(SRC, folder);
    details[folder] = {
      exists: exists(dir),
      files: exists(dir) ? listFiles(dir).map(f => f.relativePath) : [],
      count: exists(dir) ? listFiles(dir).length : 0
    };
  }

  const inventory = {
    registry: "backend_inventory",
    generatedAt: new Date().toISOString(),
    backendRoot: BACKEND,
    srcRoot: SRC,
    folders: details,
    totals: {
      files: listFiles(BACKEND).length,
      jsFiles: listFiles(BACKEND, ".js").length,
      routeFiles: details.routes ? details.routes.count : 0,
      automationFiles: details.automation ? details.automation.count : 0
    }
  };

  fs.writeFileSync(path.join(REGISTRIES, "_backend_inventory.json"), JSON.stringify(inventory, null, 2));
  return inventory;
}

function inventoryFrontend() {
  const folders = [
    "pages",
    "components",
    "hooks",
    "api",
    "services",
    "layouts",
    "enterprise"
  ];

  const details = {};
  for (const folder of folders) {
    const dir = path.join(FRONTEND_SRC, folder);
    details[folder] = {
      exists: exists(dir),
      files: exists(dir) ? listFiles(dir).map(f => f.relativePath) : [],
      count: exists(dir) ? listFiles(dir).length : 0
    };
  }

  const inventory = {
    registry: "frontend_inventory",
    generatedAt: new Date().toISOString(),
    frontendRoot: FRONTEND,
    srcRoot: FRONTEND_SRC,
    folders: details,
    totals: {
      files: listFiles(FRONTEND).length,
      jsxFiles: listFiles(FRONTEND, ".jsx").length,
      jsFiles: listFiles(FRONTEND, ".js").length,
      enterpriseFiles: details.enterprise ? details.enterprise.count : 0
    }
  };

  fs.writeFileSync(path.join(REGISTRIES, "_frontend_inventory.json"), JSON.stringify(inventory, null, 2));
  return inventory;
}

function extractRoutesFromFile(filePath) {
  const text = readSafe(filePath);
  const routes = [];
  const routeRegex = /router\.(get|post|put|patch|delete)\s*\(\s*["'`]([^"'`]+)["'`]/gi;
  let match;
  while ((match = routeRegex.exec(text)) !== null) {
    routes.push({
      method: match[1].toUpperCase(),
      localPath: match[2],
      file: path.relative(ROOT, filePath)
    });
  }
  return routes;
}

function routeRegistry() {
  const routeDir = path.join(SRC, "routes");
  const indexText = readSafe(path.join(SRC, "index.js"));
  const routeFiles = exists(routeDir) ? listFiles(routeDir, ".js") : [];

  const mounts = [];
  const mountRegex = /app\.use\(\s*["'`]([^"'`]+)["'`]\s*,\s*require\(["'`]\.\/routes\/([^"'`]+)["'`]\)\s*\)/gi;
  let m;
  while ((m = mountRegex.exec(indexText)) !== null) {
    mounts.push({
      basePath: m[1],
      routeModule: m[2],
      routeFile: path.join("backend", "src", "routes", m[2] + ".js")
    });
  }

  const extracted = [];
  for (const f of routeFiles) {
    extracted.push(...extractRoutesFromFile(f.path));
  }

  const registry = {
    registry: "route_registry",
    generatedAt: new Date().toISOString(),
    mounts,
    extractedRoutes: extracted,
    totals: {
      routeFiles: routeFiles.length,
      mounts: mounts.length,
      extractedRoutes: extracted.length
    }
  };

  fs.writeFileSync(path.join(REGISTRIES, "_route_registry.json"), JSON.stringify(registry, null, 2));
  return registry;
}

function enterpriseRegistry() {
  const automationDir = path.join(SRC, "automation");
  const routeDir = path.join(SRC, "routes");
  const automationFiles = exists(automationDir) ? listFiles(automationDir, ".js") : [];
  const routeFiles = exists(routeDir) ? listFiles(routeDir, ".js") : [];

  const expected = [
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
    "enterpriseGovernanceEngine",
    "enterpriseHardeningEngine",
    "backupRecoveryEngine",
    "enterpriseMonitoringEngine",
    "performanceOptimizationEngine",
    "loadTestingEngine"
  ];

  const modules = expected.map(name => {
    const file = path.join(automationDir, name + ".js");
    return {
      name,
      expected: true,
      exists: exists(file),
      path: path.relative(ROOT, file)
    };
  });

  const registry = {
    registry: "enterprise_registry",
    generatedAt: new Date().toISOString(),
    modules,
    automationFiles: automationFiles.map(f => f.relativePath),
    enterpriseRoutes: routeFiles.filter(f => readSafe(f.path).includes("enterprise") || f.name.toLowerCase().includes("enterprise")).map(f => f.relativePath),
    totals: {
      expectedModules: expected.length,
      existingExpectedModules: modules.filter(m => m.exists).length,
      automationFiles: automationFiles.length,
      enterpriseRoutes: routeFiles.length
    }
  };

  fs.writeFileSync(path.join(REGISTRIES, "_enterprise_registry.json"), JSON.stringify(registry, null, 2));
  return registry;
}

function databaseRegistry() {
  const dbPath = path.join(BACKEND, "litigation360.db");

  let tables = [];
  let indexes = [];
  let views = [];
  let triggers = [];
  let sqliteAvailable = true;
  let error = null;

  try {
    const cmdBase = `sqlite3 "${dbPath}"`;
    const rawTables = command(`${cmdBase} "SELECT name, type, sql FROM sqlite_master ORDER BY type, name;"`);
    const lines = rawTables.split(/\r?\n/).filter(Boolean);

    for (const line of lines) {
      const parts = line.split("|");
      const item = { name: parts[0], type: parts[1], sql: parts.slice(2).join("|") };
      if (item.type === "table") tables.push(item);
      if (item.type === "index") indexes.push(item);
      if (item.type === "view") views.push(item);
      if (item.type === "trigger") triggers.push(item);
    }
  } catch (err) {
    sqliteAvailable = false;
    error = err.message;
  }

  const registry = {
    registry: "database_registry",
    generatedAt: new Date().toISOString(),
    databasePath: dbPath,
    databaseExists: exists(dbPath),
    databaseSizeBytes: exists(dbPath) ? fs.statSync(dbPath).size : 0,
    sqliteAvailable,
    error,
    tables,
    indexes,
    views,
    triggers,
    totals: {
      tables: tables.length,
      indexes: indexes.length,
      views: views.length,
      triggers: triggers.length
    }
  };

  fs.writeFileSync(path.join(REGISTRIES, "_database_registry.json"), JSON.stringify(registry, null, 2));
  return registry;
}

function deploymentRegistry() {
  const backendPkgPath = path.join(BACKEND, "package.json");
  const frontendPkgPath = path.join(FRONTEND, "package.json");

  function pkg(p) {
    try { return JSON.parse(readSafe(p)); } catch { return {}; }
  }

  const registry = {
    registry: "deployment_registry",
    generatedAt: new Date().toISOString(),
    environment: {
      nodeVersion: command("node -v"),
      npmVersion: command("npm -v"),
      platform: process.platform,
      cwd: process.cwd()
    },
    backend: {
      packageExists: exists(backendPkgPath),
      name: pkg(backendPkgPath).name || null,
      version: pkg(backendPkgPath).version || null,
      scripts: pkg(backendPkgPath).scripts || {}
    },
    frontend: {
      packageExists: exists(frontendPkgPath),
      name: pkg(frontendPkgPath).name || null,
      version: pkg(frontendPkgPath).version || null,
      scripts: pkg(frontendPkgPath).scripts || {},
      distExists: exists(path.join(FRONTEND, "dist"))
    },
    database: {
      exists: exists(path.join(BACKEND, "litigation360.db")),
      path: path.join(BACKEND, "litigation360.db")
    },
    ports: {
      backendDefault: 5000,
      frontendDefault: 5173
    }
  };

  fs.writeFileSync(path.join(REGISTRIES, "_deployment_registry.json"), JSON.stringify(registry, null, 2));
  return registry;
}

function writeSummary(all) {
  const checks = [
    { name: "Backend folder exists", pass: exists(BACKEND) },
    { name: "Frontend folder exists", pass: exists(FRONTEND) },
    { name: "Backend inventory generated", pass: all.backend.totals.files > 0 },
    { name: "Frontend inventory generated", pass: all.frontend.totals.files > 0 },
    { name: "Routes discovered", pass: all.routes.totals.mounts > 0 },
    { name: "Enterprise modules discovered", pass: all.enterprise.totals.existingExpectedModules >= 10 },
    { name: "Database exists", pass: all.database.databaseExists },
    { name: "Deployment registry generated", pass: !!all.deployment.environment.nodeVersion }
  ];

  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;

  const summary = {
    phase: "10X.0",
    module: "Deployment Readiness Baseline Audit",
    timestamp: new Date().toISOString(),
    status: failed === 0 ? "PASS" : "FAIL",
    passed,
    failed,
    checks,
    keyCounts: {
      backendFiles: all.backend.totals.files,
      frontendFiles: all.frontend.totals.files,
      routeMounts: all.routes.totals.mounts,
      extractedRoutes: all.routes.totals.extractedRoutes,
      expectedEnterpriseModules: all.enterprise.totals.expectedModules,
      existingEnterpriseModules: all.enterprise.totals.existingExpectedModules,
      databaseTables: all.database.totals.tables,
      databaseIndexes: all.database.totals.indexes
    }
  };

  fs.writeFileSync(path.join(REPORTS, "phase10X0-baseline-audit-summary.json"), JSON.stringify(summary, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10X.0 BASELINE AUDIT SUMMARY",
    "====================================================",
    "",
    "Timestamp: " + summary.timestamp,
    "Status: " + summary.status,
    "Passed: " + summary.passed,
    "Failed: " + summary.failed,
    "",
    "Backend Files: " + summary.keyCounts.backendFiles,
    "Frontend Files: " + summary.keyCounts.frontendFiles,
    "Route Mounts: " + summary.keyCounts.routeMounts,
    "Extracted Routes: " + summary.keyCounts.extractedRoutes,
    "Enterprise Modules: " + summary.keyCounts.existingEnterpriseModules + "/" + summary.keyCounts.expectedEnterpriseModules,
    "Database Tables: " + summary.keyCounts.databaseTables,
    "Database Indexes: " + summary.keyCounts.databaseIndexes,
    "",
    ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
  ];

  fs.writeFileSync(path.join(REPORTS, "phase10X0-baseline-audit-summary.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  return summary;
}

function main() {
  const all = {
    backend: inventoryBackend(),
    frontend: inventoryFrontend(),
    routes: routeRegistry(),
    enterprise: enterpriseRegistry(),
    database: databaseRegistry(),
    deployment: deploymentRegistry()
  };

  fs.writeFileSync(path.join(REGISTRIES, "_master_baseline_registry.json"), JSON.stringify(all, null, 2));
  const summary = writeSummary(all);

  if (summary.status !== "PASS") process.exit(1);
}

main();
'@ | Out-File -LiteralPath $AuditScript -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10X.0 DEPLOYMENT READINESS BASELINE AUDIT

## Purpose
Create a single source of truth before Phase 10X deployment readiness scoring.

## Auto-Created Folders
- $Reports
- $Registries
- $Logs
- $Docs
- $Validation
- $Backups

## Generated Registries
- _backend_inventory.json
- _frontend_inventory.json
- _route_registry.json
- _enterprise_registry.json
- _database_registry.json
- _deployment_registry.json
- _master_baseline_registry.json

## Process
1. Scan backend structure
2. Scan frontend structure
3. Extract backend route mounts
4. Extract route method declarations
5. Check enterprise modules
6. Inspect SQLite database if sqlite3 CLI is available
7. Record Node/NPM/package/build/environment details
8. Generate summary report

## Run Command
node PHASE10X0-BASELINE-AUDIT.js

## Success Criteria
- Backend inventory generated
- Frontend inventory generated
- Route registry generated
- Enterprise registry generated
- Database registry generated
- Deployment registry generated
- Master registry generated
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10X0-BASELINE-AUDIT-PROTOCOL.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X0.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const auditScript = process.env.L360_AUDIT_SCRIPT;
const registries = process.env.L360_REGISTRIES;
const reports = process.env.L360_REPORTS;

fs.mkdirSync(reports, { recursive: true });

const expected = [
  "_backend_inventory.json",
  "_frontend_inventory.json",
  "_route_registry.json",
  "_enterprise_registry.json",
  "_database_registry.json",
  "_deployment_registry.json",
  "_master_baseline_registry.json"
];

const checks = [
  { name: "Audit script exists", pass: fs.existsSync(auditScript), path: auditScript },
  ...expected.map(name => ({
    name: name + " exists",
    pass: fs.existsSync(path.join(registries, name)),
    path: path.join(registries, name)
  }))
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10X.0-VALIDATION",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks
};

fs.writeFileSync(path.join(reports, "phase10X0-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.0 VALIDATION REPORT",
  "===============================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  "",
  ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
].join("\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

$runExit=0
if($Mode -eq "APPLY"){
  Write-Host "Running baseline audit..."
  node $AuditScript
  $runExit=$LASTEXITCODE
}

Write-Host ""
Write-Host "Running validation..."
$env:L360_ROOT=$Root
$env:L360_AUDIT_SCRIPT=$AuditScript
$env:L360_REGISTRIES=$Registries
$env:L360_REPORTS=$Reports
node $Validate
$validateExit=$LASTEXITCODE

Write-Host ""
Write-Host "Audit Script:"
Write-Host $AuditScript
Write-Host ""
Write-Host "Registries:"
Write-Host $Registries
Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Docs:"
Write-Host $Docs
Write-Host ""

if($runExit -eq 0 -and $validateExit -eq 0){
  Write-Host "PHASE 10X.0 BASELINE AUDIT STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.0 BASELINE AUDIT STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
if($runExit -ne 0){exit $runExit}
exit $validateExit

param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Phase=Join-Path $Root "_operations\phase-10V-frontend-smoke-test-v2-fix"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Validation=Join-Path $Phase "validation"
$SmokeScript=Join-Path $Root "PHASE10V-FRONTEND-SMOKE-TEST.js"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Validation | Out-Null

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10V FRONTEND SMOKE TEST V2 FIX"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if($Mode -eq "APPLY"){
  Backup $SmokeScript

@'
const fs = require("fs");
const path = require("path");

const ROOT = "C:\\Users\\jep_edmundrulz\\litigation-360-workspace\\litigation-360-software";
const FRONTEND = path.join(ROOT, "frontend");
const SRC = path.join(FRONTEND, "src");
const REPORTS = path.join(ROOT, "_operations", "phase-10V-frontend-smoke-testing", "reports");

fs.mkdirSync(REPORTS, { recursive: true });

function exists(filePath) {
  return fs.existsSync(filePath);
}

function read(filePath) {
  return exists(filePath) ? fs.readFileSync(filePath, "utf8") : "";
}

function has(filePath, text) {
  return read(filePath).includes(text);
}

const app = exists(path.join(SRC, "App.jsx"))
  ? path.join(SRC, "App.jsx")
  : path.join(SRC, "App.js");

const files = {
  packageJson: path.join(FRONTEND, "package.json"),
  app,
  dashboard: path.join(SRC, "enterprise", "pages", "EnterpriseOperationsDashboard.jsx"),
  connectivity: path.join(SRC, "enterprise", "pages", "FrontendBackendConnectivityValidator.jsx"),
  api: path.join(SRC, "enterprise", "api", "enterpriseApi.js"),
  connectivityApi: path.join(SRC, "enterprise", "api", "connectivityValidatorApi.js"),
  card: path.join(SRC, "enterprise", "components", "EnterpriseStatusCard.jsx"),
  panel: path.join(SRC, "enterprise", "components", "BackendConnectivityPanel.jsx")
};

const checks = [
  { name: "frontend package.json exists", pass: exists(files.packageJson), path: files.packageJson },
  { name: "App file exists", pass: exists(files.app), path: files.app },
  { name: "Enterprise dashboard page exists", pass: exists(files.dashboard), path: files.dashboard },
  { name: "Connectivity validator page exists", pass: exists(files.connectivity), path: files.connectivity },
  { name: "Enterprise API exists", pass: exists(files.api), path: files.api },
  { name: "Connectivity API exists", pass: exists(files.connectivityApi), path: files.connectivityApi },
  { name: "Status card component exists", pass: exists(files.card), path: files.card },
  { name: "Connectivity panel component exists", pass: exists(files.panel), path: files.panel },

  { name: "App imports EnterpriseOperationsDashboard", pass: has(files.app, "EnterpriseOperationsDashboard") },
  { name: "App imports FrontendBackendConnectivityValidator", pass: has(files.app, "FrontendBackendConnectivityValidator") },
  { name: "App has Enterprise Dashboard button", pass: has(files.app, "Enterprise Dashboard") },
  { name: "App has Connectivity Validator button", pass: has(files.app, "Connectivity Validator") },

  { name: "Dashboard has 15s auto refresh", pass: has(files.dashboard, "15000") && has(files.dashboard, "setInterval") },
  { name: "Connectivity has 30s auto refresh", pass: has(files.connectivity, "30000") && has(files.connectivity, "setInterval") },

  { name: "Enterprise API has monitoring endpoint", pass: has(files.api, "/api/enterprise/monitoring/health") },
  { name: "Enterprise API has performance endpoint", pass: has(files.api, "/api/enterprise/performance/benchmark") },
  { name: "Connectivity API has maps endpoint", pass: has(files.connectivityApi, "/api/enterprise/maps/health") },
  { name: "Connectivity API has documents endpoint", pass: has(files.connectivityApi, "/api/enterprise/documents/lifecycle/health") },
  { name: "Connectivity API has court operations endpoint", pass: has(files.connectivityApi, "/api/enterprise/court-operations/health") },

  { name: "Industrial Court present in UI", pass: has(files.dashboard, "Industrial Court Kuala Lumpur") && has(files.connectivity, "Industrial Court Kuala Lumpur") },
  { name: "PERKESO present in UI", pass: has(files.dashboard, "PERKESO") && has(files.connectivity, "PERKESO") }
];

const passed = checks.filter((check) => check.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10V",
  module: "Frontend Smoke Testing",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks
};

fs.writeFileSync(path.join(REPORTS, "phase10V-frontend-smoke-test-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10V FRONTEND SMOKE TEST REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  ""
];

for (const check of checks) {
  lines.push((check.pass ? "PASS" : "FAIL") + " - " + check.name);
}

console.log(lines.join("\n"));

if (report.status !== "PASS") {
  process.exit(1);
}
'@ | Out-File -LiteralPath $SmokeScript -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10V-v2-fix.js"

@'
const fs = require("fs");
const path = require("path");

const smoke = process.env.L360_SMOKE_SCRIPT;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

const text = fs.existsSync(smoke) ? fs.readFileSync(smoke, "utf8") : "";

const report = {
  phase: "10V-V2-FIX",
  timestamp: new Date().toISOString(),
  smokeScriptExists: fs.existsSync(smoke),
  syntaxSafe: text.includes('lines.push((check.pass ? "PASS" : "FAIL") + " - " + check.name);'),
  noBrokenTemplate: !text.includes("...checks.map(c => ${c.pass"),
  status: "FAIL"
};

report.status = report.smokeScriptExists && report.syntaxSafe && report.noBrokenTemplate ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10V-v2-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10V V2 FIX REPORT",
  "========================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Smoke Script Exists: " + report.smokeScriptExists,
  "Syntax Safe: " + report.syntaxSafe,
  "Broken Template Removed: " + report.noBrokenTemplate
].join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running fix validation..."
$env:L360_SMOKE_SCRIPT=$SmokeScript
$env:L360_REPORTS_DIR=$Reports
node $Validate
$exit1=$LASTEXITCODE

$exit2=0
if($Mode -eq "APPLY"){
  Write-Host ""
  Write-Host "Running corrected smoke test..."
  node $SmokeScript
  $exit2=$LASTEXITCODE
}

Write-Host ""
Write-Host "Smoke Script:"
Write-Host $SmokeScript
Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit1 -eq 0 -and $exit2 -eq 0){
  Write-Host "PHASE 10V FRONTEND SMOKE TEST V2 FIX STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10V FRONTEND SMOKE TEST V2 FIX STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
if($exit1 -ne 0){exit $exit1}
exit $exit2

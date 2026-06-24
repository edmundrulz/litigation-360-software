param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Frontend "src"
$Phase=Join-Path $Root "_operations\phase-10V-frontend-smoke-testing"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Tests=Join-Path $Phase "tests"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Tests | Out-Null

$SmokeScript=Join-Path $Root "PHASE10V-FRONTEND-SMOKE-TEST.js"
$Package=Join-Path $Frontend "package.json"
$App=Join-Path $Src "App.jsx"
if(!(Test-Path -LiteralPath $App)){ $App=Join-Path $Src "App.js" }

$Dashboard=Join-Path $Src "enterprise\pages\EnterpriseOperationsDashboard.jsx"
$Connectivity=Join-Path $Src "enterprise\pages\FrontendBackendConnectivityValidator.jsx"
$Api=Join-Path $Src "enterprise\api\enterpriseApi.js"
$ConnectivityApi=Join-Path $Src "enterprise\api\connectivityValidatorApi.js"
$Card=Join-Path $Src "enterprise\components\EnterpriseStatusCard.jsx"
$Panel=Join-Path $Src "enterprise\components\BackendConnectivityPanel.jsx"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10V FRONTEND SMOKE TESTING"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $SmokeScript

@"
const fs = require("fs");
const path = require("path");

const ROOT = "$Root".replace(/\\\\/g, "\\\\");
const FRONTEND = path.join(ROOT, "frontend");
const SRC = path.join(FRONTEND, "src");
const REPORTS = path.join(ROOT, "_operations", "phase-10V-frontend-smoke-testing", "reports");
fs.mkdirSync(REPORTS, { recursive: true });

function exists(p) {
  return fs.existsSync(p);
}

function read(p) {
  return exists(p) ? fs.readFileSync(p, "utf8") : "";
}

function has(p, text) {
  return read(p).includes(text);
}

const app = exists(path.join(SRC, "App.jsx")) ? path.join(SRC, "App.jsx") : path.join(SRC, "App.js");

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

const passed = checks.filter(c => c.pass).length;
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

console.log([
  "LITIGATION 360 - PHASE 10V FRONTEND SMOKE TEST REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  "",
  ...checks.map(c => `${c.pass ? "PASS" : "FAIL"} - ${c.name}`)
].join("\\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $SmokeScript -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10V FRONTEND SMOKE TESTING

## Purpose
Verify frontend files, imports, dashboard wiring, connectivity validator wiring, endpoint references, and special Industrial Court/PERKESO UI coverage.

## Created File
- $SmokeScript

## Run Smoke Test
From project root:

node PHASE10V-FRONTEND-SMOKE-TEST.js

## Validates
- App.jsx/App.js exists
- Enterprise dashboard exists
- Connectivity validator exists
- API files exist
- Components exist
- Buttons exist
- Auto-refresh exists
- Backend endpoint references exist
- Industrial Court and PERKESO references exist
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10V-FRONTEND-SMOKE-TESTING.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10V.js"

@"
const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const smoke = process.env.L360_SMOKE_SCRIPT;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

const smokeExists = fs.existsSync(smoke);
let smokeContent = smokeExists ? fs.readFileSync(smoke, "utf8") : "";

const report = {
  phase: "10V",
  timestamp: new Date().toISOString(),
  files: {
    smokeScriptExists: smokeExists
  },
  content: {
    checksDashboard: smokeContent.includes("Enterprise dashboard page exists"),
    checksConnectivity: smokeContent.includes("Connectivity validator page exists"),
    checksIndustrialCourt: smokeContent.includes("Industrial Court"),
    checksPERKESO: smokeContent.includes("PERKESO"),
    checksMapsEndpoint: smokeContent.includes("/api/enterprise/maps/health")
  }
};

report.status = (
  report.files.smokeScriptExists &&
  report.content.checksDashboard &&
  report.content.checksConnectivity &&
  report.content.checksIndustrialCourt &&
  report.content.checksPERKESO &&
  report.content.checksMapsEndpoint
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10V-deployment-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10V DEPLOYMENT VALIDATION REPORT",
  "======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Smoke Script Exists: " + report.files.smokeScriptExists,
  "Checks Dashboard: " + report.content.checksDashboard,
  "Checks Connectivity: " + report.content.checksConnectivity,
  "Checks Industrial Court: " + report.content.checksIndustrialCourt,
  "Checks PERKESO: " + report.content.checksPERKESO,
  "Checks Maps Endpoint: " + report.content.checksMapsEndpoint
].join("\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running deployment validation..."
$env:L360_ROOT=$Root
$env:L360_SMOKE_SCRIPT=$SmokeScript
$env:L360_REPORTS_DIR=$Reports
node $Validate
$exit1=$LASTEXITCODE

$exit2=0
if($Mode -eq "APPLY"){
  Write-Host ""
  Write-Host "Running smoke test..."
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

if($exit1 -eq 0 -and $exit2 -eq 0){
  Write-Host "PHASE 10V FRONTEND SMOKE TESTING STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10V FRONTEND SMOKE TESTING STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
if($exit1 -ne 0){exit $exit1}
exit $exit2

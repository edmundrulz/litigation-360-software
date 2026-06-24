param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Phase=Join-Path $Root "_operations\phase-10W-frontend-build-production-validation"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$BuildReports=Join-Path $Phase "build-reports"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$BuildReports | Out-Null

$Package=Join-Path $Frontend "package.json"
$ViteConfig=Join-Path $Frontend "vite.config.js"
$Src=Join-Path $Frontend "src"
$AppJsx=Join-Path $Src "App.jsx"
$AppJs=Join-Path $Src "App.js"
$Dist=Join-Path $Frontend "dist"
$BuildOutput=Join-Path $BuildReports "npm-build-output.txt"
$BuildError=Join-Path $BuildReports "npm-build-error.txt"

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10W FRONTEND BUILD PRODUCTION VALIDATION"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath $Package)){
  Write-Host "ERROR: frontend package.json not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

$Validate=Join-Path $Validation "validate-phase10W-prebuild.js"

@"
const fs = require("fs");
const path = require("path");

const frontend = process.env.L360_FRONTEND;
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const packagePath = path.join(frontend, "package.json");
const srcPath = path.join(frontend, "src");
const appPath = fs.existsSync(path.join(srcPath, "App.jsx")) ? path.join(srcPath, "App.jsx") : path.join(srcPath, "App.js");

const files = {
  packageJson: packagePath,
  src: srcPath,
  app: appPath,
  dashboard: path.join(srcPath, "enterprise", "pages", "EnterpriseOperationsDashboard.jsx"),
  connectivity: path.join(srcPath, "enterprise", "pages", "FrontendBackendConnectivityValidator.jsx"),
  enterpriseApi: path.join(srcPath, "enterprise", "api", "enterpriseApi.js"),
  connectivityApi: path.join(srcPath, "enterprise", "api", "connectivityValidatorApi.js")
};

function exists(p) { return fs.existsSync(p); }
function read(p) { return exists(p) ? fs.readFileSync(p, "utf8") : ""; }
function has(p, s) { return read(p).includes(s); }

let pkg = {};
try { pkg = JSON.parse(read(packagePath)); } catch {}

const checks = [
  { name: "package.json exists", pass: exists(files.packageJson) },
  { name: "src folder exists", pass: exists(files.src) },
  { name: "App file exists", pass: exists(files.app) },
  { name: "build script exists", pass: !!pkg.scripts && !!pkg.scripts.build },
  { name: "dev script exists", pass: !!pkg.scripts && !!pkg.scripts.dev },
  { name: "Enterprise dashboard exists", pass: exists(files.dashboard) },
  { name: "Connectivity validator exists", pass: exists(files.connectivity) },
  { name: "Enterprise API exists", pass: exists(files.enterpriseApi) },
  { name: "Connectivity API exists", pass: exists(files.connectivityApi) },
  { name: "App imports dashboard", pass: has(files.app, "EnterpriseOperationsDashboard") },
  { name: "App imports connectivity", pass: has(files.app, "FrontendBackendConnectivityValidator") },
  { name: "Monitoring endpoint referenced", pass: has(files.enterpriseApi, "/api/enterprise/monitoring/health") },
  { name: "Maps endpoint referenced", pass: has(files.connectivityApi, "/api/enterprise/maps/health") },
  { name: "Industrial Court visible", pass: has(files.dashboard, "Industrial Court Kuala Lumpur") && has(files.connectivity, "Industrial Court Kuala Lumpur") },
  { name: "PERKESO visible", pass: has(files.dashboard, "PERKESO") && has(files.connectivity, "PERKESO") }
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10W-PREBUILD",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks,
  packageScripts: pkg.scripts || {}
};

fs.writeFileSync(path.join(reports, "phase10W-prebuild-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10W PREBUILD VALIDATION REPORT",
  "====================================================",
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

Write-Host "Running prebuild validation..."
$env:L360_FRONTEND=$Frontend
$env:L360_REPORTS=$Reports
node $Validate
$preExit=$LASTEXITCODE

$buildExit=0
if($Mode -eq "APPLY" -and $preExit -eq 0){
  Write-Host ""
  Write-Host "Running npm build..."
  Push-Location $Frontend
  cmd /c "npm run build > `"$BuildOutput`" 2> `"$BuildError`""
  $buildExit=$LASTEXITCODE
  Pop-Location
}

$FinalValidate=Join-Path $Validation "validate-phase10W-final.js"

@"
const fs = require("fs");
const path = require("path");

const frontend = process.env.L360_FRONTEND;
const reports = process.env.L360_REPORTS;
const buildOutput = process.env.L360_BUILD_OUTPUT;
const buildError = process.env.L360_BUILD_ERROR;
const buildExit = Number(process.env.L360_BUILD_EXIT || 0);
const preExit = Number(process.env.L360_PRE_EXIT || 0);

fs.mkdirSync(reports, { recursive: true });

const dist = path.join(frontend, "dist");
const distExists = fs.existsSync(dist);
let distFiles = [];
if (distExists) {
  function walk(dir) {
    for (const item of fs.readdirSync(dir)) {
      const p = path.join(dir, item);
      const stat = fs.statSync(p);
      if (stat.isDirectory()) walk(p);
      else distFiles.push(p);
    }
  }
  walk(dist);
}

const outputText = fs.existsSync(buildOutput) ? fs.readFileSync(buildOutput, "utf8") : "";
const errorText = fs.existsSync(buildError) ? fs.readFileSync(buildError, "utf8") : "";

const report = {
  phase: "10W",
  module: "Frontend Build Production Validation",
  timestamp: new Date().toISOString(),
  prebuildPassed: preExit === 0,
  buildExit,
  buildPassed: buildExit === 0,
  distExists,
  distFileCount: distFiles.length,
  hasIndexHtml: distFiles.some(f => path.basename(f).toLowerCase() === "index.html"),
  hasAssets: distFiles.some(f => f.includes(path.sep + "assets" + path.sep)),
  buildOutputPreview: outputText.slice(0, 4000),
  buildErrorPreview: errorText.slice(0, 4000)
};

report.status = report.prebuildPassed && report.buildPassed && report.distExists && report.hasIndexHtml ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10W-frontend-build-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10W FRONTEND BUILD REPORT",
  "===============================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Prebuild Passed: " + report.prebuildPassed,
  "Build Exit: " + report.buildExit,
  "Build Passed: " + report.buildPassed,
  "Dist Exists: " + report.distExists,
  "Dist File Count: " + report.distFileCount,
  "Index HTML Exists: " + report.hasIndexHtml,
  "Assets Exist: " + report.hasAssets
].join("\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $FinalValidate -Encoding UTF8

$env:L360_FRONTEND=$Frontend
$env:L360_REPORTS=$Reports
$env:L360_BUILD_OUTPUT=$BuildOutput
$env:L360_BUILD_ERROR=$BuildError
$env:L360_BUILD_EXIT="$buildExit"
$env:L360_PRE_EXIT="$preExit"
node $FinalValidate
$finalExit=$LASTEXITCODE

@"
# LITIGATION 360 - PHASE 10W FRONTEND BUILD PRODUCTION VALIDATION

## Purpose
Validate that the frontend app can build for production after Phase 10S/10T/10U.

## Checks
- package.json exists
- npm build script exists
- App.jsx/App.js exists
- Enterprise dashboard exists
- Connectivity validator exists
- API files exist
- Industrial Court and PERKESO references exist
- npm run build completes
- frontend\dist exists
- frontend\dist\index.html exists

## Commands
From project root:
powershell -NoProfile -ExecutionPolicy Bypass -File ".\L360-PHASE10W-FRONTEND-BUILD-VALIDATION.ps1" -Mode APPLY

## Reports
$Reports

## Build Logs
$BuildReports
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10W-FRONTEND-BUILD-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Build Output:"
Write-Host $BuildOutput
Write-Host ""
Write-Host "Build Error:"
Write-Host $BuildError
Write-Host ""

if($finalExit -eq 0){
  Write-Host "PHASE 10W FRONTEND BUILD VALIDATION STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10W FRONTEND BUILD VALIDATION STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $finalExit

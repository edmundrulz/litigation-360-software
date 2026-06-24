param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Engine=Join-Path $Root "backend\src\automation\enterpriseHardeningEngine.js"
$Phase=Join-Path $Root "_operations\phase-10O-hardening-path-fix"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs | Out-Null
$Log=Join-Path $Logs "path-fix-log.txt"

function Log($Text){Add-Content -LiteralPath $Log -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
    Log "Backup $Path --> $dest"
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10O HARDENING PATH FIX"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Engine)){
  Write-Host "ERROR: enterpriseHardeningEngine.js not found."
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $Engine

  $txt=Get-Content -LiteralPath $Engine -Raw

  $txt=$txt.Replace(
    'const PROJECT_ROOT = path.resolve(__dirname, "..", "..");',
    'const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");'
  )

  Set-Content -LiteralPath $Engine -Value $txt -Encoding UTF8
  Log "Patched PROJECT_ROOT path to resolve project root correctly."
}

$Validate=Join-Path $Phase "validate-10O-path-fix.js"

@'
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10O-hardening-path-fix", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "enterpriseHardeningEngine.js");

delete require.cache[require.resolve(enginePath)];
const engine = require(enginePath);

const readiness = engine.getDeploymentReadiness();
const dashboard = engine.getEnterpriseHardeningDashboard();
const health = engine.getHardeningHealth();

const report = {
  phase: "10O-PATH-FIX",
  timestamp: new Date().toISOString(),
  engineExists: fs.existsSync(enginePath),
  deploymentStatus: readiness.status,
  deploymentReady: readiness.deploymentReady,
  healthScore: readiness.healthScore,
  blockingIssuesCount: readiness.blockingIssuesCount,
  blockingIssues: readiness.blockingIssues,
  dashboardStatus: dashboard.status,
  hardeningHealth: health.status,
  status: (
    fs.existsSync(enginePath) &&
    typeof readiness.healthScore === "number" &&
    readiness.healthScore > 0 &&
    readiness.blockingIssuesCount < 67
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10O-path-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10O HARDENING PATH FIX REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.engineExists,
  "Deployment Status: " + report.deploymentStatus,
  "Deployment Ready: " + report.deploymentReady,
  "Health Score: " + report.healthScore,
  "Blocking Issues: " + report.blockingIssuesCount,
  "Hardening Health: " + report.hardeningHealth
].join("\n"));

if(report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

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

if($exit -eq 0){
  Write-Host "PHASE 10O HARDENING PATH FIX STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10O HARDENING PATH FIX STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

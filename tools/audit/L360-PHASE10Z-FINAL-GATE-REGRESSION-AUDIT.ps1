param(
    [ValidateSet("AUDIT")]
    [string]$Mode = "AUDIT"
)

$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$BackendRoot = Join-Path $ProjectRoot "backend"
$BackendSrc = Join-Path $BackendRoot "src"
$IndexFile = Join-Path $BackendSrc "index.js"
$OpsRoot = Join-Path $ProjectRoot "_operations"
$AuditRoot = Join-Path $OpsRoot "phase-10Z-final-gate-regression-audit"
$ReportDir = Join-Path $AuditRoot "reports"
$ValidationDir = Join-Path $AuditRoot "validation"
$LogsDir = Join-Path $AuditRoot "logs"
$DocsDir = Join-Path $AuditRoot "docs"

function Ensure-Folder($Path) {
    if (!(Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Check-Exists($Label, $Path, [ref]$Results) {
    $ok = Test-Path -LiteralPath $Path
    $Results.Value += [pscustomobject]@{
        Check = $Label
        Result = $ok
        Path = $Path
    }
    Write-Host ("{0}: {1}" -f $Label, $ok.ToString().ToLower())
}

function Check-Contains($Label, $Path, $Needle, [ref]$Results) {
    $ok = $false
    if (Test-Path -LiteralPath $Path) {
        $content = Get-Content -LiteralPath $Path -Raw
        $ok = $content.Contains($Needle)
    }
    $Results.Value += [pscustomobject]@{
        Check = $Label
        Result = $ok
        Path = $Path
    }
    Write-Host ("{0}: {1}" -f $Label, $ok.ToString().ToLower())
}

function Check-Endpoint($Label, $Url, [ref]$Results) {
    $ok = $false
    $detail = ""
    try {
        $res = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
        $ok = ($res.StatusCode -ge 200 -and $res.StatusCode -lt 300)
        $detail = "HTTP " + $res.StatusCode
    } catch {
        $detail = $_.Exception.Message
    }
    $Results.Value += [pscustomobject]@{
        Check = $Label
        Result = $ok
        Path = $Url
        Detail = $detail
    }
    Write-Host ("{0}: {1}" -f $Label, $ok.ToString().ToLower())
}

Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10Z FINAL GATE / REGRESSION AUDIT"
Write-Host "===================================================="
Write-Host ""

Ensure-Folder $AuditRoot
Ensure-Folder $ReportDir
Ensure-Folder $ValidationDir
Ensure-Folder $LogsDir
Ensure-Folder $DocsDir

$results = @()

Check-Exists "Project Root Exists" $ProjectRoot ([ref]$results)
Check-Exists "Backend Root Exists" $BackendRoot ([ref]$results)
Check-Exists "Backend Source Exists" $BackendSrc ([ref]$results)
Check-Exists "Backend index.js Exists" $IndexFile ([ref]$results)

# Phase 10Z.0
Check-Exists "10Z.0 Engine Exists" (Join-Path $BackendSrc "automation\enterpriseOperationsCommandCentre.js") ([ref]$results)
Check-Exists "10Z.0 Route Exists" (Join-Path $BackendSrc "routes\enterpriseOperationsRoutes.js") ([ref]$results)
Check-Contains "10Z.0 Route Mounted" $IndexFile '/api/enterprise/operations' ([ref]$results)
Check-Exists "10Z.0 Ops Folder Exists" (Join-Path $OpsRoot "phase-10Z0-enterprise-operations-command-centre") ([ref]$results)

# Phase 10Z.1
Check-Exists "10Z.1 Alert Engine Exists" (Join-Path $BackendSrc "automation\alertEngine.js") ([ref]$results)
Check-Exists "10Z.1 Escalation Engine Exists" (Join-Path $BackendSrc "automation\escalationEngine.js") ([ref]$results)
Check-Exists "10Z.1 Notification Engine Exists" (Join-Path $BackendSrc "automation\notificationEngine.js") ([ref]$results)
Check-Exists "10Z.1 Alert Route Exists" (Join-Path $BackendSrc "routes\alertRoutes.js") ([ref]$results)
Check-Contains "10Z.1 Route Mounted" $IndexFile '/api/enterprise/alerts' ([ref]$results)
Check-Exists "10Z.1 Ops Folder Exists" (Join-Path $OpsRoot "phase-10Z1-alert-escalation-centre") ([ref]$results)

# Phase 10Z.2
Check-Exists "10Z.2 Analytics Engine Exists" (Join-Path $BackendSrc "automation\operationsAnalyticsEngine.js") ([ref]$results)
Check-Exists "10Z.2 Analytics Route Exists" (Join-Path $BackendSrc "routes\operationsAnalyticsRoutes.js") ([ref]$results)
Check-Contains "10Z.2 Route Mounted" $IndexFile '/api/enterprise/analytics' ([ref]$results)
Check-Exists "10Z.2 Ops Folder Exists" (Join-Path $OpsRoot "phase-10Z2-enterprise-operations-analytics-centre") ([ref]$results)

# Phase 10Z.3
Check-Exists "10Z.3 Predictive Engine Exists" (Join-Path $BackendSrc "automation\predictiveIntelligenceEngine.js") ([ref]$results)
Check-Exists "10Z.3 Risk Engine Exists" (Join-Path $BackendSrc "automation\riskScoringEngine.js") ([ref]$results)
Check-Exists "10Z.3 Trend Engine Exists" (Join-Path $BackendSrc "automation\trendAnalysisEngine.js") ([ref]$results)
Check-Exists "10Z.3 Forecast Engine Exists" (Join-Path $BackendSrc "automation\forecastEngine.js") ([ref]$results)
Check-Exists "10Z.3 Predictive Route Exists" (Join-Path $BackendSrc "routes\predictiveRoutes.js") ([ref]$results)
Check-Contains "10Z.3 Route Mounted" $IndexFile '/api/enterprise/predictive' ([ref]$results)
Check-Exists "10Z.3 Ops Folder Exists" (Join-Path $OpsRoot "phase-10Z3-predictive-intelligence-engine") ([ref]$results)

# Phase 10Z.4
Check-Exists "10Z.4 Autonomous Supervisor Exists" (Join-Path $BackendSrc "automation\autonomousSupervisor.js") ([ref]$results)
Check-Exists "10Z.4 Watchdog Engine Exists" (Join-Path $BackendSrc "automation\watchdogEngine.js") ([ref]$results)
Check-Exists "10Z.4 Recovery Engine Exists" (Join-Path $BackendSrc "automation\recoveryEngine.js") ([ref]$results)
Check-Exists "10Z.4 Remediation Engine Exists" (Join-Path $BackendSrc "automation\remediationEngine.js") ([ref]$results)
Check-Exists "10Z.4 Decision Engine Exists" (Join-Path $BackendSrc "automation\decisionEngine.js") ([ref]$results)
Check-Exists "10Z.4 Autonomous Route Exists" (Join-Path $BackendSrc "routes\autonomousRoutes.js") ([ref]$results)
Check-Contains "10Z.4 Route Mounted" $IndexFile '/api/enterprise/autonomous' ([ref]$results)
Check-Exists "10Z.4 Ops Folder Exists" (Join-Path $OpsRoot "phase-10Z4-autonomous-operations-supervisor") ([ref]$results)

# Permanent court / agency coverage
$allJs = ""
Get-ChildItem -Path $BackendSrc -Recurse -Include *.js -ErrorAction SilentlyContinue | ForEach-Object {
    $allJs += "`n" + (Get-Content -LiteralPath $_.FullName -Raw)
}

$coverageChecks = @{
    "Industrial Court Kuala Lumpur Coverage Present" = "Industrial Court Kuala Lumpur"
    "PERKESO Jalan Tun Razak Coverage Present" = "PERKESO Kuala Lumpur"
    "PERKESO Headquarters Jalan Ampang Coverage Present" = "PERKESO Headquarters"
    "Google Maps Readiness Present" = "Google Maps"
    "Waze Readiness Present" = "Waze"
    "Court Navigation Readiness Present" = "navigation"
}

foreach ($label in $coverageChecks.Keys) {
    $needle = $coverageChecks[$label]
    $ok = $allJs.Contains($needle)
    $results += [pscustomobject]@{ Check = $label; Result = $ok; Path = "backend\src recursive JS search"; Detail = $needle }
    Write-Host ("{0}: {1}" -f $label, $ok.ToString().ToLower())
}

# Optional live endpoint tests if backend is running
Write-Host ""
Write-Host "Live endpoint checks. These pass only if backend is currently running."
Check-Endpoint "Live 10Z.0 Operations Health Endpoint" "http://localhost:5100/api/enterprise/operations/health" ([ref]$results)
Check-Endpoint "Live 10Z.1 Alerts Health Endpoint" "http://localhost:5100/api/enterprise/alerts/health" ([ref]$results)
Check-Endpoint "Live 10Z.2 Analytics Health Endpoint" "http://localhost:5100/api/enterprise/analytics/health" ([ref]$results)
Check-Endpoint "Live 10Z.3 Predictive Health Endpoint" "http://localhost:5100/api/enterprise/predictive/health" ([ref]$results)
Check-Endpoint "Live 10Z.4 Autonomous Health Endpoint" "http://localhost:5100/api/enterprise/autonomous/health" ([ref]$results)

# Generate protocol doc
$protocol = @"
# Phase 10Z Final Gate Regression Audit Protocol

## Purpose
Confirm that Phase 10Z.0 through Phase 10Z.4 remain stable before Phase 11 deployment.

## Scope
This audit checks backend files, route mounts, operations folders, permanent court/agency coverage, and live endpoint readiness.

## Inputs
- backend\src
- backend\src\index.js
- _operations
- localhost backend endpoints on port 5100

## Outputs
- Console PASS / FAIL
- JSON audit report
- TXT audit report
- CSV audit report

## Parameters
- Project root: $ProjectRoot
- Backend port assumed: 5100
- Required permanent coverage: Industrial Court, PERKESO, Google Maps, Waze, court navigation

## Rules
1. Do not proceed to Phase 11 if file/mount checks fail.
2. Do not proceed to Phase 11 if backend cannot start.
3. Live endpoint checks require backend to be running.
4. Any failed endpoint must be repaired before Phase 11.
5. All Phase 10Z route mounts must remain in backend\src\index.js.

## Process
1. Run STOP-L360.bat.
2. Run START-L360-CLEAN.bat.
3. Run this audit script.
4. Review report paths.
5. If all required checks pass, proceed to Phase 11.
6. If any required check fails, patch the specific phase before proceeding.

## Validation
Expected final result:
PHASE 10Z FINAL GATE REGRESSION AUDIT STATUS: PASS

## Operator Checklist
- [ ] 10Z.0 route works
- [ ] 10Z.1 route works
- [ ] 10Z.2 route works
- [ ] 10Z.3 route works
- [ ] 10Z.4 route works
- [ ] Industrial Court coverage remains present
- [ ] PERKESO coverage remains present
- [ ] Google Maps coverage remains present
- [ ] Waze coverage remains present
- [ ] Backend health endpoints respond
"@

$protocolPath = Join-Path $DocsDir "PHASE-10Z-FINAL-GATE-REGRESSION-AUDIT-PROTOCOL.md"
$protocol | Out-File -LiteralPath $protocolPath -Encoding UTF8 -Force

$reportJson = Join-Path $ReportDir "phase-10Z-final-gate-regression-audit.json"
$reportTxt = Join-Path $ReportDir "phase-10Z-final-gate-regression-audit.txt"
$reportCsv = Join-Path $ReportDir "phase-10Z-final-gate-regression-audit.csv"

$results | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $reportJson -Encoding UTF8 -Force
$results | Format-Table -AutoSize | Out-String | Out-File -LiteralPath $reportTxt -Encoding UTF8 -Force
$results | Export-Csv -LiteralPath $reportCsv -NoTypeInformation -Encoding UTF8 -Force

$failed = $results | Where-Object { $_.Result -ne $true }

Write-Host ""
Write-Host "Reports:"
Write-Host $reportJson
Write-Host $reportTxt
Write-Host $reportCsv
Write-Host $protocolPath

Write-Host ""
Write-Host "===================================================="
if ($failed.Count -eq 0) {
    Write-Host "PHASE 10Z FINAL GATE REGRESSION AUDIT STATUS: PASS"
} else {
    Write-Host "PHASE 10Z FINAL GATE REGRESSION AUDIT STATUS: FAIL"
    Write-Host ""
    Write-Host "Failed checks:"
    $failed | ForEach-Object {
        Write-Host ("- {0}" -f $_.Check)
    }
}
Write-Host "===================================================="
Write-Host ""

Read-Host "Press Enter to close"

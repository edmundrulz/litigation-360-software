# ============================================================
# L360_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.ps1
#
# Purpose:
#   Frontend-only smoke verification after:
#   - Phase 13C finalization
#   - Phase 13B status clarity patch
#   - Injector parse error fix
#   - Final SSOT marker
#
# What it does:
#   - Verifies static files
#   - Verifies frontend/backend runtime endpoints if launcher is running
#   - Runs frontend build check if npm build exists
#   - Creates a manual UI checklist
#   - Writes Phase 13B.1 report
#
# What it does NOT do:
#   - Does NOT edit source code
#   - Does NOT touch backend/database/RBAC/auth/package/env
#   - Does NOT run git clean/reset/init/commit
# ============================================================

$ErrorActionPreference = "Continue"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"

$ProjectRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ActiveControl = Join-Path $ProjectRoot "_L360_ACTIVE_CONTROL"

$FrontendDir = Join-Path $ProjectRoot "frontend"
$BackendDir = Join-Path $ProjectRoot "backend"
$MainJsx = Join-Path $FrontendDir "src\main.jsx"
$Injector = Join-Path $FrontendDir "src\l360-status-injector.js"
$FinalSSOT = Join-Path $ActiveControl "99_FINAL_CURRENT_STATE_AFTER_PHASE13B.md"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $LogDir "phase13b1_frontend_smoke_verification_$Stamp.log"
$ReportFile = Join-Path $ActiveControl "100_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.md"
$RunnerReport = Join-Path $RunnerDir "L360_PHASE13B1_FRONTEND_SMOKE_VERIFICATION_RESULT.txt"

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -LiteralPath $LogFile -Append -Encoding UTF8
}

function Test-Url {
    param([string]$Url, [int]$TimeoutSec = 3)
    try {
        $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec $TimeoutSec -Uri $Url
        $body = [string]$r.Content
        if ($null -eq $body) { $body = "" }
        $preview = $body.Substring(0, [Math]::Min(120, $body.Length))
        return [pscustomobject]@{ Url=$Url; Status=$r.StatusCode; Result="PASS"; Preview=$preview }
    } catch {
        return [pscustomobject]@{ Url=$Url; Status=""; Result="WAIT/FAIL"; Preview=$_.Exception.Message }
    }
}

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 PHASE 13B.1 FRONTEND SMOKE VERIFICATION" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "This does not edit app source code."
Write-Host "Log: $LogFile"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Phase 13B.1 frontend smoke verification started." "Cyan"

# Static checks.
$archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)

$mainContent = ""
if (Test-Path -LiteralPath $MainJsx) { $mainContent = Get-Content -Raw -LiteralPath $MainJsx }

$injectorContent = ""
if (Test-Path -LiteralPath $Injector) { $injectorContent = Get-Content -Raw -LiteralPath $Injector }

$staticChecks = @(
    [pscustomobject]@{ Check="Project MAIN exists"; Expected=$true; Actual=(Test-Path -LiteralPath $ProjectRoot); Path=$ProjectRoot },
    [pscustomobject]@{ Check="Original CLEANROOM removed"; Expected=$true; Actual=(-not (Test-Path -LiteralPath $CleanroomRoot)); Path=$CleanroomRoot },
    [pscustomobject]@{ Check="Archive exists"; Expected=$true; Actual=($archives.Count -ge 1); Path=$Workspace },
    [pscustomobject]@{ Check="Frontend folder exists"; Expected=$true; Actual=(Test-Path -LiteralPath $FrontendDir); Path=$FrontendDir },
    [pscustomobject]@{ Check="Backend folder exists"; Expected=$true; Actual=(Test-Path -LiteralPath $BackendDir); Path=$BackendDir },
    [pscustomobject]@{ Check="Final Phase13B SSOT exists"; Expected=$true; Actual=(Test-Path -LiteralPath $FinalSSOT); Path=$FinalSSOT },
    [pscustomobject]@{ Check="main.jsx imports injector"; Expected=$true; Actual=($mainContent -match "l360-status-injector\.js"); Path=$MainJsx },
    [pscustomobject]@{ Check="safe injector exists"; Expected=$true; Actual=(Test-Path -LiteralPath $Injector); Path=$Injector },
    [pscustomobject]@{ Check="safe injector marker present"; Expected=$true; Actual=($injectorContent -match "Safe version" -and $injectorContent -match "no JavaScript template literals"); Path=$Injector }
)

Write-Host "STATIC CHECKS" -ForegroundColor Yellow
$staticChecks | Format-Table -AutoSize

$staticPass = $true
foreach ($c in $staticChecks) {
    if ($c.Expected -ne $c.Actual) { $staticPass = $false }
}

# Node syntax check.
$nodeCheckResult = "NOT_RUN"
try {
    if (Test-Path -LiteralPath $FrontendDir) {
        Push-Location $FrontendDir
        cmd /c "node --check src\l360-status-injector.js"
        if ($LASTEXITCODE -eq 0) {
            $nodeCheckResult = "PASS"
            Write-Step "node --check PASS for l360-status-injector.js" "Green"
        } else {
            $nodeCheckResult = "FAIL"
            Write-Step "node --check FAIL for l360-status-injector.js" "Red"
        }
        Pop-Location
    }
} catch {
    try { Pop-Location } catch {}
    $nodeCheckResult = "ERROR: $($_.Exception.Message)"
    Write-Step "node --check error: $($_.Exception.Message)" "Red"
}

# Build check if available.
$buildResult = "NOT_RUN"
$buildOutputFile = Join-Path $LogDir "phase13b1_frontend_build_$Stamp.log"

try {
    $pkgPath = Join-Path $FrontendDir "package.json"
    if (Test-Path -LiteralPath $pkgPath) {
        $pkg = Get-Content -Raw -LiteralPath $pkgPath | ConvertFrom-Json
        $scriptNames = @()
        if ($pkg.scripts) { $scriptNames = @($pkg.scripts.PSObject.Properties.Name) }

        if ($scriptNames -contains "build") {
            Write-Step "Running frontend build check: npm run build" "Cyan"
            Push-Location $FrontendDir
            cmd /c "npm run build > `"$buildOutputFile`" 2>&1"
            $exit = $LASTEXITCODE
            Pop-Location

            if ($exit -eq 0) {
                $buildResult = "PASS"
                Write-Step "Frontend build check PASS." "Green"
            } else {
                $buildResult = "FAIL_EXIT_$exit"
                Write-Step "Frontend build check failed with exit code $exit. See $buildOutputFile" "Red"
            }
        } else {
            $buildResult = "NO_BUILD_SCRIPT"
            Write-Step "No frontend build script found; skipped build check." "Yellow"
        }
    } else {
        $buildResult = "NO_PACKAGE_JSON"
    }
} catch {
    try { Pop-Location } catch {}
    $buildResult = "ERROR: $($_.Exception.Message)"
    Write-Step "Build check error: $($_.Exception.Message)" "Red"
}

# Runtime checks if launcher is open.
$backendResults = @()
foreach ($p in @(5000,5100,5060,5061,8080)) {
    foreach ($path in @("/api/status","/api/health")) {
        $backendResults += Test-Url -Url "http://localhost:$p$path"
    }
}

$frontendResults = @()
foreach ($p in @(5173,3000,4173)) {
    $frontendResults += Test-Url -Url "http://localhost:$p"
}

# SPA route checks on frontend pass port.
$frontendPass = @($frontendResults | Where-Object { $_.Result -eq "PASS" })
$routeResults = @()
$baseFrontendUrl = $null

if ($frontendPass.Count -ge 1) {
    $baseFrontendUrl = $frontendPass[0].Url
    foreach ($route in @("/", "/documents", "/matters", "/clients", "/dashboard")) {
        $routeResults += Test-Url -Url ($baseFrontendUrl.TrimEnd("/") + $route)
    }
}

$backendPass = @($backendResults | Where-Object { $_.Result -eq "PASS" })
$routePass = @($routeResults | Where-Object { $_.Result -eq "PASS" })

Write-Host ""
Write-Host "BACKEND RUNTIME CHECKS" -ForegroundColor Green
$backendResults | Format-Table -AutoSize

Write-Host ""
Write-Host "FRONTEND RUNTIME CHECKS" -ForegroundColor Magenta
$frontendResults | Format-Table -AutoSize

Write-Host ""
Write-Host "SPA ROUTE SMOKE CHECKS" -ForegroundColor Cyan
if ($routeResults.Count -gt 0) {
    $routeResults | Format-Table -AutoSize
} else {
    Write-Host "No frontend PASS URL found; route checks skipped."
}

$runtimePass = (($backendPass.Count -ge 1) -and ($frontendPass.Count -ge 1))
$routeSmokePass = (($routeResults.Count -eq 0) -or ($routePass.Count -ge 1))

$overallPass = ($staticPass -and ($nodeCheckResult -eq "PASS") -and ($buildResult -eq "PASS" -or $buildResult -eq "NO_BUILD_SCRIPT") -and $runtimePass -and $routeSmokePass)

# Manual checklist.
$manualChecklist = @"
## Manual Browser Checklist

Open the app:

`http://localhost:5173`

Confirm these manually:

- [ ] App loads without Vite red error overlay.
- [ ] No obvious blank white screen.
- [ ] L360 / LEOS Operational Status panel appears at bottom-right.
- [ ] Status panel says Phase 13B.
- [ ] Status panel says Documents metadata-only.
- [ ] Status panel says RBAC parked.
- [ ] Status panel says Phase 11 locked.
- [ ] Status panel says Production rollout blocked.
- [ ] Close/hide button on the panel works.
- [ ] Main navigation/sidebar still appears.
- [ ] Documents page still opens.
- [ ] Matters/dashboard/client pages still open if they existed before.
- [ ] Backend monitor still shows PASS.
- [ ] Frontend monitor still shows PASS.

"@

# Write report.
$report = @"
# L360 / LEOS — Phase 13B.1 Frontend Smoke Verification

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Verdict

Overall automated pass: **$overallPass**

Static/file checks pass: **$staticPass**

Node injector syntax check: **$nodeCheckResult**

Frontend build check: **$buildResult**

Backend runtime pass count: **$($backendPass.Count)**

Frontend runtime pass count: **$($frontendPass.Count)**

SPA route pass count: **$($routePass.Count)**

## Scope

This checkpoint is frontend-only verification/polish control.

No application source code was changed by this script.

## Static Checks

$($staticChecks | Format-Table -AutoSize | Out-String)

## Backend Runtime Checks

$($backendResults | Format-Table -AutoSize | Out-String)

## Frontend Runtime Checks

$($frontendResults | Format-Table -AutoSize | Out-String)

## SPA Route Smoke Checks

$($routeResults | Format-Table -AutoSize | Out-String)

## Build Output

Build result: **$buildResult**

Build output file:

`$buildOutputFile`

$manualChecklist

## Safety Notes

This script did not:

- edit frontend source code
- edit backend
- edit database
- edit RBAC/auth
- edit routes
- edit package.json
- edit package-lock.json
- edit `.env`
- touch `litigation-360-software_LEOS_CONTROL`
- run `git clean`
- run `git reset`
- initialize Git
- create a commit

## Current Recommended Next Step

### If overall automated pass is TRUE and manual checklist is acceptable

Proceed to **clean version-control baseline planning**, but only with explicit approval.

Recommended next gate phrase:

`APPROVE SAFE GIT BASELINE ONLY`

### If overall automated pass is FALSE

Do not proceed to Git or new feature work.

Review this report and fix only the failing frontend/runtime item.

## Still Blocked

- RBAC repair
- backend route edits
- database migrations
- Phase 11 unlock
- production/client rollout

"@

$report | Set-Content -LiteralPath $ReportFile -Encoding UTF8

$runnerText = @"
L360 PHASE 13B.1 FRONTEND SMOKE VERIFICATION RESULT
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Overall automated pass:
$overallPass

Static pass:
$staticPass

Node injector syntax:
$nodeCheckResult

Frontend build:
$buildResult

Backend pass count:
$($backendPass.Count)

Frontend pass count:
$($frontendPass.Count)

SPA route pass count:
$($routePass.Count)

Report:
$ReportFile

Next:
If pass and manual browser checklist is acceptable, the next recommended gate is:
APPROVE SAFE GIT BASELINE ONLY

Do not proceed to backend/RBAC/database/Phase11/production rollout.
"@

$runnerText | Set-Content -LiteralPath $RunnerReport -Encoding UTF8

Write-Step "Phase 13B.1 report written: $ReportFile" "Green"
Write-Step "Runner summary written: $RunnerReport" "Green"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " PHASE 13B.1 VERDICT" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Overall automated pass: $overallPass"
Write-Host "Static pass           : $staticPass"
Write-Host "Node syntax check     : $nodeCheckResult"
Write-Host "Build check           : $buildResult"
Write-Host "Backend pass count    : $($backendPass.Count)"
Write-Host "Frontend pass count   : $($frontendPass.Count)"
Write-Host "Route pass count      : $($routePass.Count)"
Write-Host ""
Write-Host "Report:"
Write-Host "  $ReportFile"
Write-Host ""
if ($overallPass) {
    Write-Host "NEXT SAFE GATE:" -ForegroundColor Green
    Write-Host "Manual browser checklist, then safe Git baseline only if approved."
    Write-Host "Approval phrase: APPROVE SAFE GIT BASELINE ONLY"
} else {
    Write-Host "NEXT SAFE ACTION:" -ForegroundColor Yellow
    Write-Host "Review failed check above. Do not proceed to Git or feature work yet."
}
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Read-Host "Press ENTER to close"

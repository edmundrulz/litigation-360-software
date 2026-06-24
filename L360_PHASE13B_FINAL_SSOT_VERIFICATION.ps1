# ============================================================
# L360_PHASE13B_FINAL_SSOT_VERIFICATION.ps1
#
# Purpose:
#   Finalize the local status after:
#   - Phase 13C cleanroom cutover/finalization
#   - Phase 13B frontend status clarity patch
#   - Phase 13B injector parse-error repair
#   - Runtime verification expected
#
# What it does:
#   - Verifies folder/code/runtime state
#   - Writes final SSOT markdown into _L360_ACTIVE_CONTROL
#   - Writes a human-readable resume file into _L360_RUNNER
#   - Does NOT edit backend/database/RBAC/auth/package/env
#   - Does NOT run git clean/reset
#   - Does NOT initialize Git automatically
# ============================================================

$ErrorActionPreference = "Continue"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"

$ProjectRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ControlRoot = Join-Path $Workspace "litigation-360-software_LEOS_CONTROL"
$ActiveControl = Join-Path $ProjectRoot "_L360_ACTIVE_CONTROL"

$MainJsx = Join-Path $ProjectRoot "frontend\src\main.jsx"
$Injector = Join-Path $ProjectRoot "frontend\src\l360-status-injector.js"
$BackendPkg = Join-Path $ProjectRoot "backend\package.json"
$FrontendPkg = Join-Path $ProjectRoot "frontend\package.json"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $LogDir "phase13b_final_ssot_verification_$Stamp.log"
$FinalSSOT = Join-Path $ActiveControl "99_FINAL_CURRENT_STATE_AFTER_PHASE13B.md"
$ResumeFile = Join-Path $RunnerDir "L360_CURRENT_STATUS_READ_THIS_FIRST.txt"

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -LiteralPath $LogFile -Append -Encoding UTF8
}

function Test-Url {
    param([string]$Url, [int]$TimeoutSec = 2)

    try {
        $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec $TimeoutSec -Uri $Url
        return [pscustomobject]@{ Url=$Url; Status=$r.StatusCode; Result="PASS" }
    } catch {
        return [pscustomobject]@{ Url=$Url; Status=""; Result="WAIT/FAIL" }
    }
}

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 PHASE 13B FINAL SSOT VERIFICATION" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "This records the current verified state."
Write-Host "It does not touch backend/database/RBAC/auth/package/env."
Write-Host "Log: $LogFile"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Final SSOT verification started." "Cyan"

$archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)
$leftovers = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-CLEANROOM-13C-LEFTOVER*" -ErrorAction SilentlyContinue)

$mainContent = ""
if (Test-Path -LiteralPath $MainJsx) {
    $mainContent = Get-Content -Raw -LiteralPath $MainJsx
}

$injectorContent = ""
if (Test-Path -LiteralPath $Injector) {
    $injectorContent = Get-Content -Raw -LiteralPath $Injector
}

$folderChecks = @(
    [pscustomobject]@{ Check="Official MAIN exists"; Expected=$true; Actual=(Test-Path -LiteralPath $ProjectRoot); Path=$ProjectRoot },
    [pscustomobject]@{ Check="Original CLEANROOM-13C removed"; Expected=$true; Actual=(-not (Test-Path -LiteralPath $CleanroomRoot)); Path=$CleanroomRoot },
    [pscustomobject]@{ Check="Polluted archive exists"; Expected=$true; Actual=($archives.Count -ge 1); Path=$Workspace },
    [pscustomobject]@{ Check="Backend package exists"; Expected=$true; Actual=(Test-Path -LiteralPath $BackendPkg); Path=$BackendPkg },
    [pscustomobject]@{ Check="Frontend package exists"; Expected=$true; Actual=(Test-Path -LiteralPath $FrontendPkg); Path=$FrontendPkg },
    [pscustomobject]@{ Check="main.jsx exists"; Expected=$true; Actual=(Test-Path -LiteralPath $MainJsx); Path=$MainJsx },
    [pscustomobject]@{ Check="status injector exists"; Expected=$true; Actual=(Test-Path -LiteralPath $Injector); Path=$Injector },
    [pscustomobject]@{ Check="main.jsx imports injector"; Expected=$true; Actual=($mainContent -match "l360-status-injector\.js"); Path=$MainJsx },
    [pscustomobject]@{ Check="injector safe version present"; Expected=$true; Actual=($injectorContent -match "Safe version" -and $injectorContent -match "STATUS_ID"); Path=$Injector }
)

Write-Host "STATIC / FILE CHECKS" -ForegroundColor Yellow
$folderChecks | Format-Table -AutoSize

Write-Host ""
Write-Host "RUNTIME CHECKS" -ForegroundColor Yellow
Write-Host "If launcher is currently running, these should show PASS."
Write-Host "If not running, they may show WAIT/FAIL; run L360_START_ALL.bat after this."
Write-Host ""

$backendResults = @()
foreach ($p in @(5000,5100,5060,5061,8080)) {
    foreach ($path in @("/api/status","/api/health")) {
        $backendResults += Test-Url -Url "http://localhost:$p$path" -TimeoutSec 2
    }
}

$frontendResults = @()
foreach ($p in @(5173,3000,4173)) {
    $frontendResults += Test-Url -Url "http://localhost:$p" -TimeoutSec 2
}

$backendPass = @($backendResults | Where-Object { $_.Result -eq "PASS" })
$frontendPass = @($frontendResults | Where-Object { $_.Result -eq "PASS" })

Write-Host "Backend endpoints:" -ForegroundColor Green
$backendResults | Format-Table -AutoSize

Write-Host ""
Write-Host "Frontend endpoints:" -ForegroundColor Magenta
$frontendResults | Format-Table -AutoSize

$staticPass = $true
foreach ($c in $folderChecks) {
    if ($c.Expected -ne $c.Actual) {
        $staticPass = $false
    }
}

$runtimePass = (($backendPass.Count -ge 1) -and ($frontendPass.Count -ge 1))

$gitExists = Test-Path -LiteralPath (Join-Path $ProjectRoot ".git")
$gitStatus = "NOT_CHECKED"
$gitBranch = "N/A"

if ($gitExists) {
    try {
        Push-Location $ProjectRoot
        $gitBranch = (git branch --show-current 2>$null)
        $gitStatus = (git status --short 2>$null | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($gitStatus)) { $gitStatus = "CLEAN_OR_NO_CHANGES_SHOWN" }
        Pop-Location
    } catch {
        try { Pop-Location } catch {}
        $gitStatus = "GIT_CHECK_FAILED"
    }
} else {
    $gitStatus = "NO_GIT_REPOSITORY_FOUND"
}

Write-Host ""
Write-Host "VERDICT" -ForegroundColor Cyan
if ($staticPass -and $runtimePass) {
    Write-Host "PASS — Phase 13B is applied and runtime verified." -ForegroundColor Green
}
elseif ($staticPass -and -not $runtimePass) {
    Write-Host "PARTIAL PASS — files are correct, but runtime endpoints were not both reachable." -ForegroundColor Yellow
    Write-Host "Run L360_START_ALL.bat and verify Backend PASS + Frontend PASS." -ForegroundColor Yellow
}
else {
    Write-Host "NOT READY — at least one static/file check failed." -ForegroundColor Red
}

# Write SSOT.
$ssot = @"
# L360 / LEOS — Final Current State After Phase 13B

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Verdict

Static/file verification pass: **$staticPass**

Runtime verification pass: **$runtimePass**

Backend endpoint pass count: **$($backendPass.Count)**

Frontend endpoint pass count: **$($frontendPass.Count)**

## Current Project Position

| Area | Status |
|---|---|
| Phase 12 | Complete |
| Phase 13A | Complete |
| Phase 13C | Cleanroom/folder cutover finalized enough for Phase 13B continuation |
| Phase 13B | Frontend status clarity patch applied |
| Phase 13B parse error | Fixed |
| Runtime verification | $(if ($runtimePass) { "PASS" } else { "Pending/needs launcher running" }) |
| RBAC | Parked |
| Documents | Metadata-only |
| Phase 11 | Locked |
| Production/client rollout | Blocked |

## Folder State

| Item | Path / Status |
|---|---|
| Official active main | `$ProjectRoot` |
| Original cleanroom path | `$CleanroomRoot` |
| Original cleanroom removed | `$(-not (Test-Path -LiteralPath $CleanroomRoot))` |
| Polluted archive count | `$($archives.Count)` |
| Leftover cleanroom archive count | `$($leftovers.Count)` |
| LEOS control folder | `$ControlRoot` |

## Phase 13B Files

| File | Status |
|---|---|
| `frontend/src/main.jsx` | Exists: $(Test-Path -LiteralPath $MainJsx); imports injector: $($mainContent -match "l360-status-injector\.js") |
| `frontend/src/l360-status-injector.js` | Exists: $(Test-Path -LiteralPath $Injector); safe version present: $($injectorContent -match "Safe version") |

## Runtime Proof

### Backend

Pass count: $($backendPass.Count)

$($backendResults | Format-Table -AutoSize | Out-String)

### Frontend

Pass count: $($frontendPass.Count)

$($frontendResults | Format-Table -AutoSize | Out-String)

## Git / Version Control Check

Git repository exists: **$gitExists**

Git branch: **$gitBranch**

Git status summary:

````text
$gitStatus
````

No Git initialization or commit was performed by this script.

## Safety Notes

This verification/final SSOT script did not:

- edit backend
- edit database
- edit RBAC/auth
- edit routes
- edit package.json
- edit package-lock.json
- edit `.env`
- touch `litigation-360-software_LEOS_CONTROL`
- run `git clean`
- run `git reset --hard`
- initialize Git automatically

## Next Recommended Course

### If runtime is PASS

1. Treat Phase 13B frontend status clarity as **applied + runtime verified**.
2. Freeze backend/RBAC/database work.
3. Prepare the next checkpoint as a frontend-only verification/polish task.
4. Only after approval, create a clean Git/version-control baseline.

### If runtime is not PASS

1. Run:
   `$RunnerDir\L360_START_ALL.bat`
2. Confirm:
   - Mode: MAIN
   - Backend: PASS
   - Frontend: PASS
3. Re-run this final SSOT verification script.

## Do Not Proceed To

- RBAC repair
- backend route edits
- database migrations
- production/client rollout
- Phase 11 unlock

until a separate approval gate is explicitly given.

"@

$ssot | Set-Content -LiteralPath $FinalSSOT -Encoding UTF8

$resume = @"
L360 CURRENT STATUS — READ THIS FIRST
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

CURRENT POSITION:
- Phase 12: Complete
- Phase 13A: Complete
- Phase 13C: Cleanroom/folder cutover finalized enough for Phase 13B
- Phase 13B: Frontend status clarity patch applied
- Phase 13B parse error: Fixed
- Runtime pass: $runtimePass
- RBAC: Parked
- Documents: Metadata-only
- Phase 11: Locked
- Production/client rollout: Blocked

MAIN ACTIVE FOLDER:
$ProjectRoot

FINAL SSOT FILE:
$FinalSSOT

NEXT ACTION:
$(if ($runtimePass) {
"Phase 13B can be treated as applied + runtime verified. Next recommended step: frontend-only verification/polish checkpoint or clean Git baseline only after explicit approval."
} else {
"Run L360_START_ALL.bat and confirm Backend PASS + Frontend PASS, then rerun final SSOT verification."
})

DO NOT DO YET:
- backend/RBAC/database edits
- Git reset/clean
- production rollout
- Phase 11 unlock
"@

$resume | Set-Content -LiteralPath $ResumeFile -Encoding UTF8

Write-Step "Final SSOT written: $FinalSSOT" "Green"
Write-Step "Resume file written: $ResumeFile" "Green"

Write-Host ""
Write-Host "FILES WRITTEN" -ForegroundColor Green
Write-Host "Final SSOT:"
Write-Host "  $FinalSSOT"
Write-Host ""
Write-Host "Resume file:"
Write-Host "  $ResumeFile"
Write-Host ""

if ($staticPass -and $runtimePass) {
    Write-Host "NEXT SAFE ACTION:" -ForegroundColor Green
    Write-Host "Phase 13B is now applied + runtime verified."
    Write-Host "Next: frontend-only polish/verification checkpoint, or Git baseline only after approval."
} elseif ($staticPass) {
    Write-Host "NEXT SAFE ACTION:" -ForegroundColor Yellow
    Write-Host "Run launcher and confirm runtime PASS:"
    Write-Host "  $RunnerDir\L360_START_ALL.bat"
} else {
    Write-Host "NEXT SAFE ACTION:" -ForegroundColor Red
    Write-Host "Static checks failed. Do not continue feature work."
}

Write-Host ""
Read-Host "Press ENTER to close"

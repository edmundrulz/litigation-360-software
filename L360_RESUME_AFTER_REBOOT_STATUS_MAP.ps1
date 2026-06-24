# ============================================================
# L360_RESUME_AFTER_REBOOT_STATUS_MAP.ps1
#
# Purpose:
#   After reboot confusion reset.
#   This script does NOT modify anything.
#   It reports where you are and what to run next.
# ============================================================

$ErrorActionPreference = "Continue"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"

$MainRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ControlRoot = Join-Path $Workspace "litigation-360-software_LEOS_CONTROL"
$ActiveControl = Join-Path $MainRoot "_L360_ACTIVE_CONTROL"

$LauncherBat = Join-Path $RunnerDir "L360_START_ALL.bat"
$Phase13BBat = Join-Path $RunnerDir "L360_PHASE13B_FRONTEND_STATUS_CLARITY.bat"
$V4Script = Join-Path $RunnerDir "L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1"
$V4Result = Join-Path $RunnerDir "PHASE13C_V4_AFTER_REBOOT_RESULT.txt"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ResumeReport = Join-Path $RunnerDir ("L360_RESUME_AFTER_REBOOT_REPORT_" + $Stamp + ".txt")

function BoolText($value) {
    if ($value) { return "YES" }
    return "NO"
}

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 RESUME AFTER REBOOT — STATUS MAP" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "This does NOT change files. It only tells you where you are."
Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)
$leftoverCleanrooms = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-CLEANROOM-13C-LEFTOVER*" -ErrorAction SilentlyContinue)

$markers = @()
if (Test-Path -LiteralPath $ActiveControl) {
    $markers += @(Get-ChildItem -LiteralPath $ActiveControl -File -Filter "*CUTOVER*" -ErrorAction SilentlyContinue)
    $markers += @(Get-ChildItem -LiteralPath $ActiveControl -File -Filter "*FINALIZED*" -ErrorAction SilentlyContinue)
    $statusFile = Join-Path $ActiveControl "00_PHASE_13C_CLEANROOM_CUTOVER_STATUS.md"
    if (Test-Path -LiteralPath $statusFile) {
        $markers += @(Get-Item -LiteralPath $statusFile)
    }
}

$v4Logs = @(Get-ChildItem -LiteralPath $LogDir -File -Filter "phase13c_finalizer_v4_after_reboot_*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)
$v3Logs = @(Get-ChildItem -LiteralPath $LogDir -File -Filter "phase13c_finalizer_v3_*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)

$checks = @(
    [pscustomobject]@{ Check="Workspace exists"; Needed="YES"; Actual=(BoolText(Test-Path -LiteralPath $Workspace)); Path=$Workspace },
    [pscustomobject]@{ Check="Official MAIN exists"; Needed="YES"; Actual=(BoolText(Test-Path -LiteralPath $MainRoot)); Path=$MainRoot },
    [pscustomobject]@{ Check="Original CLEANROOM-13C removed"; Needed="YES"; Actual=(BoolText(-not (Test-Path -LiteralPath $CleanroomRoot))); Path=$CleanroomRoot },
    [pscustomobject]@{ Check="Polluted archive exists"; Needed="YES"; Actual=(BoolText($archives.Count -ge 1)); Path=$Workspace },
    [pscustomobject]@{ Check="Backend package in MAIN"; Needed="YES"; Actual=(BoolText(Test-Path -LiteralPath (Join-Path $MainRoot "backend\package.json"))); Path=(Join-Path $MainRoot "backend\package.json") },
    [pscustomobject]@{ Check="Frontend package in MAIN"; Needed="YES"; Actual=(BoolText(Test-Path -LiteralPath (Join-Path $MainRoot "frontend\package.json"))); Path=(Join-Path $MainRoot "frontend\package.json") },
    [pscustomobject]@{ Check="Cutover/finalizer marker exists"; Needed="YES"; Actual=(BoolText($markers.Count -ge 1)); Path=$ActiveControl },
    [pscustomobject]@{ Check="Launcher exists"; Needed="YES"; Actual=(BoolText(Test-Path -LiteralPath $LauncherBat)); Path=$LauncherBat },
    [pscustomobject]@{ Check="Phase 13B patch exists"; Needed="YES"; Actual=(BoolText(Test-Path -LiteralPath $Phase13BBat)); Path=$Phase13BBat }
)

Write-Host "CURRENT CHECKS" -ForegroundColor Yellow
$checks | Format-Table -AutoSize

Write-Host ""
Write-Host "CURRENT LITIGATION FOLDERS" -ForegroundColor Yellow
Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software*" -ErrorAction SilentlyContinue |
    Select-Object Name, FullName |
    Format-Table -AutoSize

Write-Host ""
Write-Host "V4 RESULT FILE" -ForegroundColor Yellow
if (Test-Path -LiteralPath $V4Result) {
    Write-Host $V4Result -ForegroundColor Green
    Write-Host ""
    Get-Content -LiteralPath $V4Result -TotalCount 40
} else {
    Write-Host "No V4 result file found." -ForegroundColor Red
}

Write-Host ""
Write-Host "LATEST V4 LOG" -ForegroundColor Yellow
if ($v4Logs.Count -gt 0) {
    Write-Host $v4Logs[0].FullName -ForegroundColor Green
    Get-Content -LiteralPath $v4Logs[0].FullName -Tail 20
} else {
    Write-Host "No V4 log found." -ForegroundColor Red
}

# Determine final phase state.
$phase13cFinal =
    (Test-Path -LiteralPath $MainRoot) -and
    (-not (Test-Path -LiteralPath $CleanroomRoot)) -and
    ($archives.Count -ge 1) -and
    (Test-Path -LiteralPath (Join-Path $MainRoot "backend\package.json")) -and
    (Test-Path -LiteralPath (Join-Path $MainRoot "frontend\package.json")) -and
    ($markers.Count -ge 1)

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " VERDICT / WHERE YOU ARE NOW" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$next = ""

if ($phase13cFinal) {
    Write-Host "STATUS: PHASE 13C FOLDER CUTOVER IS FINALIZED." -ForegroundColor Green
    Write-Host ""
    Write-Host "You are now ready for post-cutover runtime proof, then Phase 13B." -ForegroundColor Green
    Write-Host ""
    Write-Host "RUN NEXT #1:" -ForegroundColor Yellow
    Write-Host "  $LauncherBat"
    Write-Host ""
    Write-Host "Expected in launcher/monitor:"
    Write-Host "  Mode: MAIN"
    Write-Host "  Backend: PASS"
    Write-Host "  Frontend: PASS"
    Write-Host ""
    Write-Host "RUN NEXT #2 only after launcher passes:" -ForegroundColor Yellow
    Write-Host "  $Phase13BBat"
    $next = "PHASE13C_FINAL__RUN_LAUNCHER_THEN_PHASE13B"
}
else {
    Write-Host "STATUS: PHASE 13C IS NOT FINAL YET." -ForegroundColor Red
    Write-Host ""
    Write-Host "Do NOT run Phase 13B yet." -ForegroundColor Red

    if (Test-Path -LiteralPath $CleanroomRoot) {
        Write-Host "- Original CLEANROOM-13C still exists." -ForegroundColor Yellow
    }
    if ($archives.Count -lt 1) {
        Write-Host "- Polluted archive folder is missing." -ForegroundColor Yellow
    }
    if ($markers.Count -lt 1) {
        Write-Host "- Cutover/finalizer marker is missing." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "RUN NEXT:" -ForegroundColor Yellow
    if (Test-Path -LiteralPath $V4Script) {
        Write-Host "  Right-click this script and run with PowerShell, or run it from PowerShell:"
        Write-Host "  $V4Script"
        Write-Host ""
        Write-Host "Better option if locks continue:"
        Write-Host "  Reinstall the V4 RunOnce pack, reboot again, login, and do not open anything first."
        $next = "PHASE13C_NOT_FINAL__RUN_V4_AFTER_REBOOT_SCRIPT_OR_REINSTALL_RUNONCE"
    }
    else {
        Write-Host "  V4 script not found in _L360_RUNNER."
        Write-Host "  Re-extract the V4 Reboot RunOnce Pack and run:"
        Write-Host "  INSTALL_L360_PHASE13C_FINALIZER_V4_RUNONCE.bat"
        $next = "PHASE13C_NOT_FINAL__V4_SCRIPT_MISSING__REEXTRACT_V4_PACK"
    }
}

$report = @"
L360 RESUME AFTER REBOOT REPORT
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Phase13CFinal:
$phase13cFinal

NextActionCode:
$next

Key Paths:
Workspace:
$Workspace

MainRoot:
$MainRoot

CleanroomRoot:
$CleanroomRoot

Launcher:
$LauncherBat

Phase13B:
$Phase13BBat

V4Script:
$V4Script

V4Result:
$V4Result

ArchiveFolderCount:
$($archives.Count)

LeftoverCleanroomArchiveCount:
$($leftoverCleanrooms.Count)

MarkerCount:
$($markers.Count)

LatestV4Log:
$(if($v4Logs.Count -gt 0){$v4Logs[0].FullName}else{"NONE"})

Current Folders:
$((Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software*" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }) -join "`r`n")
"@

$report | Set-Content -LiteralPath $ResumeReport -Encoding UTF8

Write-Host ""
Write-Host "Resume report saved:" -ForegroundColor Cyan
Write-Host "  $ResumeReport"
Write-Host ""
Read-Host "Press ENTER to close"

# ============================================================
# LITIGATION 360 LEOS
# ROLLBACK PHASE 12.0D-B-R3 MATTER DETAILS UI PATCH
# PURPOSE:
#   Restore Cases.jsx from the original R2 pre-patch backup if available.
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$TargetFile = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Cases.jsx"
$BackupFile = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\02_SNAPSHOTS\20260623-001221-PHASE12.0D-B-R2-MATTER-DETAILS-UI-PATCH\frontend-src-pages-Cases.jsx.before-phase12.0D-B-R2.bak"

Write-Host ""
Write-Host "ROLLBACK PHASE 12.0D-B-R3 MATTER DETAILS UI PATCH" -ForegroundColor Yellow
Write-Host "Target: $TargetFile" -ForegroundColor Yellow
Write-Host "Backup: $BackupFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "Type ROLLBACK to continue:" -ForegroundColor Yellow

$Confirm = Read-Host

if ($Confirm -ne "ROLLBACK") {
    Write-Host "Rollback cancelled." -ForegroundColor Cyan
    exit 0
}

if (!(Test-Path $BackupFile)) {
    throw "Backup file not found: $BackupFile"
}

Copy-Item -Path $BackupFile -Destination $TargetFile -Force

Write-Host ""
Write-Host "Rollback complete." -ForegroundColor Green
Write-Host "Restored: $TargetFile" -ForegroundColor Green
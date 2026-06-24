# ============================================================
# LITIGATION 360 LEOS
# ROLLBACK PHASE 12.0D-C-R2 MATTER DETAILS RUNTIME SAFETY PATCH
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$TargetFile = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Cases.jsx"
$BackupFile = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\02_SNAPSHOTS\20260623-003036-PHASE12.0D-C-R2-MATTER-DETAILS-RUNTIME-SAFETY\frontend-src-pages-Cases.jsx.before-phase12.0D-C-R2.bak"

Write-Host ""
Write-Host "ROLLBACK PHASE 12.0D-C-R2 MATTER DETAILS RUNTIME SAFETY PATCH" -ForegroundColor Yellow
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
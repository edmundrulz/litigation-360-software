# ============================================================
# LITIGATION 360 LEOS
# ROLLBACK PHASE 12.0D MATTER DETAILS TARGET FILES
# PURPOSE:
#   Restore target files from backup folder.
# BACKUP:
#   C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\02_SNAPSHOTS\20260622-235455-PHASE12.0D-A-MATTER-DETAILS-TARGET-LOCK
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$FrontendCases = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Cases.jsx"
$FrontendApi   = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\api.js"
$BackendCases  = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\cases.js"

$BackupFrontendCases = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\02_SNAPSHOTS\20260622-235455-PHASE12.0D-A-MATTER-DETAILS-TARGET-LOCK\frontend-src-pages-Cases.jsx.bak"
$BackupFrontendApi   = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\02_SNAPSHOTS\20260622-235455-PHASE12.0D-A-MATTER-DETAILS-TARGET-LOCK\frontend-src-api.js.bak"
$BackupBackendCases  = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\02_SNAPSHOTS\20260622-235455-PHASE12.0D-A-MATTER-DETAILS-TARGET-LOCK\backend-src-routes-cases.js.bak"

Write-Host ""
Write-Host "ROLLBACK PHASE 12.0D TARGET FILES" -ForegroundColor Yellow
Write-Host "This will restore the backed-up target files." -ForegroundColor Yellow
Write-Host "Type ROLLBACK to continue:" -ForegroundColor Yellow

$Confirm = Read-Host

if ($Confirm -ne "ROLLBACK") {
    Write-Host "Rollback cancelled." -ForegroundColor Cyan
    exit 0
}

if (Test-Path $BackupFrontendCases) {
    Copy-Item $BackupFrontendCases $FrontendCases -Force
    Write-Host "Restored: $FrontendCases" -ForegroundColor Green
}

if (Test-Path $BackupFrontendApi) {
    Copy-Item $BackupFrontendApi $FrontendApi -Force
    Write-Host "Restored: $FrontendApi" -ForegroundColor Green
}

if (Test-Path $BackupBackendCases) {
    Copy-Item $BackupBackendCases $BackendCases -Force
    Write-Host "Restored: $BackendCases" -ForegroundColor Green
}

Write-Host ""
Write-Host "Rollback complete." -ForegroundColor Green
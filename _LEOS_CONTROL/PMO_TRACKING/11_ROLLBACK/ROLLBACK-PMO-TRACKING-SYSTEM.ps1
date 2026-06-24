param(
    [switch]$ConfirmRollback
)

if (!$ConfirmRollback) {
    Write-Host "Rollback not executed." -ForegroundColor Yellow
    Write-Host "To rollback PMO tracking system folder, run:" -ForegroundColor Yellow
    Write-Host "powershell -ExecutionPolicy Bypass -File "$PSCommandPath" -ConfirmRollback" -ForegroundColor Cyan
    exit 0
}

$PmoRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\PMO_TRACKING"

if (!(Test-Path $PmoRoot)) {
    Write-Host "PMO folder not found. Nothing to rollback." -ForegroundColor Yellow
    exit 0
}

$ArchiveRoot = Join-Path "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\PMO_TRACKING_ROLLBACK_ARCHIVE" (Get-Date -Format "yyyyMMdd-HHmmss")
New-Item -ItemType Directory -Path $ArchiveRoot -Force | Out-Null

Copy-Item -Path $PmoRoot -Destination $ArchiveRoot -Recurse -Force

Write-Host "PMO tracking folder archived to:" -ForegroundColor Green
Write-Host $ArchiveRoot

Write-Host "Original PMO tracking folder was NOT deleted for safety." -ForegroundColor Yellow
Write-Host "Manual deletion is intentionally not performed by rollback."
$Injector = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\l360-status-injector.js"
$Backup = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_ACTIVE_CONTROL\backups\fix_phase13b_injector_parse_error_20260624_184813\l360-status-injector.js.broken.backup"

if (Test-Path -LiteralPath $Backup) {
    Copy-Item -LiteralPath $Backup -Destination $Injector -Force
    Write-Host "Restored previous injector backup."
} else {
    Write-Host "No backup found."
}

Read-Host "Press ENTER to close"

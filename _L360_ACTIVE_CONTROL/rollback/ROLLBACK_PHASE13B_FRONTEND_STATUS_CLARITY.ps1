$MainJsx = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\main.jsx"
$MainBackup = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_L360_ACTIVE_CONTROL\backups\phase13b_frontend_status_clarity_20260624_182957\main.jsx.backup"
$Injector = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\l360-status-injector.js"
if(Test-Path -LiteralPath $MainBackup){ Copy-Item -LiteralPath $MainBackup -Destination $MainJsx -Force; Write-Host "main.jsx restored." }
if(Test-Path -LiteralPath $Injector){ Remove-Item -LiteralPath $Injector -Force; Write-Host "injector removed." }
Read-Host "Press ENTER to close"

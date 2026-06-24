# LIVE STATUS SNAPSHOT SCRIPT
$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location $Root

$Report = "reports\master-system\monitoring\LIVE-STATUS-SNAPSHOT.txt"

"Litigation 360 Live Status Snapshot" | Out-File $Report
"Generated: $((Get-Date).ToString())" | Out-File $Report -Append
"" | Out-File $Report -Append

"Node Processes:" | Out-File $Report -Append
Get-Process node -ErrorAction SilentlyContinue | Select-Object Id,ProcessName,CPU,StartTime | Out-File $Report -Append

"" | Out-File $Report -Append
"Root Folder:" | Out-File $Report -Append
Get-ChildItem . | Select-Object Name,Mode,LastWriteTime | Out-File $Report -Append

Write-Host "LIVE STATUS SNAPSHOT CREATED"
Write-Host $Report

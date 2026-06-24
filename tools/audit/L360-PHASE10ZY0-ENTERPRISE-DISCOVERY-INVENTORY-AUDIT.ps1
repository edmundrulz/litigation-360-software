param(
 [ValidateSet("AUDIT")]
 [string]$Mode="AUDIT"
)

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Out=Join-Path $Root "_operations\phase-10ZY0-enterprise-discovery-inventory-audit"

$folders=@("reports","docs","validation","inventory","logs")
foreach($f in $folders){
 $p=Join-Path $Out $f
 if(!(Test-Path $p)){New-Item -ItemType Directory -Path $p -Force|Out-Null}
}

Write-Host "===================================================="
Write-Host "PHASE 10ZY.0 ENTERPRISE DISCOVERY & INVENTORY AUDIT"
Write-Host "===================================================="

if(!(Test-Path $Root)){ throw "Project root not found" }

$allFiles=Get-ChildItem $Root -Recurse -File -ErrorAction SilentlyContinue

$js=$allFiles | ? {$_.Extension -eq ".js"}
$jsx=$allFiles | ? {$_.Extension -eq ".jsx"}
$ps1=$allFiles | ? {$_.Extension -eq ".ps1"}
$md=$allFiles | ? {$_.Extension -eq ".md"}

$inventory=[ordered]@{
 ScanDate=(Get-Date)
 TotalFiles=$allFiles.Count
 JavaScriptFiles=$js.Count
 ReactFiles=$jsx.Count
 PowerShellFiles=$ps1.Count
 DocumentationFiles=$md.Count
 BackendRoutes=($allFiles | ? {$_.Name -like "*Routes.js"}).Count
 AutomationEngines=($allFiles | ? {$_.DirectoryName -like "*automation*"}).Count
 OperationsFolders=(Get-ChildItem (Join-Path $Root "_operations") -Directory -ErrorAction SilentlyContinue).Count
}

$txt=Join-Path $Out "reports\MASTER-INVENTORY.txt"
$json=Join-Path $Out "reports\MASTER-INVENTORY.json"

$inventory | ConvertTo-Json | Out-File $json -Encoding utf8

@"
ENTERPRISE DISCOVERY INVENTORY

Total Files: $($inventory.TotalFiles)
JavaScript Files: $($inventory.JavaScriptFiles)
React Files: $($inventory.ReactFiles)
PowerShell Files: $($inventory.PowerShellFiles)
Documentation Files: $($inventory.DocumentationFiles)
Backend Routes: $($inventory.BackendRoutes)
Automation Engines: $($inventory.AutomationEngines)
Operations Folders: $($inventory.OperationsFolders)

NEXT PHASES:
10ZZ.0 Documentation Recovery Audit
10ZZ.1 SOP Recovery
10ZZ.2 Validation Recovery
10ZZ.3 Testing Recovery
10ZZ.4 Governance Recovery
"@ | Out-File $txt -Encoding utf8

Write-Host ""
Write-Host "Inventory Report:"
Write-Host $txt
Write-Host $json
Write-Host ""
Write-Host "PHASE 10ZY.0 ENTERPRISE DISCOVERY & INVENTORY AUDIT STATUS: PASS"
Read-Host "Press Enter to close"

# MASTER AUDIT SCRIPT
$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location $Root

Get-Date | Out-File "reports\master-system\MASTER-AUDIT-TIMESTAMP.txt"

Get-ChildItem ".\backend\src\routes" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\ROUTES.txt"
Get-ChildItem ".\backend\src\utils" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\UTILITIES.txt"
Get-ChildItem ".\backend\src\services" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\SERVICES.txt"
Get-ChildItem ".\tests" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\TESTS.txt"
Get-ChildItem ".\docs" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\DOCS.txt"
Get-ChildItem ".\_operations" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\OPERATIONS.txt"
Get-ChildItem ".\scripts" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\SCRIPTS.txt"

Write-Host "MASTER AUDIT COMPLETE"
Write-Host "Output: reports\master-system\inventory"

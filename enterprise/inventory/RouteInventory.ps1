$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Output = "$Root\enterprise\reports\RouteInventory.csv"

Write-Host "Scanning JS route files..."

Get-ChildItem -Path $Root -Recurse -File -Filter *.js |
Where-Object {
    $_.FullName -notmatch "\\node_modules\\|\\.git\\|\\dist\\|\\build\\"
} |
Select-String -Pattern "router\.|app\.(get|post|put|delete)" |
Select-Object Path, LineNumber, Line |
Export-Csv $Output -NoTypeInformation

Write-Host "DONE:"
Write-Host $Output
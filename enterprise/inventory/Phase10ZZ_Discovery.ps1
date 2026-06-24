$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

$Output = "$Root\enterprise\reports"

New-Item -ItemType Directory -Force -Path $Output | Out-Null

Write-Host ""
Write-Host "LITIGATION 360 ENTERPRISE DISCOVERY"
Write-Host ""

Get-ChildItem $Root -Recurse -File |
Export-Csv "$Output\AllFiles.csv" -NoTypeInformation

Get-ChildItem $Root -Recurse -Include *.js |
Export-Csv "$Output\JavaScriptFiles.csv" -NoTypeInformation

Get-ChildItem $Root -Recurse -Include *.json |
Export-Csv "$Output\JsonFiles.csv" -NoTypeInformation

Get-ChildItem $Root -Recurse -Include *.md |
Export-Csv "$Output\DocumentationFiles.csv" -NoTypeInformation

Get-ChildItem $Root -Recurse -Include *.ps1 |
Export-Csv "$Output\PowerShellFiles.csv" -NoTypeInformation

Get-ChildItem $Root -Recurse -Directory |
Export-Csv "$Output\FolderInventory.csv" -NoTypeInformation

Write-Host ""
Write-Host "DISCOVERY COMPLETE"
Write-Host ""
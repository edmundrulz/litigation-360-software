$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Output = "$Root\enterprise\reports\DatabaseInventory.csv"

Write-Host "Scanning database definitions safely..."

Get-ChildItem "$Root\backend" -Recurse -File -Include *.js,*.sql,*.json -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "\\node_modules\\|\\.git\\|\\dist\\|\\build\\|\\enterprise\\" } |
Select-String -Pattern "sequelize|mongoose|CREATE TABLE|prisma|migration|sqlite|pool\.query|connection\.query" |
Select-Object Path, LineNumber, Line |
Export-Csv $Output -NoTypeInformation

Write-Host "DONE"
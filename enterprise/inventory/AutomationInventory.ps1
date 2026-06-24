$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Output = "$Root\enterprise\reports\AutomationInventory.csv"

Write-Host "Scanning automations safely..."

Get-ChildItem "$Root\backend" -Recurse -File -Include *.js,*.ps1,*.bat,*.cmd,*.json -ErrorAction SilentlyContinue |
Where-Object { $_.FullName -notmatch "\\node_modules\\|\\.git\\|\\dist\\|\\build\\|\\enterprise\\" } |
Select-String -Pattern "cron|schedule|workflow|automation|queue|job|trigger|setInterval|setTimeout" |
Select-Object Path, LineNumber, Line |
Export-Csv $Output -NoTypeInformation

Write-Host "DONE"
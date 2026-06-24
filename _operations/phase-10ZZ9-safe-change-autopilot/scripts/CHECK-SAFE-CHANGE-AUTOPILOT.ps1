Write-Host ''
Write-Host '==============================================='
Write-Host ' LITIGATION 360 SAFE CHANGE AUTOPILOT STATUS'
Write-Host '==============================================='
Write-Host ''

$Phase = 'C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot'

Write-Host 'Checking folders...'
Get-ChildItem $Phase -Directory | Select-Object Name

Write-Host ''
Write-Host 'Checking core documents...'
Get-ChildItem $Phase -Recurse -File | Select-Object FullName

Write-Host ''
Write-Host 'Status: SAFE CHANGE AUTOPILOT CONTROL CENTRE CREATED'
Write-Host 'Location:'
Write-Host $Phase
Write-Host ''

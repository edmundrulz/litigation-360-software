$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA3-enterprise-automation-assurance"
$Reports = "$Phase\reports"
$Registry = "$Phase\MASTER-PHASE-REGISTRY.md"

$Folders = Get-ChildItem $Ops -Directory | Sort-Object Name

@"
# MASTER PHASE REGISTRY

Generated:
$(Get-Date)

| Phase | Purpose | Status | Owner | Last Verified | Production Ready | Risk Level | Notes |
|---|---|---|---|---|---|---|---|
$(
$Folders | ForEach-Object {
  $name = $_.Name
  $status = if ($name -like "phase-10ZZA*" -or $name -like "phase-10ZZ*" -or $name -like "phase-10Z*") { "Operational" } else { "Reference" }
  "| $name | To be classified | $status | Owner | $(Get-Date -Format yyyy-MM-dd) | Pending Review | Medium | Auto-registered |"
} | Out-String
)
"@ | Set-Content $Registry

Write-Host ""
Write-Host "MASTER PHASE REGISTRY UPDATED"
Write-Host $Registry
Write-Host ""

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA3-enterprise-automation-assurance"

$Required = @(
  "$Phase\README.md",
  "$Phase\MASTER-PHASE-REGISTRY.md",
  "$Phase\01-daily-health-audit\DAILY-HEALTH-AUDIT-PROTOCOL.md",
  "$Phase\02-weekly-governance-audit\WEEKLY-GOVERNANCE-AUDIT-PROTOCOL.md",
  "$Phase\03-monthly-readiness-audit\MONTHLY-READINESS-AUDIT-PROTOCOL.md",
  "$Phase\08-alerting-engine\ALERTING-ENGINE.md",
  "$Phase\09-scheduled-tasks\WINDOWS-TASK-SCHEDULER-JOBS.md",
  "$Phase\scripts\RUN-DAILY-HEALTH-AUDIT.ps1",
  "$Phase\scripts\RUN-WEEKLY-GOVERNANCE-AUDIT.ps1",
  "$Phase\scripts\RUN-MONTHLY-ENTERPRISE-READINESS.ps1",
  "$Phase\scripts\UPDATE-MASTER-PHASE-REGISTRY.ps1"
)

$Missing = @()
foreach ($Item in $Required) {
  if (-not (Test-Path $Item)) {
    $Missing += $Item
  }
}

$Report = "$Phase\reports\PHASE-10ZZA3-VERIFICATION-$(Get-Date -Format yyyy-MM-dd-HHmmss).md"

@"
# PHASE 10ZZA3 VERIFICATION REPORT

Date:
$(Get-Date)

Status:
$(if ($Missing.Count -eq 0) { "PASSED" } else { "FAILED" })

Missing Items:
$(
if ($Missing.Count -eq 0) {
  "None"
} else {
  $Missing | ForEach-Object { "- $_" } | Out-String
}
)

Conclusion:
$(if ($Missing.Count -eq 0) { "Phase 10ZZA3 Enterprise Automation Assurance is operational." } else { "Repair missing items before proceeding." })
"@ | Set-Content $Report

Write-Host ""
Write-Host "PHASE 10ZZA3 VERIFICATION COMPLETE"
Write-Host "Report: $Report"
Write-Host "$(if ($Missing.Count -eq 0) { 'Status: PASSED' } else { 'Status: FAILED' })"
Write-Host ""

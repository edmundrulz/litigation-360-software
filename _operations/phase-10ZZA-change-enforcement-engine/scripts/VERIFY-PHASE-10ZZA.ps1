$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA-change-enforcement-engine"

$Required = @(
  "$Phase\README.md",
  "$Phase\01-master-control-dashboard\MASTER-CONTROL-DASHBOARD.md",
  "$Phase\02-change-gate-validator\CHANGE-GATE-VALIDATOR-RULES.md",
  "$Phase\03-deployment-readiness\DEPLOYMENT-READINESS-REPORT.md",
  "$Phase\04-override-registry\LAWYER-OVERRIDE-REGISTRY.md",
  "$Phase\05-live-system-checks\LIVE-SYSTEM-CHECKS.md",
  "$Phase\06-autopilot-lawyer-controls\AUTOPILOT-LAWYER-CONTROLS.md",
  "$Phase\07-risk-command-centre\RISK-COMMAND-CENTRE.md",
  "$Phase\08-daily-status-reports\DAILY-SYSTEM-STATUS-REPORT.md",
  "$Phase\scripts\RECORD-LAWYER-OVERRIDE.ps1",
  "$Phase\scripts\CREATE-SYSTEM-STATUS-REPORT.ps1",
  "$Phase\scripts\VALIDATE-CHANGE-GATE.ps1"
)

$Missing = @()

foreach ($Item in $Required) {
  if (-not (Test-Path $Item)) {
    $Missing += $Item
  }
}

$Report = "$Phase\09-verification\PHASE-10ZZA-VERIFICATION.md"

@"
# PHASE 10ZZA VERIFICATION REPORT

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
$(if ($Missing.Count -eq 0) { "Phase 10ZZA is operational." } else { "Phase 10ZZA is incomplete. Repair missing items." })
"@ | Set-Content $Report

Write-Host ""
Write-Host "PHASE 10ZZA VERIFICATION COMPLETE"
Write-Host "Report:"
Write-Host $Report
Write-Host ""

if ($Missing.Count -eq 0) {
  Write-Host "Status: PASSED"
} else {
  Write-Host "Status: FAILED"
}

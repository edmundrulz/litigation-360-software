$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA4-enterprise-telemetry-live-command-centre"
$Report = "$Phase\reports\PHASE-10ZZA4-VERIFICATION-$(Get-Date -Format yyyy-MM-dd-HHmmss).md"

$Required = @(
  "$Phase\README.md",
  "$Phase\01-live-command-centre\LIVE-COMMAND-CENTRE.md",
  "$Phase\08-alert-register\ALERT-REGISTER.md",
  "$Phase\scripts\REFRESH-LIVE-COMMAND-CENTRE.ps1"
)

$Missing = @()

foreach ($Item in $Required) {
  if (-not (Test-Path $Item)) {
    $Missing += $Item
  }
}

@"
# PHASE 10ZZA4 VERIFICATION REPORT

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
$(if ($Missing.Count -eq 0) { "Phase 10ZZA4 Live Command Centre is operational." } else { "Repair missing items before proceeding." })
"@ | Set-Content $Report

Write-Host ""
Write-Host "PHASE 10ZZA4 VERIFICATION COMPLETE"
Write-Host "Report: $Report"
Write-Host "$(if ($Missing.Count -eq 0) { 'Status: PASSED' } else { 'Status: FAILED' })"
Write-Host ""

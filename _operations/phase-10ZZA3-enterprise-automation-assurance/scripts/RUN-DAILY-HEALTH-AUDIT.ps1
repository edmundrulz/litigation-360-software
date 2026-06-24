$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA3-enterprise-automation-assurance"
$Reports = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $Reports | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$Report = "$Reports\DAILY-HEALTH-$Stamp.md"

$Checks = @(
  @{ Name="Root Folder"; Path=$Root },
  @{ Name="Operations Folder"; Path=$Ops },
  @{ Name="Backup Recovery Phase"; Path="$Ops\phase-10P-backup-recovery-disaster-readiness" },
  @{ Name="Monitoring Phase"; Path="$Ops\phase-10Q-enterprise-monitoring" },
  @{ Name="Safe Change Autopilot"; Path="$Ops\phase-10ZZ9-safe-change-autopilot" },
  @{ Name="Change Enforcement Engine"; Path="$Ops\phase-10ZZA-change-enforcement-engine" },
  @{ Name="Verification Sweep"; Path="$Ops\phase-10ZZA1-enterprise-verification-sweep" },
  @{ Name="Operational Assurance"; Path="$Ops\phase-10ZZA2-enterprise-operational-assurance" },
  @{ Name="Automation Assurance"; Path=$Phase }
)

$Rows = foreach ($Check in $Checks) {
  $Exists = Test-Path $Check.Path
  "| $($Check.Name) | $($Check.Path) | $(if ($Exists) { 'PASS' } else { 'FAIL' }) |"
}

$FailCount = ($Checks | Where-Object { -not (Test-Path $_.Path) }).Count
$Status = if ($FailCount -eq 0) { "GREEN" } elseif ($FailCount -le 2) { "YELLOW" } else { "RED" }

@"
# DAILY HEALTH AUDIT REPORT

Date:
$(Get-Date)

Overall Status:
$Status

Failed Checks:
$FailCount

| Check | Path | Status |
|---|---|---|
$($Rows -join "`n")

Decision:
$(if ($Status -eq "GREEN") { "System control folders are healthy." } elseif ($Status -eq "YELLOW") { "Review failed checks before further rollout." } else { "Stop and repair missing control folders." })
"@ | Set-Content $Report

Write-Host ""
Write-Host "DAILY HEALTH AUDIT COMPLETE"
Write-Host "Status: $Status"
Write-Host "Report: $Report"
Write-Host ""

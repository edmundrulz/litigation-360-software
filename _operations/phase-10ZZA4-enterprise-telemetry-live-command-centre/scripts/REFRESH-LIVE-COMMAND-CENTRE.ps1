$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA4-enterprise-telemetry-live-command-centre"
$Dashboard = "$Phase\01-live-command-centre\LIVE-COMMAND-CENTRE.md"
$Reports = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $Reports | Out-Null

$Now = Get-Date
$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"

$ZZA3Reports = "$Ops\phase-10ZZA3-enterprise-automation-assurance\reports"
$ZZA2Reports = "$Ops\phase-10ZZA2-enterprise-operational-assurance\reports"
$ZZA1Reports = "$Ops\phase-10ZZA1-enterprise-verification-sweep\reports"
$ZZAReports = "$Ops\phase-10ZZA-change-enforcement-engine\reports"

$LatestDaily = Get-ChildItem $ZZA3Reports -Filter "DAILY-HEALTH-*.md" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$LatestMonthly = Get-ChildItem $ZZA3Reports -Filter "MONTHLY-ENTERPRISE-READINESS-*.md" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$LatestWeekly = Get-ChildItem $ZZA3Reports -Filter "WEEKLY-GOVERNANCE-AUDIT-*.md" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$LatestAssurance = Get-ChildItem $ZZA2Reports -Filter "EXECUTIVE-OPERATIONS-DASHBOARD-LATEST.md" -ErrorAction SilentlyContinue | Select-Object -First 1
$LatestSweep = Get-ChildItem $ZZA1Reports -Filter "ENTERPRISE-VERIFICATION-SWEEP-*.md" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

$FolderCount = (Get-ChildItem $Ops -Directory | Measure-Object).Count
$FileCount = (Get-ChildItem $Ops -Recurse -File | Measure-Object).Count
$ScriptCount = (Get-ChildItem $Ops -Recurse -Filter *.ps1 | Measure-Object).Count
$MarkdownCount = (Get-ChildItem $Ops -Recurse -Filter *.md | Measure-Object).Count
$JsonCount = (Get-ChildItem $Ops -Recurse -Filter *.json | Measure-Object).Count

$CriticalPaths = @(
  "$Ops\phase-10ZZ9-safe-change-autopilot",
  "$Ops\phase-10ZZA-change-enforcement-engine",
  "$Ops\phase-10ZZA1-enterprise-verification-sweep",
  "$Ops\phase-10ZZA2-enterprise-operational-assurance",
  "$Ops\phase-10ZZA3-enterprise-automation-assurance",
  "$Phase"
)

$MissingCritical = $CriticalPaths | Where-Object { -not (Test-Path $_) }

$HealthStatus = if ($MissingCritical.Count -eq 0 -and $LatestDaily) { "GREEN" } elseif ($MissingCritical.Count -le 1) { "YELLOW" } else { "RED" }
$GovernanceStatus = if ($LatestWeekly) { "GREEN" } else { "YELLOW" }
$ReadinessStatus = if ($LatestMonthly -or $LatestAssurance) { "GREEN" } else { "YELLOW" }
$TelemetryStatus = if ($LatestDaily -and $LatestMonthly) { "GREEN" } else { "YELLOW" }

$AlertLines = @()

if ($MissingCritical.Count -gt 0) {
  foreach ($Missing in $MissingCritical) {
    $AlertLines += "| ALT-$Stamp | $Now | CRITICAL | Critical Path | Missing path: $Missing | Restore folder/script | Open |"
  }
}

if (-not $LatestDaily) {
  $AlertLines += "| ALT-$Stamp-DH | $Now | WARNING | Daily Health | No daily health report found | Run daily health audit | Open |"
}

if (-not $LatestMonthly) {
  $AlertLines += "| ALT-$Stamp-MR | $Now | WARNING | Monthly Readiness | No monthly readiness report found | Run monthly readiness audit | Open |"
}

if ($AlertLines.Count -gt 0) {
  Add-Content "$Phase\08-alert-register\ALERT-REGISTER.md" ($AlertLines -join "`n")
}

@"
# LITIGATION 360 LIVE COMMAND CENTRE

Last Refreshed:
$Now

## Overall Telemetry Status

| Area | Status |
|---|---|
| Health Telemetry | $HealthStatus |
| Governance Telemetry | $GovernanceStatus |
| Readiness Telemetry | $ReadinessStatus |
| Automation Telemetry | $TelemetryStatus |

## Live Inventory

| Metric | Count |
|---|---:|
| Operation Folders | $FolderCount |
| Total Files | $FileCount |
| PowerShell Scripts | $ScriptCount |
| Markdown Documents | $MarkdownCount |
| JSON Files | $JsonCount |

## Latest Reports Detected

| Report Type | Latest File |
|---|---|
| Daily Health | $(if ($LatestDaily) { $LatestDaily.FullName } else { "Not Found" }) |
| Weekly Governance | $(if ($LatestWeekly) { $LatestWeekly.FullName } else { "Not Found" }) |
| Monthly Readiness | $(if ($LatestMonthly) { $LatestMonthly.FullName } else { "Not Found" }) |
| Operational Assurance | $(if ($LatestAssurance) { $LatestAssurance.FullName } else { "Not Found" }) |
| Verification Sweep | $(if ($LatestSweep) { $LatestSweep.FullName } else { "Not Found" }) |

## Critical Path Check

$(
if ($MissingCritical.Count -eq 0) {
  "All critical operational assurance folders are present."
} else {
  $MissingCritical | ForEach-Object { "- Missing: $_" } | Out-String
}
)

## Active Alert Summary

New Alerts Generated This Refresh:
$($AlertLines.Count)

Alert Register:
$Phase\08-alert-register\ALERT-REGISTER.md

## Decision

$(if ($HealthStatus -eq "GREEN" -and $ReadinessStatus -eq "GREEN") { "Proceed. Command centre telemetry is operational." } elseif ($HealthStatus -eq "YELLOW") { "Proceed carefully. Run missing audit scripts." } else { "Stop expansion and repair critical missing paths." })

## Next Recommended Action

After this dashboard is stable:
Create Phase 10ZZA5 — Enterprise Scheduled Automation Installer.
"@ | Set-Content $Dashboard

Copy-Item $Dashboard "$Reports\LIVE-COMMAND-CENTRE-$Stamp.md" -Force

Write-Host ""
Write-Host "LIVE COMMAND CENTRE REFRESH COMPLETE"
Write-Host "Dashboard:"
Write-Host $Dashboard
Write-Host ""
Write-Host "Archived Report:"
Write-Host "$Reports\LIVE-COMMAND-CENTRE-$Stamp.md"
Write-Host ""

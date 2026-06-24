param(
  [string]$ChangePackPath
)

if (-not $ChangePackPath) {
  Write-Host ""
  Write-Host "Usage:"
  Write-Host "powershell -ExecutionPolicy Bypass -File VALIDATE-CHANGE-GATE.ps1 -ChangePackPath `"FULL_CHANGE_PACK_PATH`""
  Write-Host ""
  exit
}

$RequiredFiles = @(
  "01-CHANGE-REQUEST.md",
  "02-IMPACT-ASSESSMENT.md",
  "03-RISK-CONTROL.md",
  "04-TESTING-GATES.md",
  "05-SECURITY-REVIEW.md",
  "06-APPROVAL-WORKFLOW.md",
  "07-DEPLOYMENT-CONTROL.md",
  "08-ROLLBACK-PLAN.md",
  "09-LIVE-MONITORING.md"
)

$Phase = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZA-change-enforcement-engine"
$ReportFolder = "$Phase\reports"
New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$Report = "$ReportFolder\CHANGE-GATE-VALIDATION-$Stamp.md"

$Missing = @()

foreach ($File in $RequiredFiles) {
  $Path = Join-Path $ChangePackPath $File
  if (-not (Test-Path $Path)) {
    $Missing += $File
  }
}

$Status = if ($Missing.Count -eq 0) { "PASSED" } else { "BLOCKED" }

@"
# CHANGE GATE VALIDATION REPORT

Date:
$(Get-Date)

Change Pack:
$ChangePackPath

Status:
$Status

## Missing Files

$(
if ($Missing.Count -eq 0) {
  "None"
} else {
  $Missing | ForEach-Object { "- $_" } | Out-String
}
)

## Decision

PASSED:
Change may proceed to review.

BLOCKED:
Do not deploy. Complete missing files first.
"@ | Set-Content $Report

Write-Host ""
Write-Host "CHANGE GATE VALIDATION COMPLETE"
Write-Host "Status: $Status"
Write-Host "Report: $Report"
Write-Host ""

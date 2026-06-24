$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA3-enterprise-automation-assurance"
$Reports = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $Reports | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$Report = "$Reports\MONTHLY-ENTERPRISE-READINESS-$Stamp.md"

$MD = (Get-ChildItem $Ops -Recurse -Filter *.md | Measure-Object).Count
$PS1 = (Get-ChildItem $Ops -Recurse -Filter *.ps1 | Measure-Object).Count

$HasBackup = Test-Path "$Ops\phase-10P-backup-recovery-disaster-readiness"
$HasMonitoring = Test-Path "$Ops\phase-10Q-enterprise-monitoring"
$HasGovernance = Test-Path "$Ops\phase-10ZZ1-sop-governance-audit"
$HasTraining = Test-Path "$Ops\phase-10ZZ7-training-succession-ip"
$HasKnowledge = Test-Path "$Ops\phase-10ZZ8-enterprise-knowledge-management"
$HasChange = Test-Path "$Ops\phase-10ZZ9-safe-change-autopilot"
$HasEnforcement = Test-Path "$Ops\phase-10ZZA-change-enforcement-engine"
$HasVerification = Test-Path "$Ops\phase-10ZZA1-enterprise-verification-sweep"
$HasAssurance = Test-Path "$Ops\phase-10ZZA2-enterprise-operational-assurance"

$Health = 70 + ($(if ($HasMonitoring) {10} else {0})) + ($(if ($HasBackup) {10} else {0})) + ($(if ($HasVerification) {10} else {0}))
$Governance = 60 + ($(if ($HasGovernance) {15} else {0})) + ($(if ($HasChange) {10} else {0})) + ($(if ($HasEnforcement) {10} else {0})) + ($(if ($MD -gt 200) {5} else {0}))
$Security = 70 + ($(if ($HasBackup) {10} else {0})) + ($(if ($HasGovernance) {10} else {0})) + ($(if ($HasEnforcement) {10} else {0}))
$Deployment = 60 + ($(if ($HasChange) {10} else {0})) + ($(if ($HasEnforcement) {10} else {0})) + ($(if ($PS1 -ge 10) {10} else {5})) + ($(if ($HasBackup) {10} else {0}))
$Training = 60 + ($(if ($HasTraining) {20} else {0})) + ($(if ($HasKnowledge) {20} else {0}))
$Performance = 70 + ($(if (Test-Path "$Ops\phase-10R-performance-optimization") {20} else {0})) + ($(if ($HasMonitoring) {10} else {0}))
$Automation = 50 + ($(if ($PS1 -ge 10) {25} else {10})) + ($(if ($HasVerification) {10} else {0})) + ($(if ($HasAssurance) {10} else {0})) + 5

$Scores = @($Health,$Governance,$Security,$Deployment,$Training,$Performance,$Automation)
$Overall = [math]::Round(($Scores | Measure-Object -Average).Average,2)

@"
# MONTHLY ENTERPRISE READINESS REPORT

Date:
$(Get-Date)

## Scorecard

| Area | Score |
|---|---:|
| Health | $Health% |
| Governance | $Governance% |
| Security | $Security% |
| Deployment | $Deployment% |
| Training | $Training% |
| Performance | $Performance% |
| Automation | $Automation% |

## Overall Enterprise Readiness

$Overall%

## Decision

$(if ($Overall -ge 90) { "Enterprise foundation is strong. Proceed to telemetry and live command centre." } elseif ($Overall -ge 75) { "Operational foundation is good. Strengthen automation and monitoring." } else { "Pause feature expansion. Repair weak assurance controls first." })

## Next Actions

1. Increase executable scripts.
2. Convert repeated manual checks into scheduled jobs.
3. Build live dashboard indicators.
4. Reduce stale folders and unused files.
5. Strengthen backup and monitoring proof.
"@ | Set-Content $Report

Write-Host ""
Write-Host "MONTHLY ENTERPRISE READINESS COMPLETE"
Write-Host "Overall Readiness: $Overall%"
Write-Host "Report: $Report"
Write-Host ""

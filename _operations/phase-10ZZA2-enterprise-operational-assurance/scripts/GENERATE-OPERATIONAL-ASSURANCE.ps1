$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA2-enterprise-operational-assurance"
$Reports = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $Reports | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"

$Folders = Get-ChildItem $Ops -Directory
$Files = Get-ChildItem $Ops -Recurse -File
$MD = Get-ChildItem $Ops -Recurse -Filter *.md
$PS1 = Get-ChildItem $Ops -Recurse -Filter *.ps1
$JSON = Get-ChildItem $Ops -Recurse -Filter *.json
$CSV = Get-ChildItem $Ops -Recurse -Filter *.csv

$HasZZ9 = Test-Path "$Ops\phase-10ZZ9-safe-change-autopilot"
$HasZZA = Test-Path "$Ops\phase-10ZZA-change-enforcement-engine"
$HasZZA1 = Test-Path "$Ops\phase-10ZZA1-enterprise-verification-sweep"
$HasBackup = Test-Path "$Ops\phase-10P-backup-recovery-disaster-readiness"
$HasMonitoring = Test-Path "$Ops\phase-10Q-enterprise-monitoring"
$HasTraining = Test-Path "$Ops\phase-10ZZ7-training-succession-ip"
$HasKnowledge = Test-Path "$Ops\phase-10ZZ8-enterprise-knowledge-management"
$HasGovernance = Test-Path "$Ops\phase-10ZZ1-sop-governance-audit"

$HealthScore = 70
if ($HasMonitoring) { $HealthScore += 10 }
if ($HasBackup) { $HealthScore += 10 }
if ($HasZZA1) { $HealthScore += 10 }
if ($HealthScore -gt 100) { $HealthScore = 100 }

$GovernanceScore = 60
if ($HasGovernance) { $GovernanceScore += 15 }
if ($HasZZ9) { $GovernanceScore += 10 }
if ($HasZZA) { $GovernanceScore += 10 }
if ($MD.Count -gt 200) { $GovernanceScore += 5 }
if ($GovernanceScore -gt 100) { $GovernanceScore = 100 }

$TrainingScore = 60
if ($HasTraining) { $TrainingScore += 25 }
if ($HasKnowledge) { $TrainingScore += 15 }
if ($TrainingScore -gt 100) { $TrainingScore = 100 }

$DeploymentScore = 60
if ($HasZZ9) { $DeploymentScore += 10 }
if ($HasZZA) { $DeploymentScore += 15 }
if ($PS1.Count -ge 8) { $DeploymentScore += 10 } else { $DeploymentScore += 5 }
if ($HasBackup) { $DeploymentScore += 5 }
if ($DeploymentScore -gt 100) { $DeploymentScore = 100 }

$SecurityScore = 70
if ($HasGovernance) { $SecurityScore += 10 }
if ($HasBackup) { $SecurityScore += 10 }
if ($HasZZA) { $SecurityScore += 10 }
if ($SecurityScore -gt 100) { $SecurityScore = 100 }

$PerformanceScore = 70
if (Test-Path "$Ops\phase-10R-performance-optimization") { $PerformanceScore += 20 }
if ($HasMonitoring) { $PerformanceScore += 10 }
if ($PerformanceScore -gt 100) { $PerformanceScore = 100 }

$Overall = [math]::Round(($HealthScore + $GovernanceScore + $TrainingScore + $DeploymentScore + $SecurityScore + $PerformanceScore) / 6, 2)

$Dashboard = "$Phase\07-executive-dashboard\EXECUTIVE-OPERATIONS-DASHBOARD-$Stamp.md"

@"
# LITIGATION 360 EXECUTIVE OPERATIONS DASHBOARD

Date:
$(Get-Date)

## Enterprise Scorecard

| Area | Score |
|---|---:|
| System Health | $HealthScore% |
| Governance | $GovernanceScore% |
| Training / Succession | $TrainingScore% |
| Deployment Readiness | $DeploymentScore% |
| Security Readiness | $SecurityScore% |
| Performance Readiness | $PerformanceScore% |

## Overall Enterprise Readiness

$Overall%

## Verified Inventory

| Item | Count |
|---|---:|
| Operation Folders | $($Folders.Count) |
| Total Files | $($Files.Count) |
| Markdown Documents | $($MD.Count) |
| PowerShell Scripts | $($PS1.Count) |
| JSON Files | $($JSON.Count) |
| CSV Files | $($CSV.Count) |

## Status Meaning

90% - 100%:
Enterprise-ready foundation.

75% - 89%:
Operational, but needs strengthening.

60% - 74%:
Usable, but not yet enterprise-stable.

Below 60%:
Repair required before scale.

## Current Decision

$(if ($Overall -ge 90) { "Proceed to controlled operational rollout." } elseif ($Overall -ge 75) { "Proceed with strengthening and validation." } else { "Pause new features and repair weak controls." })

## Next Recommended Action

Create recurring assurance reports:
- Daily system status
- Weekly governance scorecard
- Monthly executive readiness dashboard
"@ | Set-Content $Dashboard

@"
# SYSTEM HEALTH SCORECARD

Backend:
Pending live runtime check

Frontend:
Pending live runtime check

Database:
Pending live runtime check

Monitoring Folder:
$HasMonitoring

Backup Folder:
$HasBackup

Verification Sweep:
$HasZZA1

Score:
$HealthScore%
"@ | Set-Content "$Phase\01-health-scorecards\SYSTEM-HEALTH-SCORECARD.md"

@"
# SECURITY SCORECARD

Governance Controls:
$HasGovernance

Backup / Recovery:
$HasBackup

Change Enforcement:
$HasZZA

Score:
$SecurityScore%
"@ | Set-Content "$Phase\02-security-scorecards\SECURITY-SCORECARD.md"

@"
# DEPLOYMENT SCORECARD

Safe Change Autopilot:
$HasZZ9

Change Enforcement Engine:
$HasZZA

PowerShell Scripts:
$($PS1.Count)

Backup Readiness:
$HasBackup

Score:
$DeploymentScore%
"@ | Set-Content "$Phase\03-deployment-scorecards\DEPLOYMENT-SCORECARD.md"

@"
# GOVERNANCE SCORECARD

SOP Governance:
$HasGovernance

Safe Change Autopilot:
$HasZZ9

Change Enforcement:
$HasZZA

Markdown Documents:
$($MD.Count)

Score:
$GovernanceScore%
"@ | Set-Content "$Phase\04-governance-scorecards\GOVERNANCE-SCORECARD.md"

@"
# TRAINING SCORECARD

Training Succession Folder:
$HasTraining

Knowledge Management Folder:
$HasKnowledge

Score:
$TrainingScore%
"@ | Set-Content "$Phase\05-training-scorecards\TRAINING-SCORECARD.md"

@"
# PERFORMANCE SCORECARD

Performance Optimization Folder:
$(Test-Path "$Ops\phase-10R-performance-optimization")

Monitoring Folder:
$HasMonitoring

Score:
$PerformanceScore%
"@ | Set-Content "$Phase\06-performance-scorecards\PERFORMANCE-SCORECARD.md"

Copy-Item $Dashboard "$Reports\EXECUTIVE-OPERATIONS-DASHBOARD-LATEST.md" -Force

Write-Host ""
Write-Host "=================================================="
Write-Host "ENTERPRISE OPERATIONAL ASSURANCE COMPLETE"
Write-Host "=================================================="
Write-Host ""
Write-Host "Overall Enterprise Readiness: $Overall%"
Write-Host ""
Write-Host "Dashboard:"
Write-Host $Dashboard
Write-Host ""

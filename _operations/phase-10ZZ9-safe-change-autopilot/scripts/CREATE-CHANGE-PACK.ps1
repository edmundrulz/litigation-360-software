# AUTO CREATE CHANGE PACK

param(
  [string]$ChangeName = "new-change"
)

$Base = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\reports"
$Date = Get-Date -Format "yyyy-MM-dd-HHmm"
$SafeName = $ChangeName -replace '[^a-zA-Z0-9\-]', '-'
$Pack = "$Base\CHANGE-$Date-$SafeName"

New-Item -ItemType Directory -Force -Path $Pack | Out-Null

Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\01-change-intake\CHANGE-REQUEST-TEMPLATE.md" "$Pack\01-CHANGE-REQUEST.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\02-impact-assessment\IMPACT-ASSESSMENT-CHECKLIST.md" "$Pack\02-IMPACT-ASSESSMENT.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\03-risk-control\RISK-CONTROL-MATRIX.md" "$Pack\03-RISK-CONTROL.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\05-testing-gates\TESTING-GATES.md" "$Pack\04-TESTING-GATES.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\06-security-review\SECURITY-REVIEW-CHECKLIST.md" "$Pack\05-SECURITY-REVIEW.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\07-approval-workflow\APPROVAL-WORKFLOW.md" "$Pack\06-APPROVAL-WORKFLOW.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\08-deployment-control\DEPLOYMENT-CONTROL-PLAN.md" "$Pack\07-DEPLOYMENT-CONTROL.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\09-rollback-control\ROLLBACK-PLAN-TEMPLATE.md" "$Pack\08-ROLLBACK-PLAN.md"
Copy-Item "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ9-safe-change-autopilot\10-live-monitoring\LIVE-MONITORING-CHECKLIST.md" "$Pack\09-LIVE-MONITORING.md"

Write-Host ''
Write-Host 'Change pack created:'
Write-Host $Pack
Write-Host ''

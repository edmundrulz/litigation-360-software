cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZD COMMERCIALISATION VALIDATION"
Write-Host "===================================================="

$Required = @(
  "phase-10ZZD-commercialisation-framework\product-packaging\PRODUCT-EDITIONS.md",
  "phase-10ZZD-commercialisation-framework\licensing\LICENSING-FRAMEWORK.md",
  "phase-10ZZD-commercialisation-framework\pricing\PRICING-MODEL.md",
  "phase-10ZZD-commercialisation-framework\onboarding\CLIENT-ONBOARDING-PROCESS.md",
  "phase-10ZZD-commercialisation-framework\deployment\CLIENT-DEPLOYMENT-PLAYBOOK.md",
  "phase-10ZZD-commercialisation-framework\support\SUPPORT-SERVICE-MODEL.md",
  "phase-10ZZD-commercialisation-framework\customer-success\CUSTOMER-SUCCESS-FRAMEWORK.md",
  "phase-10ZZD-commercialisation-framework\renewals\RENEWAL-PROCESS.md",
  "phase-10ZZD-commercialisation-framework\commercial-risk\COMMERCIAL-RISK-REGISTER.md",
  "phase-10ZZD-commercialisation-framework\commercial-governance\COMMERCIAL-GOVERNANCE-CHARTER.md",
  "phase-10ZZD-commercialisation-framework\product-roadmap\PRODUCT-ROADMAP.md",
  "phase-10ZZD-commercialisation-framework\partner-program\PARTNER-CHANNEL-FRAMEWORK.md",
  "phase-10ZZD-commercialisation-framework\market-expansion\MARKET-EXPANSION-PLAN.md",
  "phase-10ZZD-commercialisation-framework\COMMERCIALISATION-READINESS-CHECKLIST.md",
  "monitoring\commercialisation\commercialisation-metrics.json",
  "monitoring\commercialisation\COMMERCIALISATION-MONITORING-DASHBOARD.md",
  "reports\commercialisation\PHASE-10ZZD-COMMERCIALISATION-AUDIT-REPORT.md"
)

$Pass = 0
$Fail = 0

foreach ($Item in $Required) {
  if (Test-Path $Item) {
    Write-Host "? FOUND: $Item"
    $Pass++
  } else {
    Write-Host "? MISSING: $Item"
    $Fail++
  }
}

Write-Host ""
Write-Host "Passed: $Pass"
Write-Host "Failed: $Fail"

if ($Fail -eq 0) {
  Write-Host "??? PHASE 10ZZD COMMERCIALISATION VALIDATED"
} else {
  Write-Host "? PHASE 10ZZD COMMERCIALISATION INCOMPLETE"
}

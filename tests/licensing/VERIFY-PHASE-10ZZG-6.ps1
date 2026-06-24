cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.6 FILE VERIFICATION"
Write-Host "===================================================="

$Required = @(
  "backend\admin\commercial-monitoring-admin.js",
  "backend\routes\admin-control-routes.js",
  "monitoring\commercialisation\commercial-dashboard-live.json",
  "docs\governance\licensing\COMMERCIAL-MONITORING-DASHBOARD-API-SOP.md",
  "tests\licensing\RUN-PHASE-10ZZG-6-LIVE-TESTS.ps1",
  "reports\licensing\PHASE-10ZZG-6-COMMERCIAL-MONITORING-REPORT.md"
)

$Pass = 0
$Fail = 0

foreach ($File in $Required) {
  if (Test-Path $File) {
    Write-Host "? FOUND: $File"
    $Pass++
  } else {
    Write-Host "? MISSING: $File"
    $Fail++
  }
}

Write-Host ""
Write-Host "Passed: $Pass"
Write-Host "Failed: $Fail"

if ($Fail -eq 0) {
  Write-Host "??? PHASE 10ZZG.6 FILE VERIFICATION PASSED"
} else {
  Write-Host "? PHASE 10ZZG.6 FILE VERIFICATION FAILED"
}

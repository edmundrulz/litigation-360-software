cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.1 ADMIN API FRAMEWORK VERIFICATION"
Write-Host "===================================================="

$RequiredFiles = @(
  "backend\routes\admin-control-routes.js",
  "backend\middleware\requireAdmin.js",
  "backend\middleware\requireSuperAdmin.js",
  "backend\middleware\adminAudit.js",
  "backend\middleware\mockAdminContext.js",
  "tests\licensing\phase-10zzg-admin-api-test-server.js",
  "docs\governance\licensing\ADMIN-CONTROL-API-SOP.md",
  "monitoring\commercialisation\admin-api-dashboard.json"
)

$Pass = 0
$Fail = 0

foreach ($File in $RequiredFiles) {
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
  Write-Host "??? PHASE 10ZZG.1 FILE VERIFICATION PASSED"
} else {
  Write-Host "? PHASE 10ZZG.1 FILE VERIFICATION FAILED"
}

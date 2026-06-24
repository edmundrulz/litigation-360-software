cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.3 FILE VERIFICATION"
Write-Host "===================================================="

$Required = @(
  "backend\middleware\adminValidation.js",
  "backend\routes\admin-control-routes.js",
  "docs\governance\licensing\SUBSCRIPTION-API-ENDPOINT-HARDENING-SOP.md"
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
  Write-Host "??? PHASE 10ZZG.3 FILE VERIFICATION PASSED"
} else {
  Write-Host "? PHASE 10ZZG.3 FILE VERIFICATION FAILED"
}

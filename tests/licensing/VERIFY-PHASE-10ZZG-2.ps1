cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.2 VERIFICATION"
Write-Host "===================================================="

$Required = @(
  "backend\admin\approval-matrix.json",
  "backend\admin\safety-locks.json",
  "backend\middleware\requireApproval.js",
  "backend\middleware\safetyLock.js",
  "docs\governance\licensing\ADMIN-APPROVAL-MATRIX-SAFETY-LOCKS-SOP.md"
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
  Write-Host "??? PHASE 10ZZG.2 VALIDATED"
} else {
  Write-Host "? PHASE 10ZZG.2 INCOMPLETE"
}

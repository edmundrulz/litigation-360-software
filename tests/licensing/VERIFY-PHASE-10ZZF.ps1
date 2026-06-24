cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZF VERIFICATION"
Write-Host "===================================================="

$RequiredFiles = @(
  "backend\admin\subscription-admin.js",
  "backend\admin\firm-subscriptions.json",
  "backend\admin\feature-overrides.json",
  "backend\admin\trial-controls.json",
  "docs\governance\licensing\ADMIN-SUBSCRIPTION-CONTROL-SOP.md"
)

foreach ($File in $RequiredFiles) {
  if (Test-Path $File) {
    Write-Host "? FOUND: $File"
  } else {
    Write-Host "? MISSING: $File"
  }
}

Write-Host ""
Write-Host "??? Phase 10ZZF file verification complete"

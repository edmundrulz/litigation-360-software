Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10ZZE VERIFICATION CHECK"
Write-Host "===================================================="

$Root = Get-Location

$RequiredFiles = @(
  "$Root\backend\middleware\requireFeature.js",
  "$Root\backend\routes\protected-feature-routes.js",
  "$Root\backend\middleware\mockFirmContext.js",
  "$Root\tests\licensing\phase-10zze-test-server.js",
  "$Root\docs\governance\licensing\BACKEND-ROUTE-PROTECTION-SOP.md"
)

foreach ($File in $RequiredFiles) {
  if (Test-Path $File) {
    Write-Host "? FOUND: $File"
  } else {
    Write-Host "? MISSING: $File"
  }
}

Write-Host ""
Write-Host "Expected access rules:"
Write-Host "Ground Zero = ALL FEATURES ALLOWED"
Write-Host "Starter = only Starter features allowed"
Write-Host "Trial = temporary full access allowed"
Write-Host "Unauthorized = 403 FEATURE_LOCKED"
Write-Host ""
Write-Host "??? Verification complete"

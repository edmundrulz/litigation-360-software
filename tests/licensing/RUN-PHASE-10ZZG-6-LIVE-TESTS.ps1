cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.6 COMMERCIAL MONITORING LIVE TESTS"
Write-Host "Server must already be running on port 5061:"
Write-Host "node tests\licensing\phase-10zzg-admin-api-test-server.js"
Write-Host "===================================================="

function Show-Error {
  param($Err)
  if ($Err.ErrorDetails.Message) {
    Write-Host $Err.ErrorDetails.Message
  } else {
    Write-Host $Err.Exception.Message
  }
}

Write-Host "`nTEST 1 — Health"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/health"

Write-Host "`nTEST 2 — Dashboard"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/dashboard"

Write-Host "`nTEST 3 — Clients"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/clients"

Write-Host "`nTEST 4 — Trials"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/trials"

Write-Host "`nTEST 5 — Feature Overrides"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/feature-overrides"

Write-Host "`nTEST 6 — Audit Summary"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/audit-summary"

Write-Host "`nTEST 7 — Commercial Health"
Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/owner/commercial-health"

Write-Host "`nTEST 8 — Normal User Should Be Blocked"
try {
  Invoke-RestMethod -Method GET -Uri "http://localhost:5062/test/admin/user/dashboard"
} catch {
  Show-Error $_
}

Write-Host "`n??? Phase 10ZZG.6 live test commands completed"

cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.5 TRIAL MANAGEMENT LIVE TESTS"
Write-Host "Server must already be running:"
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
Invoke-RestMethod -Method GET -Uri "http://localhost:5061/test/admin/owner/health"

Write-Host "`nTEST 2 — Start Trial Should Pass"
$Body = @{
  firmId = "FIRM_STARTER_SAMPLE"
  days = 30
} | ConvertTo-Json

Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/owner/trial/start" -ContentType "application/json" -Body $Body

Write-Host "`nTEST 3 — Trial Status Should Be Active"
Invoke-RestMethod -Method GET -Uri "http://localhost:5061/test/admin/owner/trial/status?firmId=FIRM_STARTER_SAMPLE"

Write-Host "`nTEST 4 — Trial List Should Show Firm"
Invoke-RestMethod -Method GET -Uri "http://localhost:5061/test/admin/owner/trial/list"

Write-Host "`nTEST 5 — Invalid Trial Days Should Fail"
try {
  $Body = @{
    firmId = "FIRM_STARTER_SAMPLE"
    days = 120
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/owner/trial/start" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 6 — Normal User Start Trial Should Be Blocked"
try {
  $Body = @{
    firmId = "FIRM_STARTER_SAMPLE"
    days = 30
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/user/trial/start" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 7 — Super Admin End Trial Should Be Blocked"
try {
  $Body = @{
    firmId = "FIRM_STARTER_SAMPLE"
    reason = "SUPER_ADMIN_ATTEMPT"
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/super/trial/end" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 8 — Owner End Trial Should Pass"
$Body = @{
  firmId = "FIRM_STARTER_SAMPLE"
  reason = "OWNER_TEST_END"
} | ConvertTo-Json

Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/owner/trial/end" -ContentType "application/json" -Body $Body

Write-Host "`nTEST 9 — Trial Status Should Be Ended"
Invoke-RestMethod -Method GET -Uri "http://localhost:5061/test/admin/owner/trial/status?firmId=FIRM_STARTER_SAMPLE"

Write-Host "`nTEST 10 — Ground Zero End Trial Should Be Blocked"
try {
  $Body = @{
    firmId = "FIRM_GROUND_ZERO"
    reason = "SHOULD_NOT_END"
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/owner/trial/end" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 11 — Refresh Expiries Should Pass"
Invoke-RestMethod -Method POST -Uri "http://localhost:5061/test/admin/owner/trial/refresh-expiries"

Write-Host "`n??? Phase 10ZZG.5 live test commands completed"

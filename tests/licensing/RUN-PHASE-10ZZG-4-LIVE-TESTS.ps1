cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.4 FEATURE OVERRIDE LIVE TESTS"
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
Invoke-RestMethod -Method GET -Uri "http://localhost:5060/test/admin/owner/health"

Write-Host "`nTEST 2 — Grant LEGAL_AI Override Should Pass"
$Body = @{
  firmId = "FIRM_STARTER_SAMPLE"
  userId = "USER_STARTER"
  featureKey = "LEGAL_AI"
} | ConvertTo-Json

Invoke-RestMethod -Method POST -Uri "http://localhost:5060/test/admin/owner/feature/grant" -ContentType "application/json" -Body $Body

Write-Host "`nTEST 3 — List Overrides Should Show LEGAL_AI"
Invoke-RestMethod -Method GET -Uri "http://localhost:5060/test/admin/owner/feature/list?firmId=FIRM_STARTER_SAMPLE&userId=USER_STARTER"

Write-Host "`nTEST 4 — Status Should Be Active"
Invoke-RestMethod -Method GET -Uri "http://localhost:5060/test/admin/owner/feature/status?firmId=FIRM_STARTER_SAMPLE&userId=USER_STARTER&featureKey=LEGAL_AI"

Write-Host "`nTEST 5 — Invalid Feature Key Should Fail"
try {
  $Body = @{
    firmId = "FIRM_STARTER_SAMPLE"
    userId = "USER_STARTER"
    featureKey = "FAKE_FEATURE_DOES_NOT_EXIST"
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5060/test/admin/owner/feature/grant" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 6 — Normal User Grant Should Be Blocked"
try {
  $Body = @{
    firmId = "FIRM_STARTER_SAMPLE"
    userId = "USER_STARTER"
    featureKey = "LEGAL_AI"
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5060/test/admin/user/feature/grant" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 7 — Super Admin Revoke Should Be Blocked"
try {
  $Body = @{
    firmId = "FIRM_STARTER_SAMPLE"
    userId = "USER_STARTER"
    featureKey = "LEGAL_AI"
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5060/test/admin/super/feature/revoke" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`nTEST 8 — Owner Revoke Should Pass"
$Body = @{
  firmId = "FIRM_STARTER_SAMPLE"
  userId = "USER_STARTER"
  featureKey = "LEGAL_AI"
} | ConvertTo-Json

Invoke-RestMethod -Method POST -Uri "http://localhost:5060/test/admin/owner/feature/revoke" -ContentType "application/json" -Body $Body

Write-Host "`nTEST 9 — Status Should Be Inactive"
Invoke-RestMethod -Method GET -Uri "http://localhost:5060/test/admin/owner/feature/status?firmId=FIRM_STARTER_SAMPLE&userId=USER_STARTER&featureKey=LEGAL_AI"

Write-Host "`nTEST 10 — Ground Zero Revoke Should Be Blocked"
try {
  $Body = @{
    firmId = "FIRM_GROUND_ZERO"
    userId = "USER_GROUND_ZERO_OWNER"
    featureKey = "LEGAL_AI"
  } | ConvertTo-Json

  Invoke-RestMethod -Method POST -Uri "http://localhost:5060/test/admin/owner/feature/revoke" -ContentType "application/json" -Body $Body
} catch {
  Show-Error $_
}

Write-Host "`n??? Phase 10ZZG.4 live test commands completed"

cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.1 LIVE API TESTS"
Write-Host "Server must already be running in another PowerShell:"
Write-Host "node tests\licensing\phase-10zzg-admin-api-test-server.js"
Write-Host "===================================================="

Write-Host "`nTEST 1 — Owner Health"
curl.exe http://localhost:5060/test/admin/owner/health

Write-Host "`nTEST 2 — Normal User Must Be Blocked"
curl.exe http://localhost:5060/test/admin/user/health

Write-Host "`nTEST 3 — Upgrade Starter Sample to Professional"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/set-plan -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"plan\":\"PROFESSIONAL\"}"

Write-Host "`nTEST 4 — Suspend Starter Sample"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/suspend -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\"}"

Write-Host "`nTEST 5 — Activate Starter Sample"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/activate -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\"}"

Write-Host "`nTEST 6 — Start Trial"
curl.exe -X POST http://localhost:5060/test/admin/owner/trial/start -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"days\":30}"

Write-Host "`nTEST 7 — Grant Legal AI Override"
curl.exe -X POST http://localhost:5060/test/admin/owner/feature/grant -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"userId\":\"USER_STARTER\",\"featureKey\":\"LEGAL_AI\"}"

Write-Host "`nTEST 8 — Ground Zero Downgrade Protection"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/set-plan -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_GROUND_ZERO\",\"plan\":\"STARTER\"}"

Write-Host "`n??? Live API test commands completed"

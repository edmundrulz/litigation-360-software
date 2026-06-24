cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Write-Host "===================================================="
Write-Host "PHASE 10ZZG.3 LIVE HARDENING TESTS"
Write-Host "Server must already be running:"
Write-Host "node tests\licensing\phase-10zzg-admin-api-test-server.js"
Write-Host "===================================================="

Write-Host "`nTEST 1 — Health"
curl.exe http://localhost:5060/test/admin/owner/health

Write-Host "`nTEST 2 — Missing Parameters Should Fail"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/set-plan -H "Content-Type: application/json" -d "{}"

Write-Host "`nTEST 3 — Invalid Plan Should Fail"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/set-plan -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"plan\":\"INVALID_PLAN\"}"

Write-Host "`nTEST 4 — Valid Upgrade Should Pass"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/set-plan -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"plan\":\"BUSINESS\"}"

Write-Host "`nTEST 5 — Ground Zero Suspend Should Be Blocked"
curl.exe -X POST http://localhost:5060/test/admin/owner/subscription/suspend -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_GROUND_ZERO\"}"

Write-Host "`nTEST 6 — Invalid Trial Days Should Fail"
curl.exe -X POST http://localhost:5060/test/admin/owner/trial/start -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"days\":120}"

Write-Host "`nTEST 7 — Valid Trial Days Should Pass"
curl.exe -X POST http://localhost:5060/test/admin/owner/trial/start -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"days\":30}"

Write-Host "`nTEST 8 — Normal User Must Be Blocked From Set Plan"
curl.exe -X POST http://localhost:5060/test/admin/user/subscription/set-plan -H "Content-Type: application/json" -d "{\"firmId\":\"FIRM_STARTER_SAMPLE\",\"plan\":\"ENTERPRISE\"}"

Write-Host "`n??? Phase 10ZZG.3 live test commands completed"

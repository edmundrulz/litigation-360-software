# L360 Local Verification Script

Write-Host "Starting Litigation 360 local verification..."

$ROOT = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

Set-Location $ROOT

Write-Host "Git status:"
git status

if (Test-Path "$ROOT\backend\package.json") {
    Write-Host "Checking backend..."
    Set-Location "$ROOT\backend"
    npm install
    npm test
    npm run build --if-present
}

if (Test-Path "$ROOT\frontend\package.json") {
    Write-Host "Checking frontend..."
    Set-Location "$ROOT\frontend"
    npm install
    npm test --if-present
    npm run build
}

Set-Location $ROOT
Write-Host "Verification complete."

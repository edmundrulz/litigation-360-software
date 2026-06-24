param(
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
)

$deployScript = Join-Path $ProjectRoot "DEPLOY-PMO-TRACKING-SYSTEM.ps1"

if (!(Test-Path $deployScript)) {
    Write-Host "[FAIL] Master deployment script not found:" -ForegroundColor Red
    Write-Host $deployScript
    exit 1
}

powershell -ExecutionPolicy Bypass -File $deployScript -ProjectRoot $ProjectRoot
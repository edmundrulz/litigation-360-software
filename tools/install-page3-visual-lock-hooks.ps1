$ErrorActionPreference = "Stop"

$hookPath = ".git/hooks/pre-commit"

if (!(Test-Path ".git")) {
  Write-Host "INSTALL FAILED: .git folder not found. Run from repository root." -ForegroundColor Red
  exit 1
}

if (!(Test-Path ".git/hooks")) {
  New-Item -ItemType Directory -Force -Path ".git/hooks" | Out-Null
}

if (!(Test-Path $hookPath)) {
  New-Item -ItemType File -Force -Path $hookPath | Out-Null
}

$hook = Get-Content $hookPath -Raw

$requiredCounterLine = 'powershell -ExecutionPolicy Bypass -File tools/verify-page3-required-counter-lock.ps1'
$alphabetLine = 'powershell -ExecutionPolicy Bypass -File tools/verify-page3-alphabet-filter-lock.ps1'

if ($hook -notlike "*verify-page3-required-counter-lock.ps1*") {
  Add-Content -Path $hookPath -Value ""
  Add-Content -Path $hookPath -Value "# Page 3 required counter permanent lock"
  Add-Content -Path $hookPath -Value $requiredCounterLine
}

if ($hook -notlike "*verify-page3-alphabet-filter-lock.ps1*") {
  Add-Content -Path $hookPath -Value ""
  Add-Content -Path $hookPath -Value "# Page 3 alphabet filter permanent lock"
  Add-Content -Path $hookPath -Value $alphabetLine
}

Write-Host "PAGE 3 VISUAL LOCK HOOK INSTALLER COMPLETED" -ForegroundColor Green
Write-Host "Installed/verified:"
Write-Host "- tools/verify-page3-required-counter-lock.ps1"
Write-Host "- tools/verify-page3-alphabet-filter-lock.ps1"

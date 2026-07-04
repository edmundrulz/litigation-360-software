$ErrorActionPreference = "Stop"

Write-Host "=== PROTECTION PRE-COMMIT CHECK ==="

powershell -ExecutionPolicy Bypass -File tools/verify-no-protected-deletions.ps1

if (Test-Path "tools/verify-page3-required-counter-lock.ps1") {
  powershell -ExecutionPolicy Bypass -File tools/verify-page3-required-counter-lock.ps1
}

if (Test-Path "tools/verify-page3-alphabet-filter-lock.ps1") {
  powershell -ExecutionPolicy Bypass -File tools/verify-page3-alphabet-filter-lock.ps1
}

if (Test-Path "tools/verify-page3-real-percentage-lock.ps1") {
  powershell -ExecutionPolicy Bypass -File tools/verify-page3-real-percentage-lock.ps1
}

Write-Host "PROTECTION PRE-COMMIT CHECK PASSED" -ForegroundColor Green
exit 0

$ErrorActionPreference = "Stop"

$clientsPath = "frontend/src/pages/Clients.jsx"

if (!(Test-Path $clientsPath)) {
  Write-Host "PAGE 3 REAL PERCENTAGE LOCK FAILED: Clients.jsx missing" -ForegroundColor Red
  exit 1
}

$clients = Get-Content $clientsPath -Raw

$requiredMarkers = @(
  "function getClientFormCompletionProgress(form)",
  "const completed = checks.filter(([, value]) => isCompletionValuePresent(value)).length;",
  "const total = checks.length;",
  "const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);",
  "percentage,",
  "{progress.percentage}% completed",
  "progress.percentage + ""%"""
)

foreach ($marker in $requiredMarkers) {
  if ($clients -notlike "*$marker*") {
    Write-Host "PAGE 3 REAL PERCENTAGE LOCK FAILED: missing marker: $marker" -ForegroundColor Red
    exit 1
  }
}

$badMarkers = @(
  "percentage = 100",
  "percentage: 100",
  "percentage = 75",
  "percentage: 75",
  "percentage = 50",
  "percentage: 50",
  "percentage = 25",
  "percentage: 25"
)

foreach ($badMarker in $badMarkers) {
  if ($clients -like "*$badMarker*") {
    Write-Host "PAGE 3 REAL PERCENTAGE LOCK FAILED: hardcoded percentage detected: $badMarker" -ForegroundColor Red
    exit 1
  }
}

Write-Host "PAGE 3 REAL PERCENTAGE LOCK PASSED" -ForegroundColor Green
exit 0

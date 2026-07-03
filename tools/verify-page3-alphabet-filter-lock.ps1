$ErrorActionPreference = "Stop"

$clientsPath = "frontend/src/pages/Clients.jsx"
$cssPath = "frontend/src/App.css"

if (!(Test-Path $clientsPath)) {
  Write-Host "PAGE 3 ALPHABET FILTER LOCK FAILED: Clients.jsx missing" -ForegroundColor Red
  exit 1
}

if (!(Test-Path $cssPath)) {
  Write-Host "PAGE 3 ALPHABET FILTER LOCK FAILED: App.css missing" -ForegroundColor Red
  exit 1
}

$clients = Get-Content $clientsPath -Raw
$css = Get-Content $cssPath -Raw

$requiredClientMarkers = @(
  "alphabet-filter-control",
  "alphabet-filter-main-row",
  "alphabet-filter-select-field",
  "alphabet-filter-manual-field",
  "alphabet-chip-grid",
  "Filter by Letter",
  "Manual Letter",
  "Type A-Z",
  "Show All Clients"
)

$requiredCssMarkers = @(
  "PHASE 14E ALPHABET FILTER FINAL STRUCTURED CONTROL",
  ".client-directory-control-panel .client-alphabet-filter.alphabet-filter-control",
  ".client-directory-control-panel .alphabet-filter-main-row",
  ".client-directory-control-panel .alphabet-filter-select-field",
  ".client-directory-control-panel .alphabet-filter-manual-field",
  ".client-directory-control-panel .alphabet-chip-grid"
)

foreach ($marker in $requiredClientMarkers) {
  if ($clients -notlike "*$marker*") {
    Write-Host "PAGE 3 ALPHABET FILTER LOCK FAILED: missing JSX marker: $marker" -ForegroundColor Red
    exit 1
  }
}

foreach ($marker in $requiredCssMarkers) {
  if ($css -notlike "*$marker*") {
    Write-Host "PAGE 3 ALPHABET FILTER LOCK FAILED: missing CSS marker: $marker" -ForegroundColor Red
    exit 1
  }
}

Write-Host "PAGE 3 ALPHABET FILTER LOCK PASSED" -ForegroundColor Green
exit 0

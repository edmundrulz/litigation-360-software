$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$clientsPath = Join-Path $root "frontend\src\pages\Clients.jsx"
$cssPath = Join-Path $root "frontend\src\App.css"

$failures = @()

function Add-Failure($message) {
  $script:failures += $message
}

function Require-File($path, $label) {
  if (-not (Test-Path $path)) {
    Add-Failure "$label missing: $path"
  }
}

function Require-Text($content, $pattern, $label) {
  if ($content -notmatch $pattern) {
    Add-Failure "$label not found."
  }
}

Require-File $clientsPath "Clients.jsx"
Require-File $cssPath "App.css"

if ($failures.Count -eq 0) {
  $clients = Get-Content $clientsPath -Raw
  $css = Get-Content $cssPath -Raw

  Require-Text $clients "function\s+ClientRequiredFieldCounter\s*\(" "ClientRequiredFieldCounter component"
  Require-Text $clients 'className="client-required-field-counter"' "Required counter wrapper class"
  Require-Text $clients 'className="client-required-field-counter-metrics"' "Required counter metrics class"
  Require-Text $clients ">[\s\r\n]*Required[\s\r\n]*<" "Required label"
  Require-Text $clients ">[\s\r\n]*Complete[\s\r\n]*<" "Complete label"
  Require-Text $clients ">[\s\r\n]*Missing[\s\r\n]*<" "Missing label"
  Require-Text $clients 'querySelectorAll\(' "Required-control DOM scan"
  Require-Text $clients 'input\[required\], select\[required\], textarea\[required\], \[aria-required="true"\]' "Required-control selector"

  Require-Text $css '\.client-required-field-counter\s*\{' "Required counter CSS wrapper"
  Require-Text $css '\.client-required-field-counter-metrics\s*\{' "Required counter metrics CSS"
  Require-Text $css '\.client-required-field-counter-metrics\s+span\s*\{' "Required counter metric card CSS"
  Require-Text $css '\.client-required-field-counter-metrics\s+strong\s*\{' "Required counter number CSS"

  if ($css -match '(?s)\.client-required-field-counter-metrics.{0,1200}(word-break\s*:\s*break-all|overflow-wrap\s*:\s*anywhere)') {
    Add-Failure "Unsafe text-breaking rule found near required counter metrics."
  }
}

if ($failures.Count -gt 0) {
  Write-Host ""
  Write-Host "PAGE 3 REQUIRED COUNTER LOCK FAILED" -ForegroundColor Red
  $failures | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
  exit 1
}

Write-Host "PAGE 3 REQUIRED COUNTER LOCK PASSED" -ForegroundColor Green
exit 0

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

$lockLines = @(
  @{
    Name = "Page 3 required counter permanent lock"
    Script = "tools/verify-page3-required-counter-lock.ps1"
  },
  @{
    Name = "Page 3 alphabet filter permanent lock"
    Script = "tools/verify-page3-alphabet-filter-lock.ps1"
  },
  @{
    Name = "Page 3 real percentage permanent lock"
    Script = "tools/verify-page3-real-percentage-lock.ps1"
  }
)

foreach ($lock in $lockLines) {
  $line = "powershell -ExecutionPolicy Bypass -File " + $lock.Script

  if ($hook -notlike ("*" + $lock.Script + "*")) {
    Add-Content -Path $hookPath -Value ""
    Add-Content -Path $hookPath -Value ("# " + $lock.Name)
    Add-Content -Path $hookPath -Value $line
  }
}

Write-Host "PAGE 3 VISUAL LOCK HOOK INSTALLER COMPLETED" -ForegroundColor Green
Write-Host "Installed/verified:"
Write-Host "- tools/verify-page3-required-counter-lock.ps1"
Write-Host "- tools/verify-page3-alphabet-filter-lock.ps1"
Write-Host "- tools/verify-page3-real-percentage-lock.ps1"

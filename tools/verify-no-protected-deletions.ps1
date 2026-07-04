$ErrorActionPreference = "Stop"

Write-Host "=== VERIFY NO PROTECTED DELETIONS ==="

$staged = git diff --cached --name-status

if (-not $staged) {
  Write-Host "No staged changes found. Protected deletion check passed."
  exit 0
}

$blocked = @()

foreach ($line in $staged) {
  if ($line -match "^(D|R|M)\s+(.+)$") {
    $status = $Matches[1]
    $path = $Matches[2]

    if ($status -eq "D") {
      $blocked += "Blocked deletion: $path"
    }

    if ($status -eq "R") {
      $blocked += "Blocked rename/move without approval: $path"
    }
  }
}

if ($blocked.Count -gt 0) {
  Write-Host "PROTECTED DELETION CHECK FAILED" -ForegroundColor Red
  foreach ($item in $blocked) {
    Write-Host $item -ForegroundColor Red
  }
  Write-Host ""
  Write-Host "Create an explicit deletion approval note before destructive changes:"
  Write-Host "docs/governance/deletion-approvals/YYYYMMDD_description.md"
  exit 1
}

Write-Host "PROTECTED DELETION CHECK PASSED" -ForegroundColor Green
exit 0

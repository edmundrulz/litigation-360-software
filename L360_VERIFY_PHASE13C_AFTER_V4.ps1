$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"
$MainRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ActiveControl = Join-Path $MainRoot "_L360_ACTIVE_CONTROL"

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 VERIFY PHASE 13C AFTER V4" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)
$markers = @()
if (Test-Path -LiteralPath $ActiveControl) {
  $markers += @(Get-ChildItem -LiteralPath $ActiveControl -File -Filter "*FINALIZED*" -ErrorAction SilentlyContinue)
  $markers += @(Get-ChildItem -LiteralPath $ActiveControl -File -Filter "*CUTOVER*" -ErrorAction SilentlyContinue)
}
$v4Logs = @(Get-ChildItem -LiteralPath $LogDir -File -Filter "phase13c_finalizer_v4_after_reboot_*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending)

$checks = @(
  [pscustomobject]@{Check="MAIN exists"; Expected=$true; Actual=(Test-Path -LiteralPath $MainRoot); Path=$MainRoot},
  [pscustomobject]@{Check="Original CLEANROOM removed"; Expected=$false; Actual=(Test-Path -LiteralPath $CleanroomRoot); Path=$CleanroomRoot},
  [pscustomobject]@{Check="Archive exists"; Expected=$true; Actual=($archives.Count -ge 1); Path=$Workspace},
  [pscustomobject]@{Check="Backend package exists"; Expected=$true; Actual=(Test-Path -LiteralPath (Join-Path $MainRoot "backend\package.json")); Path=(Join-Path $MainRoot "backend\package.json")},
  [pscustomobject]@{Check="Frontend package exists"; Expected=$true; Actual=(Test-Path -LiteralPath (Join-Path $MainRoot "frontend\package.json")); Path=(Join-Path $MainRoot "frontend\package.json")},
  [pscustomobject]@{Check="Marker exists"; Expected=$true; Actual=($markers.Count -ge 1); Path=$ActiveControl}
)

$checks | Format-Table -AutoSize

Write-Host ""
Write-Host "CURRENT FOLDERS:" -ForegroundColor Yellow
Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software*" | Select-Object Name, FullName | Format-Table -AutoSize

Write-Host ""
Write-Host "LATEST V4 LOG:" -ForegroundColor Yellow
if ($v4Logs.Count -gt 0) {
  Write-Host $v4Logs[0].FullName
  Get-Content -LiteralPath $v4Logs[0].FullName -Tail 30
} else {
  Write-Host "No V4 log found."
}

$pass = $true
foreach($c in $checks){
  if($c.Expected -ne $c.Actual){ $pass = $false }
}

Write-Host ""
if ($pass) {
  Write-Host "PASS — Phase 13C is finalized." -ForegroundColor Green
  Write-Host "Next: run L360_START_ALL.bat, then Phase 13B patch."
} else {
  Write-Host "NOT FINAL — do not run Phase 13B yet." -ForegroundColor Red
}
Write-Host ""
Read-Host "Press ENTER to close"

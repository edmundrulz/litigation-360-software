# ============================================================
# L360_ONE_CLICK_RESUME_CONTROLLER.ps1
#
# Purpose:
#   One fresh recovery controller after reboot/confusion.
#
# It does:
#   1. Verifies Phase 13C folder state.
#   2. If Phase 13C is NOT final, offers to run safe finalizer.
#   3. If Phase 13C IS final, creates/restores missing Phase 13B BAT/PS1.
#   4. Shows exact next action.
#
# It does NOT:
#   - delete folders
#   - touch LEOS_CONTROL
#   - run git clean/reset
#   - edit backend/database/RBAC/auth/package/env
# ============================================================

$ErrorActionPreference = "Continue"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"

$MainRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ControlRoot = Join-Path $Workspace "litigation-360-software_LEOS_CONTROL"
$ActiveControl = Join-Path $MainRoot "_L360_ACTIVE_CONTROL"

$LauncherBat = Join-Path $RunnerDir "L360_START_ALL.bat"
$Phase13BBat = Join-Path $RunnerDir "L360_PHASE13B_FRONTEND_STATUS_CLARITY.bat"
$Phase13BPs1 = Join-Path $RunnerDir "L360_PHASE13B_FRONTEND_STATUS_CLARITY.ps1"
$V4Ps1 = Join-Path $RunnerDir "L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ControllerLog = Join-Path $LogDir "one_click_resume_controller_$Stamp.log"

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -LiteralPath $ControllerLog -Append -Encoding UTF8
}

function Get-Phase13CState {
    $archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)

    $markers = @()
    if (Test-Path -LiteralPath $ActiveControl) {
        $markers += @(Get-ChildItem -LiteralPath $ActiveControl -File -Filter "*CUTOVER*" -ErrorAction SilentlyContinue)
        $markers += @(Get-ChildItem -LiteralPath $ActiveControl -File -Filter "*FINALIZED*" -ErrorAction SilentlyContinue)
        $statusFile = Join-Path $ActiveControl "00_PHASE_13C_CLEANROOM_CUTOVER_STATUS.md"
        if (Test-Path -LiteralPath $statusFile) { $markers += @(Get-Item -LiteralPath $statusFile) }
    }

    $mainExists = Test-Path -LiteralPath $MainRoot
    $cleanroomGone = -not (Test-Path -LiteralPath $CleanroomRoot)
    $backendPkg = Test-Path -LiteralPath (Join-Path $MainRoot "backend\package.json")
    $frontendPkg = Test-Path -LiteralPath (Join-Path $MainRoot "frontend\package.json")
    $archiveExists = $archives.Count -ge 1
    $markerExists = $markers.Count -ge 1

    return [pscustomobject]@{
        MainExists=$mainExists
        CleanroomGone=$cleanroomGone
        BackendPkg=$backendPkg
        FrontendPkg=$frontendPkg
        ArchiveExists=$archiveExists
        MarkerExists=$markerExists
        Final=($mainExists -and $cleanroomGone -and $backendPkg -and $frontendPkg -and $archiveExists -and $markerExists)
        ArchiveCount=$archives.Count
        MarkerCount=$markers.Count
    }
}

function Stop-ProjectPorts {
    $Ports = @(3000,4173,5000,5060,5061,5100,5173,8080)
    Write-Step "Stopping known project dev ports if active." "Yellow"
    foreach ($port in $Ports) {
        try {
            $lines = netstat -ano | Select-String ":$port\s"
            foreach ($line in $lines) {
                $parts = ($line.ToString() -split "\s+") | Where-Object { $_ -ne "" }
                if ($parts.Count -ge 5) {
                    $pidText = $parts[-1]
                    $procId = 0
                    if ([int]::TryParse($pidText, [ref]$procId)) {
                        if ($procId -gt 0 -and $procId -ne $PID) {
                            $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
                            if ($proc) {
                                Write-Step "Port $port => stopping PID $procId ($($proc.ProcessName))" "DarkYellow"
                                Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
                            }
                        }
                    }
                }
            }
        } catch {}
    }
    Start-Sleep -Seconds 2
}

function Close-ProjectExplorerWindows {
    try {
        $shell = New-Object -ComObject Shell.Application
        foreach ($w in @($shell.Windows())) {
            try {
                $loc = [string]$w.LocationURL
                $decoded = [System.Uri]::UnescapeDataString($loc)
                if ($decoded -like "*litigation-360-workspace*" -or $decoded -like "*litigation-360-software*") {
                    Write-Step "Closing File Explorer window: $decoded" "DarkYellow"
                    $w.Quit()
                }
            } catch {}
        }
    } catch {}
}

function Close-VSCode {
    foreach ($p in @(Get-Process -Name "Code" -ErrorAction SilentlyContinue)) {
        try {
            Write-Step "Closing VS Code PID $($p.Id)" "DarkYellow"
            $null = $p.CloseMainWindow()
        } catch {}
    }
    Start-Sleep -Seconds 2
    foreach ($p in @(Get-Process -Name "Code" -ErrorAction SilentlyContinue)) {
        try {
            Write-Step "Force closing VS Code PID $($p.Id)" "DarkYellow"
            Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
        } catch {}
    }
}

function Get-UniqueName {
    param([string]$BaseName)
    $candidate = Join-Path $Workspace $BaseName
    if (-not (Test-Path -LiteralPath $candidate)) { return $BaseName }
    return ($BaseName + "-" + $Stamp)
}

function Rename-With-Retry {
    param([string]$FromPath, [string]$ToName)

    for ($i=1; $i -le 8; $i++) {
        try {
            Set-Location -LiteralPath $Workspace
            Write-Step "Rename attempt $i FROM: $FromPath" "Cyan"
            Write-Step "Rename attempt $i TO  : $ToName" "Cyan"
            Rename-Item -LiteralPath $FromPath -NewName $ToName -ErrorAction Stop
            Write-Step "Rename succeeded." "Green"
            return $true
        } catch {
            Write-Step "Rename attempt $i failed: $($_.Exception.Message)" "Red"
            Close-ProjectExplorerWindows
            Close-VSCode
            Stop-ProjectPorts
            Start-Sleep -Seconds 3
        }
    }
    return $false
}

function Run-Phase13CFinalizerInline {
    Write-Step "Running inline Phase 13C finalizer." "Cyan"

    if (-not (Test-Path -LiteralPath $MainRoot)) {
        Write-Step "Main folder missing. Cannot proceed." "Red"
        return $false
    }

    Close-ProjectExplorerWindows
    Close-VSCode
    Stop-ProjectPorts
    Set-Location -LiteralPath $Workspace

    $state = Get-Phase13CState

    if ($state.Final) {
        Write-Step "Phase 13C already final." "Green"
        return $true
    }

    if (-not (Test-Path -LiteralPath $CleanroomRoot)) {
        Write-Step "Cleanroom already gone but final markers/archive incomplete. Creating verification marker only if main structure is valid." "Yellow"

        if ($state.MainExists -and $state.BackendPkg -and $state.FrontendPkg) {
            New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null
            $marker = Join-Path $ActiveControl ("PHASE13C_RECOVERY_MARKER_" + $Stamp + ".md")
            "# Phase 13C recovery marker`nGenerated: $(Get-Date)`nCleanroom already absent; main structure present." | Set-Content -LiteralPath $marker -Encoding UTF8
            Write-Step "Recovery marker written: $marker" "Green"
            return $true
        }

        return $false
    }

    if ($state.MarkerExists -and $state.ArchiveExists) {
        Write-Step "Markers/archive already exist; renaming leftover cleanroom." "Yellow"
        $leftoverName = Get-UniqueName "litigation-360-software-CLEANROOM-13C-LEFTOVER-AFTER-CUTOVER-RECOVERY"
        return (Rename-With-Retry -FromPath $CleanroomRoot -ToName $leftoverName)
    }

    Write-Step "Completing full cutover: current main archive, cleanroom promote." "Yellow"

    if (-not (Test-Path -LiteralPath (Join-Path $CleanroomRoot "backend\package.json"))) {
        Write-Step "Cleanroom backend package missing. Cannot promote cleanroom." "Red"
        return $false
    }
    if (-not (Test-Path -LiteralPath (Join-Path $CleanroomRoot "frontend\package.json"))) {
        Write-Step "Cleanroom frontend package missing. Cannot promote cleanroom." "Red"
        return $false
    }

    $archiveName = Get-UniqueName "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER-RECOVERY"
    $a = Rename-With-Retry -FromPath $MainRoot -ToName $archiveName
    if (-not $a) { return $false }

    $b = Rename-With-Retry -FromPath $CleanroomRoot -ToName "litigation-360-software"
    if (-not $b) { return $false }

    New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null
    $status = Join-Path $ActiveControl "00_PHASE_13C_CLEANROOM_CUTOVER_STATUS.md"
    $marker = Join-Path $ActiveControl ("PHASE13C_FINALIZED_RECOVERY_" + $Stamp + ".md")

    $content = @"
# Phase 13C finalized by one-click resume controller

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Official main:
$MainRoot

Former cleanroom:
$CleanroomRoot

Safety:
- no deletion
- LEOS_CONTROL untouched
- no git clean/reset
- no backend/database/RBAC/auth/package/env edits
"@
    $content | Set-Content -LiteralPath $status -Encoding UTF8
    $content | Set-Content -LiteralPath $marker -Encoding UTF8

    Write-Step "Finalization marker written." "Green"
    return $true
}

function Write-Phase13BFiles {
    Write-Step "Creating/restoring Phase 13B BAT and PS1 in _L360_RUNNER." "Cyan"

    $batContent = @'
@echo off
setlocal
title L360 PHASE 13B FRONTEND STATUS CLARITY

set "WORKSPACE=C:\Users\jep_edmundrulz\litigation-360-workspace"
set "RUNNER=%WORKSPACE%\_L360_RUNNER"
set "PS1=%RUNNER%\L360_PHASE13B_FRONTEND_STATUS_CLARITY.ps1"

if not exist "%PS1%" (
  echo ERROR: Phase 13B PS1 is missing:
  echo %PS1%
  pause
  exit /b 1
)

where pwsh >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
  goto :done
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

:done
pause
endlocal
'@

    $ps1Content = @'
$ErrorActionPreference = "Stop"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$ProjectRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"
$ActiveControl = Join-Path $ProjectRoot "_L360_ACTIVE_CONTROL"
$RollbackDir = Join-Path $ActiveControl "rollback"

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null
New-Item -ItemType Directory -Force -Path $RollbackDir | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupDir = Join-Path $ActiveControl ("backups\phase13b_frontend_status_clarity_" + $Stamp)
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

function Fail($m){ Write-Host $m -ForegroundColor Red; throw $m }
function Good($m){ Write-Host $m -ForegroundColor Green }
function Info($m){ Write-Host $m -ForegroundColor Cyan }

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 PHASE 13B FRONTEND STATUS CLARITY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

if (-not (Test-Path -LiteralPath $ProjectRoot)) { Fail "Official main folder missing." }
if (Test-Path -LiteralPath $CleanroomRoot) { Fail "Original CLEANROOM-13C folder still exists. Phase 13C not final. Stop." }

$archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)
if ($archives.Count -lt 1) { Fail "Polluted archive folder missing. Phase 13C not final. Stop." }

$MainJsx = Join-Path $ProjectRoot "frontend\src\main.jsx"
$Injector = Join-Path $ProjectRoot "frontend\src\l360-status-injector.js"

if (-not (Test-Path -LiteralPath $MainJsx)) { Fail "frontend/src/main.jsx missing." }

$MainBackup = Join-Path $BackupDir "main.jsx.backup"
Copy-Item -LiteralPath $MainJsx -Destination $MainBackup -Force
Good "Backup created: $MainBackup"

$InjectorContent = @"
/*
  L360 / LEOS Frontend Status Clarity Injector
  Phase: 13B
  Scope: Frontend-only status clarity
*/
(function l360StatusClarityInjector() {
  const STATUS_ID = 'l360-phase13b-status-clarity';
  const STYLE_ID = 'l360-phase13b-status-clarity-style';

  function install() {
    if (typeof document === 'undefined') return;
    if (document.getElementById(STATUS_ID)) return;

    const style = document.createElement('style');
    style.id = STYLE_ID;
    style.textContent = `
      #${STATUS_ID} {
        position: fixed;
        right: 16px;
        bottom: 16px;
        z-index: 2147483000;
        max-width: 420px;
        font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        background: rgba(18, 24, 38, 0.96);
        color: #ffffff;
        border: 1px solid rgba(255, 255, 255, 0.18);
        border-radius: 14px;
        box-shadow: 0 12px 36px rgba(0, 0, 0, 0.30);
        padding: 12px 14px;
        line-height: 1.35;
      }
      #${STATUS_ID} .l360-title { font-size: 13px; font-weight: 800; margin-bottom: 6px; }
      #${STATUS_ID} .l360-row { font-size: 12px; opacity: 0.94; margin: 3px 0; }
      #${STATUS_ID} .l360-pill {
        display: inline-block; font-size: 11px; font-weight: 700;
        padding: 2px 7px; margin-left: 5px; border-radius: 999px;
        background: rgba(255, 255, 255, 0.14);
      }
      #${STATUS_ID} button {
        position: absolute; top: 6px; right: 8px; border: 0;
        background: transparent; color: #ffffff; cursor: pointer;
        font-size: 16px; line-height: 1; opacity: 0.72;
      }
      #${STATUS_ID} button:hover { opacity: 1; }
      @media (max-width: 640px) {
        #${STATUS_ID} { left: 10px; right: 10px; bottom: 10px; max-width: none; }
      }
    `;

    const panel = document.createElement('aside');
    panel.id = STATUS_ID;
    panel.setAttribute('role', 'status');
    panel.setAttribute('aria-label', 'Litigation 360 operational status');
    panel.innerHTML = `
      <button type="button" aria-label="Hide status panel" title="Hide">×</button>
      <div class="l360-title">L360 / LEOS Operational Status <span class="l360-pill">Phase 13B</span></div>
      <div class="l360-row">Cleanroom cutover: <strong>MAIN promoted</strong></div>
      <div class="l360-row">Documents: <strong>metadata-only</strong></div>
      <div class="l360-row">RBAC: <strong>parked</strong></div>
      <div class="l360-row">Phase 11: <strong>locked</strong> · Production rollout: <strong>blocked</strong></div>
      <div class="l360-row">Scope: frontend status clarity only; no backend logic changed.</div>
    `;

    panel.querySelector('button')?.addEventListener('click', function () { panel.remove(); });
    document.head.appendChild(style);
    document.body.appendChild(panel);
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', install);
  else install();
})();
"@

Set-Content -LiteralPath $Injector -Value $InjectorContent -Encoding UTF8
Good "Injector written: $Injector"

$main = Get-Content -Raw -LiteralPath $MainJsx
if ($main -notmatch "l360-status-injector\.js") {
    $lines = Get-Content -LiteralPath $MainJsx
    $lastImport = -1
    for($i=0; $i -lt $lines.Count; $i++){
        if($lines[$i] -match '^\s*import\s+'){ $lastImport = $i }
    }
    if($lastImport -lt 0){ Fail "No import section found in main.jsx. Aborting safely." }

    $new = New-Object System.Collections.Generic.List[string]
    for($i=0; $i -lt $lines.Count; $i++){
        $new.Add($lines[$i])
        if($i -eq $lastImport){ $new.Add("import './l360-status-injector.js';") }
    }
    Set-Content -LiteralPath $MainJsx -Value $new -Encoding UTF8
    Good "main.jsx patched with injector import."
} else {
    Good "main.jsx already has injector import."
}

$Rollback = Join-Path $RollbackDir "ROLLBACK_PHASE13B_FRONTEND_STATUS_CLARITY.ps1"
@"
`$MainJsx = "$MainJsx"
`$MainBackup = "$MainBackup"
`$Injector = "$Injector"
if(Test-Path -LiteralPath `$MainBackup){ Copy-Item -LiteralPath `$MainBackup -Destination `$MainJsx -Force; Write-Host "main.jsx restored." }
if(Test-Path -LiteralPath `$Injector){ Remove-Item -LiteralPath `$Injector -Force; Write-Host "injector removed." }
Read-Host "Press ENTER to close"
"@ | Set-Content -LiteralPath $Rollback -Encoding UTF8

$Status = Join-Path $ActiveControl "01_PHASE_13B_FRONTEND_STATUS_CLARITY_STATUS.md"
@"
# L360 Phase 13B Frontend Status Clarity

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Applied frontend-only status clarity patch.

Files:
- frontend/src/main.jsx
- frontend/src/l360-status-injector.js

Rollback:
$Rollback

No backend/database/RBAC/auth/package/env files changed.
"@ | Set-Content -LiteralPath $Status -Encoding UTF8

Good "PHASE 13B FRONTEND STATUS CLARITY PATCH COMPLETE"
Write-Host ""
Write-Host "Next run launcher:"
Write-Host "  $RunnerDir\L360_START_ALL.bat"
Write-Host ""
Read-Host "Press ENTER to close"
'@

    Set-Content -LiteralPath $Phase13BBat -Value $batContent -Encoding ASCII
    Set-Content -LiteralPath $Phase13BPs1 -Value $ps1Content -Encoding UTF8

    Write-Step "Phase 13B BAT restored: $Phase13BBat" "Green"
    Write-Step "Phase 13B PS1 restored: $Phase13BPs1" "Green"
}

function Write-LauncherIfMissing {
    if (Test-Path -LiteralPath $LauncherBat) {
        Write-Step "Launcher already exists: $LauncherBat" "Green"
        return
    }

    Write-Step "Launcher missing. Creating minimal launcher placeholder." "Yellow"

    $launcher = @'
@echo off
setlocal
title L360 START ALL - MINIMAL LAUNCHER

echo This minimal launcher was recreated by the resume controller.
echo If you previously had the full live monitor launcher, you can re-extract that pack later.
echo.
echo Starting backend/frontend manually requires the original full launcher pack.
echo.
pause
endlocal
'@

    Set-Content -LiteralPath $LauncherBat -Value $launcher -Encoding ASCII
    Write-Step "Minimal launcher placeholder written: $LauncherBat" "Yellow"
}

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 ONE-CLICK RESUME CONTROLLER" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "This keeps you from running missing/wrong scripts."
Write-Host "Log: $ControllerLog"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "One-click resume controller started." "Cyan"

$state = Get-Phase13CState

Write-Host "CURRENT PHASE 13C STATE" -ForegroundColor Yellow
[pscustomobject]@{
    MainExists=$state.MainExists
    CleanroomGone=$state.CleanroomGone
    BackendPkg=$state.BackendPkg
    FrontendPkg=$state.FrontendPkg
    ArchiveExists=$state.ArchiveExists
    MarkerExists=$state.MarkerExists
    ArchiveCount=$state.ArchiveCount
    MarkerCount=$state.MarkerCount
    Phase13CFinal=$state.Final
} | Format-List

Write-Host ""
Write-Host "CURRENT FOLDERS" -ForegroundColor Yellow
Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software*" -ErrorAction SilentlyContinue |
    Select-Object Name, FullName |
    Format-Table -AutoSize

if (-not $state.Final) {
    Write-Host ""
    Write-Host "Phase 13C is NOT final. The controller can attempt safe finalization now." -ForegroundColor Yellow
    Write-Host "It will not delete anything and will not touch LEOS_CONTROL." -ForegroundColor Yellow
    Write-Host ""
    $answer = Read-Host "Type Y then ENTER to attempt Phase 13C finalization now, or anything else to stop"

    if ($answer -eq "Y" -or $answer -eq "y") {
        $ok = Run-Phase13CFinalizerInline
        $state = Get-Phase13CState

        if (-not $state.Final) {
            Write-Host ""
            Write-Host "Still not final. Do NOT run Phase 13B yet." -ForegroundColor Red
            Write-Host "Close File Explorer/VS Code/project terminals and run this controller again." -ForegroundColor Yellow
            Write-Host ""
            Read-Host "Press ENTER to close"
            exit 1
        }
    }
    else {
        Write-Host "Stopped safely. Do NOT run Phase 13B yet." -ForegroundColor Red
        Read-Host "Press ENTER to close"
        exit 0
    }
}

# If we are here, Phase 13C is final.
Write-Host ""
Write-Host "Phase 13C is FINAL." -ForegroundColor Green

Write-Phase13BFiles
Write-LauncherIfMissing

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " RESUME CONTROLLER COMPLETE" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Your missing Phase 13B BAT has been restored here:"
Write-Host "  $Phase13BBat"
Write-Host ""
Write-Host "Correct next step:"
Write-Host "  Run launcher if available:"
Write-Host "  $LauncherBat"
Write-Host ""
Write-Host "Then run Phase 13B:"
Write-Host "  $Phase13BBat"
Write-Host ""
Write-Host "If PowerShell complains about .bat path, run with call operator:"
Write-Host "  & `"$Phase13BBat`""
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Read-Host "Press ENTER to close"

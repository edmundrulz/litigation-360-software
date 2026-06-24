# ============================================================
# L360_FIX_PHASE13B_INJECTOR_PARSE_ERROR.ps1
#
# Fixes Vite/OXC parse error in:
#   frontend/src/l360-status-injector.js
#
# Cause:
#   Previous PowerShell-generated JS accidentally expanded/stripped
#   JavaScript template-literal placeholders like ${STATUS_ID},
#   causing invalid code such as:
#       # {
#
# Fix:
#   Overwrite injector with plain ES module-safe JavaScript.
#   No JS template literals.
#   No ${...}.
#   No backend/database/RBAC/auth/package/env edits.
# ============================================================

$ErrorActionPreference = "Stop"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$ProjectRoot = Join-Path $Workspace "litigation-360-software"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"
$ActiveControl = Join-Path $ProjectRoot "_L360_ACTIVE_CONTROL"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $LogDir "fix_phase13b_injector_parse_error_$Stamp.log"
$BackupDir = Join-Path $ActiveControl ("backups\fix_phase13b_injector_parse_error_" + $Stamp)
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

$Injector = Join-Path $ProjectRoot "frontend\src\l360-status-injector.js"
$MainJsx = Join-Path $ProjectRoot "frontend\src\main.jsx"
$FrontendDir = Join-Path $ProjectRoot "frontend"

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -LiteralPath $LogFile -Append -Encoding UTF8
}

function Stop-ProjectPorts {
    $Ports = @(3000,4173,5000,5060,5061,5100,5173,8080)
    Write-Step "Stopping existing project dev servers on known ports." "Yellow"

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

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 FIX PHASE 13B INJECTOR PARSE ERROR" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Project : $ProjectRoot"
Write-Host "Injector: $Injector"
Write-Host "Log     : $LogFile"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Starting Phase 13B injector parse-error fix." "Cyan"

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    throw "Project root missing: $ProjectRoot"
}
if (-not (Test-Path -LiteralPath $MainJsx)) {
    throw "frontend/src/main.jsx missing: $MainJsx"
}

Stop-ProjectPorts

if (Test-Path -LiteralPath $Injector) {
    $backup = Join-Path $BackupDir "l360-status-injector.js.broken.backup"
    Copy-Item -LiteralPath $Injector -Destination $backup -Force
    Write-Step "Broken injector backed up: $backup" "Green"
}

$FixedInjector = @'
/*
  L360 / LEOS Frontend Status Clarity Injector
  Phase: 13B
  Scope: frontend-only status clarity

  Safe version:
  - no JavaScript template literals
  - no ${...} placeholders
  - no backend calls
  - no RBAC/auth/database/package/env changes
*/

(function () {
  'use strict';

  var STATUS_ID = 'l360-phase13b-status-clarity';
  var STYLE_ID = 'l360-phase13b-status-clarity-style';

  function install() {
    if (typeof document === 'undefined') {
      return;
    }

    if (document.getElementById(STATUS_ID)) {
      return;
    }

    if (!document.getElementById(STYLE_ID)) {
      var style = document.createElement('style');
      style.id = STYLE_ID;
      style.textContent = [
        '#' + STATUS_ID + ' {',
        '  position: fixed;',
        '  right: 16px;',
        '  bottom: 16px;',
        '  z-index: 2147483000;',
        '  max-width: 420px;',
        '  font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;',
        '  background: rgba(18, 24, 38, 0.96);',
        '  color: #ffffff;',
        '  border: 1px solid rgba(255, 255, 255, 0.18);',
        '  border-radius: 14px;',
        '  box-shadow: 0 12px 36px rgba(0, 0, 0, 0.30);',
        '  padding: 12px 14px;',
        '  line-height: 1.35;',
        '}',
        '#' + STATUS_ID + ' .l360-title {',
        '  font-size: 13px;',
        '  font-weight: 800;',
        '  letter-spacing: 0.02em;',
        '  margin-bottom: 6px;',
        '}',
        '#' + STATUS_ID + ' .l360-row {',
        '  font-size: 12px;',
        '  opacity: 0.94;',
        '  margin: 3px 0;',
        '}',
        '#' + STATUS_ID + ' .l360-pill {',
        '  display: inline-block;',
        '  font-size: 11px;',
        '  font-weight: 700;',
        '  padding: 2px 7px;',
        '  margin-left: 5px;',
        '  border-radius: 999px;',
        '  background: rgba(255, 255, 255, 0.14);',
        '}',
        '#' + STATUS_ID + ' button {',
        '  position: absolute;',
        '  top: 6px;',
        '  right: 8px;',
        '  border: 0;',
        '  background: transparent;',
        '  color: #ffffff;',
        '  cursor: pointer;',
        '  font-size: 16px;',
        '  line-height: 1;',
        '  opacity: 0.72;',
        '}',
        '#' + STATUS_ID + ' button:hover {',
        '  opacity: 1;',
        '}',
        '@media (max-width: 640px) {',
        '  #' + STATUS_ID + ' {',
        '    left: 10px;',
        '    right: 10px;',
        '    bottom: 10px;',
        '    max-width: none;',
        '  }',
        '}'
      ].join('\n');

      document.head.appendChild(style);
    }

    var panel = document.createElement('aside');
    panel.id = STATUS_ID;
    panel.setAttribute('role', 'status');
    panel.setAttribute('aria-label', 'Litigation 360 operational status');

    var closeButton = document.createElement('button');
    closeButton.type = 'button';
    closeButton.setAttribute('aria-label', 'Hide status panel');
    closeButton.title = 'Hide';
    closeButton.textContent = '×';
    closeButton.addEventListener('click', function () {
      panel.remove();
    });

    var title = document.createElement('div');
    title.className = 'l360-title';
    title.innerHTML = 'L360 / LEOS Operational Status <span class="l360-pill">Phase 13B</span>';

    var rows = [
      'Cleanroom cutover: <strong>MAIN promoted</strong>',
      'Documents: <strong>metadata-only</strong>',
      'RBAC: <strong>parked</strong>',
      'Phase 11: <strong>locked</strong> · Production rollout: <strong>blocked</strong>',
      'Scope: frontend status clarity only; no backend logic changed.'
    ];

    panel.appendChild(closeButton);
    panel.appendChild(title);

    rows.forEach(function (text) {
      var row = document.createElement('div');
      row.className = 'l360-row';
      row.innerHTML = text;
      panel.appendChild(row);
    });

    document.body.appendChild(panel);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', install);
  } else {
    install();
  }
})();
'@

Set-Content -LiteralPath $Injector -Value $FixedInjector -Encoding UTF8
Write-Step "Fixed injector written: $Injector" "Green"

$mainContent = Get-Content -Raw -LiteralPath $MainJsx
if ($mainContent -notmatch "l360-status-injector\.js") {
    Write-Step "main.jsx is missing injector import. Adding it safely." "Yellow"

    $lines = Get-Content -LiteralPath $MainJsx
    $lastImportIndex = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*import\s+') {
            $lastImportIndex = $i
        }
    }

    if ($lastImportIndex -lt 0) {
        throw "Could not find import section in main.jsx. Injector file fixed, but import was not added."
    }

    $newLines = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $newLines.Add($lines[$i])
        if ($i -eq $lastImportIndex) {
            $newLines.Add("import './l360-status-injector.js';")
        }
    }

    Set-Content -LiteralPath $MainJsx -Value $newLines -Encoding UTF8
    Write-Step "main.jsx import added." "Green"
}
else {
    Write-Step "main.jsx already imports l360-status-injector.js." "Green"
}

# Quick syntax sanity check using node if available.
try {
    Push-Location $FrontendDir
    $nodeVersion = cmd /c "node --version 2>&1"
    if ($LASTEXITCODE -eq 0) {
        Write-Step "Node found: $nodeVersion" "Green"
        cmd /c "node --check src\l360-status-injector.js"
        if ($LASTEXITCODE -ne 0) {
            throw "node --check failed for l360-status-injector.js"
        }
        Write-Step "node --check PASSED for injector." "Green"
    } else {
        Write-Step "Node not available for syntax check. Skipping." "Yellow"
    }
    Pop-Location
}
catch {
    try { Pop-Location } catch {}
    Write-Step "Syntax check failed: $($_.Exception.Message)" "Red"
    throw
}

$StatusFile = Join-Path $ActiveControl "02_PHASE13B_INJECTOR_PARSE_ERROR_FIXED.md"
$RollbackScript = Join-Path $ActiveControl "rollback\ROLLBACK_FIX_PHASE13B_INJECTOR_PARSE_ERROR.ps1"
New-Item -ItemType Directory -Force -Path (Split-Path $RollbackScript -Parent) | Out-Null

@"
# L360 Phase 13B Injector Parse Error Fixed

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Problem

Vite/OXC failed on:

frontend/src/l360-status-injector.js

because previous generated JS contained invalid CSS/template literal output such as:

# {

## Fix

The injector was overwritten with a plain JavaScript version using string arrays and concatenation.

## Files changed

- frontend/src/l360-status-injector.js

## Files not touched

- backend
- database
- RBAC
- auth
- package.json
- package-lock.json
- .env
- LEOS_CONTROL

## Backup

$BackupDir

## Next

Run:

$RunnerDir\L360_START_ALL.bat

Expected:

- Mode: MAIN
- Backend: PASS
- Frontend: PASS

"@ | Set-Content -LiteralPath $StatusFile -Encoding UTF8

@"
`$Injector = "$Injector"
`$Backup = "$BackupDir\l360-status-injector.js.broken.backup"

if (Test-Path -LiteralPath `$Backup) {
    Copy-Item -LiteralPath `$Backup -Destination `$Injector -Force
    Write-Host "Restored previous injector backup."
} else {
    Write-Host "No backup found."
}

Read-Host "Press ENTER to close"
"@ | Set-Content -LiteralPath $RollbackScript -Encoding UTF8

Write-Step "Status marker written: $StatusFile" "Green"
Write-Step "Rollback script written: $RollbackScript" "Green"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " PHASE 13B INJECTOR PARSE ERROR FIXED" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Now run:"
Write-Host "  $RunnerDir\L360_START_ALL.bat"
Write-Host ""
Write-Host "Expected:"
Write-Host "  Mode: MAIN"
Write-Host "  Backend: PASS"
Write-Host "  Frontend: PASS"
Write-Host ""
Write-Host "Open:"
Write-Host "  http://localhost:5173"
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""

Read-Host "Press ENTER to close"

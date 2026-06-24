# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R4 NON-BLOCKING RIGHT-SIDE LEGAL TOOLS DOCK FIX
#
# PURPOSE:
#   Fix the GUI overlap issue where the new Legal 360 tools panel
#   blocks the existing 4 main left-sidebar buttons.
#
# EXISTING 4 MAIN BUTTONS TO PRESERVE:
#   - End User Workspace
#   - Operations Centre
#   - Admin Centre
#   - Developer Centre
#
# FIX DESIGN:
#   - Move Legal 360 tools dock away from the left sidebar
#   - Place it on the right side as a floating command dock
#   - Keep Legal Web Links, Launch Apps / Docs, Search, Instructions,
#     Glossary, Firm Info, Managing Partner, Settings
#   - Keep all new functionality from Phase 12.0N-R3
#
# SAFE MODE:
#   - Backs up current enhancer CSS
#   - Only updates frontend/src/legal-management-enhancer.css
#   - Does NOT modify database
#   - Does NOT modify backend
#   - Does NOT unlock production
#   - Does NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0N-R4] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Save-Text {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )

    $Folder = Split-Path -Path $Path -Parent
    if (!(Test-Path -LiteralPath $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

# ------------------------------------------------------------
# 1. Resolve paths
# ------------------------------------------------------------
Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$FrontendRoot = Join-Path $ProjectRoot "frontend"
$FrontendSrc = Join-Path $FrontendRoot "src"
$CssPath = Join-Path $FrontendSrc "legal-management-enhancer.css"
$JsPath = Join-Path $FrontendSrc "legal-management-enhancer.js"

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R4-$RunStamp"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $RollbackRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. Preflight
# ------------------------------------------------------------
Write-Step "Running preflight checks..."

$PreflightRows = @()
$PreflightRows += [PSCustomObject]@{ Item="frontend folder"; Path=$FrontendRoot; Exists=(Test-Path -LiteralPath $FrontendRoot -PathType Container) }
$PreflightRows += [PSCustomObject]@{ Item="frontend/src folder"; Path=$FrontendSrc; Exists=(Test-Path -LiteralPath $FrontendSrc -PathType Container) }
$PreflightRows += [PSCustomObject]@{ Item="legal-management-enhancer.css"; Path=$CssPath; Exists=(Test-Path -LiteralPath $CssPath -PathType Leaf) }
$PreflightRows += [PSCustomObject]@{ Item="legal-management-enhancer.js"; Path=$JsPath; Exists=(Test-Path -LiteralPath $JsPath -PathType Leaf) }

$PreflightRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R4-PREFLIGHT-CHECK.csv") -NoTypeInformation -Encoding UTF8

$Missing = @($PreflightRows | Where-Object { $_.Exists -eq $false })

if ($Missing.Count -gt 0) {
    $MissingText = ($Missing | ForEach-Object { "$($_.Item): $($_.Path)" }) -join "`r`n"

    $FailReport = @"
# PHASE 12.0N-R4 FAILED PREFLIGHT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Missing items:

$MissingText

No active modification was performed.

Recommended fix:
Run Phase 12.0N-R2 and Phase 12.0N-R3 first, then run this R4 layout fix.
"@

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R4-FAILED-PREFLIGHT-REPORT.md") -Content $FailReport
    Write-Fail "Preflight failed."
    exit 1
}

Write-Pass "Preflight passed."

# ------------------------------------------------------------
# 3. Backup CSS
# ------------------------------------------------------------
Write-Step "Backing up current enhancer CSS..."

$CssBackup = Join-Path $RollbackRoot "legal-management-enhancer.css.BACKUP-BEFORE-12.0N-R4"
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backup created:"
Write-Host $CssBackup -ForegroundColor Green

# ------------------------------------------------------------
# 4. Append non-blocking layout override
# ------------------------------------------------------------
Write-Step "Applying right-side non-blocking layout override..."

$ExistingCss = [System.IO.File]::ReadAllText($CssPath)

$OverrideMarker = "PHASE 12.0N-R4 NON-BLOCKING RIGHT-SIDE LEGAL TOOLS DOCK FIX"

$OverrideCss = @'

/* ============================================================
   PHASE 12.0N-R4 NON-BLOCKING RIGHT-SIDE LEGAL TOOLS DOCK FIX

   Purpose:
   - The Legal 360 dock must NOT block the original left sidebar.
   - Original buttons remain visible:
     End User Workspace, Operations Centre, Admin Centre, Developer Centre.
   - Legal tools move to the right side.
   ============================================================ */

.leos-pro-dock {
  left: auto !important;
  right: 18px !important;
  top: 96px !important;
  width: 224px !important;
  max-height: calc(100vh - 125px) !important;
  border-radius: 16px !important;
  z-index: 2147483000 !important;
}

.leos-pro-drawer {
  left: auto !important;
  right: 260px !important;
  top: 40px !important;
  width: min(820px, calc(100vw - 540px)) !important;
  max-height: calc(100vh - 80px) !important;
  z-index: 2147483001 !important;
}

/* Give the right dock a clearer command-centre appearance. */
.leos-pro-title {
  position: sticky !important;
  top: 0 !important;
  background: #111827 !important;
  z-index: 2 !important;
}

.leos-pro-dock .major {
  background: #f8f3dc !important;
  color: #111827 !important;
  border-color: #c9a646 !important;
}

/* Slightly smaller command buttons so the dock fits without scrolling too much. */
.leos-pro-dock button {
  font-size: 11px !important;
  padding: 8px 8px !important;
  margin: 4px 0 !important;
}

/* On medium screens, make the drawer centered so it does not crush the workspace. */
@media (max-width: 1250px) {
  .leos-pro-drawer {
    right: 18px !important;
    top: 40px !important;
    width: min(760px, calc(100vw - 260px)) !important;
  }
}

/* On small screens, convert to bottom command bar. */
@media (max-width: 900px) {
  .leos-pro-dock {
    left: 10px !important;
    right: 10px !important;
    top: auto !important;
    bottom: 10px !important;
    width: auto !important;
    max-height: 42vh !important;
    display: grid !important;
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
    gap: 6px !important;
  }

  .leos-pro-title {
    grid-column: 1 / -1 !important;
  }

  .leos-pro-dock button {
    margin: 0 !important;
    text-align: center !important;
  }

  .leos-pro-drawer {
    left: 10px !important;
    right: 10px !important;
    top: 10px !important;
    width: auto !important;
    max-height: calc(100vh - 20px) !important;
  }
}

/* Emergency safety: never cover the original left nav on normal desktop widths. */
@media (min-width: 901px) {
  .leos-pro-dock,
  .leos-pro-drawer {
    transform: none !important;
  }
}
'@

$AppliedStatus = "ALREADY PRESENT"

if (-not $ExistingCss.Contains($OverrideMarker)) {
    Save-Text -Path $CssPath -Content ($ExistingCss + "`r`n" + $OverrideCss)
    $AppliedStatus = "APPLIED"
}

# ------------------------------------------------------------
# 5. Create rollback guide and report
# ------------------------------------------------------------
Write-Step "Creating rollback guide and report..."

$RollbackGuide = @"
# PHASE 12.0N-R4 ROLLBACK GUIDE

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Purpose

This rollback restores the enhancer CSS to the state before the right-side layout fix.

## Restore CSS

Copy-Item -LiteralPath "$CssBackup" -Destination "$CssPath" -Force

## Safety

This rollback only affects the Legal 360 enhancer layout.
It does not touch database, backend, App.jsx, or production flags.
"@

Save-Text -Path (Join-Path $RollbackRoot "ROLLBACK-GUIDE.md") -Content $RollbackGuide

$Checklist = @"
# PHASE 12.0N-R4 POST-LAYOUT-FIX CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restart frontend

cd "$FrontendRoot"
npm run dev

## Open

http://localhost:5173/

## Expected Layout

The original left sidebar must remain clear and clickable:

- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre

The Legal 360 tools dock should now appear on the RIGHT side, not over the left sidebar.

## Check Legal Tools

Click:

- Legal Web Links
- Launch Apps / Docs
- Search Repository
- Instructions
- Glossary
- Firm Info
- Managing Partner
- Settings

## PASS Criteria

- Existing 4 main buttons visible
- Existing 4 main buttons clickable
- Legal tools dock visible on right side
- Legal drawer opens without blocking the left sidebar
- Legal Web Links still works
- Manual legal link add form still works
- Launch Apps / Docs still separate
- No white screen
- No fatal browser console error

## Report Back

Original 4 main buttons visible:
YES / NO

Original 4 main buttons clickable:
YES / NO

Legal tools moved to right side:
YES / NO

Legal Web Links works:
YES / NO

Launch Apps / Docs works:
YES / NO

Manual legal link form works:
YES / NO

Existing pages still work:
YES / NO

Browser console errors:
YES / NO
"@

Save-Text -Path (Join-Path $RollbackRoot "POST-LAYOUT-FIX-CHECKLIST.md") -Content $Checklist

$Report = @"
# PHASE 12.0N-R4 NON-BLOCKING RIGHT-SIDE LEGAL TOOLS DOCK FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety Confirmation

Current enhancer CSS was backed up.
Only frontend/src/legal-management-enhancer.css was updated.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Problem Fixed

The Legal 360 tools panel was overlapping or blocking the existing left-sidebar buttons:

- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre

## Layout Fix Applied

The Legal 360 tools dock was moved from the left side to the right side.

The drawer was also moved to open from the right side.

## Applied Status

$AppliedStatus

## Backup Folder

$RollbackRoot

## Files Updated

$CssPath

## Rollback File

$CssBackup

## Test URL

http://localhost:5173/

## Final Ruling

Phase 12.0N-R4:
NON-BLOCKING RIGHT-SIDE LEGAL TOOLS DOCK FIX COMPLETE

Production unlock:
NO

Phase 11:
LOCKED
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R4-NON-BLOCKING-RIGHT-SIDE-LEGAL-TOOLS-DOCK-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0N-R4 NON-BLOCKING RIGHT-SIDE LEGAL TOOLS DOCK FIX COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R4-NON-BLOCKING-RIGHT-SIDE-LEGAL-TOOLS-DOCK-FIX-REPORT.md"'
Write-Host ""
Write-Host "Open checklist:" -ForegroundColor Cyan
Write-Host "notepad `"$($RollbackRoot.Substring($ProjectRoot.Length).TrimStart("\"))\POST-LAYOUT-FIX-CHECKLIST.md`""
Write-Host ""
Write-Host "Test URL:" -ForegroundColor Cyan
Write-Host "http://localhost:5173/"
Write-Host ""
Write-Pass "Paste the Phase 12.0N-R4 report and visual result back into ChatGPT."

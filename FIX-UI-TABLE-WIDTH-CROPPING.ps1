# ============================================================
# LITIGATION 360
# UI WIDTH / TABLE CROPPING FIX
#
# Purpose:
#   Fix table/header content being cropped on the right side,
#   especially the Actions column.
#
# Safety:
#   - Creates backup before modifying CSS
#   - Modifies CSS only
#   - Does NOT touch App.jsx
#   - Does NOT touch backend
#   - Does NOT touch database
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[UI WIDTH FIX] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Fail {
    param([string]$Message)
    throw "[FAIL] $Message"
}

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

$FrontendSrc = Join-Path $ProjectRoot "frontend\src"
$AppCss = Join-Path $FrontendSrc "App.css"
$IndexCss = Join-Path $FrontendSrc "index.css"

if (Test-Path -LiteralPath $AppCss -PathType Leaf) {
    $TargetCss = $AppCss
} elseif (Test-Path -LiteralPath $IndexCss -PathType Leaf) {
    $TargetCss = $IndexCss
} else {
    Fail "Could not find App.css or index.css in frontend\src"
}

$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Step "Target CSS file:"
Write-Host $TargetCss -ForegroundColor Green

$BackupPath = "$TargetCss.BACKUP_BEFORE_TABLE_WIDTH_FIX_$Stamp"
Copy-Item -LiteralPath $TargetCss -Destination $BackupPath -Force
Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

$Css = [System.IO.File]::ReadAllText($TargetCss)

$MarkerStart = "/* L360 TABLE WIDTH FIX START */"
$MarkerEnd = "/* L360 TABLE WIDTH FIX END */"

$FixBlock = @"

/* L360 TABLE WIDTH FIX START */
/* Fix right-side cropping in module tables and make the app use the full browser width. */

html,
body,
#root {
  width: 100%;
  max-width: none !important;
  min-width: 0;
}

body {
  margin: 0;
  overflow-x: auto;
}

#root {
  box-sizing: border-box;
  padding-left: 16px !important;
  padding-right: 16px !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
  text-align: left;
}

main,
section,
.hero,
.summary,
.grid,
.module-toolbar {
  box-sizing: border-box;
  width: 100%;
  max-width: none !important;
}

table {
  width: 100%;
  max-width: 100%;
  border-collapse: collapse;
  table-layout: auto;
}

thead,
tbody,
tr {
  width: 100%;
}

th,
td {
  box-sizing: border-box;
  padding: 8px 10px;
  vertical-align: top;
  text-align: left;
  white-space: normal;
  overflow-wrap: anywhere;
  word-break: break-word;
}

th:last-child,
td:last-child {
  min-width: 90px;
  padding-right: 16px;
  white-space: nowrap;
}

td button,
th button {
  max-width: 100%;
}

/* Make action buttons stack neatly instead of getting chopped on the right. */
td:last-child button {
  display: block;
  width: 100%;
  margin-bottom: 6px;
}

/* L360 TABLE WIDTH FIX END */
"@

if ($Css.Contains($MarkerStart)) {
    Write-Warn "Existing L360 table width fix found. Replacing old fix block."

    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $FixBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $FixBlock
}

[System.IO.File]::WriteAllText($TargetCss, $Css, (New-Object System.Text.UTF8Encoding($false)))

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "UI-TABLE-WIDTH-FIX-REPORT-$Stamp.md"

$Report = @"
# UI Table Width Fix Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified CSS file:
$TargetCss

Backup:
$BackupPath

## Problem

Client/module table content was cropped on the right side, especially the Actions header and action buttons.

## Changes Applied

- Removed max-width restriction from root layout.
- Reduced left/right root padding.
- Allowed app to use full browser width.
- Made tables use full available width.
- Added word wrapping for long email/name/address fields.
- Protected final Actions column from being cropped.
- Stacked action buttons vertically inside the Actions column.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Files deleted: NO

## Next Test

1. cd "$ProjectRoot\frontend"
2. npm run dev
3. Browser hard refresh: Ctrl + F5
4. Open Clients table and confirm Actions column is no longer cropped.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "UI TABLE WIDTH FIX COMPLETE"
Write-Host ""
Write-Host "Modified CSS file:" -ForegroundColor Cyan
Write-Host $TargetCss
Write-Host ""
Write-Host "Backup:" -ForegroundColor Cyan
Write-Host $BackupPath
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

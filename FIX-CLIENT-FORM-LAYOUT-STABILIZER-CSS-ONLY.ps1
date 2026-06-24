# ============================================================
# LITIGATION 360
# CLIENT FORM LAYOUT STABILIZER - CSS ONLY
#
# Purpose:
#   Fix the messy client registration form layout WITHOUT touching JSX.
#   This patch only adjusts CSS:
#   - Stops fields from overflowing outside the form card
#   - Changes form grid from cramped 4-column layout to clean 2-column layout
#   - Makes labels and helper text smaller and consistent
#   - Aligns checkboxes properly
#   - Keeps section headers professional and smaller
#   - Improves responsive behavior
#
# Safety:
#   - Backs up CSS first
#   - Modifies CSS only
#   - Does NOT modify Clients.jsx
#   - Does NOT modify App.jsx
#   - Does NOT modify backend
#   - Does NOT modify database
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT FORM LAYOUT STABILIZER] $Message" -ForegroundColor Cyan
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
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (Test-Path -LiteralPath $AppCss -PathType Leaf) {
    $CssPath = $AppCss
} elseif (Test-Path -LiteralPath $IndexCss -PathType Leaf) {
    $CssPath = $IndexCss
} else {
    Fail "Could not find App.css or index.css in frontend\src"
}

Write-Step "Target CSS file:"
Write-Host $CssPath -ForegroundColor Green

$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_FORM_LAYOUT_STABILIZER_$Stamp"
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force
Write-Pass "CSS backup created:"
Write-Host $CssBackup -ForegroundColor Green

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT FORM LAYOUT STABILIZER START */"
$MarkerEnd = "/* L360 CLIENT FORM LAYOUT STABILIZER END */"

$CssBlock = @'

/* L360 CLIENT FORM LAYOUT STABILIZER START */

/* Page/container: allow the workspace to breathe but keep the form controlled. */
html,
body,
#root {
  width: 100% !important;
  max-width: none !important;
}

body {
  overflow-x: auto;
}

#root {
  box-sizing: border-box;
}

/* Main client module sizing */
.client-module {
  width: 100% !important;
  max-width: none !important;
  box-sizing: border-box !important;
  font-size: 14px !important;
  line-height: 1.35 !important;
}

.client-module * {
  box-sizing: border-box !important;
}

/* Header sizing */
.client-module h2 {
  font-size: 22px !important;
  line-height: 1.2 !important;
  margin: 0 0 6px !important;
}

.client-module p {
  font-size: 13px !important;
  line-height: 1.35 !important;
}

/* Section headers: smaller, cleaner, not oversized blocks */
.client-module h3 {
  display: block !important;
  width: 100% !important;
  margin: 20px 0 12px !important;
  padding: 8px 10px !important;
  border-left: 4px solid #0b3b6f !important;
  background: #f5f8fc !important;
  border-radius: 7px !important;
  font-size: 16px !important;
  line-height: 1.25 !important;
  font-weight: 800 !important;
}

/* Form card */
.client-form {
  width: 100% !important;
  max-width: 100% !important;
  overflow: hidden !important;
  padding: 16px !important;
  border-radius: 12px !important;
}

/* CRITICAL FIX:
   4 columns were too cramped and caused fields to spill outside.
   Use a stable 2-column layout for professional forms. */
.client-form-grid {
  display: grid !important;
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  gap: 14px 18px !important;
  align-items: start !important;
  width: 100% !important;
}

/* Every grid item must be allowed to shrink inside its column. */
.client-form-grid > * {
  min-width: 0 !important;
  max-width: 100% !important;
}

/* Longer notes/textareas should take the full row. */
.client-span-2 {
  grid-column: 1 / -1 !important;
}

/* Labels: consistent small professional size */
.client-form-grid label,
.client-search-row label {
  display: flex !important;
  flex-direction: column !important;
  gap: 6px !important;
  min-width: 0 !important;
  max-width: 100% !important;
  font-size: 13px !important;
  line-height: 1.25 !important;
  font-weight: 700 !important;
  color: #162033 !important;
}

/* Inputs/selects/textareas: same height, same font, no overflow */
.client-form-grid input,
.client-form-grid select,
.client-form-grid textarea,
.client-search-row input {
  width: 100% !important;
  max-width: 100% !important;
  min-width: 0 !important;
  min-height: 38px !important;
  padding: 8px 10px !important;
  border: 1px solid #cbd3df !important;
  border-radius: 8px !important;
  font-size: 13px !important;
  line-height: 1.25 !important;
  font-weight: 600 !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

.client-form-grid textarea {
  min-height: 76px !important;
  resize: vertical !important;
}

/* Helper notes: smaller and not visually overpowering */
.client-form-grid small {
  display: block !important;
  max-width: 100% !important;
  font-size: 11.5px !important;
  line-height: 1.3 !important;
  font-weight: 500 !important;
  color: #5f6b7a !important;
}

/* Required and number markers */
.field-required,
.field-number {
  display: inline-block !important;
  margin-left: 4px !important;
  font-size: 13px !important;
  line-height: 1 !important;
  font-weight: 900 !important;
}

.field-required {
  color: #b00020 !important;
}

.field-number {
  color: #0b3b6f !important;
}

/* Checkbox rows: fix the checkbox floating far away and align it properly. */
.client-form-grid label.client-checkbox-label,
.client-checkbox-label {
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  justify-content: flex-start !important;
  gap: 8px !important;
  min-height: 38px !important;
  padding: 8px 10px !important;
  border: 1px solid #e2e7ef !important;
  border-radius: 8px !important;
  background: #fbfcfe !important;
  font-size: 13px !important;
  line-height: 1.25 !important;
}

.client-checkbox-label input[type="checkbox"] {
  width: 18px !important;
  height: 18px !important;
  min-height: 18px !important;
  flex: 0 0 auto !important;
  margin: 0 !important;
  padding: 0 !important;
}

/* Validation/status boxes */
.client-status,
.client-validation-box {
  font-size: 13px !important;
  line-height: 1.35 !important;
}

/* Buttons: not tiny, but not oversized */
.client-form-actions {
  display: flex !important;
  gap: 10px !important;
  margin-top: 16px !important;
  flex-wrap: wrap !important;
}

.client-form-actions button {
  min-width: 120px !important;
  min-height: 34px !important;
  padding: 7px 12px !important;
  font-size: 13px !important;
  font-weight: 700 !important;
}

/* Client search: clean single full-width row */
.client-search-row {
  margin: 16px 0 !important;
}

.client-search-row input {
  min-height: 40px !important;
}

/* Table stays horizontally scrollable instead of crushing columns */
.client-table-wrap {
  width: 100% !important;
  max-width: 100% !important;
  overflow-x: auto !important;
}

.client-table {
  width: max-content !important;
  min-width: 100% !important;
  table-layout: auto !important;
}

.client-table th {
  white-space: nowrap !important;
  word-break: normal !important;
  overflow-wrap: normal !important;
  font-size: 13px !important;
}

.client-table td {
  font-size: 12.5px !important;
  max-width: 260px !important;
}

/* Responsive: 1 column on smaller screens */
@media (max-width: 900px) {
  .client-form-grid {
    grid-template-columns: 1fr !important;
  }

  .client-span-2 {
    grid-column: 1 / -1 !important;
  }

  .client-module-header {
    flex-direction: column !important;
  }

  .client-count-card {
    text-align: left !important;
  }
}

/* L360 CLIENT FORM LAYOUT STABILIZER END */
'@

if ($Css.Contains($MarkerStart)) {
    Write-Warn "Existing layout stabilizer found. Replacing old stabilizer block."
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-FORM-LAYOUT-STABILIZER-REPORT-$Stamp.md"

$Report = @"
# Client Form Layout Stabilizer Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified CSS:
$CssPath

Backup:
$CssBackup

## Fixed

- Reduced form from cramped 4-column layout to stable 2-column layout.
- Prevented fields from overflowing outside the form.
- Made labels smaller and consistent.
- Made helper text smaller.
- Made section headers smaller and cleaner.
- Fixed checkbox alignment.
- Kept long text areas full-width.
- Preserved all existing Clients.jsx logic.
- Modified CSS only.

## Safety

Clients.jsx modified: NO
App.jsx modified: NO
Backend modified: NO
Database modified: NO
Files deleted: NO
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT FORM LAYOUT STABILIZER COMPLETE"
Write-Host ""
Write-Host "Modified CSS:" -ForegroundColor Cyan
Write-Host $CssPath
Write-Host ""
Write-Host "Backup:" -ForegroundColor Cyan
Write-Host $CssBackup
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

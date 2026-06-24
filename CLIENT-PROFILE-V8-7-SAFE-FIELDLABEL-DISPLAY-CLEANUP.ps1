# ============================================================
# LITIGATION 360
# CLIENT PROFILE V8.7 SAFE FIELDLABEL DISPLAY CLEANUP
#
# Purpose:
#   Your latest scan shows two categories:
#
#   A) Legitimate JSX labels:
#      <FieldLabel required>Given Name</FieldLabel>
#      These are allowed in JSX if FieldLabel component exists.
#
#   B) Polluted text strings/placeholders:
#      "Other <FieldLabel required>Immigration / Documented Status</FieldLabel>"
#      placeholder="<FieldLabel required>Given Name</FieldLabel>"
#      "Manual title/Gender * override"
#
#   This patch safely cleans category B only and ensures FieldLabel exists.
#
# Safety:
#   - Backs up Clients.jsx and CSS
#   - Frontend only
#   - Does NOT modify App.jsx
#   - Does NOT modify backend/database/routes
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT PROFILE V8.7 SAFE CLEANUP] $Message" -ForegroundColor Cyan
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

$ClientsPath = Join-Path $ProjectRoot "frontend\src\pages\Clients.jsx"
$AppCss = Join-Path $ProjectRoot "frontend\src\App.css"
$IndexCss = Join-Path $ProjectRoot "frontend\src\index.css"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (!(Test-Path -LiteralPath $ClientsPath -PathType Leaf)) {
    Fail "Could not find Clients.jsx at: $ClientsPath"
}

if (Test-Path -LiteralPath $AppCss -PathType Leaf) {
    $CssPath = $AppCss
} elseif (Test-Path -LiteralPath $IndexCss -PathType Leaf) {
    $CssPath = $IndexCss
} else {
    Fail "Could not find App.css or index.css in frontend\src"
}

Write-Step "Target Clients.jsx:"
Write-Host $ClientsPath -ForegroundColor Green

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_7_SAFE_CLEANUP_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_7_SAFE_CLEANUP_$Stamp"

Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

$Content = [System.IO.File]::ReadAllText($ClientsPath)
$Original = $Content

# ------------------------------------------------------------
# 1. Ensure FieldLabel component exists if JSX labels remain.
# ------------------------------------------------------------

$HasFieldLabelComponent =
    ($Content -match 'function\s+FieldLabel\s*\(') -or
    ($Content -match 'const\s+FieldLabel\s*=')

if (-not $HasFieldLabelComponent -and $Content -match '<FieldLabel') {
    $InsertAfter = 'const PRIMARY_LOCAL_STORAGE_KEY = LOCAL_STORAGE_KEYS[0];'

    $FieldLabelComponent = @'

function FieldLabel({ children, required = false }) {
  return (
    <span className="field-label-inline">
      <span>{children}</span>
      {required ? <span className="field-required"> *</span> : null}
    </span>
  );
}

'@

    if ($Content.Contains($InsertAfter)) {
        $Content = $Content.Replace($InsertAfter, $InsertAfter + $FieldLabelComponent)
        Write-Pass "Inserted missing FieldLabel component."
    } else {
        Write-Warn "Could not find insertion anchor for FieldLabel component."
    }
} else {
    Write-Warn "FieldLabel component already exists or no FieldLabel JSX remains."
}

# ------------------------------------------------------------
# 2. Clean FieldLabel pollution inside strings and placeholders.
#    These are NOT JSX labels and should be plain text.
# ------------------------------------------------------------

$TextReplacements = @{
    '"Other <FieldLabel required>Immigration / Documented Status</FieldLabel>"' = '"Other Immigration / Documented Status"'
    '"Other <FieldLabel>Immigration / Documented Status</FieldLabel>"' = '"Other Immigration / Documented Status"'

    '"<FieldLabel required>Identity Card Colour / Document Class</FieldLabel>"' = '"Identity Card Colour / Document Class"'
    '"<FieldLabel>Identity Card Colour / Document Class</FieldLabel>"' = '"Identity Card Colour / Document Class"'

    '"<FieldLabel required>Immigration / Documented Status</FieldLabel>"' = '"Immigration / Documented Status"'
    '"<FieldLabel>Immigration / Documented Status</FieldLabel>"' = '"Immigration / Documented Status"'

    'placeholder="<FieldLabel required>Given Name</FieldLabel>"' = 'placeholder="Given name"'
    'placeholder="<FieldLabel>Given Name</FieldLabel>"' = 'placeholder="Given name"'

    'placeholder="Record verified reason for title/Gender * override."' = 'placeholder="Record verified reason for title/gender override."'
    'Manual title/Gender * override' = 'Manual title/gender override'
    'title/Gender * override' = 'title/gender override'
}

foreach ($key in $TextReplacements.Keys) {
    $Content = $Content.Replace($key, $TextReplacements[$key])
}

# ------------------------------------------------------------
# 3. Clean remaining FieldLabel tags that are definitely inside quoted strings.
#    This does not remove real JSX labels that are not quoted.
# ------------------------------------------------------------

$Content = [regex]::Replace($Content, '"([^"]*)<FieldLabel required>([^<]+)</FieldLabel>([^"]*)"', {
    param($m)
    return '"' + $m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value + '"'
})

$Content = [regex]::Replace($Content, '"([^"]*)<FieldLabel>([^<]+)</FieldLabel>([^"]*)"', {
    param($m)
    return '"' + $m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value + '"'
})

# ------------------------------------------------------------
# 4. Normalize label text damage but keep JSX component usage.
# ------------------------------------------------------------

$Content = $Content.Replace('Gender * override', 'gender override')
$Content = $Content.Replace('title/Gender', 'title/gender')
$Content = $Content.Replace('title/gender * override', 'title/gender override')

# ------------------------------------------------------------
# 5. Write Clients.jsx
# ------------------------------------------------------------

if ($Content -eq $Original) {
    Write-Warn "No Clients.jsx text changed. File may already be clean."
} else {
    [System.IO.File]::WriteAllText($ClientsPath, $Content, (New-Object System.Text.UTF8Encoding($false)))
    Write-Pass "Clients.jsx safe FieldLabel display cleanup applied."
}

# ------------------------------------------------------------
# 6. CSS for one-line label + star
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT PROFILE V8_7 FIELDLABEL SAFE CLEANUP START */"
$MarkerEnd = "/* L360 CLIENT PROFILE V8_7 FIELDLABEL SAFE CLEANUP END */"

$CssBlock = @'

/* L360 CLIENT PROFILE V8_7 FIELDLABEL SAFE CLEANUP START */

.client-form-v6 .field-label-inline,
.field-label-inline {
  display: inline-flex !important;
  align-items: baseline !important;
  gap: 3px !important;
  white-space: nowrap !important;
  line-height: 1.2 !important;
}

.client-form-v6 .field-required,
.field-required {
  display: inline !important;
  margin-left: 2px !important;
  line-height: 1 !important;
  vertical-align: baseline !important;
}

.client-form-v6 label {
  overflow-wrap: normal !important;
  word-break: normal !important;
}

.client-form-v6 input,
.client-form-v6 select {
  height: 38px !important;
  min-height: 38px !important;
  white-space: nowrap !important;
}

/* L360 CLIENT PROFILE V8_7 FIELDLABEL SAFE CLEANUP END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "CSS FieldLabel one-line guardrails applied."

# ------------------------------------------------------------
# 7. Verification report
# ------------------------------------------------------------

$BadStringScan = Select-String -Path $ClientsPath -Pattern `
    '"[^"]*<FieldLabel',`
    'placeholder="<FieldLabel',`
    'Gender \* override',`
    'title/Gender \* override',`
    'const\s+<FieldLabel',`
    '</FieldLabel>_' `
    -AllMatches | ForEach-Object {
        "$($_.LineNumber): $($_.Line)"
    }

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-PROFILE-V8-7-SAFE-FIELDLABEL-CLEANUP-REPORT-$Stamp.md"

$Report = @"
# Client Profile V8.7 Safe FieldLabel Cleanup Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified Files

- $ClientsPath
- $CssPath

## Backups

- $ClientsBackup
- $CssBackup

## What Was Cleaned

- FieldLabel text inside option strings.
- FieldLabel text inside validation message labels.
- FieldLabel text inside placeholders.
- Manual title/Gender * override text.
- Added FieldLabel component if missing.
- Added CSS to keep required stars on the same line.

## Important

Visible JSX labels such as:

<FieldLabel required>Given Name</FieldLabel>

are allowed and intentionally kept if FieldLabel component exists.

## Remaining Bad String / Const Poison Scan

$($BadStringScan -join "`r`n")

If the section above is blank, the known bad string/const patterns were not found.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Routes modified: NO
Files deleted: NO
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT PROFILE V8.7 SAFE FIELDLABEL CLEANUP COMPLETE"
Write-Host ""
Write-Host "Modified Clients.jsx:" -ForegroundColor Cyan
Write-Host $ClientsPath
Write-Host ""
Write-Host "Modified CSS:" -ForegroundColor Cyan
Write-Host $CssPath
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Backups:" -ForegroundColor Cyan
Write-Host $ClientsBackup
Write-Host $CssBackup
Write-Host ""
Write-Host "Recommended verification:" -ForegroundColor Yellow
Write-Host 'Select-String -Path ".\frontend\src\pages\Clients.jsx" -Pattern ''"[^"]*<FieldLabel'',''placeholder="<FieldLabel'',''Gender \* override'',''title/Gender \* override'',''const\s+<FieldLabel'',''</FieldLabel>_'''
Write-Host ""
Write-Host "Then restart frontend:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"

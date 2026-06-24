# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5A CLIENTS JSX PARSE FIX
#
# PURPOSE:
#   Fix the Vite parse error in:
#   frontend\src\pages\Clients.jsx
#
# ERROR:
#   const <FieldLabel required>Country</FieldLabel>_OPTIONS = [
#
# SAFE FIX:
#   Replace that invalid token with:
#   const COUNTRY_OPTIONS = [
#
# SAFE MODE:
#   - Backs up Clients.jsx before modifying
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
    Write-Host "[PHASE 12.0N-R5A] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
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

$ClientsPath = Join-Path $ProjectRoot "frontend\src\pages\Clients.jsx"
$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"

$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5A-$RunStamp"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $RollbackRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. Preflight
# ------------------------------------------------------------
Write-Step "Checking Clients.jsx..."

if (!(Test-Path -LiteralPath $ClientsPath -PathType Leaf)) {
    $Report = @"
# PHASE 12.0N-R5A CLIENTS JSX PARSE FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Result

FAILED - Clients.jsx not found.

Expected:
$ClientsPath

## Safety

No file was modified.
No database was modified.
No production feature was unlocked.
No Phase 11 work was started.
"@

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5A-CLIENTS-JSX-PARSE-FIX-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5A"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Capture before context
# ------------------------------------------------------------
$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)
$BeforeContextPath = Join-Path $RollbackRoot "CLIENTS-BEFORE-LINE-CONTEXT.txt"

$Lines = $BeforeContent -split "`r?`n"
$ContextLines = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $Lines.Count; $i++) {
    $LineNumber = $i + 1
    if ($LineNumber -ge 245 -and $LineNumber -le 270) {
        $ContextLines.Add(("{0,4}: {1}" -f $LineNumber, $Lines[$i])) | Out-Null
    }
}

Save-Text -Path $BeforeContextPath -Content ($ContextLines -join "`r`n")

# ------------------------------------------------------------
# 5. Apply exact safe fix
# ------------------------------------------------------------
Write-Step "Applying exact parse fix..."

$FixedContent = $BeforeContent

$ExactBad = 'const <FieldLabel required>Country</FieldLabel>_OPTIONS = ['
$ExactGood = 'const COUNTRY_OPTIONS = ['

$HadExactBad = $FixedContent.Contains($ExactBad)

if ($HadExactBad) {
    $FixedContent = $FixedContent.Replace($ExactBad, $ExactGood)
}
else {
    # Slightly more flexible fallback, still only fixes invalid const <FieldLabel...>Country...</FieldLabel>_OPTIONS.
    $Pattern = 'const\s+<FieldLabel\s+required>\s*Country\s*</FieldLabel>_OPTIONS\s*=\s*\['
    if ($FixedContent -match $Pattern) {
        $FixedContent = [regex]::Replace($FixedContent, $Pattern, 'const COUNTRY_OPTIONS = [', 1)
        $HadExactBad = $true
    }
}

$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 6. Scan for remaining similar broken patterns
# ------------------------------------------------------------
$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)

$RemainingBadMatches = @()
try {
    $RemainingBadMatches = [regex]::Matches($AfterContent, 'const\s+<FieldLabel[^>]*>[^<]+</FieldLabel>_OPTIONS')
}
catch {
    $RemainingBadMatches = @()
}

$AfterContextPath = Join-Path $RollbackRoot "CLIENTS-AFTER-LINE-CONTEXT.txt"
$AfterLines = $AfterContent -split "`r?`n"
$AfterContextLines = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $AfterLines.Count; $i++) {
    $LineNumber = $i + 1
    if ($LineNumber -ge 245 -and $LineNumber -le 270) {
        $AfterContextLines.Add(("{0,4}: {1}" -f $LineNumber, $AfterLines[$i])) | Out-Null
    }
}

Save-Text -Path $AfterContextPath -Content ($AfterContextLines -join "`r`n")

# ------------------------------------------------------------
# 7. Rollback guide and report
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5A ROLLBACK GUIDE

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Restore Clients.jsx

Copy this backup:

$BackupPath

Back to:

$ClientsPath

PowerShell command:

Copy-Item -LiteralPath "$BackupPath" -Destination "$ClientsPath" -Force

## Note

This rollback only affects Clients.jsx.
No database or backend rollback is needed.
"@

Save-Text -Path (Join-Path $RollbackRoot "ROLLBACK-GUIDE.md") -Content $RollbackGuide

$Report = @"
# PHASE 12.0N-R5A CLIENTS JSX PARSE FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Error Addressed

Vite parse error in:

frontend\src\pages\Clients.jsx

Bad line reported:

const <FieldLabel required>Country</FieldLabel>_OPTIONS = [

Safe replacement:

const COUNTRY_OPTIONS = [

## Safety Confirmation

Clients.jsx was backed up before modification.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Fix Result

Bad exact pattern found:
$HadExactBad

File modified:
$Modified

Remaining similar broken FieldLabel const patterns:
$(@($RemainingBadMatches).Count)

## Backup Folder

$RollbackRoot

## Context Files

Before context:
$BeforeContextPath

After context:
$AfterContextPath

## Next Action

Restart or refresh frontend:

cd "$ProjectRoot\frontend"
npm run dev

Then open:

http://localhost:5173/clients

If Vite shows another parse error, paste the new error.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5A-CLIENTS-JSX-PARSE-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5A CLIENTS JSX PARSE FIX COMPLETE"
}
else {
    Write-Warn "No modification made. The exact bad pattern was not found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5A-CLIENTS-JSX-PARSE-FIX-REPORT.md"'
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

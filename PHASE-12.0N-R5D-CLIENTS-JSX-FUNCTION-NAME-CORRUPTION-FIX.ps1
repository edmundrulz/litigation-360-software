# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5D CLIENTS JSX FUNCTION NAME CORRUPTION FIX
#
# PURPOSE:
#   Fix the Vite parse error in:
#   frontend\src\pages\Clients.jsx
#
# LATEST ERROR:
#   function deriveGender *FromIdentification(value, kind) {
#
# SAFE FIX:
#   function deriveGenderFromIdentification(value, kind) {
#
# SAFE MODE:
#   - Backs up Clients.jsx before modifying
#   - Only modifies frontend\src\pages\Clients.jsx
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
    Write-Host "[PHASE 12.0N-R5D] $Message" -ForegroundColor Cyan
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

function Get-LineContext {
    param(
        [string]$Content,
        [int]$StartLine,
        [int]$EndLine
    )

    $Lines = $Content -split "`r?`n"
    $Rows = New-Object System.Collections.Generic.List[string]

    for ($n = $StartLine; $n -le $EndLine; $n++) {
        if ($n -ge 1 -and $n -le $Lines.Count) {
            $Rows.Add(("{0,4}: {1}" -f $n, $Lines[$n - 1])) | Out-Null
        }
    }

    return ($Rows -join "`r`n")
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5D-$RunStamp"

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
# PHASE 12.0N-R5D CLIENTS JSX FUNCTION NAME CORRUPTION FIX REPORT

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

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5D-CLIENTS-JSX-FUNCTION-NAME-CORRUPTION-FIX-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5D"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Read and save current context
# ------------------------------------------------------------
Write-Step "Reading current line context..."

$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-630-670-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 630 -EndLine 670)

# ------------------------------------------------------------
# 5. Scan before
# ------------------------------------------------------------
Write-Step "Scanning function-name corruption..."

$FunctionStarPattern = '\bfunction\s+([A-Za-z_$][A-Za-z0-9_$]*)\s+\*\s*([A-Za-z_$][A-Za-z0-9_$]*)\s*\('
$BeforeMatches = [regex]::Matches($BeforeContent, $FunctionStarPattern)

$BeforeRows = @()

foreach ($Match in $BeforeMatches) {
    $Replacement = "function $($Match.Groups[1].Value)$($Match.Groups[2].Value)("

    $LineNumber = 1
    try {
        if ($Match.Index -gt 0) {
            $LineNumber = ($BeforeContent.Substring(0, $Match.Index).Split("`n")).Count
        }
    }
    catch {
        $LineNumber = 0
    }

    $BeforeRows += [PSCustomObject]@{
        Line = $LineNumber
        Original = $Match.Value
        Replacement = $Replacement
    }
}

$BeforeRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5D-FUNCTION-STAR-MATCHES-BEFORE.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. Apply exact + general fix
# ------------------------------------------------------------
Write-Step "Applying function-name corruption fix..."

$FixedContent = $BeforeContent

# Exact direct replacement first.
$ExactBad = 'function deriveGender *FromIdentification(value, kind) {'
$ExactGood = 'function deriveGenderFromIdentification(value, kind) {'
$ExactCount = ([regex]::Matches($FixedContent, [regex]::Escape($ExactBad))).Count

if ($ExactCount -gt 0) {
    $FixedContent = $FixedContent.Replace($ExactBad, $ExactGood)
}

# General safe replacement for function Name *Suffix(
$GeneralCountBefore = ([regex]::Matches($FixedContent, $FunctionStarPattern)).Count
$FixedContent = [regex]::Replace($FixedContent, $FunctionStarPattern, {
    param($m)
    return "function $($m.Groups[1].Value)$($m.Groups[2].Value)("
})
$GeneralCountAfter = ([regex]::Matches($FixedContent, $FunctionStarPattern)).Count

$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 7. Scan after
# ------------------------------------------------------------
Write-Step "Scanning after fix..."

$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-630-670-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 630 -EndLine 670)

$RemainingFunctionStarMatches = [regex]::Matches($AfterContent, $FunctionStarPattern)

# Broader but report-only suspicious patterns:
$SuspiciousPatterns = @(
    '\bfunction\s+[A-Za-z_$][A-Za-z0-9_$]*\s+\*',
    '\bconst\s+<',
    '\blet\s+<',
    '\bvar\s+<',
    '<FieldLabel\b[^>]*>\s*[A-Za-z0-9 ]+\s*</FieldLabel>\s*_[A-Za-z0-9_]+'
)

$SuspiciousRows = @()

foreach ($Pattern in $SuspiciousPatterns) {
    $Matches = [regex]::Matches($AfterContent, $Pattern)
    foreach ($Match in $Matches) {
        $LineNumber = 1
        try {
            if ($Match.Index -gt 0) {
                $LineNumber = ($AfterContent.Substring(0, $Match.Index).Split("`n")).Count
            }
        }
        catch {
            $LineNumber = 0
        }

        $LineText = ""
        try {
            $AllLines = $AfterContent -split "`r?`n"
            if ($LineNumber -ge 1 -and $LineNumber -le $AllLines.Count) {
                $LineText = $AllLines[$LineNumber - 1]
            }
        }
        catch {}

        $SuspiciousRows += [PSCustomObject]@{
            Pattern = $Pattern
            Line = $LineNumber
            Match = $Match.Value
            LineText = $LineText
        }
    }
}

$SuspiciousRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5D-SUSPICIOUS-SCAN-AFTER.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 8. Rollback and report
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5D ROLLBACK GUIDE

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
# PHASE 12.0N-R5D CLIENTS JSX FUNCTION NAME CORRUPTION FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Latest Error Addressed

Vite parse error in:

frontend\src\pages\Clients.jsx

Bad line:

function deriveGender *FromIdentification(value, kind) {

Safe replacement:

function deriveGenderFromIdentification(value, kind) {

## Safety Confirmation

Clients.jsx was backed up before modification.
Only Clients.jsx was modified.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Fix Result

Exact bad pattern count:
$ExactCount

General function star pattern count before:
$GeneralCountBefore

General function star pattern count after:
$GeneralCountAfter

File modified:
$Modified

Remaining function star matches after:
$(@($RemainingFunctionStarMatches).Count)

Suspicious scan rows after:
$(@($SuspiciousRows).Count)

## Backup Folder

$RollbackRoot

## Files Created

- $RollbackRoot\CLIENTS-LINES-630-670-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-630-670-AFTER.txt
- $RollbackRoot\PHASE-12.0N-R5D-FUNCTION-STAR-MATCHES-BEFORE.csv
- $RollbackRoot\PHASE-12.0N-R5D-SUSPICIOUS-SCAN-AFTER.csv
- $RollbackRoot\ROLLBACK-GUIDE.md

## Next Action

Restart or refresh frontend:

cd "$ProjectRoot\frontend"
npm run dev

Then open:

http://localhost:5173/clients

If Vite shows another parse error, paste the new error.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5D-CLIENTS-JSX-FUNCTION-NAME-CORRUPTION-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5D CLIENTS JSX FUNCTION NAME CORRUPTION FIX COMPLETE"
}
else {
    Write-Warn "No modification made. The exact/general bad pattern was not found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5D-CLIENTS-JSX-FUNCTION-NAME-CORRUPTION-FIX-REPORT.md"'
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5B CLIENTS JSX FIELDLABEL CORRUPTION SWEEP
#
# PURPOSE:
#   Fix all broken JavaScript constants in:
#   frontend\src\pages\Clients.jsx
#
# KNOWN ERRORS:
#   const <FieldLabel required>Country</FieldLabel>_OPTIONS = [
#   const <FieldLabel required>Country</FieldLabel>_TO_CONTINENT = {
#
# SAFE SWEEP:
#   Converts patterns like:
#   const <FieldLabel required>Country</FieldLabel>_OPTIONS =
#
#   Into:
#   const COUNTRY_OPTIONS =
#
#   And:
#   const <FieldLabel required>Country</FieldLabel>_TO_CONTINENT =
#
#   Into:
#   const COUNTRY_TO_CONTINENT =
#
# SAFE MODE:
#   - Backs up Clients.jsx before modifying
#   - Modifies only frontend\src\pages\Clients.jsx
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
    Write-Host "[PHASE 12.0N-R5B] $Message" -ForegroundColor Cyan
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

function Sanitize-Const-Name {
    param([string]$Raw)

    $Clean = ($Raw -replace '[^A-Za-z0-9]+', '_').Trim('_').ToUpper()

    if ([string]::IsNullOrWhiteSpace($Clean)) {
        return "FIELD"
    }

    return $Clean
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5B-$RunStamp"

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
# PHASE 12.0N-R5B CLIENTS JSX FIELDLABEL CORRUPTION SWEEP REPORT

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

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5B-CLIENTS-JSX-FIELDLABEL-CORRUPTION-SWEEP-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5B"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Scan before
# ------------------------------------------------------------
Write-Step "Scanning corrupted FieldLabel variable declarations..."

$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)

$Pattern = '\b(const|let|var)\s+<FieldLabel(?:\s+required)?>\s*([^<]+?)\s*</FieldLabel>\s*(_[A-Za-z0-9_]+)?\s*='
$BeforeMatches = [regex]::Matches($BeforeContent, $Pattern)

$BeforeRows = @()

foreach ($Match in $BeforeMatches) {
    $Kind = $Match.Groups[1].Value
    $Label = $Match.Groups[2].Value.Trim()
    $Suffix = $Match.Groups[3].Value

    $NameBase = Sanitize-Const-Name $Label
    $SuffixClean = ""
    if (![string]::IsNullOrWhiteSpace($Suffix)) {
        $SuffixClean = $Suffix.ToUpper()
    }

    $Replacement = "$Kind $NameBase$SuffixClean ="

    $BeforeRows += [PSCustomObject]@{
        Original = $Match.Value
        DeclarationType = $Kind
        Label = $Label
        Suffix = $Suffix
        Replacement = $Replacement
    }
}

$BeforeRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5B-BEFORE-CORRUPTED-FIELDLABEL-CONSTS.csv") -NoTypeInformation -Encoding UTF8

# Save broad line context around all FieldLabel const issues
$Lines = $BeforeContent -split "`r?`n"
$Context = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $Lines.Count; $i++) {
    if ($Lines[$i] -match '<FieldLabel' -and $Lines[$i] -match '\b(const|let|var)\b') {
        $Start = [Math]::Max(0, $i - 3)
        $End = [Math]::Min($Lines.Count - 1, $i + 3)

        $Context.Add("---- Context around line $($i + 1) ----") | Out-Null
        for ($j = $Start; $j -le $End; $j++) {
            $Context.Add(("{0,4}: {1}" -f ($j + 1), $Lines[$j])) | Out-Null
        }
        $Context.Add("") | Out-Null
    }
}

Save-Text -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5B-BEFORE-CONTEXT.txt") -Content ($Context -join "`r`n")

# ------------------------------------------------------------
# 5. Apply sweep replacement
# ------------------------------------------------------------
Write-Step "Applying FieldLabel corruption sweep..."

$ReplacementEvaluator = {
    param($Match)

    $Kind = $Match.Groups[1].Value
    $Label = $Match.Groups[2].Value.Trim()
    $Suffix = $Match.Groups[3].Value

    $NameBase = Sanitize-Const-Name $Label
    $SuffixClean = ""

    if (![string]::IsNullOrWhiteSpace($Suffix)) {
        $SuffixClean = $Suffix.ToUpper()
    }

    return "$Kind $NameBase$SuffixClean ="
}

$FixedContent = [regex]::Replace($BeforeContent, $Pattern, $ReplacementEvaluator)

$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 6. Scan after
# ------------------------------------------------------------
Write-Step "Scanning after fix..."

$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)
$AfterMatches = [regex]::Matches($AfterContent, $Pattern)

$RemainingRows = @()

foreach ($Match in $AfterMatches) {
    $RemainingRows += [PSCustomObject]@{
        Remaining = $Match.Value
    }
}

$RemainingRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5B-REMAINING-CORRUPTED-FIELDLABEL-CONSTS.csv") -NoTypeInformation -Encoding UTF8

# Also scan for any remaining const < tokens
$ConstAnglePattern = '\b(const|let|var)\s+<'
$ConstAngleMatches = [regex]::Matches($AfterContent, $ConstAnglePattern)

$ConstAngleRows = @()
foreach ($Match in $ConstAngleMatches) {
    $LineNumber = 1
    try {
        if ($Match.Index -gt 0) {
            $LineNumber = ($AfterContent.Substring(0, $Match.Index).Split("`n")).Count
        }
    }
    catch {
        $LineNumber = 0
    }

    $ConstAngleRows += [PSCustomObject]@{
        Line = $LineNumber
        Match = $Match.Value
    }
}

$ConstAngleRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5B-REMAINING-CONST-ANGLE-SCAN.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 7. Create rollback guide and report
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5B ROLLBACK GUIDE

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
# PHASE 12.0N-R5B CLIENTS JSX FIELDLABEL CORRUPTION SWEEP REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Error Addressed

Vite found another corrupted JavaScript declaration in:

frontend\src\pages\Clients.jsx

Latest bad line:

const <FieldLabel required>Country</FieldLabel>_TO_CONTINENT = {

This indicates multiple corrupted FieldLabel strings were inserted into variable declarations.

## Safety Confirmation

Clients.jsx was backed up before modification.
Only Clients.jsx was modified.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Sweep Rule

Converted:

const <FieldLabel required>Country</FieldLabel>_OPTIONS =

to:

const COUNTRY_OPTIONS =

And converted:

const <FieldLabel required>Country</FieldLabel>_TO_CONTINENT =

to:

const COUNTRY_TO_CONTINENT =

The sweep also covers similar const/let/var FieldLabel variable declarations.

## Result

Corrupted FieldLabel variable declarations found before fix:
$(@($BeforeMatches).Count)

File modified:
$Modified

Remaining corrupted FieldLabel variable declarations after fix:
$(@($AfterMatches).Count)

Remaining const/let/var angle-bracket starts after fix:
$(@($ConstAngleMatches).Count)

## Backup Folder

$RollbackRoot

## Files Created

- $RollbackRoot\PHASE-12.0N-R5B-BEFORE-CORRUPTED-FIELDLABEL-CONSTS.csv
- $RollbackRoot\PHASE-12.0N-R5B-REMAINING-CORRUPTED-FIELDLABEL-CONSTS.csv
- $RollbackRoot\PHASE-12.0N-R5B-REMAINING-CONST-ANGLE-SCAN.csv
- $RollbackRoot\PHASE-12.0N-R5B-BEFORE-CONTEXT.txt
- $RollbackRoot\ROLLBACK-GUIDE.md

## Next Action

Restart or refresh frontend:

cd "$ProjectRoot\frontend"
npm run dev

Then open:

http://localhost:5173/clients

If Vite shows another parse error, paste the new error.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5B-CLIENTS-JSX-FIELDLABEL-CORRUPTION-SWEEP-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5B CLIENTS JSX FIELDLABEL CORRUPTION SWEEP COMPLETE"
}
else {
    Write-Warn "No modification made. No matching corrupted FieldLabel variable declarations were found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5B-CLIENTS-JSX-FIELDLABEL-CORRUPTION-SWEEP-REPORT.md"'
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

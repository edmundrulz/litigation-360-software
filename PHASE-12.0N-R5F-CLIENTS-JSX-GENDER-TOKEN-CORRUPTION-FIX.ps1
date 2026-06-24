# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5F CLIENTS JSX GENDER TOKEN CORRUPTION FIX
#
# PURPOSE:
#   Fix remaining invalid JavaScript token corruption in:
#   frontend\src\pages\Clients.jsx
#
# FORENSIC FINDINGS:
#   function titleMatchesGender *(title, Gender *) {
#   const Gender * = source.Gender * || deriveGenderFromIdentification(...)
#   const Gender * = form.Gender * || deriveGenderFromIdentification(...)
#   const suggestedGender * = deriveGenderFromIdentification(...)
#
# SAFE FIXES:
#   function titleMatchesGender(title, gender) {
#   const gender = source.gender || deriveGenderFromIdentification(...)
#   const gender = form.gender || deriveGenderFromIdentification(...)
#   const suggestedGender = deriveGenderFromIdentification(...)
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
    Write-Host "[PHASE 12.0N-R5F] $Message" -ForegroundColor Cyan
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

function Count-Regex {
    param(
        [string]$Content,
        [string]$Pattern
    )

    return ([regex]::Matches($Content, $Pattern)).Count
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5F-$RunStamp"

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
# PHASE 12.0N-R5F CLIENTS JSX GENDER TOKEN CORRUPTION FIX REPORT

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

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5F-CLIENTS-JSX-GENDER-TOKEN-CORRUPTION-FIX-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5F"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Read and save context
# ------------------------------------------------------------
Write-Step "Reading current Clients.jsx..."

$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-850-885-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 850 -EndLine 885)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1080-1110-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1080 -EndLine 1110)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1250-1280-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1250 -EndLine 1280)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1490-1520-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1490 -EndLine 1520)

# ------------------------------------------------------------
# 5. Count before
# ------------------------------------------------------------
$BeforeRows = @()

$Patterns = @()
$Patterns += [PSCustomObject]@{ Name="titleMatchesGender star signature"; Pattern='function\s+titleMatchesGender\s*\*\s*\(\s*title\s*,\s*Gender\s*\*\s*\)' }
$Patterns += [PSCustomObject]@{ Name="const Gender star"; Pattern='\bconst\s+Gender\s*\*\s*=' }
$Patterns += [PSCustomObject]@{ Name="source Gender star property"; Pattern='source\.Gender\s*\*' }
$Patterns += [PSCustomObject]@{ Name="form Gender star property"; Pattern='form\.Gender\s*\*' }
$Patterns += [PSCustomObject]@{ Name="suggestedGender star"; Pattern='\bsuggestedGender\s*\*' }
$Patterns += [PSCustomObject]@{ Name="parameter Gender star"; Pattern='\(\s*title\s*,\s*Gender\s*\*\s*\)' }
$Patterns += [PSCustomObject]@{ Name="generic Gender star token"; Pattern='\bGender\s+\*' }

foreach ($Item in $Patterns) {
    $Matches = [regex]::Matches($BeforeContent, $Item.Pattern)
    foreach ($Match in $Matches) {
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
            PatternName = $Item.Name
            Line = $LineNumber
            Match = $Match.Value
        }
    }
}

$BeforeRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5F-GENDER-CORRUPTION-BEFORE.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. Apply focused fixes
# ------------------------------------------------------------
Write-Step "Applying focused Gender token fixes..."

$FixedContent = $BeforeContent

# Exact full-line style fixes first.
$FixedContent = $FixedContent -replace 'function\s+titleMatchesGender\s*\*\s*\(\s*title\s*,\s*Gender\s*\*\s*\)', 'function titleMatchesGender(title, gender)'

# Known corrupted const lines/properties.
$FixedContent = $FixedContent -replace '\bconst\s+Gender\s*\*\s*=\s*source\.Gender\s*\*', 'const gender = source.gender'
$FixedContent = $FixedContent -replace '\bconst\s+Gender\s*\*\s*=\s*form\.Gender\s*\*', 'const gender = form.gender'

# Any remaining exact const Gender * = should become const gender =
$FixedContent = $FixedContent -replace '\bconst\s+Gender\s*\*\s*=', 'const gender ='

# Any remaining source/form property Gender * should become lower camel gender.
$FixedContent = $FixedContent -replace '\bsource\.Gender\s*\*', 'source.gender'
$FixedContent = $FixedContent -replace '\bform\.Gender\s*\*', 'form.gender'

# suggestedGender * should simply lose the star.
$FixedContent = $FixedContent -replace '\bsuggestedGender\s*\*', 'suggestedGender'

# Parameter Gender * should become gender where this exact function context exists.
$FixedContent = $FixedContent -replace '\(\s*title\s*,\s*Gender\s*\*\s*\)', '(title, gender)'

$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 7. Scan after
# ------------------------------------------------------------
Write-Step "Scanning after Gender token fix..."

$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-850-885-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 850 -EndLine 885)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1080-1110-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1080 -EndLine 1110)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1250-1280-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1250 -EndLine 1280)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1490-1520-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1490 -EndLine 1520)

$AfterRows = @()

foreach ($Item in $Patterns) {
    $Matches = [regex]::Matches($AfterContent, $Item.Pattern)
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

        $AfterRows += [PSCustomObject]@{
            PatternName = $Item.Name
            Line = $LineNumber
            Match = $Match.Value
        }
    }
}

$AfterRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5F-GENDER-CORRUPTION-AFTER.csv") -NoTypeInformation -Encoding UTF8

# Broader parse-danger scan.
$DangerPatterns = @()
$DangerPatterns += [PSCustomObject]@{ Name="const/let/var angle"; Pattern='\b(const|let|var)\s+<' }
$DangerPatterns += [PSCustomObject]@{ Name="function star before paren"; Pattern='function\s+[^\r\n(]*\*[^\r\n(]*\(' }
$DangerPatterns += [PSCustomObject]@{ Name="identifier star before equals"; Pattern='\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s*=' }
$DangerPatterns += [PSCustomObject]@{ Name="dot property star"; Pattern='\.[A-Za-z_$][A-Za-z0-9_$]*\s+\*' }

$DangerRows = @()

foreach ($Item in $DangerPatterns) {
    $Matches = [regex]::Matches($AfterContent, $Item.Pattern)
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

        $DangerRows += [PSCustomObject]@{
            PatternName = $Item.Name
            Line = $LineNumber
            Match = $Match.Value
            LineText = $LineText
        }
    }
}

$DangerRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5F-BROAD-PARSE-DANGER-SCAN-AFTER.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 8. Rollback and report
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5F ROLLBACK GUIDE

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
# PHASE 12.0N-R5F CLIENTS JSX GENDER TOKEN CORRUPTION FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Error Addressed

R5E forensic scan found active Gender-related syntax corruption in:

frontend\src\pages\Clients.jsx

Examples found:

function titleMatchesGender *(title, Gender *) {
const Gender * = source.Gender * || deriveGenderFromIdentification(...)
const Gender * = form.Gender * || deriveGenderFromIdentification(...)
const suggestedGender * = deriveGenderFromIdentification(...)

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

Gender corruption rows before:
$(@($BeforeRows).Count)

File modified:
$Modified

Gender corruption rows after:
$(@($AfterRows).Count)

Broad parse-danger rows after:
$(@($DangerRows).Count)

## Backup Folder

$RollbackRoot

## Files Created

- $RollbackRoot\PHASE-12.0N-R5F-GENDER-CORRUPTION-BEFORE.csv
- $RollbackRoot\PHASE-12.0N-R5F-GENDER-CORRUPTION-AFTER.csv
- $RollbackRoot\PHASE-12.0N-R5F-BROAD-PARSE-DANGER-SCAN-AFTER.csv
- $RollbackRoot\CLIENTS-LINES-850-885-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-850-885-AFTER.txt
- $RollbackRoot\CLIENTS-LINES-1080-1110-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-1080-1110-AFTER.txt
- $RollbackRoot\CLIENTS-LINES-1250-1280-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-1250-1280-AFTER.txt
- $RollbackRoot\CLIENTS-LINES-1490-1520-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-1490-1520-AFTER.txt
- $RollbackRoot\ROLLBACK-GUIDE.md

## Next Action

Stop frontend dev server with Ctrl+C, then restart:

cd "$ProjectRoot\frontend"
npm run dev

Then open:

http://localhost:5173/clients

If Vite shows another parse error, paste the new error.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5F-CLIENTS-JSX-GENDER-TOKEN-CORRUPTION-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5F CLIENTS JSX GENDER TOKEN CORRUPTION FIX COMPLETE"
}
else {
    Write-Warn "No modification made. Matching Gender corruptions were not found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5F-CLIENTS-JSX-GENDER-TOKEN-CORRUPTION-FIX-REPORT.md"'
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

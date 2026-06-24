# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5H CLIENTS JSX REQUIRED MARKER FIX
#
# PURPOSE:
#   Fix the latest Vite parse error in:
#   frontend\src\pages\Clients.jsx
#
# LATEST ERROR:
#   {required && *}
#
# SAFE FIX:
#   {required && <span className="leos-required-marker">*</span>}
#
# WHY:
#   A raw * cannot appear there as a JSX expression.
#   It must be wrapped as JSX text inside an element.
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
    Write-Host "[PHASE 12.0N-R5H] $Message" -ForegroundColor Cyan
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

function Get-Matches-As-Rows {
    param(
        [string]$Content,
        [array]$Patterns
    )

    $Rows = @()
    $AllLines = $Content -split "`r?`n"

    foreach ($Item in $Patterns) {
        $Matches = [regex]::Matches($Content, $Item.Pattern)

        foreach ($Match in $Matches) {
            $LineNumber = 1

            try {
                if ($Match.Index -gt 0) {
                    $LineNumber = ($Content.Substring(0, $Match.Index).Split("`n")).Count
                }
            }
            catch {
                $LineNumber = 0
            }

            $LineText = ""
            if ($LineNumber -ge 1 -and $LineNumber -le $AllLines.Count) {
                $LineText = $AllLines[$LineNumber - 1]
            }

            $Rows += [PSCustomObject]@{
                PatternName = $Item.Name
                Line = $LineNumber
                Match = $Match.Value
                LineText = $LineText
            }
        }
    }

    return @($Rows)
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5H-$RunStamp"

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
# PHASE 12.0N-R5H CLIENTS JSX REQUIRED MARKER FIX REPORT

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

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5H-CLIENTS-JSX-REQUIRED-MARKER-FIX-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5H"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Read and scan before
# ------------------------------------------------------------
Write-Step "Reading and scanning current Clients.jsx..."

$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1330-1360-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1330 -EndLine 1360)

$DangerPatterns = @()
$DangerPatterns += [PSCustomObject]@{ Name="required raw star JSX"; Pattern='\{\s*required\s*&&\s*\*\s*\}' }
$DangerPatterns += [PSCustomObject]@{ Name="generic JSX && raw star"; Pattern='\{\s*[A-Za-z_$][A-Za-z0-9_$]*\s*&&\s*\*\s*\}' }
$DangerPatterns += [PSCustomObject]@{ Name="const/let/var angle"; Pattern='\b(const|let|var)\s+<' }
$DangerPatterns += [PSCustomObject]@{ Name="function star before paren"; Pattern='function\s+[^\r\n(]*\*[^\r\n(]*\(' }
$DangerPatterns += [PSCustomObject]@{ Name="identifier star before equals"; Pattern='\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s*=' }
$DangerPatterns += [PSCustomObject]@{ Name="dot property star"; Pattern='\.[A-Za-z_$][A-Za-z0-9_$]*\s+\*' }

$BeforeRows = Get-Matches-As-Rows -Content $BeforeContent -Patterns $DangerPatterns
$BeforeRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5H-DANGER-SCAN-BEFORE.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. Apply targeted JSX required marker fix
# ------------------------------------------------------------
Write-Step "Applying required marker JSX fix..."

$FixedContent = $BeforeContent

# Exact required-field marker fix.
$FixedContent = [regex]::Replace(
    $FixedContent,
    '\{\s*required\s*&&\s*\*\s*\}',
    '{required && <span className="leos-required-marker">*</span>}'
)

# Any other JSX boolean && raw star pattern becomes a safe span too.
# Example: {isRequired && *} -> {isRequired && <span className="leos-required-marker">*</span>}
$FixedContent = [regex]::Replace(
    $FixedContent,
    '\{\s*([A-Za-z_$][A-Za-z0-9_$]*)\s*&&\s*\*\s*\}',
    {
        param($m)
        return "{$($m.Groups[1].Value) && <span className=`"leos-required-marker`">*</span>}"
    }
)

$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 6. Scan after
# ------------------------------------------------------------
Write-Step "Scanning after required marker fix..."

$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1330-1360-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1330 -EndLine 1360)

$AfterRows = Get-Matches-As-Rows -Content $AfterContent -Patterns $DangerPatterns
$AfterRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5H-DANGER-SCAN-AFTER.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 7. Rollback and report
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5H ROLLBACK GUIDE

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
# PHASE 12.0N-R5H CLIENTS JSX REQUIRED MARKER FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Latest Error Addressed

Vite parse error in:

frontend\src\pages\Clients.jsx

Bad JSX:

{required && *}

Safe replacement:

{required && <span className="leos-required-marker">*</span>}

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

Danger rows before:
$(@($BeforeRows).Count)

File modified:
$Modified

Danger rows after:
$(@($AfterRows).Count)

## Backup Folder

$RollbackRoot

## Files Created

- $RollbackRoot\PHASE-12.0N-R5H-DANGER-SCAN-BEFORE.csv
- $RollbackRoot\PHASE-12.0N-R5H-DANGER-SCAN-AFTER.csv
- $RollbackRoot\CLIENTS-LINES-1330-1360-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-1330-1360-AFTER.txt
- $RollbackRoot\ROLLBACK-GUIDE.md

## Next Action

Stop frontend dev server with Ctrl+C, then restart:

cd "$ProjectRoot\frontend"
npm run dev

Then open:

http://localhost:5173/clients

If Vite shows another parse error, paste the new error.

If the frontend opens successfully, report:
- Clients page opens: YES / NO
- Legal sidebar icons still visible: YES / NO
- Browser console errors: YES / NO
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5H-CLIENTS-JSX-REQUIRED-MARKER-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5H CLIENTS JSX REQUIRED MARKER FIX COMPLETE"
}
else {
    Write-Warn "No modification made. Matching required-marker corruption was not found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5H-CLIENTS-JSX-REQUIRED-MARKER-FIX-REPORT.md"'
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

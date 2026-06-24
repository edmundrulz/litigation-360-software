# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5J CLIENTS JSX DUPLICATE ISBLANK FIX
#
# PURPOSE:
#   Fix the latest Vite parse error in:
#   frontend\src\pages\Clients.jsx
#
# LATEST ERROR:
#   Identifier `isBlank` has already been declared
#
# CAUSE:
#   Inside validateClientForm(), the file contains both:
#
#   const isBlank = (value) => String(value || "").trim() === "";
#
#   and later:
#
#   function isBlank(value) {
#     return !String(value || "").trim();
#   }
#
# SAFE FIX:
#   Keep the const isBlank helper.
#   Remove only the duplicate function isBlank block.
#
# SAFE MODE:
#   - Backs up Clients.jsx before modifying
#   - Only modifies frontend\src\pages\Clients.jsx
#   - Does NOT modify database
#   - Does NOT modify backend
#   - Does NOT modify Authentication/RBAC
#   - Does NOT modify Court Dates
#   - Does NOT unlock production
#   - Does NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0N-R5J] $Message" -ForegroundColor Cyan
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5J-$RunStamp"

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
# PHASE 12.0N-R5J CLIENTS JSX DUPLICATE ISBLANK FIX REPORT

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

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5J-CLIENTS-JSX-DUPLICATE-ISBLANK-FIX-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5J"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Read and scan before
# ------------------------------------------------------------
Write-Step "Reading and scanning current Clients.jsx..."

$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1590-1675-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1590 -EndLine 1675)

$ScanPatterns = @()
$ScanPatterns += [PSCustomObject]@{ Name="const isBlank declaration"; Pattern='\bconst\s+isBlank\s*=' }
$ScanPatterns += [PSCustomObject]@{ Name="function isBlank declaration"; Pattern='\bfunction\s+isBlank\s*\(' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - const/let/var angle"; Pattern='\b(const|let|var)\s+<' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - function star before paren"; Pattern='function\s+[^\r\n(]*\*[^\r\n(]*\(' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - identifier star before equals"; Pattern='\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s*=' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - dot property star"; Pattern='\.[A-Za-z_$][A-Za-z0-9_$]*\s+\*' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - raw required star"; Pattern='\{\s*required\s*&&\s*\*\s*\}' }

$BeforeRows = Get-Matches-As-Rows -Content $BeforeContent -Patterns $ScanPatterns
$BeforeRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5J-SCAN-BEFORE.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. Apply duplicate isBlank fix
# ------------------------------------------------------------
Write-Step "Removing duplicate function isBlank block..."

$FixedContent = $BeforeContent

$DuplicateFunctionPattern = '(?ms)^\s*function\s+isBlank\s*\(\s*value\s*\)\s*\{\s*return\s+!String\s*\(\s*value\s*\|\|\s*""\s*\)\.trim\s*\(\s*\)\s*;\s*\}\s*'

$DuplicateFunctionCount = ([regex]::Matches($FixedContent, $DuplicateFunctionPattern)).Count

if ($DuplicateFunctionCount -gt 0) {
    $FixedContent = [regex]::Replace(
        $FixedContent,
        $DuplicateFunctionPattern,
        "    // isBlank is already declared above as a const helper in this validation scope.`r`n",
        1
    )
}

$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 6. Scan after
# ------------------------------------------------------------
Write-Step "Scanning after duplicate isBlank fix..."

$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1590-1675-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1590 -EndLine 1675)

$AfterRows = Get-Matches-As-Rows -Content $AfterContent -Patterns $ScanPatterns
$AfterRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5J-SCAN-AFTER.csv") -NoTypeInformation -Encoding UTF8

$ConstIsBlankAfter = ([regex]::Matches($AfterContent, '\bconst\s+isBlank\s*=')).Count
$FunctionIsBlankAfter = ([regex]::Matches($AfterContent, '\bfunction\s+isBlank\s*\(')).Count

# Broad duplicate helper scan inside file, report-only.
$DuplicateNameRows = @()
$NamesToCheck = @("isBlank", "isUnavailablePlaceholder", "requireMandatory", "validateClientForm")

foreach ($Name in $NamesToCheck) {
    $ConstCount = ([regex]::Matches($AfterContent, "\bconst\s+$Name\s*=")).Count
    $FunctionCount = ([regex]::Matches($AfterContent, "\bfunction\s+$Name\s*\(")).Count

    $DuplicateNameRows += [PSCustomObject]@{
        Name = $Name
        ConstCount = $ConstCount
        FunctionCount = $FunctionCount
        Total = $ConstCount + $FunctionCount
    }
}

$DuplicateNameRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5J-DUPLICATE-NAME-SUMMARY-AFTER.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 7. Rollback and report
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5J ROLLBACK GUIDE

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
# PHASE 12.0N-R5J CLIENTS JSX DUPLICATE ISBLANK FIX REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Latest Error Addressed

Vite parse error in:

frontend\src\pages\Clients.jsx

Error:

Identifier `isBlank` has already been declared.

Cause:

Inside validateClientForm(), the file had:

const isBlank = (value) => String(value || "").trim() === "";

and later:

function isBlank(value) {
  return !String(value || "").trim();
}

## Safe Fix

Kept the const isBlank helper.
Removed only the duplicate later function isBlank block.

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

Duplicate function isBlank blocks found:
$DuplicateFunctionCount

File modified:
$Modified

const isBlank count after:
$ConstIsBlankAfter

function isBlank count after:
$FunctionIsBlankAfter

Scan rows before:
$(@($BeforeRows).Count)

Scan rows after:
$(@($AfterRows).Count)

## Backup Folder

$RollbackRoot

## Files Created

- $RollbackRoot\Clients.jsx.BACKUP-BEFORE-12.0N-R5J
- $RollbackRoot\CLIENTS-LINES-1590-1675-BEFORE.txt
- $RollbackRoot\CLIENTS-LINES-1590-1675-AFTER.txt
- $RollbackRoot\PHASE-12.0N-R5J-SCAN-BEFORE.csv
- $RollbackRoot\PHASE-12.0N-R5J-SCAN-AFTER.csv
- $RollbackRoot\PHASE-12.0N-R5J-DUPLICATE-NAME-SUMMARY-AFTER.csv
- $RollbackRoot\ROLLBACK-GUIDE.md

## Next Action

Stop frontend dev server with Ctrl+C, then restart:

cd "$ProjectRoot\frontend"
npm run dev

Then open:

http://localhost:5173/clients

If Vite shows another parse error, paste the new error.

If the page opens, report:

- Clients page opens: YES / NO
- Add Client form structure looks restored: YES / NO
- Legal sidebar icons still visible: YES / NO
- Browser console errors: YES / NO
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5J-CLIENTS-JSX-DUPLICATE-ISBLANK-FIX-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5J CLIENTS JSX DUPLICATE ISBLANK FIX COMPLETE"
}
else {
    Write-Warn "No modification made. Duplicate function isBlank block was not found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5J-CLIENTS-JSX-DUPLICATE-ISBLANK-FIX-REPORT.md"'
Write-Host ""
Write-Host "Open after-scan:" -ForegroundColor Cyan
Write-Host "notepad `"$RollbackRoot\PHASE-12.0N-R5J-SCAN-AFTER.csv`""
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

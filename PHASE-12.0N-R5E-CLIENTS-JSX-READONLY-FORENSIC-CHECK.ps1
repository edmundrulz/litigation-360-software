# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5E CLIENTS JSX READ-ONLY FORENSIC CHECK
#
# PURPOSE:
#   Read-only verification of the current Clients.jsx file after
#   the previous Vite parse errors.
#
# WHAT THIS DOES:
#   - Does NOT modify Clients.jsx
#   - Prints line context around previous error zones
#   - Scans for remaining suspicious corruption patterns
#   - Confirms whether the Vite error is likely stale or still present
#
# SAFE MODE:
#   - READ ONLY
#   - No source modification
#   - No database modification
#   - No backend modification
#   - No production unlock
#   - No Phase 11 work
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0N-R5E] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
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
        [string[]]$Lines,
        [int]$StartLine,
        [int]$EndLine
    )

    $Rows = New-Object System.Collections.Generic.List[string]

    for ($n = $StartLine; $n -le $EndLine; $n++) {
        if ($n -ge 1 -and $n -le $Lines.Count) {
            $Rows.Add(("{0,4}: {1}" -f $n, $Lines[$n - 1])) | Out-Null
        }
    }

    return ($Rows -join "`r`n")
}

Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$ClientsPath = Join-Path $ProjectRoot "frontend\src\pages\Clients.jsx"
$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"
$AuditRoot = Join-Path $ControlRoot "feature-exploration\clients-jsx-forensic"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $AuditRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

if (!(Test-Path -LiteralPath $ClientsPath -PathType Leaf)) {
    $Report = @"
# PHASE 12.0N-R5E CLIENTS JSX READ-ONLY FORENSIC CHECK REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Result

FAILED - Clients.jsx not found.

Expected:
$ClientsPath

## Safety

Read-only.
No files modified.
"@
    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5E-CLIENTS-JSX-READONLY-FORENSIC-CHECK-REPORT.md") -Content $Report
    Write-Host "Clients.jsx not found." -ForegroundColor Red
    exit 1
}

Write-Step "Reading Clients.jsx..."

$Content = [System.IO.File]::ReadAllText($ClientsPath)
$Lines = $Content -split "`r?`n"

# Save important contexts.
$Context258 = Get-LineContext -Lines $Lines -StartLine 245 -EndLine 270
$Context326 = Get-LineContext -Lines $Lines -StartLine 315 -EndLine 335
$Context651 = Get-LineContext -Lines $Lines -StartLine 640 -EndLine 660

Save-Text -Path (Join-Path $AuditRoot "CLIENTS-LINES-245-270.txt") -Content $Context258
Save-Text -Path (Join-Path $AuditRoot "CLIENTS-LINES-315-335.txt") -Content $Context326
Save-Text -Path (Join-Path $AuditRoot "CLIENTS-LINES-640-660.txt") -Content $Context651

Write-Step "Scanning suspicious patterns..."

$Patterns = @(
    [PSCustomObject]@{ Name="const/let/var starts with JSX angle"; Pattern='\b(const|let|var)\s+<' },
    [PSCustomObject]@{ Name="FieldLabel variable suffix corruption"; Pattern='<FieldLabel\b[^>]*>\s*[A-Za-z0-9 ]+\s*</FieldLabel>\s*_[A-Za-z0-9_]+' },
    [PSCustomObject]@{ Name="function name split by star"; Pattern='\bfunction\s+[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s*[A-Za-z_$][A-Za-z0-9_$]*\s*\(' },
    [PSCustomObject]@{ Name="deriveGender suspicious"; Pattern='deriveGender\s*\*?\s*FromIdentification|deriveGenderFromIdentification' },
    [PSCustomObject]@{ Name="country constants"; Pattern='COUNTRY_OPTIONS|COUNTRY_TO_CONTINENT|<FieldLabel[^>]*>Country</FieldLabel>' },
    [PSCustomObject]@{ Name="any function line containing star before parenthesis"; Pattern='function\s+[^\r\n(]*\*[^\r\n(]*\(' }
)

$Rows = @()

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
        if ($LineNumber -ge 1 -and $LineNumber -le $Lines.Count) {
            $LineText = $Lines[$LineNumber - 1]
        }

        $Rows += [PSCustomObject]@{
            ScanName = $Item.Name
            Line = $LineNumber
            Match = $Match.Value
            LineText = $LineText
        }
    }
}

$Rows | Export-Csv -Path (Join-Path $AuditRoot "PHASE-12.0N-R5E-SUSPICIOUS-SCAN.csv") -NoTypeInformation -Encoding UTF8

# Extract exact line 651 if exists.
$Line651 = ""
if ($Lines.Count -ge 651) {
    $Line651 = $Lines[650]
}

$Line326 = ""
if ($Lines.Count -ge 326) {
    $Line326 = $Lines[325]
}

$Line258 = ""
if ($Lines.Count -ge 258) {
    $Line258 = $Lines[257]
}

$HasBadFunctionStar = ($Rows | Where-Object { $_.ScanName -eq "function name split by star" -or $_.ScanName -eq "any function line containing star before parenthesis" } | Measure-Object).Count
$HasConstAngle = ($Rows | Where-Object { $_.ScanName -eq "const/let/var starts with JSX angle" } | Measure-Object).Count
$HasFieldLabelSuffix = ($Rows | Where-Object { $_.ScanName -eq "FieldLabel variable suffix corruption" } | Measure-Object).Count

$Finding = "UNKNOWN"

if ($HasBadFunctionStar -eq 0 -and $HasConstAngle -eq 0 -and $HasFieldLabelSuffix -eq 0) {
    $Finding = "NO ACTIVE KNOWN PARSE CORRUPTION FOUND - VITE ERROR MAY BE STALE OR NEXT ERROR IS DIFFERENT"
}
else {
    $Finding = "ACTIVE SUSPICIOUS CORRUPTION STILL FOUND - REVIEW SCAN CSV"
}

$Report = @"
# PHASE 12.0N-R5E CLIENTS JSX READ-ONLY FORENSIC CHECK REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

File Checked:
$ClientsPath

## Safety Confirmation

Read-only check.
No source code was modified.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Finding

$Finding

## Current Key Lines

Line 258:
$Line258

Line 326:
$Line326

Line 651:
$Line651

## Suspicious Scan Summary

Total suspicious scan rows:
$(@($Rows).Count)

Const/let/var angle-bracket patterns:
$HasConstAngle

FieldLabel variable suffix patterns:
$HasFieldLabelSuffix

Function-name star patterns:
$HasBadFunctionStar

## Files Created

- _LEOS_CONTROL\feature-exploration\clients-jsx-forensic\CLIENTS-LINES-245-270.txt
- _LEOS_CONTROL\feature-exploration\clients-jsx-forensic\CLIENTS-LINES-315-335.txt
- _LEOS_CONTROL\feature-exploration\clients-jsx-forensic\CLIENTS-LINES-640-660.txt
- _LEOS_CONTROL\feature-exploration\clients-jsx-forensic\PHASE-12.0N-R5E-SUSPICIOUS-SCAN.csv

## Next Safe Action

1. Stop the frontend dev server with Ctrl+C.
2. Start it again:

cd "$ProjectRoot\frontend"
npm run dev

3. Open:

http://localhost:5173/clients

4. If Vite shows another error, paste the new error.
5. If Vite still shows the same error but this report shows line 651 is clean, the overlay is stale.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5E-CLIENTS-JSX-READONLY-FORENSIC-CHECK-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0N-R5E CLIENTS JSX READ-ONLY FORENSIC CHECK COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5E-CLIENTS-JSX-READONLY-FORENSIC-CHECK-REPORT.md"'
Write-Host ""
Write-Host "Open suspicious scan:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\feature-exploration\clients-jsx-forensic\PHASE-12.0N-R5E-SUSPICIOUS-SCAN.csv"'
Write-Host ""
Write-Pass "Paste the R5E report back into ChatGPT."

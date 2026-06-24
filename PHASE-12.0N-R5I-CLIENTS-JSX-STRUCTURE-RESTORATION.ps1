# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0N-R5I CLIENTS JSX STRUCTURE RESTORATION
#
# PURPOSE:
#   Restore Clients.jsx structure after corruption.
#
# THIS PHASE FIXES:
#   1. Field-name drift:
#      phonecountryCode            -> phoneCountryCode
#      backupPhonecountryCode      -> backupPhoneCountryCode
#      whatsappcountryCode         -> whatsappCountryCode
#      whatsapp2countryCode        -> whatsapp2CountryCode
#      emergencyContactcountryCode -> emergencyContactCountryCode
#      GenderSource                -> genderSource
#
#   2. Helper-name drift:
#      cleancountryCode            -> cleanCountryCode
#      isMalaysiacountryCode       -> isMalaysiaCountryCode
#      safecountry                 -> safeCountry
#
#   3. Country variable corruption:
#      const COUNTRY = source.country || "Malaysia";
#      becomes:
#      const country = source.country || "Malaysia";
#
#   4. Known parse-danger fragments:
#      const/let/var <
#      function name *
#      identifier * =
#      .property *
#      {required && *}
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
    Write-Host "[PHASE 12.0N-R5I] $Message" -ForegroundColor Cyan
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

function Apply-Literal {
    param(
        [string]$Find,
        [string]$Replace,
        [string]$Label
    )

    $Count = ([regex]::Matches($script:FixedContent, [regex]::Escape($Find))).Count

    if ($Count -gt 0) {
        $script:FixedContent = $script:FixedContent.Replace($Find, $Replace)
    }

    $script:ReplacementRows += [PSCustomObject]@{
        Type = "Literal"
        Label = $Label
        Find = $Find
        Replace = $Replace
        Count = $Count
    }
}

function Apply-Regex {
    param(
        [string]$Pattern,
        [string]$Replace,
        [string]$Label
    )

    $Count = ([regex]::Matches($script:FixedContent, $Pattern)).Count

    if ($Count -gt 0) {
        $script:FixedContent = [regex]::Replace($script:FixedContent, $Pattern, $Replace)
    }

    $script:ReplacementRows += [PSCustomObject]@{
        Type = "Regex"
        Label = $Label
        Find = $Pattern
        Replace = $Replace
        Count = $Count
    }
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
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0N-R5I-$RunStamp"

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
# PHASE 12.0N-R5I CLIENTS JSX STRUCTURE RESTORATION REPORT

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

    Save-Text -Path (Join-Path $ReportRoot "PHASE-12.0N-R5I-CLIENTS-JSX-STRUCTURE-RESTORATION-REPORT.md") -Content $Report
    Write-Fail "Clients.jsx not found."
    exit 1
}

# ------------------------------------------------------------
# 3. Backup
# ------------------------------------------------------------
Write-Step "Backing up Clients.jsx..."

$BackupPath = Join-Path $RollbackRoot "Clients.jsx.BACKUP-BEFORE-12.0N-R5I"
Copy-Item -LiteralPath $ClientsPath -Destination $BackupPath -Force

Write-Pass "Backup created:"
Write-Host $BackupPath -ForegroundColor Green

# ------------------------------------------------------------
# 4. Read and scan before
# ------------------------------------------------------------
Write-Step "Reading and scanning current Clients.jsx..."

$BeforeContent = [System.IO.File]::ReadAllText($ClientsPath)
$FixedContent = $BeforeContent
$ReplacementRows = @()

$ScanPatterns = @()
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - const/let/var angle"; Pattern='\b(const|let|var)\s+<' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - function star before paren"; Pattern='function\s+[^\r\n(]*\*[^\r\n(]*\(' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - identifier star before equals"; Pattern='\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s*=' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - dot property star"; Pattern='\.[A-Za-z_$][A-Za-z0-9_$]*\s+\*' }
$ScanPatterns += [PSCustomObject]@{ Name="parse danger - raw required star"; Pattern='\{\s*required\s*&&\s*\*\s*\}' }
$ScanPatterns += [PSCustomObject]@{ Name="structure drift - lower-case countryCode identifiers"; Pattern='\b(phonecountryCode|backupPhonecountryCode|whatsappcountryCode|whatsapp2countryCode|emergencyContactcountryCode)\b' }
$ScanPatterns += [PSCustomObject]@{ Name="structure drift - helper casing"; Pattern='\b(cleancountryCode|isMalaysiacountryCode|safecountry)\b' }
$ScanPatterns += [PSCustomObject]@{ Name="structure drift - GenderSource"; Pattern='\bGenderSource\b' }
$ScanPatterns += [PSCustomObject]@{ Name="structure drift - const COUNTRY"; Pattern='\bconst\s+COUNTRY\b' }

$BeforeRows = Get-Matches-As-Rows -Content $BeforeContent -Patterns $ScanPatterns
$BeforeRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5I-STRUCTURE-SCAN-BEFORE.csv") -NoTypeInformation -Encoding UTF8

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1-120-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1 -EndLine 120)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-630-700-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 630 -EndLine 700)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-850-930-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 850 -EndLine 930)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1070-1125-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1070 -EndLine 1125)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1480-1545-BEFORE.txt") -Content (Get-LineContext -Content $BeforeContent -StartLine 1480 -EndLine 1545)

# ------------------------------------------------------------
# 5. Restore field/function naming structure
# ------------------------------------------------------------
Write-Step "Restoring canonical Clients.jsx structure..."

# Canonical client field names.
Apply-Literal "phonecountryCode" "phoneCountryCode" "Restore phoneCountryCode casing"
Apply-Literal "backupPhonecountryCode" "backupPhoneCountryCode" "Restore backupPhoneCountryCode casing"
Apply-Literal "whatsappcountryCode" "whatsappCountryCode" "Restore whatsappCountryCode casing"
Apply-Literal "whatsapp2countryCode" "whatsapp2CountryCode" "Restore whatsapp2CountryCode casing"
Apply-Literal "emergencyContactcountryCode" "emergencyContactCountryCode" "Restore emergencyContactCountryCode casing"

# Helper names.
Apply-Literal "cleancountryCode" "cleanCountryCode" "Restore cleanCountryCode helper"
Apply-Literal "isMalaysiacountryCode" "isMalaysiaCountryCode" "Restore isMalaysiaCountryCode helper"
Apply-Literal "safecountry" "safeCountry" "Restore safeCountry local variable"

# Gender source key.
Apply-Literal "GenderSource" "genderSource" "Restore genderSource casing"

# Country variable corruption.
Apply-Regex '\bconst\s+COUNTRY\s*=\s*source\.country\s*\|\|\s*"Malaysia"\s*;' 'const country = source.country || "Malaysia";' "Restore lowercase country variable"

# Restore user-facing labels that were unintentionally lowercased.
Apply-Regex '(?m)^(\s*)gender(\s*)$' '$1Gender$2' "Restore Gender label text"
Apply-Regex '(?m)^(\s*)country(\s*)$' '$1Country$2' "Restore Country label text"
Apply-Literal "Nationality / country of Origin" "Nationality / Country of Origin" "Restore Country label phrase"

# Remaining parse-danger fixes, limited to known corruption forms.
Apply-Regex '\bfunction\s+([A-Za-z_$][A-Za-z0-9_$]*)\s+\*\s*([A-Za-z_$][A-Za-z0-9_$]*)\s*\(' 'function $1$2(' "Fix split function names"
Apply-Regex '\bfunction\s+([A-Za-z_$][A-Za-z0-9_$]*)\s+\*\s*\(' 'function $1(' "Fix function name star before paren"
Apply-Regex '\b(const|let|var)\s+([A-Za-z_$][A-Za-z0-9_$]*)\s+\*\s*=' '$1 $2 =' "Fix declaration identifier star before equals"
Apply-Regex '\b([A-Za-z_$][A-Za-z0-9_$]*)\.([A-Za-z_$][A-Za-z0-9_$]*)\s+\*' '$1.$2' "Fix property star corruption"
Apply-Regex '\{\s*required\s*&&\s*\*\s*\}' '{required && <span className="leos-required-marker">*</span>}' "Fix raw required marker"

# Compatibility fallbacks for old local-storage keys without reintroducing identifier drift.
# These use bracket notation so the canonical source remains camelCase.
Apply-Literal 'phoneCountryCode: source.phoneCountryCode || "+60 Malaysia",' 'phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",' "Add legacy fallback for phoneCountryCode"
Apply-Literal 'backupPhoneCountryCode: source.backupPhoneCountryCode || "+60 Malaysia",' 'backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",' "Add legacy fallback for backupPhoneCountryCode"
Apply-Literal 'whatsappCountryCode: source.whatsappCountryCode || source.phoneCountryCode || "+60 Malaysia",' 'whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",' "Add legacy fallback for whatsappCountryCode"
Apply-Literal 'whatsapp2CountryCode: source.whatsapp2CountryCode || "+60 Malaysia",' 'whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",' "Add legacy fallback for whatsapp2CountryCode"
Apply-Literal 'emergencyContactCountryCode: source.emergencyContactCountryCode || "+60 Malaysia",' 'emergencyContactCountryCode: source.emergencyContactCountryCode || source["emergencyContactcountryCode"] || "+60 Malaysia",' "Add legacy fallback for emergencyContactCountryCode"
Apply-Literal 'genderSource: source.genderSource || (source.gender ? "manual" : "auto"),' 'genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),' "Add legacy fallback for genderSource"

# If phone history was previously saved with uppercase CountryCode, use lower camel casing for newly generated history.
Apply-Literal "CountryCode: existing.phoneCountryCode," "countryCode: existing.phoneCountryCode," "Restore phoneHistory countryCode property"

# Clean up accidental duplicate legacy fallback if script is run twice.
Apply-Literal 'source["phonecountryCode"] || source["phonecountryCode"] ||' 'source["phonecountryCode"] ||' "Deduplicate phone legacy fallback"
Apply-Literal 'source["backupPhonecountryCode"] || source["backupPhonecountryCode"] ||' 'source["backupPhonecountryCode"] ||' "Deduplicate backup legacy fallback"
Apply-Literal 'source["whatsappcountryCode"] || source["whatsappcountryCode"] ||' 'source["whatsappcountryCode"] ||' "Deduplicate whatsapp legacy fallback"
Apply-Literal 'source["whatsapp2countryCode"] || source["whatsapp2countryCode"] ||' 'source["whatsapp2countryCode"] ||' "Deduplicate whatsapp2 legacy fallback"
Apply-Literal 'source["emergencyContactcountryCode"] || source["emergencyContactcountryCode"] ||' 'source["emergencyContactcountryCode"] ||' "Deduplicate emergency legacy fallback"
Apply-Literal 'source["GenderSource"] || source["GenderSource"] ||' 'source["GenderSource"] ||' "Deduplicate genderSource fallback"

$ReplacementRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5I-REPLACEMENT-LOG.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. Write file if changed
# ------------------------------------------------------------
$Modified = $false

if ($FixedContent -ne $BeforeContent) {
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ClientsPath, $FixedContent, $Utf8NoBom)
    $Modified = $true
}

# ------------------------------------------------------------
# 7. Scan after
# ------------------------------------------------------------
Write-Step "Scanning after structure restoration..."

$AfterContent = [System.IO.File]::ReadAllText($ClientsPath)

# We use a stricter after-scan that ignores bracket-notation legacy fallbacks.
$AfterScanPatterns = @()
$AfterScanPatterns += [PSCustomObject]@{ Name="parse danger - const/let/var angle"; Pattern='\b(const|let|var)\s+<' }
$AfterScanPatterns += [PSCustomObject]@{ Name="parse danger - function star before paren"; Pattern='function\s+[^\r\n(]*\*[^\r\n(]*\(' }
$AfterScanPatterns += [PSCustomObject]@{ Name="parse danger - identifier star before equals"; Pattern='\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s*=' }
$AfterScanPatterns += [PSCustomObject]@{ Name="parse danger - dot property star"; Pattern='\.[A-Za-z_$][A-Za-z0-9_$]*\s+\*' }
$AfterScanPatterns += [PSCustomObject]@{ Name="parse danger - raw required star"; Pattern='\{\s*required\s*&&\s*\*\s*\}' }
$AfterScanPatterns += [PSCustomObject]@{ Name="active drift - dot lower-case countryCode"; Pattern='\.(phonecountryCode|backupPhonecountryCode|whatsappcountryCode|whatsapp2countryCode|emergencyContactcountryCode)\b' }
$AfterScanPatterns += [PSCustomObject]@{ Name="active drift - helper casing"; Pattern='\b(cleancountryCode|isMalaysiacountryCode|safecountry)\b' }
$AfterScanPatterns += [PSCustomObject]@{ Name="active drift - direct GenderSource"; Pattern='(?<!\[")\bGenderSource\b(?!\"\])' }
$AfterScanPatterns += [PSCustomObject]@{ Name="active drift - const COUNTRY"; Pattern='\bconst\s+COUNTRY\b' }

$AfterRows = Get-Matches-As-Rows -Content $AfterContent -Patterns $AfterScanPatterns
$AfterRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0N-R5I-STRUCTURE-SCAN-AFTER.csv") -NoTypeInformation -Encoding UTF8

Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1-120-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1 -EndLine 120)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-630-700-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 630 -EndLine 700)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-850-930-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 850 -EndLine 930)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1070-1125-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1070 -EndLine 1125)
Save-Text -Path (Join-Path $RollbackRoot "CLIENTS-LINES-1480-1545-AFTER.txt") -Content (Get-LineContext -Content $AfterContent -StartLine 1480 -EndLine 1545)

# ------------------------------------------------------------
# 8. Optional Vite parser smoke attempt through npm build? not run automatically.
# ------------------------------------------------------------
$RollbackGuide = @"
# PHASE 12.0N-R5I ROLLBACK GUIDE

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

$ReplacementTotal = 0
foreach ($Row in $ReplacementRows) {
    $ReplacementTotal += [int]$Row.Count
}

$Report = @"
# PHASE 12.0N-R5I CLIENTS JSX STRUCTURE RESTORATION REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Purpose

Restore the Clients.jsx structure after repeated corruption events.

This phase restores the module back toward its intended camelCase client-profile structure:

- phoneCountryCode
- backupPhoneCountryCode
- whatsappCountryCode
- whatsapp2CountryCode
- emergencyContactCountryCode
- genderSource
- cleanCountryCode
- isMalaysiaCountryCode
- safeCountry
- lowercase local variable: country

## Safety Confirmation

Clients.jsx was backed up before modification.
Only Clients.jsx was modified.
No database was modified.
No backend source was modified.
No Authentication/RBAC change was made.
No Court Dates change was made.
Production unlock was NOT performed.
Phase 11 was NOT started.

## Result

Structure / danger rows before:
$(@($BeforeRows).Count)

Replacement operations applied total:
$ReplacementTotal

File modified:
$Modified

Structure / danger rows after:
$(@($AfterRows).Count)

## Backup Folder

$RollbackRoot

## Key Files Created

- $RollbackRoot\Clients.jsx.BACKUP-BEFORE-12.0N-R5I
- $RollbackRoot\PHASE-12.0N-R5I-STRUCTURE-SCAN-BEFORE.csv
- $RollbackRoot\PHASE-12.0N-R5I-STRUCTURE-SCAN-AFTER.csv
- $RollbackRoot\PHASE-12.0N-R5I-REPLACEMENT-LOG.csv
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

$ReportPath = Join-Path $ReportRoot "PHASE-12.0N-R5I-CLIENTS-JSX-STRUCTURE-RESTORATION-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
if ($Modified) {
    Write-Pass "PHASE 12.0N-R5I CLIENTS JSX STRUCTURE RESTORATION COMPLETE"
}
else {
    Write-Warn "No modification made. No matching structure corruption was found."
}
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host 'notepad "_LEOS_CONTROL\reports\PHASE-12.0N-R5I-CLIENTS-JSX-STRUCTURE-RESTORATION-REPORT.md"'
Write-Host ""
Write-Host "Open after-scan:" -ForegroundColor Cyan
Write-Host "notepad `"$RollbackRoot\PHASE-12.0N-R5I-STRUCTURE-SCAN-AFTER.csv`""
Write-Host ""
Write-Host "Restart frontend:" -ForegroundColor Cyan
Write-Host 'cd "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend"'
Write-Host "npm run dev"
Write-Host ""
Write-Pass "Paste the report and any new Vite error back into ChatGPT."

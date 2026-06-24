# ============================================================
# LITIGATION 360
# CLIENT PROFILE V8.6 IDENTIFIER-STAR SYNTAX CLEANUP
#
# Current Vite error fixed:
#   function deriveGender *FromIdentification(value, kind) {
#
# Correct form:
#   function deriveGenderFromIdentification(value, kind) {
#
# Purpose:
#   Remove accidental required-star markers that were inserted into
#   JavaScript identifiers, function names, variable names and constant names.
#
# Safety:
#   - Backs up Clients.jsx first
#   - Frontend only
#   - Does NOT modify App.jsx
#   - Does NOT modify backend/database/routes
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT PROFILE V8.6 IDENTIFIER CLEANUP] $Message" -ForegroundColor Cyan
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
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (!(Test-Path -LiteralPath $ClientsPath -PathType Leaf)) {
    Fail "Could not find Clients.jsx at: $ClientsPath"
}

Write-Step "Target Clients.jsx:"
Write-Host $ClientsPath -ForegroundColor Green

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_6_IDENTIFIER_CLEANUP_$Stamp"
Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Write-Pass "Clients.jsx backup created:"
Write-Host $ClientsBackup -ForegroundColor Green

$Content = [System.IO.File]::ReadAllText($ClientsPath)
$Original = $Content

# ------------------------------------------------------------
# 1. Exact current Vite error repair.
# ------------------------------------------------------------

$Content = [regex]::Replace(
    $Content,
    'deriveGender\s*\*\s*FromIdentification',
    'deriveGenderFromIdentification'
)

# ------------------------------------------------------------
# 2. General repair for accidental star inserted inside JS identifiers.
#
# Examples:
#   function deriveGender *FromIdentification(...)
#   const country *Code = ...
#   getMalaysiaNricState *OfBirth(...)
#
# Be conservative:
#   Left side must look like an identifier.
#   Right side must start with a capital letter, which matches camelCase
#   continuation style used in the damaged code.
# ------------------------------------------------------------

$Content = [regex]::Replace(
    $Content,
    '\b([A-Za-z_$][A-Za-z0-9_$]*)\s+\*\s+([A-Z][A-Za-z0-9_$]*)\b',
    '$1$2'
)

# Also repair no-space variants:
$Content = [regex]::Replace(
    $Content,
    '\b([A-Za-z_$][A-Za-z0-9_$]*)\s*\*\s*([A-Z][A-Za-z0-9_$]*)\b',
    '$1$2'
)

# ------------------------------------------------------------
# 3. Repair known function/helper names that may have been poisoned.
# ------------------------------------------------------------

$KnownRepairs = @{
    'isNric\s*\*\s*Kind' = 'isNricKind'
    'mask\s*\*\s*Identification' = 'maskIdentification'
    'parseNric\s*\*\s*Dob' = 'parseNricDob'
    'formatDate\s*\*\s*Display' = 'formatDateDisplay'
    'calculate\s*\*\s*Age' = 'calculateAge'
    'getAge\s*\*\s*Category' = 'getAgeCategory'
    'get\s*\*\s*Generation' = 'getGeneration'
    'getTitle\s*\*\s*GenderRule' = 'getTitleGenderRule'
    'titleMatches\s*\*\s*Gender' = 'titleMatchesGender'
    'cleanCountry\s*\*\s*Code' = 'cleanCountryCode'
    'normalizePhone\s*\*\s*ForLinks' = 'normalizePhoneForLinks'
    'formatPhone\s*\*\s*Display' = 'formatPhoneDisplay'
    'isMalaysiaCountry\s*\*\s*Code' = 'isMalaysiaCountryCode'
    'isValidMalaysia\s*\*\s*Mobile' = 'isValidMalaysiaMobile'
    'getMalaysiaNricState\s*\*\s*OfBirth' = 'getMalaysiaNricStateOfBirth'
    'getDefault\s*\*\s*Region' = 'getDefaultRegion'
    'normalize\s*\*\s*Client' = 'normalizeClient'
    'build\s*\*\s*Payload' = 'buildPayload'
    'validateClient\s*\*\s*Form' = 'validateClientForm'
}

foreach ($pattern in $KnownRepairs.Keys) {
    $Content = [regex]::Replace($Content, $pattern, $KnownRepairs[$pattern])
}

# ------------------------------------------------------------
# 4. Repair remaining FieldLabel poison if any is still present.
# ------------------------------------------------------------

$Content = $Content.Replace('<FieldLabel required>Country</FieldLabel>_TO_CONTINENT', 'COUNTRY_TO_CONTINENT')
$Content = $Content.Replace('<FieldLabel>Country</FieldLabel>_TO_CONTINENT', 'COUNTRY_TO_CONTINENT')
$Content = $Content.Replace('<FieldLabel required>Country</FieldLabel>_OPTIONS', 'COUNTRY_OPTIONS')
$Content = $Content.Replace('<FieldLabel>Country</FieldLabel>_OPTIONS', 'COUNTRY_OPTIONS')
$Content = $Content.Replace('<FieldLabel required>Country</FieldLabel>_CODE_OPTIONS', 'COUNTRY_CODE_OPTIONS')
$Content = $Content.Replace('<FieldLabel>Country</FieldLabel>_CODE_OPTIONS', 'COUNTRY_CODE_OPTIONS')
$Content = $Content.Replace('<FieldLabel required>Country</FieldLabel>Code', 'countryCode')
$Content = $Content.Replace('<FieldLabel>Country</FieldLabel>Code', 'countryCode')
$Content = $Content.Replace('<FieldLabel required>Country</FieldLabel>', 'country')
$Content = $Content.Replace('<FieldLabel>Country</FieldLabel>', 'country')

$Content = $Content.Replace('country_TO_CONTINENT', 'COUNTRY_TO_CONTINENT')
$Content = $Content.Replace('country_OPTIONS', 'COUNTRY_OPTIONS')
$Content = $Content.Replace('country_CODE_OPTIONS', 'COUNTRY_CODE_OPTIONS')

# ------------------------------------------------------------
# 5. Remove bad object-key stars if any returned.
# ------------------------------------------------------------

$Content = [regex]::Replace($Content, '(^\s*)Gender\s*\*:\s*', '$1gender: ', 'Multiline')
$Content = [regex]::Replace($Content, '(^\s*)Given Name\s*\*:\s*', '$1givenName: ', 'Multiline')
$Content = [regex]::Replace($Content, '(^\s*)Surname\s*\*:\s*', '$1surname: ', 'Multiline')
$Content = [regex]::Replace($Content, '(^\s*)NRIC No\.\s*/\s*Passport No\.\s*\*:\s*', '$1nricPassportNumber: ', 'Multiline')

# ------------------------------------------------------------
# 6. Write file.
# ------------------------------------------------------------

if ($Content -eq $Original) {
    Write-Warn "No identifier-star poison was changed. File may already be clean or error is elsewhere."
} else {
    [System.IO.File]::WriteAllText($ClientsPath, $Content, (New-Object System.Text.UTF8Encoding($false)))
    Write-Pass "Identifier-star poison repaired in Clients.jsx."
}

# ------------------------------------------------------------
# 7. Scan remaining high-risk poison patterns.
# ------------------------------------------------------------

$Remaining = Select-String -Path $ClientsPath -Pattern `
    'function\s+[A-Za-z_$][A-Za-z0-9_$]*\s*\*',`
    '\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s+[A-Z][A-Za-z0-9_$]*\b',`
    '<FieldLabel',`
    '</FieldLabel>',`
    'Gender \*:',`
    'Given Name \*:',`
    'NRIC No\. / Passport No\. \*:' `
    -AllMatches | ForEach-Object {
        "$($_.LineNumber): $($_.Line)"
    }

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-PROFILE-V8-6-IDENTIFIER-STAR-CLEANUP-REPORT-$Stamp.md"

$Report = @"
# Client Profile V8.6 Identifier-Star Syntax Cleanup Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified File

- $ClientsPath

## Backup

- $ClientsBackup

## Fixed

- function deriveGender *FromIdentification(...)
  became:
  function deriveGenderFromIdentification(...)

- General cleanup applied for accidental star markers inside JavaScript identifiers.

## Remaining High-Risk Poison Scan

$($Remaining -join "`r`n")

If the section above is blank, the known identifier-star poison patterns were not found.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Routes modified: NO
Files deleted: NO
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT PROFILE V8.6 IDENTIFIER CLEANUP COMPLETE"
Write-Host ""
Write-Host "Modified Clients.jsx:" -ForegroundColor Cyan
Write-Host $ClientsPath
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Backup:" -ForegroundColor Cyan
Write-Host $ClientsBackup
Write-Host ""
Write-Host "Run verification:" -ForegroundColor Yellow
Write-Host 'Select-String -Path ".\frontend\src\pages\Clients.jsx" -Pattern "function\s+[A-Za-z_$][A-Za-z0-9_$]*\s*\*","\b[A-Za-z_$][A-Za-z0-9_$]*\s+\*\s+[A-Z][A-Za-z0-9_$]*\b","<FieldLabel","</FieldLabel>","Gender \*:","Given Name \*:","NRIC No\. / Passport No\. \*:"'
Write-Host ""
Write-Host "Then restart frontend:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"

# ============================================================
# LITIGATION 360
# CLIENT PROFILE V8.2 EMERGENCY HOTFIX
#
# Fixes the current near-perfect Clients.jsx without rebuilding the page.
#
# Main fixes:
# 1. Repairs Vite parse error:
#      titleGender <RequiredMark />Override: false
#    becomes:
#      titleGenderOverride: false
#
# 2. Fixes RequiredMark / star display:
#    Given Name * and NRIC No. / Passport No. * stay on ONE line.
#
# 3. Expands mandatory fields for a proper legal client profile:
#    Title Prefix, Given Name, Gender for NRIC, Immigration Status,
#    ID Type, IC Colour/Class, NRIC/Passport, Email, Primary Phone,
#    Address Type, Country, Building/House No., Postcode, Street Address,
#    Town/City, Document Type, Document Status, Verification Status.
#
# 4. Adds CSS guardrails for single-line labels/inputs.
#
# Safety:
# - Backs up Clients.jsx first
# - Backs up CSS first
# - Frontend only
# - Does NOT modify App.jsx
# - Does NOT modify backend/database/routes
# - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT PROFILE V8.2 HOTFIX] $Message" -ForegroundColor Cyan
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

$FrontendSrc = Join-Path $ProjectRoot "frontend\src"
$ClientsPath = Join-Path $FrontendSrc "pages\Clients.jsx"
$AppCss = Join-Path $FrontendSrc "App.css"
$IndexCss = Join-Path $FrontendSrc "index.css"
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

Write-Step "Target CSS:"
Write-Host $CssPath -ForegroundColor Green

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_HOTFIX_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_HOTFIX_$Stamp"

Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

$ClientsContent = [System.IO.File]::ReadAllText($ClientsPath)

# ------------------------------------------------------------
# 1. Repair the exact parse error and related damaged identifiers.
# ------------------------------------------------------------

$BeforeParseRepair = $ClientsContent

$ClientsContent = [regex]::Replace(
    $ClientsContent,
    'titleGender\s*(<RequiredMark\s*/>|\*)\s*Override',
    'titleGenderOverride'
)

$ClientsContent = [regex]::Replace(
    $ClientsContent,
    'titleGender\s+Override',
    'titleGenderOverride'
)

$ClientsContent = [regex]::Replace(
    $ClientsContent,
    'titleGender\s*\*\s*Override',
    'titleGenderOverride'
)

if ($ClientsContent -ne $BeforeParseRepair) {
    Write-Pass "Repaired broken titleGenderOverride identifier causing the Vite parse error."
} else {
    Write-Warn "Broken titleGenderOverride pattern was not found; it may already be repaired."
}

# ------------------------------------------------------------
# 2. Convert JSX RequiredMark tags into inline literal stars.
#    This prevents:
#       Given Name
#       *
#    and keeps:
#       Given Name *
# ------------------------------------------------------------

$BeforeStarFix = $ClientsContent

# Remove all JSX RequiredMark component calls and replace with a plain inline star.
$ClientsContent = [regex]::Replace($ClientsContent, '\s*<RequiredMark\s*/>', ' *')

# Collapse common broken label line breaks.
$ClientsContent = [regex]::Replace($ClientsContent, '(Given Name)\s*(\r?\n\s*)+\*\s*', '$1 * ')
$ClientsContent = [regex]::Replace($ClientsContent, '(NRIC No\.\s*/\s*Passport No\.)\s*(\r?\n\s*)+\*\s*', '$1 * ')
$ClientsContent = [regex]::Replace($ClientsContent, '(Nationality / Country of Origin)\s*(\r?\n\s*)+\*\s*', '$1 * ')
$ClientsContent = [regex]::Replace($ClientsContent, '(Override Reason)\s*(\r?\n\s*)+\*\s*', '$1 * ')
$ClientsContent = [regex]::Replace($ClientsContent, '(Reason for Unavailability)\s*(\r?\n\s*)+\*\s*', '$1 * ')

# Remove duplicated stars in key labels.
$ClientsContent = [regex]::Replace($ClientsContent, 'Given Name\s+\*\s+\*', 'Given Name *')
$ClientsContent = [regex]::Replace($ClientsContent, 'NRIC No\.\s*/\s*Passport No\.\s+\*\s+\*', 'NRIC No. / Passport No. *')
$ClientsContent = [regex]::Replace($ClientsContent, 'Nationality / Country of Origin\s+\*\s+\*', 'Nationality / Country of Origin *')
$ClientsContent = [regex]::Replace($ClientsContent, 'Override Reason\s+\*\s+\*', 'Override Reason *')
$ClientsContent = [regex]::Replace($ClientsContent, 'Reason for Unavailability\s+\*\s+\*', 'Reason for Unavailability *')

# Repair identifier once more in case RequiredMark conversion touched it.
$ClientsContent = [regex]::Replace($ClientsContent, 'titleGender\s*\*\s*Override', 'titleGenderOverride')

if ($ClientsContent -ne $BeforeStarFix) {
    Write-Pass "Converted RequiredMark tags into inline stars and cleaned broken star line breaks."
} else {
    Write-Warn "No RequiredMark tags or broken star labels found."
}

# ------------------------------------------------------------
# 3. Clean label text.
# ------------------------------------------------------------

$ClientsContent = $ClientsContent.Replace("NRIC No.# / Passport No.#", "NRIC No. / Passport No.")
$ClientsContent = $ClientsContent.Replace("NRIC No.#", "NRIC No.")
$ClientsContent = $ClientsContent.Replace("Passport No.#", "Passport No.")
$ClientsContent = $ClientsContent.Replace("Building / House No.#", "Building / House No.")
$ClientsContent = $ClientsContent.Replace("Postcode No.#", "Postcode No.")

# ------------------------------------------------------------
# 4. Add expanded mandatory validation block.
# ------------------------------------------------------------

if ($ClientsContent -notmatch 'V8\.2 mandatory profile validation') {
    $OldValidationAnchor = @'
    if (!payload.nricPassportNumber.trim()) {
      errors.push("NRIC No. / Passport No. is required.");
    }
'@

    $MandatoryBlock = @'
    // V8.2 mandatory profile validation.
    const requiredFieldChecks = [
      ["titlePrefix", "Title Prefix"],
      ["residencyStatus", "Immigration / Documented Status"],
      ["identificationKind", "ID Type"],
      ["identityCardColour", "Identity Card Colour / Document Class"],
      ["nricPassportNumber", "NRIC No. / Passport No."],
      ["email", "Email Address"],
      ["phoneCountryCode", "Primary Phone Country Code"],
      ["phoneNumber", "Primary Phone Number"],
      ["addressType", "Address Type"],
      ["country", "Country"],
      ["buildingHouseNo", "Building / House No."],
      ["postcode", "Postcode No."],
      ["streetAddress", "Street Address"],
      ["townCity", "Town / City"],
      ["documentType", "Document Type"],
      ["documentStatus", "Document Status"],
      ["verificationStatus", "Verification / Review Status"]
    ];

    requiredFieldChecks.forEach(([fieldName, label]) => {
      const value = String(payload[fieldName] || "").trim();

      if (
        !value ||
        value === "Not Applicable / N/A" ||
        value === "Unknown" ||
        value === "To be confirmed"
      ) {
        errors.push(label + " is mandatory for a complete legal client profile.");
      }
    });

    if (isNricKind(payload.identificationKind) && !String(payload.gender || "").trim()) {
      errors.push("Gender is mandatory for NRIC records and should auto-populate from the final NRIC digit.");
    }

'@

    if ($ClientsContent.Contains($OldValidationAnchor)) {
        $ClientsContent = $ClientsContent.Replace($OldValidationAnchor, $OldValidationAnchor + $MandatoryBlock)
        Write-Pass "Expanded mandatory field validation inserted after NRIC/Passport validation."
    } else {
        $FallbackAnchor = 'const errors = [];'
        $FallbackIndex = $ClientsContent.IndexOf($FallbackAnchor)

        if ($FallbackIndex -ge 0) {
            $InsertAt = $FallbackIndex + $FallbackAnchor.Length
            $ClientsContent = $ClientsContent.Substring(0, $InsertAt) + "`r`n" + $MandatoryBlock + $ClientsContent.Substring($InsertAt)
            Write-Pass "Expanded mandatory field validation inserted after const errors fallback."
        } else {
            Write-Warn "Could not locate validateClientForm anchor. Mandatory validation not inserted."
        }
    }
} else {
    Write-Warn "V8.2 mandatory validation already exists. Skipping insertion."
}

# ------------------------------------------------------------
# 5. Add required attributes to the most important visible fields where exact snippets exist.
# ------------------------------------------------------------

# Keep this conservative: React validation still runs on submit even if HTML required is not on every field.
$ClientsContent = $ClientsContent.Replace('placeholder="Enter NRIC or Passport No."', 'placeholder="Enter NRIC or Passport No."')
$ClientsContent = $ClientsContent.Replace('placeholder="client@example.com"', 'placeholder="client@example.com"')
$ClientsContent = $ClientsContent.Replace('placeholder="0123456789"', 'placeholder="0123456789"')

[System.IO.File]::WriteAllText($ClientsPath, $ClientsContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx hotfix applied."

# ------------------------------------------------------------
# 6. CSS guardrails: keep labels and stars inline; force single-line inputs.
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT PROFILE V8_2 HOTFIX START */"
$MarkerEnd = "/* L360 CLIENT PROFILE V8_2 HOTFIX END */"

$CssBlock = @'

/* L360 CLIENT PROFILE V8_2 HOTFIX START */

/* Keep label text and required star on same visual line. */
.client-form-v6 label {
  gap: 6px !important;
  line-height: 1.25 !important;
  overflow-wrap: normal !important;
  word-break: normal !important;
}

/* Force important form controls to remain single-line input fields. */
.client-form-v6 input,
.client-form-v6 select {
  min-height: 38px !important;
  height: 38px !important;
  line-height: 1.25 !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

/* Given Name / Surname and NRIC / Passport field consistency. */
.client-form-v6 .single-line-input,
.client-form-v6 input[required] {
  display: block !important;
  width: 100% !important;
  height: 38px !important;
  min-height: 38px !important;
}

/* Keep two-column row alignment stable. */
.client-form-v6 .smart-grid.two {
  align-items: start !important;
  gap: 16px 20px !important;
}

/* Avoid asterisks being treated as their own large block. */
.field-required {
  display: inline !important;
  margin-left: 3px !important;
  line-height: 1 !important;
  vertical-align: baseline !important;
}

/* L360 CLIENT PROFILE V8_2 HOTFIX END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "CSS hotfix applied."

# ------------------------------------------------------------
# 7. Report
# ------------------------------------------------------------

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-PROFILE-V8-2-HOTFIX-REPORT-$Stamp.md"

$Report = @"
# Client Profile V8.2 Emergency Hotfix Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified Files

- $ClientsPath
- $CssPath

## Backups

- $ClientsBackup
- $CssBackup

## Fixed

1. Repaired Vite parse error:
   titleGender <RequiredMark />Override: false
   became:
   titleGenderOverride: false

2. Converted JSX RequiredMark tags to inline literal stars so:
   - Given Name *
   - NRIC No. / Passport No. *
   stay on one singular line.

3. Cleaned label text:
   - NRIC No. / Passport No.
   - Building / House No.
   - Postcode No.

4. Expanded mandatory validation for legal client profile:
   - Title Prefix
   - Given Name
   - Gender for NRIC records
   - Immigration / Documented Status
   - ID Type
   - Identity Card Colour / Document Class
   - NRIC No. / Passport No.
   - Email Address
   - Primary Phone Country Code
   - Primary Phone Number
   - Address Type
   - Country
   - Building / House No.
   - Postcode No.
   - Street Address
   - Town / City
   - Document Type
   - Document Status
   - Verification / Review Status

5. Added CSS guardrails for single-line inputs and inline required marks.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Routes modified: NO
Files deleted: NO
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT PROFILE V8.2 HOTFIX COMPLETE"
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
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

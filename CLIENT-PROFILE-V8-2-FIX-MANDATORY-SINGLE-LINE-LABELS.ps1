# ============================================================
# LITIGATION 360
# CLIENT PROFILE V8.2 - MANDATORY FIELD + SINGLE-LINE LABEL FIX
#
# Purpose:
#   Immediate focused repair for:
#   - "Given Name *" showing as two lines
#   - "NRIC No. / Passport No. *" showing as two lines
#   - Mandatory fields being too weak / unclear
#
# Implements:
#   - Forces label text + required star to remain on ONE line
#   - Keeps inputs single-line
#   - Adds/keeps visible required marks for core legal profile fields
#   - Strengthens validation rules for mandatory client creation fields
#   - Keeps existing V8/V8.1 functionality intact
#
# Safety:
#   - Backs up Clients.jsx first
#   - Backs up CSS first
#   - Frontend only
#   - Does NOT modify App.jsx
#   - Does NOT modify backend
#   - Does NOT modify database
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT PROFILE V8.2] $Message" -ForegroundColor Cyan
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

function Add-RequiredMarkerOnce {
    param(
        [string]$Content,
        [string]$LabelText
    )

    $Escaped = [regex]::Escape($LabelText)
    $Pattern = $Escaped + '(?!\s*<RequiredMark\s*/>)'
    return [regex]::Replace($Content, $Pattern, $LabelText + ' <RequiredMark />', 1)
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

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_MANDATORY_FIX_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_MANDATORY_FIX_$Stamp"

Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

$ClientsContent = [System.IO.File]::ReadAllText($ClientsPath)

# ------------------------------------------------------------
# 1) Clean duplicate awkward labels
# ------------------------------------------------------------

$ClientsContent = $ClientsContent.Replace("NRIC No.# / Passport No.#", "NRIC No. / Passport No.")
$ClientsContent = $ClientsContent.Replace("NRIC No.#", "NRIC No.")
$ClientsContent = $ClientsContent.Replace("Passport No.#", "Passport No.")
$ClientsContent = $ClientsContent.Replace("Building / House No.#", "Building / House No.")
$ClientsContent = $ClientsContent.Replace("Postcode No.#", "Postcode No.")

# ------------------------------------------------------------
# 2) Add visible mandatory markers to core legal/admin fields
#    Existing markers are not duplicated because function checks.
# ------------------------------------------------------------

$RequiredLabels = @(
    "Title Prefix",
    "Given Name",
    "Gender",
    "Immigration / Documented Status",
    "ID Type",
    "Identity Card Colour / Document Class",
    "NRIC No. / Passport No.",
    "Country",
    "Document Type",
    "Document Status",
    "Verification / Review Status"
)

foreach ($label in $RequiredLabels) {
    $ClientsContent = Add-RequiredMarkerOnce -Content $ClientsContent -LabelText $label
}

# Add a visible contact requirement note once inside Section 4, without making both Email and Phone individually mandatory.
if ($ClientsContent -notmatch 'At least one contact method is mandatory') {
    $Section4Heading = '<h3>4. Contact Information and Communication Preferences</h3>'
    $Section4Insert = @'
<h3>4. Contact Information and Communication Preferences</h3>
          <p className="mandatory-note">At least one contact method is mandatory: Email Address or Primary Phone Number.</p>
'@
    $ClientsContent = $ClientsContent.Replace($Section4Heading, $Section4Insert.TrimEnd())
    Write-Pass "Contact mandatory note added to Section 4."
} else {
    Write-Warn "Contact mandatory note already exists."
}

# ------------------------------------------------------------
# 3) Replace validateClientForm with stronger mandatory validation
# ------------------------------------------------------------

$NewValidateFunction = @'
  function validateClientForm(payload) {
    const errors = [];
    const flags = [];

    function isBlank(value) {
      return !String(value || "").trim();
    }

    function isUnavailablePlaceholder(value) {
      const safeValue = String(value || "").trim();
      return (
        !safeValue ||
        safeValue === "Not Applicable / N/A" ||
        safeValue === "Unknown" ||
        safeValue === "To be confirmed" ||
        safeValue === "Auto / Select"
      );
    }

    function requireMandatory(label, value) {
      if (isUnavailablePlaceholder(value)) {
        errors.push(label + " is mandatory for client profile registration.");
      }
    }

    requireMandatory("Title Prefix", payload.titlePrefix);
    requireMandatory("Given Name", payload.givenName);
    requireMandatory("Gender", payload.gender);
    requireMandatory("Immigration / Documented Status", payload.residencyStatus);
    requireMandatory("ID Type", payload.identificationKind);
    requireMandatory("Identity Card Colour / Document Class", payload.identityCardColour);
    requireMandatory("NRIC No. / Passport No.", payload.nricPassportNumber);
    requireMandatory("Country", payload.country);
    requireMandatory("Document Type", payload.documentType);
    requireMandatory("Document Status", payload.documentStatus);
    requireMandatory("Verification / Review Status", payload.verificationStatus);

    if (isBlank(payload.email) && isBlank(payload.phoneNumber)) {
      errors.push("At least one contact method is mandatory: Email Address or Primary Phone Number.");
    }

    if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) {
      errors.push("Email Address format is invalid. Example: client@example.com.");
    }

    if (showNationalityField && isBlank(payload.nationality)) {
      errors.push("Nationality / Country of Origin is mandatory for foreign or non-Malaysian status.");
    }

    if (isNricKind(payload.identificationKind)) {
      const dob = parseNricDob(payload.nricPassportNumber, payload.identificationKind);
      const derivedGender = deriveGenderFromIdentification(payload.nricPassportNumber, payload.identificationKind);
      const age = calculateAge(dob);
      const ageNumber = Number(age);

      if (!dob) {
        errors.push("NRIC date of birth could not be read. Check the first six digits.");
      }

      if (Number.isFinite(ageNumber) && ageNumber < 18) {
        errors.push("Client is below 18. This client profile system is configured for adult clients only.");
      }

      if (derivedGender && payload.gender && derivedGender !== payload.gender) {
        errors.push("Gender does not match the final NRIC digit.");
      }

      if (
        derivedGender &&
        payload.titlePrefix &&
        !payload.titleGenderOverride &&
        !titleMatchesGender(payload.titlePrefix, derivedGender)
      ) {
        errors.push("Selected title prefix does not match NRIC-derived gender. Tick manual override only if verified.");
      }
    }

    if (payload.titleGenderOverride && isBlank(payload.titleOverrideReason)) {
      errors.push("Manual title/gender override requires a reason.");
    }

    if (
      payload.identityCardColour === "Blue - Malaysian Citizen / MyKad" &&
      payload.residencyStatus !== "Malaysian Citizen"
    ) {
      flags.push("Identity Card Colour indicates Malaysian Citizen but documented status differs.");
    }

    if (
      payload.identityCardColour === "Red - Permanent Resident" &&
      payload.residencyStatus !== "Malaysia Permanent Resident"
    ) {
      flags.push("Identity Card Colour indicates Permanent Resident but documented status differs.");
    }

    if (
      payload.identityCardColour === "Green - Temporary Resident / MyKAS" &&
      payload.residencyStatus !== "Temporary Resident / MyKAS"
    ) {
      flags.push("Identity Card Colour indicates Temporary Resident / MyKAS but documented status differs.");
    }

    if (payload.documentType === "Passport Bio Page" && isNricKind(payload.identificationKind)) {
      flags.push("Document type is Passport but ID type is NRIC.");
    }

    if (payload.phoneNumber && isMalaysiaCountryCode(payload.phoneCountryCode) && !isValidMalaysiaMobile(payload.phoneNumber)) {
      errors.push("Primary Malaysian phone number should be digits only and start with 01, example 0123456789.");
    }

    if (payload.backupPhoneNumber && isMalaysiaCountryCode(payload.backupPhoneCountryCode) && !isValidMalaysiaMobile(payload.backupPhoneNumber)) {
      errors.push("Backup Malaysian phone number should be digits only and start with 01, example 0123456789.");
    }

    if (payload.unavailableUntilDate && !payload.unavailableUntilTime) {
      errors.push("Unavailable Until time is mandatory when Unavailable Until date is set.");
    }

    if (payload.unavailableUntilDate && payload.availabilityReason === "Not Applicable / N/A") {
      errors.push("Reason for Unavailability is mandatory when Unavailable Until is set.");
    }

    return { errors, flags };
  }
'@

$Pattern = 'function validateClientForm\(payload\) \{[\s\S]*?\r?\n\s+function upsertClientInUi'
$Replacement = $NewValidateFunction.TrimEnd() + "`r`n`r`n  function upsertClientInUi"

$NewClientsContent = [regex]::Replace($ClientsContent, $Pattern, $Replacement, 1)

if ($NewClientsContent -eq $ClientsContent) {
    Write-Warn "validateClientForm block was not replaced. Existing validation remains unchanged."
} else {
    $ClientsContent = $NewClientsContent
    Write-Pass "validateClientForm replaced with stronger mandatory-field validation."
}

[System.IO.File]::WriteAllText($ClientsPath, $ClientsContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx mandatory markers and validation updated."

# ------------------------------------------------------------
# 4) CSS: force label text + required star onto ONE line
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT PROFILE V8_2 MANDATORY SINGLE LINE START */"
$MarkerEnd = "/* L360 CLIENT PROFILE V8_2 MANDATORY SINGLE LINE END */"

$CssBlock = @'

/* L360 CLIENT PROFILE V8_2 MANDATORY SINGLE LINE START */

/*
  Critical fix:
  Previous label CSS used flex-column, so plain text and <RequiredMark />
  became separate flex items. This forced the * onto a second line.
  For normal labels, use block layout so "Given Name *" and
  "NRIC No. / Passport No. *" stay on ONE line.
*/

.client-form-v6 label:not(.checkbox-tile),
.client-form-v5 label:not(.checkbox-tile),
.client-form-v4 label:not(.checkbox-tile) {
  display: block !important;
  font-size: 12.5px !important;
  line-height: 1.25 !important;
  font-weight: 800 !important;
  color: #142033 !important;
  white-space: normal !important;
}

.client-form-v6 label:not(.checkbox-tile) > input,
.client-form-v6 label:not(.checkbox-tile) > select,
.client-form-v6 label:not(.checkbox-tile) > textarea,
.client-form-v6 label:not(.checkbox-tile) > .inline-fields,
.client-form-v6 label:not(.checkbox-tile) > .action-link,
.client-form-v6 label:not(.checkbox-tile) > .muted-box,
.client-form-v5 label:not(.checkbox-tile) > input,
.client-form-v5 label:not(.checkbox-tile) > select,
.client-form-v5 label:not(.checkbox-tile) > textarea,
.client-form-v5 label:not(.checkbox-tile) > .inline-fields,
.client-form-v4 label:not(.checkbox-tile) > input,
.client-form-v4 label:not(.checkbox-tile) > select,
.client-form-v4 label:not(.checkbox-tile) > textarea,
.client-form-v4 label:not(.checkbox-tile) > .inline-fields {
  margin-top: 6px !important;
}

.field-required,
.field-required-inline {
  display: inline !important;
  margin-left: 4px !important;
  color: #b00020 !important;
  font-weight: 900 !important;
  line-height: 1 !important;
  vertical-align: baseline !important;
}

/* Keep all core text inputs single-line */
.client-form-v6 input,
.client-form-v5 input,
.client-form-v4 input {
  height: 38px !important;
  min-height: 38px !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

/* Given Name and Surname must sit on the same row */
.client-form-v6 .name-lock-grid {
  grid-template-columns: repeat(2, minmax(280px, 1fr)) !important;
  align-items: start !important;
}

.client-form-v6 .name-lock-grid label:nth-of-type(3),
.client-form-v6 .name-lock-grid label:nth-of-type(4) {
  align-self: start !important;
}

/* Required note */
.client-form-v6 .mandatory-note,
.client-form-v5 .mandatory-note,
.client-form-v4 .mandatory-note {
  margin: -4px 0 12px !important;
  padding: 8px 10px !important;
  border: 1px solid #ffd27d !important;
  border-radius: 8px !important;
  background: #fff8e8 !important;
  color: #7a5200 !important;
  font-size: 12px !important;
  font-weight: 700 !important;
}

/* L360 CLIENT PROFILE V8_2 MANDATORY SINGLE LINE END */
'@

if ($Css.Contains($MarkerStart)) {
    $PatternCss = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $PatternCss, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "CSS single-line mandatory label fix applied."

# ------------------------------------------------------------
# 5) Documentation report
# ------------------------------------------------------------

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-PROFILE-V8-2-MANDATORY-SINGLE-LINE-REPORT-$Stamp.md"

$Report = @"
# Client Profile V8.2 Mandatory Field + Single-Line Label Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified Files

- $ClientsPath
- $CssPath

## Backups

- $ClientsBackup
- $CssBackup

## Fixed

1. Given Name required marker now stays on one line: Given Name *
2. NRIC No. / Passport No. required marker now stays on one line.
3. Normal labels no longer use flex-column behavior that forces * onto a separate line.
4. Core inputs remain single-line.
5. Mandatory fields strengthened.

## Mandatory Field Rules Added

Mandatory:
- Title Prefix
- Given Name
- Gender
- Immigration / Documented Status
- ID Type
- Identity Card Colour / Document Class
- NRIC No. / Passport No.
- Country
- Document Type
- Document Status
- Verification / Review Status

Conditional mandatory:
- Email Address OR Primary Phone Number, at least one required.
- Nationality / Country of Origin if foreign or non-Malaysian status.
- Manual title/gender override reason if override is checked.
- Unavailable Until time if Unavailable Until date is set.
- Reason for Unavailability if Unavailable Until date is set.

Validation retained:
- NRIC DOB extraction
- Minor blocking below age 18
- NRIC final digit gender check
- Title/gender match check
- Malaysian mobile number format check
- Verification flags for document/status mismatches

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Routes modified: NO
Files deleted: NO
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT PROFILE V8.2 PATCH COMPLETE"
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

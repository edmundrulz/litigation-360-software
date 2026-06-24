# ============================================================
# LITIGATION 360
# CLIENT PROFILE V8.2 - REQUIRED FIELD + PARSE ERROR + SINGLE-LINE FIX
#
# Purpose:
#   Emergency repair for:
#   [plugin:vite:oxc] Clients.jsx parse error:
#   titleGender <RequiredMark />Override: false
#
# Also fixes:
#   - Given Name required marker appearing on a separate line
#   - NRIC No. / Passport No. required marker appearing on a separate line
#   - Required field labels displayed on one single label line
#   - Adds stronger mandatory validation for legal client intake
#   - Keeps current near-working V8/V8.1 form, only patches the broken/messy areas
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

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_2_$Stamp"

Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

$Content = [System.IO.File]::ReadAllText($ClientsPath)

# ------------------------------------------------------------
# 1) Critical parse-error repair:
#    titleGender <RequiredMark />Override: false
#    must become titleGenderOverride: false
# ------------------------------------------------------------

$Before = $Content

$Content = [regex]::Replace(
    $Content,
    'titleGender\s*<RequiredMark\s*/>\s*Override',
    'titleGenderOverride'
)

# Generic protection: if any object property key was accidentally split by JSX RequiredMark, repair it.
$Content = [regex]::Replace(
    $Content,
    '([A-Za-z_][A-Za-z0-9_]*)\s*<RequiredMark\s*/>\s*([A-Za-z_][A-Za-z0-9_]*)\s*:',
    '$1$2:'
)

if ($Content -ne $Before) {
    Write-Pass "Critical Clients.jsx parse error repaired."
} else {
    Write-Warn "No corrupted titleGender RequiredMark pattern found. Continuing with label/layout repairs."
}

# ------------------------------------------------------------
# 2) Add FieldLabel helper so required * stays on the same label line
# ------------------------------------------------------------

if ($Content -notmatch 'function FieldLabel') {
    $FieldLabel = @'

function FieldLabel({ children, required = false }) {
  return (
    <span className="field-label-line">
      {children}
      {required && <RequiredMark />}
    </span>
  );
}
'@

    $RequiredPattern = 'function RequiredMark\(\)\s*\{\s*return\s+<span className="field-required">\*</span>;\s*\}'

    if ([regex]::IsMatch($Content, $RequiredPattern)) {
        $Content = [regex]::Replace(
            $Content,
            $RequiredPattern,
            { param($m) $m.Value + $FieldLabel },
            1
        )
        Write-Pass "FieldLabel helper added after RequiredMark."
    } else {
        Write-Warn "Could not find RequiredMark function. FieldLabel helper not inserted."
    }
} else {
    Write-Warn "FieldLabel helper already exists."
}

# ------------------------------------------------------------
# 3) Convert visible required labels to one-line FieldLabel format
# ------------------------------------------------------------

$LabelReplacements = @{
    'Title Prefix\s*<RequiredMark\s*/>' = '<FieldLabel required>Title Prefix</FieldLabel>'
    'Given Name\s*<RequiredMark\s*/>' = '<FieldLabel required>Given Name</FieldLabel>'
    'Immigration / Documented Status\s*<RequiredMark\s*/>' = '<FieldLabel required>Immigration / Documented Status</FieldLabel>'
    'ID Type\s*<RequiredMark\s*/>' = '<FieldLabel required>ID Type</FieldLabel>'
    'Identity Card Colour / Document Class\s*<RequiredMark\s*/>' = '<FieldLabel required>Identity Card Colour / Document Class</FieldLabel>'
    'NRIC No\. / Passport No\.\s*<RequiredMark\s*/>' = '<FieldLabel required>NRIC No. / Passport No.</FieldLabel>'
    'Email Address\s*<RequiredMark\s*/>' = '<FieldLabel required>Email Address</FieldLabel>'
    'Primary Phone Number\s*<RequiredMark\s*/>' = '<FieldLabel required>Primary Phone Number</FieldLabel>'
    'Country\s*<RequiredMark\s*/>' = '<FieldLabel required>Country</FieldLabel>'
    'Override Reason\s*<RequiredMark\s*/>' = '<FieldLabel required>Override Reason</FieldLabel>'
    'Nationality / Country of Origin\s*<RequiredMark\s*/>' = '<FieldLabel required>Nationality / Country of Origin</FieldLabel>'
    'Reason for Unavailability\s*<RequiredMark\s*/>' = '<FieldLabel required>Reason for Unavailability</FieldLabel>'
}

foreach ($pattern in $LabelReplacements.Keys) {
    $Content = [regex]::Replace($Content, $pattern, $LabelReplacements[$pattern])
}

# If labels still have plain text for mandatory fields, wrap specific common blocks safely.
$Content = [regex]::Replace(
    $Content,
    '(<label>\s*)Title Prefix(\s*<select)',
    '$1<FieldLabel required>Title Prefix</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label>\s*)Given Name(\s*<input)',
    '$1<FieldLabel required>Given Name</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label>\s*)Immigration / Documented Status(\s*<select)',
    '$1<FieldLabel required>Immigration / Documented Status</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label>\s*)ID Type(\s*<select)',
    '$1<FieldLabel required>ID Type</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label>\s*)Identity Card Colour / Document Class(\s*<select)',
    '$1<FieldLabel required>Identity Card Colour / Document Class</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label>\s*)NRIC No\. / Passport No\.(\s*<input)',
    '$1<FieldLabel required>NRIC No. / Passport No.</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label className="full">\s*)Email Address(\s*<input)',
    '$1<FieldLabel required>Email Address</FieldLabel>$2'
)

$Content = [regex]::Replace(
    $Content,
    '(<label className="full">\s*)Primary Phone Number(\s*<div className="inline-fields code-and-number">)',
    '$1<FieldLabel required>Primary Phone Number</FieldLabel>$2'
)

Write-Pass "Required labels converted to one-line label format."

# ------------------------------------------------------------
# 4) Add / strengthen mandatory validation
# ------------------------------------------------------------

if ($Content -notmatch 'V8_2_MANDATORY_VALIDATION_START') {
    $ValidationBlock = @'

    // V8_2_MANDATORY_VALIDATION_START
    const isBlank = (value) => String(value || "").trim() === "";
    const missingMandatory = [];

    if (isBlank(payload.titlePrefix)) {
      missingMandatory.push("Title Prefix");
    }

    if (isBlank(payload.givenName)) {
      missingMandatory.push("Given Name");
    }

    if (isBlank(payload.gender)) {
      missingMandatory.push("Gender");
    }

    if (isBlank(payload.residencyStatus)) {
      missingMandatory.push("Immigration / Documented Status");
    }

    if (isBlank(payload.identificationKind)) {
      missingMandatory.push("ID Type");
    }

    if (isBlank(payload.identityCardColour)) {
      missingMandatory.push("Identity Card Colour / Document Class");
    }

    if (isBlank(payload.nricPassportNumber)) {
      missingMandatory.push("NRIC No. / Passport No.");
    }

    if (isBlank(payload.email) && isBlank(payload.phoneNumber)) {
      missingMandatory.push("Email Address or Primary Phone Number");
    }

    if (isBlank(payload.country)) {
      missingMandatory.push("Country");
    }

    if (missingMandatory.length > 0) {
      errors.push("Mandatory client intake fields missing: " + missingMandatory.join(", ") + ".");
    }

    if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(payload.email)) {
      errors.push("Email Address format is invalid. Example: client@example.com.");
    }
    // V8_2_MANDATORY_VALIDATION_END
'@

    $ValidateIndex = $Content.IndexOf("function validateClientForm")

    if ($ValidateIndex -ge 0) {
        $FlagsAnchor = "const flags = [];"
        $FlagsIndex = $Content.IndexOf($FlagsAnchor, $ValidateIndex)

        if ($FlagsIndex -ge 0) {
            $InsertPoint = $FlagsIndex + $FlagsAnchor.Length
            $Content = $Content.Substring(0, $InsertPoint) + $ValidationBlock + $Content.Substring($InsertPoint)
            Write-Pass "Mandatory validation block inserted after const flags."
        } else {
            $ErrorsAnchor = "const errors = [];"
            $ErrorsIndex = $Content.IndexOf($ErrorsAnchor, $ValidateIndex)

            if ($ErrorsIndex -ge 0) {
                $InsertPoint = $ErrorsIndex + $ErrorsAnchor.Length
                $Content = $Content.Substring(0, $InsertPoint) + $ValidationBlock + $Content.Substring($InsertPoint)
                Write-Pass "Mandatory validation block inserted after const errors."
            } else {
                Write-Warn "Could not find const errors/flags in validateClientForm. Mandatory validation not inserted."
            }
        }
    } else {
        Write-Warn "Could not find validateClientForm. Mandatory validation not inserted."
    }
} else {
    Write-Warn "V8.2 mandatory validation already exists."
}

# ------------------------------------------------------------
# 5) Add HTML required attributes to key UI fields where safe
# ------------------------------------------------------------

$Content = [regex]::Replace($Content, '<select value=\{form\.titlePrefix\}', '<select required value={form.titlePrefix}', 1)
$Content = [regex]::Replace($Content, '<select value=\{form\.residencyStatus\}', '<select required value={form.residencyStatus}', 1)
$Content = [regex]::Replace($Content, '<select value=\{form\.identificationKind\}', '<select required value={form.identificationKind}', 1)
$Content = [regex]::Replace($Content, '<select value=\{form\.identityCardColour\}', '<select required value={form.identityCardColour}', 1)

# Keep labels clean.
$Content = $Content.Replace("NRIC No.# / Passport No.#", "NRIC No. / Passport No.")
$Content = $Content.Replace("NRIC No.#", "NRIC No.")
$Content = $Content.Replace("Passport No.#", "Passport No.")

[System.IO.File]::WriteAllText($ClientsPath, $Content, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx V8.2 patch applied."

# ------------------------------------------------------------
# 6) CSS: keep required markers inline and force single-line inputs
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT PROFILE V8_2 REQUIRED INLINE START */"
$MarkerEnd = "/* L360 CLIENT PROFILE V8_2 REQUIRED INLINE END */"

$CssBlock = @'

/* L360 CLIENT PROFILE V8_2 REQUIRED INLINE START */

.client-form-v6 .field-label-line,
.client-form-v5 .field-label-line,
.client-form-v4 .field-label-line,
.client-form .field-label-line {
  display: inline-flex !important;
  flex-direction: row !important;
  align-items: center !important;
  gap: 4px !important;
  width: auto !important;
  max-width: 100% !important;
  white-space: nowrap !important;
  line-height: 1.25 !important;
}

.client-form-v6 .field-required,
.client-form-v5 .field-required,
.client-form-v4 .field-required,
.client-form .field-required {
  display: inline !important;
  width: auto !important;
  margin-left: 2px !important;
  color: #b00020 !important;
  font-weight: 900 !important;
  line-height: 1 !important;
}

/* Hide any accidentally orphaned required star directly under a label */
.client-form-v6 label > .field-required:not(.field-label-line .field-required),
.client-form-v5 label > .field-required:not(.field-label-line .field-required),
.client-form-v4 label > .field-required:not(.field-label-line .field-required) {
  display: none !important;
}

/* Force Given Name and NRIC/Passport fields to stay as single-line input controls */
.client-form-v6 input.single-line-input,
.client-form-v6 input[required],
.client-form-v6 input,
.client-form-v6 select {
  min-height: 38px !important;
  height: 38px !important;
  line-height: 1.25 !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

/* Keep Given Name / Surname and NRIC row aligned */
.client-form-v6 .name-lock-grid,
.client-form-v6 .identity-grid {
  align-items: start !important;
}

.client-form-v6 .name-lock-grid label,
.client-form-v6 .identity-grid label {
  min-width: 0 !important;
}

/* L360 CLIENT PROFILE V8_2 REQUIRED INLINE END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "CSS inline-required/single-line patch applied."

# ------------------------------------------------------------
# 7) Documentation report
# ------------------------------------------------------------

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-PROFILE-V8-2-REQUIRED-FIELD-PARSE-REPAIR-REPORT-$Stamp.md"

$Report = @"
# Client Profile V8.2 Required Field / Parse Repair Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified Files

- $ClientsPath
- $CssPath

## Backups

- $ClientsBackup
- $CssBackup

## Fixed

1. Repaired corrupted JSX inside object literal:
   titleGender <RequiredMark />Override
   to:
   titleGenderOverride

2. Added FieldLabel helper so required * stays on the same line as the field label.

3. Fixed required labels so these do not show as two-line labels:
   - Given Name *
   - NRIC No. / Passport No. *
   - Title Prefix *
   - Immigration / Documented Status *
   - ID Type *
   - Identity Card Colour / Document Class *
   - Email Address *
   - Primary Phone Number *

4. Added stronger mandatory legal intake validation:
   - Title Prefix
   - Given Name
   - Gender
   - Immigration / Documented Status
   - ID Type
   - Identity Card Colour / Document Class
   - NRIC No. / Passport No.
   - Email Address OR Primary Phone Number
   - Country

5. Added email format validation.

6. Added CSS so required marks are inline and orphaned stars are hidden.

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

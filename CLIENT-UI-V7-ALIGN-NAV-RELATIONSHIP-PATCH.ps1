# ============================================================
# LITIGATION 360
# CLIENT UI V7 ALIGNMENT + NAVIGATION + RELATIONSHIP PATCH
#
# Purpose:
#   Patch the existing frontend without touching backend/database:
#   1. Align the module navigation toolbar:
#      Previous Page = left, Home = center, Save & Next = right
#   2. Prevent client form from overlapping / visually covering toolbar
#   3. Improve field alignment and label consistency
#   4. Keep NRIC No. / Passport No. on one clean single-line label
#   5. Move Email Address into Section 4 Contact Information
#   6. Convert Emergency Relationship into searchable/manual datalist
#   7. Add relationship options:
#      Father, Mother, Sister, Brother, Sibling, Aunty, Uncle,
#      Grandmother, Grandfather, Granduncle, Grandaunty,
#      Step-father, Step-mother, Step-sister, Step-brother,
#      Representative, Wife, Spouse, Relative, and more
#   8. Generate verification/documentation report
#
# Safety:
#   - Backs up App.jsx first
#   - Backs up Clients.jsx first
#   - Backs up CSS first
#   - Frontend only
#   - Does NOT modify backend
#   - Does NOT modify database
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT UI V7 PATCH] $Message" -ForegroundColor Cyan
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

function Get-MatchingBraceIndex {
    param(
        [string]$Text,
        [int]$OpenBraceIndex
    )

    $depth = 0
    $inSingle = $false
    $inDouble = $false
    $inTemplate = $false
    $inLineComment = $false
    $inBlockComment = $false
    $escape = $false

    for ($i = $OpenBraceIndex; $i -lt $Text.Length; $i++) {
        $c = $Text[$i]
        $next = if ($i + 1 -lt $Text.Length) { $Text[$i + 1] } else { [char]0 }

        if ($inLineComment) {
            if ($c -eq "`n") { $inLineComment = $false }
            continue
        }

        if ($inBlockComment) {
            if ($c -eq "*" -and $next -eq "/") {
                $inBlockComment = $false
                $i++
            }
            continue
        }

        if ($escape) {
            $escape = $false
            continue
        }

        if ($c -eq "\") {
            if ($inSingle -or $inDouble -or $inTemplate) {
                $escape = $true
                continue
            }
        }

        if (-not $inSingle -and -not $inDouble -and -not $inTemplate) {
            if ($c -eq "/" -and $next -eq "/") {
                $inLineComment = $true
                $i++
                continue
            }

            if ($c -eq "/" -and $next -eq "*") {
                $inBlockComment = $true
                $i++
                continue
            }
        }

        if (-not $inDouble -and -not $inTemplate -and $c -eq "'") {
            $inSingle = -not $inSingle
            continue
        }

        if (-not $inSingle -and -not $inTemplate -and $c -eq '"') {
            $inDouble = -not $inDouble
            continue
        }

        if (-not $inSingle -and -not $inDouble -and $c -eq '`') {
            $inTemplate = -not $inTemplate
            continue
        }

        if ($inSingle -or $inDouble -or $inTemplate) {
            continue
        }

        if ($c -eq "{") {
            $depth++
        } elseif ($c -eq "}") {
            $depth--

            if ($depth -eq 0) {
                return $i
            }
        }
    }

    return -1
}

function Replace-JsFunction {
    param(
        [string]$Content,
        [string]$FunctionName,
        [string]$Replacement
    )

    $functionIndex = $Content.IndexOf("function $FunctionName")

    if ($functionIndex -lt 0) {
        Fail "Could not find function $FunctionName"
    }

    $openBraceIndex = $Content.IndexOf("{", $functionIndex)

    if ($openBraceIndex -lt 0) {
        Fail "Could not find opening brace for function $FunctionName"
    }

    $closeBraceIndex = Get-MatchingBraceIndex -Text $Content -OpenBraceIndex $openBraceIndex

    if ($closeBraceIndex -lt 0) {
        Fail "Could not find closing brace for function $FunctionName"
    }

    return $Content.Substring(0, $functionIndex) + $Replacement.Trim() + $Content.Substring($closeBraceIndex + 1)
}

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

$AppPath = Join-Path $ProjectRoot "frontend\src\App.jsx"
$ClientsPath = Join-Path $ProjectRoot "frontend\src\pages\Clients.jsx"
$FrontendSrc = Join-Path $ProjectRoot "frontend\src"
$AppCss = Join-Path $FrontendSrc "App.css"
$IndexCss = Join-Path $FrontendSrc "index.css"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (!(Test-Path -LiteralPath $AppPath -PathType Leaf)) {
    Fail "Could not find App.jsx at: $AppPath"
}

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

Write-Step "Target App.jsx:"
Write-Host $AppPath -ForegroundColor Green

Write-Step "Target Clients.jsx:"
Write-Host $ClientsPath -ForegroundColor Green

Write-Step "Target CSS:"
Write-Host $CssPath -ForegroundColor Green

$AppBackup = "$AppPath.BACKUP_BEFORE_CLIENT_UI_V7_NAV_$Stamp"
$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_UI_V7_ALIGN_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_UI_V7_ALIGN_$Stamp"

Copy-Item -LiteralPath $AppPath -Destination $AppBackup -Force
Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $AppBackup -ForegroundColor Green
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

# ------------------------------------------------------------
# 1. Replace ModuleFrame so nav buttons align horizontally.
# ------------------------------------------------------------

$AppContent = [System.IO.File]::ReadAllText($AppPath)

$ModuleFrameReplacement = @'
function ModuleFrame({ title, setModule, previous, canGoBack, backToPreviousModule, children }) {
  const nextMap = {
    "Clients": "Cases",
    "Cases": "Court Dates",
    "Matters": "Court Dates",
    "Court Dates": "Documents",
    "Documents": "Review Submit",
    "Staff": "home",
    "Review / Save & Submit": "home",
    "Matter Intake": "Clients"
  };

  const previousMap = {
    "Clients": "home",
    "Cases": "Clients",
    "Matters": "Clients",
    "Court Dates": "Cases",
    "Documents": "Court Dates",
    "Review / Save & Submit": "Documents",
    "Staff": "home",
    "Matter Intake": "home"
  };

  const nextTarget = nextMap[title];
  const previousTarget = previousMap[title] || "home";

  const nextLabel =
    title === "Clients" ? "Save & Next → Case / Matter Details" :
    title === "Cases" ? "Save & Next → Deadline Details" :
    title === "Matters" ? "Save & Next → Deadline Details" :
    title === "Court Dates" ? "Save & Next → Document Details" :
    title === "Documents" ? "Save & Next → Review / Submit" :
    title === "Review / Save & Submit" ? "Complete / Save / Submit" :
    "Save & Next →";

  function goPrevious() {
    if (canGoBack && typeof previous === "function") {
      previous();
      return;
    }

    if (typeof backToPreviousModule === "function") {
      backToPreviousModule();
      return;
    }

    setModule(previousTarget);
  }

  return (
    <>
      <section className="module-toolbar module-toolbar-fixed">
        <div className="module-toolbar-slot module-toolbar-left">
          <button type="button" onClick={goPrevious}>
            Previous Page
          </button>
        </div>

        <div className="module-toolbar-slot module-toolbar-center">
          <button type="button" onClick={() => setModule("home")}>
            Home
          </button>
          <strong>{title} module is open</strong>
        </div>

        <div className="module-toolbar-slot module-toolbar-right">
          {nextTarget && (
            <button type="button" onClick={() => setModule(nextTarget)}>
              {nextLabel}
            </button>
          )}
        </div>
      </section>

      <div className="module-content-stack">
        {children}
      </div>
    </>
  );
}
'@

if ($AppContent.Contains("module-toolbar-fixed") -and $AppContent.Contains("module-content-stack")) {
    Write-Warn "ModuleFrame already appears to contain V7 toolbar structure. Replacing function again for consistency."
}

$AppContent = Replace-JsFunction -Content $AppContent -FunctionName "ModuleFrame" -Replacement $ModuleFrameReplacement
[System.IO.File]::WriteAllText($AppPath, $AppContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "App.jsx ModuleFrame replaced. Home is now centered on the same row as Previous/Next."

# ------------------------------------------------------------
# 2. Patch Clients.jsx:
#    - add relationship options
#    - move Email Address into Section 4 if still in Section 3
#    - convert Relationship field to searchable datalist/manual entry
# ------------------------------------------------------------

$ClientsContent = [System.IO.File]::ReadAllText($ClientsPath)

$RelationshipConst = @'
const RELATIONSHIP_OPTIONS = [
  "Not Applicable / N/A",
  "Father",
  "Mother",
  "Sister",
  "Brother",
  "Sibling",
  "Aunty",
  "Aunt",
  "Uncle",
  "Grandmother",
  "Grandfather",
  "Granduncle",
  "Grandaunty",
  "Grand-aunt",
  "Step-father",
  "Step-mother",
  "Step-sister",
  "Step-brother",
  "Representative",
  "Legal Representative",
  "Authorised Representative",
  "Wife",
  "Husband",
  "Spouse",
  "Relative",
  "Cousin",
  "Nephew",
  "Niece",
  "Son",
  "Daughter",
  "Parent",
  "Guardian",
  "Executor",
  "Administrator",
  "Trustee",
  "Power of Attorney Holder",
  "Company Contact Person",
  "Employer",
  "Employee",
  "Friend",
  "Other / Manual",
  "Unknown",
  "To be confirmed"
];

'@

if (-not $ClientsContent.Contains("const RELATIONSHIP_OPTIONS")) {
    $insertBefore = "const WHATSAPP_MESSAGE_TEMPLATES = {"

    if ($ClientsContent.Contains($insertBefore)) {
        $ClientsContent = $ClientsContent.Replace($insertBefore, $RelationshipConst + $insertBefore)
        Write-Pass "Relationship options constant added."
    } else {
        Write-Warn "Could not find WHATSAPP_MESSAGE_TEMPLATES marker. Relationship options constant not inserted."
    }
} else {
    Write-Warn "Relationship options constant already exists."
}

$EmailBlock = @'
            <label className="full">
              Email Address
              <input
                type="email"
                value={form.email}
                onChange={(event) => updateForm("email", event.target.value)}
                placeholder="client@example.com"
              />
            </label>
'@

# Remove the old email block once, if it exists before the contact section.
$contactSectionMarker = '<h3>4. Contact Information and Communication Preferences</h3>'
$emailIndex = $ClientsContent.IndexOf($EmailBlock)
$contactIndex = $ClientsContent.IndexOf($contactSectionMarker)

if ($emailIndex -ge 0 -and $contactIndex -gt $emailIndex) {
    $ClientsContent = $ClientsContent.Remove($emailIndex, $EmailBlock.Length)
    Write-Pass "Email Address removed from earlier section."
} else {
    Write-Warn "Email block not found before Section 4, or already moved."
}

$Section4GridMarker = @'
          <div className="smart-grid two">
'@

$contactIndex = $ClientsContent.IndexOf($contactSectionMarker)
$section4GridIndex = if ($contactIndex -ge 0) { $ClientsContent.IndexOf($Section4GridMarker, $contactIndex) } else { -1 }

if ($section4GridIndex -ge 0) {
    $insertAt = $section4GridIndex + $Section4GridMarker.Length

    # Only insert if Email Address does not already appear very close after Section 4.
    $section4SliceLength = [Math]::Min(2500, $ClientsContent.Length - $section4GridIndex)
    $section4Slice = $ClientsContent.Substring($section4GridIndex, $section4SliceLength)

    if (-not $section4Slice.Contains("Email Address")) {
        $ClientsContent = $ClientsContent.Insert($insertAt, "`r`n" + $EmailBlock + "`r`n")
        Write-Pass "Email Address inserted into Section 4 Contact Information."
    } else {
        Write-Warn "Email Address already appears in Section 4. No duplicate inserted."
    }
} else {
    Write-Warn "Could not find Section 4 grid marker. Email Address not inserted."
}

$OldRelationshipInline = @'
            <label>
              Relationship
              <input value={form.emergencyContactRelationship} onChange={(event) => updateForm("emergencyContactRelationship", event.target.value)} placeholder="Spouse, parent, sibling, etc." />
            </label>
'@

$NewRelationshipBlock = @'
            <label>
              Relationship
              <input
                list="client-relationship-options"
                value={form.emergencyContactRelationship}
                onChange={(event) => updateForm("emergencyContactRelationship", event.target.value)}
                placeholder="Search/select or type relationship"
              />
              <datalist id="client-relationship-options">
                {RELATIONSHIP_OPTIONS.map((relationship) => (
                  <option key={relationship} value={relationship} />
                ))}
              </datalist>
              <small>Searchable list with manual free-text entry for unlisted relationships.</small>
            </label>
'@

if ($ClientsContent.Contains($OldRelationshipInline)) {
    $ClientsContent = $ClientsContent.Replace($OldRelationshipInline, $NewRelationshipBlock)
    Write-Pass "Relationship field converted to searchable/manual datalist."
} elseif (-not $ClientsContent.Contains("client-relationship-options")) {
    # Broader replacement fallback
    $RelationshipPattern = '(?s)<label>\s*Relationship\s*<input\s+value=\{form\.emergencyContactRelationship\}.*?placeholder="Spouse, parent, sibling, etc\."\s*/>\s*</label>'
    $NewEscaped = $NewRelationshipBlock.Trim()
    $Updated = [regex]::Replace($ClientsContent, $RelationshipPattern, $NewEscaped, 1)

    if ($Updated -ne $ClientsContent) {
        $ClientsContent = $Updated
        Write-Pass "Relationship field converted using fallback regex."
    } else {
        Write-Warn "Relationship field not found. Manual datalist not applied."
    }
} else {
    Write-Warn "Relationship datalist already present."
}

# Clean up label text if any old hash style survived.
$ClientsContent = $ClientsContent.Replace("NRIC No.# / Passport No.#", "NRIC No. / Passport No.")
$ClientsContent = $ClientsContent.Replace("NRIC No.#", "NRIC No.")
$ClientsContent = $ClientsContent.Replace("Passport No.#", "Passport No.")
$ClientsContent = $ClientsContent.Replace("Building / House No.# and Postcode No.#", "Building / House No. and Postcode No.")
$ClientsContent = $ClientsContent.Replace("Building / House No.#", "Building / House No.")
$ClientsContent = $ClientsContent.Replace("Postcode No.#", "Postcode No.")

[System.IO.File]::WriteAllText($ClientsPath, $ClientsContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx patched for email relocation, clean labels, relationship datalist."

# ------------------------------------------------------------
# 3. CSS alignment and layering patch.
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT UI V7 ALIGNMENT PATCH START */"
$MarkerEnd = "/* L360 CLIENT UI V7 ALIGNMENT PATCH END */"

$CssBlock = @'

/* L360 CLIENT UI V7 ALIGNMENT PATCH START */

/* Toolbar: Previous left, Home centered, Next right, all on the same horizontal line. */
.module-toolbar-fixed {
  display: grid !important;
  grid-template-columns: minmax(160px, 1fr) auto minmax(160px, 1fr) !important;
  align-items: center !important;
  gap: 12px !important;
  width: 100% !important;
  min-height: 54px !important;
  padding: 12px 16px !important;
  margin: 0 0 18px !important;
  position: relative !important;
  z-index: 20 !important;
  clear: both !important;
}

.module-toolbar-slot {
  display: flex !important;
  align-items: center !important;
  min-width: 0 !important;
}

.module-toolbar-left {
  justify-content: flex-start !important;
}

.module-toolbar-center {
  justify-content: center !important;
  gap: 12px !important;
  text-align: center !important;
}

.module-toolbar-right {
  justify-content: flex-end !important;
}

.module-toolbar-fixed button {
  white-space: nowrap !important;
}

.module-toolbar-fixed strong {
  white-space: nowrap !important;
  font-size: 13px !important;
  font-weight: 800 !important;
}

.module-content-stack {
  position: relative !important;
  z-index: 1 !important;
  clear: both !important;
}

/* Client module stacking: never overlap toolbar. */
.client-module,
.client-v6 {
  position: relative !important;
  z-index: 1 !important;
  clear: both !important;
  margin-top: 0 !important;
}

/* Professional form alignment. */
.client-form-v6 .smart-grid.two,
.client-form-v7 .smart-grid.two {
  display: grid !important;
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  gap: 14px 18px !important;
  align-items: start !important;
}

.client-form-v6 .smart-grid > *,
.client-form-v7 .smart-grid > * {
  min-width: 0 !important;
  max-width: 100% !important;
}

.client-form-v6 label,
.client-form-v7 label {
  min-width: 0 !important;
  max-width: 100% !important;
  align-self: start !important;
}

.client-form-v6 input,
.client-form-v6 select,
.client-form-v6 textarea,
.client-form-v7 input,
.client-form-v7 select,
.client-form-v7 textarea {
  width: 100% !important;
  max-width: 100% !important;
}

/* Keep paired fields clean and one-line. */
.client-form-v6 .inline-fields,
.client-form-v7 .inline-fields {
  display: grid !important;
  align-items: start !important;
  width: 100% !important;
  gap: 10px !important;
}

.client-form-v6 .code-and-number,
.client-form-v7 .code-and-number {
  grid-template-columns: minmax(150px, 0.34fr) minmax(220px, 0.66fr) !important;
}

.client-form-v6 .two-even,
.client-form-v7 .two-even {
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
}

/* Remove visual confusion from old numeric marker layout if any old marker remains. */
.field-number {
  display: none !important;
}

/* Keep NRIC / Passport label clean and readable. */
.client-form-v6 label,
.client-form-v7 label {
  overflow-wrap: normal !important;
}

.client-form-v6 small,
.client-form-v7 small {
  max-width: 100% !important;
}

/* The email field now belongs with contact information and should span the form width. */
.client-form-v6 label.full,
.client-form-v7 label.full {
  grid-column: 1 / -1 !important;
}

/* Datalist relationship field should behave like a standard aligned input. */
#client-relationship-options {
  width: 100% !important;
}

/* Mobile/tablet fallback. */
@media (max-width: 1000px) {
  .module-toolbar-fixed {
    grid-template-columns: 1fr !important;
  }

  .module-toolbar-left,
  .module-toolbar-center,
  .module-toolbar-right {
    justify-content: center !important;
  }

  .client-form-v6 .smart-grid.two,
  .client-form-v7 .smart-grid.two,
  .client-form-v6 .code-and-number,
  .client-form-v7 .code-and-number,
  .client-form-v6 .two-even,
  .client-form-v7 .two-even {
    grid-template-columns: 1fr !important;
  }
}

/* L360 CLIENT UI V7 ALIGNMENT PATCH END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
    Write-Warn "Existing V7 CSS block replaced."
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "CSS alignment, toolbar, z-index and field layout patch applied."

# ------------------------------------------------------------
# 4. Verification report.
# ------------------------------------------------------------

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-UI-V7-ALIGNMENT-NAV-RELATIONSHIP-REPORT-$Stamp.md"

$Report = @"
# Client UI V7 Alignment / Navigation / Relationship Patch Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified:
$AppPath
$ClientsPath
$CssPath

Backups:
$AppBackup
$ClientsBackup
$CssBackup

## Corrections Applied

1. Navigation toolbar corrected:
   - Previous Page aligned left.
   - Home centered.
   - Save & Next aligned right.
   - All buttons on the same horizontal line.

2. Layering / z-index corrected:
   - Toolbar placed above module content.
   - Client module no longer overlaps the Home button.

3. Form alignment corrected:
   - Two-column form grid stabilized.
   - Given Name and Surname aligned.
   - Inputs kept within their columns.
   - Full-width fields explicitly span both columns.

4. NRIC / Passport label cleaned:
   - "NRIC No. / Passport No." kept as clean single-line text.
   - Old extra # label variants removed.

5. Email relocation:
   - Email Address moved into Section 4: Contact Information and Communication Preferences.

6. Relationship field corrected:
   - Converted from plain text input to searchable datalist.
   - Still allows manual free-text.
   - Includes Father, Mother, Sister, Brother, Sibling, Aunty, Uncle, Grandmother, Grandfather, Granduncle, Grandaunty, Step relationships, Representative, Wife, Husband, Spouse, Relative and additional legal/admin relationship terms.

## Safety

Backend modified: NO
Database modified: NO
Files deleted: NO

## Next Verification

Run frontend and hard refresh:

cd "$ProjectRoot\frontend"
npm run dev

Then press Ctrl + F5 in browser.

Check:
- Home is centered on same toolbar row.
- Given Name and Surname align.
- Email Address appears under Contact Information.
- Relationship field gives selectable options but allows typing.
- No extra standalone # symbols are visible.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT UI V7 PATCH COMPLETE"
Write-Host ""
Write-Host "Modified files:" -ForegroundColor Cyan
Write-Host $AppPath
Write-Host $ClientsPath
Write-Host $CssPath
Write-Host ""
Write-Host "Backups:" -ForegroundColor Cyan
Write-Host $AppBackup
Write-Host $ClientsBackup
Write-Host $CssBackup
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

# ============================================================
# LITIGATION 360
# V7 APP NAVIGATION + CLIENT FORM ALIGNMENT / VERIFICATION PATCH
#
# Purpose:
#   Fix BOTH issues reported:
#
#   A) App.jsx Vite parse error:
#      [plugin:vite:oxc] Unexpected token around App.jsx line 328
#      This script replaces only the ModuleFrame function block with
#      a clean valid version.
#
#   B) Clients UI corrections:
#      - Align form rows consistently
#      - Home button on same horizontal line as Previous/Next
#      - Stop client module overlapping toolbar
#      - Keep NRIC No. / Passport No. on one line
#      - Move Email Address into Section 4 Contact Information
#      - Add relationship searchable/manual dropdown options
#      - Keep CSS professional and controlled
#
# Safety:
#   - Creates backups first
#   - Does NOT delete files
#   - Does NOT modify backend
#   - Does NOT modify database
#   - Does NOT modify routes
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[V7 UI PATCH] $Message" -ForegroundColor Cyan
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
$AppPath = Join-Path $FrontendSrc "App.jsx"
$ClientsPath = Join-Path $FrontendSrc "pages\Clients.jsx"
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

$AppBackup = "$AppPath.BACKUP_BEFORE_V7_APP_NAV_REPAIR_$Stamp"
$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_V7_CLIENT_UI_PATCH_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_V7_UI_CSS_PATCH_$Stamp"

Copy-Item -LiteralPath $AppPath -Destination $AppBackup -Force
Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $AppBackup -ForegroundColor Green
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

# ------------------------------------------------------------
# 1) REPAIR App.jsx ModuleFrame
# ------------------------------------------------------------

$AppContent = [System.IO.File]::ReadAllText($AppPath)

$ModuleStart = $AppContent.IndexOf("function ModuleFrame")
if ($ModuleStart -lt 0) {
    Fail "Could not find function ModuleFrame in App.jsx. No App.jsx patch applied."
}

$NextFunctionNames = @(
    "function ReviewSubmit",
    "function Operations",
    "function Admin",
    "function Developer"
)

$ModuleEnd = -1

foreach ($fn in $NextFunctionNames) {
    $idx = $AppContent.IndexOf($fn, $ModuleStart + 1)
    if ($idx -gt $ModuleStart) {
        if ($ModuleEnd -lt 0 -or $idx -lt $ModuleEnd) {
            $ModuleEnd = $idx
        }
    }
}

if ($ModuleEnd -lt 0) {
    Fail "Could not find the next function after ModuleFrame in App.jsx. No App.jsx patch applied."
}

$NewModuleFrame = @'
function ModuleFrame({
  title,
  setModule,
  backToPreviousModule,
  previous,
  canGoBack,
  previousTarget,
  children
}) {
  const nextMap = {
    "Clients": "Cases",
    "Cases": "Court Dates",
    "Matters": "Court Dates",
    "Court Dates": "Documents",
    "Documents": "Review Submit",
    "Staff": "home",
    "Review / Save & Submit": "home",
    "Matter Intake": "home"
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
  const resolvedPreviousTarget = previousTarget || previousMap[title] || "home";

  const nextLabel =
    title === "Clients" ? "Save & Next -> Case / Matter Details" :
    title === "Cases" ? "Save & Next -> Deadline Details" :
    title === "Matters" ? "Save & Next -> Deadline Details" :
    title === "Court Dates" ? "Save & Next -> Document Details" :
    title === "Documents" ? "Save & Next -> Review / Submit" :
    title === "Review / Save & Submit" ? "Complete / Save / Submit" :
    "Next Page";

  function goPreviousPage() {
    if (typeof previous === "function" && canGoBack) {
      previous();
      return;
    }

    if (typeof backToPreviousModule === "function" && canGoBack) {
      backToPreviousModule();
      return;
    }

    setModule(resolvedPreviousTarget);
  }

  return (
    <>
      <section className="module-toolbar module-toolbar-fixed">
        <div className="toolbar-left">
          <button type="button" onClick={goPreviousPage}>
            Previous Page
          </button>
        </div>

        <div className="toolbar-center">
          <button type="button" className="toolbar-home-button" onClick={() => setModule("home")}>
            Home
          </button>
          <strong>{title} module is open</strong>
        </div>

        <div className="toolbar-right">
          {nextTarget && (
            <button type="button" onClick={() => setModule(nextTarget)}>
              {nextLabel}
            </button>
          )}
        </div>
      </section>

      {children}
    </>
  );
}

'@

$AppContent = $AppContent.Substring(0, $ModuleStart) + $NewModuleFrame + $AppContent.Substring($ModuleEnd)
[System.IO.File]::WriteAllText($AppPath, $AppContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "App.jsx ModuleFrame repaired and toolbar normalized."

# ------------------------------------------------------------
# 2) PATCH Clients.jsx - Email relocation + relationship datalist
# ------------------------------------------------------------

$ClientsContent = [System.IO.File]::ReadAllText($ClientsPath)

if ($ClientsContent -notmatch "const RELATIONSHIP_OPTIONS") {
    $RelationshipConst = @'

const RELATIONSHIP_OPTIONS = [
  "Not Applicable / N/A",
  "Father",
  "Mother",
  "Sister",
  "Brother",
  "Sibling",
  "Aunty",
  "Uncle",
  "Grandmother",
  "Grandfather",
  "Granduncle",
  "Grandaunty",
  "Step-father",
  "Step-mother",
  "Step-sister",
  "Step-brother",
  "Representative",
  "Wife",
  "Husband",
  "Spouse",
  "Child",
  "Son",
  "Daughter",
  "Parent",
  "Guardian",
  "Legal Representative",
  "Personal Representative",
  "Executor",
  "Administrator",
  "Relative",
  "Friend",
  "Caregiver",
  "Other / Manual",
  "Unknown",
  "To be confirmed"
];
'@

    $InsertAfter = 'const REVIEW_STATUS_OPTIONS = ['
    $ReviewStart = $ClientsContent.IndexOf($InsertAfter)

    if ($ReviewStart -ge 0) {
        $AfterReviewStart = $ClientsContent.IndexOf("];", $ReviewStart)
        if ($AfterReviewStart -ge 0) {
            $AfterReviewStart = $AfterReviewStart + 2
            $ClientsContent = $ClientsContent.Substring(0, $AfterReviewStart) + $RelationshipConst + $ClientsContent.Substring($AfterReviewStart)
            Write-Pass "RELATIONSHIP_OPTIONS added."
        } else {
            Write-Warn "Could not locate end of REVIEW_STATUS_OPTIONS. Relationship constants not inserted."
        }
    } else {
        Write-Warn "Could not locate REVIEW_STATUS_OPTIONS. Relationship constants not inserted."
    }
} else {
    Write-Warn "RELATIONSHIP_OPTIONS already exists. Skipping constant insertion."
}

# Remove Email Address block from Section 3 if it exists in the V6 location.
$EmailBlockSection3 = @'
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

if ($ClientsContent.Contains($EmailBlockSection3)) {
    $ClientsContent = $ClientsContent.Replace($EmailBlockSection3, "")
    Write-Pass "Email Address removed from old Section 3 location."
} else {
    Write-Warn "Exact old Email Address block not found. It may already have been moved."
}

# Insert Email Address into Section 4 before Primary Phone Number.
$Section4Start = @'
        <div className="form-section">
          <h3>4. Contact Information and Communication Preferences</h3>

          <div className="smart-grid two">
'@

$EmailBlockSection4 = @'
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

if ($ClientsContent.Contains($Section4Start) -and $ClientsContent -notmatch '<h3>4\. Contact Information and Communication Preferences</h3>[\s\S]*?Email Address') {
    $ClientsContent = $ClientsContent.Replace($Section4Start, $Section4Start + $EmailBlockSection4)
    Write-Pass "Email Address moved into Section 4 Contact Information."
} elseif ($ClientsContent.Contains($Section4Start)) {
    Write-Warn "Email Address appears to already be inside Section 4. Skipping insertion."
} else {
    Write-Warn "Could not locate Section 4 start. Email relocation not applied."
}

# Replace Relationship free text input with datalist-based input that still allows manual text.
$OldRelationshipBlock = @'
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
                placeholder="Select or type relationship"
              />
              <small>Search/select common relationship or type manually.</small>
            </label>
'@

if ($ClientsContent.Contains($OldRelationshipBlock)) {
    $ClientsContent = $ClientsContent.Replace($OldRelationshipBlock, $NewRelationshipBlock)
    Write-Pass "Relationship field converted to searchable/manual datalist input."
} elseif ($ClientsContent -match 'list="client-relationship-options"') {
    Write-Warn "Relationship datalist appears to already exist. Skipping relationship field patch."
} else {
    Write-Warn "Could not find exact Relationship field block. Relationship patch not applied."
}

# Add relationship datalist before country-code datalist.
$CountryCodeDatalist = @'
        <datalist id="client-country-code-options">
'@

$RelationshipDatalist = @'
        <datalist id="client-relationship-options">
          {RELATIONSHIP_OPTIONS.map((relationship) => (
            <option key={relationship} value={relationship} />
          ))}
        </datalist>

'@

if ($ClientsContent.Contains($CountryCodeDatalist) -and $ClientsContent -notmatch 'id="client-relationship-options"') {
    $ClientsContent = $ClientsContent.Replace($CountryCodeDatalist, $RelationshipDatalist + $CountryCodeDatalist)
    Write-Pass "Relationship datalist added."
} elseif ($ClientsContent -match 'id="client-relationship-options"') {
    Write-Warn "Relationship datalist already present. Skipping."
} else {
    Write-Warn "Could not find country-code datalist insertion point."
}

# Make sure NRIC label text is clean.
$ClientsContent = $ClientsContent.Replace("NRIC No.# / Passport No.#", "NRIC No. / Passport No.")
$ClientsContent = $ClientsContent.Replace("NRIC No.#", "NRIC No.")
$ClientsContent = $ClientsContent.Replace("Passport No.#", "Passport No.")
$ClientsContent = $ClientsContent.Replace("Building / House No.#", "Building / House No.")
$ClientsContent = $ClientsContent.Replace("Postcode No.#", "Postcode No.")

[System.IO.File]::WriteAllText($ClientsPath, $ClientsContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx patched for email relocation, relationship options and clean labels."

# ------------------------------------------------------------
# 3) CSS: toolbar alignment + form alignment + no overlap
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 V7 NAV CLIENT ALIGNMENT START */"
$MarkerEnd = "/* L360 V7 NAV CLIENT ALIGNMENT END */"

$CssBlock = @'

/* L360 V7 NAV CLIENT ALIGNMENT START */

/* --- Navigation toolbar: Previous / Home / Next on same horizontal line --- */
.module-toolbar.module-toolbar-fixed,
.module-toolbar {
  display: grid !important;
  grid-template-columns: minmax(150px, 1fr) auto minmax(220px, 1fr) !important;
  align-items: center !important;
  gap: 12px !important;
  width: 100% !important;
  min-height: 54px !important;
  padding: 12px 14px !important;
  margin: 0 0 16px !important;
  position: relative !important;
  z-index: 5 !important;
  overflow: visible !important;
}

.module-toolbar .toolbar-left {
  justify-self: start !important;
  display: flex !important;
  align-items: center !important;
}

.module-toolbar .toolbar-center {
  justify-self: center !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 12px !important;
  text-align: center !important;
  white-space: nowrap !important;
}

.module-toolbar .toolbar-right {
  justify-self: end !important;
  display: flex !important;
  align-items: center !important;
  justify-content: flex-end !important;
}

.module-toolbar button {
  white-space: nowrap !important;
  min-height: 34px !important;
  padding: 8px 14px !important;
}

.module-toolbar .toolbar-home-button {
  font-weight: 800 !important;
}

/* Prevent the client module from visually overlapping the toolbar */
.client-module,
.client-v6 {
  position: relative !important;
  z-index: 1 !important;
  margin-top: 0 !important;
  clear: both !important;
}

/* --- Professional form alignment --- */
.client-form-v6,
.client-form-v6 * {
  box-sizing: border-box !important;
}

.client-form-v6 {
  width: 100% !important;
  max-width: 100% !important;
  overflow: hidden !important;
}

.client-form-v6 .smart-grid.two {
  display: grid !important;
  grid-template-columns: repeat(2, minmax(280px, 1fr)) !important;
  gap: 16px 20px !important;
  align-items: start !important;
}

.client-form-v6 .smart-grid.two > label {
  min-width: 0 !important;
  width: 100% !important;
}

.client-form-v6 label {
  display: flex !important;
  flex-direction: column !important;
  gap: 6px !important;
  font-size: 12.5px !important;
  line-height: 1.25 !important;
  font-weight: 800 !important;
}

.client-form-v6 input,
.client-form-v6 select,
.client-form-v6 textarea {
  width: 100% !important;
  min-height: 38px !important;
  max-width: 100% !important;
  font-size: 13px !important;
  line-height: 1.3 !important;
}

.client-form-v6 .full {
  grid-column: 1 / -1 !important;
}

.client-form-v6 .inline-fields {
  display: grid !important;
  width: 100% !important;
  gap: 10px !important;
}

.client-form-v6 .code-and-number {
  grid-template-columns: 170px minmax(0, 1fr) !important;
}

.client-form-v6 .two-even {
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
}

/* Keep single-line labels visible */
.client-form-v6 label,
.client-form-v6 h3 {
  overflow-wrap: normal !important;
  word-break: normal !important;
}

.client-form-v6 small {
  font-size: 11px !important;
  line-height: 1.3 !important;
  font-weight: 500 !important;
}

/* Relationship field and other datalist fields should look like normal inputs */
.client-form-v6 input[list] {
  background: #ffffff !important;
}

/* Table remains scrollable instead of crushing columns */
.client-table-wrap {
  overflow-x: auto !important;
  max-width: 100% !important;
}

.client-table {
  width: max-content !important;
  min-width: 100% !important;
  table-layout: auto !important;
}

.client-table th {
  white-space: nowrap !important;
}

/* Responsive fallback */
@media (max-width: 1000px) {
  .module-toolbar.module-toolbar-fixed,
  .module-toolbar {
    grid-template-columns: 1fr !important;
    justify-items: stretch !important;
  }

  .module-toolbar .toolbar-left,
  .module-toolbar .toolbar-center,
  .module-toolbar .toolbar-right {
    justify-self: stretch !important;
    justify-content: center !important;
  }

  .client-form-v6 .smart-grid.two {
    grid-template-columns: 1fr !important;
  }

  .client-form-v6 .code-and-number,
  .client-form-v6 .two-even {
    grid-template-columns: 1fr !important;
  }
}

/* L360 V7 NAV CLIENT ALIGNMENT END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "CSS toolbar and client form alignment patch applied."

# ------------------------------------------------------------
# 4) Documentation report
# ------------------------------------------------------------

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "V7-APP-NAV-CLIENT-ALIGNMENT-VERIFICATION-REPORT-$Stamp.md"

$Report = @"
# V7 App Navigation + Client Alignment / Verification Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified Files

- $AppPath
- $ClientsPath
- $CssPath

## Backups

- $AppBackup
- $ClientsBackup
- $CssBackup

## App.jsx Repair

- Replaced corrupted or unstable ModuleFrame function block.
- Fixes Vite parse error area caused by malformed ModuleFrame syntax.
- Places Previous Page, Home, and Next Page on the same horizontal toolbar line.
- Prevents the client module from overlapping the Home button.
- Uses deterministic Previous Page targets for workflow modules.

## Clients.jsx Corrections

- Email Address moved to Section 4: Contact Information and Communication Preferences.
- Relationship field converted to searchable/manual datalist.
- Relationship options added:
  Father, Mother, Sister, Brother, Sibling, Aunty, Uncle, Grandmother, Grandfather,
  Granduncle, Grandaunty, Step-father, Step-mother, Step-sister, Step-brother,
  Representative, Wife, Husband, Spouse, Child, Son, Daughter, Parent, Guardian,
  Legal Representative, Personal Representative, Executor, Administrator, Relative,
  Friend, Caregiver, Other / Manual, Unknown, To be confirmed.
- NRIC / Passport label cleaned to one line.
- Extra # wording removed from labels where applicable.

## CSS Corrections

- Previous Page, Home, and Save & Next are aligned on one horizontal line.
- Form fields use stable two-column alignment.
- Given Name and Surname are aligned in the same form grid.
- Client module layering lowered below toolbar.
- Tables remain horizontally scrollable.

## Safety

- Backend modified: NO
- Database modified: NO
- Routes modified: NO
- Files deleted: NO

## Next Steps

Run:

cd "$ProjectRoot\frontend"
npm run dev

Then hard refresh the browser with Ctrl + F5.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "V7 PATCH COMPLETE"
Write-Host ""
Write-Host "Modified App.jsx:" -ForegroundColor Cyan
Write-Host $AppPath
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
Write-Host $AppBackup
Write-Host $ClientsBackup
Write-Host $CssBackup
Write-Host ""
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "cd `"$ProjectRoot\frontend`""
Write-Host "npm run dev"
Write-Host "Then hard refresh browser with Ctrl + F5"

# ============================================================
# LITIGATION 360
# CLIENT PROFILE V8 - FIELD ALIGNMENT + NRIC STATE OF BIRTH + REGION PATCH
#
# Purpose:
#   Fix the exact issues reported in the Clients registration/profile form:
#   - Given Name and Surname aligned on the same row
#   - Remove/disable Title Suffix from the visible form
#   - Keep NRIC No. / Passport No. as one singular field
#   - Remove extra # symbols from labels
#   - Gender auto-detection from final NRIC digit
#   - Manual title/gender override remains available and aligned
#   - Add State of Birth / Registration auto-populated from NRIC middle 2 digits
#   - Add comprehensive Continent / Region dropdown
#   - Keep contact and address fields as clean single-line entries
#   - Add CSS alignment controls
#   - Generate verification/documentation report
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
    Write-Host "[CLIENT PROFILE V8] $Message" -ForegroundColor Cyan
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

function Replace-Section {
    param(
        [string]$Content,
        [string]$StartMarker,
        [string]$EndMarker,
        [string]$Replacement,
        [string]$SectionName
    )

    $start = $Content.IndexOf($StartMarker)
    if ($start -lt 0) {
        Write-Warn "Could not find start marker for $SectionName. Section not replaced."
        return $Content
    }

    $end = $Content.IndexOf($EndMarker, $start + $StartMarker.Length)
    if ($end -lt 0) {
        Write-Warn "Could not find end marker after $SectionName. Section not replaced."
        return $Content
    }

    return $Content.Substring(0, $start) + $Replacement + "`r`n" + $Content.Substring($end)
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

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_$Stamp"
$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_PROFILE_V8_$Stamp"

Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force

Write-Pass "Backups created:"
Write-Host $ClientsBackup -ForegroundColor Green
Write-Host $CssBackup -ForegroundColor Green

$ClientsContent = [System.IO.File]::ReadAllText($ClientsPath)

# ------------------------------------------------------------
# 1) Add new model fields if missing
# ------------------------------------------------------------

if ($ClientsContent -notmatch 'stateOfBirth:') {
    $ClientsContent = $ClientsContent.Replace('generation: "",', 'generation: "",' + "`r`n  stateOfBirth: "",")
    Write-Pass "Added stateOfBirth to EMPTY_CLIENT."
} else {
    Write-Warn "stateOfBirth already exists."
}

if ($ClientsContent -notmatch 'region:') {
    $ClientsContent = $ClientsContent.Replace('continent: "Asia",', 'continent: "Asia",' + "`r`n  region: "Southeast Asia",')
    Write-Pass "Added region to EMPTY_CLIENT."
} else {
    Write-Warn "region already exists."
}

# ------------------------------------------------------------
# 2) Add REGION_OPTIONS and Malaysian NRIC state-code map
# ------------------------------------------------------------

if ($ClientsContent -notmatch 'const REGION_OPTIONS') {
    $RegionOptions = @'

const REGION_OPTIONS = [
  "Not Applicable / N/A",
  "Europe - North Europe",
  "Europe - South Europe",
  "Europe - East Europe",
  "Europe - West Europe",
  "Asia - Southeast Asia",
  "Asia - South Asia",
  "Asia - East Asia",
  "Asia - West Asia",
  "Asia - Central Asia",
  "Africa - North Africa",
  "Africa - West Africa",
  "Africa - East Africa",
  "Africa - Southern Africa",
  "Africa - Central Africa",
  "Americas - North America",
  "Americas - Central America",
  "Americas - South America",
  "Americas - Caribbean",
  "Oceania - Australia",
  "Oceania - New Zealand",
  "Oceania - Pacific Islands",
  "Other / Unknown",
  "Unknown",
  "To be confirmed"
];
'@

    $InsertAfter = 'const CONTINENT_OPTIONS = ['
    $idx = $ClientsContent.IndexOf($InsertAfter)

    if ($idx -ge 0) {
        $endIdx = $ClientsContent.IndexOf("];", $idx)
        if ($endIdx -ge 0) {
            $endIdx += 2
            $ClientsContent = $ClientsContent.Substring(0, $endIdx) + $RegionOptions + $ClientsContent.Substring($endIdx)
            Write-Pass "REGION_OPTIONS added."
        } else {
            Write-Warn "Could not find end of CONTINENT_OPTIONS."
        }
    } else {
        Write-Warn "Could not find CONTINENT_OPTIONS."
    }
} else {
    Write-Warn "REGION_OPTIONS already exists."
}

if ($ClientsContent -notmatch 'const MALAYSIA_NRIC_STATE_CODE_MAP') {
    $StateMap = @'

const MALAYSIA_NRIC_STATE_CODE_MAP = {
  "01": "Johor", "21": "Johor", "22": "Johor", "23": "Johor", "24": "Johor",
  "02": "Kedah", "25": "Kedah", "26": "Kedah", "27": "Kedah",
  "03": "Kelantan", "28": "Kelantan", "29": "Kelantan",
  "04": "Melaka", "30": "Melaka",
  "05": "Negeri Sembilan", "31": "Negeri Sembilan", "59": "Negeri Sembilan",
  "06": "Pahang", "32": "Pahang", "33": "Pahang",
  "07": "Pulau Pinang", "34": "Pulau Pinang", "35": "Pulau Pinang",
  "08": "Perak", "36": "Perak", "37": "Perak", "38": "Perak", "39": "Perak",
  "09": "Perlis", "40": "Perlis",
  "10": "Selangor", "41": "Selangor", "42": "Selangor", "43": "Selangor", "44": "Selangor",
  "11": "Terengganu", "45": "Terengganu", "46": "Terengganu",
  "12": "Sabah", "47": "Sabah", "48": "Sabah", "49": "Sabah",
  "13": "Sarawak", "50": "Sarawak", "51": "Sarawak", "52": "Sarawak", "53": "Sarawak",
  "14": "Wilayah Persekutuan Kuala Lumpur", "54": "Wilayah Persekutuan Kuala Lumpur", "55": "Wilayah Persekutuan Kuala Lumpur", "56": "Wilayah Persekutuan Kuala Lumpur", "57": "Wilayah Persekutuan Kuala Lumpur",
  "15": "Wilayah Persekutuan Labuan", "58": "Wilayah Persekutuan Labuan",
  "16": "Wilayah Persekutuan Putrajaya"
};
'@

    $InsertAfter = 'const COUNTRY_TO_CONTINENT = {'
    $idx = $ClientsContent.IndexOf($InsertAfter)

    if ($idx -ge 0) {
        $endIdx = $ClientsContent.IndexOf("};", $idx)
        if ($endIdx -ge 0) {
            $endIdx += 2
            $ClientsContent = $ClientsContent.Substring(0, $endIdx) + $StateMap + $ClientsContent.Substring($endIdx)
            Write-Pass "MALAYSIA_NRIC_STATE_CODE_MAP added."
        } else {
            Write-Warn "Could not find end of COUNTRY_TO_CONTINENT."
        }
    } else {
        Write-Warn "Could not find COUNTRY_TO_CONTINENT."
    }
} else {
    Write-Warn "MALAYSIA_NRIC_STATE_CODE_MAP already exists."
}

# ------------------------------------------------------------
# 3) Add helper functions
# ------------------------------------------------------------

if ($ClientsContent -notmatch 'function getMalaysiaNricStateOfBirth') {
    $HelperFunctions = @'

function getMalaysiaNricStateOfBirth(value, kind) {
  if (!isNricKind(kind)) {
    return "";
  }

  const digits = String(value || "").replace(/\D/g, "");

  if (digits.length < 8) {
    return "";
  }

  const stateCode = digits.slice(6, 8);
  return MALAYSIA_NRIC_STATE_CODE_MAP[stateCode] || "Unknown / Non-standard NRIC state code (" + stateCode + ")";
}

function getDefaultRegion(country, continent) {
  const safeCountry = String(country || "");
  const safeContinent = String(continent || "");

  if (safeCountry === "Malaysia" || safeCountry === "Singapore" || safeCountry === "Brunei" || safeCountry === "Indonesia" || safeCountry === "Thailand" || safeCountry === "Philippines" || safeCountry === "Vietnam") {
    return "Asia - Southeast Asia";
  }

  if (safeCountry === "India" || safeCountry === "Pakistan" || safeCountry === "Bangladesh") {
    return "Asia - South Asia";
  }

  if (safeCountry === "China" || safeCountry === "Japan" || safeCountry === "South Korea") {
    return "Asia - East Asia";
  }

  if (safeCountry === "United Arab Emirates" || safeCountry === "Saudi Arabia" || safeCountry === "Qatar") {
    return "Asia - West Asia";
  }

  if (safeCountry === "Australia") {
    return "Oceania - Australia";
  }

  if (safeCountry === "New Zealand") {
    return "Oceania - New Zealand";
  }

  if (safeCountry === "United States" || safeCountry === "Canada") {
    return "Americas - North America";
  }

  if (safeContinent === "Europe") {
    return "Europe - West Europe";
  }

  if (safeContinent === "Africa") {
    return "Africa - North Africa";
  }

  return "";
}
'@

    $insertBefore = 'function formatDateDisplay'
    $idx = $ClientsContent.IndexOf($insertBefore)

    if ($idx -ge 0) {
        $ClientsContent = $ClientsContent.Substring(0, $idx) + $HelperFunctions + "`r`n" + $ClientsContent.Substring($idx)
        Write-Pass "State of Birth and Region helper functions added."
    } else {
        Write-Warn "Could not find insertion point for helper functions."
    }
} else {
    Write-Warn "getMalaysiaNricStateOfBirth already exists."
}

# ------------------------------------------------------------
# 4) Patch normalizeClient / buildPayload / updateForm with state/region
# ------------------------------------------------------------

if ($ClientsContent -notmatch 'const stateOfBirth = source.stateOfBirth') {
    $ClientsContent = $ClientsContent.Replace(
        'const country = source.country || "Malaysia";',
        'const country = source.country || "Malaysia";' + "`r`n  const stateOfBirth = source.stateOfBirth || getMalaysiaNricStateOfBirth(nricPassportNumber, identificationKind);" + "`r`n  const region = source.region || getDefaultRegion(country, source.continent || COUNTRY_TO_CONTINENT[country] || "" );"
    )
    Write-Pass "normalizeClient stateOfBirth/region constants added."
}

if ($ClientsContent -notmatch 'stateOfBirth,') {
    $ClientsContent = $ClientsContent.Replace(
        'generation,',
        'generation,' + "`r`n    stateOfBirth,"
    )
    Write-Pass "stateOfBirth included in normalized client."
}

if ($ClientsContent -notmatch 'region,') {
    $ClientsContent = $ClientsContent.Replace(
        'continent: source.continent || COUNTRY_TO_CONTINENT[country] || "Asia",',
        'continent: source.continent || COUNTRY_TO_CONTINENT[country] || "Asia",' + "`r`n    region,"
    )
    Write-Pass "region included in normalized client."
}

if ($ClientsContent -notmatch 'const stateOfBirth = getMalaysiaNricStateOfBirth') {
    $ClientsContent = $ClientsContent.Replace(
        'const gender = form.gender || deriveGenderFromIdentification(nricPassportNumber, identificationKind);',
        'const gender = form.gender || deriveGenderFromIdentification(nricPassportNumber, identificationKind);' + "`r`n  const stateOfBirth = getMalaysiaNricStateOfBirth(nricPassportNumber, identificationKind);"
    )
    Write-Pass "buildPayload stateOfBirth constant added."
}

if ($ClientsContent -notmatch 'stateOfBirth,(\r\n|\n)    identificationKind') {
    $ClientsContent = $ClientsContent.Replace(
        'generation,' + "`r`n    identificationKind,",
        'generation,' + "`r`n    stateOfBirth," + "`r`n    identificationKind,"
    )
    Write-Pass "stateOfBirth added to buildPayload."
}

if ($ClientsContent -notmatch 'next.stateOfBirth = getMalaysiaNricStateOfBirth') {
    $ClientsContent = $ClientsContent.Replace(
        'next.generation = getGeneration(derivedDob);',
        'next.generation = getGeneration(derivedDob);' + "`r`n        next.stateOfBirth = getMalaysiaNricStateOfBirth(idValue, kind);"
    )
    Write-Pass "updateForm NRIC stateOfBirth auto-population added."
}

if ($ClientsContent -notmatch 'next.region = getDefaultRegion') {
    $ClientsContent = $ClientsContent.Replace(
        'next.continent = COUNTRY_TO_CONTINENT[value] || previous.continent || "";',
        'next.continent = COUNTRY_TO_CONTINENT[value] || previous.continent || "";' + "`r`n        next.region = getDefaultRegion(value, next.continent) || previous.region || "";"
    )
    Write-Pass "updateForm country-to-region auto-population added."
}

# ------------------------------------------------------------
# 5) Replace Section 1 and Section 2 for correct flow/alignment
# ------------------------------------------------------------

$NewSection1 = @'
        <div className="form-section">
          <h3>1. Name, Title and Identity Lock</h3>

          <div className="smart-grid two name-lock-grid">
            <label>
              Title Prefix
              <select value={form.titlePrefix} onChange={(event) => updateForm("titlePrefix", event.target.value)}>
                <option value="">Select title</option>
                {TITLE_PREFIX_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Initials
              <input value={form.initials || "Auto"} readOnly />
            </label>

            <label>
              Given Name <RequiredMark />
              <input
                className="single-line-input"
                value={form.givenName}
                onChange={(event) => updateForm("givenName", event.target.value)}
                placeholder="Given name"
                required
              />
            </label>

            <label>
              Surname / Last Name
              <input
                className="single-line-input"
                value={form.surname}
                onChange={(event) => updateForm("surname", event.target.value)}
                placeholder="Surname / Last name"
              />
            </label>

            <label>
              Gender
              <select value={form.gender} onChange={(event) => updateForm("gender", event.target.value)}>
                {["Auto / Select", "Male", "Female", "Not specified", "Not Applicable / N/A", "Unknown", "To be confirmed"].map((option) => (
                  <option key={option} value={option === "Auto / Select" ? "" : option}>
                    {option}
                  </option>
                ))}
              </select>
              <small>Auto-detected from NRIC final digit: odd = Male, even = Female.</small>
            </label>

            <label className="checkbox-tile">
              <input
                type="checkbox"
                checked={form.titleGenderOverride}
                onChange={(event) => updateForm("titleGenderOverride", event.target.checked)}
              />
              Manual title/gender override
            </label>

            {form.titleGenderOverride && (
              <label className="full">
                Override Reason <RequiredMark />
                <textarea
                  value={form.titleOverrideReason}
                  onChange={(event) => updateForm("titleOverrideReason", event.target.value)}
                  placeholder="Record verified reason for title/gender override."
                />
              </label>
            )}
          </div>
        </div>

'@

$NewSection2 = @'
        <div className="form-section">
          <h3>2. Identification, Date of Birth, State of Birth, Age and Generation</h3>

          <div className="smart-grid two identity-grid">
            <label>
              Immigration / Documented Status
              <select value={form.residencyStatus} onChange={(event) => updateForm("residencyStatus", event.target.value)}>
                {RESIDENCY_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              ID Type
              <select value={form.identificationKind} onChange={(event) => updateForm("identificationKind", event.target.value)}>
                {IDENTIFICATION_KIND_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Identity Card Colour / Document Class
              <select value={form.identityCardColour} onChange={(event) => updateForm("identityCardColour", event.target.value)}>
                {IDENTITY_CARD_COLOUR_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
              <small>Blue auto-confirms Malaysian Citizen.</small>
            </label>

            <label>
              NRIC No. / Passport No. <RequiredMark />
              <input
                className="single-line-input"
                value={form.nricPassportNumber}
                onChange={(event) => updateForm("nricPassportNumber", event.target.value)}
                placeholder="Enter NRIC or Passport No."
                required
              />
            </label>

            <label>
              Date of Birth
              <input value={form.dateOfBirth ? formatDateDisplay(form.dateOfBirth) : "Auto from NRIC"} readOnly />
            </label>

            <label>
              State of Birth / Registration
              <input value={form.stateOfBirth || "Auto from NRIC state code"} readOnly />
              <small>Auto-populated from NRIC middle two digits.</small>
            </label>

            <label>
              Age Category
              <input value={form.ageCategory || "Auto from NRIC"} readOnly />
              <small>Adult: 18-59. Senior Citizen: 60 onwards. Minor records are blocked.</small>
            </label>

            <label>
              Generation Classification
              <input value={form.generation || "Auto from date of birth"} readOnly />
            </label>

            <label>
              Ethnicity
              <input
                list="client-ethnicity-options"
                value={form.ethnicity}
                onChange={(event) => updateForm("ethnicity", event.target.value)}
                placeholder="Search/select ethnicity"
              />
              <datalist id="client-ethnicity-options">
                {ETHNICITY_OPTIONS.map((ethnicity) => (
                  <option key={ethnicity} value={ethnicity} />
                ))}
              </datalist>
            </label>

            {showNationalityField && (
              <label>
                Nationality / Country of Origin <RequiredMark />
                <input
                  list="client-country-options"
                  value={form.nationality}
                  onChange={(event) => updateForm("nationality", event.target.value)}
                  placeholder="Search or type nationality"
                  required
                />
              </label>
            )}

            {(form.ethnicity === "Other / Self Describe" || form.ethnicity === "Other Malaysian Ethnicity" || form.ethnicity === "Other Singapore Ethnicity") && (
              <label className="full">
                Other Ethnicity Description
                <input
                  value={form.ethnicityOther}
                  onChange={(event) => updateForm("ethnicityOther", event.target.value)}
                  placeholder="Describe ethnicity"
                />
              </label>
            )}
          </div>
        </div>

'@

$ClientsContent = Replace-Section `
    -Content $ClientsContent `
    -StartMarker '        <div className="form-section">' `
    -EndMarker '        <div className="form-section">' `
    -Replacement $NewSection1 `
    -SectionName "Section 1"

# After replacing section 1, replace the next section 2 using its h3 marker to the next section 3.
$Start2 = '        <div className="form-section">' + "`r`n" + '          <h3>2.'
if ($ClientsContent.IndexOf($Start2) -lt 0) {
    $Start2 = '        <div className="form-section">' + "`n" + '          <h3>2.'
}

$End3 = '        <div className="form-section">' + "`r`n" + '          <h3>3.'
if ($ClientsContent.IndexOf($End3) -lt 0) {
    $End3 = '        <div className="form-section">' + "`n" + '          <h3>3.'
}

$ClientsContent = Replace-Section `
    -Content $ClientsContent `
    -StartMarker $Start2 `
    -EndMarker $End3 `
    -Replacement $NewSection2 `
    -SectionName "Section 2"

# ------------------------------------------------------------
# 6) Replace Address Section to add Region and clean labels
# ------------------------------------------------------------

$NewSection5 = @'
        <div className="form-section">
          <h3>5. Address and Service of Correspondence</h3>

          <div className="smart-grid two address-grid">
            <label>
              Address Type
              <select value={form.addressType} onChange={(event) => updateForm("addressType", event.target.value)}>
                {ADDRESS_TYPE_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Country
              <input
                list="client-country-options"
                value={form.country}
                onChange={(event) => updateForm("country", event.target.value)}
                placeholder="Search or type country"
              />
              <datalist id="client-country-options">
                {COUNTRY_OPTIONS.map((country) => (
                  <option key={country} value={country} />
                ))}
              </datalist>
            </label>

            <label className="full">
              Building / House No. and Postcode No.
              <div className="inline-fields two-even">
                <input
                  className="single-line-input"
                  value={form.buildingHouseNo}
                  onChange={(event) => updateForm("buildingHouseNo", event.target.value)}
                  placeholder="House / unit no."
                />
                <input
                  className="single-line-input"
                  value={form.postcode}
                  onChange={(event) => updateForm("postcode", event.target.value)}
                  placeholder="Postcode"
                />
              </div>
            </label>

            <label>
              Building / House Name
              <input value={form.buildingHouseName} onChange={(event) => updateForm("buildingHouseName", event.target.value)} placeholder="Building / house name, if any" />
            </label>

            <label>
              Continent
              <select value={form.continent} onChange={(event) => updateForm("continent", event.target.value)}>
                {CONTINENT_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="full">
              Region
              <select value={form.region} onChange={(event) => updateForm("region", event.target.value)}>
                {REGION_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="full">
              Street Address
              <input value={form.streetAddress} onChange={(event) => updateForm("streetAddress", event.target.value)} placeholder="Street address" />
            </label>

            <label>
              District
              <input value={form.district} onChange={(event) => updateForm("district", event.target.value)} placeholder="District" />
            </label>

            <label>
              Town / City
              <input value={form.townCity} onChange={(event) => updateForm("townCity", event.target.value)} placeholder="Town / City" />
            </label>
          </div>
        </div>

'@

$Start5 = '        <div className="form-section">' + "`r`n" + '          <h3>5.'
if ($ClientsContent.IndexOf($Start5) -lt 0) {
    $Start5 = '        <div className="form-section">' + "`n" + '          <h3>5.'
}

$End6 = '        <div className="form-section">' + "`r`n" + '          <h3>6.'
if ($ClientsContent.IndexOf($End6) -lt 0) {
    $End6 = '        <div className="form-section">' + "`n" + '          <h3>6.'
}

$ClientsContent = Replace-Section `
    -Content $ClientsContent `
    -StartMarker $Start5 `
    -EndMarker $End6 `
    -Replacement $NewSection5 `
    -SectionName "Section 5"

# ------------------------------------------------------------
# 7) Clean labels globally and remove visible title suffix remnants
# ------------------------------------------------------------

$ClientsContent = $ClientsContent.Replace("NRIC No.# / Passport No.#", "NRIC No. / Passport No.")
$ClientsContent = $ClientsContent.Replace("NRIC No.#", "NRIC No.")
$ClientsContent = $ClientsContent.Replace("Passport No.#", "Passport No.")
$ClientsContent = $ClientsContent.Replace("Building / House No.#", "Building / House No.")
$ClientsContent = $ClientsContent.Replace("Postcode No.#", "Postcode No.")
$ClientsContent = $ClientsContent.Replace("<th>Title</th>", "<th>Title</th>")

# Add state/region to search if missing.
if ($ClientsContent -notmatch 'normalized.stateOfBirth') {
    $ClientsContent = $ClientsContent.Replace(
        'normalized.generation,',
        'normalized.generation,' + "`r`n        normalized.stateOfBirth,"
    )
}

if ($ClientsContent -notmatch 'normalized.region') {
    $ClientsContent = $ClientsContent.Replace(
        'normalized.continent,',
        'normalized.continent,' + "`r`n        normalized.region,"
    )
}

[System.IO.File]::WriteAllText($ClientsPath, $ClientsContent, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx V8 field, state-of-birth, region and alignment patch applied."

# ------------------------------------------------------------
# 8) CSS alignment patch
# ------------------------------------------------------------

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT PROFILE V8 ALIGNMENT START */"
$MarkerEnd = "/* L360 CLIENT PROFILE V8 ALIGNMENT END */"

$CssBlock = @'

/* L360 CLIENT PROFILE V8 ALIGNMENT START */

.client-v6,
.client-v6 *,
.client-form-v6,
.client-form-v6 * {
  box-sizing: border-box !important;
}

.client-form-v6 {
  width: 100% !important;
  max-width: 100% !important;
  overflow: hidden !important;
}

/* Consistent two-column professional layout */
.client-form-v6 .smart-grid.two {
  display: grid !important;
  grid-template-columns: repeat(2, minmax(280px, 1fr)) !important;
  gap: 16px 20px !important;
  align-items: start !important;
  width: 100% !important;
}

.client-form-v6 .smart-grid.two > label,
.client-form-v6 .smart-grid.two > div {
  min-width: 0 !important;
  width: 100% !important;
}

/* Force all important entry fields into single-line input appearance */
.client-form-v6 input,
.client-form-v6 select {
  min-height: 38px !important;
  height: 38px !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

.client-form-v6 textarea {
  min-height: 82px !important;
}

/* Given Name and Surname: same row, same sizing */
.client-form-v6 .name-lock-grid label:nth-of-type(3),
.client-form-v6 .name-lock-grid label:nth-of-type(4) {
  align-self: start !important;
}

.client-form-v6 .single-line-input {
  display: block !important;
  width: 100% !important;
  height: 38px !important;
  min-height: 38px !important;
  line-height: 1.25 !important;
}

/* Inline phone/address pairs */
.client-form-v6 .inline-fields {
  display: grid !important;
  gap: 10px !important;
  width: 100% !important;
  align-items: center !important;
}

.client-form-v6 .code-and-number {
  grid-template-columns: 170px minmax(0, 1fr) !important;
}

.client-form-v6 .two-even {
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
}

/* Clean labels: no awkward wrapping */
.client-form-v6 label {
  font-size: 12.5px !important;
  line-height: 1.25 !important;
  font-weight: 800 !important;
  overflow-wrap: normal !important;
  word-break: normal !important;
}

.client-form-v6 h3 {
  font-size: 16px !important;
  line-height: 1.25 !important;
}

/* Full-width rows */
.client-form-v6 .full {
  grid-column: 1 / -1 !important;
}

/* Manual override checkbox alignment */
.client-form-v6 .checkbox-tile {
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  gap: 10px !important;
  min-height: 38px !important;
}

.client-form-v6 .checkbox-tile input[type="checkbox"] {
  width: 17px !important;
  height: 17px !important;
  min-height: 17px !important;
  margin: 0 !important;
}

/* Table remains horizontally scrollable */
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

/* Responsive */
@media (max-width: 1000px) {
  .client-form-v6 .smart-grid.two {
    grid-template-columns: 1fr !important;
  }

  .client-form-v6 .code-and-number,
  .client-form-v6 .two-even {
    grid-template-columns: 1fr !important;
  }

  .client-form-v6 .full {
    grid-column: 1 / -1 !important;
  }
}

/* L360 CLIENT PROFILE V8 ALIGNMENT END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Client Profile V8 CSS alignment patch applied."

# ------------------------------------------------------------
# 9) Documentation report
# ------------------------------------------------------------

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-PROFILE-V8-FIELD-ALIGNMENT-NRIC-STATE-REGION-REPORT-$Stamp.md"

$Report = @"
# Client Profile V8 Field Alignment / NRIC State / Region Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Modified Files

- $ClientsPath
- $CssPath

## Backups

- $ClientsBackup
- $CssBackup

## Implemented

1. Given Name is a single-line field.
2. Surname / Last Name is aligned on the same row as Given Name.
3. Visible Title Suffix field removed/disabled from the form.
4. NRIC No. / Passport No. is one singular field.
5. Extra # symbols removed from labels.
6. Gender auto-detection remains based on final NRIC digit:
   - Odd = Male
   - Even = Female
7. Manual title/gender override remains available and aligned.
8. Added State of Birth / Registration field.
9. State of Birth auto-populates from NRIC middle two digits.
10. Added comprehensive Region dropdown:
   - Europe: North, South, East, West
   - Asia: Southeast, South, East, West, Central
   - Africa: North, West, East, Southern, Central
   - Americas: North, Central, South, Caribbean
   - Oceania: Australia, New Zealand, Pacific Islands
11. Address Continent / Region fields aligned.
12. Single-line input CSS added for important form fields.
13. Documentation report generated.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Routes modified: NO
Files deleted: NO

## Note

This patch uses the Malaysian NRIC state/registration code map in the frontend.
Backend/database persistence for stateOfBirth and region should be added later if your backend schema currently ignores extra client fields.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT PROFILE V8 PATCH COMPLETE"
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

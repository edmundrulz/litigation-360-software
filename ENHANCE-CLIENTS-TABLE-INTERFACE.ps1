# ============================================================
# LITIGATION 360
# ENHANCE CLIENTS TABLE + CLIENT SEARCH + CONTACT LINKS
#
# Purpose:
#   Replaces frontend\src\pages\Clients.jsx with an enhanced
#   client table/interface and adds CSS for proper alignment.
#
# Safety:
#   - Creates backup before modifying Clients.jsx
#   - Creates backup before modifying CSS
#   - Does NOT modify App.jsx
#   - Does NOT modify backend
#   - Does NOT modify database
#   - Does NOT delete files
#
# Important:
#   The UI will send the new fields to /api/clients.
#   If your backend currently only saves name/email/phone/address,
#   the UI will still compile, but full persistence of new fields
#   may require backend client-schema support later.
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENTS ENHANCEMENT] $Message" -ForegroundColor Cyan
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
$FrontendSrc = Join-Path $ProjectRoot "frontend\src"
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

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_TABLE_ENHANCEMENT_$Stamp"
Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Write-Pass "Clients.jsx backup created:"
Write-Host $ClientsBackup -ForegroundColor Green

$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_TABLE_ENHANCEMENT_$Stamp"
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force
Write-Pass "CSS backup created:"
Write-Host $CssBackup -ForegroundColor Green

$ClientsCode = @'
import { useEffect, useMemo, useState } from "react";

const API_URL = "/api/clients";

const EMPTY_CLIENT = {
  id: "",
  givenName: "",
  surname: "",
  initials: "",
  gender: "",
  icNumber: "",
  passportNumber: "",
  email: "",
  phone: "",
  addressType: "Local",
  country: "Malaysia",
  townCity: "",
  district: "",
  streetAddress: "",
  buildingHouseNo: "",
  postcode: "",
  createdAt: "",
  updatedAt: ""
};

const COUNTRY_OPTIONS = [
  "Malaysia",
  "Singapore",
  "Indonesia",
  "Thailand",
  "Brunei",
  "Philippines",
  "Vietnam",
  "Cambodia",
  "Laos",
  "Myanmar",
  "India",
  "Pakistan",
  "Bangladesh",
  "Sri Lanka",
  "China",
  "Japan",
  "South Korea",
  "Australia",
  "New Zealand",
  "United Kingdom",
  "United States",
  "Canada",
  "United Arab Emirates",
  "Saudi Arabia",
  "Qatar"
];

function getClientId(client) {
  return client.id || client._id || "";
}

function splitLegacyName(name) {
  const safeName = String(name || "").trim();

  if (!safeName) {
    return { givenName: "", surname: "" };
  }

  const parts = safeName.split(/\s+/);

  if (parts.length === 1) {
    return { givenName: parts[0], surname: "" };
  }

  return {
    givenName: parts.slice(0, -1).join(" "),
    surname: parts[parts.length - 1]
  };
}

function makeInitials(givenName, surname) {
  const first = String(givenName || "").trim().charAt(0);
  const last = String(surname || "").trim().charAt(0);
  return (first + last).toUpperCase();
}

function maskIcNumber(value) {
  const digits = String(value || "").replace(/\D/g, "");

  if (!digits) {
    return "-";
  }

  return "******-**-****";
}

function deriveGenderFromIc(value) {
  const digits = String(value || "").replace(/\D/g, "");

  if (!digits) {
    return "";
  }

  const lastDigit = Number(digits.charAt(digits.length - 1));

  if (Number.isNaN(lastDigit)) {
    return "";
  }

  return lastDigit % 2 === 1 ? "Male" : "Female";
}

function normalizePhoneForLinks(value) {
  const digits = String(value || "").replace(/\D/g, "");

  if (!digits) {
    return "";
  }

  if (digits.startsWith("60")) {
    return digits;
  }

  if (digits.startsWith("0")) {
    return "60" + digits.slice(1);
  }

  return digits;
}

function formatDateTime(value) {
  if (!value) {
    return "-";
  }

  const date = new Date(value);

  if (Number.isNaN(date.getTime())) {
    return String(value);
  }

  return date.toLocaleString();
}

function formatAddress(client) {
  const parts = [
    client.addressType,
    client.buildingHouseNo,
    client.streetAddress,
    client.district,
    client.townCity,
    client.postcode,
    client.country
  ].filter(Boolean);

  return parts.length ? parts.join(", ") : "-";
}

function normalizeClient(rawClient) {
  const legacyName = splitLegacyName(rawClient.name);
  const givenName = rawClient.givenName || rawClient.firstName || legacyName.givenName || "";
  const surname = rawClient.surname || rawClient.lastName || legacyName.surname || "";
  const icNumber = rawClient.icNumber || rawClient.icNo || rawClient.ic || "";
  const gender = rawClient.gender || deriveGenderFromIc(icNumber);

  return {
    ...EMPTY_CLIENT,
    ...rawClient,
    id: getClientId(rawClient),
    givenName,
    surname,
    initials: rawClient.initials || makeInitials(givenName, surname),
    gender,
    icNumber,
    passportNumber: rawClient.passportNumber || rawClient.passport || "",
    email: rawClient.email || "",
    phone: rawClient.phone || rawClient.phoneNumber || "",
    addressType: rawClient.addressType || "Local",
    country: rawClient.country || "Malaysia",
    townCity: rawClient.townCity || rawClient.city || rawClient.town || "",
    district: rawClient.district || "",
    streetAddress: rawClient.streetAddress || rawClient.address || "",
    buildingHouseNo: rawClient.buildingHouseNo || rawClient.houseNo || "",
    postcode: rawClient.postcode || rawClient.postalCode || "",
    createdAt: rawClient.createdAt || rawClient.createdOn || rawClient.created || "",
    updatedAt: rawClient.updatedAt || rawClient.modifiedOn || rawClient.changedOn || rawClient.editedOn || ""
  };
}

function buildPayload(form, existingClient) {
  const now = new Date().toISOString();
  const givenName = String(form.givenName || "").trim();
  const surname = String(form.surname || "").trim();
  const fullName = [givenName, surname].filter(Boolean).join(" ");
  const gender = form.gender || deriveGenderFromIc(form.icNumber);
  const initials = makeInitials(givenName, surname);

  return {
    ...existingClient,
    ...form,
    name: fullName,
    givenName,
    firstName: givenName,
    surname,
    lastName: surname,
    initials,
    gender,
    icNumber: form.icNumber,
    icMasked: maskIcNumber(form.icNumber),
    passportNumber: form.passportNumber,
    phone: form.phone,
    phoneNumber: form.phone,
    address: formatAddress(form),
    createdAt: existingClient && existingClient.createdAt ? existingClient.createdAt : now,
    updatedAt: now
  };
}

export default function Clients() {
  const [clients, setClients] = useState([]);
  const [form, setForm] = useState(EMPTY_CLIENT);
  const [editingId, setEditingId] = useState("");
  const [searchTerm, setSearchTerm] = useState("");
  const [status, setStatus] = useState("Loading clients...");

  async function loadClients() {
    try {
      const response = await fetch(API_URL);

      if (!response.ok) {
        throw new Error("Unable to load clients");
      }

      const data = await response.json();
      const list = Array.isArray(data) ? data : data.clients || data.data || [];

      setClients(list.map(normalizeClient));
      setStatus("");
    } catch (error) {
      setStatus("Backend client list could not be loaded. Check /api/clients.");
    }
  }

  useEffect(() => {
    loadClients();
  }, []);

  function updateForm(field, value) {
    setForm((previous) => {
      const next = {
        ...previous,
        [field]: value
      };

      if (field === "givenName" || field === "surname") {
        next.initials = makeInitials(
          field === "givenName" ? value : previous.givenName,
          field === "surname" ? value : previous.surname
        );
      }

      if (field === "icNumber") {
        next.gender = deriveGenderFromIc(value);
      }

      return next;
    });
  }

  function resetForm() {
    setForm(EMPTY_CLIENT);
    setEditingId("");
  }

  async function saveClient(event) {
    event.preventDefault();

    const existingClient = clients.find((client) => getClientId(client) === editingId);
    const payload = buildPayload(form, existingClient);

    try {
      const response = await fetch(editingId ? API_URL + "/" + editingId : API_URL, {
        method: editingId ? "PUT" : "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        throw new Error("Save failed");
      }

      await loadClients();
      resetForm();
      setStatus(editingId ? "Client updated." : "Client created.");
    } catch (error) {
      setStatus("Client could not be saved. Backend may need to accept the enhanced client fields.");
    }
  }

  function editClient(client) {
    setEditingId(getClientId(client));
    setForm({
      ...EMPTY_CLIENT,
      ...normalizeClient(client)
    });
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  async function deleteClient(client) {
    const id = getClientId(client);

    if (!id) {
      setStatus("Cannot delete client because the record has no id.");
      return;
    }

    const confirmed = window.confirm("Delete this client record?");

    if (!confirmed) {
      return;
    }

    try {
      const response = await fetch(API_URL + "/" + id, {
        method: "DELETE"
      });

      if (!response.ok) {
        throw new Error("Delete failed");
      }

      await loadClients();
      setStatus("Client deleted.");
    } catch (error) {
      setStatus("Client could not be deleted. Check backend DELETE /api/clients/:id.");
    }
  }

  const filteredClients = useMemo(() => {
    const query = searchTerm.trim().toLowerCase();

    if (!query) {
      return clients;
    }

    return clients.filter((client) => {
      const normalized = normalizeClient(client);
      const searchable = [
        normalized.initials,
        normalized.gender,
        normalized.givenName,
        normalized.surname,
        normalized.name,
        normalized.icNumber,
        normalized.passportNumber,
        maskIcNumber(normalized.icNumber),
        normalized.phone,
        normalized.email,
        normalized.addressType,
        normalized.country,
        normalized.townCity,
        normalized.district,
        normalized.streetAddress,
        normalized.buildingHouseNo,
        normalized.postcode
      ]
        .filter(Boolean)
        .join(" ")
        .toLowerCase();

      return searchable.includes(query);
    });
  }, [clients, searchTerm]);

  return (
    <section className="client-module">
      <div className="client-module-header">
        <div>
          <h2>Client Details</h2>
          <p>
            Searchable by initials, gender, given name, surname, IC, passport number,
            email and phone number.
          </p>
        </div>

        <strong>All Clients ({filteredClients.length})</strong>
      </div>

      {status && <p className="client-status">{status}</p>}

      <form className="client-form" onSubmit={saveClient}>
        <div className="client-form-grid">
          <label>
            Given Name
            <input
              value={form.givenName}
              onChange={(event) => updateForm("givenName", event.target.value)}
              placeholder="Given name"
              required
            />
          </label>

          <label>
            Surname
            <input
              value={form.surname}
              onChange={(event) => updateForm("surname", event.target.value)}
              placeholder="Surname"
            />
          </label>

          <label>
            Initials
            <input value={form.initials} readOnly placeholder="Auto" />
          </label>

          <label>
            IC Number
            <input
              value={form.icNumber}
              onChange={(event) => updateForm("icNumber", event.target.value)}
              placeholder="Masked after entry"
            />
            <small>Displayed as ******-**-**** in the table.</small>
          </label>

          <label>
            Gender
            <select
              value={form.gender}
              onChange={(event) => updateForm("gender", event.target.value)}
            >
              <option value="">Auto / Select</option>
              <option value="Male">Male</option>
              <option value="Female">Female</option>
              <option value="Not specified">Not specified</option>
            </select>
          </label>

          <label>
            Passport Number
            <input
              value={form.passportNumber}
              onChange={(event) => updateForm("passportNumber", event.target.value)}
              placeholder="Passport number"
            />
          </label>

          <label>
            Email Address
            <input
              type="email"
              value={form.email}
              onChange={(event) => updateForm("email", event.target.value)}
              placeholder="client@example.com"
            />
          </label>

          <label>
            Phone Number
            <input
              value={form.phone}
              onChange={(event) => updateForm("phone", event.target.value)}
              placeholder="0123456789 or +60123456789"
            />
          </label>

          <label>
            Address Type
            <select
              value={form.addressType}
              onChange={(event) => updateForm("addressType", event.target.value)}
            >
              <option value="Local">Local Address</option>
              <option value="International">International Address</option>
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

          <label>
            Town / City
            <input
              value={form.townCity}
              onChange={(event) => updateForm("townCity", event.target.value)}
              placeholder="Town / City"
            />
          </label>

          <label>
            District
            <input
              value={form.district}
              onChange={(event) => updateForm("district", event.target.value)}
              placeholder="District"
            />
          </label>

          <label>
            Street Address
            <input
              value={form.streetAddress}
              onChange={(event) => updateForm("streetAddress", event.target.value)}
              placeholder="Street address"
            />
          </label>

          <label>
            Building / House No.
            <input
              value={form.buildingHouseNo}
              onChange={(event) => updateForm("buildingHouseNo", event.target.value)}
              placeholder="Building / house no."
            />
          </label>

          <label>
            Postcode
            <input
              value={form.postcode}
              onChange={(event) => updateForm("postcode", event.target.value)}
              placeholder="Postcode"
            />
          </label>
        </div>

        <div className="client-form-actions">
          <button type="submit">
            {editingId ? "Save Modified Client" : "Add Client"}
          </button>

          <button type="button" onClick={resetForm}>
            Clear Form
          </button>
        </div>
      </form>

      <div className="client-search-row">
        <label>
          Staff Search
          <input
            value={searchTerm}
            onChange={(event) => setSearchTerm(event.target.value)}
            placeholder="Search initials, gender, name, surname, IC, passport, email or phone"
          />
        </label>
      </div>

      <div className="client-table-wrap">
        <table className="client-table">
          <thead>
            <tr>
              <th>Given Name</th>
              <th>Surname</th>
              <th>Initials</th>
              <th>Gender</th>
              <th>IC Number</th>
              <th>Passport No.</th>
              <th>Email Address</th>
              <th>Phone No.#</th>
              <th>WhatsApp</th>
              <th>Address Type</th>
              <th>Country</th>
              <th>Town / City</th>
              <th>District</th>
              <th>Street Address</th>
              <th>Building / House No.</th>
              <th>Postcode</th>
              <th>Initially Created On</th>
              <th>Modified On</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {filteredClients.length === 0 && (
              <tr>
                <td colSpan="19">No matching clients found.</td>
              </tr>
            )}

            {filteredClients.map((client) => {
              const normalized = normalizeClient(client);
              const id = getClientId(normalized);
              const phoneForLinks = normalizePhoneForLinks(normalized.phone);
              const mailTo = normalized.email ? "mailto:" + normalized.email : "";
              const telLink = phoneForLinks ? "tel:+" + phoneForLinks : "";
              const whatsappLink = phoneForLinks ? "https://wa.me/" + phoneForLinks : "";

              return (
                <tr key={id || normalized.email || normalized.phone}>
                  <td>{normalized.givenName || "-"}</td>
                  <td>{normalized.surname || "-"}</td>
                  <td>{normalized.initials || "-"}</td>
                  <td>{normalized.gender || "-"}</td>
                  <td>{maskIcNumber(normalized.icNumber)}</td>
                  <td>{normalized.passportNumber || "-"}</td>
                  <td>
                    {normalized.email ? (
                      <a href={mailTo}>{normalized.email}</a>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td>
                    {normalized.phone ? (
                      <a href={telLink}>{normalized.phone}</a>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td>
                    {phoneForLinks ? (
                      <div className="client-contact-actions">
                        <a href={whatsappLink} target="_blank" rel="noreferrer">
                          Message
                        </a>
                        <a href={telLink}>Call</a>
                      </div>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td>{normalized.addressType || "-"}</td>
                  <td>{normalized.country || "-"}</td>
                  <td>{normalized.townCity || "-"}</td>
                  <td>{normalized.district || "-"}</td>
                  <td>{normalized.streetAddress || "-"}</td>
                  <td>{normalized.buildingHouseNo || "-"}</td>
                  <td>{normalized.postcode || "-"}</td>
                  <td>{formatDateTime(normalized.createdAt)}</td>
                  <td>{formatDateTime(normalized.updatedAt)}</td>
                  <td>
                    <div className="client-row-actions">
                      <button type="button" onClick={() => editClient(normalized)}>
                        Edit
                      </button>
                      <button type="button" onClick={() => deleteClient(normalized)}>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <p className="client-footnote">
        IC numbers are masked in the table. Gender is auto-suggested from the final IC digit
        and can still be manually adjusted before saving.
      </p>
    </section>
  );
}
'@

[System.IO.File]::WriteAllText($ClientsPath, $ClientsCode, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx replaced with enhanced client interface."

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 ENHANCED CLIENT TABLE START */"
$MarkerEnd = "/* L360 ENHANCED CLIENT TABLE END */"

$CssBlock = @'

/* L360 ENHANCED CLIENT TABLE START */

.client-module {
  width: 100%;
  max-width: none;
  box-sizing: border-box;
}

.client-module-header {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: flex-start;
  margin-bottom: 16px;
}

.client-status {
  padding: 10px 12px;
  border: 1px solid #d7dce5;
  border-radius: 8px;
  background: #f7f9fc;
}

.client-form {
  border: 1px solid #d7dce5;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 18px;
  background: #ffffff;
}

.client-form-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(190px, 1fr));
  gap: 12px;
}

.client-form-grid label,
.client-search-row label {
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-weight: 700;
}

.client-form-grid input,
.client-form-grid select,
.client-search-row input {
  width: 100%;
  box-sizing: border-box;
  padding: 9px 10px;
  border: 1px solid #cbd3df;
  border-radius: 8px;
  font: inherit;
}

.client-form-grid small {
  font-weight: 400;
  color: #566275;
}

.client-form-actions {
  display: flex;
  gap: 10px;
  margin-top: 14px;
  flex-wrap: wrap;
}

.client-search-row {
  margin: 16px 0;
}

.client-table-wrap {
  width: 100%;
  max-width: 100%;
  overflow-x: auto;
  border: 1px solid #d7dce5;
  border-radius: 12px;
  background: #ffffff;
}

.client-table {
  width: max-content;
  min-width: 100%;
  border-collapse: collapse;
  table-layout: auto;
}

.client-table th,
.client-table td {
  padding: 10px 12px;
  border-bottom: 1px solid #e5e9f0;
  vertical-align: top;
  text-align: left;
}

.client-table th {
  white-space: nowrap !important;
  word-break: normal !important;
  overflow-wrap: normal !important;
  font-weight: 800;
}

.client-table td {
  max-width: 260px;
  word-break: normal;
  overflow-wrap: anywhere;
}

.client-table th:nth-last-child(3),
.client-table td:nth-last-child(3),
.client-table th:nth-last-child(2),
.client-table td:nth-last-child(2),
.client-table th:last-child,
.client-table td:last-child {
  white-space: nowrap;
  min-width: 130px;
}

.client-contact-actions,
.client-row-actions {
  display: flex;
  flex-direction: column;
  gap: 6px;
  white-space: nowrap;
}

.client-contact-actions a {
  display: inline-block;
}

.client-row-actions button {
  width: 100%;
}

.client-footnote {
  margin-top: 12px;
  color: #566275;
  font-size: 0.95rem;
}

@media (max-width: 1100px) {
  .client-form-grid {
    grid-template-columns: repeat(2, minmax(180px, 1fr));
  }
}

@media (max-width: 700px) {
  .client-module-header {
    flex-direction: column;
  }

  .client-form-grid {
    grid-template-columns: 1fr;
  }
}

/* L360 ENHANCED CLIENT TABLE END */
'@

if ($Css.Contains($MarkerStart)) {
    Write-Warn "Existing enhanced client CSS found. Replacing old block."
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Enhanced client CSS applied."

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-TABLE-ENHANCEMENT-REPORT-$Stamp.md"

$Report = @"
# Client Table Enhancement Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified:
$ClientsPath
$CssPath

Backups:
$ClientsBackup
$CssBackup

## Enhancements

- Search by initials, gender, given name, surname, IC, passport, email and phone.
- Split name into Given Name and Surname.
- Added IC Number field with masked table display.
- Added gender auto-suggestion from final IC digit.
- Added Passport Number.
- Email Address is clickable using mailto.
- Phone Number is clickable using tel.
- WhatsApp message link added through wa.me.
- Local / International address type added.
- Country searchable/manual entry using datalist.
- Added Town / City, District, Street Address, Building / House No., Postcode.
- Header fixed to Initially Created On.
- Added Modified On column.
- Added table CSS to prevent header word splitting.
- Added Actions column with Edit/Delete.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Files deleted: NO

## Important

The UI sends enhanced fields to /api/clients.
If the backend only saves old fields, backend schema/controller expansion may be needed later.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT TABLE ENHANCEMENT COMPLETE"
Write-Host ""
Write-Host "Modified Clients.jsx:" -ForegroundColor Cyan
Write-Host $ClientsPath
Write-Host ""
Write-Host "Modified CSS:" -ForegroundColor Cyan
Write-Host $CssPath
Write-Host ""
Write-Host "Backups:" -ForegroundColor Cyan
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

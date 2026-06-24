# ============================================================
# LITIGATION 360
# FIX CLIENT SAVE FEEDBACK + CLIENT SEARCH LABEL + EMPTY TABLE + IC/GENDER LOGIC
#
# Purpose:
#   Replaces frontend\src\pages\Clients.jsx with a more robust
#   client management interface:
#   - visible acknowledgement after Add Client / Save Modified Client
#   - count increases immediately after save
#   - Client Search label instead of Staff Search
#   - table shows client rows from backend and local fallback
#   - IC masked in table
#   - gender auto-suggested from final IC digit but manually adjustable
#   - email / phone / WhatsApp links
#   - Initially Created On + Modified On columns
#
# Safety:
#   - Backs up Clients.jsx first
#   - Backs up CSS first
#   - Modifies frontend only
#   - Does NOT modify App.jsx
#   - Does NOT modify backend
#   - Does NOT modify database
#   - Does NOT delete files
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[CLIENT SAVE/UI FIX] $Message" -ForegroundColor Cyan
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

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_SAVE_UI_FIX_$Stamp"
Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Write-Pass "Clients.jsx backup created:"
Write-Host $ClientsBackup -ForegroundColor Green

$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_SAVE_UI_FIX_$Stamp"
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force
Write-Pass "CSS backup created:"
Write-Host $CssBackup -ForegroundColor Green

$ClientsCode = @'
import { useEffect, useMemo, useState } from "react";

const API_URL = "/api/clients";
const LOCAL_STORAGE_KEY = "litigation360.clients.localFallback.v1";

const EMPTY_CLIENT = {
  id: "",
  givenName: "",
  surname: "",
  initials: "",
  gender: "",
  genderSource: "auto",
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

function makeId() {
  if (typeof crypto !== "undefined" && crypto.randomUUID) {
    return crypto.randomUUID();
  }

  return "client-" + Date.now() + "-" + Math.random().toString(16).slice(2);
}

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

function readLocalClients() {
  try {
    const raw = localStorage.getItem(LOCAL_STORAGE_KEY);

    if (!raw) {
      return [];
    }

    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed.map(normalizeClient) : [];
  } catch (error) {
    return [];
  }
}

function writeLocalClients(list) {
  try {
    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(list.map(normalizeClient)));
  } catch (error) {
    console.warn("Local client fallback could not be written.", error);
  }
}

function mergeClients(primaryList, secondaryList) {
  const map = new Map();

  [...secondaryList, ...primaryList].forEach((client) => {
    const normalized = normalizeClient(client);
    const key =
      getClientId(normalized) ||
      normalized.email ||
      normalized.phone ||
      normalized.icNumber ||
      normalized.passportNumber ||
      makeId();

    map.set(key, {
      ...normalized,
      id: normalized.id || key
    });
  });

  return Array.from(map.values());
}

function normalizeClient(rawClient) {
  const source = rawClient || {};
  const legacyName = splitLegacyName(source.name);
  const givenName = source.givenName || source.firstName || legacyName.givenName || "";
  const surname = source.surname || source.lastName || legacyName.surname || "";
  const icNumber = source.icNumber || source.icNo || source.ic || "";
  const gender = source.gender || deriveGenderFromIc(icNumber);

  return {
    ...EMPTY_CLIENT,
    ...source,
    id: getClientId(source) || source.id || "",
    givenName,
    surname,
    initials: source.initials || makeInitials(givenName, surname),
    gender,
    genderSource: source.genderSource || (source.gender ? "manual" : "auto"),
    icNumber,
    passportNumber: source.passportNumber || source.passport || "",
    email: source.email || "",
    phone: source.phone || source.phoneNumber || "",
    addressType: source.addressType || "Local",
    country: source.country || "Malaysia",
    townCity: source.townCity || source.city || source.town || "",
    district: source.district || "",
    streetAddress: source.streetAddress || source.address || "",
    buildingHouseNo: source.buildingHouseNo || source.houseNo || "",
    postcode: source.postcode || source.postalCode || "",
    createdAt: source.createdAt || source.createdOn || source.created || "",
    updatedAt: source.updatedAt || source.modifiedOn || source.changedOn || source.editedOn || ""
  };
}

function buildPayload(form, existingClient) {
  const now = new Date().toISOString();
  const givenName = String(form.givenName || "").trim();
  const surname = String(form.surname || "").trim();
  const fullName = [givenName, surname].filter(Boolean).join(" ");
  const gender = form.gender || deriveGenderFromIc(form.icNumber);
  const initials = makeInitials(givenName, surname);
  const existing = existingClient ? normalizeClient(existingClient) : null;

  return {
    ...(existing || {}),
    ...form,
    id: existing ? getClientId(existing) : form.id || makeId(),
    name: fullName,
    givenName,
    firstName: givenName,
    surname,
    lastName: surname,
    initials,
    gender,
    genderSource: form.genderSource || "manual",
    icNumber: form.icNumber,
    icMasked: maskIcNumber(form.icNumber),
    passportNumber: form.passportNumber,
    phone: form.phone,
    phoneNumber: form.phone,
    address: formatAddress(form),
    createdAt: existing && existing.createdAt ? existing.createdAt : now,
    updatedAt: now
  };
}

function extractSavedClient(responseData, fallbackPayload) {
  if (!responseData) {
    return fallbackPayload;
  }

  if (Array.isArray(responseData)) {
    return fallbackPayload;
  }

  return normalizeClient(
    responseData.client ||
      responseData.data ||
      responseData.record ||
      responseData.result ||
      responseData
  );
}

export default function Clients() {
  const [clients, setClients] = useState([]);
  const [form, setForm] = useState(EMPTY_CLIENT);
  const [editingId, setEditingId] = useState("");
  const [searchTerm, setSearchTerm] = useState("");
  const [status, setStatus] = useState("");
  const [statusType, setStatusType] = useState("info");
  const [isSaving, setIsSaving] = useState(false);

  function showStatus(message, type = "info") {
    setStatus(message);
    setStatusType(type);
  }

  async function loadClients() {
    const localClients = readLocalClients();

    try {
      const response = await fetch(API_URL);

      if (!response.ok) {
        throw new Error("Unable to load clients");
      }

      const data = await response.json();
      const list = Array.isArray(data) ? data : data.clients || data.data || [];
      const merged = mergeClients(list, localClients);

      setClients(merged);
      writeLocalClients(merged);

      if (merged.length === 0) {
        showStatus("No clients have been added yet.", "info");
      } else {
        showStatus("Client list loaded.", "success");
      }
    } catch (error) {
      setClients(localClients);

      if (localClients.length > 0) {
        showStatus("Showing locally saved clients. Backend client list could not be loaded.", "warning");
      } else {
        showStatus("No clients loaded. Backend /api/clients may be unavailable.", "warning");
      }
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
        const suggestedGender = deriveGenderFromIc(value);

        if (previous.genderSource !== "manual") {
          next.gender = suggestedGender;
          next.genderSource = "auto";
        }
      }

      if (field === "gender") {
        next.genderSource = "manual";
      }

      return next;
    });
  }

  function resetForm() {
    setForm(EMPTY_CLIENT);
    setEditingId("");
  }

  function upsertClientInUi(savedClient) {
    const normalizedSaved = normalizeClient(savedClient);
    const savedId = getClientId(normalizedSaved);

    setClients((previousClients) => {
      const exists = previousClients.some((client) => getClientId(client) === savedId);
      const nextClients = exists
        ? previousClients.map((client) => (getClientId(client) === savedId ? normalizedSaved : client))
        : [normalizedSaved, ...previousClients];

      writeLocalClients(nextClients);
      return nextClients;
    });
  }

  async function saveClient(event) {
    event.preventDefault();

    if (!form.givenName.trim()) {
      showStatus("Given Name is required before adding a client.", "error");
      return;
    }

    setIsSaving(true);

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

      let responseData = null;

      try {
        responseData = await response.json();
      } catch (jsonError) {
        responseData = null;
      }

      if (!response.ok) {
        throw new Error("Save failed");
      }

      const savedClient = extractSavedClient(responseData, payload);
      const normalizedSaved = {
        ...payload,
        ...savedClient,
        id: getClientId(savedClient) || getClientId(payload)
      };

      upsertClientInUi(normalizedSaved);
      resetForm();

      showStatus(
        editingId
          ? "Client details successfully modified and saved."
          : "Client details successfully entered, received and saved.",
        "success"
      );
    } catch (error) {
      upsertClientInUi(payload);
      resetForm();

      showStatus(
        editingId
          ? "Client modified in the interface and saved locally. Backend save needs checking."
          : "Client added to the interface and saved locally. Backend save needs checking.",
        "warning"
      );
    } finally {
      setIsSaving(false);
    }
  }

  function editClient(client) {
    const normalized = normalizeClient(client);

    setEditingId(getClientId(normalized));
    setForm({
      ...EMPTY_CLIENT,
      ...normalized,
      genderSource: normalized.gender ? "manual" : "auto"
    });
    showStatus("Editing selected client. Modify the details and click Save Modified Client.", "info");
    window.scrollTo({ top: 0, behavior: "smooth" });
  }

  async function deleteClient(client) {
    const normalized = normalizeClient(client);
    const id = getClientId(normalized);

    if (!id) {
      showStatus("Cannot delete client because the record has no id.", "error");
      return;
    }

    const confirmed = window.confirm("Delete this client record?");

    if (!confirmed) {
      return;
    }

    const nextClients = clients.filter((item) => getClientId(item) !== id);
    setClients(nextClients);
    writeLocalClients(nextClients);

    try {
      const response = await fetch(API_URL + "/" + id, {
        method: "DELETE"
      });

      if (!response.ok) {
        throw new Error("Delete failed");
      }

      showStatus("Client deleted.", "success");
    } catch (error) {
      showStatus("Client removed from this interface. Backend delete needs checking.", "warning");
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

        <div className="client-count-card">
          <strong>All Clients ({clients.length})</strong>
          <span>Showing {filteredClients.length} of {clients.length}</span>
        </div>
      </div>

      {status && (
        <p className={"client-status client-status-" + statusType}>
          {status}
        </p>
      )}

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
              placeholder="IC number"
            />
            <small>Table display is masked as ******-**-****.</small>
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
            <small>Auto-suggested from final IC digit; staff can adjust before saving.</small>
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
          <button type="submit" disabled={isSaving}>
            {isSaving
              ? "Saving..."
              : editingId
                ? "Save Modified Client"
                : "Add Client"}
          </button>

          <button type="button" onClick={resetForm}>
            Clear Form
          </button>
        </div>
      </form>

      <div className="client-search-row">
        <label>
          Client Search
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
                <td colSpan="19">
                  {clients.length === 0
                    ? "No clients have been added yet."
                    : "No matching clients found. Clear Client Search to show all clients."}
                </td>
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
                          WhatsApp Message
                        </a>
                        <a href={telLink}>Phone Call</a>
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
        IC numbers are masked in the table for privacy. Gender is auto-suggested from the
        final IC digit and can still be manually adjusted before saving.
      </p>
    </section>
  );
}
'@

[System.IO.File]::WriteAllText($ClientsPath, $ClientsCode, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx replaced with save feedback, client search, count, local fallback, IC masking and gender auto-suggest."

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT SAVE UI FIX START */"
$MarkerEnd = "/* L360 CLIENT SAVE UI FIX END */"

$CssBlock = @'

/* L360 CLIENT SAVE UI FIX START */

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

.client-count-card {
  display: flex;
  flex-direction: column;
  gap: 4px;
  text-align: right;
  white-space: nowrap;
}

.client-count-card span {
  font-size: 0.95rem;
  color: #566275;
}

.client-status {
  padding: 10px 12px;
  border: 1px solid #d7dce5;
  border-radius: 8px;
  background: #f7f9fc;
  font-weight: 700;
}

.client-status-success {
  border-color: #8fd19e;
  background: #ecf9ef;
  color: #145c25;
}

.client-status-warning {
  border-color: #ffd27d;
  background: #fff8e8;
  color: #7a5200;
}

.client-status-error {
  border-color: #f1a2a2;
  background: #fff0f0;
  color: #8a1111;
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

  .client-count-card {
    text-align: left;
  }

  .client-form-grid {
    grid-template-columns: 1fr;
  }
}

/* L360 CLIENT SAVE UI FIX END */
'@

if ($Css.Contains($MarkerStart)) {
    Write-Warn "Existing client save UI CSS found. Replacing old block."
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Client save/UI CSS applied."

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-SAVE-UI-FIX-REPORT-$Stamp.md"

$Report = @"
# Client Save / UI Fix Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified:
$ClientsPath
$CssPath

Backups:
$ClientsBackup
$CssBackup

## Fixed Issues

- Add Client now gives visible acknowledgement / feedback.
- Client count updates immediately after adding a client.
- Staff Search label changed to Client Search.
- Empty table now distinguishes between no clients and no matching search.
- Client rows are loaded from backend plus local fallback.
- IC Number display is masked in table as ******-**-****.
- Gender auto-suggests from final IC digit.
- Staff can manually adjust gender before saving.
- Initially Created On header is present.
- Modified On column is present.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Files deleted: NO

## Note

This patch keeps a browser localStorage fallback so added records appear immediately even if backend persistence is incomplete.
Backend client schema/API should still be reviewed later for full database persistence of the enhanced fields.
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT SAVE/UI FIX COMPLETE"
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

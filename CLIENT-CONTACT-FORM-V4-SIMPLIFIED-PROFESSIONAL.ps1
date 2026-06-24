# ============================================================
# LITIGATION 360
# CLIENT CONTACT FORM V4 - SIMPLIFIED PROFESSIONAL REDESIGN
#
# Purpose:
#   Replace the overloaded client contact form with a cleaner,
#   professional, logically sequenced version.
#
# Fixes:
#   - Removes Phone Info Status and WhatsApp Info Status
#   - One primary phone field with country code selector
#   - Secondary/backup phone support
#   - Phone number history tracking when an existing number changes
#   - WhatsApp same-as-phone checkbox
#   - WhatsApp Available/Connected checkbox
#   - WhatsApp Web link with selectable message template
#   - Consolidates WhatsApp/Contact notes into one communication notes field
#   - Adds availability flags: Away, Unreachable, Overseas, Outstation
#   - Adds availability expiry date/time and reason
#   - Adds N/A option to dropdown/select fields
#   - Adds client profile status + marital status
#   - Adds special staff/lawyer remarks section
#   - Fixes visual sequence, alignment, spacing, and hierarchy
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
    Write-Host "[CLIENT CONTACT FORM V4] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
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

$ClientsBackup = "$ClientsPath.BACKUP_BEFORE_CLIENT_CONTACT_FORM_V4_$Stamp"
Copy-Item -LiteralPath $ClientsPath -Destination $ClientsBackup -Force
Write-Pass "Clients.jsx backup created:"
Write-Host $ClientsBackup -ForegroundColor Green

$CssBackup = "$CssPath.BACKUP_BEFORE_CLIENT_CONTACT_FORM_V4_$Stamp"
Copy-Item -LiteralPath $CssPath -Destination $CssBackup -Force
Write-Pass "CSS backup created:"
Write-Host $CssBackup -ForegroundColor Green

$ClientsCode = @'
import { useEffect, useMemo, useState } from "react";

const API_URL = "/api/clients";

const LOCAL_STORAGE_KEYS = [
  "litigation360.clients.contactForm.v4",
  "litigation360.clients.contactForm.v3",
  "litigation360.clients.registration.v2",
  "litigation360.clients.localFallback.v1"
];

const PRIMARY_LOCAL_STORAGE_KEY = LOCAL_STORAGE_KEYS[0];

const EMPTY_CLIENT = {
  id: "",
  givenName: "",
  surname: "",
  initials: "",
  gender: "",
  genderSource: "auto",
  clientProfileStatus: "Adult",
  employmentStatus: "To be confirmed",
  maritalStatus: "To be confirmed",

  ethnicity: "",
  ethnicityOther: "",
  nationality: "",
  residencyStatus: "Malaysian Citizen",
  identificationKind: "Malaysian NRIC",
  nricPassportNumber: "",

  email: "",

  phoneCountryCode: "+60 Malaysia",
  phoneNumber: "",
  backupPhoneCountryCode: "+60 Malaysia",
  backupPhoneNumber: "",
  phoneHistory: [],

  whatsappSameAsPhone: true,
  whatsappAvailable: true,
  whatsappCountryCode: "+60 Malaysia",
  whatsappNumber: "",
  whatsappMessageTemplate: "General follow-up",
  whatsappCustomMessage: "",
  hasSecondWhatsapp: false,
  whatsapp2CountryCode: "+60 Malaysia",
  whatsapp2Number: "",

  preferredContact1: "WhatsApp Message",
  preferredContact2: "Phone Call",
  preferredContact3: "Email",
  preferredContactHoursFrom: "09:00",
  preferredContactHoursTo: "18:00",

  availabilityAway: false,
  availabilityUnreachable: false,
  availabilityOverseas: false,
  availabilityOutstation: false,
  availabilityUntil: "",
  availabilityReason: "Not Applicable / N/A",
  availabilityReasonOther: "",
  communicationTimingNotes: "",

  emergencyContactName: "",
  emergencyContactRelationship: "",
  emergencyContactCountryCode: "+60 Malaysia",
  emergencyContactNumber: "",
  emergencyContactEmail: "",
  emergencyContactNotes: "",

  addressType: "Residential",
  country: "Malaysia",
  continent: "Asia",
  buildingHouseNo: "",
  buildingHouseName: "",
  postcode: "",
  streetAddress: "",
  district: "",
  townCity: "",

  documentType: "NRIC",
  documentStatus: "Pending Verification",
  documentAttachmentNames: [],
  documentReferenceNote: "",

  staffLawyerRemarks: "",
  missingInformationNotes: "",
  createdAt: "",
  updatedAt: ""
};

const ETHNICITY_OPTIONS = [
  "Not Applicable / N/A",
  "Malay",
  "Chinese Malaysian",
  "Indian Malaysian",
  "Orang Asli",
  "Iban",
  "Bidayuh",
  "Kadazan-Dusun",
  "Bajau",
  "Murut",
  "Melanau",
  "Other Bumiputera Sabah",
  "Other Bumiputera Sarawak",
  "Peranakan / Baba Nyonya",
  "Eurasian Malaysian",
  "Portuguese Eurasian",
  "Sikh / Punjabi Malaysian",
  "Other Malaysian Ethnicity",
  "Chinese Singaporean",
  "Malay Singaporean",
  "Indian Singaporean",
  "Eurasian Singaporean",
  "Peranakan Singaporean",
  "Other Singapore Ethnicity",
  "Foreigner",
  "South Asian",
  "Southeast Asian",
  "East Asian",
  "Arab / Middle Eastern",
  "European / Caucasian",
  "African",
  "Mixed / Multi-ethnic",
  "Other / Self Describe",
  "Unknown",
  "To be confirmed"
];

const COUNTRY_OPTIONS = [
  "Not Applicable / N/A",
  "Malaysia",
  "Singapore",
  "Australia",
  "Bangladesh",
  "Brunei",
  "Canada",
  "China",
  "France",
  "Germany",
  "India",
  "Indonesia",
  "Japan",
  "New Zealand",
  "Pakistan",
  "Philippines",
  "South Korea",
  "Thailand",
  "United Arab Emirates",
  "United Kingdom",
  "United States",
  "Vietnam",
  "Unknown",
  "To be confirmed"
];

const CONTINENT_OPTIONS = [
  "Not Applicable / N/A",
  "Asia",
  "Europe",
  "Africa",
  "North America",
  "South America",
  "Oceania / Australia",
  "Antarctica",
  "Other / Unknown",
  "To be confirmed"
];

const COUNTRY_TO_CONTINENT = {
  Malaysia: "Asia",
  Singapore: "Asia",
  Brunei: "Asia",
  Indonesia: "Asia",
  Philippines: "Asia",
  Thailand: "Asia",
  Vietnam: "Asia",
  India: "Asia",
  Pakistan: "Asia",
  Bangladesh: "Asia",
  China: "Asia",
  Japan: "Asia",
  "South Korea": "Asia",
  "United Arab Emirates": "Asia",
  Australia: "Oceania / Australia",
  "New Zealand": "Oceania / Australia",
  France: "Europe",
  Germany: "Europe",
  "United Kingdom": "Europe",
  Canada: "North America",
  "United States": "North America"
};

const COUNTRY_CODE_OPTIONS = [
  "+60 Malaysia",
  "+1 Canada",
  "+1 United States",
  "+44 United Kingdom",
  "+61 Australia",
  "+62 Indonesia",
  "+63 Philippines",
  "+64 New Zealand",
  "+65 Singapore",
  "+66 Thailand",
  "+81 Japan",
  "+82 South Korea",
  "+84 Vietnam",
  "+86 China",
  "+91 India",
  "+92 Pakistan",
  "+94 Sri Lanka",
  "+673 Brunei",
  "+880 Bangladesh",
  "+966 Saudi Arabia",
  "+971 United Arab Emirates",
  "+974 Qatar",
  "Not Applicable / N/A",
  "Unknown",
  "To be confirmed"
];

const N_A_OPTIONS = [
  "Not Applicable / N/A",
  "Unknown",
  "To be confirmed"
];

const RESIDENCY_STATUS_OPTIONS = [
  "Not Applicable / N/A",
  "Malaysian Citizen",
  "Malaysia Permanent Resident",
  "Singapore Citizen",
  "Singapore Permanent Resident",
  "Foreigner",
  "Employment Pass",
  "Work Permit",
  "Professional Visit Pass",
  "Student Pass",
  "Dependent Pass",
  "Long Term Social Visit Pass",
  "MM2H / Long Stay",
  "Other Immigration / Documented Status",
  "Unknown",
  "To be confirmed"
];

const IDENTIFICATION_KIND_OPTIONS = [
  "Not Applicable / N/A",
  "Malaysian NRIC",
  "Singapore NRIC / FIN",
  "Passport",
  "Permanent Resident Document",
  "Work Visa / Work Permit",
  "Student Pass",
  "Dependent Pass",
  "Other Official ID",
  "Unknown",
  "To be confirmed"
];

const CLIENT_PROFILE_STATUS_OPTIONS = [
  "Not Applicable / N/A",
  "Adult",
  "Minor",
  "Senior Citizen",
  "Student",
  "Working",
  "Employed",
  "Self-Employed",
  "Unemployed",
  "Retired",
  "Homemaker",
  "Business Owner",
  "Director / Shareholder",
  "Deceased",
  "Incapacitated",
  "Unknown",
  "To be confirmed"
];

const EMPLOYMENT_STATUS_OPTIONS = [
  "Not Applicable / N/A",
  "Employed",
  "Self-Employed",
  "Unemployed",
  "Retired",
  "Student",
  "Homemaker",
  "Business Owner",
  "Company Director",
  "Contract Worker",
  "Part-Time",
  "Foreign Worker",
  "Unknown",
  "To be confirmed"
];

const MARITAL_STATUS_OPTIONS = [
  "Not Applicable / N/A",
  "Single",
  "Married",
  "Divorced",
  "Widowed",
  "Separated",
  "Annulled",
  "Customary / Traditional Marriage",
  "Unknown",
  "To be confirmed"
];

const CONTACT_METHOD_OPTIONS = [
  "Not Applicable / N/A",
  "WhatsApp Message",
  "WhatsApp Call",
  "Phone Call",
  "SMS",
  "Email",
  "Postal Mail",
  "Emergency / Next of Kin Only",
  "Unknown",
  "To be confirmed"
];

const AVAILABILITY_REASON_OPTIONS = [
  "Not Applicable / N/A",
  "Funeral",
  "Family Holiday",
  "Personal",
  "Business",
  "Medical",
  "Court / Legal Appointment",
  "Overseas Travel",
  "Other",
  "Unknown",
  "To be confirmed"
];

const ADDRESS_TYPE_OPTIONS = [
  "Not Applicable / N/A",
  "Residential",
  "Commercial",
  "Registered Office",
  "Correspondence",
  "International",
  "Temporary",
  "Other",
  "Unknown",
  "To be confirmed"
];

const DOCUMENT_TYPE_OPTIONS = [
  "Not Applicable / N/A",
  "NRIC",
  "NRIC Front",
  "NRIC Back",
  "Passport Bio Page",
  "Passport Visa Page",
  "Permanent Resident Document",
  "Citizen / PR Proof",
  "Work Visa / Work Permit",
  "Student Pass",
  "Dependent Pass",
  "Address Proof",
  "Other Supporting Document",
  "Unknown",
  "To be confirmed"
];

const DOCUMENT_STATUS_OPTIONS = [
  "Not Applicable / N/A",
  "Pending Verification",
  "Verified",
  "Rejected / Needs Resubmission",
  "Expired",
  "Not Required",
  "Unknown",
  "To be confirmed"
];

const WHATSAPP_MESSAGE_TEMPLATES = {
  "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  "Custom message": ""
};

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

function isNricKind(kind) {
  return String(kind || "").toLowerCase().includes("nric");
}

function maskIdentification(value, kind) {
  const raw = String(value || "").trim();

  if (!raw) {
    return "-";
  }

  if (isNricKind(kind)) {
    return "******-**-****";
  }

  if (raw.length <= 4) {
    return "****";
  }

  return "******" + raw.slice(-4);
}

function deriveGenderFromIdentification(value, kind) {
  if (!isNricKind(kind)) {
    return "";
  }

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

function cleanCountryCode(value) {
  const raw = String(value || "").trim();
  const match = raw.match(/\+\d+/);
  return match ? match[0] : "";
}

function normalizePhoneForLinks(countryCode, number) {
  const code = cleanCountryCode(countryCode).replace(/\D/g, "");
  let digits = String(number || "").replace(/\D/g, "");

  if (!code || !digits) {
    return "";
  }

  if (digits.startsWith(code)) {
    return digits;
  }

  if (digits.startsWith("0")) {
    digits = digits.slice(1);
  }

  return code + digits;
}

function formatPhone(countryCode, number) {
  const normalized = normalizePhoneForLinks(countryCode, number);
  return normalized ? "+" + normalized : "-";
}

function isMalaysiaCountryCode(countryCode) {
  return cleanCountryCode(countryCode) === "+60";
}

function isValidMalaysiaMobile(number) {
  const digits = String(number || "").replace(/\D/g, "");
  return /^01\d{8,9}$/.test(digits);
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

function normalizeDocumentNames(value) {
  if (Array.isArray(value)) {
    return value.filter(Boolean);
  }

  if (!value) {
    return [];
  }

  return [String(value)];
}

function normalizePhoneHistory(value) {
  if (Array.isArray(value)) {
    return value;
  }

  return [];
}

function readLocalClients() {
  const collected = [];

  LOCAL_STORAGE_KEYS.forEach((key) => {
    try {
      const raw = localStorage.getItem(key);

      if (!raw) {
        return;
      }

      const parsed = JSON.parse(raw);

      if (Array.isArray(parsed)) {
        collected.push(...parsed.map(normalizeClient));
      }
    } catch (error) {
      // Ignore old or invalid local storage records.
    }
  });

  return mergeClients([], collected);
}

function writeLocalClients(list) {
  try {
    localStorage.setItem(PRIMARY_LOCAL_STORAGE_KEY, JSON.stringify(list.map(normalizeClient)));
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
      normalized.phoneNumber ||
      normalized.nricPassportNumber ||
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

  const identificationKind =
    source.identificationKind ||
    source.idType ||
    source.documentIdType ||
    (source.passportNumber ? "Passport" : "Malaysian NRIC");

  const nricPassportNumber =
    source.nricPassportNumber ||
    source.identificationNumber ||
    source.icNumber ||
    source.icNo ||
    source.ic ||
    source.passportNumber ||
    source.passport ||
    "";

  const phoneCountryCode = source.phoneCountryCode || "+60 Malaysia";
  const phoneNumber = source.phoneNumber || source.phone || "";
  const backupPhoneCountryCode = source.backupPhoneCountryCode || "+60 Malaysia";
  const backupPhoneNumber = source.backupPhoneNumber || "";
  const whatsappCountryCode = source.whatsappCountryCode || phoneCountryCode || "+60 Malaysia";
  const whatsappNumber = source.whatsappNumber || source.whatsapp || phoneNumber || "";

  const gender = source.gender || deriveGenderFromIdentification(nricPassportNumber, identificationKind);
  const country = source.country || "Malaysia";

  return {
    ...EMPTY_CLIENT,
    ...source,
    id: getClientId(source) || source.id || "",
    givenName,
    surname,
    initials: source.initials || makeInitials(givenName, surname),
    gender,
    genderSource: source.genderSource || (source.gender ? "manual" : "auto"),
    clientProfileStatus: source.clientProfileStatus || "Adult",
    employmentStatus: source.employmentStatus || "To be confirmed",
    maritalStatus: source.maritalStatus || "To be confirmed",

    ethnicity: source.ethnicity || "",
    ethnicityOther: source.ethnicityOther || "",
    nationality: source.nationality || "",
    residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
    identificationKind,
    nricPassportNumber,

    email: source.email || "",

    phoneCountryCode,
    phoneNumber,
    backupPhoneCountryCode,
    backupPhoneNumber,
    phoneHistory: normalizePhoneHistory(source.phoneHistory),

    whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
    whatsappAvailable: source.whatsappAvailable !== undefined ? Boolean(source.whatsappAvailable) : true,
    whatsappCountryCode,
    whatsappNumber,
    whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
    whatsappCustomMessage: source.whatsappCustomMessage || "",
    hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
    whatsapp2CountryCode: source.whatsapp2CountryCode || "+60 Malaysia",
    whatsapp2Number: source.whatsapp2Number || "",

    preferredContact1: source.preferredContact1 || "WhatsApp Message",
    preferredContact2: source.preferredContact2 || "Phone Call",
    preferredContact3: source.preferredContact3 || "Email",
    preferredContactHoursFrom: source.preferredContactHoursFrom || "09:00",
    preferredContactHoursTo: source.preferredContactHoursTo || "18:00",

    availabilityAway: Boolean(source.availabilityAway),
    availabilityUnreachable: Boolean(source.availabilityUnreachable),
    availabilityOverseas: Boolean(source.availabilityOverseas),
    availabilityOutstation: Boolean(source.availabilityOutstation),
    availabilityUntil: source.availabilityUntil || source.unreachableTo || "",
    availabilityReason: source.availabilityReason || source.unreachableReason || "Not Applicable / N/A",
    availabilityReasonOther: source.availabilityReasonOther || "",
    communicationTimingNotes: source.communicationTimingNotes || source.whatsappNotes || source.preferredContactTimeNote || "",

    emergencyContactName: source.emergencyContactName || "",
    emergencyContactRelationship: source.emergencyContactRelationship || "",
    emergencyContactCountryCode: source.emergencyContactCountryCode || "+60 Malaysia",
    emergencyContactNumber: source.emergencyContactNumber || "",
    emergencyContactEmail: source.emergencyContactEmail || "",
    emergencyContactNotes: source.emergencyContactNotes || "",

    addressType: source.addressType || "Residential",
    country,
    continent: source.continent || COUNTRY_TO_CONTINENT[country] || "Asia",
    buildingHouseNo: source.buildingHouseNo || source.houseNo || "",
    buildingHouseName: source.buildingHouseName || source.buildingName || "",
    postcode: source.postcode || source.postalCode || "",
    streetAddress: source.streetAddress || source.address || "",
    district: source.district || "",
    townCity: source.townCity || source.city || source.town || "",

    documentType: source.documentType || "NRIC",
    documentStatus: source.documentStatus || "Pending Verification",
    documentAttachmentNames: normalizeDocumentNames(source.documentAttachmentNames || source.documentAttachmentName),
    documentReferenceNote: source.documentReferenceNote || "",

    staffLawyerRemarks: source.staffLawyerRemarks || "",
    missingInformationNotes: source.missingInformationNotes || "",
    createdAt: source.createdAt || source.createdOn || source.created || "",
    updatedAt: source.updatedAt || source.modifiedOn || source.changedOn || source.editedOn || ""
  };
}

function makeWhatsappMessage(client) {
  if (client.whatsappMessageTemplate === "Custom message") {
    return client.whatsappCustomMessage || "";
  }

  return WHATSAPP_MESSAGE_TEMPLATES[client.whatsappMessageTemplate] || "";
}

function makeWhatsappLink(countryCode, number, message) {
  const normalized = normalizePhoneForLinks(countryCode, number);

  if (!normalized) {
    return "";
  }

  const text = message ? "?text=" + encodeURIComponent(message) : "";
  return "https://wa.me/" + normalized + text;
}

function getActiveAvailability(client) {
  const normalized = normalizeClient(client);
  const flags = [];

  if (normalized.availabilityUntil) {
    const until = new Date(normalized.availabilityUntil);

    if (!Number.isNaN(until.getTime()) && until.getTime() < Date.now()) {
      return ["Availability expired"];
    }
  }

  if (normalized.availabilityAway) flags.push("Away");
  if (normalized.availabilityUnreachable) flags.push("Unreachable");
  if (normalized.availabilityOverseas) flags.push("Overseas");
  if (normalized.availabilityOutstation) flags.push("Outstation");

  return flags;
}

function buildPayload(form, existingClient) {
  const now = new Date().toISOString();
  const givenName = String(form.givenName || "").trim();
  const surname = String(form.surname || "").trim();
  const fullName = [givenName, surname].filter(Boolean).join(" ");
  const existing = existingClient ? normalizeClient(existingClient) : null;
  const identificationKind = form.identificationKind || "Malaysian NRIC";
  const nricPassportNumber = String(form.nricPassportNumber || "").trim();
  const gender = form.gender || deriveGenderFromIdentification(nricPassportNumber, identificationKind);
  const initials = makeInitials(givenName, surname);

  let phoneHistory = normalizePhoneHistory(form.phoneHistory);

  if (existing && existing.phoneNumber && existing.phoneNumber !== form.phoneNumber) {
    phoneHistory = [
      {
        countryCode: existing.phoneCountryCode,
        number: existing.phoneNumber,
        archivedAt: now,
        reason: "Primary phone number changed"
      },
      ...phoneHistory
    ];
  }

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
    identificationKind,
    nricPassportNumber,
    identificationNumber: nricPassportNumber,
    icNumber: identificationKind.includes("NRIC") ? nricPassportNumber : "",
    icMasked: maskIdentification(nricPassportNumber, identificationKind),
    passportNumber: identificationKind === "Passport" ? nricPassportNumber : "",
    phone: formatPhone(form.phoneCountryCode, form.phoneNumber),
    phoneNumber: form.phoneNumber,
    phoneHistory,
    whatsapp: formatPhone(form.whatsappCountryCode, form.whatsappNumber),
    whatsappNumber: form.whatsappNumber,
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

function RequiredMark() {
  return <span className="field-required">*</span>;
}

function NumberMark() {
  return <span className="field-number">#</span>;
}

export default function Clients() {
  const [clients, setClients] = useState([]);
  const [form, setForm] = useState(EMPTY_CLIENT);
  const [editingId, setEditingId] = useState("");
  const [searchTerm, setSearchTerm] = useState("");
  const [status, setStatus] = useState("");
  const [statusType, setStatusType] = useState("info");
  const [isSaving, setIsSaving] = useState(false);
  const [validationErrors, setValidationErrors] = useState([]);

  const showNationalityField =
    form.ethnicity === "Foreigner" ||
    form.residencyStatus !== "Malaysian Citizen";

  const malaysiaPhoneWarning =
    isMalaysiaCountryCode(form.phoneCountryCode) &&
    form.phoneNumber &&
    !isValidMalaysiaMobile(form.phoneNumber);

  const malaysiaBackupPhoneWarning =
    isMalaysiaCountryCode(form.backupPhoneCountryCode) &&
    form.backupPhoneNumber &&
    !isValidMalaysiaMobile(form.backupPhoneNumber);

  const malaysiaWhatsappWarning =
    isMalaysiaCountryCode(form.whatsappCountryCode) &&
    form.whatsappNumber &&
    !isValidMalaysiaMobile(form.whatsappNumber);

  const whatsappLink = makeWhatsappLink(
    form.whatsappCountryCode,
    form.whatsappNumber,
    makeWhatsappMessage(form)
  );

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

      if (field === "residencyStatus") {
        if (value === "Malaysian Citizen") {
          next.identificationKind = "Malaysian NRIC";
          next.documentType = "NRIC";
          next.phoneCountryCode = "+60 Malaysia";
          next.whatsappCountryCode = "+60 Malaysia";
          next.country = "Malaysia";
          next.continent = "Asia";
        } else if (value === "Singapore Citizen" || value === "Singapore Permanent Resident") {
          next.identificationKind = "Singapore NRIC / FIN";
          next.documentType = "Citizen / PR Proof";
          next.phoneCountryCode = "+65 Singapore";
          next.whatsappCountryCode = "+65 Singapore";
          next.country = "Singapore";
          next.continent = "Asia";
        } else {
          next.identificationKind = "Passport";
          next.documentType = "Passport Bio Page";
        }
      }

      if (field === "identificationKind" || field === "nricPassportNumber") {
        const kind = field === "identificationKind" ? value : previous.identificationKind;
        const idValue = field === "nricPassportNumber" ? value : previous.nricPassportNumber;
        const suggestedGender = deriveGenderFromIdentification(idValue, kind);

        if (previous.genderSource !== "manual") {
          next.gender = suggestedGender;
          next.genderSource = "auto";
        }
      }

      if (field === "gender") {
        next.genderSource = "manual";
      }

      if (field === "country") {
        next.continent = COUNTRY_TO_CONTINENT[value] || previous.continent || "";
      }

      if (field === "phoneCountryCode" && previous.whatsappSameAsPhone) {
        next.whatsappCountryCode = value;
      }

      if (field === "phoneNumber" && previous.whatsappSameAsPhone) {
        next.whatsappNumber = value;
      }

      if (field === "whatsappSameAsPhone") {
        const checked = Boolean(value);
        next.whatsappSameAsPhone = checked;

        if (checked) {
          next.whatsappCountryCode = previous.phoneCountryCode;
          next.whatsappNumber = previous.phoneNumber;
        }
      }

      return next;
    });
  }

  function updateDocumentFiles(event) {
    const files = Array.from(event.target.files || []);
    const names = files.map((file) => file.name);

    setForm((previous) => ({
      ...previous,
      documentAttachmentNames: names
    }));

    if (names.length > 0) {
      showStatus(
        "Document selected and matched to this client form: " + names.join(", ") + ". File contents require secure backend upload storage.",
        "info"
      );
    }
  }

  function resetForm() {
    setForm(EMPTY_CLIENT);
    setValidationErrors([]);
    setEditingId("");
  }

  function validateClientForm(payload) {
    const errors = [];

    if (!payload.givenName.trim()) {
      errors.push("Given Name is required.");
    }

    if (!payload.nricPassportNumber.trim()) {
      errors.push("NRIC No.# / Passport No.# is required.");
    }

    if (showNationalityField && !payload.nationality.trim()) {
      errors.push("Nationality / Country of Origin is required for foreign or non-Malaysian status.");
    }

    if (payload.phoneNumber && isMalaysiaCountryCode(payload.phoneCountryCode) && !isValidMalaysiaMobile(payload.phoneNumber)) {
      errors.push("Primary Malaysian phone number should be digits only and start with 01, example 0123456789.");
    }

    if (payload.backupPhoneNumber && isMalaysiaCountryCode(payload.backupPhoneCountryCode) && !isValidMalaysiaMobile(payload.backupPhoneNumber)) {
      errors.push("Backup Malaysian phone number should be digits only and start with 01, example 0123456789.");
    }

    if (payload.whatsappAvailable && payload.whatsappNumber && isMalaysiaCountryCode(payload.whatsappCountryCode) && !isValidMalaysiaMobile(payload.whatsappNumber)) {
      errors.push("Malaysian WhatsApp number should be digits only and start with 01, example 0123456789.");
    }

    if (payload.hasSecondWhatsapp && !payload.whatsapp2Number.trim()) {
      errors.push("Second WhatsApp number is enabled but empty.");
    }

    return errors;
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

    const formErrors = validateClientForm(form);
    setValidationErrors(formErrors);

    if (formErrors.length > 0) {
      showStatus("Please fix the missing or invalid client details before saving.", "error");
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
          ? "Client modified in the interface and saved locally. Backend database save needs checking."
          : "Client added to the interface and saved locally. Backend database save needs checking.",
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
    setValidationErrors([]);
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
        normalized.clientProfileStatus,
        normalized.employmentStatus,
        normalized.maritalStatus,
        normalized.ethnicity,
        normalized.ethnicityOther,
        normalized.nationality,
        normalized.residencyStatus,
        normalized.identificationKind,
        normalized.nricPassportNumber,
        maskIdentification(normalized.nricPassportNumber, normalized.identificationKind),
        normalized.email,
        normalized.phoneCountryCode,
        normalized.phoneNumber,
        normalized.backupPhoneCountryCode,
        normalized.backupPhoneNumber,
        normalized.whatsappCountryCode,
        normalized.whatsappNumber,
        normalized.preferredContact1,
        normalized.preferredContact2,
        normalized.preferredContact3,
        normalized.emergencyContactName,
        normalized.emergencyContactRelationship,
        normalized.emergencyContactNumber,
        normalized.addressType,
        normalized.country,
        normalized.continent,
        normalized.townCity,
        normalized.district,
        normalized.streetAddress,
        normalized.buildingHouseNo,
        normalized.buildingHouseName,
        normalized.postcode,
        normalized.staffLawyerRemarks
      ]
        .filter(Boolean)
        .join(" ")
        .toLowerCase();

      return searchable.includes(query);
    });
  }, [clients, searchTerm]);

  return (
    <section className="client-module client-v4">
      <div className="client-module-header">
        <div>
          <h2>Client Registration / Client Details</h2>
          <p>
            Clean professional client profile, contact numbers, communication preferences,
            address, emergency contact and remarks.
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

      {validationErrors.length > 0 && (
        <div className="client-validation-box">
          <strong>Missing / Invalid Details</strong>
          <ul>
            {validationErrors.map((error) => (
              <li key={error}>{error}</li>
            ))}
          </ul>
        </div>
      )}

      <form className="client-form client-form-v4" onSubmit={saveClient}>
        <div className="form-section">
          <h3>1. Client's Details</h3>

          <div className="smart-grid two">
            <label>
              Given Name <RequiredMark />
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
              Gender
              <select
                value={form.gender}
                onChange={(event) => updateForm("gender", event.target.value)}
              >
                {["Auto / Select", "Male", "Female", "Not specified", ...N_A_OPTIONS].map((option) => (
                  <option key={option} value={option === "Auto / Select" ? "" : option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>

            <label>
              Client Profile Status
              <select
                value={form.clientProfileStatus}
                onChange={(event) => updateForm("clientProfileStatus", event.target.value)}
              >
                {CLIENT_PROFILE_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Employment / Occupation Status
              <select
                value={form.employmentStatus}
                onChange={(event) => updateForm("employmentStatus", event.target.value)}
              >
                {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Marital / Family Status
              <select
                value={form.maritalStatus}
                onChange={(event) => updateForm("maritalStatus", event.target.value)}
              >
                {MARITAL_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
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

            <label>
              Immigration / Documented Status
              <select
                value={form.residencyStatus}
                onChange={(event) => updateForm("residencyStatus", event.target.value)}
              >
                {RESIDENCY_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
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

            <label>
              ID Type
              <select
                value={form.identificationKind}
                onChange={(event) => updateForm("identificationKind", event.target.value)}
              >
                {IDENTIFICATION_KIND_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              NRIC No.# / Passport No.# <RequiredMark /> <NumberMark />
              <input
                value={form.nricPassportNumber}
                onChange={(event) => updateForm("nricPassportNumber", event.target.value)}
                placeholder="Enter NRIC or Passport No.#"
                required
              />
              <small>NRIC is masked in the table. Passport is partially masked.</small>
            </label>

            <label className="full">
              Email Address
              <input
                type="email"
                value={form.email}
                onChange={(event) => updateForm("email", event.target.value)}
                placeholder="client@example.com"
              />
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3>2. Phone, WhatsApp and Contact Preference</h3>

          <div className="smart-grid two">
            <label className="phone-line full">
              Primary Phone Number <NumberMark />
              <div className="inline-fields code-and-number">
                <input
                  list="client-country-code-options"
                  value={form.phoneCountryCode}
                  onChange={(event) => updateForm("phoneCountryCode", event.target.value)}
                  placeholder="+60 Malaysia"
                />
                <input
                  value={form.phoneNumber}
                  onChange={(event) => updateForm("phoneNumber", event.target.value)}
                  placeholder="0123456789"
                />
              </div>
              <small>Malaysia mobile format: 0123456789, digits only, no spaces or dashes.</small>
              {malaysiaPhoneWarning && (
                <small className="field-warning">Check format: Malaysian mobile numbers should start with 01.</small>
              )}
            </label>

            <label className="phone-line full">
              Secondary / Backup Phone Number <NumberMark />
              <div className="inline-fields code-and-number">
                <input
                  list="client-country-code-options"
                  value={form.backupPhoneCountryCode}
                  onChange={(event) => updateForm("backupPhoneCountryCode", event.target.value)}
                  placeholder="+60 Malaysia"
                />
                <input
                  value={form.backupPhoneNumber}
                  onChange={(event) => updateForm("backupPhoneNumber", event.target.value)}
                  placeholder="Backup phone, if any"
                />
              </div>
              <small>Use for overseas clients, foreign number, office number, or fallback contact.</small>
              {malaysiaBackupPhoneWarning && (
                <small className="field-warning">Check format: Malaysian backup mobile numbers should start with 01.</small>
              )}
            </label>

            <label className="checkbox-tile">
              <input
                type="checkbox"
                checked={form.whatsappSameAsPhone}
                onChange={(event) => updateForm("whatsappSameAsPhone", event.target.checked)}
              />
              WhatsApp number same as phone number
            </label>

            <label className="checkbox-tile">
              <input
                type="checkbox"
                checked={form.whatsappAvailable}
                onChange={(event) => updateForm("whatsappAvailable", event.target.checked)}
              />
              WhatsApp Available / Connected
            </label>

            {!form.whatsappSameAsPhone && (
              <label className="phone-line full">
                WhatsApp Number <NumberMark />
                <div className="inline-fields code-and-number">
                  <input
                    list="client-country-code-options"
                    value={form.whatsappCountryCode}
                    onChange={(event) => updateForm("whatsappCountryCode", event.target.value)}
                    placeholder="+60 Malaysia"
                  />
                  <input
                    value={form.whatsappNumber}
                    onChange={(event) => updateForm("whatsappNumber", event.target.value)}
                    placeholder="WhatsApp number"
                  />
                </div>
                {malaysiaWhatsappWarning && (
                  <small className="field-warning">Check format: Malaysian WhatsApp number should start with 01.</small>
                )}
              </label>
            )}

            <label className="checkbox-tile full">
              <input
                type="checkbox"
                checked={form.hasSecondWhatsapp}
                onChange={(event) => updateForm("hasSecondWhatsapp", event.target.checked)}
              />
              Client has another WhatsApp / overseas mobile number
            </label>

            {form.hasSecondWhatsapp && (
              <label className="phone-line full">
                Second WhatsApp Number <NumberMark />
                <div className="inline-fields code-and-number">
                  <input
                    list="client-country-code-options"
                    value={form.whatsapp2CountryCode}
                    onChange={(event) => updateForm("whatsapp2CountryCode", event.target.value)}
                    placeholder="+60 Malaysia"
                  />
                  <input
                    value={form.whatsapp2Number}
                    onChange={(event) => updateForm("whatsapp2Number", event.target.value)}
                    placeholder="Second WhatsApp number"
                  />
                </div>
              </label>
            )}

            <label>
              WhatsApp Message Template
              <select
                value={form.whatsappMessageTemplate}
                onChange={(event) => updateForm("whatsappMessageTemplate", event.target.value)}
              >
                {Object.keys(WHATSAPP_MESSAGE_TEMPLATES).map((template) => (
                  <option key={template} value={template}>{template}</option>
                ))}
              </select>
            </label>

            <label>
              Open WhatsApp Web
              {whatsappLink && form.whatsappAvailable ? (
                <a className="action-link" href={whatsappLink} target="_blank" rel="noreferrer">
                  Open WhatsApp Draft
                </a>
              ) : (
                <span className="muted-box">WhatsApp link unavailable</span>
              )}
            </label>

            {form.whatsappMessageTemplate === "Custom message" && (
              <label className="full">
                Custom WhatsApp Message
                <textarea
                  value={form.whatsappCustomMessage}
                  onChange={(event) => updateForm("whatsappCustomMessage", event.target.value)}
                  placeholder="Type custom WhatsApp message."
                />
              </label>
            )}

            <label>
              1st Contact Choice
              <select
                value={form.preferredContact1}
                onChange={(event) => updateForm("preferredContact1", event.target.value)}
              >
                {CONTACT_METHOD_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              2nd Contact Choice
              <select
                value={form.preferredContact2}
                onChange={(event) => updateForm("preferredContact2", event.target.value)}
              >
                {CONTACT_METHOD_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              3rd Contact Choice
              <select
                value={form.preferredContact3}
                onChange={(event) => updateForm("preferredContact3", event.target.value)}
              >
                {CONTACT_METHOD_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Contact Hours
              <div className="inline-fields two-even">
                <input
                  type="time"
                  value={form.preferredContactHoursFrom}
                  onChange={(event) => updateForm("preferredContactHoursFrom", event.target.value)}
                />
                <input
                  type="time"
                  value={form.preferredContactHoursTo}
                  onChange={(event) => updateForm("preferredContactHoursTo", event.target.value)}
                />
              </div>
            </label>

            <div className="status-checks full">
              <span>Availability Status</span>
              <label><input type="checkbox" checked={form.availabilityAway} onChange={(event) => updateForm("availabilityAway", event.target.checked)} /> Away</label>
              <label><input type="checkbox" checked={form.availabilityUnreachable} onChange={(event) => updateForm("availabilityUnreachable", event.target.checked)} /> Unreachable</label>
              <label><input type="checkbox" checked={form.availabilityOverseas} onChange={(event) => updateForm("availabilityOverseas", event.target.checked)} /> Overseas</label>
              <label><input type="checkbox" checked={form.availabilityOutstation} onChange={(event) => updateForm("availabilityOutstation", event.target.checked)} /> Outstation</label>
            </div>

            <label>
              Availability Until
              <input
                type="datetime-local"
                value={form.availabilityUntil}
                onChange={(event) => updateForm("availabilityUntil", event.target.value)}
              />
              <small>After this date/time, the status is treated as expired.</small>
            </label>

            <label>
              Reason
              <select
                value={form.availabilityReason}
                onChange={(event) => updateForm("availabilityReason", event.target.value)}
              >
                {AVAILABILITY_REASON_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            {form.availabilityReason === "Other" && (
              <label className="full">
                Other Reason
                <input
                  value={form.availabilityReasonOther}
                  onChange={(event) => updateForm("availabilityReasonOther", event.target.value)}
                  placeholder="Enter reason"
                />
              </label>
            )}

            <label className="full">
              Contact / Communication Timing Notes
              <textarea
                value={form.communicationTimingNotes}
                onChange={(event) => updateForm("communicationTimingNotes", event.target.value)}
                placeholder="Example: Only reachable after 6pm, WhatsApp only, abroad number active on weekends, call assistant first."
              />
            </label>

            {form.phoneHistory.length > 0 && (
              <div className="history-box full">
                <strong>Phone Number History</strong>
                {form.phoneHistory.map((item, index) => (
                  <p key={index}>
                    {formatPhone(item.countryCode, item.number)} archived on {formatDateTime(item.archivedAt)}
                  </p>
                ))}
              </div>
            )}
          </div>
        </div>

        <div className="form-section">
          <h3>3. Address Details</h3>

          <div className="smart-grid two">
            <label>
              Address Type
              <select
                value={form.addressType}
                onChange={(event) => updateForm("addressType", event.target.value)}
              >
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

            <label>
              Building / House No.# and Postcode No.# <NumberMark />
              <div className="inline-fields two-even">
                <input
                  value={form.buildingHouseNo}
                  onChange={(event) => updateForm("buildingHouseNo", event.target.value)}
                  placeholder="House / unit no."
                />
                <input
                  value={form.postcode}
                  onChange={(event) => updateForm("postcode", event.target.value)}
                  placeholder="Postcode"
                />
              </div>
            </label>

            <label>
              Building / House Name
              <input
                value={form.buildingHouseName}
                onChange={(event) => updateForm("buildingHouseName", event.target.value)}
                placeholder="Building / house name, if any"
              />
            </label>

            <label className="full">
              Street Address
              <input
                value={form.streetAddress}
                onChange={(event) => updateForm("streetAddress", event.target.value)}
                placeholder="Street address"
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
              Town / City
              <input
                value={form.townCity}
                onChange={(event) => updateForm("townCity", event.target.value)}
                placeholder="Town / City"
              />
            </label>

            <label>
              Continent
              <select
                value={form.continent}
                onChange={(event) => updateForm("continent", event.target.value)}
              >
                {CONTINENT_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3>4. Next of Kin / Emergency Contact</h3>

          <div className="smart-grid two">
            <label>
              Emergency Contact Name
              <input
                value={form.emergencyContactName}
                onChange={(event) => updateForm("emergencyContactName", event.target.value)}
                placeholder="Name"
              />
            </label>

            <label>
              Relationship
              <input
                value={form.emergencyContactRelationship}
                onChange={(event) => updateForm("emergencyContactRelationship", event.target.value)}
                placeholder="Example: spouse, parent, sibling"
              />
            </label>

            <label className="full">
              Emergency Contact Number <NumberMark />
              <div className="inline-fields code-and-number">
                <input
                  list="client-country-code-options"
                  value={form.emergencyContactCountryCode}
                  onChange={(event) => updateForm("emergencyContactCountryCode", event.target.value)}
                  placeholder="+60 Malaysia"
                />
                <input
                  value={form.emergencyContactNumber}
                  onChange={(event) => updateForm("emergencyContactNumber", event.target.value)}
                  placeholder="Emergency contact number"
                />
              </div>
            </label>

            <label>
              Emergency Contact Email
              <input
                type="email"
                value={form.emergencyContactEmail}
                onChange={(event) => updateForm("emergencyContactEmail", event.target.value)}
                placeholder="email@example.com"
              />
            </label>

            <label className="full">
              Emergency Contact Notes
              <textarea
                value={form.emergencyContactNotes}
                onChange={(event) => updateForm("emergencyContactNotes", event.target.value)}
                placeholder="When to contact, authority to contact, or restrictions."
              />
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3>5. Identification Document and Remarks</h3>

          <div className="smart-grid two">
            <label>
              Document Type
              <select
                value={form.documentType}
                onChange={(event) => updateForm("documentType", event.target.value)}
              >
                {DOCUMENT_TYPE_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Document Status
              <select
                value={form.documentStatus}
                onChange={(event) => updateForm("documentStatus", event.target.value)}
              >
                {DOCUMENT_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="full">
              Attach Scanned Copy / Digital Copy
              <input
                type="file"
                multiple
                accept=".pdf,.png,.jpg,.jpeg,.webp"
                onChange={(event) => {
                  const files = Array.from(event.target.files || []);
                  const names = files.map((file) => file.name);
                  updateForm("documentAttachmentNames", names);
                  if (names.length > 0) {
                    showStatus("Document selected for this client: " + names.join(", ") + ". Secure file storage needs backend upload support.", "info");
                  }
                }}
              />
              <small>File names are matched to the client record. Actual secure document storage needs backend upload support.</small>
            </label>

            <label className="full">
              Document Reference Note
              <textarea
                value={form.documentReferenceNote}
                onChange={(event) => updateForm("documentReferenceNote", event.target.value)}
                placeholder="Example: NRIC front/back received, passport page pending."
              />
            </label>

            <label className="full important-notes">
              Special Remarks / Staff-Lawyer Notes
              <textarea
                value={form.staffLawyerRemarks}
                onChange={(event) => updateForm("staffLawyerRemarks", event.target.value)}
                placeholder="Important facts staff/lawyers must notice: contact restrictions, sensitivity, urgent matter, client preference, legal risk, unusual instruction."
              />
            </label>

            <label className="full">
              Missing / N/A / Unknown Information Notes
              <textarea
                value={form.missingInformationNotes}
                onChange={(event) => updateForm("missingInformationNotes", event.target.value)}
                placeholder="Record why a field is N/A, unknown, unavailable, or to be confirmed."
              />
            </label>
          </div>
        </div>

        <datalist id="client-country-code-options">
          {COUNTRY_CODE_OPTIONS.map((countryCode) => (
            <option key={countryCode} value={countryCode} />
          ))}
        </datalist>

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
            placeholder="Search name, initials, NRIC/passport, phone, WhatsApp, email, status, remarks or emergency contact"
          />
        </label>
      </div>

      <div className="client-table-wrap">
        <table className="client-table">
          <thead>
            <tr>
              <th>Given Name</th>
              <th>Surname</th>
              <th>Profile</th>
              <th>Status</th>
              <th>IC / Passport</th>
              <th>Email</th>
              <th>Primary Phone</th>
              <th>Backup Phone</th>
              <th>WhatsApp</th>
              <th>Preferred Contact</th>
              <th>Availability</th>
              <th>Address</th>
              <th>Emergency Contact</th>
              <th>Remarks</th>
              <th>Created On</th>
              <th>Modified On</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {filteredClients.length === 0 && (
              <tr>
                <td colSpan="17">
                  {clients.length === 0
                    ? "No clients have been added yet."
                    : "No matching clients found. Clear Client Search to show all clients."}
                </td>
              </tr>
            )}

            {filteredClients.map((client) => {
              const normalized = normalizeClient(client);
              const id = getClientId(normalized);
              const phoneForLinks = normalizePhoneForLinks(normalized.phoneCountryCode, normalized.phoneNumber);
              const backupPhoneForLinks = normalizePhoneForLinks(normalized.backupPhoneCountryCode, normalized.backupPhoneNumber);
              const whatsappForLinks = normalizePhoneForLinks(normalized.whatsappCountryCode, normalized.whatsappNumber);
              const emergencyPhoneForLinks = normalizePhoneForLinks(normalized.emergencyContactCountryCode, normalized.emergencyContactNumber);
              const mailTo = normalized.email ? "mailto:" + normalized.email : "";
              const telLink = phoneForLinks ? "tel:+" + phoneForLinks : "";
              const backupTelLink = backupPhoneForLinks ? "tel:+" + backupPhoneForLinks : "";
              const whatsappDraftLink = makeWhatsappLink(normalized.whatsappCountryCode, normalized.whatsappNumber, makeWhatsappMessage(normalized));
              const emergencyTelLink = emergencyPhoneForLinks ? "tel:+" + emergencyPhoneForLinks : "";
              const activeAvailability = getActiveAvailability(normalized);
              const address = [
                normalized.buildingHouseNo,
                normalized.buildingHouseName,
                normalized.streetAddress,
                normalized.district,
                normalized.townCity,
                normalized.postcode,
                normalized.country
              ].filter(Boolean).join(", ");

              return (
                <tr key={id || normalized.email || normalized.phoneNumber || normalized.nricPassportNumber}>
                  <td>{normalized.givenName || "-"}</td>
                  <td>{normalized.surname || "-"}</td>
                  <td>
                    {normalized.clientProfileStatus || "-"}
                    <br />
                    {normalized.employmentStatus || "-"}
                    <br />
                    {normalized.maritalStatus || "-"}
                  </td>
                  <td>{normalized.residencyStatus || "-"}</td>
                  <td>{maskIdentification(normalized.nricPassportNumber, normalized.identificationKind)}</td>
                  <td>
                    {normalized.email ? (
                      <a href={mailTo}>{normalized.email}</a>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td>
                    {phoneForLinks ? (
                      <a href={telLink}>{formatPhone(normalized.phoneCountryCode, normalized.phoneNumber)}</a>
                    ) : (
                      "-"
                    )}
                  </td>
                  <td>
                    {backupPhoneForLinks ? (
                      <a href={backupTelLink}>{formatPhone(normalized.backupPhoneCountryCode, normalized.backupPhoneNumber)}</a>
                    ) : (
                      "-"
                    )}
                    {normalized.phoneHistory.length > 0 && (
                      <>
                        <br />
                        History: {normalized.phoneHistory.length}
                      </>
                    )}
                  </td>
                  <td>
                    {normalized.whatsappAvailable && whatsappForLinks ? (
                      <a href={whatsappDraftLink} target="_blank" rel="noreferrer">
                        WhatsApp Draft
                      </a>
                    ) : (
                      "Not available"
                    )}
                  </td>
                  <td>
                    1st: {normalized.preferredContact1 || "-"}
                    <br />
                    2nd: {normalized.preferredContact2 || "-"}
                    <br />
                    {normalized.preferredContactHoursFrom || "-"} to {normalized.preferredContactHoursTo || "-"}
                  </td>
                  <td>
                    {activeAvailability.length ? activeAvailability.join(", ") : "-"}
                    {normalized.availabilityUntil && (
                      <>
                        <br />
                        Until: {formatDateTime(normalized.availabilityUntil)}
                      </>
                    )}
                  </td>
                  <td>{address || "-"}</td>
                  <td>
                    {normalized.emergencyContactName || "-"}
                    {emergencyPhoneForLinks && (
                      <>
                        <br />
                        <a href={emergencyTelLink}>
                          {formatPhone(normalized.emergencyContactCountryCode, normalized.emergencyContactNumber)}
                        </a>
                      </>
                    )}
                  </td>
                  <td>{normalized.staffLawyerRemarks || "-"}</td>
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
        * required field. # number-based field. NRIC/IC is masked in the table. Phone history is retained when an existing primary phone number is changed. Secure scanned document content storage requires backend upload support.
      </p>
    </section>
  );
}
'@

[System.IO.File]::WriteAllText($ClientsPath, $ClientsCode, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Clients.jsx replaced with professional V4 simplified form."

$Css = [System.IO.File]::ReadAllText($CssPath)

$MarkerStart = "/* L360 CLIENT CONTACT FORM V4 START */"
$MarkerEnd = "/* L360 CLIENT CONTACT FORM V4 END */"

$CssBlock = @'

/* L360 CLIENT CONTACT FORM V4 START */

.client-v4,
.client-v4 * {
  box-sizing: border-box !important;
}

.client-v4 {
  width: 100% !important;
  max-width: none !important;
  font-size: 13px !important;
  line-height: 1.35 !important;
  color: #142033 !important;
}

.client-v4 h2 {
  font-size: 22px !important;
  line-height: 1.2 !important;
  margin: 0 0 4px !important;
}

.client-v4 p {
  font-size: 12.5px !important;
  line-height: 1.35 !important;
}

.client-form-v4 {
  width: 100% !important;
  max-width: 100% !important;
  overflow: hidden !important;
  padding: 18px !important;
  border: 1px solid #d7dce5 !important;
  border-radius: 14px !important;
  background: #ffffff !important;
}

.client-form-v4 .form-section {
  margin-bottom: 20px !important;
}

.client-form-v4 h3 {
  margin: 0 0 14px !important;
  padding: 9px 12px !important;
  border-left: 4px solid #0b3b6f !important;
  background: #f4f7fb !important;
  border-radius: 8px !important;
  font-size: 16px !important;
  line-height: 1.25 !important;
  font-weight: 800 !important;
  color: #142033 !important;
}

.client-form-v4 .smart-grid {
  display: grid !important;
  gap: 14px 18px !important;
  align-items: start !important;
  width: 100% !important;
}

.client-form-v4 .smart-grid.two {
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
}

.client-form-v4 .smart-grid > * {
  min-width: 0 !important;
  max-width: 100% !important;
}

.client-form-v4 .full {
  grid-column: 1 / -1 !important;
}

.client-form-v4 label {
  display: flex !important;
  flex-direction: column !important;
  gap: 6px !important;
  min-width: 0 !important;
  font-size: 12.5px !important;
  line-height: 1.25 !important;
  font-weight: 800 !important;
  color: #142033 !important;
}

.client-form-v4 input,
.client-form-v4 select,
.client-form-v4 textarea {
  width: 100% !important;
  min-width: 0 !important;
  max-width: 100% !important;
  min-height: 38px !important;
  padding: 8px 10px !important;
  border: 1px solid #cbd3df !important;
  border-radius: 8px !important;
  background: #ffffff !important;
  font-size: 13px !important;
  line-height: 1.3 !important;
  font-weight: 600 !important;
  color: #142033 !important;
}

.client-form-v4 textarea {
  min-height: 82px !important;
  resize: vertical !important;
}

.client-form-v4 small {
  display: block !important;
  font-size: 11.25px !important;
  line-height: 1.3 !important;
  font-weight: 500 !important;
  color: #586579 !important;
}

.client-form-v4 .inline-fields {
  display: grid !important;
  gap: 10px !important;
  width: 100% !important;
}

.client-form-v4 .code-and-number {
  grid-template-columns: minmax(150px, 0.36fr) minmax(180px, 0.64fr) !important;
}

.client-form-v4 .two-even {
  grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
}

.client-form-v4 .checkbox-tile,
.client-form-v4 .status-checks {
  border: 1px solid #e1e7f0 !important;
  border-radius: 10px !important;
  padding: 10px 12px !important;
  background: #fbfcfe !important;
}

.client-form-v4 .checkbox-tile {
  flex-direction: row !important;
  align-items: center !important;
  gap: 10px !important;
  min-height: 42px !important;
}

.client-form-v4 .checkbox-tile input[type="checkbox"],
.client-form-v4 .status-checks input[type="checkbox"] {
  width: 17px !important;
  height: 17px !important;
  min-height: 17px !important;
  flex: 0 0 auto !important;
  margin: 0 !important;
}

.client-form-v4 .status-checks {
  display: grid !important;
  grid-template-columns: 150px repeat(4, minmax(120px, 1fr)) !important;
  align-items: center !important;
  gap: 10px !important;
}

.client-form-v4 .status-checks span {
  font-weight: 800 !important;
}

.client-form-v4 .status-checks label {
  flex-direction: row !important;
  align-items: center !important;
  gap: 8px !important;
}

.client-form-v4 .action-link,
.client-form-v4 .muted-box {
  display: flex !important;
  align-items: center !important;
  min-height: 38px !important;
  padding: 8px 10px !important;
  border-radius: 8px !important;
  text-decoration: none !important;
  font-weight: 800 !important;
}

.client-form-v4 .action-link {
  border: 1px solid #0b6bcb !important;
  background: #eef6ff !important;
}

.client-form-v4 .muted-box {
  border: 1px solid #d7dce5 !important;
  background: #f7f9fc !important;
  color: #6b7280 !important;
}

.client-form-v4 .important-notes textarea {
  min-height: 110px !important;
  border-color: #d3a12f !important;
  background: #fffaf0 !important;
}

.client-form-v4 .history-box {
  padding: 10px 12px !important;
  border: 1px dashed #9aa8ba !important;
  border-radius: 10px !important;
  background: #f7f9fc !important;
}

.client-form-v4 .history-box p {
  margin: 6px 0 0 !important;
}

.client-form-actions {
  display: flex !important;
  gap: 10px !important;
  margin-top: 18px !important;
  flex-wrap: wrap !important;
}

.client-form-actions button {
  min-width: 132px !important;
  min-height: 36px !important;
  padding: 8px 12px !important;
  font-size: 13px !important;
  font-weight: 800 !important;
}

.field-required {
  color: #b00020 !important;
  font-weight: 900 !important;
}

.field-number {
  color: #0b3b6f !important;
  font-weight: 900 !important;
}

.field-warning {
  color: #a15c00 !important;
  font-weight: 800 !important;
}

.client-table-wrap {
  overflow-x: auto !important;
}

.client-table {
  width: max-content !important;
  min-width: 100% !important;
  table-layout: auto !important;
}

.client-table th {
  white-space: nowrap !important;
  font-size: 12.75px !important;
}

.client-table td {
  font-size: 12.25px !important;
  max-width: 280px !important;
}

@media (max-width: 1000px) {
  .client-form-v4 .smart-grid.two {
    grid-template-columns: 1fr !important;
  }

  .client-form-v4 .code-and-number,
  .client-form-v4 .two-even,
  .client-form-v4 .status-checks {
    grid-template-columns: 1fr !important;
  }

  .client-form-v4 .full {
    grid-column: 1 / -1 !important;
  }
}

/* L360 CLIENT CONTACT FORM V4 END */
'@

if ($Css.Contains($MarkerStart)) {
    $Pattern = [regex]::Escape($MarkerStart) + "(?s).*?" + [regex]::Escape($MarkerEnd)
    $Css = [regex]::Replace($Css, $Pattern, $CssBlock.Trim())
} else {
    $Css = $Css.TrimEnd() + "`r`n" + $CssBlock
}

[System.IO.File]::WriteAllText($CssPath, $Css, (New-Object System.Text.UTF8Encoding($false)))
Write-Pass "Client contact form V4 CSS applied."

$ReportFolder = Join-Path $ProjectRoot "_LEOS_CONTROL\reports"
New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null

$ReportPath = Join-Path $ReportFolder "CLIENT-CONTACT-FORM-V4-REPORT-$Stamp.md"

$Report = @"
# Client Contact Form V4 Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Modified:
$ClientsPath
$CssPath

Backups:
$ClientsBackup
$CssBackup

## Implemented

- Removed Phone Info Status.
- Removed WhatsApp Info Status.
- Simplified primary phone field into country code + number.
- Added secondary/backup phone.
- Added phone history tracking when existing primary phone changes.
- Added WhatsApp same-as-phone checkbox.
- Added WhatsApp Available / Connected checkbox.
- Added WhatsApp Web draft link with selectable message template.
- Consolidated communication notes into one field.
- Added Away, Unreachable, Overseas, Outstation availability flags.
- Added availability expiry date/time.
- Added reason dropdown with N/A, Funeral, Family Holiday, Personal, Business, Other, etc.
- Added client profile, employment and marital/family statuses.
- Added special staff/lawyer remarks section.
- Fixed form order into professional sequence.
- Added N/A options in dropdown/select lists.
- Improved layout with controlled 2-column form sections.

## Safety

App.jsx modified: NO
Backend modified: NO
Database modified: NO
Files deleted: NO
"@

[System.IO.File]::WriteAllText($ReportPath, $Report, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Pass "CLIENT CONTACT FORM V4 COMPLETE"
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

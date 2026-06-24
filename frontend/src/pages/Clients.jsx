import { useEffect, useMemo, useState } from "react";

const API_URL = "/api/clients";

const LOCAL_STORAGE_KEYS = [
  "litigation360.clients.profile.v6",
  "litigation360.clients.profile.v5",
  "litigation360.clients.contactForm.v4",
  "litigation360.clients.contactForm.v3",
  "litigation360.clients.registration.v2",
  "litigation360.clients.localFallback.v1"
];

const PRIMARY_LOCAL_STORAGE_KEY = LOCAL_STORAGE_KEYS[0];

const EMPTY_CLIENT = {
  id: "",

  titlePrefix: "",
  titleSuffix: "Not Applicable / N/A",
  titleGenderOverride: false,
  titleOverrideReason: "",

  givenName: "",
  surname: "",
  initials: "",

  gender: "",
  genderSource: "auto",
  dateOfBirth: "",
  age: "",
  ageCategory: "",
  generation: "",
  stateOfBirth: "",

  employmentStatus: "To be confirmed",
  maritalStatus: "To be confirmed",

  ethnicity: "",
  ethnicityOther: "",
  nationality: "",
  residencyStatus: "Malaysian Citizen",
  identificationKind: "Malaysian NRIC",
  identityCardColour: "Blue - Malaysian Citizen / MyKad",
  nricPassportNumber: "",

  email: "",

  phoneCountryCode: "+60 Malaysia",
  phoneNumber: "",
  backupPhoneCountryCode: "+60 Malaysia",
  backupPhoneNumber: "",
  phoneHistory: [],

  whatsappSameAsPhone: true,
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

  unavailableUntilDate: "",
  unavailableUntilTime: "",
  unavailableUntil: "",
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
  region: "Asia - Southeast Asia",
  buildingHouseNo: "",
  buildingHouseName: "",
  postcode: "",
  streetAddress: "",
  district: "",
  townCity: "",

  documentType: "NRIC",
  documentStatus: "Pending Verification",
  documentAttachmentNames: [],
  documentReferenceNotes: "",
  documentRelatedReferenceNotes: "",

  staffLawyerRemarks: "",
  specialRemarksStaffLawyerNotes: "",
  missingInformationNotes: "",

  verificationStatus: "Pending Review",
  verificationFlags: [],
  auditTrail: [],

  createdAt: "",
  updatedAt: ""
};

const TITLE_PREFIX_OPTIONS = [
  "Not Applicable / N/A",
  "Mr",
  "Ms",
  "Mrs",
  "Miss",
  "Mdm",
  "Cik",
  "Puan",
  "Encik",
  "Tuan",
  "Dr",
  "Prof.",
  "Assoc. Prof.",
  "Ir.",
  "Ts.",
  "Haji",
  "Hajah",
  "Dato",
  "Dato'",
  "Dato' Seri",
  "Dato' Sri",
  "Datuk",
  "Datuk Seri",
  "Datuk Sri",
  "Datin",
  "Datin Seri",
  "Datin Sri",
  "Tan Sri",
  "Puan Sri",
  "Tun",
  "Toh Puan",
  "YB",
  "YBhg",
  "Justice",
  "Other / Manual"
];

const TITLE_SUFFIX_OPTIONS = [
  "Not Applicable / N/A",
  "JP",
  "PJK",
  "AMN",
  "KMN",
  "PMP",
  "PIS",
  "PBM",
  "Other / Manual",
  "Unknown",
  "To be confirmed"
];

const MALE_TITLE_PREFIXES = new Set([
  "Mr",
  "Encik",
  "Tuan",
  "Dato",
  "Dato'",
  "Dato' Seri",
  "Dato' Sri",
  "Datuk",
  "Datuk Seri",
  "Datuk Sri",
  "Tan Sri",
  "Haji"
]);

const FEMALE_TITLE_PREFIXES = new Set([
  "Ms",
  "Mrs",
  "Miss",
  "Mdm",
  "Cik",
  "Puan",
  "Datin",
  "Datin Seri",
  "Datin Sri",
  "Puan Sri",
  "Toh Puan",
  "Hajah"
]);

const NEUTRAL_TITLE_PREFIXES = new Set([
  "Not Applicable / N/A",
  "Dr",
  "Prof.",
  "Assoc. Prof.",
  "Ir.",
  "Ts.",
  "Tun",
  "YB",
  "YBhg",
  "Justice",
  "Other / Manual"
]);

const IDENTITY_CARD_COLOUR_OPTIONS = [
  "Not Applicable / N/A",
  "Blue - Malaysian Citizen / MyKad",
  "Red - Permanent Resident",
  "Green - Temporary Resident / MyKAS",
  "Passport / Foreign Travel Document",
  "Singapore NRIC / FIN",
  "Unknown",
  "To be confirmed"
];

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

const RESIDENCY_STATUS_OPTIONS = [
  "Not Applicable / N/A",
  "Malaysian Citizen",
  "Malaysia Permanent Resident",
  "Temporary Resident / MyKAS",
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

const REVIEW_STATUS_OPTIONS = [
  "Pending Review",
  "Verified",
  "Review Required",
  "Discrepancy Detected",
  "Documents Pending",
  "Rejected / Needs Correction"
];

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
const WHATSAPP_MESSAGE_TEMPLATES = {
  "General follow-up": "Hello, this is a follow-up regarding your matter. Please let us know when you are available.",
  "Appointment reminder": "Hello, this is a reminder regarding your upcoming appointment. Please confirm your availability.",
  "Document request": "Hello, we require your documents for your matter. Please send them when available.",
  "Payment follow-up": "Hello, this is a follow-up regarding payment for your matter. Please contact us when available.",
  "Custom message": ""
};


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
    return "************";
  }

  if (raw.length <= 4) {
    return "****";
  }

  return raw.charAt(0) + "****" + raw.slice(-3);
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

function parseNricDob(value, kind) {
  if (!isNricKind(kind)) {
    return "";
  }

  const digits = String(value || "").replace(/\D/g, "");

  if (digits.length < 6) {
    return "";
  }

  const yy = Number(digits.slice(0, 2));
  const mm = Number(digits.slice(2, 4));
  const dd = Number(digits.slice(4, 6));

  if (!Number.isInteger(yy) || !Number.isInteger(mm) || !Number.isInteger(dd)) {
    return "";
  }

  if (mm < 1 || mm > 12 || dd < 1 || dd > 31) {
    return "";
  }

  const now = new Date();
  const currentYY = Number(String(now.getFullYear()).slice(-2));
  const fullYear = yy <= currentYY ? 2000 + yy : 1900 + yy;
  const date = new Date(fullYear, mm - 1, dd);

  if (
    date.getFullYear() !== fullYear ||
    date.getMonth() !== mm - 1 ||
    date.getDate() !== dd
  ) {
    return "";
  }

  return [
    String(fullYear).padStart(4, "0"),
    String(mm).padStart(2, "0"),
    String(dd).padStart(2, "0")
  ].join("-");
}


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

  if (
    safeCountry === "Malaysia" ||
    safeCountry === "Singapore" ||
    safeCountry === "Brunei" ||
    safeCountry === "Indonesia" ||
    safeCountry === "Thailand" ||
    safeCountry === "Philippines" ||
    safeCountry === "Vietnam"
  ) {
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
function formatDateDisplay(value) {
  if (!value) {
    return "";
  }

  const parts = String(value).split("-");

  if (parts.length !== 3) {
    return value;
  }

  return parts[2] + "/" + parts[1] + "/" + parts[0];
}

function calculateAge(dateOfBirth) {
  if (!dateOfBirth) {
    return "";
  }

  const birthDate = new Date(dateOfBirth);
  const today = new Date();

  if (Number.isNaN(birthDate.getTime())) {
    return "";
  }

  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();

  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
    age -= 1;
  }

  return age >= 0 ? String(age) : "";
}

function getAgeCategory(ageValue) {
  const age = Number(ageValue);

  if (!Number.isFinite(age)) {
    return "";
  }

  if (age < 18) {
    return "Minor - Not eligible";
  }

  if (age >= 60) {
    return "Senior Citizen";
  }

  return "Adult";
}

function getGeneration(dateOfBirth) {
  if (!dateOfBirth) {
    return "";
  }

  const year = new Date(dateOfBirth).getFullYear();

  if (!Number.isFinite(year)) {
    return "";
  }

  if (year <= 1945) return "Silent Generation / Pre-Boomer";
  if (year <= 1964) return "Boomers";
  if (year <= 1980) return "Gen X";
  if (year <= 1996) return "Gen Y / Millennials";
  if (year <= 2012) return "Gen Z";
  return "Gen Alpha / Post-Gen Z";
}

function getTitleGenderRule(title) {
  if (MALE_TITLE_PREFIXES.has(title)) {
    return "Male";
  }

  if (FEMALE_TITLE_PREFIXES.has(title)) {
    return "Female";
  }

  if (NEUTRAL_TITLE_PREFIXES.has(title)) {
    return "Neutral";
  }

  return "Unknown";
}

function titleMatchesGender(title, gender) {
  const rule = getTitleGenderRule(title);

  if (!title || rule === "Neutral" || rule === "Unknown") {
    return true;
  }

  return rule === gender;
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

function formatPhoneDisplay(countryCode, number) {
  const code = cleanCountryCode(countryCode);
  const digits = String(number || "").replace(/\D/g, "");

  if (!code || !digits) {
    return "-";
  }

  return code + " " + digits;
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
  return Array.isArray(value) ? value : [];
}

function normalizeAuditTrail(value) {
  return Array.isArray(value) ? value : [];
}

function normalizeFlags(value) {
  return Array.isArray(value) ? value : [];
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

function splitAvailability(value) {
  if (!value) {
    return { date: "", time: "" };
  }

  const raw = String(value);

  if (raw.includes("T")) {
    const [date, timeWithSeconds] = raw.split("T");
    return {
      date,
      time: String(timeWithSeconds || "").slice(0, 5)
    };
  }

  return { date: "", time: "" };
}

function combineAvailability(date, time) {
  if (!date) {
    return "";
  }

  return date + "T" + (time || "23:59");
}

function getUnavailableStatus(client) {
  const combined = combineAvailability(client.unavailableUntilDate, client.unavailableUntilTime);

  if (!combined) {
    return "Available";
  }

  const until = new Date(combined);

  if (Number.isNaN(until.getTime())) {
    return "Unavailable until date/time invalid";
  }

  if (until.getTime() < Date.now()) {
    return "Available - prior unavailability expired";
  }

  return "Unavailable until " + formatDateTime(combined);
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

  const derivedDob = parseNricDob(nricPassportNumber, identificationKind);
  const dateOfBirth = source.dateOfBirth || derivedDob;
  const age = source.age || calculateAge(dateOfBirth);
  const ageCategory = source.ageCategory || getAgeCategory(age);
  const generation = source.generation || getGeneration(dateOfBirth);
  const gender = source.gender || deriveGenderFromIdentification(nricPassportNumber, identificationKind);
  const country = source.country || "Malaysia";
  const stateOfBirth = source.stateOfBirth || getMalaysiaNricStateOfBirth(nricPassportNumber, identificationKind);
  const region = source.region || getDefaultRegion(country, source.continent || COUNTRY_TO_CONTINENT[country] || "");
  const availability = splitAvailability(source.unavailableUntil || source.availabilityUntil || source.unreachableTo || "");

  return {
    ...EMPTY_CLIENT,
    ...source,
    id: getClientId(source) || source.id || "",

    titlePrefix: source.titlePrefix || "",
    titleSuffix: source.titleSuffix || "Not Applicable / N/A",
    titleGenderOverride: Boolean(source.titleGenderOverride),
    titleOverrideReason: source.titleOverrideReason || "",

    givenName,
    surname,
    initials: source.initials || makeInitials(givenName, surname),

    gender,
    genderSource: source.genderSource || source["GenderSource"] || (source.gender ? "manual" : "auto"),
    dateOfBirth,
    age,
    ageCategory,
    generation,
    stateOfBirth,

    employmentStatus: source.employmentStatus || "To be confirmed",
    maritalStatus: source.maritalStatus || "To be confirmed",

    ethnicity: source.ethnicity || "",
    ethnicityOther: source.ethnicityOther || "",
    nationality: source.nationality || "",
    residencyStatus: source.residencyStatus || source.immigrationStatus || "Malaysian Citizen",
    identificationKind,
    identityCardColour: source.identityCardColour || source.icColour || "Blue - Malaysian Citizen / MyKad",
    nricPassportNumber,

    email: source.email || "",

    phoneCountryCode: source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
    phoneNumber: source.phoneNumber || source.phone || "",
    backupPhoneCountryCode: source.backupPhoneCountryCode || source["backupPhonecountryCode"] || "+60 Malaysia",
    backupPhoneNumber: source.backupPhoneNumber || "",
    phoneHistory: normalizePhoneHistory(source.phoneHistory),

    whatsappSameAsPhone: source.whatsappSameAsPhone !== undefined ? Boolean(source.whatsappSameAsPhone) : true,
    whatsappCountryCode: source.whatsappCountryCode || source["whatsappcountryCode"] || source.phoneCountryCode || source["phonecountryCode"] || "+60 Malaysia",
    whatsappNumber: source.whatsappNumber || source.whatsapp || source.phoneNumber || source.phone || "",
    whatsappMessageTemplate: source.whatsappMessageTemplate || "General follow-up",
    whatsappCustomMessage: source.whatsappCustomMessage || "",
    hasSecondWhatsapp: Boolean(source.hasSecondWhatsapp),
    whatsapp2CountryCode: source.whatsapp2CountryCode || source["whatsapp2countryCode"] || "+60 Malaysia",
    whatsapp2Number: source.whatsapp2Number || "",

    preferredContact1: source.preferredContact1 || "WhatsApp Message",
    preferredContact2: source.preferredContact2 || "Phone Call",
    preferredContact3: source.preferredContact3 || "Email",
    preferredContactHoursFrom: source.preferredContactHoursFrom || "09:00",
    preferredContactHoursTo: source.preferredContactHoursTo || "18:00",

    unavailableUntilDate: source.unavailableUntilDate || availability.date || "",
    unavailableUntilTime: source.unavailableUntilTime || availability.time || "",
    availabilityReason: source.availabilityReason || "Not Applicable / N/A",
    availabilityReasonOther: source.availabilityReasonOther || "",
    communicationTimingNotes: source.communicationTimingNotes || source.whatsappNotes || source.preferredContactTimeNote || "",

    emergencyContactName: source.emergencyContactName || "",
    emergencyContactRelationship: source.emergencyContactRelationship || "",
    emergencyContactCountryCode: source.emergencyContactCountryCode || source["emergencyContactcountryCode"] || "+60 Malaysia",
    emergencyContactNumber: source.emergencyContactNumber || "",
    emergencyContactEmail: source.emergencyContactEmail || "",
    emergencyContactNotes: source.emergencyContactNotes || "",

    addressType: source.addressType || "Residential",
    country,
    continent: source.continent || COUNTRY_TO_CONTINENT[country] || "Asia",
    region,
    buildingHouseNo: source.buildingHouseNo || source.houseNo || "",
    buildingHouseName: source.buildingHouseName || source.buildingName || "",
    postcode: source.postcode || source.postalCode || "",
    streetAddress: source.streetAddress || source.address || "",
    district: source.district || "",
    townCity: source.townCity || source.city || source.town || "",

    documentType: source.documentType || "NRIC",
    documentStatus: source.documentStatus || "Pending Verification",
    documentAttachmentNames: normalizeDocumentNames(source.documentAttachmentNames || source.documentAttachmentName),
    documentRelatedReferenceNotes: source.documentRelatedReferenceNotes || source.documentReferenceNotes || source.documentReferenceNote || "",

    specialRemarksStaffLawyerNotes: source.specialRemarksStaffLawyerNotes || source.staffLawyerRemarks || "",
    missingInformationNotes: source.missingInformationNotes || "",

    verificationStatus: source.verificationStatus || "Pending Review",
    verificationFlags: normalizeFlags(source.verificationFlags),
    auditTrail: normalizeAuditTrail(source.auditTrail),

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

function buildAuditTrail(form, existingClient, now) {
  const existing = existingClient ? normalizeClient(existingClient) : null;
  const auditTrail = existing ? normalizeAuditTrail(existing.auditTrail) : [];

  if (!existing) {
    return auditTrail;
  }

  const watchedFields = [
    ["documentRelatedReferenceNotes", "Document Related Reference Notes"],
    ["specialRemarksStaffLawyerNotes", "Internal Remarks and Staff Notes"],
    ["nricPassportNumber", "NRIC / Passport Number"],
    ["identityCardColour", "Identity Card Colour / Document Class"],
    ["residencyStatus", "Immigration / Documented Status"],
    ["phoneNumber", "Primary Phone Number"],
    ["backupPhoneNumber", "Secondary / Backup Phone Number"],
    ["email", "Email Address"]
  ];

  watchedFields.forEach(([field, label]) => {
    if ((existing[field] || "") !== (form[field] || "")) {
      auditTrail.unshift({
        field,
        label,
        oldValue: existing[field] || "",
        newValue: form[field] || "",
        changedAt: now,
        reason: "Client profile field amended via frontend form"
      });
    }
  });

  return auditTrail;
}

function buildPayload(form, existingClient) {
  const now = new Date().toISOString();
  const givenName = String(form.givenName || "").trim();
  const surname = String(form.surname || "").trim();
  const fullName = [givenName, surname].filter(Boolean).join(" ");
  const existing = existingClient ? normalizeClient(existingClient) : null;
  const identificationKind = form.identificationKind || "Malaysian NRIC";
  const nricPassportNumber = String(form.nricPassportNumber || "").trim();

  const derivedDob = parseNricDob(nricPassportNumber, identificationKind);
  const dateOfBirth = derivedDob || form.dateOfBirth;
  const age = calculateAge(dateOfBirth);
  const ageCategory = getAgeCategory(age);
  const generation = getGeneration(dateOfBirth);
  const gender = form.gender || deriveGenderFromIdentification(nricPassportNumber, identificationKind);
  const stateOfBirth = getMalaysiaNricStateOfBirth(nricPassportNumber, identificationKind);
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

  const unavailableUntil = combineAvailability(form.unavailableUntilDate, form.unavailableUntilTime);
  const auditTrail = buildAuditTrail(form, existing, now);

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
    dateOfBirth,
    age,
    ageCategory,
    generation,
    stateOfBirth,
    identificationKind,
    nricPassportNumber,
    identificationNumber: nricPassportNumber,
    icNumber: identificationKind.includes("NRIC") ? nricPassportNumber : "",
    icMasked: maskIdentification(nricPassportNumber, identificationKind),
    passportNumber: identificationKind === "Passport" ? nricPassportNumber : "",
    unavailableUntil,
    phone: formatPhone(form.phoneCountryCode, form.phoneNumber),
    phoneNumber: form.phoneNumber,
    phoneHistory,
    whatsapp: formatPhone(form.whatsappCountryCode, form.whatsappNumber),
    whatsappNumber: form.whatsappNumber,
    auditTrail,
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
function FieldLabel({ children, required = false }) {
  return (
    <span className="field-label-line">
      {children}
      {required && <span className="leos-required-marker">*</span>}
    </span>
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

  const whatsappLink = makeWhatsappLink(
    form.whatsappCountryCode,
    form.whatsappNumber,
    makeWhatsappMessage(form)
  );

  const unavailabilityIsSet = Boolean(form.unavailableUntilDate);

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

      if (field === "identityCardColour") {
        if (value === "Blue - Malaysian Citizen / MyKad") {
          next.residencyStatus = "Malaysian Citizen";
          next.identificationKind = "Malaysian NRIC";
          next.documentType = "NRIC";
          next.country = "Malaysia";
          next.continent = "Asia";
        }

        if (value === "Red - Permanent Resident") {
          next.residencyStatus = "Malaysia Permanent Resident";
          next.identificationKind = "Malaysian NRIC";
          next.documentType = "Permanent Resident Document";
          next.country = "Malaysia";
          next.continent = "Asia";
        }

        if (value === "Green - Temporary Resident / MyKAS") {
          next.residencyStatus = "Temporary Resident / MyKAS";
          next.identificationKind = "Malaysian NRIC";
          next.documentType = "Permanent Resident Document";
          next.country = "Malaysia";
          next.continent = "Asia";
        }

        if (value === "Passport / Foreign Travel Document") {
          next.identificationKind = "Passport";
          next.documentType = "Passport Bio Page";
        }

        if (value === "Singapore NRIC / FIN") {
          next.identificationKind = "Singapore NRIC / FIN";
          next.country = "Singapore";
          next.continent = "Asia";
        }
      }

      if (field === "residencyStatus") {
        if (value === "Malaysian Citizen") {
          next.identityCardColour = "Blue - Malaysian Citizen / MyKad";
          next.identificationKind = "Malaysian NRIC";
          next.documentType = "NRIC";
          next.phoneCountryCode = "+60 Malaysia";
          next.whatsappCountryCode = "+60 Malaysia";
          next.country = "Malaysia";
          next.continent = "Asia";
        } else if (value === "Malaysia Permanent Resident") {
          next.identityCardColour = "Red - Permanent Resident";
        } else if (value === "Temporary Resident / MyKAS") {
          next.identityCardColour = "Green - Temporary Resident / MyKAS";
        } else if (value === "Singapore Citizen" || value === "Singapore Permanent Resident") {
          next.identityCardColour = "Singapore NRIC / FIN";
          next.identificationKind = "Singapore NRIC / FIN";
          next.documentType = "Citizen / PR Proof";
          next.phoneCountryCode = "+65 Singapore";
          next.whatsappCountryCode = "+65 Singapore";
          next.country = "Singapore";
          next.continent = "Asia";
        } else if (value === "Foreigner") {
          next.identityCardColour = "Passport / Foreign Travel Document";
          next.identificationKind = "Passport";
          next.documentType = "Passport Bio Page";
        }
      }

      if (field === "identificationKind" || field === "nricPassportNumber") {
        const kind = field === "identificationKind" ? value : previous.identificationKind;
        const idValue = field === "nricPassportNumber" ? value : previous.nricPassportNumber;
        const suggestedGender = deriveGenderFromIdentification(idValue, kind);
        const derivedDob = parseNricDob(idValue, kind);
        const age = calculateAge(derivedDob);

        next.dateOfBirth = derivedDob;
        next.age = age;
        next.ageCategory = getAgeCategory(age);
        next.generation = getGeneration(derivedDob);
        next.stateOfBirth = getMalaysiaNricStateOfBirth(idValue, kind);

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
        next.region = getDefaultRegion(value, next.continent) || previous.region || "";
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

      if (field === "titleGenderOverride") {
        next.titleGenderOverride = Boolean(value);
      }

      if (field === "unavailableUntilDate" && !value) {
        next.unavailableUntilTime = "";
        next.availabilityReason = "Not Applicable / N/A";
        next.availabilityReasonOther = "";
      }

      return next;
    });
  }

  function resetForm() {
    setForm(EMPTY_CLIENT);
    setValidationErrors([]);
    setEditingId("");
  }

    function validateClientForm(payload) {
    const errors = [];
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

    const flags = [];
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
    // isBlank is already declared above as a const helper in this validation scope.
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

    const { errors, flags } = validateClientForm(form);
    setValidationErrors(errors);

    if (errors.length > 0) {
      window.alert("Client profile validation failed. Please correct the highlighted issues before saving.");
      showStatus("Please fix the missing, inconsistent, or invalid client profile details before saving.", "error");
      return;
    }

    let formForSave = {
      ...form,
      verificationFlags: flags,
      verificationStatus: flags.length > 0 ? "Review Required" : form.verificationStatus
    };

    if (flags.length > 0) {
      window.alert("Verification discrepancy detected. Record will be flagged for review:\n\n" + flags.join("\n"));
    }

    setIsSaving(true);

    const existingClient = clients.find((client) => getClientId(client) === editingId);
    const payload = buildPayload(formForSave, existingClient);

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
          ? "Client profile successfully modified, verified and saved."
          : "Client profile successfully entered, received, verified and saved.",
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
    showStatus("Editing selected client. Modify the profile and click Save Modified Client.", "info");
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

  function updateDocumentFiles(event) {
    const files = Array.from(event.target.files || []);
    const names = files.map((file) => file.name);

    updateForm("documentAttachmentNames", names);

    if (names.length > 0) {
      showStatus("Document selected for this client: " + names.join(", ") + ". Secure file storage needs backend upload support.", "info");
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
        normalized.titlePrefix,
        normalized.titleSuffix,
        normalized.initials,
        normalized.gender,
        normalized.givenName,
        normalized.surname,
        normalized.name,
        normalized.ageCategory,
        normalized.generation,
        normalized.stateOfBirth,
        normalized.employmentStatus,
        normalized.maritalStatus,
        normalized.ethnicity,
        normalized.nationality,
        normalized.residencyStatus,
        normalized.identificationKind,
        normalized.identityCardColour,
        normalized.nricPassportNumber,
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
        normalized.region,
        normalized.townCity,
        normalized.district,
        normalized.streetAddress,
        normalized.buildingHouseNo,
        normalized.buildingHouseName,
        normalized.postcode,
        normalized.specialRemarksStaffLawyerNotes,
        normalized.documentRelatedReferenceNotes,
        normalized.verificationStatus,
        normalized.verificationFlags.join(" ")
      ]
        .filter(Boolean)
        .join(" ")
        .toLowerCase();

      return searchable.includes(query);
    });
  }, [clients, searchTerm]);

  return (
    <section className="client-module client-v6">
      <div className="client-module-header">
        <div>
          <h2>Client Registration / Client Profile</h2>
          <p>
            Malaysian and Singaporean client profile with legal verification,
            document classification, audit notes and communication records.
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
          <strong>Validation / Compliance Issues</strong>
          <ul>
            {validationErrors.map((error) => (
              <li key={error}>{error}</li>
            ))}
          </ul>
        </div>
      )}

      <form className="client-form client-form-v6" onSubmit={saveClient}>
                <div className="form-section">
          <h3>Client Profile Details</h3>

          <div className="smart-grid two name-lock-grid">
            <label>
              Title Prefix
              <select required value={form.titlePrefix} onChange={(event) => updateForm("titlePrefix", event.target.value)}>
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
              Given Name
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
                Override Reason
                <textarea
                  value={form.titleOverrideReason}
                  onChange={(event) => updateForm("titleOverrideReason", event.target.value)}
                  placeholder="Record verified reason for title/gender override."
                />
              </label>
            )}
          </div>
        </div>
        <div className="form-section">
          <h3>Client Identification Details</h3>

          <div className="smart-grid two identity-grid">
            <label>
              Immigration / Documented Status
              <select required value={form.residencyStatus} onChange={(event) => updateForm("residencyStatus", event.target.value)}>
                {RESIDENCY_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              ID Type
              <select required value={form.identificationKind} onChange={(event) => updateForm("identificationKind", event.target.value)}>
                {IDENTIFICATION_KIND_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Identity Card Colour / Document Class
              <select required value={form.identityCardColour} onChange={(event) => updateForm("identityCardColour", event.target.value)}>
                {IDENTITY_CARD_COLOUR_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
              <small>Blue auto-confirms Malaysian Citizen.</small>
            </label>

            <label>
              NRIC No. / Passport No.
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
                Nationality / Country of Origin *
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
        <div className="form-section">
          <h3>Employment Details</h3>

          <div className="smart-grid two">
            <label>
              Employment Status
              <select value={form.employmentStatus} onChange={(event) => updateForm("employmentStatus", event.target.value)}>
                {EMPLOYMENT_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3>Family and Marital Details</h3>

          <div className="smart-grid two">
            <label>
              Marital / Family Status
              <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
                {MARITAL_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3>4. Contact Information and Communication Preferences</h3>
          <p className="mandatory-note">At least one contact method is mandatory: Email Address or Primary Phone Number.</p>

          <div className="smart-grid two">            <label className="full">
              Email Address
              <input
                type="email"
                value={form.email}
                onChange={(event) => updateForm("email", event.target.value)}
                placeholder="client@example.com"
              />
            </label>



            <label className="full">
              Primary Phone Number
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
              <small>Display format: +60 0123456789. Digits only, no spaces or dashes.</small>
              {malaysiaPhoneWarning && <small className="field-warning">Check format: Malaysian mobile numbers should start with 01.</small>}
            </label>

            <label className="full">
              Secondary / Backup Phone Number
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
              {malaysiaBackupPhoneWarning && <small className="field-warning">Check format: Malaysian backup phone numbers should start with 01.</small>}
            </label>

            <label className="checkbox-tile full">
              <input
                type="checkbox"
                checked={form.whatsappSameAsPhone}
                onChange={(event) => updateForm("whatsappSameAsPhone", event.target.checked)}
              />
              WhatsApp number same as primary phone number
            </label>

            {!form.whatsappSameAsPhone && (
              <label className="full">
                WhatsApp Number
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
              </label>
            )}

            <label>
              WhatsApp Message Template
              <select value={form.whatsappMessageTemplate} onChange={(event) => updateForm("whatsappMessageTemplate", event.target.value)}>
                {Object.keys(WHATSAPP_MESSAGE_TEMPLATES).map((template) => (
                  <option key={template} value={template}>{template}</option>
                ))}
              </select>
            </label>

            <label>
              WhatsApp Web Draft
              {whatsappLink ? (
                <a className="action-link" href={whatsappLink} target="_blank" rel="noreferrer">
                  Open WhatsApp Draft
                </a>
              ) : (
                <span className="muted-box">Enter WhatsApp number first</span>
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
              <select value={form.preferredContact1} onChange={(event) => updateForm("preferredContact1", event.target.value)}>
                {CONTACT_METHOD_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              2nd Contact Choice
              <select value={form.preferredContact2} onChange={(event) => updateForm("preferredContact2", event.target.value)}>
                {CONTACT_METHOD_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              3rd Contact Choice
              <select value={form.preferredContact3} onChange={(event) => updateForm("preferredContact3", event.target.value)}>
                {CONTACT_METHOD_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Contact Hours
              <div className="inline-fields two-even">
                <input type="time" value={form.preferredContactHoursFrom} onChange={(event) => updateForm("preferredContactHoursFrom", event.target.value)} />
                <input type="time" value={form.preferredContactHoursTo} onChange={(event) => updateForm("preferredContactHoursTo", event.target.value)} />
              </div>
            </label>

            <label className="full">
              Unavailable Until
              <div className="inline-fields two-even">
                <input type="date" value={form.unavailableUntilDate} onChange={(event) => updateForm("unavailableUntilDate", event.target.value)} />
                <input type="time" value={form.unavailableUntilTime} onChange={(event) => updateForm("unavailableUntilTime", event.target.value)} />
              </div>
              <small>{getUnavailableStatus(form)}</small>
            </label>

            {unavailabilityIsSet && (
              <label className="full">
                Reason for Unavailability
                <select value={form.availabilityReason} onChange={(event) => updateForm("availabilityReason", event.target.value)}>
                  {AVAILABILITY_REASON_OPTIONS.map((option) => (
                    <option key={option} value={option}>{option}</option>
                  ))}
                </select>
              </label>
            )}

            {unavailabilityIsSet && form.availabilityReason === "Other" && (
              <label className="full">
                Other Unavailability Reason
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
                placeholder="Example: reachable after 6pm, WhatsApp only, overseas number active on weekends."
              />
            </label>
          </div>
        </div>

                <div className="form-section">
          <h3>Address and Service Location Details</h3>
          <p className="mandatory-note">Use this section for residential, business, local, overseas, correspondence, courier and service-location details.</p>
          <p className="mandatory-note">
            <a
              href={"https://www.google.com/maps/search/?api=1&query=" + encodeURIComponent([form.streetAddress, form.townCity, form.postcode, form.country].filter(Boolean).join(", "))}
              target="_blank"
              rel="noreferrer"
            >
              Open entered address in Google Maps
            </a>
            <br />
            GPS Latitude / GPS Longitude auto-population should be implemented in a later Google Maps API-safe phase without overwriting the typed legal address.
          </p>
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
<div className="form-section">
          <h3>Emergency Contact Details</h3>

          <div className="smart-grid two">
            <label>
              Emergency Contact Name
              <input value={form.emergencyContactName} onChange={(event) => updateForm("emergencyContactName", event.target.value)} placeholder="Name" />
            </label>

            <label>
              Relationship to Client / Emergency Contact
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

            <label className="full">
              Emergency Contact Number
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
              <input type="email" value={form.emergencyContactEmail} onChange={(event) => updateForm("emergencyContactEmail", event.target.value)} placeholder="email@example.com" />
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3>Documentation Verification Status</h3>
          <p className="mandatory-note">Tracks document type, document receipt status, verification status and digital copy handling.</p>

          <div className="smart-grid two">
            <label>
              Document Type *
              <select value={form.documentType} onChange={(event) => updateForm("documentType", event.target.value)}>
                {DOCUMENT_TYPE_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Document Status *
              <select value={form.documentStatus} onChange={(event) => updateForm("documentStatus", event.target.value)}>
                {DOCUMENT_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Verification / Review Status *
              <select value={form.verificationStatus} onChange={(event) => updateForm("verificationStatus", event.target.value)}>
                {REVIEW_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="full">
              Attach Scanned Copy / Digital Copy
              <input type="file" multiple accept=".pdf,.png,.jpg,.jpeg,.webp" onChange={updateDocumentFiles} />
              <small>File names are matched to the client record. Actual secure document storage needs backend upload support.</small>
            </label>

            <label className="full">
              Document Related Reference Notes
              <textarea
                value={form.documentRelatedReferenceNotes}
                onChange={(event) => updateForm("documentRelatedReferenceNotes", event.target.value)}
                placeholder="Example: NRIC front/back received, passport page pending, certified true copy required."
              />
            </label>

            <label className="full important-notes">
              Internal Remarks and Staff Notes
              <textarea
                value={form.specialRemarksStaffLawyerNotes}
                onChange={(event) => updateForm("specialRemarksStaffLawyerNotes", event.target.value)}
                placeholder="Important legal/admin notes: discrepancy, urgent matter, contact restriction, sensitivity, unusual instruction."
              />
            </label>

            <label className="full">
              Missing, Unknown or Pending Information
              <textarea
                value={form.missingInformationNotes}
                onChange={(event) => updateForm("missingInformationNotes", event.target.value)}
                placeholder="Record why any field is N/A, unknown, unavailable, or to be confirmed."
              />
            </label>

            {form.verificationFlags.length > 0 && (
              <div className="review-flag-box full">
                <strong>Verification Flags</strong>
                <ul>
                  {form.verificationFlags.map((flag) => (
                    <li key={flag}>{flag}</li>
                  ))}
                </ul>
              </div>
            )}

            {form.auditTrail.length > 0 && (
              <div className="audit-box full">
                <strong>Local Audit / Historical Record</strong>
                {form.auditTrail.slice(0, 5).map((entry, index) => (
                  <p key={index}>
                    {entry.label}: amended on {formatDateTime(entry.changedAt)}
                  </p>
                ))}
              </div>
            )}
          </div>
        </div>

        <datalist id="client-country-code-options">
          {COUNTRY_CODE_OPTIONS.map((countryCode) => (
            <option key={countryCode} value={countryCode} />
          ))}
        </datalist>

        <div className="client-form-actions">
          <button type="submit" disabled={isSaving}>
            {isSaving ? "Saving..." : editingId ? "Save Modified Client" : "Add Client"}
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
            placeholder="Search name, title, NRIC/passport, document class, phone, email, status, remarks or verification flags"
          />
        </label>
      </div>

      <div className="client-table-wrap">
        <table className="client-table">
          <thead>
            <tr>
              <th>Title</th>
              <th>Given Name</th>
              <th>Surname</th>
              <th>gender</th>
              <th>Age Category</th>
              <th>Generation</th>
              <th>IC Colour / Class</th>
              <th>Employment</th>
              <th>Marital Status</th>
              <th>IC / Passport</th>
              <th>Email</th>
              <th>Primary Phone</th>
              <th>Backup Phone</th>
              <th>WhatsApp</th>
              <th>Availability</th>
              <th>Address</th>
              <th>Emergency Contact</th>
              <th>Review Status</th>
              <th>Notes / Flags</th>
              <th>Created On</th>
              <th>Modified On</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {filteredClients.length === 0 && (
              <tr>
                <td colSpan="22">
                  {clients.length === 0 ? "No clients have been added yet." : "No matching clients found. Clear Client Search to show all clients."}
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
                  <td>{normalized.titlePrefix || "-"}</td>
                  <td>{normalized.givenName || "-"}</td>
                  <td>{normalized.surname || "-"}</td>
                  <td>{normalized.gender || "-"}</td>
                  <td>{normalized.ageCategory || "-"}</td>
                  <td>{normalized.generation || "-"}</td>
                  <td>{normalized.identityCardColour || "-"}</td>
                  <td>{normalized.employmentStatus || "-"}</td>
                  <td>{normalized.maritalStatus || "-"}</td>
                  <td>{maskIdentification(normalized.nricPassportNumber, normalized.identificationKind)}</td>
                  <td>{normalized.email ? <a href={mailTo}>{normalized.email}</a> : "-"}</td>
                  <td>{phoneForLinks ? <a href={telLink}>{formatPhoneDisplay(normalized.phoneCountryCode, normalized.phoneNumber)}</a> : "-"}</td>
                  <td>
                    {backupPhoneForLinks ? <a href={backupTelLink}>{formatPhoneDisplay(normalized.backupPhoneCountryCode, normalized.backupPhoneNumber)}</a> : "-"}
                    {normalized.phoneHistory.length > 0 && (
                      <>
                        <br />
                        History: {normalized.phoneHistory.length}
                      </>
                    )}
                  </td>
                  <td>{whatsappForLinks ? <a href={whatsappDraftLink} target="_blank" rel="noreferrer">WhatsApp Draft</a> : "-"}</td>
                  <td>{getUnavailableStatus(normalized)}</td>
                  <td>{address || "-"}</td>
                  <td>
                    {normalized.emergencyContactName || "-"}
                    {emergencyPhoneForLinks && (
                      <>
                        <br />
                        <a href={emergencyTelLink}>{formatPhoneDisplay(normalized.emergencyContactCountryCode, normalized.emergencyContactNumber)}</a>
                      </>
                    )}
                  </td>
                  <td>{normalized.verificationStatus || "-"}</td>
                  <td>
                    {normalized.verificationFlags.length > 0 ? normalized.verificationFlags.join("; ") : normalized.specialRemarksStaffLawyerNotes || "-"}
                  </td>
                  <td>{formatDateTime(normalized.createdAt)}</td>
                  <td>{formatDateTime(normalized.updatedAt)}</td>
                  <td>
                    <div className="client-row-actions">
                      <button type="button" onClick={() => editClient(normalized)}>Edit</button>
                      <button type="button" onClick={() => deleteClient(normalized)}>Delete</button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <p className="client-footnote">
        * required field. NRIC is fully masked in table views. Passport is partially masked.
        Age category and generation are locked from NRIC date of birth. Verification discrepancies are flagged for review and stored in the local audit trail until backend audit support is added.
      </p>
    </section>
  );
}
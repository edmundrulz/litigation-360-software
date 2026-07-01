import { useEffect, useMemo, useState } from "react";
const API_URL = "/api/clients";
const CLIENT_DIRECTORY_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");

const DEFAULT_CLIENT_TAG_OPTIONS = [
  "General",
  "Important",
  "Urgent",
  "VIP",
  "Pending Documents",
  "Pending Verification",
  "Court Matter",
  "Employment Matter",
  "Medical Matter",
  "Police / Authority Matter",
  "Billing / Invoice Matter",
  "Follow Up Required",
  "Archived / Dormant"
];

function getClientDirectoryName(client) {
  const source = client || {};
  return (
    [source.givenName, source.surname].filter(Boolean).join(" ") ||
    source.name ||
    source.full_name ||
    source.fullName ||
    source.email ||
    source.phoneNumber ||
    "Unnamed client"
  );
}

function getClientDirectoryInitial(client) {
  const name = getClientDirectoryName(client).trim();
  const first = name.charAt(0).toUpperCase();
  return /^[A-Z]$/.test(first) ? first : "#";
}

function normalizeClientTagList(value) {
  if (Array.isArray(value)) {
    return value.map((item) => String(item || "").trim()).filter(Boolean);
  }

  if (!value) {
    return [];
  }

  return String(value)
    .split(/[;,|]/)
    .map((item) => item.trim())
    .filter(Boolean);
}

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
  hasDependents: false,
  dependentsCount: "",
  dependentNotes: "",

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
  preferredContact3: "Not Applicable / N/A",
  preferredContact4: "Not Applicable / N/A",
  preferredContact5: "Not Applicable / N/A",
  preferredContactDetail1: "",
  preferredContactDetail2: "",
  preferredContactDetail3: "",
  preferredContactDetail4: "",
  preferredContactDetail5: "",
  hasBackupPhone: false,
  preferredContactHoursFrom: "09:00",
  preferredContactHoursTo: "18:00",

  unavailableUntilDate: "",
  unavailableUntilTime: "",
  unavailableUntil: "",
  availabilityReason: "Not Applicable / N/A",
  availabilityReasonOther: "",
  communicationTimingNotes: "",
  isClientUnavailable: false,
  enableCommunicationTimingNotes: false,

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

  correspondenceSameAsResidential: true,
  correspondenceDifferenceConfirmed: false,
  correspondenceAddressType: "Correspondence",
  correspondenceCountry: "Malaysia",
  correspondenceContinent: "Asia",
  correspondenceRegion: "Asia - Southeast Asia",
  correspondenceBuildingHouseNo: "",
  correspondenceBuildingHouseName: "",
  correspondencePostcode: "",
  correspondenceStreetAddress: "",
  correspondenceTownCity: "",
  correspondenceState: "",
  correspondenceNotes: "",

  district: "",
  townCity: "",
  state: "",
  municipality: "",
  council: "",
  borough: "",
  secondaryAdministrativeCategory: "",
  secondaryAdministrativeName: "",
  manualAdministrativeLocation: "",
  locationAdminType: "",
  locationAdminTypeManual: "",
  locationAdminTypeIsManual: false,
  locationFieldsLocked: false,
  locationLockReason: "",
  locationMismatchWarnings: [],
  googleContactResourceName: "",
  googleContactMatched: false,
  googleContactMatchSource: "",
  linkedClientId: "",
  linkedClientMatchStatus: "",

  documentType: "NRIC",
  documentStatus: "Pending Verification",
  documentAttachmentNames: [],
  documentReferenceNotes: "",
  documentRelatedReferenceNotes: "",

  staffLawyerRemarks: "",
  specialRemarksStaffLawyerNotes: "",
  missingInformationNotes: "",

  verificationStatus: "Pending Review",
  documentationVerificationCompleted: false,

  willStatus: "Unknown",
  willReferenceNotes: "",
  willRestrictedAccess: false,
  willAuthorizedParties: [],

  clientSince: "",
  totalMattersCount: "",
  clientValueTier: "Medium",
  clientValueNotes: "",

  clientRoleInMatter: "Plaintiff",
  caseOriginType: "New Direct Client",
  previousFirmName: "",
  coCounselNotes: "",

  healthDisabilityStatus: "None",
  accommodationRequired: false,
  accommodationNotes: "",
  verificationFlags: [],
  clientCategory: "General",
  clientTags: [],
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
const LOCATION_ADMIN_TYPE_OPTIONS = [
  "Municipality",
  "Municipal Council",
  "City Council",
  "District Council",
  "Local Council",
  "Borough",
  "District",
  "Town",
  "City",
  "Village",
  "Township",
  "Parish",
  "Region",
  "Province",
  "State",
  "Territory",
  "County",
  "Shire",
  "Local Government Area",
  "Administrative Division",
  "Federal Territory",
  "Autonomous Region",
  "Prefecture",
  "Commune",
  "Canton",
  "Ward",
  "Subdistrict",
  "Mukim",
  "Barangay",
  "Regency",
  "Department",
  "Governorate",
  "Emirate",
  "Not Applicable / N/A",
  "Unknown",
  "To be confirmed",
  "Other / Manual"
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

const WILL_STATUS_OPTIONS = ["Unknown", "No", "Yes"];

const WILL_AUTHORIZED_PARTY_OPTIONS = [
  "Lawyer",
  "Client",
  "Next of Kin",
  "Executor",
  "Court-Ordered Access"
];

const CLIENT_VALUE_TIER_OPTIONS = [
  "Low",
  "Medium",
  "High",
  "Strategic"
];

const CLIENT_ROLE_IN_MATTER_OPTIONS = [
  "Plaintiff",
  "Defendant",
  "Applicant",
  "Respondent",
  "Witness",
  "Other"
];

const CASE_ORIGIN_TYPE_OPTIONS = [
  "New Direct Client",
  "Inherited / Taken Over from Another Firm",
  "Joint Representation / Multi-firm Action"
];

const HEALTH_DISABILITY_STATUS_OPTIONS = [
  "None",
  "OKU / Disability",
  "Medical Sensitivity",
  "Prefer Not to Disclose"
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
    hasDependents: Boolean(source.hasDependents),
    dependentsCount: source.dependentsCount || "",
    dependentNotes: source.dependentNotes || "",

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
    preferredContact3: source.preferredContact3 || "Not Applicable / N/A",
    preferredContact4: source.preferredContact4 || "Not Applicable / N/A",
    preferredContact5: source.preferredContact5 || "Not Applicable / N/A",
    preferredContactDetail1: source.preferredContactDetail1 || "",
    preferredContactDetail2: source.preferredContactDetail2 || "",
    preferredContactDetail3: source.preferredContactDetail3 || "",
    preferredContactDetail4: source.preferredContactDetail4 || "",
    preferredContactDetail5: source.preferredContactDetail5 || "",
    hasBackupPhone: source.hasBackupPhone !== undefined ? Boolean(source.hasBackupPhone) : Boolean(source.backupPhoneNumber),
    preferredContactHoursFrom: source.preferredContactHoursFrom || "09:00",
    preferredContactHoursTo: source.preferredContactHoursTo || "18:00",

    unavailableUntilDate: source.unavailableUntilDate || availability.date || "",
    unavailableUntilTime: source.unavailableUntilTime || availability.time || "",
    availabilityReason: source.availabilityReason || "Not Applicable / N/A",
    availabilityReasonOther: source.availabilityReasonOther || "",
    communicationTimingNotes: source.communicationTimingNotes || source.whatsappNotes || source.preferredContactTimeNote || "",
    isClientUnavailable: source.isClientUnavailable !== undefined
      ? Boolean(source.isClientUnavailable)
      : Boolean(source.unavailableUntilDate || source.unavailableUntilTime || source.unavailableUntil),
    enableCommunicationTimingNotes: source.enableCommunicationTimingNotes !== undefined
      ? Boolean(source.enableCommunicationTimingNotes)
      : Boolean(source.communicationTimingNotes),

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

    correspondenceSameAsResidential: source.correspondenceSameAsResidential !== undefined
      ? Boolean(source.correspondenceSameAsResidential)
      : true,
    correspondenceDifferenceConfirmed: Boolean(source.correspondenceDifferenceConfirmed),
    correspondenceAddressType: source.correspondenceAddressType || "Correspondence",
    correspondenceCountry: source.correspondenceCountry || source.country || country,
    correspondenceContinent: source.correspondenceContinent || source.continent || COUNTRY_TO_CONTINENT[country] || "Asia",
    correspondenceRegion: source.correspondenceRegion || source.region || region,
    correspondenceBuildingHouseNo: source.correspondenceBuildingHouseNo || source.buildingHouseNo || source.houseNo || "",
    correspondenceBuildingHouseName: source.correspondenceBuildingHouseName || source.buildingHouseName || source.buildingName || "",
    correspondencePostcode: source.correspondencePostcode || source.postcode || source.postalCode || "",
    correspondenceStreetAddress: source.correspondenceStreetAddress || source.streetAddress || source.address || "",
    correspondenceTownCity: source.correspondenceTownCity || source.townCity || source.city || source.town || "",
    correspondenceState: source.correspondenceState || source.state || source.province || source.territory || "",
    correspondenceNotes: source.correspondenceNotes || "",

    district: source.district || "",
    townCity: source.townCity || source.city || source.town || "",
    state: source.state || source.province || source.territory || "",
    municipality: source.municipality || "",
    council: source.council || "",
    borough: source.borough || "",
    secondaryAdministrativeCategory: source.secondaryAdministrativeCategory || "",
    secondaryAdministrativeName: source.secondaryAdministrativeName || "",
    manualAdministrativeLocation: source.manualAdministrativeLocation || "",
    locationAdminType: source.locationAdminType || "",
    locationAdminTypeManual: source.locationAdminTypeManual || "",
    locationAdminTypeIsManual: Boolean(source.locationAdminTypeIsManual),
    locationFieldsLocked: Boolean(source.locationFieldsLocked),
    locationLockReason: source.locationLockReason || "",
    locationMismatchWarnings: Array.isArray(source.locationMismatchWarnings) ? source.locationMismatchWarnings : [],
    googleContactResourceName: source.googleContactResourceName || "",
    googleContactMatched: Boolean(source.googleContactMatched),
    googleContactMatchSource: source.googleContactMatchSource || "",
    linkedClientId: source.linkedClientId || "",
    linkedClientMatchStatus: source.linkedClientMatchStatus || "",

    documentType: source.documentType || "NRIC",
    documentStatus: source.documentStatus || "Pending Verification",
    documentAttachmentNames: normalizeDocumentNames(source.documentAttachmentNames || source.documentAttachmentName),
    documentRelatedReferenceNotes: source.documentRelatedReferenceNotes || source.documentReferenceNotes || source.documentReferenceNote || "",

    specialRemarksStaffLawyerNotes: source.specialRemarksStaffLawyerNotes || source.staffLawyerRemarks || "",
    missingInformationNotes: source.missingInformationNotes || "",

    verificationStatus: source.verificationStatus || "Pending Review",
    documentationVerificationCompleted: Boolean(source.documentationVerificationCompleted),

    willStatus: source.willStatus || "Unknown",
    willReferenceNotes: source.willReferenceNotes || "",
    willRestrictedAccess: Boolean(source.willRestrictedAccess),
    willAuthorizedParties: normalizeFlags(source.willAuthorizedParties),

    clientSince: source.clientSince || "",
    totalMattersCount: source.totalMattersCount || "",
    clientValueTier: source.clientValueTier || "Medium",
    clientValueNotes: source.clientValueNotes || "",

    clientRoleInMatter: source.clientRoleInMatter || "Plaintiff",
    caseOriginType: source.caseOriginType || "New Direct Client",
    previousFirmName: source.previousFirmName || "",
    coCounselNotes: source.coCounselNotes || "",

    healthDisabilityStatus: source.healthDisabilityStatus || "None",
    accommodationRequired: Boolean(source.accommodationRequired),
    accommodationNotes: source.accommodationNotes || "",
    verificationFlags: normalizeFlags(source.verificationFlags),
    clientCategory: source.clientCategory || "General",
    clientTags: normalizeClientTagList(source.clientTags || source.tags),
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

function getRelationshipDurationLabel(clientSince) {
  if (!clientSince) return "Not recorded";

  const start = new Date(clientSince);
  if (Number.isNaN(start.getTime())) return "Invalid date";

  const now = new Date();
  let months = (now.getFullYear() - start.getFullYear()) * 12 + (now.getMonth() - start.getMonth());

  if (now.getDate() < start.getDate()) {
    months -= 1;
  }

  if (months < 1) return "Less than 1 month";

  const years = Math.floor(months / 12);
  const remainingMonths = months % 12;
  const parts = [];

  if (years > 0) parts.push(years + " year" + (years === 1 ? "" : "s"));
  if (remainingMonths > 0) parts.push(remainingMonths + " month" + (remainingMonths === 1 ? "" : "s"));

  return parts.join(" ");
}

function isCompletionValuePresent(value) {
  if (Array.isArray(value)) return value.length > 0;
  if (typeof value === "boolean") return value;
  return String(value || "").trim() !== "";
}

function getClientFormCompletionProgress(form) {
  const checks = [
    ["Given Name", form.givenName],
    ["Surname", form.surname],
    ["Gender", form.gender],
    ["Date of Birth / Age", form.dateOfBirth || form.ageCategory],
    ["ID / Passport", form.nricPassportNumber],
    ["Primary Phone", form.phoneNumber],
    ["Primary Contact Choice", form.preferredContact1],
    ["Address", form.streetAddress || form.townCity || form.country],
    ["Emergency Contact", form.emergencyContactName || form.emergencyContactNumber],
    ["Documentation", form.documentationVerificationCompleted || form.documentType || form.documentStatus],
    ["Family / Marital", form.maritalStatus],
    ["Matter Context", form.clientRoleInMatter || form.caseOriginType],
    ["Client Tenure / Value", form.clientSince || form.clientValueTier],
    ["Health / Accommodation", form.healthDisabilityStatus || form.accommodationRequired],
    ["Will / Estate", form.willStatus]
  ];

  const completed = checks.filter(([, value]) => isCompletionValuePresent(value)).length;
  const total = checks.length;
  const percentage = total === 0 ? 0 : Math.round((completed / total) * 100);
  const missing = checks.filter(([, value]) => !isCompletionValuePresent(value)).map(([label]) => label);

  return {
    completed,
    total,
    percentage,
    missing
  };
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

const MINIMUM_CONTACT_DIGITS = 9;

const CANONICAL_CONTACT_METHODS = new Set([
  "Email",
  "WhatsApp Message",
  "WhatsApp Call",
  "Phone Call",
  "SMS"
]);

const RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP = {
  addressType: "correspondenceAddressType",
  country: "correspondenceCountry",
  continent: "correspondenceContinent",
  region: "correspondenceRegion",
  buildingHouseNo: "correspondenceBuildingHouseNo",
  buildingHouseName: "correspondenceBuildingHouseName",
  postcode: "correspondencePostcode",
  streetAddress: "correspondenceStreetAddress",
  townCity: "correspondenceTownCity",
  state: "correspondenceState"
};

const CORRESPONDENCE_REQUIRED_FIELDS = [
  ["correspondenceCountry", "Correspondence Country"],
  ["correspondenceBuildingHouseNo", "Correspondence Building / House No."],
  ["correspondencePostcode", "Correspondence Postcode"],
  ["correspondenceStreetAddress", "Correspondence Street Address"],
  ["correspondenceTownCity", "Correspondence Town / City"]
];

function normalizeDigits(value) {
  return String(value || "").replace(/\D/g, "");
}

function hasMinimumContactDigits(value) {
  return normalizeDigits(value).length >= MINIMUM_CONTACT_DIGITS;
}

function getContactDisplayNumber(countryCode, number) {
  return hasMinimumContactDigits(number) ? formatPhoneDisplay(countryCode, number) : "";
}

function getCanonicalContactDetail(method, source) {
  const safeMethod = String(method || "");

  if (safeMethod === "Email") {
    const value = String(source.email || "").trim();

    return {
      isCanonical: true,
      value,
      sourceField: "email",
      sourceLabel: "Email Address",
      helper: value
        ? "Email Address already captured above. No duplicate entry required."
        : "Enter the Email Address above; duplicate entry is not required here.",
      missingMessage: "Email Address is required when Email is selected as a preferred contact choice."
    };
  }

  if (safeMethod === "WhatsApp Message" || safeMethod === "WhatsApp Call") {
    const usePrimaryPhone = Boolean(source.whatsappSameAsPhone);
    const sourceField = usePrimaryPhone ? "phoneNumber" : "whatsappNumber";
    const sourceLabel = usePrimaryPhone ? "Primary Phone Number" : "WhatsApp Number";
    const countryCode = usePrimaryPhone ? source.phoneCountryCode : source.whatsappCountryCode;
    const number = usePrimaryPhone ? source.phoneNumber : source.whatsappNumber;
    const primaryValue = getContactDisplayNumber(countryCode, number);

    if (primaryValue) {
      return {
        isCanonical: true,
        value: primaryValue,
        sourceField,
        sourceLabel,
        helper: sourceLabel + " already captured above. No duplicate entry required.",
        missingMessage: sourceLabel + " must contain at least " + MINIMUM_CONTACT_DIGITS + " digits before " + safeMethod + " can reuse it."
      };
    }

    if (!usePrimaryPhone && source.hasSecondWhatsapp && hasMinimumContactDigits(source.whatsapp2Number)) {
      return {
        isCanonical: true,
        value: getContactDisplayNumber(source.whatsapp2CountryCode, source.whatsapp2Number),
        sourceField: "whatsapp2Number",
        sourceLabel: "Second WhatsApp Number",
        helper: "Second WhatsApp Number is enabled and captured above. No duplicate entry required.",
        missingMessage: "Second WhatsApp Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits."
      };
    }

    return {
      isCanonical: true,
      value: "",
      sourceField,
      sourceLabel,
      helper: "Complete " + sourceLabel + " above; duplicate entry is not required here.",
      missingMessage: sourceLabel + " must contain at least " + MINIMUM_CONTACT_DIGITS + " digits before " + safeMethod + " can reuse it."
    };
  }

  if (safeMethod === "Phone Call" || safeMethod === "SMS") {
    if (hasMinimumContactDigits(source.phoneNumber)) {
      return {
        isCanonical: true,
        value: getContactDisplayNumber(source.phoneCountryCode, source.phoneNumber),
        sourceField: "phoneNumber",
        sourceLabel: "Primary Phone Number",
        helper: "Primary Phone Number already captured above. No duplicate entry required.",
        missingMessage: "Primary Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits."
      };
    }

    if (source.hasBackupPhone && hasMinimumContactDigits(source.backupPhoneNumber)) {
      return {
        isCanonical: true,
        value: getContactDisplayNumber(source.backupPhoneCountryCode, source.backupPhoneNumber),
        sourceField: "backupPhoneNumber",
        sourceLabel: "Secondary / Backup Phone Number",
        helper: "Secondary / Backup Phone Number is enabled and captured above. No duplicate entry required.",
        missingMessage: "Secondary / Backup Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits."
      };
    }

    return {
      isCanonical: true,
      value: "",
      sourceField: "phoneNumber",
      sourceLabel: "Primary Phone Number",
      helper: "Complete Primary Phone Number above; duplicate entry is not required here.",
      missingMessage: "Primary Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits before " + safeMethod + " can reuse it."
    };
  }

  return {
    isCanonical: false,
    value: "",
    sourceField: "",
    sourceLabel: "",
    helper: "",
    missingMessage: ""
  };
}

function fillCanonicalPreferredContactDetails(source) {
  const next = { ...source };

  [1, 2, 3, 4, 5].forEach((rank) => {
    const method = next["preferredContact" + rank];
    const canonical = getCanonicalContactDetail(method, next);

    if (canonical.isCanonical && canonical.value) {
      next["preferredContactDetail" + rank] = canonical.value;
    }
  });

  return next;
}

function getCorrespondenceAddressUpdatesFromResidential(source) {
  const updates = {
    correspondenceSameAsResidential: true,
    correspondenceDifferenceConfirmed: false
  };

  Object.entries(RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP).forEach(([residentialField, correspondenceField]) => {
    updates[correspondenceField] = residentialField === "addressType"
      ? "Correspondence"
      : source[residentialField] || "";
  });

  return updates;
}

function normalizeAddressValue(value) {
  return String(value || "").trim().toLowerCase().replace(/\s+/g, " ");
}

function doResidentialAndCorrespondenceAddressesMatch(source) {
  if (source.correspondenceSameAsResidential) {
    return true;
  }

  return Object.entries(RESIDENTIAL_TO_CORRESPONDENCE_FIELD_MAP)
    .filter(([residentialField]) => residentialField !== "addressType")
    .every(([residentialField, correspondenceField]) => (
      normalizeAddressValue(source[residentialField]) === normalizeAddressValue(source[correspondenceField])
    ));
}

function prepareClientFormForValidation(source) {
  const withCanonicalContacts = fillCanonicalPreferredContactDetails(source);

  if (withCanonicalContacts.correspondenceSameAsResidential) {
    return {
      ...withCanonicalContacts,
      ...getCorrespondenceAddressUpdatesFromResidential(withCanonicalContacts)
    };
  }

  return withCanonicalContacts;
}


function ClientRequiredFieldCounter() {
  const [snapshot, setSnapshot] = useState({
    total: 0,
    complete: 0,
    missing: 0,
  });

  useEffect(() => {
    const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;

    const isVisible = (control) => {
      if (!control || control.disabled) return false;
      if (control.closest(".client-profile-completion-shell")) return false;
      if (control.closest(".client-profile-review-panel")) return false;
      if (control.closest(".client-profile-summary-rail")) return false;
      return Boolean(control.offsetParent || control.getClientRects().length);
    };

    const isFilled = (control, root, countedGroups) => {
      const type = (control.getAttribute("type") || "").toLowerCase();

      if (type === "checkbox" || type === "radio") {
        const name = control.getAttribute("name");

        if (name) {
          const groupKey = type + ":" + name;
          if (countedGroups.has(groupKey)) return null;
          countedGroups.add(groupKey);

          const groupControls = Array.from(root.querySelectorAll('input[type="' + type + '"]')).filter(
            (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
          );

          return groupControls.some((candidate) => candidate.checked);
        }

        return control.checked;
      }

      return String(control.value || "").trim().length > 0;
    };

    const collectRequiredState = () => {
      const root = getRoot();
      const rawControls = Array.from(
        root.querySelectorAll('input[required], select[required], textarea[required], [aria-required="true"]'),
      ).filter(isVisible);

      const countedGroups = new Set();
      let total = 0;
      let complete = 0;

      rawControls.forEach((control) => {
        const filled = isFilled(control, root, countedGroups);

        if (filled === null) {
          return;
        }

        total += 1;

        if (filled) {
          complete += 1;
        }
      });

      setSnapshot({
        total,
        complete,
        missing: Math.max(total - complete, 0),
      });
    };

    collectRequiredState();

    const root = getRoot();
    root.addEventListener("input", collectRequiredState, true);
    root.addEventListener("change", collectRequiredState, true);

    const observer = new MutationObserver(collectRequiredState);
    observer.observe(root, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ["required", "aria-required", "disabled", "class", "style"],
    });

    return () => {
      root.removeEventListener("input", collectRequiredState, true);
      root.removeEventListener("change", collectRequiredState, true);
      observer.disconnect();
    };
  }, []);

  const hasRequiredFields = snapshot.total > 0;
  const isClear = hasRequiredFields && snapshot.missing === 0;

  return (
    <div className="client-required-field-counter" aria-live="polite">
      <div>
        <p className="client-profile-completion-kicker">Existing Required Fields</p>
        <h4>{isClear ? "No Visible Required Field Gaps Detected" : "Visible Required Fields Need Review"}</h4>
        <p>
          Counter reads currently rendered required controls only. Existing Clients validation and save/create checks remain authoritative.
        </p>
      </div>

      <div className="client-required-field-counter-metrics">
        <span>
          <strong>{snapshot.total}</strong>
          Required
        </span>
        <span>
          <strong>{snapshot.complete}</strong>
          Complete
        </span>
        <span className={snapshot.missing > 0 ? "needs-review" : "is-clear"}>
          <strong>{snapshot.missing}</strong>
          Missing
        </span>
      </div>
    </div>
  );
}

function ClientSectionCompletionStatus() {
  const sectionDefinitions = [
    { anchor: "client-profile-details", label: "Identity & Authority" },
    { anchor: "client-identification-details", label: "Identification" },
    { anchor: "client-employment-details", label: "Employment & Organisation" },
    { anchor: "client-family-marital-details", label: "Family / Marital" },
    { anchor: "client-matter-context-origin", label: "Matter Context" },
    { anchor: "client-source-value-indicators", label: "Source / Value" },
    { anchor: "client-will-estate-metadata", label: "Will / Estate" },
    { anchor: "client-health-oku-accommodation", label: "Health / OKU / Accommodation" },
    { anchor: "client-contact-communication-preferences", label: "Contact / Communication" },
    { anchor: "client-address-service-location", label: "Address / Service Location" },
    { anchor: "client-emergency-next-of-kin", label: "Emergency / Next of Kin" },
    { anchor: "client-documentation-verification", label: "Documentation Verification" },
    { anchor: "client-internal-remarks-issues", label: "Remarks / Pending Info" },
  ];

  const [sections, setSections] = useState([]);

  useEffect(() => {
    const getRoot = () => document.querySelector(".client-module-header")?.parentElement || document;

    const isVisible = (control) => {
      if (!control || control.disabled) return false;
      if (control.closest(".client-profile-completion-shell")) return false;
      if (control.closest(".client-profile-review-panel")) return false;
      if (control.closest(".client-profile-summary-rail")) return false;
      return Boolean(control.offsetParent || control.getClientRects().length);
    };

    const hasValue = (control) => {
      const type = (control.getAttribute("type") || "").toLowerCase();

      if (type === "checkbox" || type === "radio") {
        return Boolean(control.checked);
      }

      return String(control.value || "").trim().length > 0;
    };

    const countRequiredControls = (controls, sectionRoot) => {
      const countedGroups = new Set();
      let required = 0;
      let complete = 0;

      controls.forEach((control) => {
        const type = (control.getAttribute("type") || "").toLowerCase();

        if (type === "checkbox" || type === "radio") {
          const name = control.getAttribute("name");

          if (name) {
            const groupKey = type + ":" + name;

            if (countedGroups.has(groupKey)) {
              return;
            }

            countedGroups.add(groupKey);

            const groupControls = Array.from(sectionRoot.querySelectorAll('input[type="' + type + '"]')).filter(
              (candidate) => candidate.getAttribute("name") === name && isVisible(candidate),
            );

            required += 1;

            if (groupControls.some((candidate) => candidate.checked)) {
              complete += 1;
            }

            return;
          }

          required += 1;

          if (control.checked) {
            complete += 1;
          }

          return;
        }

        required += 1;

        if (String(control.value || "").trim().length > 0) {
          complete += 1;
        }
      });

      return {
        required,
        complete,
        missing: Math.max(required - complete, 0),
      };
    };

    const readSection = (section) => {
      const anchorElement = document.getElementById(section.anchor);

      if (!anchorElement) {
        return {
          ...section,
          status: "Mapping Pending",
          tone: "optional",
          required: 0,
          complete: 0,
          missing: 0,
          active: false,
        };
      }

      const sectionRoot =
        anchorElement.closest(".client-profile-card, .client-profile-section, .client-form-section, .form-section, section, article, fieldset") ||
        anchorElement.parentElement ||
        anchorElement;

      const controls = Array.from(sectionRoot.querySelectorAll("input, select, textarea")).filter(isVisible);
      const requiredControls = controls.filter((control) => control.matches("[required], [aria-required='true']"));
      const counts = countRequiredControls(requiredControls, sectionRoot);
      const active = controls.some(hasValue);

      let status = "Optional";
      let tone = "optional";

      if (counts.required > 0 && counts.missing === 0) {
        status = "Complete";
        tone = "complete";
      } else if (counts.required > 0 && counts.complete > 0) {
        status = "Review Required";
        tone = "review";
      } else if (counts.required > 0) {
        status = "Pending";
        tone = "pending";
      } else if (active) {
        status = "Review Required";
        tone = "review";
      }

      return {
        ...section,
        ...counts,
        active,
        status,
        tone,
      };
    };

    const collectSections = () => {
      setSections(sectionDefinitions.map(readSection));
    };

    collectSections();

    const root = getRoot();
    root.addEventListener("input", collectSections, true);
    root.addEventListener("change", collectSections, true);

    const observer = new MutationObserver(collectSections);
    observer.observe(root, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ["required", "aria-required", "disabled", "class", "style"],
    });

    return () => {
      root.removeEventListener("input", collectSections, true);
      root.removeEventListener("change", collectSections, true);
      observer.disconnect();
    };
  }, []);

  const totalMissing = sections.reduce((sum, section) => sum + section.missing, 0);
  const reviewSections = sections.filter((section) => section.tone === "review" || section.tone === "pending").length;

  return (
    <div className="client-section-completion-status" aria-live="polite">
      <div className="client-section-completion-header">
        <div>
          <p className="client-profile-completion-kicker">Section-Level Completion</p>
          <h4>Full Profile Section Readiness</h4>
          <p>
            Section statuses read existing visible required fields and entered values only. Existing Clients validation remains authoritative.
          </p>
        </div>

        <div className="client-section-completion-summary">
          <span>
            <strong>{reviewSections}</strong>
            Review
          </span>
          <span>
            <strong>{totalMissing}</strong>
            Missing
          </span>
        </div>
      </div>

      <div className="client-section-completion-list" aria-label="Client profile section completion statuses">
        {sections.map((section) => (
          <a
            className={`client-section-completion-row ${section.tone}`}
            href={`#${section.anchor}`}
            key={section.anchor}
          >
            <span className="client-section-completion-name">{section.label}</span>
            <span className="client-section-completion-badge">{section.status}</span>
            <span className="client-section-completion-count">
              {section.required} required / {section.missing} missing
            </span>
          </a>
        ))}
      </div>
    </div>
  );
}
export default function Clients({ setModule } = {}) {
  const [clients, setClients] = useState([]);
  const [form, setForm] = useState(EMPTY_CLIENT);
  const [editingId, setEditingId] = useState("");
  const [searchTerm, setSearchTerm] = useState("");
  const [clientLookupSearchBy, setClientLookupSearchBy] = useState("All Fields");
  const [status, setStatus] = useState("");
  const [statusType, setStatusType] = useState("info");
  const [isSaving, setIsSaving] = useState(false);
  const [validationErrors, setValidationErrors] = useState([]);
  const [showExtendedContactChoices, setShowExtendedContactChoices] = useState(false);
  const [viewingClientProfile, setViewingClientProfile] = useState(null);
  const [showClientProfileForm, setShowClientProfileForm] = useState(false);
  const [activeAlphabetFilter, setActiveAlphabetFilter] = useState("All");
  const [clientSearchHistory, setClientSearchHistory] = useState([]);
  const [selectedClientTagFilter, setSelectedClientTagFilter] = useState("All");
  const [manualClientTagSearch, setManualClientTagSearch] = useState("");
  const [fieldErrors, setFieldErrors] = useState({});
  const CLIENT_ONBOARDING_DRAFT_KEY = "l360.clientOnboardingDraft.v1";
  const [draftSaveStatus, setDraftSaveStatus] = useState("Draft not saved yet.");
  const [lastDraftSavedAt, setLastDraftSavedAt] = useState("");
  const [hasRecoverableDraft, setHasRecoverableDraft] = useState(false);
  const [numericWarnings, setNumericWarnings] = useState({});
  const [contactChoiceNotice, setContactChoiceNotice] = useState("");
  const [contactDatabaseSearch, setContactDatabaseSearch] = useState("");
  const [googleContactSearch, setGoogleContactSearch] = useState("");
  const [googleContactStatus, setGoogleContactStatus] = useState("");

  const contactDatabaseResults = useMemo(() => {
    const query = contactDatabaseSearch.trim().toLowerCase();
    if (!query) return [];

    return clients
      .map(normalizeClient)
      .filter((client) => [
        client.givenName,
        client.surname,
        client.name,
        client.email,
        client.phoneNumber,
        client.backupPhoneNumber,
        client.whatsappNumber,
        client.emergencyContactNumber,
        client.nricPassportNumber,
        client.postcode,
        client.townCity,
        client.district,
        client.state,
        client.municipality,
        client.council,
        client.borough,
        client.country,
        client.specialRemarksStaffLawyerNotes,
        client.documentRelatedReferenceNotes
      ].filter(Boolean).join(" ").toLowerCase().includes(query))
      .slice(0, 8);
  }, [clients, contactDatabaseSearch]);

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

  const addressMatchStatus = doResidentialAndCorrespondenceAddressesMatch(form);

  const CONTACT_CHOICE_FIELDS = [1, 2, 3, 4, 5];
  const CONTACT_CHOICE_RANK_LABELS = {
    1: "1st Contact Choice",
    2: "2nd Contact Choice",
    3: "3rd Contact Choice",
    4: "4th Contact Choice",
    5: "5th Contact Choice"
  };

  function getContactChoiceLabel(rank) {
    return CONTACT_CHOICE_RANK_LABELS[rank] || rank + " Contact Choice";
  }

  function showStatus(message, type = "info") {
    setStatus(message);
    setStatusType(type);
  }
  function openNewClientProfile() {
    resetForm();
    setShowClientProfileForm(true);
    window.setTimeout(() => {
      document.querySelector(".client-form-v6")?.scrollIntoView({ behavior: "smooth", block: "start" });
    }, 50);
  }

  function closeClientProfileForm() {
    setShowClientProfileForm(false);
    setEditingId("");
    setValidationErrors([]);
  }

  function handleDirectorySearchChange(event) {
    const value = event.target.value;
    setSearchTerm(value);

    const trimmed = value.trim();
    if (trimmed.length >= 2) {
      setClientSearchHistory((previous) => [trimmed, ...previous.filter((item) => item !== trimmed)].slice(0, 8));
    }
  }

  function selectClientFromDirectory(client) {
    const normalized = normalizeClient(client);
    const directoryName = getClientDirectoryName(normalized);
    const initial = getClientDirectoryInitial(normalized);

    setSearchTerm(directoryName);
    setClientLookupSearchBy("Client Name");
    setActiveAlphabetFilter(initial || "All");
    setSelectedClientTagFilter("All");
    setManualClientTagSearch("");
    setViewingClientProfile(normalized);

    showStatus("Manual client selection applied to the shared directory filter context.", "info");

    window.setTimeout(() => {
      document.querySelector(".client-directory-table")?.scrollIntoView({ behavior: "smooth", block: "start" });
    }, 50);
  }

  function clearDirectoryFilters() {
    setSearchTerm("");
    setClientLookupSearchBy("All Fields");
    setActiveAlphabetFilter("All");
    setSelectedClientTagFilter("All");
    setManualClientTagSearch("");
    setViewingClientProfile(null);
    showStatus("All client directory filters cleared. Showing all clients.", "info");
  }

  function getClientDirectoryActiveFilterSummary() {
    const filters = [];

    if (String(searchTerm || "").trim()) {
      filters.push("Search: " + String(searchTerm || "").trim());
    }

    if (clientLookupSearchBy && clientLookupSearchBy !== "All Fields") {
      filters.push("Search By: " + clientLookupSearchBy);
    }

    if (activeAlphabetFilter && activeAlphabetFilter !== "All") {
      filters.push("A-Z: " + activeAlphabetFilter);
    }

    if (selectedClientTagFilter && selectedClientTagFilter !== "All") {
      filters.push("Category / Tag: " + selectedClientTagFilter);
    }

    if (String(manualClientTagSearch || "").trim()) {
      filters.push("Manual Tag: " + String(manualClientTagSearch || "").trim());
    }

    return filters;
  }

  function getClientDirectoryEmptyStateMessage() {
    if (clients.length === 0) {
      return "No clients have been added yet.";
    }

    const activeFilters = getClientDirectoryActiveFilterSummary();

    if (activeFilters.length === 0) {
      return "No matching clients found. Use Show All Clients to refresh the full directory.";
    }

    return "No matching clients found for active filters (" + activeFilters.join(" | ") + "). Use Show All Clients to clear filters and return to the full directory.";
  }

  function isPhoneLikeContactMethod(method) {
    return ["WhatsApp Message", "WhatsApp Call", "Phone Call", "SMS"].includes(method);
  }

  function shouldSanitizeNumericField(field, currentForm) {
    if (["phoneNumber", "backupPhoneNumber", "whatsappNumber", "whatsapp2Number", "emergencyContactNumber"].includes(field)) {
      return true;
    }

    if (field === "preferredContactDetail1") return isPhoneLikeContactMethod(currentForm.preferredContact1);
    if (field === "preferredContactDetail2") return isPhoneLikeContactMethod(currentForm.preferredContact2);
    if (field === "preferredContactDetail3") return isPhoneLikeContactMethod(currentForm.preferredContact3);
    if (field === "preferredContactDetail4") return isPhoneLikeContactMethod(currentForm.preferredContact4);
    if (field === "preferredContactDetail5") return isPhoneLikeContactMethod(currentForm.preferredContact5);

    return false;
  }

  function deriveFieldErrors(payload) {
    const nextErrors = {};
    const isBlank = (value) => String(value || "").trim() === "";

    if (isBlank(payload.titlePrefix)) nextErrors.titlePrefix = "Title Prefix is required.";
    if (isBlank(payload.givenName)) nextErrors.givenName = "Given Name is required.";
    if (isBlank(payload.nricPassportNumber)) nextErrors.nricPassportNumber = "NRIC No. / Passport No. is required.";
    if (isBlank(payload.phoneNumber)) {
      nextErrors.phoneNumber = "Primary Phone Number is required for client profile completion.";
    } else if (!hasMinimumContactDigits(payload.phoneNumber)) {
      nextErrors.phoneNumber = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
    }

    if (payload.hasBackupPhone) {
      if (isBlank(payload.backupPhoneNumber)) {
        nextErrors.backupPhoneNumber = "Secondary / Backup Phone Number is enabled. Enter at least " + MINIMUM_CONTACT_DIGITS + " digits or untick the backup number option.";
      } else if (!hasMinimumContactDigits(payload.backupPhoneNumber)) {
        nextErrors.backupPhoneNumber = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
      }
    }

    if (!payload.whatsappSameAsPhone && !isBlank(payload.whatsappNumber) && !hasMinimumContactDigits(payload.whatsappNumber)) {
      nextErrors.whatsappNumber = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
    }

    if (payload.hasSecondWhatsapp && !isBlank(payload.whatsapp2Number) && !hasMinimumContactDigits(payload.whatsapp2Number)) {
      nextErrors.whatsapp2Number = "Enter at least " + MINIMUM_CONTACT_DIGITS + " digits.";
    }

    if (!isBlank(payload.email) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(payload.email).trim())) nextErrors.email = "Invalid email format.";
    if (isBlank(payload.country)) nextErrors.country = "Country is required.";
    if (isBlank(payload.buildingHouseNo)) nextErrors.buildingHouseNo = "Building / House No. is required.";
    if (isBlank(payload.postcode)) nextErrors.postcode = "Postcode No. is required.";

    const hasPrimaryAdminCategory = !isBlank(payload.administrativeCategory);
    const hasPrimaryAdminName = !isBlank(payload.municipality) || !isBlank(payload.council) || !isBlank(payload.borough) || !isBlank(payload.district);

    if (hasPrimaryAdminCategory && !hasPrimaryAdminName) {
      nextErrors.administrativeCategory = "Primary admin category requires a matching admin name.";
    }

    if (!hasPrimaryAdminCategory && hasPrimaryAdminName) {
      nextErrors.administrativeCategory = "Primary admin name requires a matching admin category.";
    }

    if (!isBlank(payload.secondaryAdministrativeCategory) && isBlank(payload.secondaryAdministrativeName)) {
      nextErrors.secondaryAdministrativeName = "Secondary admin category requires a secondary admin name.";
    }

    if (isBlank(payload.secondaryAdministrativeCategory) && !isBlank(payload.secondaryAdministrativeName)) {
      nextErrors.secondaryAdministrativeCategory = "Secondary admin name requires a secondary admin category.";
    }
    if (isBlank(payload.townCity)) nextErrors.townCity = "Town / City is required.";
    [1, 2, 3, 4, 5].forEach((rank) => {
      const method = payload["preferredContact" + rank];
      const detailField = "preferredContactDetail" + rank;
      const detail = payload[detailField];

      if (rank === 1 && isBlank(method)) nextErrors.preferredContact1 = "1st Contact Choice is required.";

      const duplicateRank = findDuplicateContactChoiceRank(method, rank, payload);
      if (duplicateRank) {
        nextErrors["preferredContact" + rank] = getDuplicateContactChoiceMessage(method, rank, duplicateRank);
      }

      if (!isBlank(method) && !["Not Applicable / N/A", "Unknown", "To be confirmed"].includes(method)) {
        const canonicalDetail = getCanonicalContactDetail(method, payload);

        if (canonicalDetail.isCanonical) {
          if (!canonicalDetail.value) {
            nextErrors[canonicalDetail.sourceField] = canonicalDetail.missingMessage;
            nextErrors[detailField] = canonicalDetail.missingMessage;
          }

          return;
        }

        if (isBlank(detail)) {
          nextErrors[detailField] = rank + " Contact Detail is required when a method is selected.";
        }
      }

      if (method === "Email" && !isBlank(detail) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(detail).trim())) {
        nextErrors[detailField] = "Invalid email format for contact detail.";
      }
    });

    if (payload.locationAdminType === "Other / Manual" && isBlank(payload.locationAdminTypeManual)) {
      nextErrors.locationAdminTypeManual = "Manual location/admin category is required when Other / Manual is selected.";
    }

    if (!payload.correspondenceSameAsResidential) {
      CORRESPONDENCE_REQUIRED_FIELDS.forEach(([fieldName, label]) => {
        if (isBlank(payload[fieldName])) {
          nextErrors[fieldName] = label + " is required when correspondence address differs from residential address.";
        }
      });

      if (!payload.correspondenceDifferenceConfirmed) {
        nextErrors.correspondenceDifferenceConfirmed = "Confirm that the correspondence address is intentionally different from the residential address.";
      }
    }

    return nextErrors;
  }

  function inputClass(field) {
    return fieldErrors[field] ? "field-input-error" : undefined;
  }

  function renderInlineError(field) {
    return fieldErrors[field] ? <small className="field-error">{fieldErrors[field]}</small> : null;
  }

  function renderNumericWarning(field) {
    return numericWarnings[field] ? <small className="field-warning-message">{numericWarnings[field]}</small> : null;
  }


  function saveClientDraftSilently(message = "Draft saved at") {
    try {
      const savedAt = new Date().toISOString();
      window.localStorage.setItem(CLIENT_ONBOARDING_DRAFT_KEY, JSON.stringify({ savedAt, form }));
      setLastDraftSavedAt(savedAt);
      setDraftSaveStatus(message + " " + new Date(savedAt).toLocaleString());
      setHasRecoverableDraft(true);
    } catch (error) {
      setDraftSaveStatus("Draft save failed. Browser local storage may be unavailable.");
    }
  }

  function saveClientDraftManually() {
    saveClientDraftSilently("Draft saved manually at");
  }

  function restoreClientDraft() {
    try {
      const rawDraft = window.localStorage.getItem(CLIENT_ONBOARDING_DRAFT_KEY);
      if (!rawDraft) {
        setDraftSaveStatus("No saved draft found.");
        setHasRecoverableDraft(false);
        return;
      }
      const draftPayload = JSON.parse(rawDraft);
      if (!draftPayload || !draftPayload.form) {
        setDraftSaveStatus("Saved draft could not be read safely.");
        return;
      }
      setForm((previous) => ({ ...previous, ...draftPayload.form }));
      setLastDraftSavedAt(draftPayload.savedAt || "");
      setDraftSaveStatus("Draft restored from local browser storage.");
      setFieldErrors({});
      setValidationErrors([]);
      setContactChoiceNotice("");
    } catch (error) {
      setDraftSaveStatus("Draft restore failed. Saved draft may be corrupted.");
    }
  }

  function clearClientDraft() {
    try {
      window.localStorage.removeItem(CLIENT_ONBOARDING_DRAFT_KEY);
      setHasRecoverableDraft(false);
      setLastDraftSavedAt("");
      setDraftSaveStatus("Saved draft cleared.");
    } catch (error) {
      setDraftSaveStatus("Draft clear failed. Browser local storage may be unavailable.");
    }
  }

  useEffect(() => {
    try {
      const rawDraft = window.localStorage.getItem(CLIENT_ONBOARDING_DRAFT_KEY);
      if (rawDraft) {
        const draftPayload = JSON.parse(rawDraft);
        setHasRecoverableDraft(true);
        setLastDraftSavedAt(draftPayload.savedAt || "");
        setDraftSaveStatus(draftPayload.savedAt ? "Recoverable draft saved at " + new Date(draftPayload.savedAt).toLocaleString() : "Recoverable draft found.");
      }
    } catch (error) {
      setHasRecoverableDraft(false);
    }
  }, []);

  useEffect(() => {
    if (!showClientProfileForm) return undefined;
    const autoSaveTimer = window.setTimeout(() => {
      saveClientDraftSilently("Auto-saved draft at");
    }, 7000);
    return () => window.clearTimeout(autoSaveTimer);
  }, [form, showClientProfileForm]);

  useEffect(() => {
    function handleBeforeUnload(event) {
      if (!showClientProfileForm) return;
      event.preventDefault();
      event.returnValue = "";
    }
    window.addEventListener("beforeunload", handleBeforeUnload);
    return () => window.removeEventListener("beforeunload", handleBeforeUnload);
  }, [showClientProfileForm]);
  async function searchGoogleContacts() {
    const query = googleContactSearch.trim();
    if (!query) {
      setGoogleContactStatus("Enter a name, phone, or email before searching Google Contacts.");
      return;
    }

    try {
      const response = await fetch("/api/google-contacts/search?q=" + encodeURIComponent(query));
      if (!response.ok) {
        throw new Error("Google Contacts connector not configured");
      }
      setGoogleContactStatus("Google Contacts connector responded. Review backend result handling in the next phase.");
    } catch (error) {
      setGoogleContactStatus("Google Contacts connector is not configured yet. Showing local client contact database results only.");
    }
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

  function isPlaceholderContactChoice(value) {
    return ["", "Not Applicable / N/A", "Unknown", "To be confirmed"].includes(String(value || ""));
  }

  function findDuplicateContactChoiceRank(nextChoice, rank, currentForm) {
    if (isPlaceholderContactChoice(nextChoice)) return null;

    for (let i = 1; i <= 5; i += 1) {
      if (i === rank) continue;
      if (currentForm["preferredContact" + i] === nextChoice) return i;
    }

    return null;
  }

  function getDuplicateContactChoiceMessage(nextChoice, rank, duplicateRank) {
    return (
      getContactChoiceLabel(rank) +
      ' cannot reuse "' +
      nextChoice +
      '" because it is already selected as ' +
      getContactChoiceLabel(duplicateRank) +
      ". Please choose a different contact method."
    );
  }

  function renderContactMethodOptions(rank) {
    return CONTACT_METHOD_OPTIONS.map((option) => {
      const duplicateRank = findDuplicateContactChoiceRank(option, rank, form);
      const isDisabled = Boolean(duplicateRank);

      return (
        <option key={option} value={option} disabled={isDisabled}>
          {option}{isDisabled ? " (already selected as " + getContactChoiceLabel(duplicateRank) + ")" : ""}
        </option>
      );
    });
  }

  function getActiveContactChoiceSummary() {
    return CONTACT_CHOICE_FIELDS
      .map((rank) => {
        const value = form["preferredContact" + rank];
        return isPlaceholderContactChoice(value) ? "" : getContactChoiceLabel(rank) + ": " + value;
      })
      .filter(Boolean);
  }

  function renderPreferredContactDetailField(rank) {
    const method = form["preferredContact" + rank];
    const detailField = "preferredContactDetail" + rank;
    const canonicalDetail = getCanonicalContactDetail(method, form);
    const ordinalLabel = getContactChoiceLabel(rank).replace(" Choice", " Detail");

    if (canonicalDetail.isCanonical) {
      return (
        <label>
          {ordinalLabel}
          <input
            className="canonical-contact-display"
            value={canonicalDetail.value || ""}
            readOnly
            placeholder={canonicalDetail.sourceLabel + " will be reused from above"}
          />
          <small>{canonicalDetail.helper}</small>
          {!canonicalDetail.value && <small className="field-warning-message">{canonicalDetail.missingMessage}</small>}
          {renderInlineError(detailField)}
        </label>
      );
    }

    return (
      <label>
        {ordinalLabel}
        <input
          className={inputClass(detailField)}
          value={form[detailField]}
          onChange={(event) => updateForm(detailField, event.target.value)}
          placeholder={"Phone, email, or contact detail for " + rank + " choice"}
        />
        {renderInlineError(detailField)}
        {renderNumericWarning(detailField)}
      </label>
    );
  }

  function updateForm(field, value) {
    let safeValue = value;

    const contactRankMatch = String(field).match(/^preferredContact([1-5])$/);
    if (contactRankMatch) {
      const rank = Number(contactRankMatch[1]);
      const duplicateRank = findDuplicateContactChoiceRank(value, rank, form);

      if (duplicateRank) {
        const message = getDuplicateContactChoiceMessage(value, rank, duplicateRank);
        setContactChoiceNotice(message);
        setFieldErrors((previous) => ({
          ...previous,
          [field]: message
        }));
        showStatus(message, "warning");

        if (typeof window !== "undefined" && typeof window.alert === "function") {
          window.alert(message);
        }

        return;
      }

      setContactChoiceNotice("");
    }

    if (shouldSanitizeNumericField(field, form)) {
      const digitsOnly = String(value || "").replace(/\D/g, "");
      const hadInvalidCharacters = String(value || "") !== digitsOnly;
      safeValue = digitsOnly;
      setNumericWarnings((previous) => ({
        ...previous,
        [field]: hadInvalidCharacters ? "Only numeric characters are allowed. Please enter a valid phone number." : ""
      }));
    } else {
      setNumericWarnings((previous) => ({ ...previous, [field]: "" }));
    }

    setFieldErrors((previous) => ({ ...previous, [field]: undefined }));

    setForm((previous) => {
      const next = {
        ...previous,
        [field]: safeValue
      };
      if (field === "hasDependents") {
        const checked = Boolean(value);
        next.hasDependents = checked;
        if (!checked) {
          next.dependentsCount = "";
          next.dependentNotes = "";
        }
      }

      if (field === "willStatus" && value !== "Yes") {
        next.willReferenceNotes = "";
        next.willRestrictedAccess = false;
        next.willAuthorizedParties = [];
      }

      if (field === "caseOriginType" && value !== "Inherited / Taken Over from Another Firm") {
        next.previousFirmName = "";
      }

      if (field === "caseOriginType" && value !== "Joint Representation / Multi-firm Action") {
        next.coCounselNotes = "";
      }

      if (field === "accommodationRequired") {
        const checked = Boolean(value);
        next.accommodationRequired = checked;
        if (!checked) next.accommodationNotes = "";
      }

      if (field === "healthDisabilityStatus" && value === "None") {
        next.accommodationRequired = false;
        next.accommodationNotes = "";
      }
      if (field === "isClientUnavailable") {
        const checked = Boolean(value);
        next.isClientUnavailable = checked;
        if (!checked) {
          next.unavailableUntilDate = "";
          next.unavailableUntilTime = "";
          next.availabilityReason = "Not Applicable / N/A";
          next.availabilityReasonOther = "";
        }
      }

      if (field === "enableCommunicationTimingNotes") {
        const checked = Boolean(value);
        next.enableCommunicationTimingNotes = checked;
        if (!checked) next.communicationTimingNotes = "";
      }

      if (field === "correspondenceSameAsResidential") {
        const checked = Boolean(value);
        next.correspondenceSameAsResidential = checked;

        if (checked) {
          Object.assign(next, getCorrespondenceAddressUpdatesFromResidential(next));
        }
      }

      if (field === "correspondenceDifferenceConfirmed") {
        next.correspondenceDifferenceConfirmed = Boolean(value);
      }

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

      if (next.correspondenceSameAsResidential) {
        Object.assign(next, getCorrespondenceAddressUpdatesFromResidential(next));
      }

      return next;
    });
  }

  function resetForm() {
    setForm(EMPTY_CLIENT);
    setValidationErrors([]);
    setFieldErrors({});
    setNumericWarnings({});
    setContactChoiceNotice("");
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
      ["phoneCountryCode", "Primary Phone Country Code"],
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

    if (isBlank(payload.phoneNumber)) {
      missingMandatory.push("Primary Phone Number");
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
    if (!payload.documentationVerificationCompleted) requireMandatory("Document Type", payload.documentType);
    if (!payload.documentationVerificationCompleted) requireMandatory("Document Status", payload.documentStatus);
    if (!payload.documentationVerificationCompleted) requireMandatory("Verification / Review Status", payload.verificationStatus);

    if (isBlank(payload.phoneNumber)) {
      errors.push("Primary Phone Number is required for client profile completion.");
    } else if (!hasMinimumContactDigits(payload.phoneNumber)) {
      errors.push("Primary Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits.");
    }

    if (payload.hasBackupPhone) {
      if (isBlank(payload.backupPhoneNumber)) {
        errors.push("Secondary / Backup Phone Number is enabled. Enter at least " + MINIMUM_CONTACT_DIGITS + " digits or untick the backup number option.");
      } else if (!hasMinimumContactDigits(payload.backupPhoneNumber)) {
        errors.push("Secondary / Backup Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits.");
      }
    }

    CONTACT_CHOICE_FIELDS.forEach((rank) => {
      const method = payload["preferredContact" + rank];
      const duplicateRank = findDuplicateContactChoiceRank(method, rank, payload);

      if (duplicateRank && duplicateRank < rank) {
        errors.push(getDuplicateContactChoiceMessage(method, rank, duplicateRank));
      }

      const canonicalDetail = getCanonicalContactDetail(method, payload);
      if (canonicalDetail.isCanonical && !canonicalDetail.value) {
        errors.push(getContactChoiceLabel(rank) + " cannot be completed yet. " + canonicalDetail.missingMessage);
      }
    });

    if (!payload.correspondenceSameAsResidential) {
      CORRESPONDENCE_REQUIRED_FIELDS.forEach(([fieldName, label]) => {
        if (isBlank(payload[fieldName])) {
          errors.push(label + " is required when correspondence address differs from residential address.");
        }
      });

      if (!payload.correspondenceDifferenceConfirmed) {
        errors.push("Confirm that the correspondence address is intentionally different from the residential address.");
      }
    }

    if (payload.hasDependents && isBlank(payload.dependentsCount)) {
      errors.push("Number of Dependents is required when Has Dependents is selected.");
    }

    if (payload.dependentsCount && Number(payload.dependentsCount) < 0) {
      errors.push("Number of Dependents cannot be negative.");
    }

    if (payload.totalMattersCount && Number(payload.totalMattersCount) < 0) {
      errors.push("Total Matters / Cases Count cannot be negative.");
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

    if (payload.phoneNumber && !hasMinimumContactDigits(payload.phoneNumber)) {
      errors.push("Primary Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits.");
    }

    if (payload.backupPhoneNumber && !hasMinimumContactDigits(payload.backupPhoneNumber)) {
      errors.push("Backup Phone Number must contain at least " + MINIMUM_CONTACT_DIGITS + " digits.");
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

    const preparedForm = prepareClientFormForValidation(form);
    setForm(preparedForm);

    const { errors, flags } = validateClientForm(preparedForm);
    const nextFieldErrors = deriveFieldErrors(preparedForm);
    const mergedErrors = Array.from(new Set([...errors, ...Object.values(nextFieldErrors).filter(Boolean)]));
    setFieldErrors(nextFieldErrors);
    setValidationErrors(mergedErrors);

    if (mergedErrors.length > 0) {
      window.alert("We couldn’t save yet. Please correct the highlighted fields.");
      showStatus("We couldn’t save yet. Please correct the highlighted fields.", "error");
      return;
    }

    let formForSave = {
      ...preparedForm,
      verificationFlags: flags,
      verificationStatus: flags.length > 0 ? "Review Required" : preparedForm.verificationStatus
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

  function viewClientProfile(client) {
    const normalized = normalizeClient(client);
    setViewingClientProfile(normalized);
    window.setTimeout(() => {
      document.querySelector(".client-profile-view-card")?.scrollIntoView({
        behavior: "smooth",
        block: "start"
      });
    }, 50);
  }

  function closeClientProfileView() {
    setViewingClientProfile(null);
  }
  function editClient(client) {
    /* L360_DASHBOARD_V3C_EDIT_REVEAL */
    setShowClientProfileForm(true);
    const normalized = normalizeClient(client);

    setEditingId(getClientId(normalized));
    setForm({
      ...EMPTY_CLIENT,
      ...normalized,
      genderSource: normalized.gender ? "manual" : "auto"
    });
    setValidationErrors([]);
    setFieldErrors({});
    setNumericWarnings({});
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
        normalized.preferredContact4,
        normalized.preferredContact5,
        normalized.preferredContactDetail1,
        normalized.preferredContactDetail2,
        normalized.preferredContactDetail3,
        normalized.preferredContactDetail4,
        normalized.preferredContactDetail5,
        normalized.emergencyContactName,
        normalized.emergencyContactRelationship,
        normalized.emergencyContactNumber,
        normalized.addressType,
        normalized.country,
        normalized.continent,
        normalized.region,
        normalized.townCity,
        normalized.district,
        normalized.state,
        normalized.municipality,
        normalized.council,
        normalized.borough,
        normalized.locationAdminType,
        normalized.locationAdminTypeManual,
        normalized.googleContactResourceName,
        normalized.linkedClientId,
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

      return getClientLookupFieldText(normalized, clientLookupSearchBy).includes(query);
    });
  }, [clients, searchTerm, clientLookupSearchBy]);
  const clientNameSuggestions = useMemo(() => {
    return Array.from(new Set(clients.map(getClientDirectoryName).filter(Boolean))).sort((a, b) => a.localeCompare(b));
  }, [clients]);

  const clientTagOptions = useMemo(() => {
    const collected = new Set(DEFAULT_CLIENT_TAG_OPTIONS);
    clients.forEach((client) => {
      normalizeClientTagList(client.clientTags || client.tags).forEach((tag) => collected.add(tag));
      if (client.clientCategory) collected.add(client.clientCategory);
      if (client.verificationStatus) collected.add(client.verificationStatus);
    });
    return Array.from(collected).filter(Boolean).sort((a, b) => a.localeCompare(b));
  }, [clients]);


  function getClientLookupFieldText(client, mode = "All Fields") {
    const normalized = normalizeClient(client);
    const addressText = [
      normalized.buildingHouseNo,
      normalized.buildingHouseName,
      normalized.streetAddress,
      normalized.postcode,
      normalized.district,
      normalized.townCity,
      normalized.stateProvinceTerritory || normalized.state,
      normalized.municipality,
      normalized.council,
      normalized.borough,
      normalized.locationAdminCategoryType,
      normalized.country
    ].filter(Boolean).join(" ");

    const tagText = Array.isArray(normalized.clientTags)
      ? normalized.clientTags.join(" ")
      : String(normalized.clientTags || "");

    const fields = {
      "All Fields": [
        normalized.titlePrefix,
        normalized.givenName,
        normalized.surname,
        normalized.initials,
        normalized.gender,
        normalized.ethnicity,
        normalized.ethnicityOther,
        normalized.nationality,
        normalized.residencyStatus,
        normalized.identificationKind,
        normalized.identityCardColour,
        normalized.nricPassportNumber,
        normalized.dateOfBirth,
        normalized.stateOfBirth,
        normalized.email,
        normalized.phoneNumber,
        normalized.backupPhoneNumber,
        normalized.whatsappNumber,
        normalized.documentType,
        normalized.documentStatus,
        normalized.verificationStatus,
        normalized.clientCategory,
        tagText,
        addressText,
        normalized.specialRemarksStaffLawyerNotes,
        normalized.staffLawyerRemarks,
        normalized.missingInformationNotes,
        Array.isArray(normalized.verificationFlags) ? normalized.verificationFlags.join(" ") : ""
      ],
      "Client Name": [normalized.titlePrefix, normalized.givenName, normalized.surname, normalized.initials],
      "Phone / WhatsApp": [normalized.phoneNumber, normalized.backupPhoneNumber, normalized.whatsappNumber, formatPhoneDisplay(normalized.phoneCountryCode, normalized.phoneNumber)],
      "Email": [normalized.email],
      "NRIC / Passport": [normalized.nricPassportNumber, normalized.identificationKind, normalized.identityCardColour],
      "Date of Birth": [normalized.dateOfBirth],
      "State of Birth": [normalized.stateOfBirth],
      "Gender": [normalized.gender],
      "Ethnicity": [normalized.ethnicity, normalized.ethnicityOther],
      "Nationality / Residency": [normalized.nationality, normalized.residencyStatus],
      "Document Status": [normalized.documentType, normalized.documentStatus, normalized.verificationStatus],
      "Postcode": [normalized.postcode],
      "Administrative Location": [normalized.district, normalized.townCity, normalized.stateProvinceTerritory || normalized.state, normalized.municipality, normalized.council, normalized.borough, normalized.locationAdminCategoryType],
      "Category / Tag": [normalized.clientCategory, tagText],
      "Remarks / Notes": [normalized.specialRemarksStaffLawyerNotes, normalized.staffLawyerRemarks, normalized.missingInformationNotes, Array.isArray(normalized.verificationFlags) ? normalized.verificationFlags.join(" ") : ""]
    };

    return (fields[mode] || fields["All Fields"]).filter(Boolean).join(" ").toLowerCase();
  }
  const filteredDirectoryClients = useMemo(() => {
    return [...filteredClients]
      .filter((client) => activeAlphabetFilter === "All" || getClientDirectoryInitial(client) === activeAlphabetFilter)
      .filter((client) => {
        if (selectedClientTagFilter === "All") return true;
        const tags = normalizeClientTagList(client.clientTags || client.tags);
        return tags.includes(selectedClientTagFilter) || client.clientCategory === selectedClientTagFilter || client.verificationStatus === selectedClientTagFilter;
      })
      .filter((client) => {
        const manualTagQuery = manualClientTagSearch.trim().toLowerCase();
        if (!manualTagQuery) return true;
        const tagText = [
          client.clientCategory,
          client.verificationStatus,
          ...normalizeClientTagList(client.clientTags || client.tags)
        ].filter(Boolean).join(" ").toLowerCase();
        return tagText.includes(manualTagQuery);
      })
      .sort((a, b) => getClientDirectoryName(a).localeCompare(getClientDirectoryName(b)));
  }, [filteredClients, activeAlphabetFilter, selectedClientTagFilter, manualClientTagSearch]);

  return (
    <section className={"client-module client-v6 " + (showClientProfileForm ? "client-profile-form-open" : "client-profile-form-closed")}>      <style>{`
        /* L360_DASHBOARD_V3G2_FINAL_SEARCH_VIEW_CLEANUP */
        .client-contact-search-panel,
        .client-search-row {
          display: none !important;
        }
        .client-alphabet-filter.two-rows {
          display: grid;
          gap: 6px;
          justify-items: center;
        }
        .client-alphabet-filter.two-rows .alphabet-action-row {
          display: contents;
        }
        .client-alphabet-filter.two-rows .alphabet-row {
          display: flex;
          flex-wrap: wrap;
          justify-content: center;
          gap: 6px;
          width: 100%;
        }
        .client-alphabet-filter.two-rows button {
          flex: 0 0 auto;
          min-width: 42px;
          width: auto;
          max-width: 190px;
          white-space: nowrap;
        }
        .client-alphabet-filter.two-rows .show-all-clients-chip {
          min-width: 140px;
          max-width: 190px;
        }
        .client-contact-meta {
          display: flex;
          flex-wrap: wrap;
          gap: 4px 12px;
          align-items: center;
        }
        .client-directory-mini-card-actions {
          display: flex;
          flex-wrap: wrap;
          gap: 6px;
          margin-top: 10px;
        }
        .client-profile-view-card {
          border: 1px solid rgba(148, 163, 184, 0.45);
          border-radius: 16px;
          background: #ffffff;
          padding: 16px;
          margin: 16px 0;
        }
        .client-profile-view-header {
          display: flex;
          justify-content: space-between;
          gap: 12px;
          align-items: flex-start;
          flex-wrap: wrap;
          margin-bottom: 12px;
        }
        .client-profile-view-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
          gap: 10px;
        }
        .client-profile-view-grid > div {
          border: 1px solid rgba(226, 232, 240, 0.95);
          border-radius: 12px;
          padding: 10px;
          background: rgba(248, 250, 252, 0.72);
        }
        .client-profile-view-grid strong,
        .client-profile-view-grid span {
          display: block;
        }
        .client-profile-view-grid .full {
          grid-column: 1 / -1;
        }
        /* L360_DASHBOARD_V3E_FINAL_CLEANUP */
        .client-profile-form-closed .client-form-v6,
        .client-profile-form-closed .client-validation-box {
          display: none !important;
        }

        .client-directory-control-panel {
          display: flex !important;
          flex-direction: column !important;
          gap: 10px !important;
        }

        .client-directory-summary-row {
          order: 2 !important;
        }

        .client-directory-mini-list {
          order: 3 !important;
        }

        .client-alphabet-filter {
          order: 4 !important;
        }

        .client-alphabet-filter.two-rows {
          display: grid !important;
          gap: 6px !important;
          margin: 10px 0 !important;
        }

        .client-alphabet-filter.two-rows .alphabet-action-row {
          display: flex !important;
          gap: 6px !important;
          justify-content: flex-start !important;
        }

        .client-alphabet-filter.two-rows .alphabet-row {
          display: grid !important;
          grid-template-columns: repeat(13, minmax(20px, 1fr)) !important;
          gap: 4px !important;
        }

        .client-alphabet-filter.two-rows button {
          min-width: 0 !important;
          width: 100% !important;
          padding: 4px 0 !important;
          font-size: 11px !important;
          text-align: center !important;
        }

        .client-directory-mini-card span,
        .client-contact-result-card span {
          white-space: normal !important;
          line-height: 1.25 !important;
        }

        .client-directory-mini-card {
          min-height: auto !important;
        }

        .client-form-v6 label.full > button.btn-small {
          margin-top: 8px;
        }
        /* L360_SURGICAL_CLIENT_PATCH_V2_STYLE */
        /* L360_DASHBOARD_V3F_BUILD_FIX_UI_REFINEMENT */
        .extended-contact-choices {
          display: contents;
        }
        .client-alphabet-filter.two-rows {
          align-items: center;
          justify-items: center;
        }
        .client-alphabet-filter.two-rows .alphabet-action-row,
        .client-alphabet-filter.two-rows .alphabet-row {
          display: flex !important;
          justify-content: center !important;
          align-items: center !important;
          gap: 6px !important;
          width: 100%;
        }
        .client-alphabet-filter.two-rows .alphabet-action-row button,
        .client-alphabet-filter.two-rows button {
          width: auto !important;
          flex: 0 0 auto !important;
          min-width: 42px;
          max-width: 180px;
          white-space: nowrap;
        }
        .client-alphabet-filter.two-rows .alphabet-action-row button {
          min-width: 130px;
        }
        .client-directory-result-actions {
          display: flex;
          flex-wrap: wrap;
          gap: 6px;
          align-items: center;
          justify-content: flex-end;
        }
        .client-profile-preview-card {
          border: 1px solid rgba(15, 23, 42, 0.14);
          border-radius: 14px;
          padding: 14px;
          margin: 14px 0;
          background: #ffffff;
          box-shadow: 0 10px 24px rgba(15, 23, 42, 0.06);
        }
        .client-profile-preview-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 10px;
          margin-bottom: 10px;
        }
        .client-profile-preview-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
          gap: 10px;
          margin-bottom: 12px;
        }
        .client-form-has-errors input:required:invalid,
        .client-form-has-errors select:required:invalid,
        .field-input-error {
          border: 2px solid #dc2626 !important;
          background: #fff1f2 !important;
          box-shadow: 0 0 0 1px rgba(220, 38, 38, 0.12);
        }
        .field-error,
        .field-warning-message {
          display: block;
          color: #b91c1c;
          font-weight: 700;
          margin-top: 4px;
        }
        .client-contact-search-panel {
          border: 1px solid rgba(148, 163, 184, 0.45);
          border-radius: 14px;
          padding: 14px;
          margin: 14px 0;
          background: rgba(248, 250, 252, 0.92);
        }
        .client-contact-result-list {
          display: grid;
          gap: 8px;
          margin-top: 10px;
        }
        .client-contact-result-card {
          display: flex;
          justify-content: space-between;
          gap: 10px;
          align-items: center;
          padding: 10px;
          border: 1px solid rgba(148, 163, 184, 0.35);
          border-radius: 12px;
          background: #ffffff;
        }
        /* L360_CLIENT_DIRECTORY_V3C_STYLE */
        .client-directory-control-panel {
          border: 1px solid rgba(148, 163, 184, 0.45);
          border-radius: 16px;
          padding: 16px;
          margin: 16px 0;
          background: rgba(255, 255, 255, 0.94);
        }
        .client-directory-header-row,
        .client-directory-summary-row {
          display: flex;
          justify-content: space-between;
          gap: 12px;
          align-items: center;
          flex-wrap: wrap;
        }
        .client-directory-actions {
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
        }
        .client-alphabet-filter,
        .client-search-history {
          display: flex;
          flex-wrap: wrap;
          gap: 6px;
          margin: 12px 0;
        }
        .client-alphabet-filter button,
        .client-search-history button {
          border: 1px solid rgba(148, 163, 184, 0.55);
          border-radius: 999px;
          padding: 5px 10px;
          background: #fff;
          cursor: pointer;
        }
        .client-alphabet-filter button.active {
          font-weight: 800;
          border-color: #2563eb;
          box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.12);
        }
        .client-directory-mini-list {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
          gap: 10px;
          margin-top: 12px;
        }
        .client-directory-mini-card {
          text-align: left;
          border: 1px solid rgba(148, 163, 184, 0.45);
          border-radius: 12px;
          padding: 10px;
          background: #fff;
          cursor: pointer;
        }
        .client-directory-mini-card span {
          display: block;
          margin-top: 4px;
          font-size: 0.86rem;
          opacity: 0.78;
        }
      `}</style>
      <div className="client-module-header" id="clients-page-top">
        <div>
          <p className="client-profile-summary-kicker">Stage 2 · Client Gate</p>
          <h2>Client Search & Duplicate Detection</h2>
          <p className="mandatory-note">
            Search first, then link an existing client or continue to new client details. This page preserves the full original client profile, directory, validation, draft, and manual management process.
          </p>

          <div className="client-flow-bridge-panel" role="navigation" aria-label="Clients page workflow navigation">
            <strong>Step 2 of 6</strong>
            <p>
              Use these standard controls to reorient, return home, continue the guided workflow, or jump to the end of this page.
            </p>
            <div className="client-directory-actions" aria-label="Standard page navigation controls">
              <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Matter Intake")}>← Previous Page</button>
              <button type="button" className="btn btn-secondary btn-small" onClick={() => setModule?.("Home")}>Home Main Page</button>
              <button type="button" className="btn btn-primary btn-small" onClick={() => setModule?.("Matter Intake")}>Continue to Next Step →</button>
              <button type="button" className="btn btn-secondary btn-small" onClick={() => window.scrollTo({ top: document.documentElement.scrollHeight, behavior: "smooth" })}>Go to Bottom/End of Page ↓</button>
            </div>
          </div>
        <aside className="client-profile-summary-rail" aria-label="Client profile summary and section navigation">
                    <div className="client-profile-summary-card">
            <p className="client-profile-summary-kicker">Client Summary Dashboard</p>
            <h3>Client Summary Dashboard</h3>
            <p>
              Summary navigation for the preserved Clients workflow. Original fields, validation, backend checks,
              local fallback, draft behaviour, required-field rules, and manual management protocols remain unchanged.
            </p>
          </div>

          <nav className="client-profile-summary-card" aria-label="Client profile section checklist">
            <p className="client-profile-summary-kicker">Section Checklist</p>
            <ol className="client-profile-summary-list">
              <li><a href="#client-profile-details" className="client-profile-summary-link">Client Identity & Authority</a></li>
              <li><a href="#client-identification-details" className="client-profile-summary-link">Client Identification Details</a></li>
              <li><a href="#client-employment-details" className="client-profile-summary-link">Employment & Organisation Details</a></li>
              <li><a href="#client-family-marital-details" className="client-profile-summary-link">Family and Marital Details</a></li>
              <li><a href="#client-matter-context-origin" className="client-profile-summary-link">Matter Context and Case Origin</a></li>
              <li><a href="#client-source-value-indicators" className="client-profile-summary-link">Client Source and Value Indicators</a></li>
              <li><a href="#client-will-estate-metadata" className="client-profile-summary-link">Will / Estate Handling Metadata</a></li>
              <li><a href="#client-health-oku-accommodation" className="client-profile-summary-link">Health / OKU / Disability and Accommodation Metadata</a></li>
              <li><a href="#client-contact-communication-preferences" className="client-profile-summary-link">Contact Information and Communication Preferences</a></li>
              <li><a href="#client-address-service-location" className="client-profile-summary-link">Address and Service Location Details</a></li>
              <li><a href="#client-emergency-next-of-kin" className="client-profile-summary-link">Emergency Contact / Next of Kin Details</a></li>
              <li><a href="#client-documentation-verification" className="client-profile-summary-link">Documentation Verification Status</a></li>
              <li><a href="#client-internal-remarks-issues" className="client-profile-summary-link">Internal Remarks / Pending Information</a></li>
            </ol>
          </nav>
</aside>
        </div>

        <div className="client-count-card">
          <strong>All Clients ({clients.length})</strong>
          <span>Showing {filteredDirectoryClients.length} of {clients.length}</span>
        </div>
      </div>

      {status && (
        <p className={"client-status client-status-" + statusType}>
          {status}
        </p>
      )}

      <section className="client-profile-completion-shell" aria-labelledby="client-profile-completion-heading">
        <div className="client-profile-completion-header">
          <div>
            <p className="client-profile-completion-kicker">Client File Alert / Status</p>
            <h3 id="client-profile-completion-heading">Client Profile Completion Status</h3>
            <p>
              Existing Clients validation, required fields, backend checks, local fallback,
              draft behaviour, create/save controls, and manual-management protocols remain authoritative.
            </p>
          </div>
        </div>

        <ClientRequiredFieldCounter />

        <ClientSectionCompletionStatus />

        <div className="client-profile-completion-links" aria-label="Completion review jump links">
          <a href="#client-profile-details">Identity & Authority</a>
          <a href="#client-contact-communication-preferences">Contact</a>
          <a href="#client-address-service-location">Address</a>
          <a href="#client-documentation-verification">Documentation</a>
          <a href="#client-internal-remarks-issues">Pending Info</a>
        </div>
      </section>
<div className="client-directory-control-panel">
        <div className="client-directory-header-row">
          <div>
            <h3>Advanced Client Directory / Manual Management</h3>
            <p className="mandatory-note">Saved clients are searchable, alphabetically indexed, and filterable without opening the full client profile form. Google Contacts can be included only when contacts are imported into Litigation 360 or when a backend Google Contacts connector endpoint is active.</p>
          </div>
          <div className="client-directory-actions">
            <button type="button" className="btn btn-primary" onClick={openNewClientProfile}>
              + Add/Create New Client Profile
            </button>
            {showClientProfileForm && (
              <button type="button" className="btn btn-secondary" onClick={closeClientProfileForm}>
                Hide Client Profile Form
              </button>
            )}
          </div>
        </div>

        <div className="inline-fields four-even">
          <label>
            Search By
            <select value={clientLookupSearchBy} onChange={(event) => setClientLookupSearchBy(event.target.value)}>
              {[
                "All Fields",
                "Client Name",
                "Phone / WhatsApp",
                "Email",
                "NRIC / Passport",
                "Date of Birth",
                "State of Birth",
                "Gender",
                "Ethnicity",
                "Nationality / Residency",
                "Document Status",
                "Postcode",
                "Administrative Location",
                "Category / Tag",
                "Remarks / Notes"
              ].map((option) => (
                <option key={option} value={option}>{option}</option>
              ))}
            </select>
          </label>

          <label>
            Search Existing Client
            <input
              list="client-directory-name-suggestions"
              value={searchTerm}
              onChange={handleDirectorySearchChange}
              placeholder="Search as you type: name, phone, WhatsApp, email, NRIC/passport, postcode, town/city, district, municipality, council, borough, state, tags or remarks"
            />
            <datalist id="client-directory-name-suggestions">
              {clientNameSuggestions.map((name) => <option key={name} value={name} />)}
            </datalist>
          </label>

          <label>
            Manual Client Selection
            <select
              value=""
              onChange={(event) => {
                const selected = clients.find((client) => getClientId(client) === event.target.value);
                if (selected) selectClientFromDirectory(selected);
              }}
            >
              <option value="">Select existing client</option>
              {clients
                .slice()
                .sort((a, b) => getClientDirectoryName(a).localeCompare(getClientDirectoryName(b)))
                .map((client) => (
                  <option key={getClientId(client) || getClientDirectoryName(client)} value={getClientId(client)}>
                    {getClientDirectoryName(client)}
                  </option>
                ))}
            </select>
          </label>

          <label>
            Category / Tag
            <select value={selectedClientTagFilter} onChange={(event) => setSelectedClientTagFilter(event.target.value)}>
              <option value="All">All Tags / Categories</option>
              {clientTagOptions.map((tag) => <option key={tag} value={tag}>{tag}</option>)}
            </select>
            <input
              value={manualClientTagSearch}
              onChange={(event) => setManualClientTagSearch(event.target.value)}
              placeholder="Type tag/category manually"
            />
          </label>
        </div>

        <div className="client-alphabet-filter two-rows" aria-label="Client alphabet filter">
          <div className="alphabet-action-row">
            <button type="button" className={"show-all-clients-chip " + (activeAlphabetFilter === "All" ? "active" : "")} onClick={clearDirectoryFilters}>Show All Clients</button>
          </div>
          <div className="alphabet-row">
            {CLIENT_DIRECTORY_ALPHABET.slice(0, 13).map((letter) => (
              <button
                type="button"
                key={letter}
                className={activeAlphabetFilter === letter ? "active" : ""}
                onClick={() => setActiveAlphabetFilter(letter)}
              >
                {letter}
              </button>
            ))}
          </div>
          <div className="alphabet-row">
            {CLIENT_DIRECTORY_ALPHABET.slice(13).map((letter) => (
              <button
                type="button"
                key={letter}
                className={activeAlphabetFilter === letter ? "active" : ""}
                onClick={() => setActiveAlphabetFilter(letter)}
              >
                {letter}
              </button>
            ))}
          </div>
        </div>

        {clientSearchHistory.length > 0 && (
          <div className="client-search-history">
            <strong>Recent searches:</strong>
            {clientSearchHistory.map((item) => (
              <button type="button" key={item} onClick={() => setSearchTerm(item)}>{item}</button>
            ))}
            <button type="button" onClick={() => setClientSearchHistory([])}>Clear History</button>
          </div>
        )}

      </div>

      {/* L360_DASHBOARD_V3G2_VIEW_PROFILE_PANEL */}
      {viewingClientProfile && (
        <section className="client-profile-view-card">
          <div className="client-profile-view-header">
            <div>
              <h3>View Client Profile</h3>
              <p className="mandatory-note">Read-only client profile view. Use Edit / Amend to change details.</p>
            </div>
            <div className="client-directory-actions">
              <button type="button" className="btn btn-secondary btn-small" onClick={() => editClient(viewingClientProfile)}>
                Edit / Amend
              </button>
              <button type="button" className="btn btn-secondary btn-small" onClick={closeClientProfileView}>
                Close View
              </button>
            </div>
          </div>

          <div className="client-profile-view-grid">
            <div><strong>Client ID</strong><span>{getClientId(viewingClientProfile) || "Not assigned"}</span></div>
            <div><strong>Name</strong><span>{getClientDirectoryName(viewingClientProfile)}</span></div>
            <div><strong>Email</strong><span>{viewingClientProfile.email || "No email"}</span></div>
            <div><strong>Phone / WhatsApp</strong><span>{formatPhoneDisplay(viewingClientProfile.phoneCountryCode, viewingClientProfile.phoneNumber) || viewingClientProfile.phoneNumber || "No phone"}</span></div>
            <div><strong>NRIC / Passport</strong><span>{viewingClientProfile.nricPassportNumber || "Not recorded"}</span></div>
            <div><strong>Gender / Ethnicity</strong><span>{[viewingClientProfile.gender, viewingClientProfile.ethnicity].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
            <div><strong>Date / State of Birth</strong><span>{[viewingClientProfile.dateOfBirth, viewingClientProfile.stateOfBirth].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
            <div><strong>Document Status</strong><span>{[viewingClientProfile.documentType, viewingClientProfile.documentStatus, viewingClientProfile.verificationStatus].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
            <div className="full"><strong>Address</strong><span>{[viewingClientProfile.buildingHouseNo, viewingClientProfile.postcode, viewingClientProfile.district, viewingClientProfile.townCity, viewingClientProfile.stateProvinceTerritory || viewingClientProfile.state, viewingClientProfile.country].filter(Boolean).join(", ") || "No address recorded"}</span></div>
            <div className="full"><strong>Emergency Contact / Next of Kin</strong><span>{[viewingClientProfile.emergencyContactName, viewingClientProfile.emergencyContactRelationship, viewingClientProfile.emergencyContactNumber].filter(Boolean).join(" / ") || "Not recorded"}</span></div>
            <div className="full"><strong>Remarks / Notes</strong><span>{viewingClientProfile.specialRemarksStaffLawyerNotes || viewingClientProfile.staffLawyerRemarks || viewingClientProfile.missingInformationNotes || "No remarks recorded"}</span></div>
          </div>
        </section>
      )}
      <div className="client-contact-search-panel">
        <h3>Client Search / Contact Lookup</h3>
        <p className="mandatory-note">
          Search by name, phone, WhatsApp, email, NRIC/passport, postcode, town, district, municipality, council, borough, state, or remarks before creating a duplicate profile.
        </p>
        <div className="inline-fields two-even">
          <input
            value={contactDatabaseSearch}
            onChange={(event) => setContactDatabaseSearch(event.target.value)}
            placeholder="Search local client contact database"
          />
          <input
            value={googleContactSearch}
            onChange={(event) => setGoogleContactSearch(event.target.value)}
            placeholder="Google Contacts search-ready field"
          />
        </div>
        <button type="button" className="btn btn-secondary" onClick={searchGoogleContacts}>Search Google Contacts Connector</button>
        {googleContactStatus && <small className="field-warning-message">{googleContactStatus}</small>}
        {contactDatabaseResults.length > 0 && (
          <div className="client-contact-result-list">
            {contactDatabaseResults.map((client) => (
              <div className="client-contact-result-card" key={getClientId(client) || client.email || client.phoneNumber}>
                <span>
                  <strong>{[client.givenName, client.surname].filter(Boolean).join(" ") || client.name || "Unnamed client"}</strong><br />
                  <span className="client-contact-meta">
                    <span>{client.email || "No email"}</span>
                    <span>{formatPhoneDisplay(client.phoneCountryCode, client.phoneNumber) || "No phone"}</span>
                    <span>{client.townCity || "No town/city"}</span>
                  </span>
                </span>
                                <div className="client-directory-result-actions">
                  <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); viewClientProfile(client); }}>View Client Profile</button>
                  <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); editClient(client); }}>Edit / Amend</button>
                  <button type="button" className="btn btn-secondary btn-small" onClick={(event) => { event.stopPropagation(); deleteClient(client); }}>Delete</button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

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

      <form className={"client-form client-form-v6" + (validationErrors.length > 0 ? " client-form-has-errors" : "")} onSubmit={saveClient} style={{ display: showClientProfileForm ? undefined : "none" }}>
        <div className="client-draft-save-panel">
          <div>
            <strong>Draft Protection</strong>
            <small>{draftSaveStatus}</small>
            {lastDraftSavedAt && (
              <small>Last saved: {new Date(lastDraftSavedAt).toLocaleString()}</small>
            )}
          </div>
          <div className="inline-actions">
            <button type="button" className="btn btn-secondary btn-small" onClick={saveClientDraftManually}>Manual Save Draft</button>
            <button type="button" className="btn btn-secondary btn-small" onClick={restoreClientDraft} disabled={!hasRecoverableDraft}>Restore Draft</button>
            <button type="button" className="btn btn-secondary btn-small" onClick={clearClientDraft} disabled={!hasRecoverableDraft}>Clear Draft</button>
          </div>
          <small className="field-warning-message">Drafts are saved locally in this browser to protect against refresh, accidental navigation, browser crash, or timeout.</small>
        </div>
        {(() => {
          const progress = getClientFormCompletionProgress(form);
          return (
            <div className="form-section client-form-progress-card">
              <h3>Client Form Completion Progress</h3>
              <p className="mandatory-note">
                {progress.percentage}% completed ({progress.completed} of {progress.total} key sections captured).
              </p>
              <div className="client-form-progress-track" aria-label="Client form completion progress">
                <div className="client-form-progress-fill" style={{ width: progress.percentage + "%" }} />
              </div>
              {progress.missing.length > 0 && (
                <small>Missing / incomplete: {progress.missing.slice(0, 6).join(", ")}{progress.missing.length > 6 ? "..." : ""}</small>
              )}
            </div>
          );
        })()}

                <div className="form-section">
          <h3 id="client-profile-details"><span className="client-profile-card-kicker">Section 1</span><span className="client-profile-card-title">Client Identity & Authority</span><span className="client-profile-card-status">Identity & authority</span></h3>
          <p className="client-profile-card-help">Core legal identity, name authority, title/gender authority, and profile classification information. Existing fields, validation, and handlers remain preserved.</p>

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
          <h3 id="client-identification-details"><span className="client-profile-card-kicker">Section 2</span><span className="client-profile-card-title">Client Identification Details</span><span className="client-profile-card-status">Verification</span></h3>
          <p className="client-profile-card-help">Identification, document status, date of birth, and verification-related details. Existing validation remains preserved.</p>

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
          <h3 id="client-employment-details"><span className="client-profile-card-kicker">Section 3</span><span className="client-profile-card-title">Employment & Organisation Details</span><span className="client-profile-card-status">Employment / organisation</span></h3>
          <p className="client-profile-card-help">Employment and organisation-related status details. Existing employmentStatus field, options, rules, validation, and handlers remain preserved.</p>

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
          <h3 id="client-family-marital-details"><span className="client-profile-card-kicker">Section 4</span><span className="client-profile-card-title">Family and Marital Details</span><span className="client-profile-card-status">Personal metadata</span></h3>
          <p className="client-profile-card-help">Family, marital, and dependency information. Existing conditional rules remain preserved.</p>

          <div className="smart-grid two">
            <label>
              Marital / Family Status
              <select value={form.maritalStatus} onChange={(event) => updateForm("maritalStatus", event.target.value)}>
                {MARITAL_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="checkbox-tile">
              <input
                type="checkbox"
                checked={Boolean(form.hasDependents)}
                onChange={(event) => updateForm("hasDependents", event.target.checked)}
              />
              Has Dependents?
            </label>

            {form.hasDependents && (
              <>
                <label>
                  Number of Dependents
                  <input
                    type="number"
                    min="0"
                    value={form.dependentsCount}
                    onChange={(event) => updateForm("dependentsCount", event.target.value)}
                    placeholder="Example: 2"
                  />
                </label>

                <label className="full">
                  Dependent Notes
                  <textarea
                    value={form.dependentNotes}
                    onChange={(event) => updateForm("dependentNotes", event.target.value)}
                    placeholder="Example: minor children, elderly parent, caregiver responsibility, financial dependents."
                  />
                </label>
              </>
            )}
          </div>
        </div>

        <div className="form-section">
          <h3 id="client-matter-context-origin"><span className="client-profile-card-kicker">Section 5</span><span className="client-profile-card-title">Matter Context and Case Origin</span><span className="client-profile-card-status">Workflow context</span></h3>
          <p className="client-profile-card-help">Client role, case origin, and matter-source context. Existing protocol warnings remain preserved.</p>
          <p className="mandatory-note">Frontend metadata only. Linkage to actual matters/cases should be enforced in a future backend matter module.</p>

          <div className="smart-grid two">
            <label>
              Client Role in Matter
              <select value={form.clientRoleInMatter} onChange={(event) => updateForm("clientRoleInMatter", event.target.value)}>
                {CLIENT_ROLE_IN_MATTER_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label>
              Case Origin
              <select value={form.caseOriginType} onChange={(event) => updateForm("caseOriginType", event.target.value)}>
                {CASE_ORIGIN_TYPE_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            {form.caseOriginType === "Inherited / Taken Over from Another Firm" && (
              <label className="full">
                Previous Firm
                <input
                  value={form.previousFirmName}
                  onChange={(event) => updateForm("previousFirmName", event.target.value)}
                  placeholder="Previous firm name, if known"
                />
              </label>
            )}

            {form.caseOriginType === "Joint Representation / Multi-firm Action" && (
              <label className="full">
                Co-counsel / Partner Firm Notes
                <textarea
                  value={form.coCounselNotes}
                  onChange={(event) => updateForm("coCounselNotes", event.target.value)}
                  placeholder="Example: joint representation, co-counsel, merged client group, shared litigation strategy."
                />
              </label>
            )}
          </div>
        </div>

        <div className="form-section">
          <h3>Client Tenure and Value Indicators</h3>
          <p className="mandatory-note">Frontend-only indicators. No backend revenue computation is performed here.</p>

          <div className="smart-grid two">
            <label>
              Client Since
              <input
                type="date"
                value={form.clientSince}
                onChange={(event) => updateForm("clientSince", event.target.value)}
              />
              <small>Relationship duration: {getRelationshipDurationLabel(form.clientSince)}</small>
            </label>

            <label>
              Total Matters / Cases Count
              <input
                type="number"
                min="0"
                value={form.totalMattersCount}
                onChange={(event) => updateForm("totalMattersCount", event.target.value)}
                placeholder="Manual count if backend matter records are unavailable"
              />
            </label>

            <label>
              Estimated Client Value Tier
              <select value={form.clientValueTier} onChange={(event) => updateForm("clientValueTier", event.target.value)}>
                {CLIENT_VALUE_TIER_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="full">
              Revenue / Value Notes
              <textarea
                value={form.clientValueNotes}
                onChange={(event) => updateForm("clientValueNotes", event.target.value)}
                placeholder="Manual notes only. Example: repeat client, multiple matters, strategic client, high-touch account."
              />
            </label>
          </div>
        </div>

        <div className="form-section">
          <h3 id="client-will-estate-metadata"><span className="client-profile-card-kicker">Section 7</span><span className="client-profile-card-title">Will / Estate Handling Metadata</span><span className="client-profile-card-status">Specialist metadata</span></h3>
          <p className="client-profile-card-help">Will, estate, probate, and inheritance handling metadata. Existing conditional handling remains preserved.</p>
          <p className="mandatory-note">Frontend indicator only; enforce access via backend RBAC in future phase.</p>

          <div className="smart-grid two">
            <label>
              Will Status
              <select value={form.willStatus} onChange={(event) => updateForm("willStatus", event.target.value)}>
                {WILL_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            {form.willStatus === "Yes" && (
              <>
                <label className="full">
                  Will Reference Notes
                  <textarea
                    value={form.willReferenceNotes}
                    onChange={(event) => updateForm("willReferenceNotes", event.target.value)}
                    placeholder="Example: will exists, held by client, executor named, copy requested, court access may be required."
                  />
                </label>

                <label className="checkbox-tile full">
                  <input
                    type="checkbox"
                    checked={Boolean(form.willRestrictedAccess)}
                    onChange={(event) => updateForm("willRestrictedAccess", event.target.checked)}
                  />
                  Restricted to authorized legal parties only
                </label>

                <div className="full">
                  <span className="field-label-text">Authorized Parties</span>
                  <div className="checkbox-grid">
                    {WILL_AUTHORIZED_PARTY_OPTIONS.map((option) => {
                      const selectedParties = normalizeFlags(form.willAuthorizedParties);
                      return (
                        <label key={option} className="checkbox-tile">
                          <input
                            type="checkbox"
                            checked={selectedParties.includes(option)}
                            onChange={(event) => {
                              const nextParties = event.target.checked
                                ? Array.from(new Set([...selectedParties, option]))
                                : selectedParties.filter((item) => item !== option);
                              updateForm("willAuthorizedParties", nextParties);
                            }}
                          />
                          {option}
                        </label>
                      );
                    })}
                  </div>
                </div>
              </>
            )}
          </div>
        </div>

        <div className="form-section">
          <h3 id="client-health-oku-accommodation"><span className="client-profile-card-kicker">Section 8</span><span className="client-profile-card-title">Health / OKU / Disability and Accommodation Metadata</span><span className="client-profile-card-status">Accommodation</span></h3>
          <p className="client-profile-card-help">Accommodation, accessibility, and communication support information. Existing requirements remain preserved.</p>
          <p className="mandatory-note">Use respectful, neutral wording. Treat accommodation details as sensitive frontend metadata.</p>

          <div className="smart-grid two">
            <label>
              Health / Disability Status
              <select value={form.healthDisabilityStatus} onChange={(event) => updateForm("healthDisabilityStatus", event.target.value)}>
                {HEALTH_DISABILITY_STATUS_OPTIONS.map((option) => (
                  <option key={option} value={option}>{option}</option>
                ))}
              </select>
            </label>

            <label className="checkbox-tile">
              <input
                type="checkbox"
                checked={Boolean(form.accommodationRequired)}
                onChange={(event) => updateForm("accommodationRequired", event.target.checked)}
              />
              Communication Accommodation Required
            </label>

            {(form.accommodationRequired || form.healthDisabilityStatus !== "None") && (
              <label className="full">
                Accommodation Notes
                <textarea
                  value={form.accommodationNotes}
                  onChange={(event) => updateForm("accommodationNotes", event.target.value)}
                  placeholder="Example: prefers written communication, mobility access, hearing/visual support, medical sensitivity, appointment timing needs."
                />
              </label>
            )}
          </div>
        </div>
        <div className="form-section">
          <h3>4. Contact Information and Communication Preferences</h3>
          <p className="mandatory-note">Primary Phone Number is mandatory for client profile completion. Reused contact details are auto-captured from the canonical fields above.</p>

          <div className="smart-grid two">
            <label className="full">
              Email Address
              <input
                type="email"
                value={form.email}
                onChange={(event) => updateForm("email", event.target.value)}
                placeholder="client@example.com"
              />
              {renderInlineError("email")}
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
                  className={inputClass("phoneNumber")}
                  value={form.phoneNumber}
                  onChange={(event) => updateForm("phoneNumber", event.target.value)}
                  placeholder="0123456789"
                />
              </div>
              <small>Display format: +60 0123456789. Digits only, no spaces or dashes. Minimum 9 digits required.</small>
              {renderInlineError("phoneNumber")}
              {renderNumericWarning("phoneNumber")}
              {malaysiaPhoneWarning && <small className="field-warning">Check format: Malaysian mobile numbers should start with 01.</small>}
            </label>

            <label className="checkbox-tile full">
              <input
                type="checkbox"
                checked={form.hasBackupPhone}
                onChange={(event) => updateForm("hasBackupPhone", event.target.checked)}
              />
              Add Secondary / Backup Phone Number
            </label>

            {form.hasBackupPhone && (
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
                    className={inputClass("backupPhoneNumber")}
                    value={form.backupPhoneNumber}
                    onChange={(event) => updateForm("backupPhoneNumber", event.target.value)}
                    placeholder="Backup phone, if any"
                  />
                </div>
                {renderInlineError("backupPhoneNumber")}
                {renderNumericWarning("backupPhoneNumber")}
                {malaysiaBackupPhoneWarning && <small className="field-warning">Check format: Malaysian backup phone numbers should start with 01.</small>}
              </label>
            )}

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

            <div className="contact-choice-guard-panel full" role="status" aria-live="polite">
              <strong>Preferred contact choice guard</strong>
              <small>
                Each contact method may be selected once only. Already-used choices are disabled in the next dropdowns to prevent accidental duplicate selections.
              </small>
              {getActiveContactChoiceSummary().length > 0 && (
                <small>Active choices: {getActiveContactChoiceSummary().join(" | ")}</small>
              )}
              {contactChoiceNotice && <small className="field-warning-message">{contactChoiceNotice}</small>}
            </div>

            <label>
              1st Contact Choice
              <select
                className={inputClass("preferredContact1")}
                value={form.preferredContact1}
                onChange={(event) => updateForm("preferredContact1", event.target.value)}
              >
                {renderContactMethodOptions(1)}
              </select>
              {renderInlineError("preferredContact1")}
            </label>

            {renderPreferredContactDetailField(1)}

            <label>
              2nd Contact Choice
              <select
                className={inputClass("preferredContact2")}
                value={form.preferredContact2}
                onChange={(event) => updateForm("preferredContact2", event.target.value)}
              >
                {renderContactMethodOptions(2)}
              </select>
              {renderInlineError("preferredContact2")}
            </label>

            {renderPreferredContactDetailField(2)}

            <label className="full">
              Additional Contact Choices
              <button
                type="button"
                className="btn btn-secondary btn-small"
                onClick={() => setShowExtendedContactChoices((value) => !value)}
              >
                {showExtendedContactChoices ? "Hide 3rd / 4th / 5th Contact Choices" : "Show 3rd / 4th / 5th Contact Choices"}
              </button>
            </label>

            {showExtendedContactChoices && (
              <>
                <label>
                  3rd Contact Choice
                  <select
                    className={inputClass("preferredContact3")}
                    value={form.preferredContact3}
                    onChange={(event) => updateForm("preferredContact3", event.target.value)}
                  >
                    {renderContactMethodOptions(3)}
                  </select>
                  {renderInlineError("preferredContact3")}
                </label>

                {renderPreferredContactDetailField(3)}

                <label>
                  4th Contact Choice
                  <select
                    className={inputClass("preferredContact4")}
                    value={form.preferredContact4}
                    onChange={(event) => updateForm("preferredContact4", event.target.value)}
                  >
                    {renderContactMethodOptions(4)}
                  </select>
                  {renderInlineError("preferredContact4")}
                </label>

                {renderPreferredContactDetailField(4)}

                <label>
                  5th Contact Choice
                  <select
                    className={inputClass("preferredContact5")}
                    value={form.preferredContact5}
                    onChange={(event) => updateForm("preferredContact5", event.target.value)}
                  >
                    {renderContactMethodOptions(5)}
                  </select>
                  {renderInlineError("preferredContact5")}
                </label>

                {renderPreferredContactDetailField(5)}
              </>
            )}

            <label>
              Contactable Hours
              <div className="inline-fields two-even">
                <input type="time" value={form.preferredContactHoursFrom} onChange={(event) => updateForm("preferredContactHoursFrom", event.target.value)} />
                <input type="time" value={form.preferredContactHoursTo} onChange={(event) => updateForm("preferredContactHoursTo", event.target.value)} />
              </div>
            </label>

            <label className="checkbox-tile full">
              <input
                type="checkbox"
                checked={Boolean(form.isClientUnavailable)}
                onChange={(event) => updateForm("isClientUnavailable", event.target.checked)}
              />
              Client is away / unavailable / overseas
            </label>

            {form.isClientUnavailable && (
              <label className="full">
                Unavailable Until
                <div className="inline-fields two-even">
                  <input type="date" value={form.unavailableUntilDate} onChange={(event) => updateForm("unavailableUntilDate", event.target.value)} />
                  <input type="time" value={form.unavailableUntilTime} onChange={(event) => updateForm("unavailableUntilTime", event.target.value)} />
                </div>
                <small>Date format: dd/mm/yyyy where applicable.</small>
                <small>{getUnavailableStatus(form)}</small>
              </label>
            )}

            {form.isClientUnavailable && (
              <label className="full">
                Reason for Unavailability
                <select value={form.availabilityReason} onChange={(event) => updateForm("availabilityReason", event.target.value)}>
                  {AVAILABILITY_REASON_OPTIONS.map((option) => (
                    <option key={option} value={option}>{option}</option>
                  ))}
                </select>
              </label>
            )}

            {form.isClientUnavailable && form.availabilityReason === "Other" && (
              <label className="full">
                Other Unavailability Reason
                <input
                  value={form.availabilityReasonOther}
                  onChange={(event) => updateForm("availabilityReasonOther", event.target.value)}
                  placeholder="Enter reason"
                />
              </label>
            )}

            <label className="checkbox-tile full">
              <input
                type="checkbox"
                checked={Boolean(form.enableCommunicationTimingNotes)}
                onChange={(event) => updateForm("enableCommunicationTimingNotes", event.target.checked)}
              />
              Add Additional Contact / Communication Timing Notes / Comments
            </label>

            {form.enableCommunicationTimingNotes && (
              <label className="full">
                Additional Contact / Communication Timing Notes / Comments
                <textarea
                  value={form.communicationTimingNotes}
                  onChange={(event) => updateForm("communicationTimingNotes", event.target.value)}
                  placeholder="Example: reachable after 6pm, WhatsApp only, overseas number active on weekends."
                />
              </label>
            )}
          </div>
        </div>

                <div className="form-section">
          <h3 id="client-address-service-location"><span className="client-profile-card-kicker">Section 10</span><span className="client-profile-card-title">Address and Service Location Details</span><span className="client-profile-card-status">Location</span></h3>
          <p className="client-profile-card-help">Address, correspondence, service location, and administrative-area details. Existing synchronization rules remain preserved.</p>
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
            {/* L360_FINAL_ADDRESS_LOCATION_CONTROL_AREA_REPLACEMENT */}
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

            <div className="full inline-fields two-even">
              <label>
                Building / House No.
                <input
                  className="single-line-input"
                  value={form.buildingHouseNo}
                  onChange={(event) => updateForm("buildingHouseNo", event.target.value)}
                  placeholder="House / unit no."
                />
              </label>

              <label>
                Postcode
                <input
                  className="single-line-input"
                  value={form.postcode}
                  onChange={(event) => updateForm("postcode", event.target.value)}
                  placeholder="Postcode"
                />
              </label>
            </div>

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

            <div className="address-sync-panel full" role="status" aria-live="polite">
              <strong>Correspondence Address Synchronization</strong>
              <small>
                Correspondence Address is the same as Residential Address by default. Untick only when the correspondence / service address is intentionally different.
              </small>
              <small className={addressMatchStatus ? "address-match-ok" : "address-match-warning"}>
                {addressMatchStatus ? "✓ Addresses match or are set to auto-sync." : "⚠ Addresses differ — confirmation required before saving."}
              </small>
            </div>

            <label className="checkbox-tile full">
              <input
                type="checkbox"
                checked={Boolean(form.correspondenceSameAsResidential)}
                onChange={(event) => updateForm("correspondenceSameAsResidential", event.target.checked)}
              />
              Same as residential address
            </label>

            {form.correspondenceSameAsResidential ? (
              <div className="canonical-address-display full">
                <strong>Correspondence Address</strong>
                <small>Already captured from the residential address above. No duplicate address entry is required.</small>
                <small>
                  {[form.buildingHouseNo, form.buildingHouseName, form.streetAddress, form.postcode, form.townCity, form.state, form.country]
                    .filter(Boolean)
                    .join(", ") || "Complete the residential address fields above."}
                </small>
              </div>
            ) : (
              <>
                <label>
                  Correspondence Country
                  <input
                    className={inputClass("correspondenceCountry")}
                    list="client-country-options"
                    value={form.correspondenceCountry}
                    onChange={(event) => updateForm("correspondenceCountry", event.target.value)}
                    placeholder="Search or type country"
                  />
                  {renderInlineError("correspondenceCountry")}
                </label>

                <div className="full inline-fields two-even">
                  <label>
                    Correspondence Building / House No.
                    <input
                      className={inputClass("correspondenceBuildingHouseNo")}
                      value={form.correspondenceBuildingHouseNo}
                      onChange={(event) => updateForm("correspondenceBuildingHouseNo", event.target.value)}
                      placeholder="Correspondence house / unit no."
                    />
                    {renderInlineError("correspondenceBuildingHouseNo")}
                  </label>

                  <label>
                    Correspondence Postcode
                    <input
                      className={inputClass("correspondencePostcode")}
                      value={form.correspondencePostcode}
                      onChange={(event) => updateForm("correspondencePostcode", event.target.value)}
                      placeholder="Correspondence postcode"
                    />
                    {renderInlineError("correspondencePostcode")}
                  </label>
                </div>

                <label>
                  Correspondence Building / House Name
                  <input
                    value={form.correspondenceBuildingHouseName}
                    onChange={(event) => updateForm("correspondenceBuildingHouseName", event.target.value)}
                    placeholder="Correspondence building / house name, if any"
                  />
                </label>

                <label>
                  Correspondence Town / City
                  <input
                    className={inputClass("correspondenceTownCity")}
                    value={form.correspondenceTownCity}
                    onChange={(event) => updateForm("correspondenceTownCity", event.target.value)}
                    placeholder="Correspondence town / city"
                  />
                  {renderInlineError("correspondenceTownCity")}
                </label>

                <label className="full">
                  Correspondence Street Address
                  <input
                    className={inputClass("correspondenceStreetAddress")}
                    value={form.correspondenceStreetAddress}
                    onChange={(event) => updateForm("correspondenceStreetAddress", event.target.value)}
                    placeholder="Correspondence street address"
                  />
                  {renderInlineError("correspondenceStreetAddress")}
                </label>

                <label>
                  Correspondence State
                  <input
                    value={form.correspondenceState}
                    onChange={(event) => updateForm("correspondenceState", event.target.value)}
                    placeholder="Correspondence state / province"
                  />
                </label>

                <label className="full">
                  Correspondence Notes
                  <textarea
                    value={form.correspondenceNotes}
                    onChange={(event) => updateForm("correspondenceNotes", event.target.value)}
                    placeholder="Example: different mailing address, courier address, office address, service address, or temporary overseas correspondence address."
                  />
                </label>

                <label className="checkbox-tile full">
                  <input
                    type="checkbox"
                    checked={Boolean(form.correspondenceDifferenceConfirmed)}
                    onChange={(event) => updateForm("correspondenceDifferenceConfirmed", event.target.checked)}
                  />
                  I confirm the correspondence address is intentionally different from the residential address.
                </label>
                {renderInlineError("correspondenceDifferenceConfirmed")}
              </>
            )}

            <div className="full mandatory-note">
              <strong>Location / Administrative Classification — Combined:</strong> Select the administrative category/type, then enter the actual area, authority or locality details. Use this for postcode area, town, state, municipality, council, borough, district, county, parish, shire, mukim or other local authority structures.
            </div>

            {/* L360_ADMIN_AREA_PROGRESSIVE_WIZARD_FINAL */}
            <div className="full l360-admin-wizard">
              <div className="mandatory-note">
                <strong>Administrative area details:</strong> Add one recognised administrative area at a time. Add another section only when an additional recognised area is required.
              </div>

              <div className="l360-admin-progress">
                Administrative Area Details
              </div>

              {form.locationAdminType && form.manualAdministrativeLocation && Number(form.administrativeAreaActiveLevel || 1) !== 1 && (
                <div className="l360-admin-summary-card">
                  <span>✓ 1st: {form.locationAdminType} — {form.manualAdministrativeLocation}</span>
                  <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 1)}>Edit</button>
                </div>
              )}

              {form.secondaryAdministrativeCategory && form.secondaryAdministrativeName && Number(form.administrativeAreaActiveLevel || 1) !== 2 && (
                <div className="l360-admin-summary-card">
                  <span>✓ 2nd: {form.secondaryAdministrativeCategory} — {form.secondaryAdministrativeName}</span>
                  <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 2)}>Edit</button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("secondaryAdministrativeCategory", "");
                      updateForm("secondaryAdministrativeName", "");
                      updateForm("thirdAdministrativeCategory", "");
                      updateForm("thirdAdministrativeLocation", "");
                      updateForm("fourthAdministrativeCategory", "");
                      updateForm("fourthAdministrativeLocation", "");
                      updateForm("fifthAdministrativeCategory", "");
                      updateForm("fifthAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 1);
                    }}
                  >Delete</button>
                </div>
              )}

              {form.thirdAdministrativeCategory && form.thirdAdministrativeLocation && Number(form.administrativeAreaActiveLevel || 1) !== 3 && (
                <div className="l360-admin-summary-card">
                  <span>✓ 3rd: {form.thirdAdministrativeCategory} — {form.thirdAdministrativeLocation}</span>
                  <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 3)}>Edit</button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("thirdAdministrativeCategory", "");
                      updateForm("thirdAdministrativeLocation", "");
                      updateForm("fourthAdministrativeCategory", "");
                      updateForm("fourthAdministrativeLocation", "");
                      updateForm("fifthAdministrativeCategory", "");
                      updateForm("fifthAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 2);
                    }}
                  >Delete</button>
                </div>
              )}

              {form.fourthAdministrativeCategory && form.fourthAdministrativeLocation && Number(form.administrativeAreaActiveLevel || 1) !== 4 && (
                <div className="l360-admin-summary-card">
                  <span>✓ 4th: {form.fourthAdministrativeCategory} — {form.fourthAdministrativeLocation}</span>
                  <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 4)}>Edit</button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("fourthAdministrativeCategory", "");
                      updateForm("fourthAdministrativeLocation", "");
                      updateForm("fifthAdministrativeCategory", "");
                      updateForm("fifthAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 3);
                    }}
                  >Delete</button>
                </div>
              )}

              {form.fifthAdministrativeCategory && form.fifthAdministrativeLocation && Number(form.administrativeAreaActiveLevel || 1) !== 5 && (
                <div className="l360-admin-summary-card">
                  <span>✓ 5th: {form.fifthAdministrativeCategory} — {form.fifthAdministrativeLocation}</span>
                  <button type="button" className="btn btn-secondary btn-small" onClick={() => updateForm("administrativeAreaActiveLevel", 5)}>Edit</button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("fifthAdministrativeCategory", "");
                      updateForm("fifthAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 4);
                    }}
                  >Delete</button>
                </div>
              )}

              {Number(form.administrativeAreaActiveLevel || 1) === 1 && (
                <div className="l360-admin-active-card">
                  <div className="l360-admin-level-title">Administrative Area Details</div>
                  <div className="l360-admin-area-row">
                    <label>
                      Location / Administrative Area — All-in-One
                      <input
                        list="l360-location-admin-type-options"
                        value={form.locationAdminType}
                        onChange={(event) => updateForm("locationAdminType", event.target.value)}
                        placeholder="Select or type administrative category/type"
                        title="Examples: state, province, municipality, council, borough, district, county, parish, shire, mukim, locality, postcode area."
                      />
                    </label>

                    <label>
                      Administrative Area Details
                      <input
                        value={form.manualAdministrativeLocation || ""}
                        onChange={(event) => {
                          const value = event.target.value;
                          updateForm("manualAdministrativeLocation", value);
                          updateForm("townCity", value);
                          updateForm("district", value);
                        }}
                        placeholder="Enter administrative area/name/details"
                        title="Example: Selangor, Petaling Jaya, MBPJ, Mukim Damansara or 47300."
                      />
                    </label>
                  </div>

                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    disabled={!(String(form.locationAdminType || "").trim() && String(form.manualAdministrativeLocation || "").trim())}
                    onClick={() => updateForm("administrativeAreaActiveLevel", 2)}
                  >
                    Add Another Administrative Area
                  </button>
                </div>
              )}

              {Number(form.administrativeAreaActiveLevel || 1) === 2 && (
                <div className="l360-admin-active-card">
                  <div className="l360-admin-level-title">Administrative Area Details</div>
                  <div className="l360-admin-area-row">
                    <label>
                      Location / Administrative Area — All-in-One
                      <input
                        list="l360-location-admin-type-options"
                        value={form.secondaryAdministrativeCategory || ""}
                        onChange={(event) => updateForm("secondaryAdministrativeCategory", event.target.value)}
                        placeholder="Select or type administrative category/type"
                      />
                    </label>

                    <label>
                      Administrative Area Details
                      <input
                        value={form.secondaryAdministrativeName || ""}
                        onChange={(event) => updateForm("secondaryAdministrativeName", event.target.value)}
                        placeholder="Enter administrative area/name/details"
                      />
                    </label>
                  </div>

                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    disabled={!(String(form.secondaryAdministrativeCategory || "").trim() && String(form.secondaryAdministrativeName || "").trim())}
                    onClick={() => updateForm("administrativeAreaActiveLevel", 3)}
                  >
                    Add Another Administrative Area
                  </button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("secondaryAdministrativeCategory", "");
                      updateForm("secondaryAdministrativeName", "");
                      updateForm("administrativeAreaActiveLevel", 1);
                    }}
                  >
                    Remove This Administrative Area
                  </button>
                </div>
              )}

              {Number(form.administrativeAreaActiveLevel || 1) === 3 && (
                <div className="l360-admin-active-card">
                  <div className="l360-admin-level-title">Administrative Area Details</div>
                  <div className="l360-admin-area-row">
                    <label>
                      Location / Administrative Area — All-in-One
                      <input
                        list="l360-location-admin-type-options"
                        value={form.thirdAdministrativeCategory || ""}
                        onChange={(event) => updateForm("thirdAdministrativeCategory", event.target.value)}
                        placeholder="Select or type administrative category/type"
                      />
                    </label>

                    <label>
                      Administrative Area Details
                      <input
                        value={form.thirdAdministrativeLocation || ""}
                        onChange={(event) => updateForm("thirdAdministrativeLocation", event.target.value)}
                        placeholder="Enter administrative area/name/details"
                      />
                    </label>
                  </div>

                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    disabled={!(String(form.thirdAdministrativeCategory || "").trim() && String(form.thirdAdministrativeLocation || "").trim())}
                    onClick={() => updateForm("administrativeAreaActiveLevel", 4)}
                  >
                    Add Another Administrative Area
                  </button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("thirdAdministrativeCategory", "");
                      updateForm("thirdAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 2);
                    }}
                  >
                    Remove This Administrative Area
                  </button>
                </div>
              )}

              {Number(form.administrativeAreaActiveLevel || 1) === 4 && (
                <div className="l360-admin-active-card">
                  <div className="l360-admin-level-title">Administrative Area Details</div>
                  <div className="l360-admin-area-row">
                    <label>
                      Location / Administrative Area — All-in-One
                      <input
                        list="l360-location-admin-type-options"
                        value={form.fourthAdministrativeCategory || ""}
                        onChange={(event) => updateForm("fourthAdministrativeCategory", event.target.value)}
                        placeholder="Select or type administrative category/type"
                      />
                    </label>

                    <label>
                      Administrative Area Details
                      <input
                        value={form.fourthAdministrativeLocation || ""}
                        onChange={(event) => updateForm("fourthAdministrativeLocation", event.target.value)}
                        placeholder="Enter administrative area/name/details"
                      />
                    </label>
                  </div>

                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    disabled={!(String(form.fourthAdministrativeCategory || "").trim() && String(form.fourthAdministrativeLocation || "").trim())}
                    onClick={() => updateForm("administrativeAreaActiveLevel", 5)}
                  >
                    Add Another Administrative Area
                  </button>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("fourthAdministrativeCategory", "");
                      updateForm("fourthAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 3);
                    }}
                  >
                    Remove This Administrative Area
                  </button>
                </div>
              )}

              {Number(form.administrativeAreaActiveLevel || 1) === 5 && (
                <div className="l360-admin-active-card">
                  <div className="l360-admin-level-title">Administrative Area Details</div>
                  <div className="l360-admin-area-row">
                    <label>
                      Location / Administrative Area — All-in-One
                      <input
                        list="l360-location-admin-type-options"
                        value={form.fifthAdministrativeCategory || ""}
                        onChange={(event) => updateForm("fifthAdministrativeCategory", event.target.value)}
                        placeholder="Select or type administrative category/type"
                      />
                    </label>

                    <label>
                      Administrative Area Details
                      <input
                        value={form.fifthAdministrativeLocation || ""}
                        onChange={(event) => updateForm("fifthAdministrativeLocation", event.target.value)}
                        placeholder="Enter administrative area/name/details or notes"
                      />
                    </label>
                  </div>

                  <small className="field-hint">
                    No further administrative area sections can be added. Submit/save the client if no further section is needed.
                  </small>
                  <button
                    type="button"
                    className="btn btn-secondary btn-small"
                    onClick={() => {
                      updateForm("fifthAdministrativeCategory", "");
                      updateForm("fifthAdministrativeLocation", "");
                      updateForm("administrativeAreaActiveLevel", 4);
                    }}
                  >
                    Remove This Administrative Area
                  </button>
                </div>
              )}
            </div>

            <datalist id="l360-location-admin-type-options">
              {LOCATION_ADMIN_TYPE_OPTIONS.map((option) => <option key={option} value={option} />)}
            </datalist>
            <datalist id="l360-state-location-options">
              {Array.from(new Set(clients.map((client) => normalizeClient(client).state).filter(Boolean))).map((option) => <option key={option} value={option} />)}
            </datalist>
            <datalist id="l360-municipality-options">
              {Array.from(new Set(clients.map((client) => normalizeClient(client).municipality).filter(Boolean))).map((option) => <option key={option} value={option} />)}
            </datalist>
            <datalist id="l360-council-options">
              {Array.from(new Set(clients.map((client) => normalizeClient(client).council).filter(Boolean))).map((option) => <option key={option} value={option} />)}
            </datalist>
            <datalist id="l360-borough-options">
              {Array.from(new Set(clients.map((client) => normalizeClient(client).borough).filter(Boolean))).map((option) => <option key={option} value={option} />)}
            </datalist>
          </div>
        </div>
<div className="form-section">
          <h3 id="client-emergency-next-of-kin"><span className="client-profile-card-kicker">Section 11</span><span className="client-profile-card-title">Emergency Contact / Next of Kin Details</span><span className="client-profile-card-status">Secondary contact</span></h3>
          <p className="client-profile-card-help">Emergency and next-of-kin information. Existing fields and handlers remain preserved.</p>

          <div className="smart-grid two">
            <label>
              Emergency Contact Name
              <input value={form.emergencyContactName} onChange={(event) => updateForm("emergencyContactName", event.target.value)} placeholder="Name" />
            </label>

            <label>
              Relationship to Client
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
          <h3 id="client-documentation-verification"><span className="client-profile-card-kicker">Section 12</span><span className="client-profile-card-title">Documentation Verification Status</span><span className="client-profile-card-status">Compliance</span></h3>
          <p className="client-profile-card-help">Document verification, status, pending reasons, retention notes, and review fields. Existing compliance process remains preserved.</p>
          <p className="mandatory-note">Tracks document type, document receipt status, verification status and digital copy handling.</p>

                    <div className="smart-grid two">
            <label className="full">
              Documentation Verification Completion
              <select
                value={form.documentationVerificationCompleted ? "done" : "not_done"}
                onChange={(event) => updateForm("documentationVerificationCompleted", event.target.value === "done")}
              >
                <option value="not_done">Not Yet / Not Completed ❌</option>
                <option value="done">Documentation Verification Status Done ✅</option>
              </select>
            </label>

            {!form.documentationVerificationCompleted && (
              <>
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
              </>
            )}


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


        <section className="client-profile-review-panel" aria-labelledby="client-profile-review-heading">
          <div className="client-profile-review-header">
            <div>
              <p className="client-profile-review-kicker">Pre-Submission Review</p>
              <h3 id="client-profile-review-heading">Review Full Client Profile Before Saving</h3>
              <p>
                Confirm the complete manual-management profile before creating or saving this client record.
                This panel is informational only and does not replace the original validation, required fields,
                backend checks, draft behaviour, or save controls.
              </p>
            </div>
            <span className="client-profile-review-status">Verify before saving</span>
          </div>

          <div className="client-profile-review-grid">
            <article className="client-profile-review-card">
              <p className="client-profile-review-kicker">Identity</p>
              <h4>Client Identity & Authority Review</h4>
              <p>Confirm legal name, title authority, gender/title override reason, organisation details where present, identification reference, and profile classification.</p>
              <a href="#client-profile-details" className="client-profile-review-link">Jump to Client Identity & Authority</a>
            </article>

            <article className="client-profile-review-card">
              <p className="client-profile-review-kicker">Verification</p>
              <h4>Identification & Documentation</h4>
              <p>Check identification details, document status, pending document reasons, and verification notes.</p>
              <a href="#client-documentation-verification" className="client-profile-review-link">Jump to Documentation Verification</a>
            </article>

            <article className="client-profile-review-card">
              <p className="client-profile-review-kicker">Contact</p>
              <h4>Contact & Communication</h4>
              <p>Review phone, email, WhatsApp/contact preference, communication notes, and correspondence protocol.</p>
              <a href="#client-contact-communication-preferences" className="client-profile-review-link">Jump to Contact Details</a>
            </article>

            <article className="client-profile-review-card">
              <p className="client-profile-review-kicker">Location</p>
              <h4>Address & Service Location</h4>
              <p>Confirm address, service location, correspondence location, postcode, city, state, and country details.</p>
              <a href="#client-address-service-location" className="client-profile-review-link">Jump to Address Details</a>
            </article>

            <article className="client-profile-review-card">
              <p className="client-profile-review-kicker">Matter Context</p>
              <h4>Matter Origin & Client Source</h4>
              <p>Review matter origin, client source, referral details, value indicators, and prior-firm context where applicable.</p>
              <a href="#client-matter-context-origin" className="client-profile-review-link">Jump to Matter Context</a>
            </article>

            <article className="client-profile-review-card client-profile-review-warning">
              <p className="client-profile-review-kicker">Pending Items</p>
              <h4>Internal Remarks & Missing Information</h4>
              <p>Check unresolved notes, pending information, missing details, and internal follow-up items before final save.</p>
              <a href="#client-internal-remarks-issues" className="client-profile-review-link">Jump to Internal Remarks</a>
            </article>
          </div>

          <div className="client-profile-review-footer">
            <strong>Preservation notice:</strong>
            Existing required markers, validation rules, backend/local fallback warnings, draft controls,
            create/save actions, and manual-management protocols remain authoritative.
          </div>
        </section>
<div className="client-form-actions">
          <button type="submit" disabled={isSaving}>
            {isSaving ? "Saving..." : editingId ? "Save Modified Client" : "Create New Client Profile"}
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
            onChange={handleDirectorySearchChange}
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
              <th>Gender</th>
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
              <th>Emergency / Next of Kin</th>
              <th>Review Status</th>
              <th>Notes / Flags</th>
              <th>Created On</th>
              <th>Modified On</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {filteredDirectoryClients.length === 0 && (
              <tr>
                <td colSpan="22">
                  {getClientDirectoryEmptyStateMessage()}
                </td>
              </tr>
            )}

            {filteredDirectoryClients.map((client) => {
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
                      <button type="button" onClick={(event) => { event.stopPropagation(); viewClientProfile(normalized); }}>View Client Profile</button>
                      <button type="button" onClick={(event) => { event.stopPropagation(); editClient(normalized); }}>Edit / Amend</button>
                      <button type="button" onClick={(event) => { event.stopPropagation(); deleteClient(normalized); }}>Delete</button>
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

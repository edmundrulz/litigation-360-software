import React, { useMemo, useState } from "react";

const SAMPLE_CLIENTS = [
  {
    id: "CL-0001",
    fullName: "John Edmund Pereira",
    givenName: "John Edmund",
    surname: "Pereira",
    preferredName: "John",
    alias: "",
    email: "edmundrulz@gmail.com",
    phone: "0162172852",
    whatsapp: "0162172852",
    idReference: "",
    passportNumber: "",
    companyName: "",
    address: "20 JALAN SS2/6",
    city: "Petaling Jaya",
    postcode: "47300",
    state: "Selangor",
    country: "Malaysia",
    clientType: "Individual",
    status: "Existing Client",
    lastUpdated: "2026-06-27"
  },
  {
    id: "CL-0002",
    fullName: "Sample Test Client",
    givenName: "Sample",
    surname: "Client",
    preferredName: "",
    alias: "",
    email: "sample.client@example.com",
    phone: "0123456789",
    whatsapp: "",
    idReference: "",
    passportNumber: "",
    companyName: "Sample Client Sdn Bhd",
    address: "Petaling Jaya",
    city: "Petaling Jaya",
    postcode: "",
    state: "Selangor",
    country: "Malaysia",
    clientType: "Company",
    status: "Sample Record",
    lastUpdated: "2026-06-27"
  }
];

const EMPTY_CLIENT_INTAKE = {
  fullName: "",
  givenName: "",
  surname: "",
  preferredName: "",
  alias: "",
  email: "",
  phone: "",
  whatsapp: "",
  idReference: "",
  passportNumber: "",
  companyName: "",
  address: "",
  city: "",
  postcode: "",
  state: "",
  country: "Malaysia",
  dateOfBirth: "",
  clientType: "Individual",
  intakeSource: "Manual Entry",
  notes: "",
  duplicateDecision: ""
};

const STEPS = [
  {
    id: 1,
    title: "Client Details",
    status: "OPEN",
    description: "Search, check duplicates, paste intake notes, and prepare an editable client profile."
  },
  {
    id: 2,
    title: "Case / Matter Details",
    status: "OPEN",
    description: "Record the case, matter type, parties, facts, and legal issue summary."
  },
  {
    id: 3,
    title: "Deadline Details",
    status: "OPEN",
    description: "Capture court dates, limitation dates, reminders, and urgent timeline risks."
  },
  {
    id: 4,
    title: "Document Details",
    status: "OPEN",
    description: "Prepare document, evidence, filing, bundle, and template information."
  },
  {
    id: 5,
    title: "Review",
    status: "OPEN",
    description: "Review the collected workflow details before completion."
  },
  {
    id: 6,
    title: "Review / Save & Submit",
    status: "OPEN",
    description: "Final review point before saving, submission, or future workflow handoff."
  }
];

function normalizeText(value) {
  return String(value || "").trim().toLowerCase();
}

function compactPhone(value) {
  return String(value || "").replace(/\D/g, "");
}

function hasCompanySignal(value) {
  const text = normalizeText(value);
  return (
    text.includes("sdn bhd") ||
    text.includes("berhad") ||
    text.includes("enterprise") ||
    text.includes("trading") ||
    text.includes("llp") ||
    text.includes("ltd") ||
    text.includes("pte")
  );
}

function hasAddressSignal(value) {
  const text = normalizeText(value);
  return (
    text.includes("jalan") ||
    text.includes("road") ||
    text.includes("taman") ||
    text.includes("lorong") ||
    text.includes("persiaran") ||
    text.includes("petaling") ||
    text.includes("selangor") ||
    text.includes("kuala lumpur") ||
    text.includes("ss")
  );
}

function deriveIntakeFromSearch(rawValue) {
  const value = String(rawValue || "").trim();

  if (!value) {
    return {};
  }

  const emailMatch = value.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/i);
  const phoneMatch = value.match(/(?:\+?6?0|\b0)[0-9][0-9\s-]{6,14}/);
  const idLike = value.match(/\b[A-Z0-9][A-Z0-9-]{5,24}\b/i);

  let remaining = value;

  if (emailMatch) {
    remaining = remaining.replace(emailMatch[0], "");
  }

  if (phoneMatch) {
    remaining = remaining.replace(phoneMatch[0], "");
  }

  remaining = remaining.replace(/\s+/g, " ").trim();

  const derived = {};

  if (emailMatch) {
    derived.email = emailMatch[0];
  }

  if (phoneMatch) {
    derived.phone = phoneMatch[0].replace(/\s+/g, "");
  }

  if (hasCompanySignal(value)) {
    derived.clientType = "Company";
    derived.companyName = remaining || value;
  } else if (hasAddressSignal(value)) {
    derived.address = value;
  } else if (remaining && remaining.length > 2) {
    derived.fullName = remaining;
  }

  if (!emailMatch && !phoneMatch && idLike && value === idLike[0]) {
    derived.idReference = value;
  }

  return derived;
}

function extractBasicFieldsFromPaste(text) {
  const source = String(text || "");
  const emailMatch = source.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/i);
  const phoneMatch = source.match(/(?:\+?6?0|\b0)[0-9][0-9\s-]{6,14}/);

  const lines = source
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  const possibleName = lines.find((line) => {
    const lower = line.toLowerCase();

    return (
      line.length >= 4 &&
      line.length <= 90 &&
      !lower.includes("@") &&
      !lower.includes("tel") &&
      !lower.includes("phone") &&
      !lower.includes("address") &&
      !hasAddressSignal(line)
    );
  });

  const possibleAddress = lines.find((line) => hasAddressSignal(line));
  const possibleCompany = lines.find((line) => hasCompanySignal(line));

  return {
    fullName: possibleName || "",
    email: emailMatch ? emailMatch[0] : "",
    phone: phoneMatch ? phoneMatch[0].replace(/\s+/g, "") : "",
    address: possibleAddress || "",
    companyName: possibleCompany || "",
    clientType: possibleCompany ? "Company" : ""
  };
}

function findClientMatches(query, intake) {
  const normalizedQuery = normalizeText(query);
  const queryPhone = compactPhone(query);

  const hasSearchInput = Boolean(
    normalizedQuery ||
    queryPhone ||
    normalizeText(intake.fullName) ||
    normalizeText(intake.givenName) ||
    normalizeText(intake.surname) ||
    normalizeText(intake.alias) ||
    normalizeText(intake.email) ||
    compactPhone(intake.phone) ||
    compactPhone(intake.whatsapp) ||
    normalizeText(intake.idReference) ||
    normalizeText(intake.passportNumber) ||
    normalizeText(intake.companyName) ||
    normalizeText(intake.address)
  );

  if (!hasSearchInput) {
    return [];
  }

  return SAMPLE_CLIENTS.map((client) => {
    const matchedFields = [];

    const clientName = normalizeText(client.fullName);
    const clientGivenName = normalizeText(client.givenName);
    const clientSurname = normalizeText(client.surname);
    const clientAlias = normalizeText(client.alias);
    const clientEmail = normalizeText(client.email);
    const clientPhone = compactPhone(client.phone);
    const clientWhatsapp = compactPhone(client.whatsapp);
    const clientId = normalizeText(client.idReference);
    const clientPassport = normalizeText(client.passportNumber);
    const clientCompany = normalizeText(client.companyName);
    const clientAddress = normalizeText(client.address);
    const clientCity = normalizeText(client.city);
    const clientPostcode = normalizeText(client.postcode);
    const clientState = normalizeText(client.state);
    const clientCountry = normalizeText(client.country);

    const searchableText = [
      clientName,
      clientGivenName,
      clientSurname,
      clientAlias,
      clientEmail,
      clientCompany,
      clientAddress,
      clientCity,
      clientPostcode,
      clientState,
      clientCountry,
      clientId,
      clientPassport
    ].filter(Boolean).join(" ");

    if (normalizedQuery && searchableText.includes(normalizedQuery)) matchedFields.push("Search Term");
    if (queryPhone && (clientPhone.includes(queryPhone) || clientWhatsapp.includes(queryPhone))) matchedFields.push("Phone");

    if (normalizeText(intake.fullName) && clientName.includes(normalizeText(intake.fullName))) matchedFields.push("Full Name");
    if (normalizeText(intake.givenName) && clientGivenName.includes(normalizeText(intake.givenName))) matchedFields.push("Given Name");
    if (normalizeText(intake.surname) && clientSurname.includes(normalizeText(intake.surname))) matchedFields.push("Surname");
    if (normalizeText(intake.alias) && clientAlias.includes(normalizeText(intake.alias))) matchedFields.push("Alias");
    if (normalizeText(intake.email) && clientEmail === normalizeText(intake.email)) matchedFields.push("Email");
    if (compactPhone(intake.phone) && clientPhone === compactPhone(intake.phone)) matchedFields.push("Phone");
    if (compactPhone(intake.whatsapp) && clientWhatsapp === compactPhone(intake.whatsapp)) matchedFields.push("WhatsApp");
    if (normalizeText(intake.idReference) && clientId === normalizeText(intake.idReference)) matchedFields.push("ID Reference");
    if (normalizeText(intake.passportNumber) && clientPassport === normalizeText(intake.passportNumber)) matchedFields.push("Passport");
    if (normalizeText(intake.companyName) && clientCompany.includes(normalizeText(intake.companyName))) matchedFields.push("Company");
    if (normalizeText(intake.address) && clientAddress.includes(normalizeText(intake.address))) matchedFields.push("Address");

    const uniqueMatchedFields = [...new Set(matchedFields)];

    if (uniqueMatchedFields.length === 0) {
      return null;
    }

    const strongFields = ["Email", "Phone", "WhatsApp", "ID Reference", "Passport"];
    const hasStrongMatch = uniqueMatchedFields.some((field) => strongFields.includes(field));

    return {
      ...client,
      matchedFields: uniqueMatchedFields,
      confidence: hasStrongMatch ? "Exact / Strong Match" : "Possible Match"
    };
  }).filter(Boolean);
}

export default function MatterIntakeWizard({ setModule } = {}) {
  const [step, setStep] = useState(1);
  const [clientIntake, setClientIntake] = useState(EMPTY_CLIENT_INTAKE);
  const [searchQuery, setSearchQuery] = useState("");
  const [searchStatus, setSearchStatus] = useState("Search existing clients before creating a new profile.");
  const [searchMode, setSearchMode] = useState("idle");
  const [clientMatches, setClientMatches] = useState([]);
  const [pasteText, setPasteText] = useState("");
  const [selectedClientId, setSelectedClientId] = useState("");
  const [validationMessage, setValidationMessage] = useState("");
  const [draftMessage, setDraftMessage] = useState("");
  const [creationMode, setCreationMode] = useState(false);

  const activeStep = STEPS.find((item) => item.id === step) || STEPS[0];

  const intakeHasMinimumValue = useMemo(() => {
    return Boolean(
      String(clientIntake.fullName || "").trim() ||
      String(clientIntake.companyName || "").trim() ||
      String(clientIntake.email || "").trim() ||
      String(clientIntake.phone || "").trim() ||
      String(clientIntake.idReference || "").trim() ||
      String(clientIntake.passportNumber || "").trim()
    );
  }, [clientIntake]);

  function goHome() {
    if (typeof setModule === "function") {
      setModule("home");
    }
  }

  function updateClientField(field, value) {
    setClientIntake((current) => ({
      ...current,
      [field]: value
    }));
    setValidationMessage("");
    setDraftMessage("");
  }

  function runClientSearch() {
    const matches = findClientMatches(searchQuery, clientIntake);
    setClientMatches(matches);
    setSelectedClientId("");
    setCreationMode(false);

    if (matches.length === 0) {
      setSearchMode("none");
      setSearchStatus("No results found. Create a new client profile from this search without leaving the intake workflow.");
      return;
    }

    const hasStrongMatch = matches.some((match) => match.confidence === "Exact / Strong Match");
    setSearchMode(hasStrongMatch ? "strong" : "possible");
    setSearchStatus(
      hasStrongMatch
        ? "Client already exists or strongly matches an existing record. Review the record before creating a duplicate."
        : "Possible matching client records found. Review before continuing as new."
    );
  }

  function clearSearch() {
    setSearchQuery("");
    setClientMatches([]);
    setSelectedClientId("");
    setSearchMode("idle");
    setCreationMode(false);
    setSearchStatus("Search existing clients before creating a new profile.");
  }

  function createNewFromSearch() {
    const derived = deriveIntakeFromSearch(searchQuery);

    setClientIntake((current) => ({
      ...current,
      ...derived,
      intakeSource: "Search No Result",
      duplicateDecision: "No existing client found from search. Proceeding with new client profile."
    }));

    setCreationMode(true);
    setSearchStatus("New client profile form prepared from the search term. Review and complete the editable fields below.");
    setValidationMessage("");
  }

  function loadClientIntoIntake(client) {
    setClientIntake((current) => ({
      ...current,
      fullName: client.fullName || "",
      givenName: client.givenName || "",
      surname: client.surname || "",
      preferredName: client.preferredName || "",
      alias: client.alias || "",
      email: client.email || "",
      phone: client.phone || "",
      whatsapp: client.whatsapp || "",
      idReference: client.idReference || "",
      passportNumber: client.passportNumber || "",
      companyName: client.companyName || "",
      address: client.address || "",
      city: client.city || "",
      postcode: client.postcode || "",
      state: client.state || "",
      country: client.country || "Malaysia",
      clientType: client.clientType || "Individual",
      intakeSource: "Loaded Existing Client",
      notes: current.notes,
      duplicateDecision: "Existing client loaded into intake."
    }));

    setSelectedClientId(client.id);
    setCreationMode(true);
    setSearchStatus("Existing client loaded into intake. Review, amend frontend draft values, or start a new matter.");
    setValidationMessage("");
  }

  function markReviewed(client) {
    setSelectedClientId(client.id);
    updateClientField("duplicateDecision", `Reviewed possible duplicate ${client.id}.`);
  }

  function applyPastedText() {
    const extracted = extractBasicFieldsFromPaste(pasteText);

    setClientIntake((current) => ({
      ...current,
      fullName: extracted.fullName || current.fullName,
      email: extracted.email || current.email,
      phone: extracted.phone || current.phone,
      address: extracted.address || current.address,
      companyName: extracted.companyName || current.companyName,
      clientType: extracted.clientType || current.clientType,
      notes: current.notes || pasteText,
      intakeSource: "Pasted Email / Document"
    }));

    setCreationMode(true);
    setDraftMessage("Pasted text applied where simple name, email, phone, address, or company values were detected. Review and amend before continuing.");
  }

  function saveDraft() {
    try {
      if (typeof window !== "undefined" && window.localStorage) {
        window.localStorage.setItem(
          "litigation360.matterIntake.clientDraft",
          JSON.stringify({
            savedAt: new Date().toISOString(),
            clientIntake,
            pasteText,
            searchQuery
          })
        );
      }

      setDraftMessage("Client intake draft saved locally in this browser.");
    } catch (error) {
      setDraftMessage("Draft could not be saved in this browser.");
    }
  }

  function clearDraft() {
    try {
      if (typeof window !== "undefined" && window.localStorage) {
        window.localStorage.removeItem("litigation360.matterIntake.clientDraft");
      }
    } catch (error) {
      // Frontend-only draft clearing should not break the wizard.
    }

    setDraftMessage("Local client intake draft cleared.");
  }

  function resetClientIntake() {
    setClientIntake(EMPTY_CLIENT_INTAKE);
    setPasteText("");
    setSearchQuery("");
    setClientMatches([]);
    setSelectedClientId("");
    setValidationMessage("");
    setSearchMode("idle");
    setCreationMode(false);
    setSearchStatus("Search existing clients before creating a new profile.");
    setDraftMessage("Client intake fields reset.");
  }

  function previousStep() {
    if (step === 1) {
      goHome();
      return;
    }

    setStep((currentStep) => Math.max(1, currentStep - 1));
  }

  function nextStep() {
    if (step === 1 && !intakeHasMinimumValue) {
      setValidationMessage("Enter at least a full name, company name, email, phone, ID reference, or passport number before continuing.");
      return;
    }

    setValidationMessage("");
    setStep((currentStep) => Math.min(STEPS.length, currentStep + 1));
  }

  function renderClientSearchStep() {
    return (
      <section className="intake-client-step">
        <div className="intake-section-heading">
          <div>
            <p className="eyebrow">Step 1A</p>
            <h2>Client Search & Duplicate Check</h2>
            <p>Search first. If no record exists, create a new client profile immediately in the same workflow.</p>
          </div>
          <span className="intake-status-chip">Search-first intake</span>
        </div>

        <div className="intake-panel intake-search-panel">
          <div className="intake-panel-header">
            <div>
              <h3>Search Existing Client</h3>
              <p>Use any identifying detail available from the potential client, email, document, call note, or referral.</p>
            </div>
          </div>

          <div className="intake-search-row">
            <label>
              Universal Client Search
              <input
                className="intake-control"
                value={searchQuery}
                onChange={(event) => setSearchQuery(event.target.value)}
                placeholder="Name, email, phone, ID, passport, company, address, city, postcode, state, or country"
              />
            </label>

            <div className="intake-search-actions">
              <button type="button" onClick={runClientSearch}>
                Search Existing Client
              </button>
              <button type="button" className="secondary-action" onClick={clearSearch}>
                Clear Search
              </button>
              <button type="button" className="secondary-action" onClick={() => setModule?.("Clients")}>
                Open Full Clients Directory
              </button>
            </div>
          </div>

          <div className="intake-search-hints">
            <span>Name</span>
            <span>Email</span>
            <span>Phone / WhatsApp</span>
            <span>ID / Passport</span>
            <span>Company</span>
            <span>Address</span>
            <span>City / Postcode</span>
          </div>

          <div className={`intake-alert intake-alert-${searchMode}`}>
            <strong>{searchMode === "none" ? "No results found" : searchMode === "strong" ? "Existing client warning" : searchMode === "possible" ? "Possible match review" : "Search status"}</strong>
            <p>{searchStatus}</p>

            {searchMode === "none" && (
              <button type="button" onClick={createNewFromSearch}>
                Create New Client Profile From Search
              </button>
            )}
          </div>

          {clientMatches.length > 0 && (
            <div className="intake-results-grid">
              {clientMatches.map((client) => (
                <article className="intake-result-card" key={client.id}>
                  <div className="intake-card-topline">
                    <span className={client.confidence === "Exact / Strong Match" ? "pill danger" : "pill"}>
                      {client.confidence}
                    </span>
                    <span className="pill">{client.id}</span>
                  </div>

                  <h4>{client.fullName}</h4>
                  <dl>
                    <div>
                      <dt>Email</dt>
                      <dd>{client.email || "Not recorded"}</dd>
                    </div>
                    <div>
                      <dt>Phone</dt>
                      <dd>{client.phone || "Not recorded"}</dd>
                    </div>
                    <div>
                      <dt>Company</dt>
                      <dd>{client.companyName || "Not applicable"}</dd>
                    </div>
                    <div>
                      <dt>Address</dt>
                      <dd>{client.address || "Not recorded"}</dd>
                    </div>
                  </dl>

                  <p className="intake-small">Matched fields: {client.matchedFields.join(", ")}</p>
                  <p className="intake-small">Last updated: {client.lastUpdated}</p>

                  <div className="intake-card-actions">
                    <button type="button" onClick={() => loadClientIntoIntake(client)}>
                      Load Existing Client
                    </button>
                    <button type="button" className="secondary-action" onClick={() => markReviewed(client)}>
                      Mark Reviewed
                    </button>
                  </div>
                </article>
              ))}
            </div>
          )}

          {selectedClientId && (
            <p className="intake-note">
              Selected / reviewed client reference: <strong>{selectedClientId}</strong>
            </p>
          )}
        </div>

        <div className="intake-two-column">
          <div className="intake-panel">
            <div className="intake-panel-header">
              <div>
                <h3>Paste From Email / Document</h3>
                <p>Paste copied intake text and apply detected values into the editable profile form.</p>
              </div>
            </div>

            <label>
              Intake text
              <textarea
                className="intake-control"
                value={pasteText}
                onChange={(event) => setPasteText(event.target.value)}
                placeholder="Paste email, WhatsApp text, letter extract, PDF text, call notes, or referral notes here."
                rows={9}
              />
            </label>

            <button type="button" onClick={applyPastedText}>
              Apply Pasted Text To Form
            </button>
          </div>

          <div className="intake-panel">
            <div className="intake-panel-header">
              <div>
                <h3>Creation Decision</h3>
                <p>The intake should remain in one continuous flow from search to creation.</p>
              </div>
            </div>

            <div className="intake-decision-card">
              <strong>{creationMode ? "Client profile draft active" : "Awaiting search or intake entry"}</strong>
              <p>
                {creationMode
                  ? "Review the editable fields below, amend as needed, then continue to Case / Matter Details."
                  : "Search first, load an existing record, paste details, or manually enter a new profile."}
              </p>
            </div>

            <div className="intake-decision-list">
              <span>1. Search</span>
              <span>2. Review match</span>
              <span>3. Load or create</span>
              <span>4. Edit profile</span>
              <span>5. Save & Next</span>
            </div>
          </div>
        </div>

        <div className="intake-panel intake-form-panel">
          <div className="intake-panel-header">
            <div>
              <h3>Editable Client Profile</h3>
              <p>All key searchable and identifying fields are editable before continuing.</p>
            </div>
            <span className="intake-status-chip">{clientIntake.clientType}</span>
          </div>

          <div className="intake-field-grid">
            <label>
              Full Name
              <input
                className="intake-control"
                value={clientIntake.fullName}
                onChange={(event) => updateClientField("fullName", event.target.value)}
                placeholder="Client full legal name"
              />
            </label>

            <label>
              Given Name
              <input
                className="intake-control"
                value={clientIntake.givenName}
                onChange={(event) => updateClientField("givenName", event.target.value)}
                placeholder="Given name"
              />
            </label>

            <label>
              Surname
              <input
                className="intake-control"
                value={clientIntake.surname}
                onChange={(event) => updateClientField("surname", event.target.value)}
                placeholder="Surname / family name"
              />
            </label>

            <label>
              Preferred Name
              <input
                className="intake-control"
                value={clientIntake.preferredName}
                onChange={(event) => updateClientField("preferredName", event.target.value)}
                placeholder="Preferred name"
              />
            </label>

            <label>
              Alias / Also Known As
              <input
                className="intake-control"
                value={clientIntake.alias}
                onChange={(event) => updateClientField("alias", event.target.value)}
                placeholder="Alias, nickname, alternate spelling"
              />
            </label>

            <label>
              Client Type
              <select
                className="intake-control"
                value={clientIntake.clientType}
                onChange={(event) => updateClientField("clientType", event.target.value)}
              >
                <option>Individual</option>
                <option>Company</option>
                <option>Government / Agency</option>
                <option>Organisation</option>
                <option>Other</option>
              </select>
            </label>

            <label>
              Email
              <input
                className="intake-control"
                value={clientIntake.email}
                onChange={(event) => updateClientField("email", event.target.value)}
                placeholder="Email address"
              />
            </label>

            <label>
              Phone
              <input
                className="intake-control"
                value={clientIntake.phone}
                onChange={(event) => updateClientField("phone", event.target.value)}
                placeholder="Primary phone number"
              />
            </label>

            <label>
              WhatsApp
              <input
                className="intake-control"
                value={clientIntake.whatsapp}
                onChange={(event) => updateClientField("whatsapp", event.target.value)}
                placeholder="WhatsApp number"
              />
            </label>

            <label>
              ID / NRIC / Reference
              <input
                className="intake-control"
                value={clientIntake.idReference}
                onChange={(event) => updateClientField("idReference", event.target.value)}
                placeholder="ID, NRIC, internal reference"
              />
            </label>

            <label>
              Passport Number
              <input
                className="intake-control"
                value={clientIntake.passportNumber}
                onChange={(event) => updateClientField("passportNumber", event.target.value)}
                placeholder="Passport number"
              />
            </label>

            <label>
              Date Of Birth
              <input
                className="intake-control"
                type="date"
                value={clientIntake.dateOfBirth}
                onChange={(event) => updateClientField("dateOfBirth", event.target.value)}
              />
            </label>

            <label className="full">
              Company / Organisation Name
              <input
                className="intake-control"
                value={clientIntake.companyName}
                onChange={(event) => updateClientField("companyName", event.target.value)}
                placeholder="Company, employer, organisation, or entity name"
              />
            </label>

            <label className="full">
              Address
              <textarea
                className="intake-control"
                value={clientIntake.address}
                onChange={(event) => updateClientField("address", event.target.value)}
                placeholder="Full address"
                rows={3}
              />
            </label>

            <label>
              City / Area
              <input
                className="intake-control"
                value={clientIntake.city}
                onChange={(event) => updateClientField("city", event.target.value)}
                placeholder="City, town, area"
              />
            </label>

            <label>
              Postcode
              <input
                className="intake-control"
                value={clientIntake.postcode}
                onChange={(event) => updateClientField("postcode", event.target.value)}
                placeholder="Postcode"
              />
            </label>

            <label>
              State
              <input
                className="intake-control"
                value={clientIntake.state}
                onChange={(event) => updateClientField("state", event.target.value)}
                placeholder="State"
              />
            </label>

            <label>
              Country
              <input
                className="intake-control"
                value={clientIntake.country}
                onChange={(event) => updateClientField("country", event.target.value)}
                placeholder="Country"
              />
            </label>

            <label>
              Intake Source
              <select
                className="intake-control"
                value={clientIntake.intakeSource}
                onChange={(event) => updateClientField("intakeSource", event.target.value)}
              >
                <option>Manual Entry</option>
                <option>Search No Result</option>
                <option>Pasted Email / Document</option>
                <option>Loaded Existing Client</option>
                <option>Phone Call</option>
                <option>Walk-In</option>
                <option>Referral</option>
              </select>
            </label>

            <label className="full">
              Duplicate Decision / Review Notes
              <textarea
                className="intake-control"
                value={clientIntake.duplicateDecision}
                onChange={(event) => updateClientField("duplicateDecision", event.target.value)}
                placeholder="Record duplicate decision, reason to continue as new, or selected existing client reference."
                rows={3}
              />
            </label>

            <label className="full">
              General Intake Notes
              <textarea
                className="intake-control"
                value={clientIntake.notes}
                onChange={(event) => updateClientField("notes", event.target.value)}
                placeholder="Matter notes, referral details, urgency, source comments, or copied intake context."
                rows={4}
              />
            </label>
          </div>

          {validationMessage && <p className="intake-warning">{validationMessage}</p>}
          {draftMessage && <p className="intake-note">{draftMessage}</p>}

          <div className="intake-form-actions">
            <button type="button" onClick={saveDraft}>
              Save Draft
            </button>
            <button type="button" className="secondary-action" onClick={clearDraft}>
              Clear Draft
            </button>
            <button type="button" className="secondary-action" onClick={resetClientIntake}>
              Reset Client Intake
            </button>
          </div>
        </div>
      </section>
    );
  }

  function renderStepBody() {
    if (step === 1) {
      return renderClientSearchStep();
    }

    if (step === 2) {
      return (
        <section className="intake-panel">
          <h2>▶ 2. Case / Matter Details</h2>
          <p>Create the case or matter using the client selected, loaded, or created in Step 1.</p>

          <div className="intake-summary-grid">
            <div>
              <strong>{clientIntake.fullName || clientIntake.companyName || "Client Intake Prepared"}</strong>
              <span>Client</span>
            </div>
            <div>
              <strong>{clientIntake.email || clientIntake.phone || clientIntake.idReference || "No primary identifier entered"}</strong>
              <span>Primary Identifier</span>
            </div>
            <div>
              <strong>Case / Matter Details</strong>
              <span>Workflow Stage</span>
            </div>
            <div>
              <strong>OPEN</strong>
              <span>Status</span>
            </div>
          </div>
        </section>
      );
    }

    if (step === 3) {
      return (
        <section className="intake-panel">
          <h2>▶ 3. Deadline Details</h2>
          <p>Record court dates, filing deadlines, limitation periods, reminders, and urgency indicators.</p>
        </section>
      );
    }

    if (step === 4) {
      return (
        <section className="intake-panel">
          <h2>▶ 4. Document Details</h2>
          <p>Prepare document, evidence, filing, bundle, template, and review information.</p>
        </section>
      );
    }

    if (step === 5) {
      return (
        <section className="intake-panel">
          <h2>▶ 5. Review</h2>
          <p>Review the prepared workflow before save or submission.</p>

          <div className="intake-summary-grid">
            <div>
              <strong>{clientIntake.fullName || clientIntake.companyName || "Client Intake"}</strong>
              <span>Client</span>
            </div>
            <div>
              <strong>{clientIntake.intakeSource}</strong>
              <span>Intake Source</span>
            </div>
            <div>
              <strong>{clientIntake.duplicateDecision || "No duplicate decision recorded"}</strong>
              <span>Duplicate Review</span>
            </div>
          </div>
        </section>
      );
    }

    return (
      <section className="intake-panel">
        <h2>▶ 6. Review / Save & Submit</h2>
        <p>Final review point before saving, submission, or future workflow handoff.</p>

        <div className="intake-summary-grid">
          <div>
            <strong>{clientIntake.fullName || clientIntake.companyName || "Client Intake"}</strong>
            <span>Client</span>
          </div>
          <div>
            <strong>Review / Save & Submit</strong>
            <span>Workflow Stage</span>
          </div>
          <div>
            <strong>OPEN</strong>
            <span>Status</span>
          </div>
        </div>

        <div className="intake-form-actions">
          <button type="button" onClick={() => setModule?.("Review Submit")}>
            Open Completion Review
          </button>
        </div>
      </section>
    );
  }

  return (
    <section className="intake-workflow-shell">
      <div className="intake-workflow-header">
        <div>
          <p className="eyebrow">Matter Intake Workflow</p>
          <h2>{activeStep.title}</h2>
          <p>{activeStep.description}</p>
        </div>

        <span className="pill good">
          Step {activeStep.id} / {STEPS.length} · {activeStep.status}
        </span>
      </div>

      <nav className="intake-step-grid" aria-label="Matter intake steps">
        {STEPS.map((item) => (
          <button
            key={item.id}
            type="button"
            className={item.id === step ? "active" : ""}
            onClick={() => setStep(item.id)}
          >
            <span>{item.id}</span>
            {item.title}
          </button>
        ))}
      </nav>

      {renderStepBody()}

      <div className="intake-sticky-actions">
        <button type="button" onClick={previousStep}>
          ← Previous
        </button>

        <button type="button" className="secondary-action" onClick={goHome}>
          Main Page
        </button>

        {step < STEPS.length ? (
          <button type="button" onClick={nextStep}>
            {step === 1 ? "Continue to Case / Matter Details →" : "Save & Next →"}
          </button>
        ) : (
          <button type="button" onClick={() => setModule?.("Review Submit")}>
            Complete / Review Submit
          </button>
        )}
      </div>
    </section>
  );
}

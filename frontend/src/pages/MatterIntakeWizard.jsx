import React, { useMemo, useState } from "react";

const SAMPLE_CLIENTS = [
  {
    id: "CL-0001",
    fullName: "John Edmund Pereira",
    email: "edmundrulz@gmail.com",
    phone: "0162172852",
    address: "20 JALAN SS2/6",
    status: "Existing Client",
    lastUpdated: "2026-06-27"
  },
  {
    id: "CL-0002",
    fullName: "Sample Test Client",
    email: "sample.client@example.com",
    phone: "0123456789",
    address: "Petaling Jaya",
    status: "Sample Record",
    lastUpdated: "2026-06-27"
  }
];

const EMPTY_CLIENT_INTAKE = {
  fullName: "",
  email: "",
  phone: "",
  address: "",
  idReference: "",
  clientType: "Individual",
  intakeSource: "Manual Entry",
  notes: ""
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

function findClientMatches(query, intake) {
  const normalizedQuery = normalizeText(query);
  const queryPhone = compactPhone(query);

  const signals = [
    normalizedQuery,
    normalizeText(intake.fullName),
    normalizeText(intake.email),
    compactPhone(intake.phone),
    normalizeText(intake.address),
    normalizeText(intake.idReference)
  ].filter(Boolean);

  if (signals.length === 0 && !queryPhone) {
    return [];
  }

  return SAMPLE_CLIENTS.map((client) => {
    const matchedFields = [];

    const clientName = normalizeText(client.fullName);
    const clientEmail = normalizeText(client.email);
    const clientPhone = compactPhone(client.phone);
    const clientAddress = normalizeText(client.address);

    if (normalizedQuery && clientName.includes(normalizedQuery)) matchedFields.push("Name");
    if (normalizedQuery && clientEmail.includes(normalizedQuery)) matchedFields.push("Email");
    if (queryPhone && clientPhone.includes(queryPhone)) matchedFields.push("Phone");

    if (normalizeText(intake.fullName) && clientName.includes(normalizeText(intake.fullName))) matchedFields.push("Name");
    if (normalizeText(intake.email) && clientEmail === normalizeText(intake.email)) matchedFields.push("Email");
    if (compactPhone(intake.phone) && clientPhone === compactPhone(intake.phone)) matchedFields.push("Phone");
    if (normalizeText(intake.address) && clientAddress.includes(normalizeText(intake.address))) matchedFields.push("Address");

    const uniqueMatchedFields = [...new Set(matchedFields)];

    if (uniqueMatchedFields.length === 0) {
      return null;
    }

    return {
      ...client,
      matchedFields: uniqueMatchedFields,
      confidence:
        uniqueMatchedFields.includes("Email") || uniqueMatchedFields.includes("Phone")
          ? "Exact / Strong Match"
          : "Possible Match"
    };
  }).filter(Boolean);
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
      line.length <= 80 &&
      !lower.includes("@") &&
      !lower.includes("tel") &&
      !lower.includes("phone") &&
      !lower.includes("address")
    );
  });

  const possibleAddress = lines.find((line) => {
    const lower = line.toLowerCase();
    return (
      lower.includes("jalan") ||
      lower.includes("road") ||
      lower.includes("taman") ||
      lower.includes("ss") ||
      lower.includes("petaling") ||
      lower.includes("selangor")
    );
  });

  return {
    fullName: possibleName || "",
    email: emailMatch ? emailMatch[0] : "",
    phone: phoneMatch ? phoneMatch[0].replace(/\s+/g, "") : "",
    address: possibleAddress || ""
  };
}

export default function MatterIntakeWizard({ setModule } = {}) {
  const [step, setStep] = useState(1);
  const [clientIntake, setClientIntake] = useState(EMPTY_CLIENT_INTAKE);
  const [searchQuery, setSearchQuery] = useState("");
  const [searchStatus, setSearchStatus] = useState("Search existing clients before creating a new profile.");
  const [clientMatches, setClientMatches] = useState([]);
  const [pasteText, setPasteText] = useState("");
  const [selectedClientId, setSelectedClientId] = useState("");
  const [validationMessage, setValidationMessage] = useState("");
  const [draftMessage, setDraftMessage] = useState("");

  const activeStep = STEPS.find((item) => item.id === step) || STEPS[0];

  const intakeHasMinimumValue = useMemo(() => {
    return Boolean(
      String(clientIntake.fullName || "").trim() ||
      String(clientIntake.email || "").trim() ||
      String(clientIntake.phone || "").trim()
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

    if (matches.length === 0) {
      setSearchStatus("No existing client found. You may continue creating a new client profile.");
      return;
    }

    const hasStrongMatch = matches.some((match) => match.confidence === "Exact / Strong Match");
    setSearchStatus(
      hasStrongMatch
        ? "Client already exists or strongly matches an existing record. Select or load the existing client before continuing."
        : "Possible matching client records found. Review before continuing as new."
    );
  }

  function clearSearch() {
    setSearchQuery("");
    setClientMatches([]);
    setSelectedClientId("");
    setSearchStatus("Search existing clients before creating a new profile.");
  }

  function loadClientIntoIntake(client) {
    setClientIntake((current) => ({
      ...current,
      fullName: client.fullName || "",
      email: client.email || "",
      phone: client.phone || "",
      address: client.address || "",
      intakeSource: "Loaded Existing Client",
      notes: current.notes
    }));
    setSelectedClientId(client.id);
    setSearchStatus("Existing client loaded into intake. You may review, amend frontend draft values, or start a new matter.");
    setValidationMessage("");
  }

  function applyPastedText() {
    const extracted = extractBasicFieldsFromPaste(pasteText);

    setClientIntake((current) => ({
      ...current,
      fullName: extracted.fullName || current.fullName,
      email: extracted.email || current.email,
      phone: extracted.phone || current.phone,
      address: extracted.address || current.address,
      notes: current.notes || pasteText,
      intakeSource: "Pasted Email / Document"
    }));

    setDraftMessage("Pasted text applied where simple name, email, phone, or address values were detected. Please review and amend manually.");
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
      setValidationMessage("Enter at least a full name, email, or phone number before continuing to Case / Matter Details.");
      return;
    }

    setValidationMessage("");
    setStep((currentStep) => Math.min(STEPS.length, currentStep + 1));
  }

  function renderClientSearchStep() {
    return (
      <section className="card">
        <h2>▶ 1. Client Details</h2>
        <p>Search existing clients first, then load an existing client or continue with a new editable intake profile.</p>

        <div className="card">
          <p className="eyebrow">Search Existing Client</p>
          <div className="form-grid">
            <label className="full">
              Search by name, email, phone, ID, company, or address
              <input
                value={searchQuery}
                onChange={(event) => setSearchQuery(event.target.value)}
                placeholder="Example: John Edmund Pereira, email, phone, or address"
              />
            </label>
          </div>

          <div className="actions">
            <button type="button" onClick={runClientSearch}>
              Search Existing Client
            </button>
            <button type="button" onClick={clearSearch}>
              Clear Search
            </button>
          </div>

          <p>{searchStatus}</p>

          {clientMatches.length > 0 && (
            <div className="summary">
              {clientMatches.map((client) => (
                <article className="card" key={client.id}>
                  <div className="module-step-header">
                    <span className={client.confidence === "Exact / Strong Match" ? "pill danger" : "pill"}>
                      {client.confidence}
                    </span>
                    <span className="pill">{client.id}</span>
                  </div>

                  <h3>{client.fullName}</h3>
                  <p>{client.email}</p>
                  <p>{client.phone}</p>
                  <p>{client.address}</p>
                  <small>Matched fields: {client.matchedFields.join(", ")}</small>
                  <small>Last updated: {client.lastUpdated}</small>

                  <div className="actions">
                    <button type="button" onClick={() => loadClientIntoIntake(client)}>
                      Load Existing Client Into Intake
                    </button>
                    <button type="button" onClick={() => setSelectedClientId(client.id)}>
                      Mark As Reviewed
                    </button>
                  </div>
                </article>
              ))}
            </div>
          )}

          {selectedClientId && (
            <p className="field-warning-message">
              Selected/reviewed client reference: {selectedClientId}
            </p>
          )}
        </div>

        <div className="card">
          <p className="eyebrow">Paste From Email / Document</p>
          <label className="full">
            Paste intake notes, email content, WhatsApp text, or document extract
            <textarea
              value={pasteText}
              onChange={(event) => setPasteText(event.target.value)}
              placeholder="Paste copied intake text here. Simple email, phone, name, and address extraction will be attempted."
              rows={7}
            />
          </label>

          <div className="actions">
            <button type="button" onClick={applyPastedText}>
              Apply Pasted Text To Editable Fields
            </button>
          </div>
        </div>

        <div className="card">
          <p className="eyebrow">Editable Client Intake Fields</p>

          <div className="form-grid">
            <label>
              Full Name
              <input
                value={clientIntake.fullName}
                onChange={(event) => updateClientField("fullName", event.target.value)}
                placeholder="Enter client full name"
              />
            </label>

            <label>
              Email
              <input
                value={clientIntake.email}
                onChange={(event) => updateClientField("email", event.target.value)}
                placeholder="Enter email address"
              />
            </label>

            <label>
              Phone
              <input
                value={clientIntake.phone}
                onChange={(event) => updateClientField("phone", event.target.value)}
                placeholder="Enter phone number"
              />
            </label>

            <label>
              ID / Passport / Reference
              <input
                value={clientIntake.idReference}
                onChange={(event) => updateClientField("idReference", event.target.value)}
                placeholder="Enter ID, passport, or client reference"
              />
            </label>

            <label className="full">
              Address
              <textarea
                value={clientIntake.address}
                onChange={(event) => updateClientField("address", event.target.value)}
                placeholder="Enter client address"
                rows={3}
              />
            </label>

            <label>
              Client Type
              <select
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
              Intake Source
              <select
                value={clientIntake.intakeSource}
                onChange={(event) => updateClientField("intakeSource", event.target.value)}
              >
                <option>Manual Entry</option>
                <option>Pasted Email / Document</option>
                <option>Loaded Existing Client</option>
                <option>Phone Call</option>
                <option>Walk-In</option>
                <option>Referral</option>
              </select>
            </label>

            <label className="full">
              Notes
              <textarea
                value={clientIntake.notes}
                onChange={(event) => updateClientField("notes", event.target.value)}
                placeholder="Enter intake notes, duplicate decision, or source comments"
                rows={4}
              />
            </label>
          </div>

          {validationMessage && <p className="field-warning-message">{validationMessage}</p>}
          {draftMessage && <p>{draftMessage}</p>}

          <div className="actions">
            <button type="button" onClick={saveDraft}>
              Save Draft
            </button>
            <button type="button" onClick={clearDraft}>
              Clear Draft
            </button>
            <button type="button" onClick={resetClientIntake}>
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
        <section className="card">
          <h2>▶ 2. Case / Matter Details</h2>
          <p>Capture the case or matter summary, parties, legal issue, and file-opening details.</p>

          <div className="summary">
            <div>
              <strong>{clientIntake.fullName || "Client Intake Prepared"}</strong>
              <span>Client</span>
            </div>
            <div>
              <strong>{clientIntake.email || clientIntake.phone || "No contact entered"}</strong>
              <span>Primary Contact</span>
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
        <section className="card">
          <h2>▶ 3. Deadline Details</h2>
          <p>Record court dates, filing deadlines, limitation periods, reminders, and urgency indicators.</p>

          <div className="summary">
            <div>
              <strong>Deadline Details</strong>
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

    if (step === 4) {
      return (
        <section className="card">
          <h2>▶ 4. Document Details</h2>
          <p>Prepare document, evidence, filing, bundle, template, and review information.</p>

          <div className="summary">
            <div>
              <strong>Document Details</strong>
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

    if (step === 5) {
      return (
        <section className="card">
          <h2>▶ 5. Review</h2>
          <p>Review the prepared workflow before save or submission.</p>

          <div className="summary">
            <div>
              <strong>{clientIntake.fullName || "Client Intake"}</strong>
              <span>Client</span>
            </div>
            <div>
              <strong>{clientIntake.intakeSource}</strong>
              <span>Intake Source</span>
            </div>
            <div>
              <strong>Review</strong>
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

    return (
      <section className="card">
        <h2>▶ 6. Review / Save & Submit</h2>
        <p>Final review point before saving, submission, or future workflow handoff.</p>

        <div className="summary">
          <div>
            <strong>{clientIntake.fullName || "Client Intake"}</strong>
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

        <div className="actions">
          <button type="button" onClick={() => setModule?.("Review Submit")}>
            Open Completion Review
          </button>
        </div>
      </section>
    );
  }

  return (
    <section className="module-frame">
      <div className="module-frame-header">
        <div>
          <p className="eyebrow">Matter Intake Workflow</p>
          <h2>{activeStep.title}</h2>
          <p>{activeStep.description}</p>
        </div>

        <span className="pill good">
          Step {activeStep.id} / {STEPS.length} · {activeStep.status}
        </span>
      </div>

      <div className="summary">
        {STEPS.map((item) => (
          <button
            key={item.id}
            type="button"
            className={item.id === step ? "active" : ""}
            onClick={() => setStep(item.id)}
          >
            {item.id}. {item.title}
          </button>
        ))}
      </div>

      {renderStepBody()}

      <div className="actions">
        <button type="button" onClick={previousStep}>
          ← Previous
        </button>

        <button type="button" onClick={goHome}>
          Main Page
        </button>

        {step < STEPS.length ? (
          <button type="button" onClick={nextStep}>
            Save & Next →
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

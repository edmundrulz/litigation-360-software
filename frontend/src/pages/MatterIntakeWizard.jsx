import React, { useMemo, useState } from "react";

const CLIENT_STEP_MODE = {
  SEARCH: "search",
  CREATE: "create",
  EXISTING_SELECTED: "existing-selected",
  DUPLICATE_REVIEW: "duplicate-review",
};

const STEPS = [
  "Client Search & Duplicate Detection",
  "Case / Matter Details",
  "Deadline Details",
  "Document Details",
  "Review",
  "Draft Engagement Preview",
];

const EMPTY_CLIENT_INTAKE = {
  clientType: "Individual",
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
  dateOfBirth: "",
  companyName: "",
  address: "",
  city: "",
  postcode: "",
  state: "",
  country: "Malaysia",
  intakeSource: "Manual Entry",
  duplicateDecision: "",
  notes: "",
};

const SAMPLE_CLIENTS = [
  {
    clientId: "CL-0001",
    fullName: "John Edmund Pereira",
    givenName: "John Edmund",
    surname: "Pereira",
    preferredName: "John",
    alias: "J E Pereira",
    email: "john.pereira@example.com",
    phone: "0123456789",
    whatsapp: "0123456789",
    idReference: "900101-10-1234",
    passportNumber: "A12345678",
    dateOfBirth: "01/01/1990",
    companyName: "Pereira Holdings",
    address: "Petaling Jaya, Selangor",
    lastMatterDate: "18/06/2026",
    clientType: "Individual",
  },
  {
    clientId: "CL-0002",
    fullName: "Sample Test Client",
    givenName: "Sample",
    surname: "Client",
    preferredName: "Sample",
    alias: "Test Client",
    email: "sample.client@example.com",
    phone: "0198887777",
    whatsapp: "0198887777",
    idReference: "850505-14-5678",
    passportNumber: "B99887766",
    dateOfBirth: "05/05/1985",
    companyName: "Sample Client Sdn Bhd",
    address: "Kuala Lumpur",
    lastMatterDate: "03/05/2026",
    clientType: "Individual",
  },
];

function normalizeText(value = "") {
  return String(value)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function compact(value = "") {
  return String(value)
    .toLowerCase()
    .replace(/[^a-z0-9]/g, "");
}

function compactDigits(value = "") {
  return String(value).replace(/\D/g, "");
}

function phoneticKey(value = "") {
  return normalizeText(value)
    .split(" ")
    .filter(Boolean)
    .map((part) => `${part.charAt(0)}${part.slice(1).replace(/[aeiou]/g, "")}`)
    .join(" ");
}

function confidenceWeight(level) {
  if (level === "high") return 3;
  if (level === "medium") return 2;
  return 1;
}

function scoreClientMatch(query, client) {
  const q = normalizeText(query);
  const qc = compact(query);
  const qd = compactDigits(query);
  const qPhonetic = phoneticKey(query);

  if (!q) return null;

  const fields = [
    client.fullName,
    client.givenName,
    client.surname,
    client.preferredName,
    client.alias,
    client.email,
    client.phone,
    client.whatsapp,
    client.idReference,
    client.passportNumber,
    client.companyName,
    client.address,
  ];

  const haystack = normalizeText(fields.filter(Boolean).join(" "));
  const compactFields = fields.map((field) => compact(field));
  const digitFields = [client.phone, client.whatsapp, client.idReference].map((field) => compactDigits(field));

  const exactIdentity =
    (qc && [client.email, client.idReference, client.passportNumber].some((field) => compact(field) === qc)) ||
    (qd && digitFields.some((field) => field === qd));

  if (exactIdentity) {
    return {
      confidenceLevel: "high",
      confidenceLabel: "High probability",
      matchType: "Exact match",
      reason: "Exact identifying detail matched.",
    };
  }

  const exactName = [client.fullName, client.preferredName, client.alias, client.companyName]
    .filter(Boolean)
    .some((field) => normalizeText(field) === q);

  if (exactName) {
    return {
      confidenceLevel: "high",
      confidenceLabel: "High probability",
      matchType: "Exact match",
      reason: "Exact name or organisation value matched.",
    };
  }

  const allTokensMatch = q
    .split(" ")
    .filter(Boolean)
    .every((token) => haystack.includes(token));

  if (allTokensMatch) {
    return {
      confidenceLevel: "medium",
      confidenceLabel: "Medium probability",
      matchType: "Partial match",
      reason: "Search terms partially matched existing client details.",
    };
  }

  const phoneticMatch = qPhonetic && phoneticKey(client.fullName).includes(qPhonetic);

  if (phoneticMatch) {
    return {
      confidenceLevel: "low",
      confidenceLabel: "Low probability",
      matchType: "Phonetic match",
      reason: "Name appears similar by phonetic comparison.",
    };
  }

  if (compactFields.some((field) => field.includes(qc) || qc.includes(field))) {
    return {
      confidenceLevel: "low",
      confidenceLabel: "Low probability",
      matchType: "Partial match",
      reason: "Partial identifying value matched.",
    };
  }

  return null;
}

function findClientMatches(query) {
  return SAMPLE_CLIENTS.map((client) => {
    const score = scoreClientMatch(query, client);
    if (!score) return null;

    return {
      ...client,
      ...score,
    };
  })
    .filter(Boolean)
    .sort((a, b) => confidenceWeight(b.confidenceLevel) - confidenceWeight(a.confidenceLevel));
}

function deriveIntakeFromSearch(query, current) {
  const next = { ...current };
  const trimmed = query.trim();
  const digits = compactDigits(trimmed);

  if (trimmed.includes("@") && !next.email) {
    next.email = trimmed;
  } else if (digits.length >= 7 && !next.phone) {
    next.phone = trimmed;
  } else if (!next.fullName && trimmed) {
    next.fullName = trimmed;
  }

  return next;
}

function detectDuplicateCandidates(intake) {
  const fullName = normalizeText(intake.fullName);
  const email = compact(intake.email);
  const phone = compactDigits(intake.phone);
  const whatsapp = compactDigits(intake.whatsapp);
  const idReference = compact(intake.idReference);
  const passportNumber = compact(intake.passportNumber);
  const dateOfBirth = compact(intake.dateOfBirth);

  return SAMPLE_CLIENTS.map((client) => {
    const exactIdentity =
      (email && compact(client.email) === email) ||
      (phone && compactDigits(client.phone) === phone) ||
      (whatsapp && compactDigits(client.whatsapp) === whatsapp) ||
      (idReference && compact(client.idReference) === idReference) ||
      (passportNumber && compact(client.passportNumber) === passportNumber);

    if (exactIdentity) {
      return {
        ...client,
        confidenceLevel: "high",
        confidenceLabel: "High probability",
        matchType: "Exact match",
        reason: "A unique identifying value matches an existing client.",
      };
    }

    const nameDobMatch =
      fullName &&
      normalizeText(client.fullName) === fullName &&
      dateOfBirth &&
      compact(client.dateOfBirth) === dateOfBirth;

    if (nameDobMatch) {
      return {
        ...client,
        confidenceLevel: "medium",
        confidenceLabel: "Medium probability",
        matchType: "Partial match",
        reason: "Full name and date of birth match an existing client.",
      };
    }

    const nameOnlyMatch = fullName && normalizeText(client.fullName) === fullName;

    if (nameOnlyMatch) {
      return {
        ...client,
        confidenceLevel: "low",
        confidenceLabel: "Low probability",
        matchType: "Partial match",
        reason: "Full name matches an existing client.",
      };
    }

    return null;
  }).filter(Boolean);
}

function Field({ label, children }) {
  return (
    <label className="client-gate-field">
      <span>{label}</span>
      {children}
    </label>
  );
}

function ClientMatchCard({ client, onView, onSelect }) {
  return (
    <article className={`client-match-card confidence-${client.confidenceLevel}`}>
      <div className="client-match-card-header">
        <div>
          <strong>{client.fullName}</strong>
          <p>{client.clientId} · {client.clientType}</p>
        </div>
        <span className="confidence-badge">{client.matchType} · {client.confidenceLabel}</span>
      </div>

      <dl className="client-match-summary">
        <div>
          <dt>Date of Birth</dt>
          <dd>{client.dateOfBirth || "-"}</dd>
        </div>
        <div>
          <dt>Primary Contact Details</dt>
          <dd>{client.email || client.phone || client.whatsapp || "-"}</dd>
        </div>
        <div>
          <dt>ID/NRIC</dt>
          <dd>{client.idReference || "-"}</dd>
        </div>
        <div>
          <dt>Last Matter Date</dt>
          <dd>{client.lastMatterDate || "-"}</dd>
        </div>
      </dl>

      <p className="client-match-reason">{client.reason}</p>

      <div className="client-match-actions">
        <button type="button" className="secondary-action" onClick={() => onView(client)}>
          View Full Profile
        </button>
        <button type="button" onClick={() => onSelect(client)}>
          Select This Client
        </button>
      </div>
    </article>
  );
}

export default function MatterIntakeWizard({ setModule } = {}) {
  const [step, setStep] = useState(1);
  const [clientStepMode, setClientStepMode] = useState(CLIENT_STEP_MODE.SEARCH);
  const [searchQuery, setSearchQuery] = useState("");
  const [searchPerformed, setSearchPerformed] = useState(false);
  const [clientMatches, setClientMatches] = useState([]);
  const [selectedExistingClient, setSelectedExistingClient] = useState(null);
  const [profilePreviewClient, setProfilePreviewClient] = useState(null);
  const [confirmedNoDuplicate, setConfirmedNoDuplicate] = useState(false);
  const [duplicateOverrideMatches, setDuplicateOverrideMatches] = useState([]);
  const [searchAuditTrail, setSearchAuditTrail] = useState([]);
  const [viewedClientIds, setViewedClientIds] = useState([]);
  const [clientIntake, setClientIntake] = useState(EMPTY_CLIENT_INTAKE);
  const [validationMessage, setValidationMessage] = useState("");
  const [draftMessage, setDraftMessage] = useState("");

  const stepLabel = STEPS[step - 1] || STEPS[0];

  const hasMinimumNewClientIdentity = useMemo(() => {
    if (clientIntake.clientType === "Organisation") {
      return Boolean(clientIntake.companyName.trim() || clientIntake.fullName.trim());
    }

    return Boolean(clientIntake.fullName.trim());
  }, [clientIntake]);

  function addAudit(action, details = {}) {
    const entry = {
      timestamp: new Date().toISOString(),
      action,
      ...details,
    };

    setSearchAuditTrail((current) => [...current, entry]);
  }

  function updateClientIntake(field, value) {
    setClientIntake((current) => ({
      ...current,
      [field]: value,
    }));

    setValidationMessage("");
    setDraftMessage("");
  }

  function runClientSearch() {
    const trimmed = searchQuery.trim();

    if (!trimmed) {
      setValidationMessage("Enter at least one identifying detail before searching.");
      return;
    }

    const matches = findClientMatches(trimmed);
    setSearchPerformed(true);
    setClientMatches(matches);
    setProfilePreviewClient(null);
    setValidationMessage("");
    setDraftMessage(matches.length ? `${matches.length} possible match record(s) found.` : "No results found.");

    addAudit("search_performed", {
      query: trimmed,
      resultCount: matches.length,
    });
  }

  function viewFullProfile(client) {
    setProfilePreviewClient(client);
    setViewedClientIds((current) => Array.from(new Set([...current, client.clientId])));
    addAudit("full_profile_viewed", {
      clientId: client.clientId,
      fullName: client.fullName,
    });
  }

  function selectExistingClient(client) {
    setSelectedExistingClient(client);
    setClientStepMode(CLIENT_STEP_MODE.EXISTING_SELECTED);
    setValidationMessage("");
    setDraftMessage("Existing client selected for this matter intake.");

    addAudit("existing_client_selected", {
      clientId: client.clientId,
      fullName: client.fullName,
    });
  }

  function openNewClientCreation() {
    if (!searchPerformed) {
      setValidationMessage("Search must be performed before creating a full client profile.");
      return;
    }

    const derivedIntake = deriveIntakeFromSearch(searchQuery, clientIntake);

    try {
      localStorage.setItem(
        "litigation360:no-match-client-creation-context",
        JSON.stringify({
          source: "matter-intake-no-match",
          searchTerm: searchQuery.trim(),
          reviewedResultCount: clientMatches.length,
          searchPerformed,
          suggestedIntake: derivedIntake,
          instruction: "Create the full client profile in Direct Client Directory / Manual Management.",
          createdAt: new Date().toISOString(),
        }),
      );
    } catch (error) {
      console.warn("No-match client creation context could not be saved.", error);
    }

    setClientIntake(derivedIntake);
    setConfirmedNoDuplicate(false);
    setValidationMessage("");
    setDraftMessage("Redirecting to Direct Client Directory / Manual Management for full client profile creation.");

    addAudit("no_match_redirected_to_advanced_client_directory", {
      query: searchQuery.trim(),
      reviewedResultCount: clientMatches.length,
    });

    setModule?.("Clients");
  }

  function saveDraft() {
    localStorage.setItem(
      "litigation360:matter-intake-client-draft",
      JSON.stringify({
        clientIntake,
        clientStepMode,
        searchQuery,
        searchPerformed,
        clientMatches,
        selectedExistingClient,
        searchAuditTrail,
        savedAt: new Date().toISOString(),
      }),
    );

    setDraftMessage("Client intake draft saved locally.");
    addAudit("client_intake_draft_saved");
  }

  function clearDraft() {
    localStorage.removeItem("litigation360:matter-intake-client-draft");
    setDraftMessage("Client intake draft cleared.");
    addAudit("client_intake_draft_cleared");
  }

  function resetClientIntake() {
    setClientIntake(EMPTY_CLIENT_INTAKE);
    setConfirmedNoDuplicate(false);
    setDuplicateOverrideMatches([]);
    setValidationMessage("");
    setDraftMessage("Client intake fields reset.");
    addAudit("client_intake_reset");
  }

  function continueToCaseDetailsFromNewClient({ allowOverride = false } = {}) {
    if (!searchPerformed) {
      setValidationMessage("Search must be completed before continuing.");
      setClientStepMode(CLIENT_STEP_MODE.SEARCH);
      return;
    }

    if (!confirmedNoDuplicate) {
      setValidationMessage("Confirm that duplicate search was performed and reviewed before entering a new client profile.");
      return;
    }

    if (!hasMinimumNewClientIdentity) {
      setValidationMessage("Minimum required field missing: Full Name (legal name) or Company/Organisation Name.");
      return;
    }

    const duplicateCandidates = detectDuplicateCandidates(clientIntake);

    if (duplicateCandidates.length && !allowOverride) {
      setDuplicateOverrideMatches(duplicateCandidates);
      setClientStepMode(CLIENT_STEP_MODE.DUPLICATE_REVIEW);
      setValidationMessage("Possible duplicate detected. Review the matching record(s) and record an override reason before continuing.");
      addAudit("duplicate_hard_stop_triggered", {
        matchCount: duplicateCandidates.length,
      });
      return;
    }

    if (duplicateCandidates.length && clientIntake.duplicateDecision.trim().length < 12) {
      setValidationMessage("Duplicate Decision/Review Notes must explain why this is a new record before override is allowed.");
      return;
    }

    addAudit(duplicateCandidates.length ? "duplicate_override_confirmed" : "new_client_confirmed", {
      fullName: clientIntake.fullName,
      companyName: clientIntake.companyName,
      reason: clientIntake.duplicateDecision,
    });

    setStep(2);
    setValidationMessage("");
    setDraftMessage("Client profile accepted. Continue with Case / Matter Details.");
  }

  function continueFromExistingClient() {
    if (!selectedExistingClient) {
      setValidationMessage("Select an existing client before continuing.");
      return;
    }

    addAudit("continued_with_existing_client", {
      clientId: selectedExistingClient.clientId,
      fullName: selectedExistingClient.fullName,
    });

    setStep(2);
    setValidationMessage("");
    setDraftMessage("Existing client linked to matter intake.");
  }

  function previousStep() {
    if (step === 1) {
      if (clientStepMode !== CLIENT_STEP_MODE.SEARCH) {
        setClientStepMode(CLIENT_STEP_MODE.SEARCH);
        setValidationMessage("");
        return;
      }

      return;
    }

    setStep((current) => Math.max(1, current - 1));
  }

  function nextStep() {
    if (step === 1) {
      if (clientStepMode === CLIENT_STEP_MODE.EXISTING_SELECTED) {
        continueFromExistingClient();
        return;
      }

      if (clientStepMode === CLIENT_STEP_MODE.CREATE) {
        continueToCaseDetailsFromNewClient();
        return;
      }

      if (clientStepMode === CLIENT_STEP_MODE.DUPLICATE_REVIEW) {
        continueToCaseDetailsFromNewClient({ allowOverride: true });
        return;
      }

      setValidationMessage("Search and select an existing client, or confirm no match before creating a new client profile.");
      return;
    }

    if (step < STEPS.length) {
      setStep((current) => current + 1);
      return;
    }

    setModule?.("Review Submit");
  }


  function renderPageNavigationBar(placement = "top") {
    const isTop = placement === "top";

    const goPreviousPage = () => {
      if (step === 1 && clientStepMode === CLIENT_STEP_MODE.SEARCH) {
        setModule?.("Client Intake Discovery");
        return;
      }

      previousStep();
    };

    const goPageEdge = () => {
      window.scrollTo({
        top: isTop ? document.documentElement.scrollHeight : 0,
        behavior: "smooth",
      });
    };

    return (
      <div
        className="matter-intake-page-nav"
        aria-label={"Matter intake page navigation - " + placement}
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(3, minmax(0, 1fr))",
          gap: "12px 16px",
          alignItems: "center",
          margin: isTop ? "0 0 24px" : "24px 0 0",
          padding: "14px",
          border: "1px solid rgba(148, 163, 184, 0.35)",
          borderRadius: "18px",
          background: "#ffffff",
        }}
      >
        <button type="button" className="secondary-action" onClick={goPreviousPage}>
          ← Previous Page
        </button>

        <button type="button" className="secondary-action" onClick={() => setModule?.("home")}>
          Home Main Page
        </button>

        <button type="button" onClick={nextStep}>
          Continue to Next Step →
        </button>

        <button
          type="button"
          className="secondary-action"
          onClick={goPageEdge}
          style={{ gridColumn: "2 / 3" }}
        >
          {isTop ? "Go to Bottom/End of Page ↓" : "Go to Top of Page ↑"}
        </button>
      </div>
    );
  }

  function renderStepTabs() {
    return (
      <div className="intake-step-grid">
        {STEPS.map((label, index) => {
          const number = index + 1;
          const active = number === step;

          return (
            <div key={label} className={`intake-step-pill ${active ? "active" : ""}`}>
              <span>{number}</span>
              {label}
            </div>
          );
        })}
      </div>
    );
  }

  function renderSearchTips() {
    return (
      <aside className="client-gate-tips">
        <strong>Search Tips</strong>
        <ul>
          <li>Try full legal name first.</li>
          <li>Use ID/NRIC, passport number, phone, WhatsApp, or email if the name is uncertain.</li>
          <li>Try alternate spellings, partial names, preferred names, or aliases.</li>
          <li>Company name can help locate organisation-linked records.</li>
        </ul>
      </aside>
    );
  }

  function renderAuditTrail() {
    if (!searchAuditTrail.length) return null;

    return (
      <details className="client-audit-trail">
        <summary>Search audit trail ({searchAuditTrail.length})</summary>
        <ol>
          {searchAuditTrail.map((entry, index) => (
            <li key={`${entry.timestamp}-${index}`}>
              <strong>{entry.action}</strong>
              <span>{entry.timestamp}</span>
              {entry.query ? <em>Query: {entry.query}</em> : null}
              {typeof entry.resultCount === "number" ? <em>Results: {entry.resultCount}</em> : null}
              {entry.clientId ? <em>Client: {entry.clientId}</em> : null}
            </li>
          ))}
        </ol>
      </details>
    );
  }

  function renderSearchModule() {
    return (
      <section className="client-gate-screen">

        <div className="client-search-layout">
          <div className="client-search-primary">
            <label className="client-search-input-label" htmlFor="client-search-gate-input">
              Search Existing Client
            </label>
            <div className="client-search-row">
              <input
                id="client-search-gate-input"
                type="search"
                value={searchQuery}
                onChange={(event) => setSearchQuery(event.target.value)}
                onKeyDown={(event) => {
                  if (event.key === "Enter") {
                    event.preventDefault();
                    runClientSearch();
                  }
                }}
                placeholder="Enter full name, given name, surname, preferred name, alias, ID/NRIC, passport number, phone, WhatsApp, email, or company name"
              />
              <button type="button" onClick={runClientSearch}>
                Search Existing Client
              </button>
            </div>

            <div className="client-search-chip-row">
              <span>Name</span>
              <span>ID/NRIC</span>
              <span>Passport</span>
              <span>Phone</span>
              <span>WhatsApp</span>
              <span>Email</span>
              <span>Company</span>
            </div>

            <div className="client-search-secondary-actions">
              <button type="button" className="secondary-action" onClick={() => {
                setSearchQuery("");
                setClientMatches([]);
                setSearchPerformed(false);
                setProfilePreviewClient(null);
                setValidationMessage("");
                setDraftMessage("");
              }}>
                Clear Search
              </button>
              <button type="button" className="secondary-action" onClick={() => setModule?.("Clients")}>
                Direct Client Directory / Manual Management
              </button>
            </div>

            <small className="intake-small">
              Opens the full manual client directory for review or editing. The guided Matter Intake conveyor remains active and separate.
            </small>
          </div>

          {renderSearchTips()}
        </div>

        {searchPerformed ? (
          <div className="client-search-results">
            <div className="client-results-header">
              <h3>Search Results</h3>
              <span>{clientMatches.length} potential match(es)</span>
            </div>

            {clientMatches.length ? (
              <div className="client-match-list">
                {clientMatches.map((client) => (
                  <ClientMatchCard
                    key={client.clientId}
                    client={client}
                    onView={viewFullProfile}
                    onSelect={selectExistingClient}
                  />
                ))}
              </div>
            ) : (
              <div className="client-no-match-panel">
                <strong>No Match Found</strong>
                <p>No existing client record matched this search. Create the full client profile through Direct Client Directory / Manual Management so complete contact, billing, communication, document, audit, and manual-management details are preserved.</p>
              </div>
            )}

            <button type="button" className="client-create-pathway" onClick={openNewClientCreation}>
              No Match Found — Create Full Client Profile in Advanced Directory
            </button>
          </div>
        ) : null}

        {profilePreviewClient ? (
          <aside className="client-profile-preview">
            <div>
              <p className="eyebrow">Read-only profile preview</p>
              <h3>{profilePreviewClient.fullName}</h3>
            </div>
            <dl className="client-match-summary">
              <div>
                <dt>Client ID</dt>
                <dd>{profilePreviewClient.clientId}</dd>
              </div>
              <div>
                <dt>Date of Birth</dt>
                <dd>{profilePreviewClient.dateOfBirth}</dd>
              </div>
              <div>
                <dt>Email</dt>
                <dd>{profilePreviewClient.email}</dd>
              </div>
              <div>
                <dt>Phone / WhatsApp</dt>
                <dd>{profilePreviewClient.phone} / {profilePreviewClient.whatsapp}</dd>
              </div>
              <div>
                <dt>ID/NRIC</dt>
                <dd>{profilePreviewClient.idReference}</dd>
              </div>
              <div>
                <dt>Last Matter Date</dt>
                <dd>{profilePreviewClient.lastMatterDate}</dd>
              </div>
            </dl>
          </aside>
        ) : null}

        {renderAuditTrail()}
      </section>
    );
  }

  function renderExistingSelectedModule() {
    return (
      <section className="client-gate-screen">
        <div className="client-gate-header">
          <div>
            <p className="eyebrow">Stage 2 · Existing Client Decision</p>
            <h2>Existing Client Selected</h2>
            <p>This existing client will be linked to the new matter/intake.</p>
          </div>
          <span className="intake-status-pill">Existing client</span>
        </div>

        <ClientMatchCard client={selectedExistingClient} onView={viewFullProfile} onSelect={continueFromExistingClient} />

        <div className="client-selected-actions">
          <button type="button" className="secondary-action" onClick={() => setClientStepMode(CLIENT_STEP_MODE.SEARCH)}>
            Change Selection
          </button>
          <button type="button" onClick={continueFromExistingClient}>
            Continue to Next Step →
          </button>
        </div>

        {profilePreviewClient ? (
          <aside className="client-profile-preview">
            <h3>{profilePreviewClient.fullName}</h3>
            <p>{profilePreviewClient.email} · {profilePreviewClient.phone}</p>
          </aside>
        ) : null}

        {renderAuditTrail()}
      </section>
    );
  }

  function renderNewClientCreationModule() {
    return (
      <section className="client-gate-screen">
        <div className="client-gate-header">
          <div>
            <p className="eyebrow">Step 1B</p>
            <h2>Legacy Simplified Client Intake Form</h2>
            <p>Legacy fallback only. The primary no-match creation route now redirects to Direct Client Directory / Manual Management for the complete full profile process.</p>
          </div>
          <span className="intake-status-pill">Protected interface</span>
        </div>

        <div className="client-confirmation-gate">
          <label>
            <input
              type="checkbox"
              checked={confirmedNoDuplicate}
              onChange={(event) => {
                setConfirmedNoDuplicate(event.target.checked);
                addAudit(event.target.checked ? "no_duplicate_confirmation_checked" : "no_duplicate_confirmation_unchecked", {
                  query: searchQuery.trim(),
                  reviewedResultCount: clientMatches.length,
                });
              }}
            />
            <span>
              I confirm I have performed a search and verified no duplicate exists before creating a new client profile.
            </span>
          </label>
        </div>

        {!confirmedNoDuplicate ? (
          <div className="client-search-empty-state">
            <strong>New client form protected</strong>
            <p>Confirm the duplicate search gate above before entering brand-new client details.</p>
          </div>
        ) : (
          <>
            <div className="client-create-actions">
              <button type="button" className="secondary-action" onClick={saveDraft}>
                Save Draft
              </button>
              <button type="button" className="secondary-action" onClick={clearDraft}>
                Clear Draft
              </button>
              <button type="button" className="secondary-action" onClick={resetClientIntake}>
                Reset Client Intake
              </button>
            </div>

            <div className="client-profile-form-gated">
              <section>
                <h3>Client Type</h3>
                <Field label="Client Type">
                  <select value={clientIntake.clientType} onChange={(event) => updateClientIntake("clientType", event.target.value)}>
                    <option>Individual</option>
                    <option>Organisation</option>
                  </select>
                </Field>
              </section>

              {clientIntake.clientType === "Individual" ? (
                <section>
                  <h3>Individual Information</h3>
                  <div className="client-form-grid three">
                    <Field label="Full Name (legal name)">
                      <input value={clientIntake.fullName} onChange={(event) => updateClientIntake("fullName", event.target.value)} placeholder="Client full legal name" />
                    </Field>
                    <Field label="Given Name">
                      <input value={clientIntake.givenName} onChange={(event) => updateClientIntake("givenName", event.target.value)} placeholder="Given name" />
                    </Field>
                    <Field label="Surname">
                      <input value={clientIntake.surname} onChange={(event) => updateClientIntake("surname", event.target.value)} placeholder="Surname / family name" />
                    </Field>
                    <Field label="Preferred Name">
                      <input value={clientIntake.preferredName} onChange={(event) => updateClientIntake("preferredName", event.target.value)} placeholder="Preferred name" />
                    </Field>
                    <Field label="Alias/Also Known As">
                      <input value={clientIntake.alias} onChange={(event) => updateClientIntake("alias", event.target.value)} placeholder="Alias, nickname, alternate spelling" />
                    </Field>
                  </div>
                </section>
              ) : null}

              <section>
                <h3>Contact Details</h3>
                <div className="client-form-grid three">
                  <Field label="Email">
                    <input type="email" value={clientIntake.email} onChange={(event) => updateClientIntake("email", event.target.value)} placeholder="Email address" />
                  </Field>
                  <Field label="Phone">
                    <input value={clientIntake.phone} onChange={(event) => updateClientIntake("phone", event.target.value)} placeholder="Primary phone number" />
                  </Field>
                  <Field label="WhatsApp">
                    <input value={clientIntake.whatsapp} onChange={(event) => updateClientIntake("whatsapp", event.target.value)} placeholder="WhatsApp number" />
                  </Field>
                </div>
              </section>

              <section>
                <h3>Identification</h3>
                <div className="client-form-grid three">
                  <Field label="ID/NRIC/Reference">
                    <input value={clientIntake.idReference} onChange={(event) => updateClientIntake("idReference", event.target.value)} placeholder="ID, NRIC, internal reference" />
                  </Field>
                  <Field label="Passport Number">
                    <input value={clientIntake.passportNumber} onChange={(event) => updateClientIntake("passportNumber", event.target.value)} placeholder="Passport number" />
                  </Field>
                  <Field label="Date of Birth">
                    <input value={clientIntake.dateOfBirth} onChange={(event) => updateClientIntake("dateOfBirth", event.target.value)} placeholder="dd/mm/yyyy" />
                  </Field>
                </div>
              </section>

              <section>
                <h3>Employment/Entity</h3>
                <Field label="Company/Organisation Name">
                  <input value={clientIntake.companyName} onChange={(event) => updateClientIntake("companyName", event.target.value)} placeholder="Company, employer, organisation, or entity name" />
                </Field>
              </section>

              <section>
                <h3>Address</h3>
                <Field label="Full Address">
                  <textarea value={clientIntake.address} onChange={(event) => updateClientIntake("address", event.target.value)} placeholder="Full address" rows={3} />
                </Field>
                <div className="client-form-grid three">
                  <Field label="City/Area">
                    <input value={clientIntake.city} onChange={(event) => updateClientIntake("city", event.target.value)} placeholder="City, town, area" />
                  </Field>
                  <Field label="Postcode">
                    <input value={clientIntake.postcode} onChange={(event) => updateClientIntake("postcode", event.target.value)} placeholder="Postcode" />
                  </Field>
                  <Field label="State">
                    <input value={clientIntake.state} onChange={(event) => updateClientIntake("state", event.target.value)} placeholder="State" />
                  </Field>
                </div>
                <Field label="Country">
                  <input value={clientIntake.country} onChange={(event) => updateClientIntake("country", event.target.value)} placeholder="Malaysia" />
                </Field>
              </section>

              <section>
                <h3>Intake Metadata</h3>
                <div className="client-form-grid two">
                  <Field label="Intake Source">
                    <select value={clientIntake.intakeSource} onChange={(event) => updateClientIntake("intakeSource", event.target.value)}>
                      <option>Manual Entry</option>
                      <option>Referral</option>
                      <option>Walk-in</option>
                      <option>Phone Inquiry</option>
                      <option>Email Inquiry</option>
                      <option>Website Inquiry</option>
                      <option>Existing Client Referral</option>
                      <option>Other</option>
                    </select>
                  </Field>
                </div>

                <Field label="Duplicate Decision/Review Notes">
                  <textarea
                    value={clientIntake.duplicateDecision}
                    onChange={(event) => updateClientIntake("duplicateDecision", event.target.value)}
                    placeholder="Record duplicate decision, reason to continue as new, or selected existing client reference."
                    rows={3}
                  />
                </Field>

                <Field label="General Intake Notes">
                  <textarea
                    value={clientIntake.notes}
                    onChange={(event) => updateClientIntake("notes", event.target.value)}
                    placeholder="Matter notes, referral details, urgency, source comments, or copied intake context."
                    rows={4}
                  />
                </Field>
              </section>
            </div>
          </>
        )}

        {renderAuditTrail()}
      </section>
    );
  }

  function renderDuplicateReviewModule() {
    return (
      <section className="client-gate-screen duplicate-hard-stop">
        <div className="client-gate-header">
          <div>
            <p className="eyebrow">Duplicate hard stop</p>
            <h2>Possible Existing Client Detected</h2>
            <p>Review the matching record(s). Continuing as new requires explicit justification.</p>
          </div>
          <span className="intake-status-pill danger">Review required</span>
        </div>

        <div className="client-match-list">
          {duplicateOverrideMatches.map((client) => (
            <ClientMatchCard key={client.clientId} client={client} onView={viewFullProfile} onSelect={selectExistingClient} />
          ))}
        </div>

        <Field label="Duplicate Decision/Review Notes">
          <textarea
            value={clientIntake.duplicateDecision}
            onChange={(event) => updateClientIntake("duplicateDecision", event.target.value)}
            placeholder="Record duplicate decision, reason to continue as new, or selected existing client reference."
            rows={4}
          />
        </Field>

        <div className="client-selected-actions">
          <button type="button" className="secondary-action" onClick={() => setClientStepMode(CLIENT_STEP_MODE.SEARCH)}>
            ← Previous Page
          </button>
          <button type="button" className="secondary-action" onClick={openNewClientCreation}>
            Create Full Profile in Advanced Directory
          </button>
          <button type="button" onClick={() => continueToCaseDetailsFromNewClient({ allowOverride: true })}>
            Continue to Next Step →
          </button>
        </div>

        {renderAuditTrail()}
      </section>
    );
  }

  function renderClientDetailsStep() {
    if (clientStepMode === CLIENT_STEP_MODE.SEARCH) return renderSearchModule();
    if (clientStepMode === CLIENT_STEP_MODE.CREATE) return renderNewClientCreationModule();
    if (clientStepMode === CLIENT_STEP_MODE.EXISTING_SELECTED) return renderExistingSelectedModule();
    if (clientStepMode === CLIENT_STEP_MODE.DUPLICATE_REVIEW) return renderDuplicateReviewModule();

    return null;
  }

  function renderLaterStep() {
    return (
      <section className="client-gate-screen">
        <div className="client-gate-header">
          <div>
            <p className="eyebrow">Step {step}</p>
            <h2>{stepLabel}</h2>
            <p>
              Continue the matter intake workflow using the client selected or created in this stage.
            </p>
          </div>
          <span className="intake-status-pill">Client linked</span>
        </div>

        <div className="client-search-empty-state">
          <strong>Client context</strong>
          {selectedExistingClient ? (
            <p>{selectedExistingClient.fullName} is linked as the existing client for this matter.</p>
          ) : (
            <p>{clientIntake.fullName || clientIntake.companyName || "New client profile"} is prepared for this matter intake.</p>
          )}
        </div>
      </section>
    );
  }

  return (
    <div className="matter-intake-workflow">
      <div className="intake-workflow-header">
        <div>
          <p>Stage 2 Matter Intake Workflow</p>
          <h2>{stepLabel}</h2>
          <p>Start with duplicate detection, then confirm an existing client or continue to client details entry before proceeding to matter facts.</p>
        </div>
        <span className="intake-status-pill">Step 2 of {STEPS.length} · OPEN</span>
      </div>

      {renderPageNavigationBar("top")}

      {step === 1 ? renderClientDetailsStep() : renderLaterStep()}

      {validationMessage ? <div className="intake-validation-message">{validationMessage}</div> : null}
      {draftMessage ? <div className="intake-draft-message">{draftMessage}</div> : null}

      {renderPageNavigationBar("bottom")}
    </div>
  );
}

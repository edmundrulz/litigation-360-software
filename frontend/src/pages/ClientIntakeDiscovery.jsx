import { useEffect, useMemo, useState } from "react";
import WizardProgressPanel from "../components/workflow/WizardProgressPanel";

const STORAGE_KEY = "litigation360.workflow.stage1.preliminaryAssessment";

const initialAssessment = {
  prospectiveClient: "",
  contactPerson: "",
  authorityToInstruct: "Unknown / to verify",
  conflictRisk: "Not checked",
  matterCategory: "",
  urgencyLevel: "Normal",
  criticalDeadline: "",
  documentReadiness: "Partially available",
  evidencePosition: "Unknown / to assess",
  budgetClarity: "Unknown / estimate required",
  primaryObjective: "",
  backgroundSummary: "",
};

const primaryRoutes = {
  matter: {
    number: "2",
    title: "Matter Intake / Urgent Action",
    shortTitle: "Matter Intake",
    headline: "Proceed to urgent matter intake first.",
    purpose:
      "Use this route when time-sensitive legal exposure must be assessed before ordinary onboarding continues.",
    examples:
      "Court date, limitation risk, urgent filing, injunction risk, regulatory deadline, enforcement risk, or immediate commercial exposure.",
  },
  client: {
    number: "3",
    title: "Client Details / Authority & Conflict",
    shortTitle: "Client Details",
    headline: "Resolve client identity, authority, and conflict first.",
    purpose:
      "Use this route when the firm must confirm who the client is, who can instruct, and whether the firm is clear to act.",
    examples:
      "Unclear authority, incomplete contact details, possible conflict, onboarding issue, KYC, retainer approval, or engagement governance.",
  },
};

const supportingStages = [
  {
    number: "4",
    title: "Documents & Evidence Readiness",
    text: "Collect chronology, agreements, correspondence, payment proof, pleadings, notices, photos, reports, or other evidence required for review.",
  },
  {
    number: "5",
    title: "Scope, Risk & Strategy Review",
    text: "Clarify the proposed work scope, exclusions, risk position, merits, dependencies, deadlines, and practical action plan.",
  },
  {
    number: "6",
    title: "Fee Estimate & Engagement Terms",
    text: "Clarify budget range, fee model, assumptions, disbursements, approval threshold, and variation triggers before formal engagement.",
  },
  {
    number: "7",
    title: "Draft Engagement Preview",
    text: "Prepare an internal draft engagement summary only after intake, authority, conflict, documents, scope, and fee expectations are clear enough.",
  },
];

function loadStoredAssessment() {
  if (typeof window === "undefined") return initialAssessment;

  try {
    const stored = window.localStorage.getItem(STORAGE_KEY);
    if (!stored) return initialAssessment;

    const parsed = JSON.parse(stored);
    return {
      ...initialAssessment,
      ...(parsed.assessment || {}),
    };
  } catch {
    return initialAssessment;
  }
}

function hasValue(value) {
  return String(value || "").trim().length > 0;
}

function analyseAssessment(assessment) {
  let matterPriority = 0;
  let clientPriority = 0;
  const matterReasons = [];
  const clientReasons = [];
  const supportingAlerts = [];

  if (assessment.urgencyLevel === "High") {
    matterPriority += 35;
    matterReasons.push("High urgency selected.");
  }

  if (assessment.urgencyLevel === "Critical / same day") {
    matterPriority += 55;
    matterReasons.push("Critical same-day urgency selected.");
  }

  if (hasValue(assessment.criticalDeadline)) {
    matterPriority += 40;
    matterReasons.push("Critical deadline or time pressure recorded.");
  }

  if (
    assessment.authorityToInstruct === "Unknown / to verify" ||
    assessment.authorityToInstruct === "No clear authority yet"
  ) {
    clientPriority += 40;
    clientReasons.push("Authority to instruct is not confirmed.");
  }

  if (assessment.authorityToInstruct === "Representative claims authority") {
    clientPriority += 25;
    clientReasons.push("Representative authority requires verification.");
  }

  if (assessment.conflictRisk === "Not checked") {
    clientPriority += 35;
    clientReasons.push("Conflict position has not been checked.");
  }

  if (assessment.conflictRisk === "Possible conflict") {
    clientPriority += 55;
    clientReasons.push("Possible conflict requires clearance before proceeding.");
  }

  if (!hasValue(assessment.prospectiveClient)) {
    clientPriority += 10;
    clientReasons.push("Prospective client identity is incomplete.");
  }

  if (
    assessment.documentReadiness === "Not available" ||
    assessment.documentReadiness === "Partially available"
  ) {
    supportingAlerts.push("Stage 4 document readiness should be improved before full legal review.");
  }

  if (
    assessment.evidencePosition === "Unknown / to assess" ||
    assessment.evidencePosition === "Weak / incomplete"
  ) {
    supportingAlerts.push("Stage 5 risk and evidence review may be required before scope is finalised.");
  }

  if (
    assessment.budgetClarity === "Unknown / estimate required" ||
    assessment.budgetClarity === "Budget concern"
  ) {
    supportingAlerts.push("Stage 6 fee estimate and approval threshold should be clarified before engagement approval.");
  }

  if (!hasValue(assessment.primaryObjective)) {
    supportingAlerts.push("Client priorities and desired outcomes are not yet recorded.");
  }

  const primaryRouteId = "matter";
  const secondaryRouteId = "client";

  return {
    matterPriority,
    clientPriority,
    primaryRouteId,
    secondaryRouteId,
    primaryRoute: primaryRoutes[primaryRouteId],
    secondaryRoute: primaryRoutes[secondaryRouteId],
    matterReasons,
    clientReasons,
    supportingAlerts,
  };
}

export default function ClientIntakeDiscovery() {
  const [assessment, setAssessment] = useState(loadStoredAssessment);
  const [selectedRouteId, setSelectedRouteId] = useState("");
  const [lastSavedAt, setLastSavedAt] = useState("");

  const analysis = useMemo(() => analyseAssessment(assessment), [assessment]);

  const selectedRoute =
    selectedRouteId === "matter"
      ? primaryRoutes.matter
      : selectedRouteId === "client"
        ? primaryRoutes.client
        : analysis.primaryRoute;

  const completedInputs = useMemo(() => {
    return Object.values(assessment).filter(hasValue).length;
  }, [assessment]);

  const completionPercent = Math.round(
    (completedInputs / Object.keys(initialAssessment).length) * 100
  );

  useEffect(() => {
    if (typeof window === "undefined") return;

    const now = new Date().toLocaleString();
    const payload = {
      workflowStage: "1",
      stageTitle: "Preliminary Assessment & Triage",
      recommendedNextStage: analysis.primaryRoute.number,
      recommendedNextTitle: analysis.primaryRoute.title,
      assessment,
      lastSavedAt: now,
    };

    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(payload));
    setLastSavedAt(now);
  }, [assessment, analysis.primaryRoute.number, analysis.primaryRoute.title]);

  function updateField(field, value) {
    setAssessment((current) => ({
      ...current,
      [field]: value,
    }));
  }

  const primaryReasons =
    analysis.primaryRouteId === "matter"
      ? analysis.matterReasons
      : analysis.clientReasons;

  const secondaryReasons =
    analysis.secondaryRouteId === "matter"
      ? analysis.matterReasons
      : analysis.clientReasons;

  return (
    <main
      className="client-intake-page"
      aria-labelledby="client-intake-title"
      style={pageStyle}
    >
      <section style={heroStyle}>
        <div>
          <p style={eyebrowStyle}>Step 1 · Assessment Gateway</p>
          <h1 id="client-intake-title" style={titleStyle}>
            1. Preliminary Assessment & Triage
          </h1>
          <p style={heroTextStyle}>
            The mandatory first step before Matter Intake, Client Details, document readiness, fee review, or draft engagement preparation. The assessment recommends the next appropriate workflow step.
          </p>
        </div>

        <aside style={statusPanelStyle}>
          <strong>Local assessment status</strong>
          <p style={{ margin: "10px 0 0", lineHeight: 1.6 }}>
            Information is saved locally in this browser. This assessment screen does not create a client record, open a matter file, upload documents, issue a fee quote, or provide legal advice.
          </p>
          <p style={{ margin: "12px 0 0", fontWeight: 800 }}>
            Autosaved: {lastSavedAt || "pending first change"}
          </p>
        </aside>
      </section>
      <WizardProgressPanel
        currentStep={1}
        pageCompletionPercent={completionPercent}
        pageCompletionLabel="Current Page Completion"
      />

      <section style={layoutStyle}>
        <section style={mainPanelStyle}>
          <div style={sectionHeaderStyle}>
            <div>
              <p style={eyebrowStyle}>Step 1 assessment</p>
              <h2 style={h2Style}>Assessment Details</h2>
              <p style={mutedTextStyle}>
                Complete the decision-critical intake factors below. The system
                will recommend the next appropriate step: Matter Intake or Client Details.
              </p>
            </div>
          </div>

          <FormSection
            title="A. Identity, Authority & Conflict"
            text="These fields decide whether Step 3 Client Details, Authority & Conflict must happen before matter work."
          >
            <div style={formGridStyle}>
              <Field label="Prospective Client / Entity">
                <TextInput
                  value={assessment.prospectiveClient}
                  onChange={(value) => updateField("prospectiveClient", value)}
                  placeholder="e.g. ABC Sdn Bhd / John Tan"
                />
              </Field>

              <Field label="Contact Person">
                <TextInput
                  value={assessment.contactPerson}
                  onChange={(value) => updateField("contactPerson", value)}
                  placeholder="Name, role, phone, email"
                />
              </Field>

              <Field label="Authority to Instruct">
                <SelectInput
                  value={assessment.authorityToInstruct}
                  onChange={(value) => updateField("authorityToInstruct", value)}
                >
                  <option>Unknown / to verify</option>
                  <option>No clear authority yet</option>
                  <option>Representative claims authority</option>
                  <option>Confirmed</option>
                </SelectInput>
              </Field>

              <Field label="Conflict / Independence Position">
                <SelectInput
                  value={assessment.conflictRisk}
                  onChange={(value) => updateField("conflictRisk", value)}
                >
                  <option>Not checked</option>
                  <option>Possible conflict</option>
                  <option>No obvious conflict recorded</option>
                </SelectInput>
              </Field>
            </div>
          </FormSection>

          <FormSection
            title="B. Urgency & Matter Direction"
            text="These fields decide whether Step 2 Matter Intake / Urgent Action should become the next route."
          >
            <div style={formGridStyle}>
              <Field label="Matter Category">
                <TextInput
                  value={assessment.matterCategory}
                  onChange={(value) => updateField("matterCategory", value)}
                  placeholder="e.g. debt recovery, employment, tenancy, contract dispute"
                />
              </Field>

              <Field label="Urgency Level">
                <SelectInput
                  value={assessment.urgencyLevel}
                  onChange={(value) => updateField("urgencyLevel", value)}
                >
                  <option>Low</option>
                  <option>Normal</option>
                  <option>High</option>
                  <option>Critical / same day</option>
                </SelectInput>
              </Field>

              <Field label="Critical Deadline / Time Pressure">
                <TextInput
                  value={assessment.criticalDeadline}
                  onChange={(value) => updateField("criticalDeadline", value)}
                  placeholder="e.g. hearing tomorrow / limitation risk / no fixed deadline"
                />
              </Field>

              <Field label="Document Readiness">
                <SelectInput
                  value={assessment.documentReadiness}
                  onChange={(value) => updateField("documentReadiness", value)}
                >
                  <option>Not available</option>
                  <option>Partially available</option>
                  <option>Mostly available</option>
                  <option>Complete for preliminary review</option>
                </SelectInput>
              </Field>
            </div>
          </FormSection>

          <FormSection
            title="C. Evidence, Budget & Desired Outcome"
            text="These fields support documents, scope, risk, fee estimate, and draft engagement readiness."
          >
            <div style={formGridStyle}>
              <Field label="Evidence Position">
                <SelectInput
                  value={assessment.evidencePosition}
                  onChange={(value) => updateField("evidencePosition", value)}
                >
                  <option>Unknown / to assess</option>
                  <option>Weak / incomplete</option>
                  <option>Moderate</option>
                  <option>Strong for preliminary review</option>
                </SelectInput>
              </Field>

              <Field label="Budget / Fee Clarity">
                <SelectInput
                  value={assessment.budgetClarity}
                  onChange={(value) => updateField("budgetClarity", value)}
                >
                  <option>Unknown / estimate required</option>
                  <option>Budget concern</option>
                  <option>Budget range provided</option>
                  <option>Fee model agreed in principle</option>
                </SelectInput>
              </Field>
            </div>

            <div style={{ display: "grid", gap: 16, marginTop: 16 }}>
              <Field
                label="Client Priorities, Objectives & Desired Outcomes"
                note="Professional wording for the client’s commercial and legal objectives."
              >
                <TextArea
                  value={assessment.primaryObjective}
                  onChange={(value) => updateField("primaryObjective", value)}
                  placeholder="Record immediate priority, desired outcome, acceptable compromise position, and longer-term objective."
                />
              </Field>

              <Field label="Brief Matter Background">
                <TextArea
                  value={assessment.backgroundSummary}
                  onChange={(value) => updateField("backgroundSummary", value)}
                  placeholder="Summarise what happened, when it started, who is involved, current stage, and why help is needed now."
                />
              </Field>
            </div>
          </FormSection>
        </section>

        <aside style={sideColumnStyle}>
          <section style={recommendationStyle}>
            <p style={eyebrowStyle}>Recommended next step</p>
            <div style={routeBadgeStyle}>{analysis.primaryRoute.number}</div>
            <h2 style={{ ...h2Style, marginTop: 12 }}>
              {analysis.primaryRoute.title}
            </h2>
            <p style={mutedTextStyle}>{analysis.primaryRoute.headline}</p>
          </section>

          <section style={panelStyle}>
            <p style={eyebrowStyle}>Priority branch after Stage 1</p>

            <RouteChoice
              route={primaryRoutes.matter}
              recommended={analysis.primaryRouteId === "matter"}
              selected={selectedRoute.number === "2"}
              onClick={() => setSelectedRouteId("matter")}
            />

            <RouteChoice
              route={primaryRoutes.client}
              recommended={analysis.primaryRouteId === "client"}
              selected={selectedRoute.number === "3"}
              onClick={() => setSelectedRouteId("client")}
            />
          </section>

          <section style={panelStyle}>
            <p style={eyebrowStyle}>Selected route explanation</p>
            <h3 style={{ margin: "0 0 8px", color: "#0f172a" }}>
              {selectedRoute.number}. {selectedRoute.title}
            </h3>
            <p style={mutedTextStyle}>{selectedRoute.purpose}</p>
            <p style={{ ...mutedTextStyle, marginTop: 10 }}>
              <strong>Common triggers:</strong> {selectedRoute.examples}
            </p>

            <button type="button" disabled style={disabledButtonStyle}>
              Continue to Next Step →
            </button>
          </section>

          <section style={panelStyle}>
            <p style={eyebrowStyle}>Why this recommendation</p>

            <ReasonList
              title="Primary decision factors"
              reasons={primaryReasons}
              fallback="Current default favours governance first unless urgency or deadline risk is recorded."
            />

            <ReasonList
              title="Secondary route factors"
              reasons={secondaryReasons}
              fallback="No major secondary trigger recorded yet."
            />
          </section>

          <section style={panelStyle}>
            <p style={eyebrowStyle}>Supporting steps</p>

            {analysis.supportingAlerts.length > 0 ? (
              <ul style={alertListStyle}>
                {analysis.supportingAlerts.map((alert) => (
                  <li key={alert}>{alert}</li>
                ))}
              </ul>
            ) : (
              <p style={mutedTextStyle}>
                No major supporting readiness issue has been highlighted yet.
              </p>
            )}

            <div style={supportGridStyle}>
              {supportingStages.map((stage) => (
                <div key={stage.number} style={supportCardStyle}>
                  <strong>
                    {stage.number}. {stage.title}
                  </strong>
                  <p>{stage.text}</p>
                </div>
              ))}
            </div>
          </section>
        </aside>
      </section>
    </main>
  );
}

function Field({ label, note, children }) {
  return (
    <label style={fieldStyle}>
      <span style={fieldLabelStyle}>{label}</span>
      {note ? <small style={fieldNoteStyle}>{note}</small> : null}
      {children}
    </label>
  );
}

function TextInput({ value, onChange, placeholder }) {
  return (
    <input
      value={value}
      onChange={(event) => onChange(event.target.value)}
      placeholder={placeholder}
      style={inputStyle}
    />
  );
}

function SelectInput({ value, onChange, children }) {
  return (
    <select
      value={value}
      onChange={(event) => onChange(event.target.value)}
      style={inputStyle}
    >
      {children}
    </select>
  );
}

function TextArea({ value, onChange, placeholder }) {
  return (
    <textarea
      value={value}
      onChange={(event) => onChange(event.target.value)}
      placeholder={placeholder}
      rows={5}
      style={{
        ...inputStyle,
        minHeight: 118,
        lineHeight: 1.55,
        resize: "vertical",
      }}
    />
  );
}

function FormSection({ title, text, children }) {
  return (
    <section style={formSectionStyle}>
      <h3 style={formSectionTitleStyle}>{title}</h3>
      <p style={{ ...mutedTextStyle, marginBottom: 16 }}>{text}</p>
      {children}
    </section>
  );
}

function RouteChoice({ route, recommended, selected, onClick }) {
  return (
    <button
      type="button"
      onClick={onClick}
      style={routeChoiceStyle(selected, recommended)}
    >
      <span style={routeNumberStyle}>{route.number}</span>
      <span>
        <strong style={{ display: "block" }}>{route.title}</strong>
        <small style={routeMetaStyle}>
          {recommended ? "Recommended after Step 1" : "Secondary branch"}
        </small>
      </span>
    </button>
  );
}

function ReasonList({ title, reasons, fallback }) {
  return (
    <div style={{ marginTop: 12 }}>
      <strong style={{ color: "#0f172a" }}>{title}</strong>
      {reasons.length > 0 ? (
        <ul style={reasonListStyle}>
          {reasons.map((reason) => (
            <li key={reason}>{reason}</li>
          ))}
        </ul>
      ) : (
        <p style={{ ...mutedTextStyle, marginTop: 8 }}>{fallback}</p>
      )}
    </div>
  );
}

function WorkflowNode({ label, title, active }) {
  return (
    <div style={workflowNodeStyle(active)}>
      <span>{label}</span>
      <strong>{title}</strong>
    </div>
  );
}

function WorkflowArrow() {
  return <div style={workflowArrowStyle}>→</div>;
}

const pageStyle = {
  minHeight: "100vh",
  padding: 28,
  background:
    "radial-gradient(circle at top left, rgba(37, 99, 235, 0.10), transparent 34rem), linear-gradient(180deg, #f8fafc 0%, #eef2f7 100%)",
};

const heroStyle = {
  display: "grid",
  gridTemplateColumns: "minmax(0, 1fr) minmax(260px, 360px)",
  gap: 24,
  alignItems: "start",
  background: "#ffffff",
  border: "1px solid #dbe2ea",
  borderRadius: 24,
  padding: 30,
  marginBottom: 18,
  boxShadow: "0 18px 45px rgba(15, 23, 42, 0.08)",
};

const eyebrowStyle = {
  margin: "0 0 10px",
  color: "#2563eb",
  fontSize: 12,
  fontWeight: 900,
  letterSpacing: "0.13em",
  textTransform: "uppercase",
};

const titleStyle = {
  margin: 0,
  color: "#0f172a",
  fontSize: "clamp(2rem, 4vw, 3.25rem)",
  lineHeight: 1.04,
  letterSpacing: "-0.045em",
};

const heroTextStyle = {
  margin: "16px 0 0",
  maxWidth: 880,
  color: "#475569",
  fontSize: 17,
  lineHeight: 1.7,
};

const statusPanelStyle = {
  background: "#eff6ff",
  borderRadius: 20,
  padding: 18,
  color: "#1e3a8a",
};

const workflowMapStyle = {
  display: "grid",
  gridTemplateColumns: "1fr auto 1fr auto 1fr auto 1fr",
  gap: 10,
  alignItems: "center",
  marginBottom: 18,
};

function workflowNodeStyle(active) {
  return {
    minHeight: 74,
    display: "grid",
    alignContent: "center",
    gap: 4,
    border: active ? "2px solid #2563eb" : "1px solid #dbe2ea",
    borderRadius: 18,
    padding: 14,
    background: active ? "#eff6ff" : "#ffffff",
    color: "#0f172a",
    boxShadow: active ? "0 10px 24px rgba(37, 99, 235, 0.14)" : "none",
  };
}

const workflowArrowStyle = {
  color: "#64748b",
  fontWeight: 900,
  fontSize: 22,
};

const layoutStyle = {
  display: "grid",
  gridTemplateColumns: "minmax(0, 1fr) minmax(340px, 390px)",
  gap: 22,
  alignItems: "start",
};

const mainPanelStyle = {
  background: "#ffffff",
  border: "1px solid #dbe2ea",
  borderRadius: 24,
  padding: 22,
  boxShadow: "0 18px 45px rgba(15, 23, 42, 0.08)",
};

const panelStyle = {
  background: "#ffffff",
  border: "1px solid #dbe2ea",
  borderRadius: 22,
  padding: 18,
  boxShadow: "0 14px 34px rgba(15, 23, 42, 0.07)",
};

const recommendationStyle = {
  ...panelStyle,
  borderColor: "#93c5fd",
  background: "#eff6ff",
};

const sectionHeaderStyle = {
  display: "flex",
  justifyContent: "space-between",
  gap: 18,
  alignItems: "start",
  marginBottom: 18,
};

const h2Style = {
  margin: 0,
  color: "#0f172a",
  lineHeight: 1.2,
};

const mutedTextStyle = {
  margin: 0,
  color: "#475569",
  lineHeight: 1.6,
};

const progressCardStyle = {
  display: "grid",
  placeItems: "center",
  minWidth: 118,
  minHeight: 78,
  borderRadius: 18,
  background: "#0f172a",
  color: "#ffffff",
  fontWeight: 900,
};

const formSectionStyle = {
  border: "1px solid #e2e8f0",
  borderRadius: 20,
  padding: 18,
  background: "#f8fafc",
  marginTop: 16,
};

const formSectionTitleStyle = {
  margin: "0 0 6px",
  color: "#0f172a",
};

const formGridStyle = {
  display: "grid",
  gridTemplateColumns: "repeat(auto-fit, minmax(230px, 1fr))",
  gap: 16,
};

const fieldStyle = {
  display: "grid",
  gap: 8,
};

const fieldLabelStyle = {
  color: "#0f172a",
  fontWeight: 850,
  lineHeight: 1.25,
};

const fieldNoteStyle = {
  color: "#64748b",
  lineHeight: 1.45,
};

const inputStyle = {
  width: "100%",
  minHeight: 42,
  border: "1px solid #cbd5e1",
  borderRadius: 12,
  padding: "10px 12px",
  color: "#0f172a",
  background: "#ffffff",
};

const sideColumnStyle = {
  display: "grid",
  gap: 16,
  position: "sticky",
  top: 24,
};

const routeBadgeStyle = {
  width: 52,
  height: 52,
  display: "grid",
  placeItems: "center",
  borderRadius: 16,
  background: "#0f172a",
  color: "#ffffff",
  fontWeight: 950,
  fontSize: 20,
};

const routeNumberStyle = {
  width: 40,
  height: 40,
  display: "grid",
  placeItems: "center",
  borderRadius: 13,
  background: "#0f172a",
  color: "#ffffff",
  fontWeight: 950,
};

function routeChoiceStyle(selected, recommended) {
  return {
    width: "100%",
    display: "grid",
    gridTemplateColumns: "46px minmax(0, 1fr)",
    gap: 12,
    alignItems: "center",
    textAlign: "left",
    border: selected ? "2px solid #2563eb" : "1px solid #dbe2ea",
    borderRadius: 16,
    padding: 12,
    marginBottom: 10,
    background: recommended ? "#eff6ff" : "#ffffff",
    color: "#0f172a",
    cursor: "pointer",
  };
}

const routeMetaStyle = {
  display: "block",
  marginTop: 4,
  color: "#64748b",
  fontWeight: 800,
  lineHeight: 1.35,
};

const disabledButtonStyle = {
  width: "100%",
  marginTop: 16,
  border: 0,
  borderRadius: 14,
  padding: "12px 14px",
  background: "#e2e8f0",
  color: "#64748b",
  fontWeight: 900,
  cursor: "not-allowed",
};

const reasonListStyle = {
  margin: "8px 0 0",
  paddingLeft: 18,
  color: "#475569",
  lineHeight: 1.55,
};

const alertListStyle = {
  margin: 0,
  paddingLeft: 18,
  color: "#475569",
  lineHeight: 1.55,
};

const supportGridStyle = {
  display: "grid",
  gap: 10,
  marginTop: 14,
};

const supportCardStyle = {
  border: "1px solid #e2e8f0",
  borderRadius: 16,
  padding: 12,
  background: "#f8fafc",
  color: "#475569",
  lineHeight: 1.5,
};

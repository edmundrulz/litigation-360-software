import { useMemo, useState } from "react";
import ClientIntakeSectionCard from "./ClientIntakeSectionCard";
import ClientIntakeProposalPreview from "./ClientIntakeProposalPreview";

const initialIntake = {
  clientName: "",
  clientType: "",
  industry: "",
  matterType: "",
  urgency: "Normal",
  background: "",
  stakeholders: "",
  primaryObjective: "",
  shortTermGoals: "",
  longTermGoals: "",
  successCriteria: "",
  valueAtStake: "",
  riskMerits: "",
  scopeSummary: "",
  dependencies: "",
  documentsRequired: "",
  documentChecklistAgreements: "Missing",
  documentChecklistChronology: "Missing",
  documentChecklistCorrespondence: "Missing",
  documentChecklistPayments: "Missing",
  documentChecklistPleadings: "Not Applicable",
  documentChecklistPhotosReports: "Not Applicable",
  documentChecklistWitnesses: "Missing",
  documentChecklistAuthorityIdentity: "Missing",
  documentChecklistNotes: "",
  budgetRange: "",
  feeModel: "",
  consultationFee: "",
  professionalFeeEstimate: "",
  disbursementEstimate: "",
  approvalThreshold: "",
  feeComplexity: "Medium",
  feeAssumptions: "",
  feeEscalationTriggers: "",
  communicationPreference: "",
};

const sections = [
  "Client Background",
  "Stakeholders",
  "Needs & Outcomes",
  "Merits & Value",
  "Scope",
  "Risks & Documents",
  "Budget & Fees",
  "Proposal Preview",
];

export default function ClientIntakeDiscoveryPrototype() {
  const [activeSection, setActiveSection] = useState(0);
  const [intake, setIntake] = useState(initialIntake);

  const completionCount = useMemo(() => {
    return Object.values(intake).filter((value) => String(value).trim()).length;
  }, [intake]);

  const updateField = (field, value) => {
    setIntake((current) => ({
      ...current,
      [field]: value,
    }));
  };


  const renderDocumentChecklistField = (field, label, helperText) => (
    <label>
      {label}
      <select
        value={intake[field]}
        onChange={(event) => updateField(field, event.target.value)}
      >
        <option>Available</option>
        <option>Partial</option>
        <option>Missing</option>
        <option>Not Applicable</option>
      </select>
      <small>{helperText}</small>
    </label>
  );

  const nextSection = () => {
    setActiveSection((current) => Math.min(current + 1, sections.length - 1));
  };

  const previousSection = () => {
    setActiveSection((current) => Math.max(current - 1, 0));
  };

  return (
    <div className="client-intake-prototype">
      <header className="client-intake-hero">
        <div>
          <p className="eyebrow">Phase 14A Prototype</p>
          <h1>Client Intake & Discovery</h1>
          <p>
            Guided pre-client intake framework for capturing client background,
            objectives, scope, merits, risks, documents, fees, and proposal
            inputs before formal engagement.
          </p>
        </div>

        <div className="client-intake-status-card">
          <span>Prototype Mode</span>
          <strong>Frontend only</strong>
          <p>No backend save. No database write. No real client creation.</p>
        </div>
      </header>

      <nav className="client-intake-stepper" aria-label="Client intake sections">
        {sections.map((section, index) => (
          <button
            key={section}
            type="button"
            className={index === activeSection ? "active" : ""}
            onClick={() => setActiveSection(index)}
          >
            <span>{index + 1}</span>
            {section}
          </button>
        ))}
      </nav>

      <div className="client-intake-layout">
        <div className="client-intake-main">
          {activeSection === 0 && (
            <ClientIntakeSectionCard
              number="01"
              title="Client Background & Context"
              description="Capture identity, structure, industry, authority, and matter background."
            >
              <div className="client-intake-grid">
                <label>
                  Client / Entity Name
                  <input
                    value={intake.clientName}
                    onChange={(event) => updateField("clientName", event.target.value)}
                    placeholder="e.g. ABC Sdn Bhd / John Tan"
                  />
                </label>

                <label>
                  Client Type
                  <select
                    value={intake.clientType}
                    onChange={(event) => updateField("clientType", event.target.value)}
                  >
                    <option value="">Select type</option>
                    <option>Individual</option>
                    <option>Company</option>
                    <option>Partnership</option>
                    <option>Director / Shareholder</option>
                    <option>Employer</option>
                    <option>Employee</option>
                    <option>Property Owner / Tenant</option>
                    <option>Representative</option>
                  </select>
                </label>

                <label>
                  Industry / Sector
                  <input
                    value={intake.industry}
                    onChange={(event) => updateField("industry", event.target.value)}
                    placeholder="e.g. construction, retail, property, technology"
                  />
                </label>

                <label>
                  Matter Type
                  <input
                    value={intake.matterType}
                    onChange={(event) => updateField("matterType", event.target.value)}
                    placeholder="e.g. dispute, advisory, compliance, contract review"
                  />
                </label>

                <label>
                  Urgency
                  <select
                    value={intake.urgency}
                    onChange={(event) => updateField("urgency", event.target.value)}
                  >
                    <option>Low</option>
                    <option>Normal</option>
                    <option>High</option>
                    <option>Emergency</option>
                  </select>
                </label>
              </div>

              <label>
                Historical Background
                <textarea
                  value={intake.background}
                  onChange={(event) => updateField("background", event.target.value)}
                  placeholder="Summarize what happened, when it started, and why help is needed now."
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 1 && (
            <ClientIntakeSectionCard
              number="02"
              title="Stakeholders & Decision-Makers"
              description="Identify instructing parties, approvers, affected parties, witnesses, experts, and third parties."
            >
              <label>
                Stakeholders / Decision-Makers / Third Parties
                <textarea
                  value={intake.stakeholders}
                  onChange={(event) => updateField("stakeholders", event.target.value)}
                  placeholder="List names, roles, relationship to client, influence level, and approval authority."
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 2 && (
            <ClientIntakeSectionCard
              number="03"
              title="Needs, Wants & Desired Outcomes"
              description="Separate immediate needs, short-term goals, long-term outcomes, and success criteria."
            >
              <label>
                Primary Objective
                <input
                  value={intake.primaryObjective}
                  onChange={(event) => updateField("primaryObjective", event.target.value)}
                  placeholder="What does the client mainly want to achieve?"
                />
              </label>

              <div className="client-intake-grid">
                <label>
                  Short-Term Goals
                  <textarea
                    value={intake.shortTermGoals}
                    onChange={(event) => updateField("shortTermGoals", event.target.value)}
                    placeholder="What must be done in days or weeks?"
                  />
                </label>

                <label>
                  Long-Term Goals
                  <textarea
                    value={intake.longTermGoals}
                    onChange={(event) => updateField("longTermGoals", event.target.value)}
                    placeholder="What is the desired 6–12 month outcome?"
                  />
                </label>
              </div>

              <label>
                Success Criteria
                <textarea
                  value={intake.successCriteria}
                  onChange={(event) => updateField("successCriteria", event.target.value)}
                  placeholder="How will the client know the engagement succeeded?"
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 3 && (
            <ClientIntakeSectionCard
              number="04"
              title="Value, Merits & Realistic Outcome"
              description="Capture the value at stake, strength of the case/project, evidence position, and realistic outcome."
            >
              <label>
                Value At Stake
                <textarea
                  value={intake.valueAtStake}
                  onChange={(event) => updateField("valueAtStake", event.target.value)}
                  placeholder="Include financial, reputational, regulatory, strategic, relationship, and business continuity value."
                />
              </label>

              <label>
                Merits / Risk Notes
                <textarea
                  value={intake.riskMerits}
                  onChange={(event) => updateField("riskMerits", event.target.value)}
                  placeholder="Strong points, weak points, evidence gaps, best/realistic/worst outcomes."
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 4 && (
            <ClientIntakeSectionCard
              number="05"
              title="Scope of Work & Action Items"
              description="Map essential work, flexible work, and future-phase work."
            >
              <label>
                Preliminary Scope Summary
                <textarea
                  value={intake.scopeSummary}
                  onChange={(event) => updateField("scopeSummary", event.target.value)}
                  placeholder="Advice, drafting, negotiation, filing, representation, document review, proposal, report, etc."
                />
              </label>

              <label>
                Dependencies / Deadlines
                <textarea
                  value={intake.dependencies}
                  onChange={(event) => updateField("dependencies", event.target.value)}
                  placeholder="Prerequisites, sequential tasks, parallel workstreams, hard deadlines, approvals."
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 5 && (
            <ClientIntakeSectionCard
              number="06"
              title="Risks, Contingencies, Documents & Evidence"
              description="Identify blockers, fallback positions, required records, witnesses, and experts."
            >
              <label>
                Documents / Evidence Required
                <textarea
                  value={intake.documentsRequired}
                  onChange={(event) => updateField("documentsRequired", event.target.value)}
                  placeholder="Agreements, emails, WhatsApp, invoices, payment proof, photos, reports, court papers, expert input."
                />
              </label>

              <div className="client-intake-grid">
                {renderDocumentChecklistField(
                  "documentChecklistAgreements",
                  "Agreements / Contracts",
                  "Contracts, engagement records, purchase orders, tenancy documents, quotations, or signed terms."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistChronology",
                  "Chronology / Timeline",
                  "Key dates, event sequence, deadline timeline, limitation risk, and current procedural stage."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistCorrespondence",
                  "Correspondence",
                  "Emails, WhatsApp messages, letters, notices, meeting notes, and call records."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistPayments",
                  "Payment / Invoices / Receipts",
                  "Invoices, receipts, bank slips, proof of payment, statements of account, or ledgers."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistPleadings",
                  "Pleadings / Notices / Court Documents",
                  "Court papers, demand letters, statutory notices, tribunal forms, orders, or hearing notices."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistPhotosReports",
                  "Photos / Reports / Expert Evidence",
                  "Photos, inspection reports, technical findings, expert input, screenshots, or site records."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistWitnesses",
                  "Witness / Contact Details",
                  "Names, roles, phone/email details, and relevance of witnesses or supporting contacts."
                )}

                {renderDocumentChecklistField(
                  "documentChecklistAuthorityIdentity",
                  "Authority / Identity / Company Documents",
                  "Identity, company, representative authority, consent proof, or instruction authority documents."
                )}
              </div>

              <label>
                Document Checklist Notes / Client Responsibility
                <textarea
                  value={intake.documentChecklistNotes}
                  onChange={(event) => updateField("documentChecklistNotes", event.target.value)}
                  placeholder="Record what the client must still provide, by when, and any document-quality concerns."
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 6 && (
            <ClientIntakeSectionCard
              number="07"
              title="Budget, Fees & Engagement Expectations"
              description="Capture budget range, fee model preference, fee assumptions, approval thresholds, and escalation triggers."
            >
              <div className="client-intake-grid">
                <label>
                  Budget Range
                  <input
                    value={intake.budgetRange}
                    onChange={(event) => updateField("budgetRange", event.target.value)}
                    placeholder="e.g. RM2,000–RM5,000 / flexible / unknown"
                  />
                </label>

                <label>
                  Preferred Fee Model
                  <select
                    value={intake.feeModel}
                    onChange={(event) => updateField("feeModel", event.target.value)}
                  >
                    <option value="">Select fee model</option>
                    <option>Consultation fee</option>
                    <option>Hourly billing</option>
                    <option>Fixed fee</option>
                    <option>Retainer</option>
                    <option>Stage-based fee</option>
                    <option>Monthly advisory</option>
                    <option>Hybrid</option>
                    <option>Unknown / wants estimate first</option>
                  </select>
                </label>

                <label>
                  Complexity Rating
                  <select
                    value={intake.feeComplexity}
                    onChange={(event) => updateField("feeComplexity", event.target.value)}
                  >
                    <option>Low</option>
                    <option>Medium</option>
                    <option>High</option>
                    <option>Emergency / Expedited</option>
                  </select>
                </label>

                <label>
                  Consultation Fee Placeholder
                  <input
                    value={intake.consultationFee}
                    onChange={(event) => updateField("consultationFee", event.target.value)}
                    placeholder="e.g. RM300 / waived / to be confirmed"
                  />
                </label>

                <label>
                  Professional Work Fee Estimate
                  <input
                    value={intake.professionalFeeEstimate}
                    onChange={(event) =>
                      updateField("professionalFeeEstimate", event.target.value)
                    }
                    placeholder="e.g. RM3,000–RM8,000"
                  />
                </label>

                <label>
                  Disbursement Estimate
                  <input
                    value={intake.disbursementEstimate}
                    onChange={(event) =>
                      updateField("disbursementEstimate", event.target.value)
                    }
                    placeholder="e.g. filing, searches, travel, translation"
                  />
                </label>

                <label>
                  Client Approval Threshold
                  <input
                    value={intake.approvalThreshold}
                    onChange={(event) =>
                      updateField("approvalThreshold", event.target.value)
                    }
                    placeholder="e.g. seek approval above RM1,000"
                  />
                </label>

                <label>
                  Communication Preference
                  <input
                    value={intake.communicationPreference}
                    onChange={(event) =>
                      updateField("communicationPreference", event.target.value)
                    }
                    placeholder="e.g. WhatsApp for quick updates, email for formal advice"
                  />
                </label>
              </div>

              <label>
                Fee Assumptions
                <textarea
                  value={intake.feeAssumptions}
                  onChange={(event) => updateField("feeAssumptions", event.target.value)}
                  placeholder="What assumptions is the estimate based on?"
                />
              </label>

              <label>
                Fee Escalation Triggers
                <textarea
                  value={intake.feeEscalationTriggers}
                  onChange={(event) =>
                    updateField("feeEscalationTriggers", event.target.value)
                  }
                  placeholder="Scope expansion, urgency, new parties, extra documents, court/tribunal action, experts, revisions."
                />
              </label>
            </ClientIntakeSectionCard>
          )}

          {activeSection === 7 && (
            <ClientIntakeSectionCard
              number="08"
              title="Proposal Preview"
              description="Review the mock engagement proposal snapshot generated from local state."
            >
              <ClientIntakeProposalPreview intake={intake} />
            </ClientIntakeSectionCard>
          )}

          <div className="client-intake-actions">
            <button type="button" onClick={previousSection} disabled={activeSection === 0}>
              Previous
            </button>
            <span>
              Section {activeSection + 1} of {sections.length} · {completionCount} fields captured
            </span>
            <button
              type="button"
              onClick={nextSection}
              disabled={activeSection === sections.length - 1}
            >
              Next
            </button>
          </div>
        </div>

        <ClientIntakeProposalPreview intake={intake} />
      </div>
    </div>
  );
}

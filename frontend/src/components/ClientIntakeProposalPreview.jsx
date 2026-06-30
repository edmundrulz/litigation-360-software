const fallback = "Not captured yet";

function hasValue(value) {
  return String(value || "").trim().length > 0;
}

function toPreviewList(value, fallbackItems = []) {
  if (!hasValue(value)) {
    return fallbackItems;
  }

  return String(value)
    .split(/\n|;|,/)
    .map((item) => item.trim())
    .filter(Boolean)
    .slice(0, 6);
}

function PreviewList({ items }) {
  if (!items.length) {
    return <p className="proposal-preview-muted">Not captured yet</p>;
  }

  return (
    <ul className="proposal-preview-list">
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  );
}

function PreviewBlock({ title, children }) {
  return (
    <section className="proposal-preview-block">
      <h4>{title}</h4>
      {children}
    </section>
  );
}


function buildDocumentChecklist(intake) {
  return [
    ["Agreements / Contracts", intake.documentChecklistAgreements || "Missing"],
    ["Chronology / Timeline", intake.documentChecklistChronology || "Missing"],
    ["Correspondence", intake.documentChecklistCorrespondence || "Missing"],
    ["Payment / Invoices / Receipts", intake.documentChecklistPayments || "Missing"],
    ["Pleadings / Notices / Court Documents", intake.documentChecklistPleadings || "Not Applicable"],
    ["Photos / Reports / Expert Evidence", intake.documentChecklistPhotosReports || "Not Applicable"],
    ["Witness / Contact Details", intake.documentChecklistWitnesses || "Missing"],
    ["Authority / Identity / Company Documents", intake.documentChecklistAuthorityIdentity || "Missing"],
  ].map(([label, status]) => ({ label, status }));
}

function DocumentChecklistPreview({ checklist, notes }) {
  const activeItems = checklist.filter((item) => item.status !== "Not Applicable");
  const availableItems = checklist.filter((item) => item.status === "Available");
  const partialItems = checklist.filter((item) => item.status === "Partial");
  const missingItems = checklist.filter((item) => item.status === "Missing");
  const readinessPercent = activeItems.length
    ? Math.round((availableItems.length / activeItems.length) * 100)
    : 100;

  const pendingItems = [...missingItems, ...partialItems];

  return (
    <div style={{ display: "grid", gap: "14px", marginTop: "14px" }}>
      <div className="fee-preview-panel">
        <div>
          <span>Checklist Readiness</span>
          <strong>{readinessPercent}%</strong>
        </div>
        <div>
          <span>Available</span>
          <strong>{availableItems.length}</strong>
        </div>
        <div>
          <span>Partial</span>
          <strong>{partialItems.length}</strong>
        </div>
        <div>
          <span>Missing</span>
          <strong>{missingItems.length}</strong>
        </div>
      </div>

      <div style={{ display: "grid", gap: "8px" }}>
        {checklist.map((item) => (
          <div
            key={item.label}
            style={{
              display: "grid",
              gridTemplateColumns: "minmax(0, 1fr) auto",
              gap: "10px",
              alignItems: "center",
              padding: "10px 12px",
              border: "1px solid rgba(148, 163, 184, 0.28)",
              borderRadius: "12px",
            }}
          >
            <strong>{item.label}</strong>
            <span>{item.status}</span>
          </div>
        ))}
      </div>

      <div className="fee-assumption-box">
        <h5>Missing / partial document categories</h5>
        <PreviewList items={pendingItems.map((item) => item.label + " — " + item.status)} />
      </div>

      <div className="fee-assumption-box">
        <h5>Client responsibility notes</h5>
        <p>
          {notes ||
            "Client should provide all available documents, disclose missing items early, and confirm whether unavailable categories are not applicable."}
        </p>
      </div>
    </div>
  );
}

export default function ClientIntakeProposalPreview({ intake }) {
  const requiredFields = [
    ["Client / Entity", intake.clientName],
    ["Matter Type", intake.matterType],
    ["Primary Objective", intake.primaryObjective],
    ["Scope Summary", intake.scopeSummary],
    ["Risk / Merits", intake.riskMerits],
    ["Documents Required", intake.documentsRequired],
    ["Budget Range", intake.budgetRange],
    ["Fee Model", intake.feeModel],
    ["Professional Fee Estimate", intake.professionalFeeEstimate],
    ["Approval Threshold", intake.approvalThreshold],
  ];

  const completedRequired = requiredFields.filter(([, value]) => hasValue(value));
  const readinessPercent = Math.round(
    (completedRequired.length / requiredFields.length) * 100
  );

  const scopeItems = toPreviewList(intake.scopeSummary, [
    "Initial consultation and fact review",
    "Document and evidence review",
    "Preliminary advice / strategy recommendation",
  ]);

  const documentItems = toPreviewList(intake.documentsRequired, [
    "Agreements / correspondence",
    "Payment records / invoices",
    "Chronology and supporting evidence",
  ]);

  const documentChecklist = buildDocumentChecklist(intake);
  const documentChecklistPendingCount = documentChecklist.filter(
    (item) => item.status === "Missing" || item.status === "Partial"
  ).length;

  const riskItems = toPreviewList(intake.riskMerits, [
    "Merits and risk assessment pending fuller documents",
  ]);

  const escalationItems = toPreviewList(intake.feeEscalationTriggers, [
    "Scope expansion",
    "Urgency or emergency timeline",
    "New parties, documents, or issues",
    "Court, tribunal, regulatory, or expert involvement",
  ]);

  const nextSteps = [
    "Confirm conflict check can proceed",
    "Provide missing or partial document checklist items",
    "Review proposed scope and exclusions",
    "Confirm fee model and budget threshold",
  ];

  return (
    <aside className="client-intake-preview proposal-preview-enhanced">
      <div className="client-intake-preview-header">
        <p className="eyebrow">Mock Proposal Preview</p>
        <h2>Engagement Proposal Snapshot</h2>
        <p>
          Frontend-only preview generated from local prototype state. Nothing is
          saved, submitted, emailed, exported, billed, invoiced, or persisted.
        </p>
      </div>

      <div className="proposal-readiness-card">
        <div>
          <span>Proposal readiness</span>
          <strong>{readinessPercent}%</strong>
        </div>
        <div className="proposal-readiness-bar" aria-hidden="true">
          <i style={{ width: `${readinessPercent}%` }} />
        </div>
        <p>
          {completedRequired.length} of {requiredFields.length} core proposal
          inputs captured.
        </p>
      </div>

      <div className="client-intake-preview-grid">
        <div>
          <span>Client / Entity</span>
          <strong>{intake.clientName || fallback}</strong>
        </div>

        <div>
          <span>Client Type</span>
          <strong>{intake.clientType || fallback}</strong>
        </div>

        <div>
          <span>Matter Type</span>
          <strong>{intake.matterType || fallback}</strong>
        </div>

        <div>
          <span>Urgency</span>
          <strong>{intake.urgency || fallback}</strong>
        </div>

        <div>
          <span>Budget Range</span>
          <strong>{intake.budgetRange || fallback}</strong>
        </div>

        <div>
          <span>Preferred Fee Model</span>
          <strong>{intake.feeModel || fallback}</strong>
        </div>
      </div>

      <PreviewBlock title="1. Client and Matter Summary">
        <p>
          <strong>{intake.clientName || "The prospective client"}</strong>
          {intake.industry ? ` operates in ${intake.industry}` : ""}. The matter
          is currently identified as{" "}
          <strong>{intake.matterType || "an unclassified matter"}</strong> with{" "}
          <strong>{intake.urgency || "normal"}</strong> urgency.
        </p>
        <p>{intake.background || fallback}</p>
      </PreviewBlock>

      <PreviewBlock title="2. Objectives and Success Criteria">
        <p>
          <strong>Primary objective:</strong>{" "}
          {intake.primaryObjective || fallback}
        </p>
        <p>
          <strong>Short-term goals:</strong>{" "}
          {intake.shortTermGoals || fallback}
        </p>
        <p>
          <strong>Long-term outcome:</strong>{" "}
          {intake.longTermGoals || fallback}
        </p>
        <p>
          <strong>Success criteria:</strong>{" "}
          {intake.successCriteria || fallback}
        </p>
      </PreviewBlock>

      <PreviewBlock title="3. Recommended Scope Preview">
        <PreviewList items={scopeItems} />
      </PreviewBlock>

      <PreviewBlock title="4. Merits, Value, and Risk Summary">
        <p>
          <strong>Value at stake:</strong> {intake.valueAtStake || fallback}
        </p>
        <PreviewList items={riskItems} />
      </PreviewBlock>

      <PreviewBlock title="5. Documents and Evidence Required">
        <PreviewList items={documentItems} />

        <DocumentChecklistPreview
          checklist={documentChecklist}
          notes={intake.documentChecklistNotes}
        />

        <p className="proposal-preview-muted">
          Draft Engagement Preview support: {documentChecklistPendingCount
            ? "Documents are not yet complete. Missing or partial categories should be resolved or expressly marked not applicable before formal engagement approval."
            : "Document checklist is ready for preliminary proposal review, subject to conflict, authority, scope, and fee confirmation."}
        </p>
      </PreviewBlock>

      <PreviewBlock title="6. Fee Preview">
        <div className="fee-preview-panel">
          <div>
            <span>Complexity</span>
            <strong>{intake.feeComplexity || fallback}</strong>
          </div>
          <div>
            <span>Consultation Fee</span>
            <strong>{intake.consultationFee || fallback}</strong>
          </div>
          <div>
            <span>Professional Work Fee</span>
            <strong>{intake.professionalFeeEstimate || fallback}</strong>
          </div>
          <div>
            <span>Disbursements</span>
            <strong>{intake.disbursementEstimate || fallback}</strong>
          </div>
          <div>
            <span>Approval Threshold</span>
            <strong>{intake.approvalThreshold || fallback}</strong>
          </div>
          <div>
            <span>Fee Model</span>
            <strong>{intake.feeModel || fallback}</strong>
          </div>
        </div>

        <div className="fee-assumption-box">
          <h5>Fee assumptions</h5>
          <p>{intake.feeAssumptions || fallback}</p>
        </div>

        <div className="fee-assumption-box">
          <h5>Fee escalation triggers</h5>
          <PreviewList items={escalationItems} />
        </div>
      </PreviewBlock>

      <PreviewBlock title="7. Dependencies and Timing">
        <p>{intake.dependencies || fallback}</p>
      </PreviewBlock>

      <PreviewBlock title="8. Client Responsibilities">
        <PreviewList
          items={[
            "Provide complete and accurate information",
            "Disclose helpful and harmful facts",
            "Provide requested documents by deadline",
            "Approve scope, fees, and next steps before formal work starts",
          ]}
        />
      </PreviewBlock>

      <PreviewBlock title="9. Recommended Next Steps">
        <PreviewList items={nextSteps} />
      </PreviewBlock>

      <div className="proposal-preview-warning">
        <strong>Prototype limitation:</strong> This is not a formal engagement
        proposal, fee quote, invoice, payment request, PDF export, legal advice,
        or client record. It is a frontend-only planning preview.
      </div>
    </aside>
  );
}

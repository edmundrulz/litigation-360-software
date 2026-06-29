export default function ClientIntakeProposalPreview({ intake }) {
  const fallback = "Not captured yet";

  return (
    <aside className="client-intake-preview">
      <div className="client-intake-preview-header">
        <p className="eyebrow">Mock Proposal Preview</p>
        <h2>Engagement Scope Snapshot</h2>
        <p>
          This preview is generated from local prototype state only. Nothing is
          saved to the backend.
        </p>
      </div>

      <div className="client-intake-preview-grid">
        <div>
          <span>Client / Entity</span>
          <strong>{intake.clientName || fallback}</strong>
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
          <span>Primary Objective</span>
          <strong>{intake.primaryObjective || fallback}</strong>
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

      <div className="client-intake-preview-block">
        <h4>Preliminary Scope</h4>
        <p>{intake.scopeSummary || fallback}</p>
      </div>

      <div className="client-intake-preview-block">
        <h4>Risk / Merits Notes</h4>
        <p>{intake.riskMerits || fallback}</p>
      </div>

      <div className="client-intake-preview-block">
        <h4>Documents / Evidence Required</h4>
        <p>{intake.documentsRequired || fallback}</p>
      </div>
    </aside>
  );
}

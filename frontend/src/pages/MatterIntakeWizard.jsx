import React, { useState } from "react";

const API_URL = "http://localhost:5000/api";

const steps = [
  "Client Details",
  "Case / Matter Details",
  "Deadline Details",
  "Document Details",
  "Review",
  "Save & Submit Details"
];

export default function MatterIntakeWizard() {
  const [step, setStep] = useState(1);
  const [draftGuid, setDraftGuid] = useState(null);
  const [message, setMessage] = useState("");

  const [clientData, setClientData] = useState({
    full_name: "",
    email: "",
    phone: "",
    address: ""
  });

  const [caseData, setCaseData] = useState({
    case_number: "",
    title: "",
    status: "Active",
    description: "",
    opened_date: ""
  });

  const [deadlineData, setDeadlineData] = useState({
    title: "",
    deadline_date: "",
    reminder_days: 7,
    notes: ""
  });

  const [documentData, setDocumentData] = useState({
    file_name: "",
    file_path: "",
    document_type: "General"
  });

  async function ensureDraft() {
    if (draftGuid) return draftGuid;

    const res = await fetch(`${API_URL}/intake/draft`, { method: "POST" });
    const draft = await res.json();

    setDraftGuid(draft.draft_guid);
    return draft.draft_guid;
  }

  function getPayload() {
    if (step === 1) return clientData;
    if (step === 2) return caseData;
    if (step === 3) return deadlineData;
    if (step === 4) return documentData;
    if (step === 5) return { reviewed: true };
    return {};
  }

  async function saveCurrentStep() {
    const guid = await ensureDraft();

    const res = await fetch(`${API_URL}/intake/draft/${guid}/step/${step}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(getPayload())
    });

    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      setMessage(err.error || "Failed to save this step");
      return false;
    }

    setMessage("Saved");
    return true;
  }

  async function nextStep() {
    const ok = await saveCurrentStep();
    if (ok && step < 6) setStep(step + 1);
  }

  async function submitWizard() {
    const ok = await saveCurrentStep();
    if (!ok) return;

    const guid = await ensureDraft();

    const res = await fetch(`${API_URL}/intake/draft/${guid}/submit`, {
      method: "POST"
    });

    const data = await res.json();

    if (!res.ok) {
      setMessage(data.error || "Submit failed");
      return;
    }

    setMessage("YES - Submitted successfully. Client, case/matter, deadline and document created.");
  }

  function inputStyle() {
    return {
      display: "block",
      width: "100%",
      padding: "10px",
      marginBottom: "10px"
    };
  }

  return (
    <div style={{ padding: 24 }}>
      <h1>New Matter Intake Conveyor</h1>

      <div style={{ display: "flex", gap: 10, flexWrap: "wrap", marginBottom: 24 }}>
        {steps.map((label, index) => (
          <div
            key={label}
            onClick={() => index + 1 < step && setStep(index + 1)}
            style={{
              padding: "10px 14px",
              borderRadius: 8,
              border: "1px solid #ccc",
              cursor: index + 1 < step ? "pointer" : "default",
              background: index + 1 === step ? "#e8efff" : index + 1 < step ? "#e8ffe8" : "#f5f5f5",
              fontWeight: index + 1 === step ? "bold" : "normal"
            }}
          >
            {index + 1 === step ? "▶ " : index + 1 < step ? "✓ " : ""}
            {index + 1}. {label}
          </div>
        ))}
      </div>

      <div style={{ border: "1px solid #ddd", borderRadius: 12, padding: 24, minHeight: 330 }}>
        {step === 1 && (
          <>
            <h2>▶ 1. Client Details</h2>
            <input style={inputStyle()} placeholder="Full Name" value={clientData.full_name} onChange={e => setClientData({ ...clientData, full_name: e.target.value })} />
            <input style={inputStyle()} placeholder="Email" value={clientData.email} onChange={e => setClientData({ ...clientData, email: e.target.value })} />
            <input style={inputStyle()} placeholder="Phone" value={clientData.phone} onChange={e => setClientData({ ...clientData, phone: e.target.value })} />
            <input style={inputStyle()} placeholder="Address" value={clientData.address} onChange={e => setClientData({ ...clientData, address: e.target.value })} />
          </>
        )}

        {step === 2 && (
          <>
            <h2>▶ 2. Case / Matter Details</h2>
            <input style={inputStyle()} placeholder="Case Number" value={caseData.case_number} onChange={e => setCaseData({ ...caseData, case_number: e.target.value })} />
            <input style={inputStyle()} placeholder="Matter / Case Title" value={caseData.title} onChange={e => setCaseData({ ...caseData, title: e.target.value })} />
            <input style={inputStyle()} placeholder="Status" value={caseData.status} onChange={e => setCaseData({ ...caseData, status: e.target.value })} />
            <input style={inputStyle()} placeholder="Opened Date YYYY-MM-DD" value={caseData.opened_date} onChange={e => setCaseData({ ...caseData, opened_date: e.target.value })} />
            <textarea style={inputStyle()} placeholder="Description" value={caseData.description} onChange={e => setCaseData({ ...caseData, description: e.target.value })} />
          </>
        )}

        {step === 3 && (
          <>
            <h2>▶ 3. Deadline Details</h2>
            <input style={inputStyle()} placeholder="Deadline Title" value={deadlineData.title} onChange={e => setDeadlineData({ ...deadlineData, title: e.target.value })} />
            <input style={inputStyle()} placeholder="Deadline Date YYYY-MM-DD" value={deadlineData.deadline_date} onChange={e => setDeadlineData({ ...deadlineData, deadline_date: e.target.value })} />
            <input style={inputStyle()} placeholder="Reminder Days" value={deadlineData.reminder_days} onChange={e => setDeadlineData({ ...deadlineData, reminder_days: e.target.value })} />
            <textarea style={inputStyle()} placeholder="Notes" value={deadlineData.notes} onChange={e => setDeadlineData({ ...deadlineData, notes: e.target.value })} />
          </>
        )}

        {step === 4 && (
          <>
            <h2>▶ 4. Document Details</h2>
            <input style={inputStyle()} placeholder="Document Name / File Name" value={documentData.file_name} onChange={e => setDocumentData({ ...documentData, file_name: e.target.value })} />
            <input style={inputStyle()} placeholder="File Path / Location" value={documentData.file_path} onChange={e => setDocumentData({ ...documentData, file_path: e.target.value })} />
            <input style={inputStyle()} placeholder="Document Type" value={documentData.document_type} onChange={e => setDocumentData({ ...documentData, document_type: e.target.value })} />
          </>
        )}

        {step === 5 && (
          <>
            <h2>▶ 5. Review</h2>
            <p>Review all details before final save.</p>
            <pre>{JSON.stringify({ clientData, caseData, deadlineData, documentData }, null, 2)}</pre>
          </>
        )}

        {step === 6 && (
          <>
            <h2>▶ 6. Save & Submit Details?</h2>
            <p>Choose one:</p>
            <button onClick={submitWizard}>YES - Save & Submit</button>
            <button onClick={() => setMessage("NO - Submission cancelled. Nothing submitted.")}>NO - Do Not Submit</button>
            <button onClick={() => setStep(1)}>CHANGE / AMEND / EDIT</button>
          </>
        )}
      </div>

      <div style={{ display: "flex", justifyContent: "space-between", marginTop: 24 }}>
        <button disabled={step === 1} onClick={() => setStep(step - 1)}>
          ← Previous
        </button>

        {step < 6 && (
          <button onClick={nextStep}>
            Save & Next →
          </button>
        )}
      </div>

      <p style={{ marginTop: 16, fontWeight: "bold" }}>{message}</p>
    </div>
  );
}

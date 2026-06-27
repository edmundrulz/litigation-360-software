import { useMemo, useState } from "react";
import { submitSupportRequest } from "../mockSupportApi";

const CATEGORIES = [
  "Bug / Defect",
  "User Query",
  "Feature Request",
  "Data Issue",
  "UI / UX Feedback",
  "Access / Permission Question",
  "Other",
];

const PRIORITIES = ["Low", "Normal", "High", "Urgent"];

function makeReferenceId() {
  return `L360-${Date.now().toString().slice(-6)}`;
}

function validateForm(form, attachments) {
  const errors = [];

  if (!form.category) errors.push("Category is required.");
  if (!form.priority) errors.push("Priority is required.");
  if (form.subject.trim().length < 5) errors.push("Subject must be at least 5 characters.");
  if (form.description.trim().length < 20) errors.push("Description must be at least 20 characters.");
  if (form.contact.trim() && !form.contact.includes("@")) {
    errors.push("Contact email should include @ if provided.");
  }

  const totalSize = attachments.reduce((sum, file) => sum + file.size, 0);
  const maxSize = 8 * 1024 * 1024;

  if (attachments.length > 5) errors.push("Maximum 5 attachments allowed.");
  if (totalSize > maxSize) errors.push("Total attachment size must stay below 8 MB.");

  return errors;
}

function formatBytes(bytes) {
  if (!bytes) return "0 B";
  const units = ["B", "KB", "MB"];
  let value = bytes;
  let unitIndex = 0;

  while (value >= 1024 && unitIndex < units.length - 1) {
    value = value / 1024;
    unitIndex += 1;
  }

  return `${value.toFixed(unitIndex === 0 ? 0 : 1)} ${units[unitIndex]}`;
}

export function SupportRequestPanel() {
  const [form, setForm] = useState({
    category: "User Query",
    priority: "Normal",
    subject: "",
    description: "",
    contact: "",
    includeDiagnostics: true,
  });

  const [attachments, setAttachments] = useState([]);
  const [errors, setErrors] = useState([]);
  const [ticket, setTicket] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  const attachmentSummary = useMemo(() => {
    const totalSize = attachments.reduce((sum, file) => sum + file.size, 0);
    return `${attachments.length}/5 files · ${formatBytes(totalSize)} / 8 MB`;
  }, [attachments]);

  function updateField(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
    setErrors([]);
  }

  function handleFiles(event) {
    const incoming = Array.from(event.target.files || []);
    const merged = [...attachments, ...incoming].slice(0, 5);
    setAttachments(merged);
    setErrors([]);
    event.target.value = "";
  }

  function removeAttachment(index) {
    setAttachments((current) => current.filter((_, itemIndex) => itemIndex !== index));
  }

  async function handleSubmit(event) {
    event.preventDefault();

    const validationErrors = validateForm(form, attachments);
    if (validationErrors.length > 0) {
      setErrors(validationErrors);
      return;
    }

    setSubmitting(true);
    setTicket(null);

    try {
      const referenceId = makeReferenceId();
      const response = await submitSupportRequest({
        ...form,
        referenceId,
        attachments: attachments.map((file) => ({
          name: file.name,
          size: file.size,
          type: file.type || "unknown",
        })),
      });

      setTicket({
        referenceId,
        status: response.status || "Mock Submitted",
        createdAt: new Date().toLocaleString(),
      });
    } catch {
      setErrors(["Mock support submission failed. Please retry."]);
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Submit Query / Request</h2>
          <p>Frontend-only support request form for feedback, issues, and future ticket workflows.</p>
        </div>
      </div>

      {ticket ? (
        <div className="mp-success">
          <strong>Mock request captured</strong>
          <span>Reference: {ticket.referenceId}</span>
          <span>Status: {ticket.status}</span>
          <span>Created: {ticket.createdAt}</span>
          <span>No backend ticket was created in this phase.</span>
        </div>
      ) : null}

      {errors.length > 0 ? (
        <div className="mp-error-box" role="alert">
          <strong>Check the form</strong>
          <ul>
            {errors.map((error) => (
              <li key={error}>{error}</li>
            ))}
          </ul>
        </div>
      ) : null}

      <form className="mp-support-form" onSubmit={handleSubmit}>
        <div className="mp-form-grid">
          <label className="mp-field">
            <span>Category</span>
            <select value={form.category} onChange={(event) => updateField("category", event.target.value)}>
              {CATEGORIES.map((category) => (
                <option key={category}>{category}</option>
              ))}
            </select>
          </label>

          <label className="mp-field">
            <span>Priority</span>
            <select value={form.priority} onChange={(event) => updateField("priority", event.target.value)}>
              {PRIORITIES.map((priority) => (
                <option key={priority}>{priority}</option>
              ))}
            </select>
          </label>
        </div>

        <label className="mp-field">
          <span>Subject</span>
          <input
            value={form.subject}
            onChange={(event) => updateField("subject", event.target.value)}
            placeholder="Short summary of the issue or request"
          />
        </label>

        <label className="mp-field">
          <span>Description</span>
          <textarea
            value={form.description}
            onChange={(event) => updateField("description", event.target.value)}
            rows={6}
            placeholder="Describe what happened, what you expected, and any steps to reproduce."
          />
        </label>

        <label className="mp-field">
          <span>Contact Email Optional</span>
          <input
            value={form.contact}
            onChange={(event) => updateField("contact", event.target.value)}
            placeholder="name@example.com"
          />
        </label>

        <label className="mp-checkbox">
          <input
            type="checkbox"
            checked={form.includeDiagnostics}
            onChange={(event) => updateField("includeDiagnostics", event.target.checked)}
          />
          <span>
            Include frontend diagnostics summary. No backend, database, auth, RBAC, or server data is collected.
          </span>
        </label>

        <label className="mp-file-drop">
          <strong>Attachments</strong>
          <small>{attachmentSummary}</small>
          <input type="file" multiple onChange={handleFiles} />
        </label>

        {attachments.length > 0 ? (
          <ul className="mp-attachment-list">
            {attachments.map((file, index) => (
              <li key={`${file.name}-${index}`}>
                <span>
                  {file.name} · {formatBytes(file.size)}
                </span>
                <button type="button" onClick={() => removeAttachment(index)}>
                  Remove
                </button>
              </li>
            ))}
          </ul>
        ) : null}

        <button className="mp-primary-button" type="submit" disabled={submitting}>
          {submitting ? "Submitting Mock Request..." : "Submit Mock Request"}
        </button>
      </form>
    </section>
  );
}

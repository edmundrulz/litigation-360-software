import { useMemo, useState } from "react";
import {
  redactSensitiveLogText,
  submitSupportRequest,
  validateSupportAttachment,
} from "../mockSupportApi";

const ISSUE_TYPES = [
  { value: "bug", label: "Bug Report" },
  { value: "feature", label: "Feature Request" },
  { value: "general", label: "General Inquiry" },
  { value: "performance", label: "Performance Issue" },
  { value: "uiux", label: "UI/UX Feedback" },
];

export function SupportRequestPanel() {
  const [form, setForm] = useState({
    issueType: "bug",
    title: "",
    description: "",
    logs: "",
    contact: "",
    autoCaptureLogs: true,
  });

  const [attachments, setAttachments] = useState([]);
  const [error, setError] = useState("");
  const [ticket, setTicket] = useState(null);
  const [submitting, setSubmitting] = useState(false);

  const redactedLogs = useMemo(
    () => redactSensitiveLogText(form.logs),
    [form.logs]
  );

  function updateField(field, value) {
    setForm((current) => ({ ...current, [field]: value }));
    setError("");
  }

  function addFiles(fileList) {
    const incoming = Array.from(fileList || []);
    const next = [];

    for (const file of incoming) {
      const validation = validateSupportAttachment(file);
      if (!validation.ok) {
        setError(validation.message);
        return;
      }
      next.push(file);
    }

    setAttachments((current) => [...current, ...next].slice(0, 5));
  }

  function handlePaste(event) {
    const files = [];
    const items = Array.from(event.clipboardData?.items || []);

    items.forEach((item) => {
      if (item.kind === "file") {
        const file = item.getAsFile();
        if (file) files.push(file);
      }
    });

    if (files.length > 0) {
      addFiles(files);
    }
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setError("");
    setTicket(null);

    if (!form.title.trim()) {
      setError("Please enter a short title.");
      return;
    }

    if (!form.description.trim()) {
      setError("Please describe the issue or request.");
      return;
    }

    setSubmitting(true);

    try {
      const response = await submitSupportRequest({
        ...form,
        logs: redactedLogs,
        attachments,
      });

      setTicket(response);
      setForm({
        issueType: "bug",
        title: "",
        description: "",
        logs: "",
        contact: "",
        autoCaptureLogs: true,
      });
      setAttachments([]);
    } catch (requestError) {
      setError("Submission failed. Please try again.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <section className="mp-panel" aria-labelledby="mp-support-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-support-title">Submit Query / Request</h2>
          <p>Send bugs, feature requests, screenshots, logs, or UI feedback.</p>
        </div>
      </div>

      <form className="mp-support-form" onSubmit={handleSubmit} onPaste={handlePaste}>
        <label className="mp-field">
          <span>Issue Type</span>
          <select
            value={form.issueType}
            onChange={(event) => updateField("issueType", event.target.value)}
          >
            {ISSUE_TYPES.map((item) => (
              <option key={item.value} value={item.value}>
                {item.label}
              </option>
            ))}
          </select>
        </label>

        <label className="mp-field">
          <span>Title</span>
          <input
            value={form.title}
            onChange={(event) => updateField("title", event.target.value)}
            placeholder="Short summary"
          />
        </label>

        <label className="mp-field">
          <span>Description</span>
          <textarea
            value={form.description}
            onChange={(event) => updateField("description", event.target.value)}
            placeholder="Explain what happened, what you expected, and steps to reproduce."
            rows={5}
          />
        </label>

        <label className="mp-checkbox">
          <input
            type="checkbox"
            checked={form.autoCaptureLogs}
            onChange={(event) =>
              updateField("autoCaptureLogs", event.target.checked)
            }
          />
          <span>Include automatically captured error context where available</span>
        </label>

        <label className="mp-field">
          <span>Error Messages / Logs</span>
          <textarea
            value={form.logs}
            onChange={(event) => updateField("logs", event.target.value)}
            placeholder="Paste crash report, console error, or logs. Sensitive tokens are redacted before mock submission."
            rows={4}
          />
        </label>

        <label className="mp-field">
          <span>Optional Contact</span>
          <input
            value={form.contact}
            onChange={(event) => updateField("contact", event.target.value)}
            placeholder="Email or phone, if follow-up is needed"
          />
        </label>

        <label className="mp-file-drop">
          <input
            type="file"
            multiple
            accept="image/png,image/jpeg,image/webp,text/plain,application/json"
            onChange={(event) => addFiles(event.target.files)}
          />
          <span>Attach screenshot / log file, or paste screenshot directly here</span>
          <small>PNG, JPG, WEBP, TXT, JSON. Max 5MB each. Max 5 files.</small>
        </label>

        {attachments.length > 0 ? (
          <ul className="mp-attachment-list" aria-label="Attached files">
            {attachments.map((file, index) => (
              <li key={`${file.name}-${index}`}>
                <span>{file.name}</span>
                <button
                  type="button"
                  onClick={() =>
                    setAttachments((current) =>
                      current.filter((_, itemIndex) => itemIndex !== index)
                    )
                  }
                >
                  Remove
                </button>
              </li>
            ))}
          </ul>
        ) : null}

        {error ? (
          <p className="mp-error" role="alert">
            {error}
          </p>
        ) : null}

        {ticket ? (
          <div className="mp-success" role="status" aria-live="polite">
            <strong>Request submitted.</strong>
            <span>Ticket reference: {ticket.ticketId}</span>
          </div>
        ) : null}

        <button className="mp-primary-button" type="submit" disabled={submitting}>
          {submitting ? "Submitting..." : "Submit Request"}
        </button>
      </form>
    </section>
  );
}

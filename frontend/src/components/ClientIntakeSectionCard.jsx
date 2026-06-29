const statusOptions = [
  "Draft",
  "Pending",
  "In review",
  "Needs lawyer review",
  "Indicative only",
];

export default function ClientIntakeSectionCard({
  section,
  title,
  status,
  summary,
  fields,
  isActive = false,
  onSelect,
  onStatusChange,
}) {
  const safeSection = section ?? {
    id: title || "client-intake-section",
    title: title || "Untitled intake section",
    status: status || "Draft",
    summary: summary || "No section summary provided.",
    fields: Array.isArray(fields) ? fields : [],
  };

  const safeFields = Array.isArray(safeSection.fields) ? safeSection.fields : [];

  function handleSelect() {
    if (typeof onSelect === "function") {
      onSelect();
    }
  }

  function handleStatusChange(event) {
    if (typeof onStatusChange === "function") {
      onStatusChange(event.target.value);
    }
  }

  return (
    <article
      className={`client-intake-card${isActive ? " is-active" : ""}`}
      aria-label={`${safeSection.title} section`}
    >
      <button
        className="client-intake-card-button"
        type="button"
        onClick={handleSelect}
        aria-pressed={isActive}
      >
        <span className="client-intake-card-title">{safeSection.title}</span>
        <span className="client-intake-card-status">{safeSection.status}</span>
      </button>

      <p>{safeSection.summary}</p>

      {safeFields.length > 0 ? (
        <dl className="client-intake-field-list">
          {safeFields.map((field, index) => (
            <div key={`${safeSection.id}-${field.label || index}`}>
              <dt>{field.label || "Field"}</dt>
              <dd>{field.value || "Not provided"}</dd>
            </div>
          ))}
        </dl>
      ) : (
        <p className="client-intake-empty-note">
          No preview fields available for this section yet.
        </p>
      )}

      <label className="client-intake-status-picker">
        <span>Local status</span>
        <select value={safeSection.status} onChange={handleStatusChange}>
          {statusOptions.map((option) => (
            <option key={option} value={option}>
              {option}
            </option>
          ))}
        </select>
      </label>
    </article>
  );
}

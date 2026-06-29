const statusOptions = [
  "Draft",
  "Pending",
  "In review",
  "Needs lawyer review",
  "Indicative only",
];

export default function ClientIntakeSectionCard({
  section,
  isActive,
  onSelect,
  onStatusChange,
}) {
  return (
    <article
      className={`client-intake-card${isActive ? " is-active" : ""}`}
      aria-label={`${section.title} section`}
    >
      <button
        className="client-intake-card-button"
        type="button"
        onClick={onSelect}
        aria-pressed={isActive}
      >
        <span className="client-intake-card-title">{section.title}</span>
        <span className="client-intake-card-status">{section.status}</span>
      </button>

      <p>{section.summary}</p>

      <dl className="client-intake-field-list">
        {section.fields.map((field) => (
          <div key={`${section.id}-${field.label}`}>
            <dt>{field.label}</dt>
            <dd>{field.value}</dd>
          </div>
        ))}
      </dl>

      <label className="client-intake-status-picker">
        <span>Local status</span>
        <select
          value={section.status}
          onChange={(event) => onStatusChange(event.target.value)}
        >
          {statusOptions.map((status) => (
            <option key={status} value={status}>
              {status}
            </option>
          ))}
        </select>
      </label>
    </article>
  );
}

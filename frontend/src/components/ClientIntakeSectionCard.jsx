export default function ClientIntakeSectionCard({
  number,
  title,
  description,
  children,
}) {
  return (
    <section className="client-intake-section-card">
      <div className="client-intake-section-heading">
        <span className="client-intake-section-number">{number}</span>
        <div>
          <h3>{title}</h3>
          {description ? <p>{description}</p> : null}
        </div>
      </div>

      <div className="client-intake-section-body">{children}</div>
    </section>
  );
}

function InfoCard({ title, children }) {
  return (
    <article className="mp-info-card">
      <h3>{title}</h3>
      {children}
    </article>
  );
}

function DetailGrid({ items }) {
  return (
    <dl className="mp-info-grid">
      {items.map((item) => (
        <div key={item.label}>
          <dt>{item.label}</dt>
          <dd>{item.value}</dd>
        </div>
      ))}
    </dl>
  );
}

export function AboutAppPanel({ appVersion = "0.0.0" }) {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>About App</h2>
          <p>Application identity, release context, and current frontend scope.</p>
        </div>
      </div>

      <DetailGrid
        items={[
          { label: "Application", value: "Litigation 360 / LEOS 360" },
          { label: "Version", value: appVersion },
          { label: "Current Layer", value: "Frontend menu platform" },
          { label: "Status", value: "Active development" },
        ]}
      />

      <InfoCard title="Current Capability">
        <p>
          The App Menu provides a professional frontend command hub for navigation,
          information, settings, FAQs, and support-request workflows.
        </p>
      </InfoCard>

      <div className="mp-release-notes">
        <strong>Release Notes</strong>
        <p>
          Phase 13B.3 focuses on safe frontend-first menu action wiring before any
          backend, API, document repository, or production integration is approved.
        </p>
      </div>
    </section>
  );
}

export function AboutSystemPanel() {
  const browser = typeof navigator !== "undefined" ? navigator.userAgent : "Unavailable";
  const language = typeof navigator !== "undefined" ? navigator.language : "Unavailable";
  const platform = typeof navigator !== "undefined" ? navigator.platform : "Unavailable";
  const viewport =
    typeof window !== "undefined"
      ? `${window.innerWidth} × ${window.innerHeight}`
      : "Unavailable";

  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>About System</h2>
          <p>Frontend-only environment information for diagnostics and support.</p>
        </div>
      </div>

      <DetailGrid
        items={[
          { label: "Platform", value: platform },
          { label: "Language", value: language },
          { label: "Viewport", value: viewport },
          { label: "Mode", value: "Browser client" },
        ]}
      />

      <InfoCard title="Browser User Agent">
        <p className="mp-code-text">{browser}</p>
      </InfoCard>

      <p className="mp-empty">
        This panel does not inspect server, database, authentication, RBAC, or production infrastructure.
      </p>
    </section>
  );
}

export function SettingsPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Settings</h2>
          <p>Frontend-only preference placeholders for future application configuration.</p>
        </div>
      </div>

      <div className="mp-setting-list">
        <div className="mp-setting-row">
          <div>
            <strong>Theme</strong>
            <span>Visual theme controls are planned.</span>
          </div>
          <span className="mp-status-pill">Planned</span>
        </div>

        <div className="mp-setting-row">
          <div>
            <strong>Accessibility</strong>
            <span>Keyboard, contrast, and motion preferences are planned.</span>
          </div>
          <span className="mp-status-pill">Planned</span>
        </div>

        <div className="mp-setting-row">
          <div>
            <strong>Notifications</strong>
            <span>Notification preferences require future workflow approval.</span>
          </div>
          <span className="mp-status-pill">Planned</span>
        </div>

        <div className="mp-setting-row">
          <div>
            <strong>Workspace Defaults</strong>
            <span>Default landing module and menu preferences are planned.</span>
          </div>
          <span className="mp-status-pill">Planned</span>
        </div>
      </div>

      <p className="mp-empty">
        No settings are persisted in this phase.
      </p>
    </section>
  );
}

export function SystemPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>System</h2>
          <p>Frontend-safe operational status for the menu platform.</p>
        </div>
      </div>

      <DetailGrid
        items={[
          { label: "Menu Overlay", value: "Active" },
          { label: "Portal Rendering", value: "Enabled" },
          { label: "Backdrop", value: "Enabled" },
          { label: "Backend Calls", value: "Not used by menu platform" },
        ]}
      />

      <InfoCard title="Safe Operating Boundary">
        <p>
          This menu platform is operating in frontend-only mode. It does not modify
          backend services, databases, authentication, RBAC, API routes, or production infrastructure.
        </p>
      </InfoCard>
    </section>
  );
}

export function RecentFilesPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Recent Files</h2>
          <p>Recently opened matter documents, templates and exports will appear here after file storage is connected.</p>
        </div>
      </div>

      <p className="mp-empty">
        No recent files yet.
      </p>
    </section>
  );
}

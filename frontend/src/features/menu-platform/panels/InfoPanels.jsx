export function AboutAppPanel({ appVersion = "0.0.0" }) {
  return (
    <section className="mp-panel" aria-labelledby="mp-about-app-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-about-app-title">About App</h2>
          <p>Version, credits, license, update status, and release notes.</p>
        </div>
      </div>

      <dl className="mp-info-grid">
        <div>
          <dt>Version</dt>
          <dd>{appVersion}</dd>
        </div>
        <div>
          <dt>Update Status</dt>
          <dd>Ready for update-provider integration</dd>
        </div>
        <div>
          <dt>License</dt>
          <dd>Internal application license placeholder</dd>
        </div>
        <div>
          <dt>Credits</dt>
          <dd>Application team, contributors, and future integration providers</dd>
        </div>
      </dl>

      <div className="mp-release-notes">
        <h3>Release Notes</h3>
        <ul>
          <li>Schema-driven dropdown menu platform added.</li>
          <li>FAQ and support-request panels included.</li>
          <li>Responsive, accessible, keyboard-friendly menu shell included.</li>
        </ul>
      </div>
    </section>
  );
}

export function AboutSystemPanel() {
  const nav = typeof navigator !== "undefined" ? navigator : {};
  const screenInfo = typeof window !== "undefined" ? window.screen : {};

  return (
    <section className="mp-panel" aria-labelledby="mp-about-system-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-about-system-title">About System</h2>
          <p>Device, environment, compatibility, and performance context.</p>
        </div>
      </div>

      <dl className="mp-info-grid">
        <div>
          <dt>Platform</dt>
          <dd>{nav.platform || "Unavailable"}</dd>
        </div>
        <div>
          <dt>Browser Language</dt>
          <dd>{nav.language || "Unavailable"}</dd>
        </div>
        <div>
          <dt>Online</dt>
          <dd>{nav.onLine ? "Yes" : "No"}</dd>
        </div>
        <div>
          <dt>CPU Threads</dt>
          <dd>{nav.hardwareConcurrency || "Unavailable"}</dd>
        </div>
        <div>
          <dt>Device Memory</dt>
          <dd>{nav.deviceMemory ? `${nav.deviceMemory} GB` : "Unavailable"}</dd>
        </div>
        <div>
          <dt>Screen</dt>
          <dd>
            {screenInfo.width && screenInfo.height
              ? `${screenInfo.width} × ${screenInfo.height}`
              : "Unavailable"}
          </dd>
        </div>
      </dl>
    </section>
  );
}

export function SettingsPanel() {
  return (
    <section className="mp-panel" aria-labelledby="mp-settings-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-settings-title">Settings</h2>
          <p>Application preferences and customization options.</p>
        </div>
      </div>

      <div className="mp-setting-list">
        <label className="mp-checkbox">
          <input type="checkbox" defaultChecked />
          <span>Show pinned favorites</span>
        </label>

        <label className="mp-checkbox">
          <input type="checkbox" defaultChecked />
          <span>Use compact menu rows</span>
        </label>

        <label className="mp-field">
          <span>Theme Mode</span>
          <select defaultValue="system">
            <option value="system">Follow system</option>
            <option value="light">Light</option>
            <option value="dark">Dark</option>
            <option value="high-contrast">High contrast</option>
          </select>
        </label>

        <label className="mp-field">
          <span>Accent Color</span>
          <select defaultValue="default">
            <option value="default">Default</option>
            <option value="blue">Blue</option>
            <option value="green">Green</option>
            <option value="purple">Purple</option>
            <option value="amber">Amber</option>
          </select>
        </label>
      </div>
    </section>
  );
}

export function SystemPanel() {
  return (
    <section className="mp-panel" aria-labelledby="mp-system-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-system-title">System</h2>
          <p>System-level controls and diagnostic entry points.</p>
        </div>
      </div>

      <div className="mp-action-grid">
        <button type="button">Run Diagnostics</button>
        <button type="button">Check Compatibility</button>
        <button type="button">View Performance Metrics</button>
        <button type="button" disabled title="Requires admin permission">
          Reset System Cache
        </button>
      </div>
    </section>
  );
}

export function RecentFilesPanel() {
  const files = [
    "Client Intake Draft",
    "Matter Checklist Template",
    "Exported Report Example",
  ];

  return (
    <section className="mp-panel" aria-labelledby="mp-recent-files-title">
      <div className="mp-panel-header">
        <div>
          <h2 id="mp-recent-files-title">Recent Files</h2>
          <p>Recent file entries are ready for storage-provider integration.</p>
        </div>
      </div>

      <ul className="mp-simple-list">
        {files.map((file) => (
          <li key={file}>
            <button type="button">{file}</button>
          </li>
        ))}
      </ul>
    </section>
  );
}

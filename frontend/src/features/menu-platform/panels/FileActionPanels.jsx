export function FileOpenPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Open File</h2>
          <p>Frontend-only file opening placeholder for Litigation 360 workspace assets.</p>
        </div>
      </div>

      <div className="mp-info-card">
        <h3>Planned Behaviour</h3>
        <p>
          This action will later open matter documents, templates, evidence bundles,
          exported reports, or recent local workspace files.
        </p>
      </div>

      <div className="mp-action-grid">
        <button type="button" disabled>Open Matter Document</button>
        <button type="button" disabled>Open Template</button>
        <button type="button" disabled>Open Evidence Bundle</button>
        <button type="button" disabled>Browse Local File</button>
      </div>

      <p className="mp-empty">
        Backend, storage, and document repository integration are intentionally not connected in this phase.
      </p>
    </section>
  );
}

export function FileSavePanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Save Workspace</h2>
          <p>Frontend-only save confirmation placeholder.</p>
        </div>
      </div>

      <div className="mp-success">
        <strong>Mock save ready</strong>
        <span>No production data was written. This is a frontend-only status response.</span>
      </div>

      <dl className="mp-info-grid">
        <div>
          <dt>Save Scope</dt>
          <dd>Current visible workspace state</dd>
        </div>
        <div>
          <dt>Persistence</dt>
          <dd>Not connected</dd>
        </div>
        <div>
          <dt>Backend API</dt>
          <dd>Not used</dd>
        </div>
        <div>
          <dt>Status</dt>
          <dd>Ready for future wiring</dd>
        </div>
      </dl>
    </section>
  );
}

export function FileImportPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Import</h2>
          <p>Frontend-only import placeholder for future document and data intake.</p>
        </div>
      </div>

      <div className="mp-info-card">
        <h3>Future Import Sources</h3>
        <ul>
          <li>Client intake forms</li>
          <li>Matter documents</li>
          <li>Court bundles</li>
          <li>CSV or spreadsheet records</li>
          <li>Template packs</li>
        </ul>
      </div>

      <label className="mp-file-drop">
        <strong>Import area disabled for this phase</strong>
        <small>No files are uploaded or processed yet.</small>
        <input type="file" disabled />
      </label>
    </section>
  );
}

export function FileExportPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Export</h2>
          <p>Frontend-only export placeholder for future reports, bundles, and records.</p>
        </div>
      </div>

      <div className="mp-action-grid">
        <button type="button" disabled>Export PDF</button>
        <button type="button" disabled>Export CSV</button>
        <button type="button" disabled>Export Excel</button>
        <button type="button" disabled>Export Matter Bundle</button>
      </div>

      <p className="mp-empty">
        Export generation is intentionally disabled until the document/reporting layer is approved.
      </p>
    </section>
  );
}

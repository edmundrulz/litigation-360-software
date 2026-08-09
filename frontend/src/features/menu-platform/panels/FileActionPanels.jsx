export function FileOpenPanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Open</h2>
          <p>Open a matter document, template, evidence bundle, report or local workspace file.</p>
        </div>
      </div>

      <div className="mp-info-card">
        <h3>Not available yet</h3>
        <p>
          This action will later open matter documents, templates, evidence bundles,
          exported reports, or recent local workspace files.
        </p>
      </div>

      <p className="mp-empty">
        File storage is not connected in this preview. Supported sources will be shown here when opening files is available.
      </p>
    </section>
  );
}

export function FileSavePanel() {
  return (
    <section className="mp-panel">
      <div className="mp-panel-header">
        <div>
          <h2>Save</h2>
          <p>Saving is not available in this preview.</p>
        </div>
      </div>

      <div className="mp-info-banner">
        <strong>Changes are not written to permanent storage.</strong>
        <span>Do not rely on this preview as a saved legal-work record.</span>
      </div>

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

      <p className="mp-empty">Import is not available in this preview. No files can be selected, uploaded or processed yet.</p>
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

      <p className="mp-empty">
        Export is not available in this preview. PDF, CSV, Excel and matter-package options will appear when generation is enabled.
      </p>
    </section>
  );
}

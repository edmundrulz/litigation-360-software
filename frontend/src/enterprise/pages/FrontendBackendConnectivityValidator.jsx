import React, { useEffect, useState } from "react";
import BackendConnectivityPanel from "../components/BackendConnectivityPanel";
import { validateFrontendBackendConnectivity } from "../api/connectivityValidatorApi";

export default function FrontendBackendConnectivityValidator() {
  const [report, setReport] = useState(null);
  const [running, setRunning] = useState(false);

  async function runValidation() {
    setRunning(true);
    const result = await validateFrontendBackendConnectivity();
    setReport(result);
    setRunning(false);
  }

  useEffect(() => {
    runValidation();
    const timer = setInterval(runValidation, 30000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Frontend Backend Connectivity Validator</h1>
      <p>Validates frontend access to all major Phase 10 backend endpoints. Auto-refreshes every 30 seconds.</p>

      <button onClick={runValidation} disabled={running} style={{ padding: "8px 14px" }}>
        {running ? "Testing..." : "Run Connectivity Test"}
      </button>

      {report && (
        <div style={{ marginTop: 16 }}>
          <h2>Status: {report.status}</h2>
          <p>Passed: {report.passed} / {report.endpointsTested}</p>
          <p>Failed: {report.failed}</p>
          <p>Average Response: {report.avgMs} ms</p>
          <p>Generated: {report.generatedAt}</p>
        </div>
      )}

      <BackendConnectivityPanel report={report} />

      <h2>Special Court / Agency Coverage</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur â€” Wisma PERKESO, Jalan Tun Razak</li>
        <li>PERKESO Headquarters â€” Menara PERKESO, Jalan Ampang</li>
      </ul>
    </div>
  );
}

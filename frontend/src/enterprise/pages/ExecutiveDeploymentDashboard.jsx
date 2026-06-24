import React, { useEffect, useState } from "react";
import { getExecutiveDeploymentDashboard } from "../api/deploymentDashboardApi";

export default function ExecutiveDeploymentDashboard() {
  const [dashboard, setDashboard] = useState(null);
  const [error, setError] = useState(null);

  async function refresh() {
    try {
      setError(null);
      setDashboard(await getExecutiveDeploymentDashboard());
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 30000);
    return () => clearInterval(timer);
  }, []);

  const summary = dashboard?.executiveSummary || {};

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Executive Deployment Dashboard</h1>
      <p>Single executive view of deployment score, release approval, risk, blockers, warnings, monitoring, and performance.</p>

      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>Refresh Now</button>
      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: 16 }}>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Approval</h3>
          <strong>{dashboard?.status || "UNKNOWN"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Overall Score</h3>
          <strong>{summary.overallScore ?? "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Enterprise Grade</h3>
          <strong>{summary.enterpriseGrade || "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Risk</h3>
          <strong>{summary.risk || "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Blockers</h3>
          <strong>{summary.blockers ?? "N/A"}</strong>
        </div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}>
          <h3>Warnings</h3>
          <strong>{summary.warnings ?? "N/A"}</strong>
        </div>
      </div>

      <h2>Plain English Summary</h2>
      <p>{summary.plainEnglish || "Waiting for dashboard data..."}</p>

      <h2>Special Operations Coverage</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur â€” Jalan Tun Razak</li>
        <li>PERKESO Headquarters â€” Jalan Ampang</li>
        <li>Maps Integration</li>
        <li>Court Navigation</li>
      </ul>

      <h2>Raw Executive Dashboard</h2>
      <pre style={{ background: "#f5f5f5", padding: 16, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(dashboard, null, 2)}
      </pre>
    </div>
  );
}

import React, { useEffect, useState } from "react";
import { getEnterpriseOperationsDashboard } from "../api/enterpriseOperationsApi";

export default function EnterpriseOperationsCommandCentre() {
  const [dashboard, setDashboard] = useState(null);
  const [error, setError] = useState(null);

  async function refresh() {
    try {
      setError(null);
      setDashboard(await getEnterpriseOperationsDashboard());
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 30000);
    return () => clearInterval(timer);
  }, []);

  const summary = dashboard?.summary || {};

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Enterprise Operations Command Centre</h1>
      <p>Live operations view for system health, deployment, workflows, courts, Industrial Court, PERKESO, navigation, and alerts.</p>

      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>Refresh Now</button>
      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))", gap: 16 }}>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Operations</h3><strong>{summary.operationalStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Deployment</h3><strong>{summary.deploymentStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Monitoring</h3><strong>{summary.monitoringStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Performance</h3><strong>{summary.performanceStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>Industrial Court</h3><strong>{summary.industrialCourtStatus || "UNKNOWN"}</strong></div>
        <div style={{ padding: 16, border: "1px solid #ddd", borderRadius: 12 }}><h3>PERKESO</h3><strong>{summary.perkesoStatus || "UNKNOWN"}</strong></div>
      </div>

      <h2>Executive Alerts</h2>
      <ul>
        {(dashboard?.executiveAlerts || []).map((alert, index) => (
          <li key={index}><strong>{alert.severity}</strong> â€” {alert.category}: {alert.message}</li>
        ))}
      </ul>

      <h2>Special Operations</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur â€” Jalan Tun Razak</li>
        <li>PERKESO Headquarters â€” Jalan Ampang</li>
        <li>Google Maps / Waze navigation readiness</li>
      </ul>

      <h2>Raw Operations Dashboard</h2>
      <pre style={{ background: "#f5f5f5", padding: 16, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify(dashboard, null, 2)}
      </pre>
    </div>
  );
}

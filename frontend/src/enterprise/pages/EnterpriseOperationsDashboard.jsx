import React, { useEffect, useState } from "react";
import EnterpriseStatusCard from "../components/EnterpriseStatusCard";
import { getEnterpriseHealthBundle, getEnterpriseDashboard, getDeploymentReadiness, getPerformanceBenchmark } from "../api/enterpriseApi";

export default function EnterpriseOperationsDashboard() {
  const [bundle, setBundle] = useState(null);
  const [dashboard, setDashboard] = useState(null);
  const [readiness, setReadiness] = useState(null);
  const [performance, setPerformance] = useState(null);
  const [error, setError] = useState(null);

  async function refresh() {
    try {
      setError(null);
      const [healthBundle, monitoringDashboard, deploymentReadiness, benchmark] = await Promise.all([
        getEnterpriseHealthBundle(),
        getEnterpriseDashboard(),
        getDeploymentReadiness(),
        getPerformanceBenchmark()
      ]);
      setBundle(healthBundle);
      setDashboard(monitoringDashboard);
      setReadiness(deploymentReadiness);
      setPerformance(benchmark);
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 15000);
    return () => clearInterval(timer);
  }, []);

  const result = bundle?.result || {};

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Litigation 360 Enterprise Operations Dashboard</h1>
      <p>Live monitoring dashboard. Auto-refreshes every 15 seconds.</p>
      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>Refresh Now</button>
      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))", gap: 16 }}>
        <EnterpriseStatusCard title="Monitoring" status={result.monitoring?.status} value={`Score: ${result.monitoring?.healthScore ?? "N/A"}`} />
        <EnterpriseStatusCard title="Deployment Readiness" status={readiness?.status} value={`Ready: ${String(readiness?.deploymentReady ?? false)}`} />
        <EnterpriseStatusCard title="Performance" status={result.performance?.status} value={`Avg: ${result.performance?.avgMs ?? "N/A"} ms`} />
        <EnterpriseStatusCard title="Backup Recovery" status={result.backupRecovery?.status} value={`Snapshots: ${result.backupRecovery?.snapshotsCreated ?? "N/A"}`} />
        <EnterpriseStatusCard title="Governance" status={result.governance?.status} value={`Score: ${result.governance?.governanceScore ?? "N/A"}`} />
        <EnterpriseStatusCard title="Autonomous Ops" status={result.autonomous?.status} value={`Escalations: ${result.autonomous?.openEscalations ?? "N/A"}`} />
        <EnterpriseStatusCard title="Maps" status={result.maps?.status} value={`Courts: ${result.maps?.registeredCourts ?? "N/A"}`} />
        <EnterpriseStatusCard title="Navigation" status={result.navigation?.status} value={`Courts: ${result.navigation?.courtsRegistered ?? "N/A"}`} />
      </div>

      <h2 style={{ marginTop: 32 }}>Special Court / Agency Monitoring</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur â€” Wisma PERKESO, Jalan Tun Razak</li>
        <li>PERKESO Headquarters â€” Menara PERKESO, Jalan Ampang</li>
      </ul>

      <h2>Operational Details</h2>
      <pre style={{ background: "#f5f5f5", padding: 16, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify({ bundle, dashboard, readiness, performance }, null, 2)}
      </pre>
    </div>
  );
}

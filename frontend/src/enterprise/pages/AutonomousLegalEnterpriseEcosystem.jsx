import React, { useEffect, useState } from "react";
import {
  getEcosystemDashboard,
  getEcosystemMetrics,
  getEcosystemAgents
} from "../api/autonomousEcosystemApi";

export default function AutonomousLegalEnterpriseEcosystem() {
  const [dashboard, setDashboard] = useState(null);
  const [metrics, setMetrics] = useState(null);
  const [agents, setAgents] = useState(null);

  useEffect(() => {
    getEcosystemDashboard().then(setDashboard).catch(console.error);
    getEcosystemMetrics().then(setMetrics).catch(console.error);
    getEcosystemAgents().then(setAgents).catch(console.error);
  }, []);

  return (
    <div style={{ padding: 24 }}>
      <h1>Phase 11.0 Autonomous Legal Enterprise Ecosystem</h1>
      <p>Foundation layer for autonomous legal enterprise orchestration.</p>

      <h2>Metrics</h2>
      <pre>{JSON.stringify(metrics, null, 2)}</pre>

      <h2>Dashboard</h2>
      <pre>{JSON.stringify(dashboard, null, 2)}</pre>

      <h2>Agents</h2>
      <pre>{JSON.stringify(agents, null, 2)}</pre>
    </div>
  );
}

import React, { useEffect, useState } from 'react';
import { getAutonomousDashboard } from '../api/autonomousOperationsApi';

export default function EnterpriseAutonomousOperationsSupervisor() {
  const [dashboard, setDashboard] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    getAutonomousDashboard()
      .then(setDashboard)
      .catch((err) => setError(err.message));
  }, []);

  if (error) return <div>Autonomous Supervisor Error: {error}</div>;
  if (!dashboard) return <div>Loading Autonomous Operations Supervisor...</div>;

  return (
    <div style={{ padding: 24 }}>
      <h1>Enterprise Autonomous Operations Supervisor</h1>
      <p>Status: {dashboard.status}</p>
      <p>Mode: {dashboard.summary?.overallAutonomyMode}</p>
      <p>Destructive Actions Blocked: {String(dashboard.summary?.destructiveActionsBlocked)}</p>
      <p>Executive Control Enabled: {String(dashboard.summary?.executiveControlEnabled)}</p>
      <h2>Metrics</h2>
      <pre>{JSON.stringify(dashboard.metrics, null, 2)}</pre>
      <h2>Court Supervision</h2>
      <pre>{JSON.stringify(dashboard.courts, null, 2)}</pre>
      <h2>Deployment Supervision</h2>
      <pre>{JSON.stringify(dashboard.deployments, null, 2)}</pre>
      <h2>Executive Controls</h2>
      <pre>{JSON.stringify(dashboard.executive, null, 2)}</pre>
    </div>
  );
}

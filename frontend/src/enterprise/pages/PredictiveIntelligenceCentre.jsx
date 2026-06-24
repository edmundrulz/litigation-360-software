import React, { useEffect, useState } from "react";
import { getPredictiveDashboard, getPredictiveMetrics } from "../api/predictiveIntelligenceApi";

export default function PredictiveIntelligenceCentre() {
  const [dashboard, setDashboard] = useState(null);
  const [metrics, setMetrics] = useState(null);

  useEffect(() => {
    getPredictiveDashboard().then(setDashboard).catch(console.error);
    getPredictiveMetrics().then(setMetrics).catch(console.error);
  }, []);

  return (
    <div style={{ padding: 24 }}>
      <h1>Phase 10Z.3 Predictive Intelligence Engine</h1>
      <h2>Metrics</h2>
      <pre>{JSON.stringify(metrics, null, 2)}</pre>
      <h2>Dashboard</h2>
      <pre>{JSON.stringify(dashboard, null, 2)}</pre>
    </div>
  );
}

import React, { useEffect, useState } from "react";
import { operationsAnalyticsApi } from "../api/operationsAnalyticsApi";

export default function EnterpriseOperationsAnalyticsCentre() {
  const [dashboard, setDashboard] = useState(null);
  const [metrics, setMetrics] = useState(null);
  const [performance, setPerformance] = useState(null);
  const [error, setError] = useState(null);

  async function load() {
    try {
      const [dashboardData, metricsData, performanceData] = await Promise.all([
        operationsAnalyticsApi.dashboard(),
        operationsAnalyticsApi.metrics(),
        operationsAnalyticsApi.performance()
      ]);
      setDashboard(dashboardData);
      setMetrics(metricsData);
      setPerformance(performanceData);
      setError(null);
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    load();
    const timer = setInterval(load, 30000);
    return () => clearInterval(timer);
  }, []);

  return (
    <main style={{ padding: "24px", fontFamily: "Arial, sans-serif" }}>
      <h1>Enterprise Operations Analytics Centre</h1>
      <p>Phase 10Z.2 live monitoring dashboard. Auto refresh: 30 seconds.</p>
      {error && <pre style={{ color: "crimson" }}>{error}</pre>}
      {!dashboard && <p>Loading analytics...</p>}
      {dashboard && (
        <section>
          <h2>Operations Health: {dashboard.snapshot.operationsHealth}</h2>
          <p>Stability Score: {dashboard.snapshot.stabilityScore}%</p>
          <p>Risk Score: {dashboard.snapshot.riskScore}%</p>
          <p>Workflow Success Rate: {dashboard.snapshot.workflowSuccessRate}%</p>
          <h3>Recommendations</h3>
          <ul>{dashboard.snapshot.recommendations.map((item) => <li key={item}>{item}</li>)}</ul>
          <h3>Checks & Balances</h3>
          <ul>{dashboard.checksAndBalances.map((item) => <li key={item}>{item}</li>)}</ul>
        </section>
      )}
      {metrics && (
        <section>
          <h2>Metrics</h2>
          <ul>{metrics.values.map((m) => <li key={m.key}>{m.label}: {String(m.value)}</li>)}</ul>
        </section>
      )}
      {performance && (
        <section>
          <h2>Performance</h2>
          <pre>{JSON.stringify(performance.results, null, 2)}</pre>
        </section>
      )}
    </main>
  );
}

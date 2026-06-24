import React, { useEffect, useState } from "react";
import {
  getAlertDashboard,
  createAlert,
  escalateAlert,
  resolveAlert
} from "../api/alertEscalationApi";

export default function EnterpriseAlertEscalationCentre() {
  const [dashboard, setDashboard] = useState(null);
  const [status, setStatus] = useState("Loading...");

  async function refreshDashboard() {
    try {
      const data = await getAlertDashboard();
      setDashboard(data);
      setStatus("Live dashboard updated");
    } catch (error) {
      setStatus(`Dashboard failed: ${error.message}`);
    }
  }

  async function createTestCriticalAlert() {
    await createAlert({
      severity: "CRITICAL",
      category: "DEPLOYMENT",
      title: "Gatekeeper rejected deployment",
      message: "Deployment gatekeeper rejected release and blocked promotion.",
      source: "GATEKEEPER"
    });
    await refreshDashboard();
  }

  async function escalateFirstOpenAlert() {
    const first = dashboard?.openAlerts?.[0];
    if (!first) return;
    await escalateAlert({
      alertId: first.alertId,
      level: "EXECUTIVE",
      reason: "Critical alert requires executive attention"
    });
    await refreshDashboard();
  }

  async function resolveFirstOpenAlert() {
    const first = dashboard?.openAlerts?.[0];
    if (!first) return;
    await resolveAlert({
      alertId: first.alertId,
      resolvedBy: "OPERATOR",
      notes: "Resolved from Enterprise Alert & Escalation Centre",
      checksCompleted: true
    });
    await refreshDashboard();
  }

  useEffect(() => {
    refreshDashboard();
    const timer = setInterval(refreshDashboard, 15000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: "24px" }}>
      <h1>Enterprise Alert & Escalation Centre</h1>
      <p>{status}</p>

      <div style={{ display: "flex", gap: "12px", marginBottom: "16px" }}>
        <button onClick={refreshDashboard}>Refresh</button>
        <button onClick={createTestCriticalAlert}>Create Critical Test Alert</button>
        <button onClick={escalateFirstOpenAlert}>Escalate First Open Alert</button>
        <button onClick={resolveFirstOpenAlert}>Resolve First Open Alert</button>
      </div>

      <section>
        <h2>Health</h2>
        <pre>{JSON.stringify(dashboard?.health, null, 2)}</pre>
      </section>

      <section>
        <h2>Metrics</h2>
        <pre>{JSON.stringify(dashboard?.metrics, null, 2)}</pre>
      </section>

      <section>
        <h2>Open Alerts</h2>
        <pre>{JSON.stringify(dashboard?.openAlerts, null, 2)}</pre>
      </section>

      <section>
        <h2>Escalations</h2>
        <pre>{JSON.stringify(dashboard?.escalations, null, 2)}</pre>
      </section>

      <section>
        <h2>Notifications</h2>
        <pre>{JSON.stringify(dashboard?.notifications, null, 2)}</pre>
      </section>
    </div>
  );
}

const BASE = "/api/enterprise/predictive";

export async function getPredictiveHealth() {
  const res = await fetch(`${BASE}/health`);
  return res.json();
}

export async function getPredictiveMetrics() {
  const res = await fetch(`${BASE}/metrics`);
  return res.json();
}

export async function getPredictiveDashboard() {
  const res = await fetch(`${BASE}/dashboard`);
  return res.json();
}

export async function getPredictiveRisks() {
  const res = await fetch(`${BASE}/risks`);
  return res.json();
}

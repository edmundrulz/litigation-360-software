const BASE = "/api/enterprise/ecosystem";

export async function getEcosystemHealth() {
  const res = await fetch(`${BASE}/health`);
  return res.json();
}

export async function getEcosystemMetrics() {
  const res = await fetch(`${BASE}/metrics`);
  return res.json();
}

export async function getEcosystemDashboard() {
  const res = await fetch(`${BASE}/dashboard`);
  return res.json();
}

export async function getEcosystemRegistry() {
  const res = await fetch(`${BASE}/registry`);
  return res.json();
}

export async function getEcosystemAgents() {
  const res = await fetch(`${BASE}/agents`);
  return res.json();
}

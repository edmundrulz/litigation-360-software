const BASE_URL = "/api/enterprise/alerts";

export async function getAlertHealth() {
  const response = await fetch(`${BASE_URL}/health`);
  return response.json();
}

export async function getAlertMetrics() {
  const response = await fetch(`${BASE_URL}/metrics`);
  return response.json();
}

export async function getAlertDashboard() {
  const response = await fetch(`${BASE_URL}/dashboard`);
  return response.json();
}

export async function getOpenAlerts() {
  const response = await fetch(`${BASE_URL}/open`);
  return response.json();
}

export async function createAlert(payload) {
  const response = await fetch(`${BASE_URL}/create`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  return response.json();
}

export async function resolveAlert(payload) {
  const response = await fetch(`${BASE_URL}/resolve`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  return response.json();
}

export async function escalateAlert(payload) {
  const response = await fetch(`${BASE_URL}/escalate`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  return response.json();
}

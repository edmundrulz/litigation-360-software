const API_BASE = "http://localhost:5000";

async function getJson(path) {
  try {
    const response = await fetch(`${API_BASE}${path}`);
    if (!response.ok) return { ok: false, status: response.status, error: `Request failed: ${response.status}`, path };
    return await response.json();
  } catch (err) {
    return { ok: false, status: "NETWORK_ERROR", error: err.message, path };
  }
}

export async function getEnterpriseOperationsDashboard() {
  return await getJson("/api/enterprise/operations/dashboard");
}

export async function getEnterpriseOperationsHealth() {
  return await getJson("/api/enterprise/operations/health");
}

export async function getEnterpriseOperationsAlerts() {
  return await getJson("/api/enterprise/operations/alerts");
}

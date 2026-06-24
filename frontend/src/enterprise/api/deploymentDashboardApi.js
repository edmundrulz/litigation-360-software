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

export async function getExecutiveDeploymentDashboard() {
  return await getJson("/api/enterprise/executive-deployment/dashboard");
}

export async function getExecutiveDeploymentSummary() {
  return await getJson("/api/enterprise/executive-deployment/summary");
}

export async function getExecutiveDeploymentHealth() {
  return await getJson("/api/enterprise/executive-deployment/health");
}

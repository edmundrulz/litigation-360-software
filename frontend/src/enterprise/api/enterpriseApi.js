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

export async function getEnterpriseHealthBundle() {
  const endpoints = {
    monitoring: "/api/enterprise/monitoring/health",
    monitoringDashboard: "/api/enterprise/monitoring/dashboard",
    hardening: "/api/enterprise/hardening/deployment/readiness",
    backupRecovery: "/api/enterprise/backup-recovery/health",
    performance: "/api/enterprise/performance/health",
    governance: "/api/enterprise/governance/health",
    autonomous: "/api/enterprise/autonomous/health",
    maps: "/api/enterprise/maps/health",
    navigation: "/api/enterprise/navigation/health",
    predictive: "/api/enterprise/predictive/health",
    assistant: "/api/enterprise/assistant/health",
    commandCentre: "/api/enterprise/command-centre/health"
  };
  const result = {};
  for (const [key, path] of Object.entries(endpoints)) result[key] = await getJson(path);
  return { generatedAt: new Date().toISOString(), result };
}

export async function getEnterpriseDashboard() { return await getJson("/api/enterprise/monitoring/dashboard"); }
export async function getPerformanceBenchmark() { return await getJson("/api/enterprise/performance/benchmark"); }
export async function getDeploymentReadiness() { return await getJson("/api/enterprise/hardening/deployment/readiness"); }

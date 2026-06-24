const API_BASE = "http://localhost:5000";

const ENTERPRISE_ENDPOINTS = [
  { key: "monitoring", label: "Monitoring", path: "/api/enterprise/monitoring/health" },
  { key: "hardening", label: "Hardening Readiness", path: "/api/enterprise/hardening/deployment/readiness" },
  { key: "backupRecovery", label: "Backup Recovery", path: "/api/enterprise/backup-recovery/health" },
  { key: "performance", label: "Performance", path: "/api/enterprise/performance/health" },
  { key: "governance", label: "Governance", path: "/api/enterprise/governance/health" },
  { key: "autonomous", label: "Autonomous Operations", path: "/api/enterprise/autonomous/health" },
  { key: "maps", label: "Maps Integration", path: "/api/enterprise/maps/health" },
  { key: "navigation", label: "Court Navigation", path: "/api/enterprise/navigation/health" },
  { key: "predictive", label: "Predictive Analytics", path: "/api/enterprise/predictive/health" },
  { key: "assistant", label: "Legal Assistant", path: "/api/enterprise/assistant/health" },
  { key: "commandCentre", label: "Command Centre", path: "/api/enterprise/command-centre/health" },
  { key: "documents", label: "Document Lifecycle", path: "/api/enterprise/documents/lifecycle/health" },
  { key: "courtOperations", label: "Court Operations", path: "/api/enterprise/court-operations/health" },
  { key: "matterIntelligence", label: "Matter Intelligence", path: "/api/enterprise/matters/intelligence/health" }
];

async function testEndpoint(endpoint) {
  const startedAt = performance.now();

  try {
    const response = await fetch(`${API_BASE}${endpoint.path}`);
    const durationMs = Math.round((performance.now() - startedAt) * 100) / 100;

    let data = null;
    try {
      data = await response.json();
    } catch {
      data = { parseError: true };
    }

    return {
      ...endpoint,
      ok: response.ok,
      httpStatus: response.status,
      durationMs,
      data,
      status: response.ok ? "PASS" : "FAIL",
      testedAt: new Date().toISOString()
    };
  } catch (err) {
    return {
      ...endpoint,
      ok: false,
      httpStatus: "NETWORK_ERROR",
      durationMs: Math.round((performance.now() - startedAt) * 100) / 100,
      error: err.message,
      status: "FAIL",
      testedAt: new Date().toISOString()
    };
  }
}

export async function validateFrontendBackendConnectivity() {
  const results = [];
  for (const endpoint of ENTERPRISE_ENDPOINTS) {
    results.push(await testEndpoint(endpoint));
  }

  const passed = results.filter(r => r.ok).length;
  const failed = results.length - passed;
  const avgMs = Math.round(results.reduce((sum, r) => sum + r.durationMs, 0) / Math.max(1, results.length) * 100) / 100;

  return {
    module: "Frontend Backend Connectivity Validator",
    apiBase: API_BASE,
    status: failed === 0 ? "PASS" : "FAIL",
    endpointsTested: results.length,
    passed,
    failed,
    avgMs,
    results,
    generatedAt: new Date().toISOString()
  };
}

export { ENTERPRISE_ENDPOINTS };

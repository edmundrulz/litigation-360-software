const { collectEnterpriseMetrics } = require("./metricsCollector");
const { generateAlertsFromMetrics, getAlerts, getAlertHealth } = require("./alertManager");

const monitoringMetrics = {
  dashboardsGenerated: 0,
  healthChecksGenerated: 0,
  metricsGenerated: 0,
  alertsGenerated: 0,
  readinessChecksGenerated: 0,
  lastGeneratedAt: null
};

function statusWeight(status) {
  const s = String(status || "").toUpperCase();
  if (["HEALTHY", "READY", "PASS"].includes(s)) return 100;
  if (["ATTENTION", "WARNING"].includes(s)) return 75;
  if (["CRITICAL", "HIGH_RISK"].includes(s)) return 40;
  if (["BLOCKER", "BLOCKED", "FAIL", "ERROR", "LOAD_ERROR"].includes(s)) return 0;
  return 70;
}

function calculateMonitoringScore(metrics, alertHealth) {
  const modules = Object.values(metrics.modules || {});
  const moduleScore = modules.length
    ? Math.round(modules.reduce((sum, m) => sum + statusWeight(m.status), 0) / modules.length)
    : 100;

  let score = moduleScore;
  if (!metrics.database.exists) score -= 30;
  if (alertHealth.blockerAlerts > 0) score -= 30;
  if (alertHealth.criticalAlerts > 0) score -= 15;
  if (metrics.process.memory.heapUsedMB > 512) score -= 10;

  return Math.max(0, Math.min(100, score));
}

function getMonitoringDashboard() {
  const metrics = collectEnterpriseMetrics();
  const generatedAlerts = generateAlertsFromMetrics(metrics);
  const alertHealth = getAlertHealth();
  const healthScore = calculateMonitoringScore(metrics, alertHealth);

  monitoringMetrics.dashboardsGenerated += 1;
  monitoringMetrics.alertsGenerated += generatedAlerts.length;
  monitoringMetrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Enterprise Monitoring & Observability",
    status: healthScore >= 90 ? "HEALTHY" : healthScore >= 70 ? "ATTENTION" : "CRITICAL",
    healthScore,
    generatedAt: monitoringMetrics.lastGeneratedAt,
    metrics,
    alertHealth,
    generatedAlerts,
    openAlerts: getAlerts({ status: "OPEN", limit: 50 }),
    serviceStatus: {
      backend: "ONLINE",
      database: metrics.database.exists ? "ONLINE" : "MISSING",
      workflows: metrics.modules.workflows?.status || "UNKNOWN",
      notifications: metrics.modules.notifications?.status || "UNKNOWN",
      courtOperations: metrics.modules.courtOperations?.status || "UNKNOWN",
      maps: metrics.modules.maps?.status || "UNKNOWN",
      governance: metrics.modules.governance?.status || "UNKNOWN",
      backupRecovery: metrics.modules.backupRecovery?.status || "UNKNOWN",
      hardening: metrics.modules.hardening?.status || "UNKNOWN"
    },
    specialMonitoring: metrics.specialMonitoring
  };
}

function getMonitoringHealth() {
  const dashboard = getMonitoringDashboard();
  monitoringMetrics.healthChecksGenerated += 1;

  return {
    module: "Enterprise Monitoring Engine",
    status: dashboard.status,
    healthScore: dashboard.healthScore,
    backend: dashboard.serviceStatus.backend,
    database: dashboard.serviceStatus.database,
    workflows: dashboard.serviceStatus.workflows,
    notifications: dashboard.serviceStatus.notifications,
    courtOperations: dashboard.serviceStatus.courtOperations,
    maps: dashboard.serviceStatus.maps,
    governance: dashboard.serviceStatus.governance,
    backupRecovery: dashboard.serviceStatus.backupRecovery,
    openAlerts: dashboard.openAlerts.length,
    timestamp: new Date().toISOString()
  };
}

function getMonitoringMetrics() {
  monitoringMetrics.metricsGenerated += 1;
  return {
    ...monitoringMetrics,
    runtime: collectEnterpriseMetrics(),
    timestamp: new Date().toISOString()
  };
}

function getMonitoringReadiness() {
  monitoringMetrics.readinessChecksGenerated += 1;
  const dashboard = getMonitoringDashboard();

  return {
    module: "Monitoring Readiness",
    status: dashboard.status === "CRITICAL" ? "BLOCKED" : "READY",
    monitoringReady: dashboard.status !== "CRITICAL",
    healthScore: dashboard.healthScore,
    openAlerts: dashboard.openAlerts.length,
    requiredPanels: {
      systemHealth: true,
      runtimeMetrics: true,
      alertManager: true,
      hardening: true,
      backupRecovery: true,
      governance: true,
      courtOperations: true,
      maps: true,
      specialCourtAgencyMonitoring: true
    },
    timestamp: new Date().toISOString()
  };
}

function getMonitoringAlerts() {
  return {
    alerts: getAlerts({ limit: 100 }),
    alertHealth: getAlertHealth(),
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  getMonitoringDashboard,
  getMonitoringHealth,
  getMonitoringMetrics,
  getMonitoringReadiness,
  getMonitoringAlerts
};

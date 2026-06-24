const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const PHASE_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10Z0-enterprise-operations-command-centre");
const DASHBOARDS = path.join(PHASE_ROOT, "dashboards");
const ALERTS = path.join(PHASE_ROOT, "alerts");

fs.mkdirSync(DASHBOARDS, { recursive: true });
fs.mkdirSync(ALERTS, { recursive: true });

const metrics = {
  dashboardsGenerated: 0,
  alertsGenerated: 0,
  workflowViewsGenerated: 0,
  courtViewsGenerated: 0,
  navigationViewsGenerated: 0,
  deploymentViewsGenerated: 0,
  lastGeneratedAt: null
};

function safeCall(label, fn) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, label };
  }
}

function loadJson(file) {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return null;
  }
}

function getSystemPanel() {
  const monitoring = require("./enterpriseMonitoringEngine");
  const environment = require("./environmentValidationEngine");
  const release = require("./releaseValidatorEngine");
  const performance = require("./performanceOptimizationEngine");
  const backup = require("./backupRecoveryEngine");

  return {
    monitoring: safeCall("monitoring", () => monitoring.getMonitoringHealth()),
    environment: safeCall("environment", () => environment.getEnvironmentHealth()),
    release: safeCall("release", () => release.getReleaseHealth()),
    performance: safeCall("performance", () => performance.getPerformanceHealth ? performance.getPerformanceHealth() : performance.health()),
    backupRecovery: safeCall("backupRecovery", () => backup.getBackupRecoveryHealth()),
    generatedAt: new Date().toISOString()
  };
}

function getDeploymentPanel() {
  const scoring = require("./deploymentScoringEngine");
  const gatekeeper = require("./deploymentGatekeeperEngine");
  const dashboard = require("./executiveDeploymentDashboardEngine");

  metrics.deploymentViewsGenerated += 1;

  return {
    scoring: safeCall("scoring", () => scoring.getScoringHealth()),
    gatekeeper: safeCall("gatekeeper", () => gatekeeper.getGatekeeperHealth()),
    executiveDeployment: safeCall("executiveDeployment", () => dashboard.getExecutiveDeploymentHealth()),
    generatedAt: new Date().toISOString()
  };
}

function getWorkflowPanel() {
  const architecture = loadJson(path.join(PROJECT_ROOT, "_operations", "phase-10Y0-enterprise-master-registry-digital-twin", "registries", "workflows-registry.json"));
  const automation = loadJson(path.join(PROJECT_ROOT, "_operations", "enterprise-architecture", "registries", "automation-registry.json"));

  metrics.workflowViewsGenerated += 1;

  return {
    module: "Workflow Operations",
    status: "MONITORED",
    activeWorkflows: 0,
    pendingWorkflows: 0,
    failedWorkflows: 0,
    completedWorkflows: 0,
    knownWorkflows: architecture?.totals?.workflows || automation?.totals?.events || 0,
    workflows: architecture?.workflows || [],
    generatedAt: new Date().toISOString()
  };
}

function getCourtPanel() {
  metrics.courtViewsGenerated += 1;

  return {
    module: "Court Operations",
    status: "MONITORED",
    todayHearings: [],
    upcomingHearings: [],
    courtAttendance: [],
    preparationStatus: "NO_ACTIVE_HEARING_DATA_CONNECTED",
    courts: [
      "Federal Court",
      "Court of Appeal",
      "High Court",
      "Sessions Court",
      "Magistrates Court"
    ],
    generatedAt: new Date().toISOString()
  };
}

function getIndustrialCourtPanel() {
  return {
    module: "Industrial Court Operations",
    status: "MONITORED",
    location: "Industrial Court Kuala Lumpur",
    cases: [],
    hearings: [],
    deadlines: [],
    attendance: [],
    navigationStatus: "READY_FOR_MAP_LINK_GENERATION",
    generatedAt: new Date().toISOString()
  };
}

function getPerkesoPanel() {
  return {
    module: "PERKESO Operations",
    status: "MONITORED",
    offices: [
      "PERKESO Kuala Lumpur - Jalan Tun Razak",
      "PERKESO Headquarters - Jalan Ampang"
    ],
    meetings: [],
    submissions: [],
    appointments: [],
    attendance: [],
    navigationStatus: "READY_FOR_MAP_LINK_GENERATION",
    generatedAt: new Date().toISOString()
  };
}

function getNavigationPanel() {
  metrics.navigationViewsGenerated += 1;

  return {
    module: "Navigation Centre",
    status: "READY",
    destinations: [
      {
        name: "Industrial Court Kuala Lumpur",
        type: "INDUSTRIAL_COURT",
        googleMapsReady: true,
        wazeReady: true
      },
      {
        name: "PERKESO Kuala Lumpur - Jalan Tun Razak",
        type: "PERKESO",
        googleMapsReady: true,
        wazeReady: true
      },
      {
        name: "PERKESO Headquarters - Jalan Ampang",
        type: "PERKESO",
        googleMapsReady: true,
        wazeReady: true
      }
    ],
    generatedAt: new Date().toISOString()
  };
}

function generateExecutiveAlerts(dashboard) {
  const alerts = [];

  if (dashboard.deployment?.gatekeeper?.deploymentApproved === false || dashboard.deployment?.gatekeeper?.status === "REJECTED") {
    alerts.push({
      severity: "CRITICAL",
      category: "DEPLOYMENT",
      message: "Deployment Gatekeeper has not approved deployment.",
      createdAt: new Date().toISOString()
    });
  }

  if (dashboard.system?.monitoring?.status === "CRITICAL") {
    alerts.push({
      severity: "CRITICAL",
      category: "MONITORING",
      message: "Enterprise monitoring is critical.",
      createdAt: new Date().toISOString()
    });
  }

  if (dashboard.system?.backupRecovery?.status === "FAIL") {
    alerts.push({
      severity: "CRITICAL",
      category: "BACKUP",
      message: "Backup recovery status failed.",
      createdAt: new Date().toISOString()
    });
  }

  alerts.push({
    severity: "INFO",
    category: "OPERATIONS",
    message: "Industrial Court Kuala Lumpur and PERKESO operational coverage present.",
    createdAt: new Date().toISOString()
  });

  metrics.alertsGenerated += alerts.length;
  fs.writeFileSync(path.join(ALERTS, "latest-executive-alerts.json"), JSON.stringify(alerts, null, 2));

  return alerts;
}

function generateOperationsDashboard() {
  const dashboard = {
    module: "Enterprise Operations Command Centre",
    status: "ACTIVE",
    system: getSystemPanel(),
    deployment: getDeploymentPanel(),
    workflows: getWorkflowPanel(),
    courts: getCourtPanel(),
    industrialCourt: getIndustrialCourtPanel(),
    perkeso: getPerkesoPanel(),
    navigation: getNavigationPanel(),
    generatedAt: new Date().toISOString()
  };

  dashboard.executiveAlerts = generateExecutiveAlerts(dashboard);
  dashboard.summary = {
    operationalStatus: "ACTIVE",
    deploymentStatus: dashboard.deployment.gatekeeper?.status || "UNKNOWN",
    deploymentApproved: dashboard.deployment.gatekeeper?.deploymentApproved || false,
    monitoringStatus: dashboard.system.monitoring?.status || "UNKNOWN",
    performanceStatus: dashboard.system.performance?.status || "UNKNOWN",
    industrialCourtStatus: dashboard.industrialCourt.status,
    perkesoStatus: dashboard.perkeso.status,
    alertCount: dashboard.executiveAlerts.length
  };

  metrics.dashboardsGenerated += 1;
  metrics.lastGeneratedAt = dashboard.generatedAt;

  fs.writeFileSync(path.join(DASHBOARDS, "latest-enterprise-operations-dashboard.json"), JSON.stringify(dashboard, null, 2));
  return dashboard;
}

function getOperationsAlerts() {
  const dashboard = generateOperationsDashboard();
  return {
    module: "Enterprise Operations Alerts",
    alertCount: dashboard.executiveAlerts.length,
    alerts: dashboard.executiveAlerts,
    timestamp: new Date().toISOString()
  };
}

function getOperationsHealth() {
  const dashboard = generateOperationsDashboard();

  return {
    module: "Enterprise Operations Command Centre",
    status: dashboard.status,
    operationalStatus: dashboard.summary.operationalStatus,
    deploymentApproved: dashboard.summary.deploymentApproved,
    monitoringStatus: dashboard.summary.monitoringStatus,
    performanceStatus: dashboard.summary.performanceStatus,
    industrialCourtStatus: dashboard.summary.industrialCourtStatus,
    perkesoStatus: dashboard.summary.perkesoStatus,
    alertCount: dashboard.summary.alertCount,
    dashboardsGenerated: metrics.dashboardsGenerated,
    alertsGenerated: metrics.alertsGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getOperationsMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  generateOperationsDashboard,
  getOperationsAlerts,
  getSystemPanel,
  getDeploymentPanel,
  getWorkflowPanel,
  getCourtPanel,
  getIndustrialCourtPanel,
  getPerkesoPanel,
  getNavigationPanel,
  getOperationsHealth,
  getOperationsMetrics
};

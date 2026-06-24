const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10Q-enterprise-monitoring", "reports");
const dashboards = path.join(root, "_operations", "phase-10Q-enterprise-monitoring", "dashboards");
fs.mkdirSync(reports, { recursive: true });
fs.mkdirSync(dashboards, { recursive: true });

const monitoringPath = path.join(src, "automation", "enterpriseMonitoringEngine.js");
const metricsPath = path.join(src, "automation", "metricsCollector.js");
const alertsPath = path.join(src, "automation", "alertManager.js");
const routePath = path.join(src, "routes", "enterpriseMonitoringRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(monitoringPath)) {
  console.log("Enterprise Monitoring Engine missing. Run APPLY mode.");
  process.exit(1);
}

const monitoring = require(monitoringPath);

const dashboard = monitoring.getMonitoringDashboard();
const health = monitoring.getMonitoringHealth();
const metrics = monitoring.getMonitoringMetrics();
const alerts = monitoring.getMonitoringAlerts();
const readiness = monitoring.getMonitoringReadiness();
const indexText = fs.readFileSync(indexPath, "utf8");

fs.writeFileSync(path.join(dashboards, "latest-monitoring-dashboard.json"), JSON.stringify(dashboard, null, 2));

const report = {
  phase: "10Q",
  module: "Enterprise Monitoring & Observability",
  timestamp: new Date().toISOString(),
  files: {
    monitoringEngineExists: fs.existsSync(monitoringPath),
    metricsCollectorExists: fs.existsSync(metricsPath),
    alertManagerExists: fs.existsSync(alertsPath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseMonitoringRoutes")
  },
  tests: {
    dashboardGenerated: !!dashboard.status,
    healthGenerated: !!health.status,
    metricsGenerated: !!metrics.runtime,
    alertsGenerated: !!alerts.alertHealth,
    readinessGenerated: !!readiness.status,
    specialMonitoringIncluded: dashboard.specialMonitoring?.industrialCourtKualaLumpur === "MONITORED"
  },
  health,
  readiness,
  status: (
    fs.existsSync(monitoringPath) &&
    fs.existsSync(metricsPath) &&
    fs.existsSync(alertsPath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseMonitoringRoutes") &&
    !!dashboard.status &&
    !!health.status &&
    !!metrics.runtime &&
    !!alerts.alertHealth &&
    !!readiness.status &&
    dashboard.specialMonitoring?.industrialCourtKualaLumpur === "MONITORED"
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10Q-monitoring-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10Q ENTERPRISE MONITORING REPORT",
  "======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Monitoring Engine Exists: " + report.files.monitoringEngineExists,
  "Metrics Collector Exists: " + report.files.metricsCollectorExists,
  "Alert Manager Exists: " + report.files.alertManagerExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Metrics Generated: " + report.tests.metricsGenerated,
  "Alerts Generated: " + report.tests.alertsGenerated,
  "Readiness Generated: " + report.tests.readinessGenerated,
  "Industrial Court/PERKESO Monitoring: " + report.tests.specialMonitoringIncluded,
  "Monitoring Health Score: " + health.healthScore,
  "Monitoring Status: " + health.status
];

fs.writeFileSync(path.join(reports, "phase10Q-monitoring-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

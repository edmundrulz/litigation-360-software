const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const frontendSrc = path.join(root, "frontend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "enterpriseOperationsCommandCentre.js");
const routePath = path.join(src, "routes", "enterpriseOperationsRoutes.js");
const indexPath = path.join(src, "index.js");
const apiPath = path.join(frontendSrc, "enterprise", "api", "enterpriseOperationsApi.js");
const pagePath = path.join(frontendSrc, "enterprise", "pages", "EnterpriseOperationsCommandCentre.jsx");

if (!fs.existsSync(enginePath)) {
  console.log("Enterprise Operations Command Centre missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const dashboard = engine.generateOperationsDashboard();
const alerts = engine.getOperationsAlerts();
const health = engine.getOperationsHealth();
const indexText = fs.readFileSync(indexPath, "utf8");
const pageText = fs.existsSync(pagePath) ? fs.readFileSync(pagePath, "utf8") : "";

const validation = {
  phase: "10Z.0",
  module: "Enterprise Operations Command Centre",
  timestamp: new Date().toISOString(),
  files: {
    commandCentreExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseOperationsRoutes"),
    frontendApiExists: fs.existsSync(apiPath),
    frontendPageExists: fs.existsSync(pagePath)
  },
  tests: {
    operationsDashboardGenerated: !!dashboard.summary,
    courtPanelPresent: !!dashboard.courts,
    industrialCourtPanelPresent: !!dashboard.industrialCourt && JSON.stringify(dashboard.industrialCourt).includes("Industrial Court Kuala Lumpur"),
    perkesoPanelPresent: !!dashboard.perkeso && JSON.stringify(dashboard.perkeso).includes("PERKESO"),
    deploymentPanelPresent: !!dashboard.deployment,
    executiveAlertsPresent: Array.isArray(dashboard.executiveAlerts),
    realtimeRefreshPresent: pageText.includes("setInterval") && pageText.includes("30000"),
    healthGenerated: !!health.status,
    alertsGenerated: Array.isArray(alerts.alerts)
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseOperationsRoutes") &&
    fs.existsSync(apiPath) &&
    fs.existsSync(pagePath) &&
    !!dashboard.summary &&
    !!dashboard.courts &&
    !!dashboard.industrialCourt &&
    JSON.stringify(dashboard.industrialCourt).includes("Industrial Court Kuala Lumpur") &&
    !!dashboard.perkeso &&
    JSON.stringify(dashboard.perkeso).includes("PERKESO") &&
    !!dashboard.deployment &&
    Array.isArray(dashboard.executiveAlerts) &&
    pageText.includes("setInterval") &&
    pageText.includes("30000") &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10Z0-enterprise-operations-command-centre-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10Z.0 ENTERPRISE OPERATIONS COMMAND CENTRE REPORT",
  "======================================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Command Centre Exists: " + validation.files.commandCentreExists,
  "Routes Exist: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Frontend API Exists: " + validation.files.frontendApiExists,
  "Frontend Page Exists: " + validation.files.frontendPageExists,
  "Operations Dashboard Generated: " + validation.tests.operationsDashboardGenerated,
  "Court Panel Present: " + validation.tests.courtPanelPresent,
  "Industrial Court Panel Present: " + validation.tests.industrialCourtPanelPresent,
  "PERKESO Panel Present: " + validation.tests.perkesoPanelPresent,
  "Deployment Panel Present: " + validation.tests.deploymentPanelPresent,
  "Executive Alerts Present: " + validation.tests.executiveAlertsPresent,
  "Realtime Refresh Present: " + validation.tests.realtimeRefreshPresent,
  "Health Generated: " + validation.tests.healthGenerated
].join("\n"));

if (validation.status !== "PASS") process.exit(1);

const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const frontendSrc = path.join(root, "frontend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "executiveDeploymentDashboardEngine.js");
const routePath = path.join(src, "routes", "executiveDeploymentDashboardRoutes.js");
const apiPath = path.join(frontendSrc, "enterprise", "api", "deploymentDashboardApi.js");
const pagePath = path.join(frontendSrc, "enterprise", "pages", "ExecutiveDeploymentDashboard.jsx");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Executive Deployment Dashboard Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const dashboard = engine.generateExecutiveDeploymentDashboard();
const summary = engine.getExecutiveDeploymentSummary();
const health = engine.getExecutiveDeploymentHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10X.5",
  module: "Executive Deployment Dashboard",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("executiveDeploymentDashboardRoutes"),
    frontendApiExists: fs.existsSync(apiPath),
    frontendPageExists: fs.existsSync(pagePath)
  },
  tests: {
    dashboardGenerated: !!dashboard.executiveSummary,
    summaryGenerated: !!summary.plainEnglish,
    healthGenerated: !!health.status,
    specialCoverageIncluded: JSON.stringify(dashboard).includes("industrialCourtKualaLumpur")
  },
  health,
  summary,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("executiveDeploymentDashboardRoutes") &&
    fs.existsSync(apiPath) &&
    fs.existsSync(pagePath) &&
    !!dashboard.executiveSummary &&
    !!summary.plainEnglish &&
    !!health.status &&
    JSON.stringify(dashboard).includes("industrialCourtKualaLumpur")
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X5-executive-deployment-dashboard-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.5 EXECUTIVE DEPLOYMENT DASHBOARD REPORT",
  "=================================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Frontend API Exists: " + report.files.frontendApiExists,
  "Frontend Page Exists: " + report.files.frontendPageExists,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Summary Generated: " + report.tests.summaryGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Special Coverage Included: " + report.tests.specialCoverageIncluded,
  "Dashboard Status: " + dashboard.status,
  "Overall Score: " + summary.overallScore,
  "Enterprise Grade: " + summary.enterpriseGrade,
  "Risk: " + summary.risk
].join("\n"));

if (report.status !== "PASS") process.exit(1);

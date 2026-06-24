const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "deploymentReadinessCentre.js");
const routePath = path.join(src, "routes", "deploymentReadinessCentreRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Deployment Readiness Centre missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const baseline = engine.loadBaseline();
const readiness = engine.calculateDeploymentReadiness();
const dashboard = engine.getDeploymentDashboard();
const summary = engine.getExecutiveDeploymentSummary();
const health = engine.getDeploymentCentreHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10X.1",
  module: "Deployment Readiness Centre",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("deploymentReadinessCentreRoutes")
  },
  tests: {
    baselineLoaded: !!baseline.master,
    readinessGenerated: typeof readiness.deploymentScore === "number",
    dashboardGenerated: !!dashboard.summary,
    summaryGenerated: !!summary.plainEnglish,
    healthGenerated: !!health.status
  },
  readiness,
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("deploymentReadinessCentreRoutes") &&
    !!baseline.master &&
    typeof readiness.deploymentScore === "number" &&
    !!dashboard.summary &&
    !!summary.plainEnglish &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X1-deployment-readiness-centre-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.1 DEPLOYMENT READINESS CENTRE REPORT",
  "==============================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Baseline Loaded: " + report.tests.baselineLoaded,
  "Readiness Generated: " + report.tests.readinessGenerated,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Executive Summary Generated: " + report.tests.summaryGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Deployment Status: " + readiness.status,
  "Deployment Ready: " + readiness.deploymentReady,
  "Deployment Score: " + readiness.deploymentScore,
  "Risk Level: " + readiness.riskLevel,
  "Blocking Issues: " + readiness.blockingIssuesCount,
  "Warnings: " + readiness.warningsCount
].join("\n"));

if (report.status !== "PASS") process.exit(1);

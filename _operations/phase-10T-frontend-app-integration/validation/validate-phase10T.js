const fs = require("fs");
const path = require("path");

const app = process.env.L360_APP_FILE;
const dashboard = process.env.L360_DASHBOARD_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10T",
  module: "Frontend App Integration",
  timestamp: new Date().toISOString(),
  files: {
    appExists: fs.existsSync(app),
    dashboardExists: fs.existsSync(dashboard)
  },
  content: {
    appImportsDashboard: has(app, "EnterpriseOperationsDashboard"),
    appHasEnterpriseButton: has(app, "Enterprise Dashboard"),
    appHasPhaseMarker: has(app, "Phase 10T")
  }
};

report.status = (
  report.files.appExists &&
  report.files.dashboardExists &&
  report.content.appImportsDashboard &&
  report.content.appHasEnterpriseButton &&
  report.content.appHasPhaseMarker
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10T-frontend-app-integration-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10T FRONTEND APP INTEGRATION REPORT",
  "=========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "App Exists: " + report.files.appExists,
  "Dashboard Exists: " + report.files.dashboardExists,
  "App Imports Dashboard: " + report.content.appImportsDashboard,
  "Enterprise Button Present: " + report.content.appHasEnterpriseButton,
  "Phase Marker Present: " + report.content.appHasPhaseMarker
].join("\n"));

if (report.status !== "PASS") process.exit(1);

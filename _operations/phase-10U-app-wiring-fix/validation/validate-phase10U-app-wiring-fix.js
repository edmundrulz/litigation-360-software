const fs = require("fs");
const path = require("path");

const app = process.env.L360_APP_FILE;
const dashboard = process.env.L360_DASHBOARD_FILE;
const connectivity = process.env.L360_CONNECTIVITY_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10U-APP-WIRING-FIX",
  timestamp: new Date().toISOString(),
  files: {
    appExists: fs.existsSync(app),
    dashboardExists: fs.existsSync(dashboard),
    connectivityExists: fs.existsSync(connectivity)
  },
  content: {
    appImportsDashboard: has(app, "EnterpriseOperationsDashboard"),
    appImportsConnectivity: has(app, "FrontendBackendConnectivityValidator"),
    appHasConnectivityButton: has(app, "Connectivity Validator"),
    appHasEnterpriseButton: has(app, "Enterprise Dashboard"),
    appHasPhaseMarker: has(app, "Phase 10U")
  }
};

report.status = (
  report.files.appExists &&
  report.files.dashboardExists &&
  report.files.connectivityExists &&
  report.content.appImportsDashboard &&
  report.content.appImportsConnectivity &&
  report.content.appHasConnectivityButton &&
  report.content.appHasEnterpriseButton &&
  report.content.appHasPhaseMarker
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10U-app-wiring-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10U APP WIRING FIX REPORT",
  "================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "App Exists: " + report.files.appExists,
  "Dashboard Exists: " + report.files.dashboardExists,
  "Connectivity Exists: " + report.files.connectivityExists,
  "App Imports Dashboard: " + report.content.appImportsDashboard,
  "App Imports Connectivity: " + report.content.appImportsConnectivity,
  "Connectivity Button Present: " + report.content.appHasConnectivityButton,
  "Enterprise Button Present: " + report.content.appHasEnterpriseButton,
  "Phase Marker Present: " + report.content.appHasPhaseMarker
].join("\\n"));

if (report.status !== "PASS") process.exit(1);

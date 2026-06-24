const fs = require("fs");
const path = require("path");

const api = process.env.L360_CONNECTIVITY_API;
const panel = process.env.L360_CONNECTIVITY_PANEL;
const page = process.env.L360_CONNECTIVITY_PAGE;
const app = process.env.L360_APP_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10U",
  module: "Frontend Backend Connectivity Validator",
  timestamp: new Date().toISOString(),
  files: {
    apiExists: fs.existsSync(api),
    panelExists: fs.existsSync(panel),
    pageExists: fs.existsSync(page),
    appExists: fs.existsSync(app)
  },
  content: {
    apiHasMonitoring: has(api, "/api/enterprise/monitoring/health"),
    apiHasMaps: has(api, "/api/enterprise/maps/health"),
    apiHasDocuments: has(api, "/api/enterprise/documents/lifecycle/health"),
    pageHasAutoRefresh: has(page, "setInterval"),
    pageHasIndustrialCourt: has(page, "Industrial Court Kuala Lumpur"),
    appHasConnectivity: has(app, "Connectivity Validator")
  }
};

report.status = (
  report.files.apiExists &&
  report.files.panelExists &&
  report.files.pageExists &&
  report.files.appExists &&
  report.content.apiHasMonitoring &&
  report.content.apiHasMaps &&
  report.content.apiHasDocuments &&
  report.content.pageHasAutoRefresh &&
  report.content.pageHasIndustrialCourt &&
  report.content.appHasConnectivity
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10U-connectivity-validator-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10U CONNECTIVITY VALIDATOR REPORT",
  "=======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "API Exists: " + report.files.apiExists,
  "Panel Exists: " + report.files.panelExists,
  "Page Exists: " + report.files.pageExists,
  "App Exists: " + report.files.appExists,
  "Monitoring Endpoint Present: " + report.content.apiHasMonitoring,
  "Maps Endpoint Present: " + report.content.apiHasMaps,
  "Documents Endpoint Present: " + report.content.apiHasDocuments,
  "Auto Refresh Present: " + report.content.pageHasAutoRefresh,
  "Industrial Court Present: " + report.content.pageHasIndustrialCourt,
  "App Connectivity Button Present: " + report.content.appHasConnectivity
].join("\n"));

if (report.status !== "PASS") process.exit(1);

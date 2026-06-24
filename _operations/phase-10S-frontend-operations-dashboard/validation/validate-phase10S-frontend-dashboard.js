const fs = require("fs");
const path = require("path");

const root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software".replace(/\\\\/g, "\\\\");
const frontend = path.join(root, "frontend");
const reports = path.join(root, "_operations", "phase-10S-frontend-operations-dashboard", "reports");

fs.mkdirSync(reports, { recursive: true });

const files = {
  api: path.join(frontend, "src", "enterprise", "api", "enterpriseApi.js"),
  card: path.join(frontend, "src", "enterprise", "components", "EnterpriseStatusCard.jsx"),
  page: path.join(frontend, "src", "enterprise", "pages", "EnterpriseOperationsDashboard.jsx")
};

const report = {
  phase: "10S",
  module: "Frontend Operations Dashboard",
  timestamp: new Date().toISOString(),
  files: {
    apiExists: fs.existsSync(files.api),
    cardExists: fs.existsSync(files.card),
    pageExists: fs.existsSync(files.page)
  },
  content: {
    apiHasMonitoringEndpoint: fs.existsSync(files.api) && fs.readFileSync(files.api, "utf8").includes("/api/enterprise/monitoring/health"),
    pageHasAutoRefresh: fs.existsSync(files.page) && fs.readFileSync(files.page, "utf8").includes("setInterval"),
    pageHasIndustrialCourt: fs.existsSync(files.page) && fs.readFileSync(files.page, "utf8").includes("Industrial Court Kuala Lumpur"),
    pageHasPERKESO: fs.existsSync(files.page) && fs.readFileSync(files.page, "utf8").includes("PERKESO")
  }
};

report.status = (
  report.files.apiExists &&
  report.files.cardExists &&
  report.files.pageExists &&
  report.content.apiHasMonitoringEndpoint &&
  report.content.pageHasAutoRefresh &&
  report.content.pageHasIndustrialCourt &&
  report.content.pageHasPERKESO
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10S-frontend-dashboard-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10S FRONTEND DASHBOARD REPORT",
  "===================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "API File Exists: " + report.files.apiExists,
  "Card Component Exists: " + report.files.cardExists,
  "Dashboard Page Exists: " + report.files.pageExists,
  "Monitoring Endpoint Present: " + report.content.apiHasMonitoringEndpoint,
  "Auto Refresh Present: " + report.content.pageHasAutoRefresh,
  "Industrial Court Present: " + report.content.pageHasIndustrialCourt,
  "PERKESO Present: " + report.content.pageHasPERKESO
].join("\\n"));

if (report.status !== "PASS") process.exit(1);

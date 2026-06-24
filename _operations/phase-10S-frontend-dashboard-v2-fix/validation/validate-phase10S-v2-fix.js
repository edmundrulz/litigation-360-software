const fs = require("fs");
const path = require("path");

const api = process.env.L360_API_FILE;
const card = process.env.L360_CARD_FILE;
const page = process.env.L360_PAGE_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10S-V2-FIX",
  timestamp: new Date().toISOString(),
  files: {
    apiExists: fs.existsSync(api),
    cardExists: fs.existsSync(card),
    pageExists: fs.existsSync(page)
  },
  content: {
    monitoringEndpoint: has(api, "/api/enterprise/monitoring/health"),
    performanceEndpoint: has(api, "/api/enterprise/performance/benchmark"),
    autoRefresh: has(page, "setInterval"),
    industrialCourt: has(page, "Industrial Court Kuala Lumpur"),
    perkeso: has(page, "PERKESO"),
    cardLogic: has(card, "normalized")
  }
};

report.status =
  report.files.apiExists &&
  report.files.cardExists &&
  report.files.pageExists &&
  report.content.monitoringEndpoint &&
  report.content.performanceEndpoint &&
  report.content.autoRefresh &&
  report.content.industrialCourt &&
  report.content.perkeso &&
  report.content.cardLogic
    ? "PASS"
    : "FAIL";

fs.writeFileSync(path.join(reports, "phase10S-v2-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10S FRONTEND DASHBOARD V2 FIX REPORT",
  "==========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "API File Exists: " + report.files.apiExists,
  "Card Component Exists: " + report.files.cardExists,
  "Dashboard Page Exists: " + report.files.pageExists,
  "Monitoring Endpoint Present: " + report.content.monitoringEndpoint,
  "Performance Endpoint Present: " + report.content.performanceEndpoint,
  "Auto Refresh Present: " + report.content.autoRefresh,
  "Industrial Court Present: " + report.content.industrialCourt,
  "PERKESO Present: " + report.content.perkeso,
  "Card Logic Present: " + report.content.cardLogic
].join("\n"));

if (report.status !== "PASS") process.exit(1);

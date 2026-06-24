const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10H-executive-command-centre", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "executiveCommandCentre.js");
const routePath = path.join(srcRoot, "routes", "executiveCommandRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Executive Command Centre missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const dashboard = engine.generateExecutiveDashboard();
const health = engine.getExecutiveCommandHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10H",
  module: "Executive Command Centre",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("executiveCommandRoutes")
  },
  dashboard: {
    enterpriseStatus: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    moduleHealthPanels: dashboard.moduleHealth.length,
    riskItems: dashboard.riskItems.length,
    hasSummary: !!dashboard.executiveSummary,
    hasPanels: !!dashboard.panels
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("executiveCommandRoutes") &&
    !!dashboard.enterpriseStatus &&
    typeof dashboard.enterpriseScore === "number" &&
    dashboard.moduleHealth.length >= 7 &&
    !!dashboard.executiveSummary &&
    !!dashboard.panels
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10H-executive-command-centre-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10H EXECUTIVE COMMAND CENTRE REPORT",
  "==========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Enterprise Score: " + report.dashboard.enterpriseScore,
  "Enterprise Status: " + report.dashboard.enterpriseStatus,
  "Module Health Panels: " + report.dashboard.moduleHealthPanels,
  "Risk Items: " + report.dashboard.riskItems,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10H-executive-command-centre-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

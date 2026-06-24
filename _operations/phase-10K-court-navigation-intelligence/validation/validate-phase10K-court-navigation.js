const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10K-court-navigation-intelligence", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "courtNavigationEngine.js");
const routePath = path.join(srcRoot, "routes", "courtNavigationRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Court Navigation Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
engine.resetNavigationForTestOnly();

const courts = engine.listCourts();
const readiness = engine.checkCourtReadinessForMatter("MATTER-VALIDATION-10K");
const dashboard = engine.generateNavigationDashboard();
const health = engine.getNavigationHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10K",
  module: "Court Navigation Intelligence",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("courtNavigationRoutes")
  },
  tests: {
    courtsSeeded: courts.length >= 3,
    readinessGenerated: !!readiness.status,
    dashboardGenerated: !!dashboard.status,
    healthGenerated: !!health.status
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("courtNavigationRoutes") &&
    courts.length >= 3 &&
    !!readiness.status &&
    !!dashboard.status &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10K-court-navigation-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10K COURT NAVIGATION INTELLIGENCE REPORT",
  "==============================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Courts Seeded: " + report.tests.courtsSeeded,
  "Readiness Generated: " + report.tests.readinessGenerated,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10K-court-navigation-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10L-maps-restore", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "mapsIntegrationLayer.js");
const routePath = path.join(src, "routes", "mapsIntegrationRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Maps Integration Layer missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
engine.resetMapsForTestOnly();

const google = engine.generateGoogleMapsLink({ destination: "Wisma PERKESO, 155 Jalan Tun Razak, Kuala Lumpur", origin: "Petaling Jaya" });
const waze = engine.generateWazeLink({ query: "Wisma PERKESO, 155 Jalan Tun Razak, Kuala Lumpur" });
const court = engine.generateCourtMapLinks("Industrial Court Kuala Lumpur", "Petaling Jaya");
const dashboard = engine.generateMapsDashboard();
const health = engine.getMapsHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10L-RESTORE",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("mapsIntegrationRoutes")
  },
  tests: {
    googleLinkGenerated: google.includes("google.com/maps"),
    wazeLinkGenerated: waze.includes("waze.com"),
    courtMapGenerated: court.ok === true,
    dashboardGenerated: !!dashboard.status,
    healthGenerated: !!health.status
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("mapsIntegrationRoutes") &&
    google.includes("google.com/maps") &&
    waze.includes("waze.com") &&
    court.ok === true &&
    !!dashboard.status &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10L-restore-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10L MAPS RESTORE REPORT",
  "================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Google Link Generated: " + report.tests.googleLinkGenerated,
  "Waze Link Generated: " + report.tests.wazeLinkGenerated,
  "Court Map Generated: " + report.tests.courtMapGenerated,
  "Health Status: " + health.status
].join("\n"));

if (report.status !== "PASS") process.exit(1);

const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10J-predictive-litigation-analytics", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "predictiveAnalyticsEngine.js");
const routePath = path.join(srcRoot, "routes", "predictiveAnalyticsRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Predictive Analytics Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const dashboard = engine.generatePredictiveDashboard();
const matter = engine.forecastMatter("MATTER-VALIDATION-10J");
const deadlines = engine.forecastDeadlines();
const workload = engine.forecastWorkload();
const capacity = engine.forecastCapacity();
const health = engine.getPredictiveHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10J",
  module: "Predictive Litigation Analytics Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("predictiveAnalyticsRoutes")
  },
  tests: {
    dashboardGenerated: !!dashboard.status,
    matterForecastGenerated: !!matter.predictedRisk,
    deadlineForecastGenerated: !!deadlines.predictedDeadlineFailureRisk,
    workloadForecastGenerated: !!workload.predictedOverloadRisk,
    capacityForecastGenerated: !!capacity.predictedCapacityStatus
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("predictiveAnalyticsRoutes") &&
    !!dashboard.status &&
    !!matter.predictedRisk &&
    !!deadlines.predictedDeadlineFailureRisk &&
    !!workload.predictedOverloadRisk &&
    !!capacity.predictedCapacityStatus
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10J-predictive-analytics-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10J PREDICTIVE LITIGATION ANALYTICS REPORT",
  "================================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Matter Forecast Generated: " + report.tests.matterForecastGenerated,
  "Deadline Forecast Generated: " + report.tests.deadlineForecastGenerated,
  "Workload Forecast Generated: " + report.tests.workloadForecastGenerated,
  "Capacity Forecast Generated: " + report.tests.capacityForecastGenerated,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10J-predictive-analytics-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

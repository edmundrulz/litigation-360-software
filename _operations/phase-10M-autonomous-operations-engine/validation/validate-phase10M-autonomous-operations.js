const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10M-autonomous-operations-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "autonomousOperationsEngine.js");
const routePath = path.join(srcRoot, "routes", "autonomousOperationsRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Autonomous Operations Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

async function run() {
  engine.resetAutonomousForTestOnly();

  const cycle = await engine.runAutonomousCycle({ executeSafeActions: false });
  const dashboard = engine.getAutonomousDashboard();
  const health = engine.getAutonomousHealth();
  const metrics = engine.getAutonomousMetrics();
  const rules = engine.getRules();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10M",
    module: "Autonomous Operations Engine",
    timestamp: new Date().toISOString(),
    files: {
      engineExists: fs.existsSync(enginePath),
      routeExists: fs.existsSync(routePath),
      routeMountedInIndex: indexText.includes("autonomousOperationsRoutes")
    },
    tests: {
      cycleRan: !!cycle.status,
      dashboardGenerated: !!dashboard.status,
      healthGenerated: !!health.status,
      rulesAvailable: rules.length >= 6,
      metricsGenerated: typeof metrics.cyclesRun === "number"
    },
    health,
    metrics,
    status: (
      fs.existsSync(enginePath) &&
      fs.existsSync(routePath) &&
      indexText.includes("autonomousOperationsRoutes") &&
      !!cycle.status &&
      !!dashboard.status &&
      !!health.status &&
      rules.length >= 6 &&
      typeof metrics.cyclesRun === "number"
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10M-autonomous-operations-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10M AUTONOMOUS OPERATIONS ENGINE REPORT",
    "=============================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Engine Exists: " + report.files.engineExists,
    "Route Exists: " + report.files.routeExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Cycle Ran: " + report.tests.cycleRan,
    "Dashboard Generated: " + report.tests.dashboardGenerated,
    "Health Generated: " + report.tests.healthGenerated,
    "Rules Available: " + report.tests.rulesAvailable,
    "Cycles Run: " + metrics.cyclesRun,
    "Decisions Made: " + metrics.decisionsMade,
    "Actions Created: " + metrics.actionsCreated,
    "Escalations Created: " + metrics.escalationsCreated,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10M-autonomous-operations-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});

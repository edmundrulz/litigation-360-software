const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10B-universal-event-bus", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const indexPath = path.join(srcRoot, "index.js");
const eventBusPath = path.join(srcRoot, "automation", "eventBus.js");
const eventRoutesPath = path.join(srcRoot, "routes", "eventBusRoutes.js");

if (!fs.existsSync(eventBusPath)) {
  console.log("Event Bus file missing. Run APPLY mode.");
  process.exit(1);
}

const eventBus = require(eventBusPath);

async function run() {
  eventBus.resetEventBusForTestOnly();

  const handled = await eventBus.emitEvent("CLIENT_CREATED", { testClientName: "Phase 10B Validation Client" }, { source: "phase10BValidation" });
  const unhandled = await eventBus.emitEvent("UNKNOWN_EVENT_TYPE", { test: true }, { source: "phase10BValidation" });

  const metrics = eventBus.getEventMetrics();
  const health = eventBus.getEventBusHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10B",
    module: "Universal Event Bus",
    timestamp: new Date().toISOString(),
    files: {
      eventBusExists: fs.existsSync(eventBusPath),
      eventBusRoutesExists: fs.existsSync(eventRoutesPath),
      routeMountedInIndex: indexText.includes("eventBusRoutes")
    },
    handledTest: { ok: handled.ok, status: handled.status, eventType: handled.event.eventType },
    unhandledTest: { ok: unhandled.ok, status: unhandled.status, eventType: unhandled.event.eventType },
    metrics,
    health,
    status: (
      fs.existsSync(eventBusPath) &&
      fs.existsSync(eventRoutesPath) &&
      indexText.includes("eventBusRoutes") &&
      handled.ok === true &&
      handled.status === "HANDLED" &&
      unhandled.ok === false &&
      unhandled.status === "UNHANDLED" &&
      metrics.emitted === 2 &&
      metrics.handled === 1 &&
      metrics.unhandled === 1
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10B-event-bus-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10B UNIVERSAL EVENT BUS REPORT",
    "=====================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Event Bus File Exists: " + report.files.eventBusExists,
    "Event Routes File Exists: " + report.files.eventBusRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Handled Test: " + report.handledTest.status,
    "Unhandled Test: " + report.unhandledTest.status,
    "Metrics Emitted: " + metrics.emitted,
    "Metrics Handled: " + metrics.handled,
    "Metrics Failed: " + metrics.failed,
    "Metrics Unhandled: " + metrics.unhandled,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10B-event-bus-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});

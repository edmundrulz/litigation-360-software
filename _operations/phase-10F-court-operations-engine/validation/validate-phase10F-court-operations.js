const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10F-court-operations-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const courtPath = path.join(srcRoot, "automation", "courtOperationsEngine.js");
const courtRoutesPath = path.join(srcRoot, "routes", "courtOperationsRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(courtPath)) {
  console.log("Court Operations Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(courtPath);

async function run() {
  engine.resetCourtOperationsForTestOnly();

  const future = new Date();
  future.setDate(future.getDate() + 30);

  const courtEvent = engine.createCourtDate({
    matterId: "MATTER-VALIDATION-10F",
    caseTitle: "Phase 10F Validation Case",
    courtName: "Validation High Court",
    courtAddress: "Validation Address",
    courtRoom: "Validation Room",
    eventType: "HEARING",
    eventDate: future.toISOString(),
    eventTime: "09:00",
    assignedTo: "VALIDATION"
  });

  const workflowResult = await engine.startCourtPreparationWorkflow(courtEvent.id, "VALIDATION");
  const metrics = engine.getCourtOperationsMetrics();
  const health = engine.getCourtOperationsHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10F",
    module: "Court Operations Engine",
    timestamp: new Date().toISOString(),
    files: {
      courtOperationsEngineExists: fs.existsSync(courtPath),
      courtOperationsRoutesExists: fs.existsSync(courtRoutesPath),
      routeMountedInIndex: indexText.includes("courtOperationsRoutes")
    },
    tests: {
      courtEventCreated: !!courtEvent.id,
      deadlinesGenerated: courtEvent.deadlines.length,
      remindersGenerated: courtEvent.reminders.length,
      tasksGenerated: courtEvent.tasks.length,
      workflowStarted: workflowResult.ok === true
    },
    metrics,
    health,
    status: (
      fs.existsSync(courtPath) &&
      fs.existsSync(courtRoutesPath) &&
      indexText.includes("courtOperationsRoutes") &&
      !!courtEvent.id &&
      courtEvent.deadlines.length >= 3 &&
      courtEvent.reminders.length >= 4 &&
      courtEvent.tasks.length >= 5 &&
      workflowResult.ok === true &&
      metrics.courtDatesCreated === 1 &&
      metrics.workflowsStarted === 1 &&
      metrics.overdue === 0
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10F-court-operations-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10F COURT OPERATIONS ENGINE REPORT",
    "=========================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Court Operations Engine Exists: " + report.files.courtOperationsEngineExists,
    "Court Operations Routes Exists: " + report.files.courtOperationsRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Court Event Created: " + report.tests.courtEventCreated,
    "Deadlines Generated: " + report.tests.deadlinesGenerated,
    "Reminders Generated: " + report.tests.remindersGenerated,
    "Tasks Generated: " + report.tests.tasksGenerated,
    "Workflow Started: " + report.tests.workflowStarted,
    "Metrics Court Dates Created: " + metrics.courtDatesCreated,
    "Metrics Deadlines Generated: " + metrics.deadlinesGenerated,
    "Metrics Reminders Generated: " + metrics.remindersGenerated,
    "Metrics Tasks Generated: " + metrics.tasksGenerated,
    "Metrics Workflows Started: " + metrics.workflowsStarted,
    "Metrics Upcoming: " + metrics.upcoming,
    "Metrics Overdue: " + metrics.overdue,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10F-court-operations-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});

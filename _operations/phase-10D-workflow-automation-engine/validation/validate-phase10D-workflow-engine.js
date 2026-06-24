const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10D-workflow-automation-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const workflowPath = path.join(srcRoot, "automation", "workflowEngine.js");
const workflowRoutesPath = path.join(srcRoot, "routes", "workflowRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(workflowPath)) {
  console.log("Workflow Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const workflowEngine = require(workflowPath);

async function run() {
  workflowEngine.resetWorkflowsForTestOnly();

  const workflow = workflowEngine.createWorkflow({
    workflowType: "NEW_CLIENT_INTAKE",
    title: "Phase 10D Validation Workflow",
    payload: { test: true },
    context: { source: "phase10DValidation" }
  });

  const startResult = await workflowEngine.startWorkflow(workflow.id);
  const stepResult = await workflowEngine.completeCurrentStep(workflow.id, "First validation step completed");
  const metrics = workflowEngine.getWorkflowMetrics();
  const health = workflowEngine.getWorkflowHealth();
  const templates = workflowEngine.getWorkflowTemplates();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10D",
    module: "Workflow Automation Engine",
    timestamp: new Date().toISOString(),
    files: {
      workflowEngineExists: fs.existsSync(workflowPath),
      workflowRoutesExists: fs.existsSync(workflowRoutesPath),
      routeMountedInIndex: indexText.includes("workflowRoutes")
    },
    tests: {
      workflowCreated: !!workflow.id,
      workflowStarted: startResult.ok === true,
      stepCompleted: stepResult.ok === true,
      templatesAvailable: Object.keys(templates).length
    },
    metrics,
    health,
    status: (
      fs.existsSync(workflowPath) &&
      fs.existsSync(workflowRoutesPath) &&
      indexText.includes("workflowRoutes") &&
      !!workflow.id &&
      startResult.ok === true &&
      stepResult.ok === true &&
      metrics.created === 1 &&
      metrics.started === 1 &&
      metrics.active === 1 &&
      Object.keys(templates).length >= 4
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10D-workflow-engine-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10D WORKFLOW AUTOMATION ENGINE REPORT",
    "============================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Workflow Engine Exists: " + report.files.workflowEngineExists,
    "Workflow Routes Exists: " + report.files.workflowRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Workflow Created: " + report.tests.workflowCreated,
    "Workflow Started: " + report.tests.workflowStarted,
    "Step Completed: " + report.tests.stepCompleted,
    "Templates Available: " + report.tests.templatesAvailable,
    "Metrics Created: " + metrics.created,
    "Metrics Started: " + metrics.started,
    "Metrics Active: " + metrics.active,
    "Metrics Completed: " + metrics.completed,
    "Metrics Failed: " + metrics.failed,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10D-workflow-engine-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});

const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
const decisions = process.env.L360_DECISIONS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "deploymentGatekeeperEngine.js");
const routePath = path.join(src, "routes", "deploymentGatekeeperRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Deployment Gatekeeper Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
const evaluation = engine.evaluateDeploymentGate();
const approval = engine.getGatekeeperApproval();
const rejection = engine.testRejectionLogic();
const health = engine.getGatekeeperHealth();
const report = engine.getGatekeeperReport();
const decision = engine.approveDeployment({ approver: "PHASE_10X6_VALIDATION", note: "Validation approval flow test" });
const indexText = fs.readFileSync(indexPath, "utf8");

const validation = {
  phase: "10X.6",
  module: "Enterprise Deployment Gatekeeper",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("deploymentGatekeeperRoutes")
  },
  tests: {
    deploymentDecisionGenerated: !!evaluation.status,
    approvalEndpointLogicPresent: !!approval.status,
    rejectionLogicWorking: rejection.passed === true,
    gatekeeperHealthGenerated: !!health.status,
    reportGenerated: !!report.status,
    decisionHistoryGenerated: fs.existsSync(path.join(decisions, "latest-decision.json")),
    approveFlowGeneratedDecision: !!decision.decisionId
  },
  health,
  evaluation,
  approval,
  rejection,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("deploymentGatekeeperRoutes") &&
    !!evaluation.status &&
    !!approval.status &&
    rejection.passed === true &&
    !!health.status &&
    !!report.status &&
    fs.existsSync(path.join(decisions, "latest-decision.json")) &&
    !!decision.decisionId
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X6-deployment-gatekeeper-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.6 DEPLOYMENT GATEKEEPER REPORT",
  "========================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Engine Exists: " + validation.files.engineExists,
  "Route Exists: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Deployment Decision Generated: " + validation.tests.deploymentDecisionGenerated,
  "Approval Logic Present: " + validation.tests.approvalEndpointLogicPresent,
  "Rejection Logic Working: " + validation.tests.rejectionLogicWorking,
  "Gatekeeper Health Generated: " + validation.tests.gatekeeperHealthGenerated,
  "Report Generated: " + validation.tests.reportGenerated,
  "Decision History Generated: " + validation.tests.decisionHistoryGenerated,
  "Approve Flow Generated Decision: " + validation.tests.approveFlowGeneratedDecision,
  "Gatekeeper Status: " + evaluation.status,
  "Deployment Approved: " + evaluation.deploymentApproved,
  "Overall Score: " + evaluation.overallScore,
  "Enterprise Grade: " + evaluation.enterpriseGrade,
  "Risk: " + evaluation.risk,
  "Blockers: " + evaluation.blockerCount,
  "Warnings: " + evaluation.warningCount
].join("\n"));

if (validation.status !== "PASS") process.exit(1);

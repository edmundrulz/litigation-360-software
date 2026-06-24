const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10N-enterprise-governance", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "enterpriseGovernanceEngine.js");
const routePath = path.join(srcRoot, "routes", "enterpriseGovernanceRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Enterprise Governance Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
engine.resetGovernanceForTestOnly();

const approval = engine.createApprovalRequest({
  approvalType: "MATTER_CLOSURE",
  title: "Phase 10N Validation Approval",
  requestedBy: "VALIDATION",
  matterId: "MATTER-VALIDATION-10N",
  reason: "Validation test"
});
const approved = engine.approveRequest(approval.id, { approvedBy: "VALIDATION_APPROVER", note: "Approved during validation" });
const compliance = engine.runComplianceCheck();
const dashboard = engine.getGovernanceDashboard();
const health = engine.getGovernanceHealth();
const policies = engine.getPolicies();
const metrics = engine.getGovernanceMetrics();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10N",
  module: "Enterprise Governance Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseGovernanceRoutes")
  },
  tests: {
    approvalCreated: !!approval.id,
    approvalApproved: approved.ok === true,
    evidenceGenerated: !!approved.evidence?.evidenceHash,
    complianceRan: compliance.ok === true,
    dashboardGenerated: !!dashboard.status,
    policiesAvailable: policies.length >= 5
  },
  metrics,
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseGovernanceRoutes") &&
    !!approval.id &&
    approved.ok === true &&
    !!approved.evidence?.evidenceHash &&
    compliance.ok === true &&
    !!dashboard.status &&
    policies.length >= 5
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10N-governance-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10N ENTERPRISE GOVERNANCE ENGINE REPORT",
  "============================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Approval Created: " + report.tests.approvalCreated,
  "Approval Approved: " + report.tests.approvalApproved,
  "Evidence Generated: " + report.tests.evidenceGenerated,
  "Compliance Ran: " + report.tests.complianceRan,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Policies Available: " + report.tests.policiesAvailable,
  "Governance Score: " + health.governanceScore,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10N-governance-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);

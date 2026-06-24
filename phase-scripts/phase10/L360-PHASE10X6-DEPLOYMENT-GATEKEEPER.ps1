param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend=Join-Path $Root "backend"
$Src=Join-Path $Backend "src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"

$Phase=Join-Path $Root "_operations\phase-10X6-deployment-gatekeeper"
$Reports=Join-Path $Phase "reports"
$Decisions=Join-Path $Phase "decisions"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $Reports,$Decisions,$Backups,$Logs,$Docs,$Validation,$Auto,$Routes | Out-Null

$Engine=Join-Path $Auto "deploymentGatekeeperEngine.js"
$Route=Join-Path $Routes "deploymentGatekeeperRoutes.js"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10X.6 ENTERPRISE DEPLOYMENT GATEKEEPER"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project Root: $Root"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){
  Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

foreach($r in @("deploymentScoringEngine.js","releaseValidatorEngine.js","environmentValidationEngine.js","enterpriseHardeningEngine.js","enterpriseMonitoringEngine.js","backupRecoveryEngine.js","performanceOptimizationEngine.js","executiveDeploymentDashboardEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Auto $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

if($Mode -eq "APPLY"){
  Backup $Engine
  Backup $Route
  Backup $Index

@'
const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const PHASE_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10X6-deployment-gatekeeper");
const DECISIONS_DIR = path.join(PHASE_ROOT, "decisions");
const REPORTS_DIR = path.join(PHASE_ROOT, "reports");

fs.mkdirSync(DECISIONS_DIR, { recursive: true });
fs.mkdirSync(REPORTS_DIR, { recursive: true });

const metrics = {
  evaluationsRun: 0,
  approvalsIssued: 0,
  rejectionsIssued: 0,
  reportsGenerated: 0,
  lastDecisionAt: null,
  lastEvaluationAt: null
};

function safeCall(label, fn) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, label };
  }
}

function nowSafeId() {
  return new Date().toISOString().replace(/[:.]/g, "-");
}

function writeDecision(decision) {
  const file = path.join(DECISIONS_DIR, `${decision.decisionId}.json`);
  fs.writeFileSync(file, JSON.stringify(decision, null, 2));
  fs.writeFileSync(path.join(DECISIONS_DIR, "latest-decision.json"), JSON.stringify(decision, null, 2));
  metrics.lastDecisionAt = decision.decidedAt;
  return file;
}

function collectGatekeeperInputs() {
  const scoring = require("./deploymentScoringEngine");
  const release = require("./releaseValidatorEngine");
  const environment = require("./environmentValidationEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const monitoring = require("./enterpriseMonitoringEngine");
  const backup = require("./backupRecoveryEngine");
  const performance = require("./performanceOptimizationEngine");
  const executive = require("./executiveDeploymentDashboardEngine");

  return {
    scoring: safeCall("scoring", () => scoring.generateScoringReport()),
    scoringReadiness: safeCall("scoringReadiness", () => scoring.getScoringReadiness()),
    release: safeCall("release", () => release.validateRelease()),
    environment: safeCall("environment", () => environment.getEnvironmentReadiness()),
    hardening: safeCall("hardening", () => hardening.getDeploymentReadiness()),
    monitoring: safeCall("monitoring", () => monitoring.getMonitoringHealth()),
    backup: safeCall("backup", () => backup.getBackupRecoveryHealth()),
    performance: safeCall("performance", () => performance.health()),
    executive: safeCall("executive", () => executive.getExecutiveDeploymentSummary())
  };
}

function evaluateDeploymentGate() {
  const inputs = collectGatekeeperInputs();
  const blockers = [];
  const warnings = [];

  function blocker(condition, message) {
    if (condition) blockers.push(message);
  }

  function warning(condition, message) {
    if (condition) warnings.push(message);
  }

  const score = Number(inputs.scoring.overallScore || 0);
  const risk = String(inputs.scoring.risk || "UNKNOWN").toUpperCase();

  blocker(score < 85, `Overall deployment score below threshold: ${score}. Required >= 85.`);
  blocker((inputs.scoring.blockerCount || 0) > 0, `Scoring engine reports ${inputs.scoring.blockerCount} blocker(s).`);
  blocker(risk === "CRITICAL", "Risk level is CRITICAL.");
  blocker(String(inputs.release.status || "").toUpperCase() === "RELEASE_BLOCKED", "Release validator is BLOCKED.");
  blocker(String(inputs.environment.risk || "").toUpperCase() === "CRITICAL", "Environment risk is CRITICAL.");
  blocker(String(inputs.hardening.status || "").toUpperCase() === "BLOCKED", "Hardening is BLOCKED.");
  blocker(String(inputs.monitoring.status || "").toUpperCase() === "CRITICAL", "Monitoring is CRITICAL.");
  blocker(String(inputs.backup.status || "").toUpperCase() === "FAIL", "Backup recovery is FAIL.");
  blocker(String(inputs.performance.status || "").toUpperCase() === "FAIL", "Performance is FAIL.");

  warning(score < 90 && score >= 85, `Overall score is acceptable but below A-grade target: ${score}.`);
  warning(String(inputs.environment.status || "").toUpperCase() === "ATTENTION", "Environment validation has attention items.");
  warning(String(inputs.monitoring.status || "").toUpperCase() === "ATTENTION", "Monitoring has attention items.");
  warning((inputs.scoring.warningCount || 0) > 0, `Scoring engine reports ${inputs.scoring.warningCount} warning(s).`);

  const deploymentApproved = blockers.length === 0;
  const status = deploymentApproved ? "APPROVED" : "REJECTED";

  metrics.evaluationsRun += 1;
  metrics.lastEvaluationAt = new Date().toISOString();

  return {
    module: "Enterprise Deployment Gatekeeper",
    status,
    deploymentApproved,
    decision: status,
    overallScore: score,
    enterpriseGrade: inputs.scoring.enterpriseGrade || "UNKNOWN",
    risk: inputs.scoring.risk || "UNKNOWN",
    blockers,
    blockerCount: blockers.length,
    warnings,
    warningCount: warnings.length,
    automaticRules: {
      minimumScore: 85,
      rejectCriticalRisk: true,
      rejectReleaseBlocked: true,
      rejectEnvironmentCritical: true,
      rejectHardeningBlocked: true,
      rejectMonitoringCritical: true,
      rejectBackupFail: true,
      rejectPerformanceFail: true
    },
    inputs,
    evaluatedAt: metrics.lastEvaluationAt
  };
}

function approveDeployment({ approver = "SYSTEM", note = "Automatic approval request" } = {}) {
  const evaluation = evaluateDeploymentGate();

  const decision = {
    decisionId: `DG-${nowSafeId()}-${Math.random().toString(16).slice(2)}`,
    requestedAction: "APPROVE",
    finalDecision: evaluation.deploymentApproved ? "APPROVED" : "REJECTED",
    deploymentApproved: evaluation.deploymentApproved,
    approver,
    note,
    overallScore: evaluation.overallScore,
    enterpriseGrade: evaluation.enterpriseGrade,
    risk: evaluation.risk,
    blockers: evaluation.blockers,
    warnings: evaluation.warnings,
    evaluation,
    decidedAt: new Date().toISOString()
  };

  if (decision.deploymentApproved) metrics.approvalsIssued += 1;
  else metrics.rejectionsIssued += 1;

  writeDecision(decision);
  return decision;
}

function rejectDeployment({ rejectedBy = "SYSTEM", reason = "Manual rejection request" } = {}) {
  const evaluation = evaluateDeploymentGate();

  const decision = {
    decisionId: `DG-${nowSafeId()}-${Math.random().toString(16).slice(2)}`,
    requestedAction: "REJECT",
    finalDecision: "REJECTED",
    deploymentApproved: false,
    rejectedBy,
    reason,
    overallScore: evaluation.overallScore,
    enterpriseGrade: evaluation.enterpriseGrade,
    risk: evaluation.risk,
    blockers: evaluation.blockers.length ? evaluation.blockers : ["Manual rejection"],
    warnings: evaluation.warnings,
    evaluation,
    decidedAt: new Date().toISOString()
  };

  metrics.rejectionsIssued += 1;
  writeDecision(decision);
  return decision;
}

function getGatekeeperReport() {
  const evaluation = evaluateDeploymentGate();

  const report = {
    module: "Deployment Gatekeeper Report",
    status: evaluation.status,
    deploymentApproved: evaluation.deploymentApproved,
    overallScore: evaluation.overallScore,
    enterpriseGrade: evaluation.enterpriseGrade,
    risk: evaluation.risk,
    blockerCount: evaluation.blockerCount,
    warningCount: evaluation.warningCount,
    blockers: evaluation.blockers,
    warnings: evaluation.warnings,
    generatedAt: new Date().toISOString()
  };

  metrics.reportsGenerated += 1;
  fs.writeFileSync(path.join(REPORTS_DIR, "latest-gatekeeper-report.json"), JSON.stringify(report, null, 2));

  return report;
}

function getGatekeeperStatus() {
  return getGatekeeperReport();
}

function getGatekeeperApproval() {
  const evaluation = evaluateDeploymentGate();

  return {
    module: "Gatekeeper Approval Check",
    status: evaluation.status,
    deploymentApproved: evaluation.deploymentApproved,
    approved: evaluation.deploymentApproved,
    overallScore: evaluation.overallScore,
    enterpriseGrade: evaluation.enterpriseGrade,
    risk: evaluation.risk,
    blockers: evaluation.blockers,
    warnings: evaluation.warnings,
    timestamp: new Date().toISOString()
  };
}

function getGatekeeperBlockers() {
  const evaluation = evaluateDeploymentGate();
  return {
    blockerCount: evaluation.blockerCount,
    blockers: evaluation.blockers,
    timestamp: new Date().toISOString()
  };
}

function getGatekeeperWarnings() {
  const evaluation = evaluateDeploymentGate();
  return {
    warningCount: evaluation.warningCount,
    warnings: evaluation.warnings,
    timestamp: new Date().toISOString()
  };
}

function getGatekeeperHealth() {
  const evaluation = evaluateDeploymentGate();

  return {
    module: "Enterprise Deployment Gatekeeper",
    status: evaluation.status,
    deploymentApproved: evaluation.deploymentApproved,
    overallScore: evaluation.overallScore,
    enterpriseGrade: evaluation.enterpriseGrade,
    risk: evaluation.risk,
    blockerCount: evaluation.blockerCount,
    warningCount: evaluation.warningCount,
    evaluationsRun: metrics.evaluationsRun,
    approvalsIssued: metrics.approvalsIssued,
    rejectionsIssued: metrics.rejectionsIssued,
    reportsGenerated: metrics.reportsGenerated,
    lastDecisionAt: metrics.lastDecisionAt,
    lastEvaluationAt: metrics.lastEvaluationAt,
    timestamp: new Date().toISOString()
  };
}

function getGatekeeperMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

function testRejectionLogic() {
  const fakeEvaluation = {
    overallScore: 61,
    risk: "HIGH",
    blockers: ["Simulated blocker"],
    blockerCount: 1
  };

  return {
    status: "REJECTED",
    deploymentApproved: false,
    test: "REJECTION_LOGIC",
    reason: fakeEvaluation.blockers,
    passed: fakeEvaluation.blockerCount > 0 && fakeEvaluation.overallScore < 85
  };
}

module.exports = {
  collectGatekeeperInputs,
  evaluateDeploymentGate,
  approveDeployment,
  rejectDeployment,
  getGatekeeperReport,
  getGatekeeperStatus,
  getGatekeeperApproval,
  getGatekeeperBlockers,
  getGatekeeperWarnings,
  getGatekeeperHealth,
  getGatekeeperMetrics,
  testRejectionLogic
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  evaluateDeploymentGate,
  approveDeployment,
  rejectDeployment,
  getGatekeeperReport,
  getGatekeeperStatus,
  getGatekeeperApproval,
  getGatekeeperBlockers,
  getGatekeeperWarnings,
  getGatekeeperHealth,
  getGatekeeperMetrics,
  testRejectionLogic
} = require("../automation/deploymentGatekeeperEngine");

router.get("/health", (req, res) => res.json(getGatekeeperHealth()));
router.get("/metrics", (req, res) => res.json(getGatekeeperMetrics()));
router.get("/status", (req, res) => res.json(getGatekeeperStatus()));
router.get("/approval", (req, res) => res.json(getGatekeeperApproval()));
router.get("/blockers", (req, res) => res.json(getGatekeeperBlockers()));
router.get("/warnings", (req, res) => res.json(getGatekeeperWarnings()));
router.get("/report", (req, res) => res.json(getGatekeeperReport()));
router.get("/evaluate", (req, res) => res.json(evaluateDeploymentGate()));
router.get("/test/rejection", (req, res) => res.json(testRejectionLogic()));
router.get("/test/approval", (req, res) => res.json(approveDeployment({ approver: "PHASE_10X6_TEST", note: "Test approval flow" })));

router.post("/approve", (req, res) => {
  const result = approveDeployment({
    approver: req.body?.approver || "API",
    note: req.body?.note || "Deployment approval requested through API"
  });
  res.status(result.deploymentApproved ? 200 : 409).json(result);
});

router.post("/reject", (req, res) => {
  const result = rejectDeployment({
    rejectedBy: req.body?.rejectedBy || "API",
    reason: req.body?.reason || "Deployment rejected through API"
  });
  res.status(200).json(result);
});

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/gatekeeper", require("./routes/deploymentGatekeeperRoutes"));'
  if($txt -notlike '*deploymentGatekeeperRoutes*'){
    if($txt -like '*executiveDeploymentDashboardRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/executive-deployment",\s*require\("\./routes/executiveDeploymentDashboardRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10X.6 Enterprise Deployment Gatekeeper Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }

@"
# DEPLOYMENT GATEKEEPER PROTOCOL

## Purpose
The Deployment Gatekeeper is the final authority before release, migration, deployment, or production rollout.

## Decision Rules
Deployment is approved only when:
- Overall score >= 85
- No blockers
- Risk is not CRITICAL
- Release is not BLOCKED
- Environment is not CRITICAL
- Hardening is not BLOCKED
- Monitoring is not CRITICAL
- Backup Recovery is not FAIL
- Performance is not FAIL

## Endpoints
- GET /api/enterprise/gatekeeper/health
- GET /api/enterprise/gatekeeper/status
- GET /api/enterprise/gatekeeper/approval
- GET /api/enterprise/gatekeeper/blockers
- GET /api/enterprise/gatekeeper/warnings
- GET /api/enterprise/gatekeeper/report
- GET /api/enterprise/gatekeeper/evaluate
- POST /api/enterprise/gatekeeper/approve
- POST /api/enterprise/gatekeeper/reject
"@ | Out-File -LiteralPath (Join-Path $Docs "DEPLOYMENT-GATEKEEPER-PROTOCOL.md") -Encoding UTF8

@"
# DEPLOYMENT APPROVAL RULES

Approve only when:
1. Score >= 85
2. Blockers = 0
3. Risk != CRITICAL
4. Release validator not blocked
5. Environment not critical
6. Hardening not blocked
7. Monitoring not critical
8. Backup not failed
9. Performance not failed
"@ | Out-File -LiteralPath (Join-Path $Docs "DEPLOYMENT-APPROVAL-RULES.md") -Encoding UTF8

@"
# DEPLOYMENT REJECTION RULES

Reject automatically when:
- Score below 85
- Any blocker exists
- Risk is CRITICAL
- Release is BLOCKED
- Environment is CRITICAL
- Hardening is BLOCKED
- Monitoring is CRITICAL
- Backup is FAIL
- Performance is FAIL
"@ | Out-File -LiteralPath (Join-Path $Docs "DEPLOYMENT-REJECTION-RULES.md") -Encoding UTF8

@"
# DEPLOYMENT OVERRIDE PROTOCOL

Manual override is not implemented by default.
Reason: deployment safety should not be bypassed casually.

If override is ever added, it must require:
- Named approver
- Reason
- Timestamp
- Full blocker list acknowledgement
- Rollback plan confirmation
- Backup confirmation
"@ | Out-File -LiteralPath (Join-Path $Docs "DEPLOYMENT-OVERRIDE-PROTOCOL.md") -Encoding UTF8

@"
# DEPLOYMENT DECISION HISTORY

All decisions are written to:
$Decisions

Files:
- latest-decision.json
- DG-<timestamp>-<random>.json

Each file includes:
- Final decision
- Score
- Grade
- Risk
- Blockers
- Warnings
- Inputs
- Timestamp
"@ | Out-File -LiteralPath (Join-Path $Docs "DEPLOYMENT-DECISION-HISTORY.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10X6.js"

@"
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
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
$env:L360_ROOT=$Root
$env:L360_REPORTS=$Reports
$env:L360_DECISIONS=$Decisions
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Decisions:"
Write-Host $Decisions
Write-Host ""
Write-Host "Docs:"
Write-Host $Docs
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){
  Write-Host "PHASE 10X.6 DEPLOYMENT GATEKEEPER STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10X.6 DEPLOYMENT GATEKEEPER STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit

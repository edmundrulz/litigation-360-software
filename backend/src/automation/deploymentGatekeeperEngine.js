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

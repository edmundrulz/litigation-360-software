const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const SCORE_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10X4-deployment-scoring-engine");
const DASHBOARD_DIR = path.join(SCORE_ROOT, "dashboards");
const TRENDS_DIR = path.join(SCORE_ROOT, "trends");

fs.mkdirSync(DASHBOARD_DIR, { recursive: true });
fs.mkdirSync(TRENDS_DIR, { recursive: true });

const metrics = {
  reportsGenerated: 0,
  dashboardsGenerated: 0,
  readinessChecksGenerated: 0,
  trendsGenerated: 0,
  lastGeneratedAt: null
};

function safeCall(label, fn, fallback = {}) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, label, ...fallback };
  }
}

function clampScore(value) {
  const n = Number(value);
  if (Number.isNaN(n)) return 0;
  return Math.max(0, Math.min(100, Math.round(n)));
}

function scoreFromStatus(status) {
  const s = String(status || "").toUpperCase();
  if (["READY", "HEALTHY", "PASS", "RELEASE_CANDIDATE_READY"].includes(s)) return 100;
  if (["ATTENTION", "WARNING", "MEDIUM"].includes(s)) return 75;
  if (["HIGH_RISK", "CRITICAL"].includes(s)) return 40;
  if (["BLOCKED", "BLOCKER", "FAIL", "ERROR", "RELEASE_BLOCKED"].includes(s)) return 0;
  return 65;
}

function gradeFromScore(score, blocked) {
  if (blocked) return "FAIL";
  if (score >= 97) return "A+";
  if (score >= 90) return "A";
  if (score >= 80) return "B";
  if (score >= 70) return "C";
  if (score >= 60) return "D";
  return "FAIL";
}

function riskFromScore(score, blockers) {
  if (blockers > 0 || score < 60) return "CRITICAL";
  if (score < 70) return "HIGH";
  if (score < 85) return "MEDIUM";
  return "LOW";
}

function loadArchitectureCriticality() {
  const file = path.join(PROJECT_ROOT, "_operations", "enterprise-architecture", "registries", "criticality-registry.json");
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch {
    return null;
  }
}

function collectScoreInputs() {
  const deploymentCentre = require("./deploymentReadinessCentre");
  const environment = require("./environmentValidationEngine");
  const release = require("./releaseValidatorEngine");
  const monitoring = require("./enterpriseMonitoringEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");
  const performance = require("./performanceOptimizationEngine");

  return {
    deployment: safeCall("deployment", () => deploymentCentre.calculateDeploymentReadiness()),
    environment: safeCall("environment", () => environment.getEnvironmentReadiness()),
    release: safeCall("release", () => release.validateRelease()),
    monitoring: safeCall("monitoring", () => monitoring.getMonitoringHealth()),
    hardening: safeCall("hardening", () => hardening.getDeploymentReadiness()),
    backup: safeCall("backup", () => backup.getBackupRecoveryHealth()),
    performance: safeCall("performance", () => performance.health()),
    architecture: loadArchitectureCriticality()
  };
}

function calculateCategoryScores(inputs) {
  const deploymentScore = clampScore(inputs.deployment.deploymentScore);
  const environmentScore = clampScore(inputs.environment.environmentScore);
  const releaseScore = clampScore(inputs.release.releaseScore);
  const monitoringScore = clampScore(inputs.monitoring.healthScore);
  const hardeningScore = clampScore(inputs.hardening.healthScore);
  const backupScore = scoreFromStatus(inputs.backup.status);
  const performanceScore = scoreFromStatus(inputs.performance.status);
  const architectureScore = inputs.architecture ? 100 : 50;

  return {
    deployment: deploymentScore,
    environment: environmentScore,
    release: releaseScore,
    monitoring: monitoringScore,
    hardening: hardeningScore,
    backupRecovery: backupScore,
    performance: performanceScore,
    architecture: architectureScore,
    operations: clampScore((monitoringScore + backupScore + performanceScore) / 3),
    security: hardeningScore,
    database: inputs.deployment.keyCounts?.databaseTables > 0 || inputs.environment.deploymentReady ? 90 : 60,
    workflow: inputs.architecture?.systemCriticality ? 90 : 70
  };
}

function detectBlockers(inputs, categoryScores) {
  const blockers = [];
  const warnings = [];

  function add(condition, text, severity = "blocker") {
    if (!condition) return;
    if (severity === "warning") warnings.push(text);
    else blockers.push(text);
  }

  add(String(inputs.hardening.status || "").toUpperCase() === "BLOCKED", "Hardening is BLOCKED.");
  add(String(inputs.release.status || "").toUpperCase() === "RELEASE_BLOCKED", "Release validator is BLOCKED.");
  add(String(inputs.environment.risk || "").toUpperCase() === "CRITICAL", "Environment risk is CRITICAL.");
  add(String(inputs.monitoring.status || "").toUpperCase() === "CRITICAL", "Monitoring is CRITICAL.");
  add(String(inputs.backup.status || "").toUpperCase() === "FAIL", "Backup recovery failed.");
  add(String(inputs.performance.status || "").toUpperCase() === "FAIL", "Performance benchmark failed.");

  add(categoryScores.deployment < 75, "Deployment score below 75.", "warning");
  add(categoryScores.environment < 75, "Environment score below 75.", "warning");
  add(categoryScores.release < 75, "Release score below 75.", "warning");
  add(categoryScores.architecture < 80, "Architecture registry incomplete.", "warning");

  return { blockers, warnings };
}

function calculateOverallScore(categoryScores) {
  const weights = {
    deployment: 18,
    environment: 12,
    release: 18,
    monitoring: 10,
    hardening: 14,
    backupRecovery: 8,
    performance: 8,
    architecture: 7,
    workflow: 5
  };

  let weighted = 0;
  let total = 0;

  for (const [key, weight] of Object.entries(weights)) {
    weighted += clampScore(categoryScores[key]) * weight;
    total += weight;
  }

  return clampScore(weighted / Math.max(1, total));
}

function generateScoringReport() {
  const inputs = collectScoreInputs();
  const categoryScores = calculateCategoryScores(inputs);
  const { blockers, warnings } = detectBlockers(inputs, categoryScores);
  const overallScore = calculateOverallScore(categoryScores);
  const risk = riskFromScore(overallScore, blockers.length);
  const enterpriseGrade = gradeFromScore(overallScore, blockers.length > 0);
  const deploymentReady = overallScore >= 85 && blockers.length === 0;
  const releaseApproved = deploymentReady && String(inputs.release.status).toUpperCase() === "RELEASE_CANDIDATE_READY";

  metrics.reportsGenerated += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  const report = {
    module: "Deployment Scoring Engine",
    status: deploymentReady ? "READY" : "NOT_READY",
    deploymentReady,
    enterpriseReady: deploymentReady,
    releaseApproved,
    overallScore,
    enterpriseGrade,
    risk,
    categoryScores,
    blockers,
    blockerCount: blockers.length,
    warnings,
    warningCount: warnings.length,
    inputs,
    generatedAt: metrics.lastGeneratedAt
  };

  fs.writeFileSync(path.join(DASHBOARD_DIR, "latest-deployment-scoring-report.json"), JSON.stringify(report, null, 2));
  writeTrend(report);

  return report;
}

function writeTrend(report) {
  const latestFile = path.join(TRENDS_DIR, "latest-score.json");
  let previous = null;

  try {
    previous = JSON.parse(fs.readFileSync(latestFile, "utf8"));
  } catch {}

  const trend = {
    timestamp: report.generatedAt,
    currentScore: report.overallScore,
    previousScore: previous ? previous.currentScore : null,
    change: previous ? report.overallScore - previous.currentScore : 0,
    direction: !previous ? "BASELINE" : report.overallScore > previous.currentScore ? "IMPROVING" : report.overallScore < previous.currentScore ? "DECLINING" : "STABLE",
    grade: report.enterpriseGrade,
    risk: report.risk
  };

  fs.writeFileSync(path.join(TRENDS_DIR, `score-${report.generatedAt.replace(/[:.]/g, "-")}.json`), JSON.stringify(trend, null, 2));
  fs.writeFileSync(latestFile, JSON.stringify(trend, null, 2));

  return trend;
}

function getScoringDashboard() {
  const report = generateScoringReport();
  metrics.dashboardsGenerated += 1;

  return {
    module: "Enterprise Deployment Scoring Dashboard",
    status: report.status,
    overallScore: report.overallScore,
    enterpriseGrade: report.enterpriseGrade,
    risk: report.risk,
    deploymentReady: report.deploymentReady,
    releaseApproved: report.releaseApproved,
    categoryScores: report.categoryScores,
    blockers: report.blockers,
    warnings: report.warnings,
    generatedAt: new Date().toISOString()
  };
}

function getScoringReadiness() {
  const report = generateScoringReport();
  metrics.readinessChecksGenerated += 1;

  return {
    module: "Scoring Readiness",
    status: report.deploymentReady ? "READY" : "BLOCKED",
    deploymentReady: report.deploymentReady,
    releaseApproved: report.releaseApproved,
    overallScore: report.overallScore,
    enterpriseGrade: report.enterpriseGrade,
    risk: report.risk,
    blockerCount: report.blockerCount,
    warningCount: report.warningCount,
    timestamp: new Date().toISOString()
  };
}

function getEnterpriseGrade() {
  const report = generateScoringReport();
  return {
    module: "Enterprise Grade Engine",
    grade: report.enterpriseGrade,
    overallScore: report.overallScore,
    risk: report.risk,
    deploymentReady: report.deploymentReady,
    timestamp: new Date().toISOString()
  };
}

function getTrends() {
  metrics.trendsGenerated += 1;
  const latest = path.join(TRENDS_DIR, "latest-score.json");
  try {
    return JSON.parse(fs.readFileSync(latest, "utf8"));
  } catch {
    const report = generateScoringReport();
    return writeTrend(report);
  }
}

function getScoringHealth() {
  const readiness = getScoringReadiness();

  return {
    module: "Deployment Scoring Engine",
    status: readiness.status,
    overallScore: readiness.overallScore,
    enterpriseGrade: readiness.enterpriseGrade,
    risk: readiness.risk,
    deploymentReady: readiness.deploymentReady,
    releaseApproved: readiness.releaseApproved,
    reportsGenerated: metrics.reportsGenerated,
    dashboardsGenerated: metrics.dashboardsGenerated,
    readinessChecksGenerated: metrics.readinessChecksGenerated,
    trendsGenerated: metrics.trendsGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getScoringMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  collectScoreInputs,
  calculateCategoryScores,
  generateScoringReport,
  getScoringDashboard,
  getScoringReadiness,
  getEnterpriseGrade,
  getTrends,
  getScoringHealth,
  getScoringMetrics
};

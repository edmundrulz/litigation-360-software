const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const DASHBOARD_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X5-executive-deployment-dashboard", "dashboards");
fs.mkdirSync(DASHBOARD_DIR, { recursive: true });

const metrics = {
  dashboardsGenerated: 0,
  summariesGenerated: 0,
  lastGeneratedAt: null
};

function safeCall(name, fn) {
  try {
    return fn();
  } catch (err) {
    return { status: "ERROR", error: err.message, name };
  }
}

function generateExecutiveDeploymentDashboard() {
  const scoring = require("./deploymentScoringEngine");
  const deployment = require("./deploymentReadinessCentre");
  const environment = require("./environmentValidationEngine");
  const release = require("./releaseValidatorEngine");
  const monitoring = require("./enterpriseMonitoringEngine");
  const performance = require("./performanceOptimizationEngine");

  const scoringReport = safeCall("scoring", () => scoring.generateScoringReport());
  const scoringReadiness = safeCall("scoringReadiness", () => scoring.getScoringReadiness());
  const deploymentReadiness = safeCall("deployment", () => deployment.calculateDeploymentReadiness());
  const environmentReadiness = safeCall("environment", () => environment.getEnvironmentReadiness());
  const releaseValidation = safeCall("release", () => release.validateRelease());
  const monitoringHealth = safeCall("monitoring", () => monitoring.getMonitoringHealth());
  const performanceHealth = safeCall("performance", () => performance.health());

  const approvalStatus =
    scoringReadiness.deploymentReady && scoringReport.releaseApproved
      ? "APPROVED_FOR_DEPLOYMENT"
      : "NOT_APPROVED";

  const executiveSummary = {
    deploymentStatus: scoringReadiness.status,
    approvalStatus,
    overallScore: scoringReport.overallScore,
    enterpriseGrade: scoringReport.enterpriseGrade,
    risk: scoringReport.risk,
    deploymentReady: scoringReadiness.deploymentReady,
    releaseApproved: scoringReport.releaseApproved,
    blockers: scoringReport.blockerCount || 0,
    warnings: scoringReport.warningCount || 0,
    plainEnglish: approvalStatus === "APPROVED_FOR_DEPLOYMENT"
      ? `Deployment approved. Score ${scoringReport.overallScore}. Grade ${scoringReport.enterpriseGrade}. Risk ${scoringReport.risk}.`
      : `Deployment not approved. Score ${scoringReport.overallScore}. Grade ${scoringReport.enterpriseGrade}. Blockers ${scoringReport.blockerCount}.`
  };

  const dashboard = {
    module: "Executive Deployment Dashboard",
    status: approvalStatus,
    executiveSummary,
    panels: {
      scoring: scoringReport,
      scoringReadiness,
      deploymentReadiness,
      environmentReadiness,
      releaseValidation,
      monitoringHealth,
      performanceHealth,
      specialOperations: {
        industrialCourtKualaLumpur: "MONITORED",
        perkesoKualaLumpur: "MONITORED",
        perkesoHeadquartersJalanAmpang: "MONITORED",
        mapsIntegration: "MONITORED",
        courtNavigation: "MONITORED"
      }
    },
    generatedAt: new Date().toISOString()
  };

  metrics.dashboardsGenerated += 1;
  metrics.lastGeneratedAt = dashboard.generatedAt;

  fs.writeFileSync(path.join(DASHBOARD_DIR, "latest-executive-deployment-dashboard.json"), JSON.stringify(dashboard, null, 2));
  return dashboard;
}

function getExecutiveDeploymentSummary() {
  const dashboard = generateExecutiveDeploymentDashboard();
  metrics.summariesGenerated += 1;

  return {
    module: "Executive Deployment Summary",
    status: dashboard.status,
    ...dashboard.executiveSummary,
    generatedAt: new Date().toISOString()
  };
}

function getExecutiveDeploymentHealth() {
  const summary = getExecutiveDeploymentSummary();

  return {
    module: "Executive Deployment Dashboard Engine",
    status: summary.status,
    overallScore: summary.overallScore,
    enterpriseGrade: summary.enterpriseGrade,
    risk: summary.risk,
    deploymentReady: summary.deploymentReady,
    releaseApproved: summary.releaseApproved,
    dashboardsGenerated: metrics.dashboardsGenerated,
    summariesGenerated: metrics.summariesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getExecutiveDeploymentMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  generateExecutiveDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getExecutiveDeploymentHealth,
  getExecutiveDeploymentMetrics
};

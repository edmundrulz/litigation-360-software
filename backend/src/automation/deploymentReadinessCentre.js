const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BASELINE_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X0-deployment-readiness-baseline-audit", "registries");
const OUTPUT_DIR = path.join(PROJECT_ROOT, "_operations", "phase-10X1-deployment-readiness-centre", "dashboards");

fs.mkdirSync(OUTPUT_DIR, { recursive: true });

const metrics = {
  readinessChecksRun: 0,
  dashboardsGenerated: 0,
  executiveSummariesGenerated: 0,
  lastGeneratedAt: null
};

function readJson(file) {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch (err) {
    return null;
  }
}

function loadBaseline() {
  const files = {
    backend: "_backend_inventory.json",
    frontend: "_frontend_inventory.json",
    routes: "_route_registry.json",
    enterprise: "_enterprise_registry.json",
    database: "_database_registry.json",
    deployment: "_deployment_registry.json",
    master: "_master_baseline_registry.json"
  };

  const loaded = {};
  for (const [key, file] of Object.entries(files)) {
    loaded[key] = readJson(path.join(BASELINE_DIR, file));
  }

  return loaded;
}

function scoreSection(name, checks, weight) {
  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;
  const score = Math.round((passed / Math.max(1, checks.length)) * 100);

  return {
    name,
    weight,
    status: failed === 0 ? "PASS" : "FAIL",
    score,
    passed,
    failed,
    checks
  };
}

function calculateDeploymentReadiness() {
  const baseline = loadBaseline();

  const backend = baseline.backend || {};
  const frontend = baseline.frontend || {};
  const routes = baseline.routes || {};
  const enterprise = baseline.enterprise || {};
  const database = baseline.database || {};
  const deployment = baseline.deployment || {};

  const sections = [
    scoreSection("Backend", [
      { name: "Backend inventory exists", pass: !!baseline.backend },
      { name: "Backend files discovered", pass: (backend.totals?.files || 0) > 0 },
      { name: "Automation files discovered", pass: (backend.totals?.automationFiles || 0) > 0 },
      { name: "Route files discovered", pass: (backend.totals?.routeFiles || 0) > 0 }
    ], 15),

    scoreSection("Frontend", [
      { name: "Frontend inventory exists", pass: !!baseline.frontend },
      { name: "Frontend files discovered", pass: (frontend.totals?.files || 0) > 0 },
      { name: "Frontend enterprise files discovered", pass: (frontend.totals?.enterpriseFiles || 0) > 0 },
      { name: "Frontend dist exists", pass: deployment.frontend?.distExists === true }
    ], 15),

    scoreSection("Routes", [
      { name: "Route registry exists", pass: !!baseline.routes },
      { name: "Route mounts discovered", pass: (routes.totals?.mounts || 0) > 0 },
      { name: "Enterprise route mounts discovered", pass: (routes.mounts || []).some(m => String(m.basePath).includes("/api/enterprise")) },
      { name: "Extracted routes discovered", pass: (routes.totals?.extractedRoutes || 0) > 0 }
    ], 15),

    scoreSection("Enterprise Modules", [
      { name: "Enterprise registry exists", pass: !!baseline.enterprise },
      { name: "At least 15 expected enterprise modules exist", pass: (enterprise.totals?.existingExpectedModules || 0) >= 15 },
      { name: "All expected enterprise modules exist", pass: (enterprise.totals?.existingExpectedModules || 0) === (enterprise.totals?.expectedModules || 999) },
      { name: "Automation inventory exists", pass: (enterprise.totals?.automationFiles || 0) > 0 }
    ], 20),

    scoreSection("Database", [
      { name: "Database registry exists", pass: !!baseline.database },
      { name: "Database exists", pass: database.databaseExists === true },
      { name: "Database non-zero size", pass: (database.databaseSizeBytes || 0) > 0 },
      { name: "Database tables detected or sqlite fallback recorded", pass: (database.totals?.tables || 0) > 0 || database.sqliteAvailable === false }
    ], 15),

    scoreSection("Environment", [
      { name: "Deployment registry exists", pass: !!baseline.deployment },
      { name: "Node version detected", pass: !!deployment.environment?.nodeVersion },
      { name: "NPM version detected", pass: !!deployment.environment?.npmVersion },
      { name: "Backend package exists", pass: deployment.backend?.packageExists === true },
      { name: "Frontend package exists", pass: deployment.frontend?.packageExists === true }
    ], 10),

    scoreSection("Build & Release", [
      { name: "Frontend build script exists", pass: !!deployment.frontend?.scripts?.build },
      { name: "Frontend dev script exists", pass: !!deployment.frontend?.scripts?.dev },
      { name: "Backend scripts exist", pass: Object.keys(deployment.backend?.scripts || {}).length > 0 },
      { name: "Default backend port registered", pass: deployment.ports?.backendDefault === 5000 }
    ], 10)
  ];

  let weighted = 0;
  let totalWeight = 0;
  for (const section of sections) {
    weighted += section.score * section.weight;
    totalWeight += section.weight;
  }

  const deploymentScore = Math.round(weighted / Math.max(1, totalWeight));

  const blockingIssues = [];
  const warnings = [];

  for (const section of sections) {
    for (const check of section.checks) {
      if (!check.pass) {
        if (section.weight >= 15) blockingIssues.push(`${section.name}: ${check.name}`);
        else warnings.push(`${section.name}: ${check.name}`);
      }
    }
  }

  const riskLevel =
    deploymentScore >= 90 && blockingIssues.length === 0 ? "LOW" :
    deploymentScore >= 75 ? "MEDIUM" :
    deploymentScore >= 50 ? "HIGH" :
    "CRITICAL";

  const deploymentReady = deploymentScore >= 85 && blockingIssues.length === 0;

  metrics.readinessChecksRun += 1;
  metrics.lastGeneratedAt = new Date().toISOString();

  return {
    module: "Enterprise Deployment Readiness Centre",
    status: deploymentReady ? "READY" : "BLOCKED",
    deploymentReady,
    deploymentScore,
    riskLevel,
    blockingIssues,
    blockingIssuesCount: blockingIssues.length,
    warnings,
    warningsCount: warnings.length,
    sections,
    keyCounts: {
      backendFiles: backend.totals?.files || 0,
      frontendFiles: frontend.totals?.files || 0,
      routeMounts: routes.totals?.mounts || 0,
      extractedRoutes: routes.totals?.extractedRoutes || 0,
      expectedEnterpriseModules: enterprise.totals?.expectedModules || 0,
      existingEnterpriseModules: enterprise.totals?.existingExpectedModules || 0,
      databaseTables: database.totals?.tables || 0,
      databaseIndexes: database.totals?.indexes || 0
    },
    generatedAt: metrics.lastGeneratedAt
  };
}

function getDeploymentDashboard() {
  const readiness = calculateDeploymentReadiness();
  metrics.dashboardsGenerated += 1;

  const dashboard = {
    module: "Deployment Readiness Dashboard",
    generatedAt: new Date().toISOString(),
    summary: {
      status: readiness.status,
      deploymentReady: readiness.deploymentReady,
      deploymentScore: readiness.deploymentScore,
      riskLevel: readiness.riskLevel,
      blockingIssues: readiness.blockingIssuesCount,
      warnings: readiness.warningsCount
    },
    readiness
  };

  fs.writeFileSync(path.join(OUTPUT_DIR, "latest-deployment-readiness-dashboard.json"), JSON.stringify(dashboard, null, 2));
  return dashboard;
}

function getExecutiveDeploymentSummary() {
  const readiness = calculateDeploymentReadiness();
  metrics.executiveSummariesGenerated += 1;

  return {
    title: "Litigation 360 Deployment Readiness Executive Summary",
    status: readiness.status,
    deploymentReady: readiness.deploymentReady,
    score: readiness.deploymentScore,
    risk: readiness.riskLevel,
    blockingIssues: readiness.blockingIssuesCount,
    warnings: readiness.warningsCount,
    plainEnglish: readiness.deploymentReady
      ? `Deployment status READY. Score ${readiness.deploymentScore}. Risk ${readiness.riskLevel}.`
      : `Deployment status BLOCKED. Score ${readiness.deploymentScore}. ${readiness.blockingIssuesCount} blocking issue(s) must be resolved.`,
    generatedAt: new Date().toISOString()
  };
}

function getDeploymentCentreHealth() {
  const readiness = calculateDeploymentReadiness();

  return {
    module: "Deployment Readiness Centre",
    status: readiness.status,
    deploymentReady: readiness.deploymentReady,
    deploymentScore: readiness.deploymentScore,
    riskLevel: readiness.riskLevel,
    blockingIssuesCount: readiness.blockingIssuesCount,
    warningsCount: readiness.warningsCount,
    readinessChecksRun: metrics.readinessChecksRun,
    dashboardsGenerated: metrics.dashboardsGenerated,
    executiveSummariesGenerated: metrics.executiveSummariesGenerated,
    lastGeneratedAt: metrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getDeploymentCentreMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = {
  loadBaseline,
  calculateDeploymentReadiness,
  getDeploymentDashboard,
  getExecutiveDeploymentSummary,
  getDeploymentCentreHealth,
  getDeploymentCentreMetrics
};

const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const SRC_ROOT = path.join(PROJECT_ROOT, "backend", "src");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");

const REQUIRED_AUTOMATION_FILES = [
  "handlerRegistry.js",
  "eventBus.js",
  "notificationService.js",
  "workflowEngine.js",
  "documentLifecycleEngine.js",
  "courtOperationsEngine.js",
  "matterIntelligenceEngine.js",
  "executiveCommandCentre.js",
  "legalOperationsAssistant.js",
  "predictiveAnalyticsEngine.js",
  "courtNavigationEngine.js",
  "mapsIntegrationLayer.js",
  "autonomousOperationsEngine.js",
  "enterpriseGovernanceEngine.js"
];

const REQUIRED_ROUTE_FILES = [
  "handlerRoutes.js",
  "eventBusRoutes.js",
  "notificationRoutes.js",
  "workflowRoutes.js",
  "documentLifecycleRoutes.js",
  "courtOperationsRoutes.js",
  "matterIntelligenceRoutes.js",
  "executiveCommandRoutes.js",
  "legalOperationsAssistantRoutes.js",
  "predictiveAnalyticsRoutes.js",
  "courtNavigationRoutes.js",
  "mapsIntegrationRoutes.js",
  "autonomousOperationsRoutes.js",
  "enterpriseGovernanceRoutes.js"
];

const REQUIRED_MOUNTS = [
  "handlerRoutes",
  "eventBusRoutes",
  "notificationRoutes",
  "workflowRoutes",
  "documentLifecycleRoutes",
  "courtOperationsRoutes",
  "matterIntelligenceRoutes",
  "executiveCommandRoutes",
  "legalOperationsAssistantRoutes",
  "predictiveAnalyticsRoutes",
  "courtNavigationRoutes",
  "mapsIntegrationRoutes",
  "autonomousOperationsRoutes",
  "enterpriseGovernanceRoutes"
];

const REQUIRED_DATABASE_FILES = [
  "litigation360.db"
];

const hardeningMetrics = {
  validationsRun: 0,
  readinessChecksRun: 0,
  dashboardsGenerated: 0,
  lastRunAt: null
};

function exists(p) {
  return fs.existsSync(p);
}

function fileSize(p) {
  try {
    return fs.statSync(p).size;
  } catch {
    return 0;
  }
}

function validateConfiguration() {
  const packagePath = path.join(BACKEND_ROOT, "package.json");
  const envPath = path.join(BACKEND_ROOT, ".env");
  const indexPath = path.join(SRC_ROOT, "index.js");

  const checks = [
    { name: "backend package.json exists", pass: exists(packagePath), path: packagePath },
    { name: "backend .env exists", pass: exists(envPath), path: envPath },
    { name: "backend src index.js exists", pass: exists(indexPath), path: indexPath }
  ];

  return resultBlock("Configuration", checks);
}

function validateDatabase() {
  const checks = REQUIRED_DATABASE_FILES.map(file => {
    const p = path.join(BACKEND_ROOT, file);
    return {
      name: `${file} exists and non-zero`,
      pass: exists(p) && fileSize(p) > 0,
      path: p,
      size: fileSize(p)
    };
  });

  return resultBlock("Database Integrity", checks);
}

function validateAutomation() {
  const checks = REQUIRED_AUTOMATION_FILES.map(file => {
    const p = path.join(SRC_ROOT, "automation", file);
    return {
      name: `${file} exists`,
      pass: exists(p),
      path: p
    };
  });

  return resultBlock("Automation Integrity", checks);
}

function validateRoutes() {
  const routeChecks = REQUIRED_ROUTE_FILES.map(file => {
    const p = path.join(SRC_ROOT, "routes", file);
    return {
      name: `${file} exists`,
      pass: exists(p),
      path: p
    };
  });

  const indexPath = path.join(SRC_ROOT, "index.js");
  const indexText = exists(indexPath) ? fs.readFileSync(indexPath, "utf8") : "";

  const mountChecks = REQUIRED_MOUNTS.map(mount => ({
    name: `${mount} mounted in index.js`,
    pass: indexText.includes(mount),
    path: indexPath
  }));

  return resultBlock("Route Integrity", [...routeChecks, ...mountChecks]);
}

function validateSecurity() {
  const checks = [
    {
      name: "authentication route exists",
      pass: exists(path.join(SRC_ROOT, "routes", "auth.js")) || exists(path.join(SRC_ROOT, "routes", "sqliteAuth.js"))
    },
    {
      name: "middleware folder exists",
      pass: exists(path.join(SRC_ROOT, "middleware"))
    },
    {
      name: ".env file exists",
      pass: exists(path.join(BACKEND_ROOT, ".env"))
    },
    {
      name: "governance engine exists",
      pass: exists(path.join(SRC_ROOT, "automation", "enterpriseGovernanceEngine.js"))
    }
  ];

  return resultBlock("Security Validation", checks);
}

function validatePerformance() {
  const nodeModules = path.join(BACKEND_ROOT, "node_modules");
  const packageLock = path.join(BACKEND_ROOT, "package-lock.json");

  const checks = [
    { name: "node_modules exists", pass: exists(nodeModules), path: nodeModules },
    { name: "package-lock exists", pass: exists(packageLock), path: packageLock },
    { name: "backend source folder exists", pass: exists(SRC_ROOT), path: SRC_ROOT }
  ];

  return resultBlock("Performance Baseline", checks);
}

function validateStartup() {
  const modules = [
    "handlerRegistry",
    "eventBus",
    "notificationService",
    "workflowEngine",
    "documentLifecycleEngine",
    "courtOperationsEngine",
    "matterIntelligenceEngine",
    "executiveCommandCentre",
    "legalOperationsAssistant",
    "predictiveAnalyticsEngine",
    "courtNavigationEngine",
    "mapsIntegrationLayer",
    "autonomousOperationsEngine",
    "enterpriseGovernanceEngine"
  ];

  const checks = modules.map(moduleName => {
    try {
      require(path.join(SRC_ROOT, "automation", moduleName));
      return { name: `${moduleName} loads`, pass: true };
    } catch (err) {
      return { name: `${moduleName} loads`, pass: false, error: err.message };
    }
  });

  return resultBlock("Startup Validation", checks);
}

function resultBlock(name, checks) {
  const passed = checks.filter(c => c.pass).length;
  const failed = checks.length - passed;
  const score = Math.round((passed / Math.max(1, checks.length)) * 100);

  return {
    name,
    status: failed === 0 ? "PASS" : "FAIL",
    score,
    passed,
    failed,
    checks
  };
}

function calculateHealthScore(sections) {
  const weights = {
    "Configuration": 5,
    "Database Integrity": 20,
    "Automation Integrity": 20,
    "Route Integrity": 20,
    "Security Validation": 15,
    "Performance Baseline": 10,
    "Startup Validation": 10
  };

  let total = 0;
  let weightTotal = 0;

  for (const section of sections) {
    const weight = weights[section.name] || 5;
    total += section.score * weight;
    weightTotal += weight;
  }

  return Math.round(total / Math.max(1, weightTotal));
}

function getEnterpriseHardeningDashboard() {
  const sections = [
    validateConfiguration(),
    validateDatabase(),
    validateAutomation(),
    validateRoutes(),
    validateSecurity(),
    validatePerformance(),
    validateStartup()
  ];

  const healthScore = calculateHealthScore(sections);
  const failedSections = sections.filter(s => s.status !== "PASS");
  const blockingIssues = [];

  for (const section of sections) {
    for (const check of section.checks) {
      if (!check.pass) blockingIssues.push(`${section.name}: ${check.name}`);
    }
  }

  const status = blockingIssues.length === 0 ? "READY" : "BLOCKED";

  hardeningMetrics.dashboardsGenerated += 1;
  hardeningMetrics.lastRunAt = new Date().toISOString();

  return {
    module: "Enterprise Hardening & Deployment Readiness",
    status,
    deploymentReady: blockingIssues.length === 0,
    healthScore,
    blockingIssues,
    blockingIssuesCount: blockingIssues.length,
    sections,
    generatedAt: hardeningMetrics.lastRunAt
  };
}

function getDeploymentReadiness() {
  hardeningMetrics.readinessChecksRun += 1;
  const dashboard = getEnterpriseHardeningDashboard();

  return {
    module: "Deployment Readiness Engine",
    status: dashboard.status,
    deploymentReady: dashboard.deploymentReady,
    healthScore: dashboard.healthScore,
    blockingIssues: dashboard.blockingIssues,
    blockingIssuesCount: dashboard.blockingIssuesCount,
    warnings: dashboard.sections.filter(s => s.status !== "PASS").length,
    timestamp: new Date().toISOString()
  };
}

function runFullValidation() {
  hardeningMetrics.validationsRun += 1;
  return getEnterpriseHardeningDashboard();
}

function getEnterpriseHealthScore() {
  const dashboard = getEnterpriseHardeningDashboard();
  return {
    module: "Enterprise Health Score Engine",
    status: dashboard.status,
    healthScore: dashboard.healthScore,
    deploymentReady: dashboard.deploymentReady,
    blockingIssuesCount: dashboard.blockingIssuesCount,
    timestamp: new Date().toISOString()
  };
}

function getHardeningHealth() {
  const readiness = getDeploymentReadiness();

  return {
    module: "Enterprise Hardening Engine",
    status: readiness.status,
    healthScore: readiness.healthScore,
    deploymentReady: readiness.deploymentReady,
    blockingIssuesCount: readiness.blockingIssuesCount,
    validationsRun: hardeningMetrics.validationsRun,
    readinessChecksRun: hardeningMetrics.readinessChecksRun,
    dashboardsGenerated: hardeningMetrics.dashboardsGenerated,
    lastRunAt: hardeningMetrics.lastRunAt,
    timestamp: new Date().toISOString()
  };
}

function getHardeningMetrics() {
  return {
    ...hardeningMetrics,
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  validateConfiguration,
  validateDatabase,
  validateAutomation,
  validateRoutes,
  validateSecurity,
  validatePerformance,
  validateStartup,
  runFullValidation,
  getEnterpriseHardeningDashboard,
  getDeploymentReadiness,
  getEnterpriseHealthScore,
  getHardeningHealth,
  getHardeningMetrics
};


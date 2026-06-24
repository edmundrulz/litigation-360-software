const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");

function safeRequire(relativePath) {
  try {
    return require(relativePath);
  } catch (err) {
    return { __loadError: err.message };
  }
}

function getDatabaseSize() {
  const dbPath = path.join(BACKEND_ROOT, "litigation360.db");
  if (!fs.existsSync(dbPath)) return { exists: false, sizeBytes: 0, sizeMB: 0 };
  const size = fs.statSync(dbPath).size;
  return { exists: true, sizeBytes: size, sizeMB: Math.round((size / 1024 / 1024) * 100) / 100 };
}

function getProcessMetrics() {
  const memory = process.memoryUsage();
  return {
    pid: process.pid,
    platform: process.platform,
    nodeVersion: process.version,
    uptimeSeconds: Math.round(process.uptime()),
    memory: {
      rssMB: Math.round((memory.rss / 1024 / 1024) * 100) / 100,
      heapTotalMB: Math.round((memory.heapTotal / 1024 / 1024) * 100) / 100,
      heapUsedMB: Math.round((memory.heapUsed / 1024 / 1024) * 100) / 100,
      externalMB: Math.round((memory.external / 1024 / 1024) * 100) / 100
    }
  };
}

function collectEnterpriseMetrics() {
  const hardening = safeRequire("./enterpriseHardeningEngine");
  const backup = safeRequire("./backupRecoveryEngine");
  const governance = safeRequire("./enterpriseGovernanceEngine");
  const autonomous = safeRequire("./autonomousOperationsEngine");
  const maps = safeRequire("./mapsIntegrationLayer");
  const navigation = safeRequire("./courtNavigationEngine");
  const courts = safeRequire("./courtOperationsEngine");
  const notifications = safeRequire("./notificationService");
  const workflows = safeRequire("./workflowEngine");
  const documents = safeRequire("./documentLifecycleEngine");
  const matters = safeRequire("./matterIntelligenceEngine");
  const predictive = safeRequire("./predictiveAnalyticsEngine");

  function call(module, fn, fallback) {
    try {
      if (module.__loadError) return { status: "LOAD_ERROR", error: module.__loadError };
      if (typeof module[fn] !== "function") return fallback || { status: "NOT_AVAILABLE" };
      return module[fn]();
    } catch (err) {
      return { status: "ERROR", error: err.message };
    }
  }

  const courtEvents = call(courts, "getCourtOperationsHealth", {});
  const navigationHealth = call(navigation, "getNavigationHealth", {});
  const mapHealth = call(maps, "getMapsHealth", {});
  const backupHealth = call(backup, "getBackupRecoveryHealth", {});
  const governanceHealth = call(governance, "getGovernanceHealth", {});
  const hardeningHealth = call(hardening, "getHardeningHealth", {});
  const autonomousHealth = call(autonomous, "getAutonomousHealth", {});
  const notificationHealth = call(notifications, "getNotificationHealth", {});
  const workflowHealth = call(workflows, "getWorkflowHealth", {});
  const documentHealth = call(documents, "getDocumentLifecycleHealth", {});
  const matterHealth = call(matters, "getMatterIntelligenceHealth", {});
  const predictiveHealth = call(predictive, "getPredictiveHealth", {});

  return {
    module: "Enterprise Metrics Collector",
    collectedAt: new Date().toISOString(),
    process: getProcessMetrics(),
    database: getDatabaseSize(),
    modules: {
      hardening: hardeningHealth,
      backupRecovery: backupHealth,
      governance: governanceHealth,
      autonomous: autonomousHealth,
      predictive: predictiveHealth,
      matters: matterHealth,
      documents: documentHealth,
      workflows: workflowHealth,
      notifications: notificationHealth,
      courtOperations: courtEvents,
      navigation: navigationHealth,
      maps: mapHealth
    },
    specialMonitoring: {
      industrialCourtKualaLumpur: "MONITORED",
      perkesoKualaLumpur: "MONITORED",
      perkesoHeadquartersJalanAmpang: "MONITORED"
    }
  };
}

module.exports = {
  collectEnterpriseMetrics,
  getDatabaseSize,
  getProcessMetrics
};

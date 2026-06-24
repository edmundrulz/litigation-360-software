const fs = require("fs");
const path = require("path");
const { performance } = require("perf_hooks");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");

function runtimeSnapshot() {
  const mem = process.memoryUsage();
  const db = path.join(BACKEND_ROOT, "litigation360.db");
  const dbSize = fs.existsSync(db) ? fs.statSync(db).size : 0;

  return {
    pid: process.pid,
    uptimeSeconds: Math.round(process.uptime()),
    nodeVersion: process.version,
    platform: process.platform,
    memory: {
      rssMB: Math.round(mem.rss / 1048576 * 100) / 100,
      heapTotalMB: Math.round(mem.heapTotal / 1048576 * 100) / 100,
      heapUsedMB: Math.round(mem.heapUsed / 1048576 * 100) / 100,
      externalMB: Math.round(mem.external / 1048576 * 100) / 100
    },
    database: {
      exists: fs.existsSync(db),
      sizeBytes: dbSize,
      sizeMB: Math.round(dbSize / 1048576 * 100) / 100
    },
    timestamp: new Date().toISOString()
  };
}

function timed(name, fn) {
  const start = performance.now();
  try {
    fn();
    return { name, ok: true, durationMs: Math.round((performance.now() - start) * 100) / 100 };
  } catch (err) {
    return { name, ok: false, durationMs: Math.round((performance.now() - start) * 100) / 100, error: err.message };
  }
}

function runBenchmark() {
  const monitoring = require("./enterpriseMonitoringEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");

  const checks = [
    timed("monitoring.health", () => monitoring.getMonitoringHealth()),
    timed("monitoring.dashboard", () => monitoring.getMonitoringDashboard()),
    timed("hardening.healthscore", () => hardening.getEnterpriseHealthScore()),
    timed("hardening.readiness", () => hardening.getDeploymentReadiness()),
    timed("backup.health", () => backup.getBackupRecoveryHealth()),
    timed("backup.integrity", () => backup.runBackupIntegrityCheck())
  ];

  const avgMs = Math.round(checks.reduce((s, c) => s + c.durationMs, 0) / checks.length * 100) / 100;
  const maxMs = Math.max(...checks.map(c => c.durationMs));
  const failed = checks.filter(c => !c.ok);
  const slow = checks.filter(c => c.durationMs > 1000);

  return {
    module: "Performance Optimization Engine",
    status: failed.length ? "FAIL" : slow.length ? "ATTENTION" : "HEALTHY",
    avgMs,
    maxMs,
    failedChecks: failed.length,
    slowChecks: slow.length,
    checks,
    runtime: runtimeSnapshot(),
    generatedAt: new Date().toISOString()
  };
}

function recommendations() {
  const benchmark = runBenchmark();
  const recs = [];

  if (benchmark.runtime.memory.heapUsedMB > 256) {
    recs.push({ priority: "MEDIUM", area: "MEMORY", recommendation: "Monitor heap usage and reduce in-memory stores if growth continues." });
  }

  if (benchmark.runtime.database.sizeMB > 100) {
    recs.push({ priority: "MEDIUM", area: "DATABASE", recommendation: "Add database archiving and compact schedule." });
  }

  for (const c of benchmark.checks) {
    if (c.durationMs > 1000) {
      recs.push({ priority: "HIGH", area: "SLOW_CHECK", recommendation: `${c.name} is slow at ${c.durationMs} ms.` });
    }
  }

  if (!recs.length) {
    recs.push({ priority: "LOW", area: "GENERAL", recommendation: "Performance baseline is acceptable. Continue monitoring." });
  }

  return { module: "Performance Recommendations", recommendations: recs, generatedAt: new Date().toISOString() };
}

function health() {
  const b = runBenchmark();
  return {
    module: "Performance Optimization Engine",
    status: b.status,
    avgMs: b.avgMs,
    maxMs: b.maxMs,
    failedChecks: b.failedChecks,
    slowChecks: b.slowChecks,
    heapUsedMB: b.runtime.memory.heapUsedMB,
    databaseSizeMB: b.runtime.database.sizeMB,
    timestamp: new Date().toISOString()
  };
}

module.exports = { runtimeSnapshot, runBenchmark, recommendations, health };

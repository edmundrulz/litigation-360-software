const { performance } = require("perf_hooks");

const metrics = { testsRun: 0, totalIterations: 0, lastRunAt: null };

function runLoadTest({ iterations = 10 } = {}) {
  const monitoring = require("./enterpriseMonitoringEngine");
  const hardening = require("./enterpriseHardeningEngine");
  const backup = require("./backupRecoveryEngine");

  const count = Math.max(1, Math.min(Number(iterations || 10), 100));
  const results = [];
  const allStart = performance.now();

  for (let i = 0; i < count; i++) {
    const start = performance.now();
    let ok = true;
    let error = null;

    try {
      monitoring.getMonitoringHealth();
      hardening.getEnterpriseHealthScore();
      backup.getBackupRecoveryHealth();
    } catch (err) {
      ok = false;
      error = err.message;
    }

    results.push({
      iteration: i + 1,
      ok,
      durationMs: Math.round((performance.now() - start) * 100) / 100,
      error
    });
  }

  const durations = results.map(r => r.durationMs);
  const failed = results.filter(r => !r.ok);

  metrics.testsRun += 1;
  metrics.totalIterations += count;
  metrics.lastRunAt = new Date().toISOString();

  return {
    module: "Load Testing Engine",
    status: failed.length ? "FAIL" : Math.max(...durations) > 1500 ? "ATTENTION" : "PASS",
    iterations: count,
    failedIterations: failed.length,
    avgMs: Math.round(durations.reduce((a, b) => a + b, 0) / durations.length * 100) / 100,
    minMs: Math.min(...durations),
    maxMs: Math.max(...durations),
    totalDurationMs: Math.round((performance.now() - allStart) * 100) / 100,
    results,
    generatedAt: metrics.lastRunAt
  };
}

function health() {
  return { module: "Load Testing Engine", status: "HEALTHY", ...metrics, timestamp: new Date().toISOString() };
}

function getMetrics() {
  return { ...metrics, timestamp: new Date().toISOString() };
}

module.exports = { runLoadTest, health, getMetrics };

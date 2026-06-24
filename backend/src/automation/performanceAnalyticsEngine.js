function nowIso() { return new Date().toISOString(); }

const PERFORMANCE_PARAMETERS = {
  backendLatencyMs: { good: 250, watch: 750, critical: 1500 },
  frontendLoadMs: { good: 1000, watch: 2500, critical: 5000 },
  memoryUsagePercent: { good: 70, watch: 85, critical: 95 },
  errorRatePercent: { good: 1, watch: 3, critical: 5 },
  uptimePercent: { good: 99, watch: 95, critical: 90 }
};

function classifyLowerIsBetter(value, thresholds) {
  if (value <= thresholds.good) return "GOOD";
  if (value <= thresholds.watch) return "WATCH";
  if (value <= thresholds.critical) return "DEGRADED";
  return "CRITICAL";
}

function classifyHigherIsBetter(value, thresholds) {
  if (value >= thresholds.good) return "GOOD";
  if (value >= thresholds.watch) return "WATCH";
  if (value >= thresholds.critical) return "DEGRADED";
  return "CRITICAL";
}

function analyzePerformance(input = {}) {
  const data = {
    backendLatencyMs: Number(input.backendLatencyMs || 120),
    frontendLoadMs: Number(input.frontendLoadMs || 900),
    memoryUsagePercent: Number(input.memoryUsagePercent || 45),
    errorRatePercent: Number(input.errorRatePercent || 0),
    uptimePercent: Number(input.uptimePercent || 100)
  };

  return {
    generatedAt: nowIso(),
    parameters: PERFORMANCE_PARAMETERS,
    data,
    results: {
      backendLatency: classifyLowerIsBetter(data.backendLatencyMs, PERFORMANCE_PARAMETERS.backendLatencyMs),
      frontendLoad: classifyLowerIsBetter(data.frontendLoadMs, PERFORMANCE_PARAMETERS.frontendLoadMs),
      memoryUsage: classifyLowerIsBetter(data.memoryUsagePercent, PERFORMANCE_PARAMETERS.memoryUsagePercent),
      errorRate: classifyLowerIsBetter(data.errorRatePercent, PERFORMANCE_PARAMETERS.errorRatePercent),
      uptime: classifyHigherIsBetter(data.uptimePercent, PERFORMANCE_PARAMETERS.uptimePercent)
    }
  };
}

module.exports = { PERFORMANCE_PARAMETERS, analyzePerformance };

const express = require("express");
const router = express.Router();
const analyticsEngine = require("../automation/operationsAnalyticsEngine");
const metricsEngine = require("../automation/enterpriseMetricsEngine");
const performanceEngine = require("../automation/performanceAnalyticsEngine");

function safeInput(req) {
  return { ...(req.query || {}), ...(req.body || {}) };
}

router.get("/health", (req, res) => {
  res.json({
    status: "OK",
    phase: "10Z.2",
    service: "Enterprise Operations Analytics Centre",
    timestamp: new Date().toISOString(),
    coverage: {
      industrialCourt: true,
      perkeso: true,
      deployment: true,
      performance: true,
      alerts: true,
      escalations: true
    }
  });
});

router.get("/metrics", (req, res) => {
  const snapshot = analyticsEngine.buildSnapshot(safeInput(req));
  res.json(metricsEngine.buildMetrics(snapshot));
});

router.get("/snapshot", (req, res) => {
  res.json(analyticsEngine.buildSnapshot(safeInput(req)));
});

router.post("/snapshot", (req, res) => {
  const snapshot = analyticsEngine.buildSnapshot(safeInput(req));
  const file = analyticsEngine.writeSnapshot(snapshot);
  res.json({ saved: true, file, snapshot });
});

router.get("/dashboard", (req, res) => {
  res.json(analyticsEngine.buildDashboard(safeInput(req)));
});

router.get("/performance", (req, res) => {
  res.json(performanceEngine.analyzePerformance(safeInput(req)));
});

router.get("/courts", (req, res) => {
  res.json({
    generatedAt: new Date().toISOString(),
    coverage: analyticsEngine.COURT_ANALYTICS_COVERAGE,
    industrialCourtIncluded: analyticsEngine.COURT_ANALYTICS_COVERAGE.some(x => x.includes("Industrial Court")),
    perkesoIncluded: analyticsEngine.COURT_ANALYTICS_COVERAGE.some(x => x.includes("PERKESO")),
    navigationIncluded: analyticsEngine.COURT_ANALYTICS_COVERAGE.some(x => x.includes("Google Maps")) && analyticsEngine.COURT_ANALYTICS_COVERAGE.some(x => x.includes("Waze"))
  });
});

router.get("/deployment", (req, res) => {
  const snapshot = analyticsEngine.buildSnapshot(safeInput(req));
  res.json({
    generatedAt: new Date().toISOString(),
    deploymentReadiness: snapshot.criticalAlertCount === 0 && snapshot.backupFailureCount === 0 && snapshot.deploymentBlockCount === 0,
    gatekeeperClear: snapshot.deploymentBlockCount === 0,
    backupClear: snapshot.backupFailureCount === 0,
    riskScore: snapshot.riskScore,
    recommendations: snapshot.recommendations
  });
});

router.get("/reports", (req, res) => {
  const snapshot = analyticsEngine.buildSnapshot(safeInput(req));
  const evaluation = metricsEngine.evaluateMetrics(snapshot);
  res.json({
    generatedAt: new Date().toISOString(),
    reportName: "10Z.2 Enterprise Operations Analytics Report",
    snapshot,
    evaluation
  });
});

module.exports = router;

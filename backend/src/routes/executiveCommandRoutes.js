const express = require("express");
const router = express.Router();

const {
  generateExecutiveDashboard,
  getExecutiveCommandHealth,
  getExecutiveCommandMetrics
} = require("../automation/executiveCommandCentre");

router.get("/health", (req, res) => res.json(getExecutiveCommandHealth()));
router.get("/metrics", (req, res) => res.json(getExecutiveCommandMetrics()));
router.get("/dashboard", (req, res) => res.json(generateExecutiveDashboard()));
router.get("/summary", (req, res) => {
  const dashboard = generateExecutiveDashboard();
  res.json({
    module: dashboard.module,
    enterpriseStatus: dashboard.enterpriseStatus,
    enterpriseScore: dashboard.enterpriseScore,
    generatedAt: dashboard.generatedAt,
    executiveSummary: dashboard.executiveSummary,
    riskItems: dashboard.riskItems
  });
});
router.get("/risk", (req, res) => {
  const dashboard = generateExecutiveDashboard();
  res.json({ riskItems: dashboard.riskItems, count: dashboard.riskItems.length, timestamp: new Date().toISOString() });
});
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: generateExecutiveDashboard() }));

module.exports = router;

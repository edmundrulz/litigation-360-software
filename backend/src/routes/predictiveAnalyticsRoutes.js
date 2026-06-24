const express = require("express");
const router = express.Router();

const {
  forecastMatter,
  forecastDeadlines,
  forecastWorkload,
  forecastCapacity,
  generatePredictiveDashboard,
  getPredictiveHealth,
  getPredictiveMetrics
} = require("../automation/predictiveAnalyticsEngine");

router.get("/health", (req, res) => res.json(getPredictiveHealth()));
router.get("/metrics", (req, res) => res.json(getPredictiveMetrics()));
router.get("/dashboard", (req, res) => res.json(generatePredictiveDashboard()));
router.get("/matter/:matterId", (req, res) => res.json(forecastMatter(req.params.matterId)));
router.get("/deadlines", (req, res) => res.json(forecastDeadlines()));
router.get("/workload", (req, res) => res.json(forecastWorkload()));
router.get("/capacity", (req, res) => res.json(forecastCapacity()));
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: generatePredictiveDashboard() }));
router.get("/test/matter", (req, res) => res.json({ ok: true, forecast: forecastMatter("MATTER-PHASE-10J-TEST") }));

module.exports = router;

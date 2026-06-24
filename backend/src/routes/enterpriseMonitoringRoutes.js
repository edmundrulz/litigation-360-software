const express = require("express");
const router = express.Router();

const {
  getMonitoringDashboard,
  getMonitoringHealth,
  getMonitoringMetrics,
  getMonitoringReadiness,
  getMonitoringAlerts
} = require("../automation/enterpriseMonitoringEngine");

const { resolveAlert } = require("../automation/alertManager");

router.get("/health", (req, res) => res.json(getMonitoringHealth()));
router.get("/dashboard", (req, res) => res.json(getMonitoringDashboard()));
router.get("/metrics", (req, res) => res.json(getMonitoringMetrics()));
router.get("/alerts", (req, res) => res.json(getMonitoringAlerts()));
router.get("/readiness", (req, res) => res.json(getMonitoringReadiness()));
router.post("/alerts/:id/resolve", (req, res) => {
  const result = resolveAlert(req.params.id, req.body?.note || "Resolved from monitoring API");
  res.status(result.ok ? 200 : 404).json(result);
});
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: getMonitoringDashboard() }));

module.exports = router;

const express = require("express");
const router = express.Router();

const {
  runAutonomousCycle,
  getAutonomousDashboard,
  getAutonomousHealth,
  getAutonomousMetrics,
  getRules,
  getActions,
  getEscalations,
  getDecisions,
  resolveEscalation
} = require("../automation/autonomousOperationsEngine");

router.get("/health", (req, res) => res.json(getAutonomousHealth()));
router.get("/metrics", (req, res) => res.json(getAutonomousMetrics()));
router.get("/dashboard", (req, res) => res.json(getAutonomousDashboard()));
router.get("/rules", (req, res) => res.json({ rules: getRules(), timestamp: new Date().toISOString() }));
router.get("/actions", (req, res) => res.json({ actions: getActions({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.get("/escalations", (req, res) => res.json({ escalations: getEscalations({ status: req.query.status || null }), timestamp: new Date().toISOString() }));
router.get("/decisions", (req, res) => res.json({ decisions: getDecisions(), timestamp: new Date().toISOString() }));

router.post("/run", async (req, res) => {
  const result = await runAutonomousCycle({ executeSafeActions: !!req.body?.executeSafeActions });
  res.json(result);
});

router.get("/test/run", async (req, res) => {
  const result = await runAutonomousCycle({ executeSafeActions: false });
  res.json({ ok: true, result });
});

router.post("/escalations/:id/resolve", (req, res) => {
  const result = resolveEscalation(req.params.id, req.body?.note || "Resolved from API");
  res.status(result.ok ? 200 : 404).json(result);
});

module.exports = router;

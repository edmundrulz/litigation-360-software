const express = require("express");
const router = express.Router();

const {
  registerCourt,
  getCourt,
  listCourts,
  createTravelPlanForCourtEvent,
  checkCourtReadinessForMatter,
  generateNavigationDashboard,
  getNavigationHealth,
  getNavigationMetrics
} = require("../automation/courtNavigationEngine");

router.get("/health", (req, res) => res.json(getNavigationHealth()));
router.get("/metrics", (req, res) => res.json(getNavigationMetrics()));
router.get("/dashboard", (req, res) => res.json(generateNavigationDashboard()));
router.get("/courts", (req, res) => res.json({ courts: listCourts(), timestamp: new Date().toISOString() }));
router.post("/courts", (req, res) => {
  try {
    res.status(201).json({ ok: true, court: registerCourt(req.body || {}) });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});
router.get("/courts/:courtName", (req, res) => {
  const court = getCourt(req.params.courtName);
  res.status(court ? 200 : 404).json(court ? { ok: true, court } : { ok: false, error: "Court not found" });
});
router.get("/travel-plan/:courtEventId", (req, res) => {
  const result = createTravelPlanForCourtEvent(req.params.courtEventId, {
    travelMinutes: req.query.travelMinutes,
    bufferMinutes: req.query.bufferMinutes
  });
  res.status(result.ok ? 200 : 404).json(result);
});
router.get("/readiness/:matterId", (req, res) => res.json({ ok: true, readiness: checkCourtReadinessForMatter(req.params.matterId) }));
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: generateNavigationDashboard() }));
router.get("/test/readiness", (req, res) => res.json({ ok: true, readiness: checkCourtReadinessForMatter("MATTER-PHASE-10K-TEST") }));

module.exports = router;

const express = require("express");
const router = express.Router();

const {
  COURT_EVENT_TYPES,
  createCourtDate,
  startCourtPreparationWorkflow,
  getCourtEventById,
  getCourtEvents,
  getUpcomingCourtEvents,
  getOverdueCourtDeadlines,
  getCourtTasks,
  getCourtOperationsMetrics,
  getCourtOperationsHealth
} = require("../automation/courtOperationsEngine");

router.get("/health", (req, res) => {
  res.json(getCourtOperationsHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getCourtOperationsMetrics());
});

router.get("/event-types", (req, res) => {
  res.json({
    eventTypes: COURT_EVENT_TYPES,
    timestamp: new Date().toISOString()
  });
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);

  res.json({
    courtEvents: getCourtEvents({
      limit,
      matterId: req.query.matterId || null,
      status: req.query.status || null,
      eventType: req.query.eventType || null
    }),
    timestamp: new Date().toISOString()
  });
});

router.get("/upcoming", (req, res) => {
  const days = Number(req.query.days || 30);

  res.json({
    courtEvents: getUpcomingCourtEvents(days),
    days,
    timestamp: new Date().toISOString()
  });
});

router.get("/overdue-deadlines", (req, res) => {
  res.json({
    deadlines: getOverdueCourtDeadlines(),
    timestamp: new Date().toISOString()
  });
});

router.get("/tasks", (req, res) => {
  const limit = Number(req.query.limit || 25);

  res.json({
    tasks: getCourtTasks({
      limit,
      matterId: req.query.matterId || null,
      status: req.query.status || null
    }),
    timestamp: new Date().toISOString()
  });
});

router.get("/:id", (req, res) => {
  const courtEvent = getCourtEventById(req.params.id);

  if (!courtEvent) {
    return res.status(404).json({
      ok: false,
      error: "Court event not found"
    });
  }

  res.json({
    ok: true,
    courtEvent
  });
});

router.post("/create", (req, res) => {
  try {
    const courtEvent = createCourtDate(req.body || {});
    res.status(201).json({
      ok: true,
      courtEvent
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.post("/:id/start-preparation", async (req, res) => {
  const result = await startCourtPreparationWorkflow(req.params.id, req.body?.actor || "API");
  res.status(result.ok ? 200 : 400).json(result);
});

router.get("/test/court-preparation", async (req, res) => {
  const future = new Date();
  future.setDate(future.getDate() + 30);

  const courtEvent = createCourtDate({
    matterId: "MATTER-PHASE-10F-TEST",
    caseTitle: "Phase 10F Test Case",
    courtName: "Shah Alam High Court",
    courtAddress: "Shah Alam, Selangor",
    courtRoom: "Test Court Room",
    eventType: "HEARING",
    eventDate: future.toISOString(),
    eventTime: "09:00",
    assignedTo: "PHASE_10F_TEST",
    notes: "Automated test court event"
  });

  const workflowResult = await startCourtPreparationWorkflow(courtEvent.id, "PHASE_10F_TEST");

  res.json({
    ok: true,
    courtEvent: getCourtEventById(courtEvent.id),
    workflowResult
  });
});

module.exports = router;

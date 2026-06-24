const express = require("express");
const router = express.Router();

const {
  emitEvent,
  getRecentEvents,
  getEventMetrics,
  getEventBusHealth
} = require("../automation/eventBus");

router.get("/health", (req, res) => {
  res.json(getEventBusHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getEventMetrics());
});

router.get("/recent", (req, res) => {
  const limit = Number(req.query.limit || 25);
  res.json({
    events: getRecentEvents(limit),
    timestamp: new Date().toISOString()
  });
});

router.post("/emit", async (req, res) => {
  try {
    const { eventType, payload, context } = req.body || {};
    if (!eventType) {
      return res.status(400).json({ ok: false, error: "eventType is required" });
    }
    const result = await emitEvent(eventType, payload || {}, context || {});
    res.status(result.ok ? 200 : 202).json(result);
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message, timestamp: new Date().toISOString() });
  }
});

router.get("/test/:eventType", async (req, res) => {
  const eventType = req.params.eventType;
  const result = await emitEvent(eventType, {
    source: "eventBusTestEndpoint",
    test: true
  }, {
    route: "/api/enterprise/events/test/:eventType"
  });
  res.status(result.ok ? 200 : 202).json(result);
});

module.exports = router;

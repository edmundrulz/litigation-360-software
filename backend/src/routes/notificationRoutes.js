const express = require("express");
const router = express.Router();

const {
  createNotification,
  markNotificationRead,
  getNotifications,
  getNotificationMetrics,
  getNotificationHealth
} = require("../automation/notificationService");

router.get("/health", (req, res) => {
  res.json(getNotificationHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getNotificationMetrics());
});

router.get("/list", (req, res) => {
  const limit = Number(req.query.limit || 25);
  const unreadOnly = String(req.query.unreadOnly || "false").toLowerCase() === "true";
  const level = req.query.level || null;

  res.json({
    notifications: getNotifications({ limit, unreadOnly, level }),
    timestamp: new Date().toISOString()
  });
});

router.post("/create", (req, res) => {
  try {
    const notification = createNotification(req.body || {});
    res.status(201).json({
      ok: true,
      notification
    });
  } catch (err) {
    res.status(500).json({
      ok: false,
      error: err.message,
      timestamp: new Date().toISOString()
    });
  }
});

router.post("/:id/read", (req, res) => {
  const result = markNotificationRead(req.params.id);
  res.status(result.ok ? 200 : 404).json(result);
});

router.get("/test", (req, res) => {
  const notification = createNotification({
    title: "Phase 10C Test Notification",
    message: "Notification Framework test completed.",
    level: "INFO",
    source: "PHASE_10C_TEST",
    payload: {
      test: true
    }
  });

  res.json({
    ok: true,
    notification
  });
});

router.get("/test-critical", (req, res) => {
  const notification = createNotification({
    title: "Phase 10C Critical Test",
    message: "Critical notification route test completed.",
    level: "CRITICAL",
    source: "PHASE_10C_TEST",
    payload: {
      test: true,
      severity: "critical"
    }
  });

  res.json({
    ok: true,
    notification
  });
});

module.exports = router;

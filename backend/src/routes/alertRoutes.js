const express = require("express");
const router = express.Router();

const alertEngine = require("../automation/alertEngine");
const escalationEngine = require("../automation/escalationEngine");
const notificationEngine = require("../automation/notificationEngine");

router.get("/health", (req, res) => {
  res.json({
    alertEngine: alertEngine.getHealth(),
    escalationEngine: escalationEngine.getHealth(),
    notificationEngine: notificationEngine.getHealth()
  });
});

router.get("/metrics", (req, res) => {
  res.json({
    phase: "10Z.1",
    generatedAt: new Date().toISOString(),
    alerts: alertEngine.getMetrics(),
    escalations: escalationEngine.getMetrics(),
    notifications: notificationEngine.getMetrics()
  });
});

router.get("/open", (req, res) => {
  res.json({
    status: "OK",
    alerts: alertEngine.getOpenAlerts()
  });
});

router.get("/critical", (req, res) => {
  res.json({
    status: "OK",
    alerts: alertEngine.getCriticalAlerts()
  });
});

router.get("/high", (req, res) => {
  res.json({
    status: "OK",
    alerts: alertEngine.getHighAlerts()
  });
});

router.get("/dashboard", (req, res) => {
  res.json({
    ...alertEngine.getDashboard(),
    escalations: escalationEngine.listEscalations(),
    notifications: notificationEngine.listNotifications()
  });
});

router.get("/escalations", (req, res) => {
  res.json({
    status: "OK",
    escalations: escalationEngine.listEscalations()
  });
});

router.get("/notifications", (req, res) => {
  res.json({
    status: "OK",
    notifications: notificationEngine.listNotifications()
  });
});

router.post("/create", (req, res) => {
  const alert = alertEngine.createAlert(req.body || {});
  const notification = notificationEngine.notifyForAlert(alert, "DASHBOARD");

  res.status(201).json({
    status: "CREATED",
    alert,
    notification
  });
});

router.post("/resolve", (req, res) => {
  const result = alertEngine.resolveAlert(req.body.alertId, req.body || {});
  res.json({
    status: result.found ? "RESOLVED" : "NOT_FOUND",
    result
  });
});

router.post("/escalate", (req, res) => {
  const result = escalationEngine.escalateAlert(req.body || {});
  if (result.success) {
    notificationEngine.createNotification({
      alertId: result.escalation.alertId,
      channel: "DASHBOARD",
      recipient: result.escalation.level,
      message: result.escalation.reason
    });
  }

  res.status(result.success ? 200 : 404).json(result);
});

module.exports = router;

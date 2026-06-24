const alertEngine = require("./alertEngine");

const levels = ["OPERATIONS", "MANAGER", "EXECUTIVE", "URGENT"];
const statuses = ["ACTIVE", "COMPLETED", "CANCELLED"];
const escalations = [];

function nextId() {
  return `ESC-${String(escalations.length + 1).padStart(6, "0")}`;
}

function defaultLevelForSeverity(severity) {
  if (severity === "CRITICAL") return "EXECUTIVE";
  if (severity === "HIGH") return "MANAGER";
  return "OPERATIONS";
}

function escalateAlert(input = {}) {
  const alertId = input.alertId;
  const alert = alertEngine.listAlerts().find((item) => item.alertId === alertId);

  if (!alert) {
    return {
      success: false,
      status: "ALERT_NOT_FOUND",
      alertId
    };
  }

  const level = levels.includes(input.level) ? input.level : defaultLevelForSeverity(alert.severity);

  const escalation = {
    escalationId: nextId(),
    alertId,
    level,
    status: "ACTIVE",
    reason: input.reason || `${alert.severity} alert requires ${level.toLowerCase()} attention`,
    createdAt: new Date().toISOString()
  };

  escalations.push(escalation);
  alertEngine.markEscalated(alertId);

  return {
    success: true,
    escalation
  };
}

function listEscalations() {
  return escalations;
}

function getMetrics() {
  return {
    phase: "10Z.1",
    totalEscalations: escalations.length,
    activeEscalations: escalations.filter((item) => item.status === "ACTIVE").length,
    levels,
    statuses,
    generatedAt: new Date().toISOString()
  };
}

function getHealth() {
  return {
    status: "HEALTHY",
    service: "Escalation Engine",
    phase: "10Z.1",
    metrics: getMetrics(),
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  levels,
  statuses,
  escalateAlert,
  listEscalations,
  getMetrics,
  getHealth
};
